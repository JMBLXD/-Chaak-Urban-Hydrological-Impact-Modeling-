function [hidrograma] = hidrogramaSCS(hietogramaEfectivo,tc,area)
%% hidrogramaSCS
% //    Description:
% //        -Get SCS Unit Hydrograph
% //    Update History
% =============================================================
%
    
    hietogramaEfectivo=[hietogramaEfectivo(:,1),hietogramaEfectivo];
    hietogramaEfectivo(:,2)=hietogramaEfectivo(:,2)+hietogramaEfectivo(2,1);
    hietogramaEfectivo(:,2)=hietogramaEfectivo(:,2)-hietogramaEfectivo(1,1);
    hietogramaEfectivo(:,1)=[];
    hietogramaEfectivo(:,1)=hietogramaEfectivo(:,1)/60;
    tc=tc/60;
    tr=hietogramaEfectivo(1,1);%Duracion de precipitacion
    tp=(0.6*tc); %Tiempo de retardo
    Tp=tr/2+tp; %Tiempo pico
    area=(area*10000)/(1000*1000);%Conversion a km2
    qp=(2.083*area)/Tp; %Caudal pico del hidrograma

    hidrogramaAdimensional=[0,0;0.1,0.03;0.4,0.31;0.7,0.82;1,1;1.3,0.86;1.6,0.56;1.9,...
        0.33;2.4,0.147;3,0.055;4,0.011;4.5,0.005;5,0]; %HU adimensional del SCS
    HU=[Tp*hidrogramaAdimensional(:,1),qp*hidrogramaAdimensional(:,2)]; %Se obtine el HU para la cuenca
    Tiempo1=(hietogramaEfectivo(1,1):hietogramaEfectivo(1,1):HU(end,1))'; %Intervalos de tiempo necesarios para realizar la convolucion
    Qf=interp1(HU(:,1),HU(:,2),Tiempo1)'; %Valores de caudal interpolados para cada intervalo de tiempo
    for i=1:size(hietogramaEfectivo,1)
        HUTotales(:,i)=Qf*hietogramaEfectivo(i,2)/10; %Se crea el HU del SCS para cada intervalo del hietograma
    end
    hidrograma=zeros(size(HUTotales,1)+size(HUTotales,2),size(HUTotales,2)); %Se crea la matriz final donde se acomodara cada HU
    for i=1:size(HUTotales,2)    
        hidrograma(i:i-1+size(HUTotales,1),i)=HUTotales(:,i); %Se acomodan los HU en el tiempo
    end
    hidrograma=[hidrograma,sum(hidrograma,2)]; %Se agrupa el hidrograma convolucionado con los demas HU
    duracion=(hietogramaEfectivo(1,1):hietogramaEfectivo(1,1):size(hidrograma,1)*hietogramaEfectivo(1,1))';%Se obtiene el vector de tiempo total para el HU
    hidrograma=[duracion,hidrograma]; %Se agrupan los resultados
    t0=zeros(1,size(hidrograma,2)); %Se crea un renglon de zeros 
    hidrograma=[t0*60;hidrograma]; %Se acomoda el vector de zeros en el inicio 
    hidrograma=[hidrograma(:,1)*60,hidrograma(:,end)];

end