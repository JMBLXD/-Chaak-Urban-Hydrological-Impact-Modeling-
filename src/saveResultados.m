function [resultados,respuesta]=saveResultados(sistemaDrenaje,varargin)
%% saveResultados
% //    Description:
% //        -Get summary results of simulation
% //    Update History
% =============================================================
%
Catchment=sistemaDrenaje.Catchment;
Conduit=sistemaDrenaje.Conduit;
Node=sistemaDrenaje.Node;
Retencion=sistemaDrenaje.Retencion;
Detencion=sistemaDrenaje.Detencion;
Infiltracion=sistemaDrenaje.Infiltracion;
escorrentia=[];
infiltracion=[];
hietogramas=[];
errorC=zeros(length(Catchment),1);
for i=1:length(Catchment)
    switch Catchment(i).escorrentia.metodo
        case 'HU-SCS'
            escorrentia=[escorrentia,Catchment(i).hidrograma];
            infiltracion=[infiltracion,Catchment(i).precipitacionInfiltrada];
            hietogramas=[hietogramas,Catchment(i).hietogramaTotal];
            errorC(i)=0;
        case 'HU-Snyder'
            escorrentia=[escorrentia,Catchment(i).hidrograma];
            infiltracion=[infiltracion,Catchment(i).precipitacionInfiltrada];
            hietogramas=[hietogramas,Catchment(i).hietogramaTotal];
            area=(Catchment(i).area*10000);
            errorC(i)=0;
        case 'Onda-Cinematica'
            escorrentia=[escorrentia,Catchment(i).hidrograma];
            infiltracion=[infiltracion,Catchment(i).precipitacionInfiltrada];
            hietogramas=[hietogramas,Catchment(i).hietogramaTotal];
            area=(Catchment(i).area*10000);
            errorC(i)=100*((sum(Catchment(i).hietogramaTotal(:,2))*area)-(trapz(Catchment(i).hidrograma(:,1),Catchment(i).hidrograma(:,2)))...
                -(sum(Catchment(i).precipitacionInfiltrada)*Catchment(i).escorrentia.areaPerm)-(Catchment(i).rx1*Catchment(i).escorrentia.areaPerm)...
                -(Catchment(i).rx2*Catchment(i).escorrentia.areaImp)-(Catchment(i).rx3*Catchment(i).escorrentia.areaSDImp))/(sum(Catchment(i).hietogramaTotal(:,2))*area);        
        case 'H-Conocido'
            errorC(i)=0;
    end
end
errorR=zeros(length(Retencion),1);
errorD=zeros(length(Detencion),1);
errorI=zeros(length(Infiltracion),1);

if ~isempty(Retencion)
    for i=1:length(Retencion)
        area=(Catchment(Retencion(i).cuenca).area*10000);
        entrada=trapz(Retencion(i).hidrogramaDirecto(:,1),Retencion(i).hidrogramaDirecto(:,2));
        errorC(i)=errorC(i)-100*entrada/(sum(Catchment(Retencion(i).cuenca).hietogramaTotal(:,2))*area);
        salida=trapz(Retencion(i).salida(:,1),Retencion(i).salida(:,2));
        volumen=Retencion(i).evolucion(end,2)-(Retencion(i).volumenTotal*Retencion(i).capacidadInicial);
        errorR(i)=100*(entrada-salida-volumen)/entrada;
    end
end
if ~isempty(Detencion)
    for i=1:length(Detencion)
        area=(Catchment(Detencion(i).cuenca).area*10000);
        entrada=trapz(Detencion(i).hidrogramaDirecto(:,1),Detencion(i).hidrogramaDirecto(:,2));
        errorC(i)=errorC(i)-100*entrada/(sum(Catchment(Detencion(i).cuenca).hietogramaTotal(:,2))*area);
        salida=trapz(Detencion(i).salida(:,1),Detencion(i).salida(:,2));
        h=Detencion(i).evolucion(end,2);
        h1=Detencion(i).hInicial;
        v=interp1(Detencion(i).curvaHV(:,1),Detencion(i).curvaHV(:,2),h);
        v1=interp1(Detencion(i).curvaHV(:,1),Detencion(i).curvaHV(:,2),h1);
        volumen=v-v1;
        errorD(i)=100*(entrada-salida-volumen)/entrada;
    end
end

if ~isempty(Infiltracion)
    for i=1:length(Infiltracion)
        area=(Catchment(Infiltracion(i).cuenca).area*10000);
        entrada=trapz(Infiltracion(i).hidrogramaDirecto(:,1),Infiltracion(i).hidrogramaDirecto(:,2));
        salida=trapz(Infiltracion(i).salida(:,1),Infiltracion(i).salida(:,2));
        errorC(i)=errorC(i)-100*entrada/(sum(Catchment(Infiltracion(i).cuenca).hietogramaTotal(:,2))*area);
        volumen=Infiltracion(i).infilTotal*Infiltracion(i).superficie;
        errorI(i)=100*(entrada-salida-volumen)/entrada;
    end
end

entradaTuberia=[];
salidaTuberia=[];
errorT=zeros(length(Conduit),1);
tirante=[];
for i=1:length(Conduit)
    entradaTuberia=[entradaTuberia,Conduit(i).q1];
    salidaTuberia=[salidaTuberia,Conduit(i).q2];
    errorT(i)=100*(trapz(Conduit(i).q1(:,1),Conduit(i).q1(:,2))-trapz(Conduit(i).q2(:,1),Conduit(i).q2(:,2))...
        -((0.5*Conduit(i).a1(end,2)+0.5*Conduit(i).a2(end,2))*Conduit(i).longitud));
    denom=trapz(Conduit(i).q1(:,1),Conduit(i).q1(:,2));
    if denom==0
        errorT(i)=0;
    else
        errorT(i)=errorT(i)/denom;
    end
    t1=Conduit(i).y1;
    t2=Conduit(i).y2;
    tirante=[tirante,[t1(:,1),0.5*(t2(:,2)+t1(:,2))]];
end

directoNodo=[];
inundacion=[];
totalNodo=[];
for i=1:length(Node)
    directoNodo=[directoNodo,Node(i).hidrogramaDirecto];
    inundacion=[inundacion,Node(i).hidrogramaNeto];
    if i==sistemaDrenaje.nf
        totalNodo=[totalNodo,Node(i).qinflow];
    else
        totalNodo=[totalNodo,Node(i).qinflow2];
    end
end


resultados.escorrentia=escorrentia;
resultados.infiltracion=infiltracion;
resultados.hietogramas=hietogramas;
resultados.errorC=errorC;
resultados.entradaTuberia=entradaTuberia;
resultados.salidaTuberia=salidaTuberia;
resultados.errorT=errorT;
resultados.totalNodo=totalNodo;
resultados.tirante=tirante;
resultados.directoNodo=directoNodo;
resultados.inundacion=inundacion;
resultados.errorI=errorI;
resultados.errorR=errorR;
resultados.errorD=errorD;
resultados.convergedNodos=sistemaDrenaje.convergedNodos;
resultados.convergedTuberias=sistemaDrenaje.convergedTuberias;
resultados.noConverged=sistemaDrenaje.noConverged;
respuesta=Node(sistemaDrenaje.nf).qinflow;

end