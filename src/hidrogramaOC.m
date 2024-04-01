function [cuenca] = hidrogramaOC(cuenca,simulacion)
%% hidrogramaOC
% //    Description:
% //        -Get Kinematic wave hydrograph
% //    Update History
% =============================================================
%
HF2=[];
HF3=[];
HFinal=[];
Runf=zeros(1,3);
subAreas=zeros(1,3);
D=3;
for i=1:D
    n1=60;
    eps=0.000001;
    h1=simulacion.dtEscorrentia;
    
    Final=[0 0 0];
    if i==1
        cuenca.infiltracion=iniciarInfiltracion(cuenca.infiltracion);
        area=cuenca.escorrentia.areaPerm;
        alpha=(cuenca.escorrentia.ancho*cuenca.escorrentia.pendiente^0.5)/(area*cuenca.escorrentia.nPermeable);
        depresionAlm=cuenca.escorrentia.dPermeable/1000;
        subAreas(1)=area;
        cuenca.precipitacionInfiltrada=[];
    elseif i==2
        area=cuenca.escorrentia.areaImp;
        alpha=(cuenca.escorrentia.ancho*cuenca.escorrentia.pendiente^0.5)/((cuenca.escorrentia.areaImp+cuenca.escorrentia.areaSDImp)*cuenca.escorrentia.nImpermeable);
        depresionAlm=cuenca.escorrentia.dImpermeable/1000;
        subAreas(2)=area;    
    elseif i==3
        area=cuenca.escorrentia.areaSDImp;
        alpha=(cuenca.escorrentia.ancho*cuenca.escorrentia.pendiente^0.5)/((cuenca.escorrentia.areaImp+cuenca.escorrentia.areaSDImp)*cuenca.escorrentia.nImpermeable);
        depresionAlm=0;
        subAreas(3)=area;
    end
     
    for j=1:size(cuenca.hietogramaTotal,1)-1
        yini=Final(end,3);
        if i==1
            cuenca= estimarInfiltracion(cuenca,cuenca.hietogramaTotal(j,2),yini,cuenca.hietogramaTotal(j+1,1)-cuenca.hietogramaTotal(j,1));
            cuenca.f=cuenca.infiltracion.f;
        elseif i==4 && simulacion.incluirSUDS==1 && ~isempty(cuenca.SInf)
            [cuenca]=SUD_infiltracion(cuenca,cuenca.hietogramaTotal(j,2),yini,simulacion.dtEscorrentia,cuenca.hietogramaTotal(j,1));
            cuenca.f=cuenca.SInf.f;
        else
            cuenca.f=0;
        end
        hidro = Odesolve(n1,alpha,depresionAlm,eps,h1,yini,cuenca.hietogramaTotal,j,cuenca);
        Final=[Final;hidro];
    end
    if i==1
        cuenca.rx1=Final(end,3);
    elseif i==2
        cuenca.rx2=Final(end,3);
    else
        cuenca.rx3=Final(end,3);
    end
    rx=(Final(:,3)-depresionAlm);
    rx(rx<0)=0;
    rx(isnan(rx))=0;
    caudal=alpha*rx.^(5/3)*area;
    caudal(isnan(caudal))=0;
    hidrograma{i}=[Final(:,2),caudal];
end
tiempo=(cuenca.hietogramaTotal(1,1):simulacion.dtEscorrentia:cuenca.hietogramaTotal(end,1))';
hidrogramaFinal=tiempo*0;
for i=1:D
    hidrogramaFinal=hidrogramaFinal+interp1(hidrograma{i}(:,1),hidrograma{i}(:,2),tiempo);
    if i==1
        cuenca.hidrogramaPermeable=[tiempo,interp1(hidrograma{i}(:,1),hidrograma{i}(:,2),tiempo)];
    elseif i==2
        cuenca.hidrogramaImpermeable=[tiempo,interp1(hidrograma{i}(:,1),hidrograma{i}(:,2),tiempo)];
    elseif i==3
        cuenca.hidrogramaSDImpermeable=[tiempo,interp1(hidrograma{i}(:,1),hidrograma{i}(:,2),tiempo)];
    end
end
cuenca.hidrograma=[tiempo,hidrogramaFinal];
cuenca.qEscorrentia=trapz(cuenca.hidrograma(:,1),cuenca.hidrograma(:,2));
end
