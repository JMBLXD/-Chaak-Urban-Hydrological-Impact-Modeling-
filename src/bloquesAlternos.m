function [HPTotal] =bloquesAlternos(tipo,DTormenta,DIntervalo,DIDF,tr)
%% bloquesAlternos
% //    Description:
% //        -Get alternate block hyetograph
% //    Update History
% =============================================================
%
N=round(DTormenta/DIntervalo,0);
if N*DIntervalo<DTormenta
    N=N+1; 
end
Tiempo1=(DIntervalo:DIntervalo:DIntervalo*N)'; 
switch tipo
    case 'EcuacionChen'
        HPre=((DIDF(1)*log10(10^(2-DIDF(2)).*tr^(DIDF(2)-1)))./(Tiempo1+DIDF(4)).^DIDF(3)).*(Tiempo1./60);
    case 'EcuacionGen'
        HPre=(DIDF(1)*tr^(DIDF(2))./((Tiempo1+DIDF(4)).^(DIDF(3)))).*(Tiempo1./60);
end

HBAlternos=[HPre(1);diff(HPre)]; 
Fin=HBAlternos(1); 

for i=2:size(HBAlternos,1)
  b=mod(i,2);
  if b==0
      Fin=[Fin;HBAlternos(i)];
  else
      Fin=[HBAlternos(i);Fin];
  end

HBAlternos=[Tiempo1,Fin];
HBAlternos=[0,0;HBAlternos];
HPTotal=HBAlternos;
end