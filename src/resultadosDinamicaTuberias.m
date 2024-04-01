function [inflow,outflow,depth,volumen,area1,area2,converged] = resultadosDinamicaTuberias(tuberias,inflow,outflow,depth,volumen,area1,area2,converged)
%% resultadosDinamicaTuberias
% //    Description:
% //        -Save current dynamic wave conduit results 
% //    Update History
% =============================================================
%
inflowAc=zeros(1,length(tuberias));
outflowAc=zeros(1,length(tuberias));
depthAc=zeros(1,length(tuberias));
volumenAc=zeros(1,length(tuberias));
area1Ac=zeros(1,length(tuberias));
area2Ac=zeros(1,length(tuberias));
convergedAC=zeros(1,length(tuberias));
    for i=1:length(tuberias)
        inflowAc(i)=tuberias(i).q1;
        outflowAc(i)=tuberias(i).q2;
        depthAc(i)=tuberias(i).newDepth;
        volumenAc(i)=tuberias(i).newVolume;
        area1Ac(i)=tuberias(i).a1;
        area2Ac(i)=tuberias(i).a2;
        convergedAC(i)=tuberias(i).bypassed;
    end
inflow=[inflow;inflowAc];
outflow=[outflow;outflowAc];
depth=[depth;depthAc];
volumen=[volumen;volumenAc];
area1=[area1;area1Ac];
area2=[area2;area2Ac];
converged=[converged;convergedAC];
end