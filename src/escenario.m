classdef escenario
%% Scenery element
% //    Description:
% //        -Scenery object
% //    Update History
% =============================================================
%
    properties
        nombre          % Name
        estado=true;    % State
        routing         % Routing method
        RHN             % Check natural response
        SUDS            % Check SUDS response
        startDate       % Simulation start date
        startHour       % Simulation start hour
        startMin        % Simulation start minute
        endDate         % Simulation end date
        endHour         % Simulation end hour
        endMin          % Simulation end min
        stepResult      % Result step (s)
        stepRunoff      % Runoff step (s)
        stepRouting     % Routing step (s)
        DW              % Dynamic wave
    end
    
    methods
        function obj = escenario(nombre)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.nombre=nombre;
        end

    end
end