function [nodos,tuberias]=initRoutingStep(nodos,tuberias)
%% initRoutingStep
% //    Description:
% //        -Initializes at start of step routing simulation
% //    Update History
% =============================================================
%
    for i=1:length(nodos)
        nodos(i).XNodo.converged = false;
        nodos(i).XNodo.dYdT = 0;
    end
    for i=1:length(tuberias)
        tuberias(i).bypassed = false;
        tuberias(i).surfArea1 = 0;
        tuberias(i).surfArea2 = 0;
        tuberias(i).a2 = tuberias(i).a1;
    end
end
