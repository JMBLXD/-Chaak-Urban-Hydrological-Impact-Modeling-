function [hietogramaEfectivo] = hietogramaESCS(hietogramaTotal,CN)
%% hietogramaESCS
% //    Description:
% //        -Get effective hydrograph
% //    Update History
% =============================================================
%
S=(25400/CN)-254; 
Ia=0.2*S;
hietogramaEfectivo=hietogramaTotal*0; 
hietogramaTotal(:,3)=hietogramaTotal(:,2);
hietogramaEfectivo(:,1)=hietogramaTotal(:,1); 
for i=2:size(hietogramaTotal,1)
    hietogramaTotal(i,3)=hietogramaTotal(i,2)+hietogramaTotal(i-1,3);
end

for i=1:size(hietogramaTotal,1)
    if Ia>hietogramaTotal(i,3)
        hietogramaTotal(i,4)=0; 
    else
        hietogramaTotal(i,4)=((hietogramaTotal(i,3)-0.2*S)^2)/(hietogramaTotal(i,3)+0.8*S); 
    end
end

hietogramaEfectivo(:,2)=[hietogramaTotal(1,4);diff(hietogramaTotal(:,4))];
end