function nodos=initNodeStates(nodos)
%% initNodeStates
% //    Description:
% //        -Initializes node's surface area, inflow & outflow
% //    Update History
% =============================================================
%
for i=1:length(nodos)
    nodos(i).XNodo.newSurfArea = 0;
    nodos(i).inflow = 0;
    nodos(i).outflow = 0;
    if nodos(i).newLatFlow >= 0
        nodos(i).inflow =nodos(i).inflow + nodos(i).newLatFlow;
    else
        nodos(i).outflow = nodos(i).outflow - nodos(i).newLatFlow;
    end
    nodos(i).XNodo.sumdqdh = 0;
end
end