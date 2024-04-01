classdef XNodo
%% Node element
% //    Description:
% //        -Aid in the routing method
% //    Update History
% =============================================================
%
    properties
        ID              % Identifier
        converged       % Check for iteration node completed
        newSurfArea     % Current surface area
        oldSurfArea     % Previous surface area
        sumdqdh         % Sum of dqdh in contiguous links
        dYdT=0;         % Change in depth Y over time t
    end

    methods
        function obj = XNodo(nodo)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.ID=nodo.ID;
            obj.converged=0;
            obj.newSurfArea=0;
            obj.oldSurfArea=0;
            obj.dYdT=0;
            obj.sumdqdh=0;
        end
    end
end