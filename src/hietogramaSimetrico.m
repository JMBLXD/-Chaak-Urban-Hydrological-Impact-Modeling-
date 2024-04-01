function [HPTotal] =hietogramaSimetrico(tipo,duracion,dt,idf,tr)
%% hietogramaSimetrico
% //    Description:
% //        -Get symmetrical hydrograph
% //    Update History
% =============================================================
%
n=round(duracion/(dt),0);  
if mod(n,2)==0
    n=n+1;
end

if n*dt<=duracion
    n=n+1;
end
Tiempo1=(dt:2*dt:dt*(n))';

switch tipo
    case 'EcuacionChen'
        HPre=((idf(1)*log10(10^(2-idf(2)).*tr^(idf(2)-1)))./(Tiempo1+idf(4)).^idf(3)).*(Tiempo1./60);
    case 'EcuacionGen'
        HPre=(idf(1)*tr^(idf(2))./((Tiempo1+idf(4)).^(idf(3)))).*(Tiempo1./60);
end
HPdelta=[HPre(1);diff(HPre)]; 
Fin=HPre(1); 
for i=2:size(HPre,1)

      Fin=[HPdelta(i)/2;Fin;HPdelta(i)/2];
end
Tiempo2=(dt:dt:dt*size(Fin,1))'; 

HSimetrico2=[Tiempo2,Fin];
HPTotal=HSimetrico2;
HPTotal=[0,0;HPTotal;HPTotal(end,1)+dt,0];


end