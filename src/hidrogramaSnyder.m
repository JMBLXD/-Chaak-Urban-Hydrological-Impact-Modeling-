function hidrograma = hidrogramaSnyder(hietogramaEfectivo,tp,cp,area)
%% hidrogramaSnyder
% //    Description:
% //        -Get Snyder Unit Hydrograph
% //    Update History
% =============================================================
%
    area=area*10000/(1000*1000); %Conviente el area a km2
    tR=hietogramaEfectivo(2,1)/60; %Conversion de la duracion del intervalo de precipitacion a horas (duracion real de la lluvia)
    C2=2.75; %Coeficiente para SI
    C3=5.56; %Coeficiente para SI
    Cw75=1.22; %Coeficiente de forma
    Cw50=2.14; %Coeficiente de forma
    tp=tp/60; %Tiempo de retardo en horas
    tr=tp/5.5; %Duracion de lluvia asociada a tp 
    qp=C2*cp/tp; %Caudal pico de Snyder
    if tr~=tR
        tpR=tp-(tr-tR)/4; %Modificacion de tp debido a tR
        qpR=qp*tp/tpR; %Calculo de caudal pico relacionado a tR
    else
        qpR=qp; %Si tr=tR estamos dentro del hidrograma estandar de Snyder
    end
    tb=C3/qpR; %Calculo del tiempo base del hidrograma
    W75=Cw75*qpR^(-1.08); %Ancho en hora para el 75% de qp
    W50=Cw50*qpR^(-1.08); %Ancho en hora para el 50% de qp
    qpR=qpR*area; %Caudal pico del HU para la cuenca y 1 cm de lamina de precipitacion
    tp=tR/2+tpR; %Tiempo pico desde el comienzo de lluvia
    W501=tp-W50/3; 
    W751=tp-W75/3;
    W752=tp+W75*2/3;
    W502=tp+W50*2/3;
    Tiempo=[0,W501,W751,tp,W752,W502,tb]'; %Tiempos conocidos del HU 
    Q=[0,0.5*qpR,0.75*qpR,qpR,0.75*qpR,0.5*qpR,0]'; %Caudales asociados a tiempos conocidos
    TF=(0:tR:tb)'; %Intervalo s de tiempo para realizar la convolucion de los HU tomando a tR como base
    QF=interp1(Tiempo,Q,TF);
    for i=1:size(hietogramaEfectivo,1)
        HSnyder(:,i)=(QF*hietogramaEfectivo(i,2)/10); %Se crea HU para cada intervalo de precipitacion efectiva
    end
    HSnyderF=zeros(size(HSnyder,1)+size(hietogramaEfectivo,1),size(HSnyder,2)); %Crea una matriz para desplazar los HU
    for i=1:size(HSnyder,2)
        HSnyderF(i:i-1+size(HSnyder,1),i)=HSnyder(:,i); %Se desplazan los HU
    end
    Conv=sum(HSnyderF,2); %Se realiza la convolucion de los HU
    TFSnyder=(0:tR:tR*(size(HSnyderF,1)-1))'; %Se crea el vector tiempo 
    HSnyderF=[TFSnyder*60,HSnyderF,Conv]; %Se agrupan los resultados en una sola matriz
    hidrograma=[TFSnyder*60,Conv];
end