classdef escorrentiaSCS
%% SCS runoff method
% //    Description:
% //        -Runoff method
% //    Update History
% =============================================================
%
    properties
        metodo  % Runoff method
        tc      % Concentration time
    end

    methods
        function obj = escorrentiaSCS(metodo,tc)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.metodo=metodo;
            obj.tc=tc;
        end

    end
end