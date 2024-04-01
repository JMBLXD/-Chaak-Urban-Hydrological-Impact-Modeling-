function [yNew,nodo]=getFloodedDepth(nodo,canPond,dV,yNew,yMax,dt)
%% getFloodedDepth
% //    Description:
% //        -Computes depth, volume and overflow for a flooded node
% //    Update History
% =============================================================
%
FUDGE=0.00001; 
if ~canPond
   nodo.overflow = dV / dt;
   nodo.newVolume = nodo.fullVolume;
   yNew = yMax;
else
   nodo.newVolume = max((nodo.oldVolume+dV), nodo.fullVolume);
   nodo.overflow = (nodo.newVolume - max(nodo.oldVolume, nodo.fullVolume)) / dt;
end
if nodo.overflow < FUDGE  
    nodo.overflow = 0;
end
end