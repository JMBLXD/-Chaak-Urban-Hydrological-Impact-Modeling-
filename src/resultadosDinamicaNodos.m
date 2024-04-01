function [inflow,outflow,overflow,depth,volumen,converged] = resultadosDinamicaNodos(nodos,inflow,outflow,overflow,depth,volumen,converged)
%% resultadosDinamicaTuberias
% //    Description:
% //        -Save current dynamic wave node results 
% //    Update History
% =============================================================
%
inflowAc=zeros(1,length(nodos));
outflowAc=zeros(1,length(nodos));
overflowAC=zeros(1,length(nodos));
oldDepthAC=zeros(1,length(nodos));
oldVolumenAC=zeros(1,length(nodos));
convergedAC=zeros(1,length(nodos));
    for i=1:length(nodos)
        inflowAc(i)=nodos(i).inflow;
        outflowAc(i)=nodos(i).outflow;
        overflowAC(i)=nodos(i).overflow;
        oldDepthAC(i)=nodos(i).oldDepth;
        oldVolumenAC(i)=nodos(i).newVolume;
        convergedAC(i)=nodos(i).XNodo.converged ;
    end
inflow=[inflow;inflowAc];
outflow=[outflow;outflowAc];
overflow=[overflow;overflowAC];
depth=[depth;oldDepthAC];
volumen=[volumen;oldVolumenAC];
converged=[converged;convergedAC];
end