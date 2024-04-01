classdef simulacion
%% Simulation control
% //    Description:
% //        -Simulation object
% //    Update History
% =============================================================
%   
    properties
        inicioSimulacion    % Start simulation
        finSimulacion       % End simulation  
        dtEscorrentia       % Runoff step (s)
        dtTransito          % Routing step (s)
        dtReporte           % Result step (s)  
        tiempoEscorrentia   % Duration runoff (s) 
        tiempoTransito      % Duration routing (s)
        duracionSimulacion  % Duration simulation (s)
        estado              % Condition of simulation
        incluirSUDS         % Simulate suds  
        incluirRN           % Simulate natural response
        metodoTransito      % Routing method
        dinamica            % Dynamic wave options

        
    end
    
    methods
        function obj=simulacion(estado)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %       
            obj.estado=estado;
        end
        function obj=tiempoTotal(obj)
        % //    Description:
        % //        -Get time simulation 
        % //    Update History
        % =============================================================
        %
            [h,m,~] = hms(diff([obj.inicioSimulacion,obj.finSimulacion]));
            obj.tiempoEscorrentia=(0:obj.dtEscorrentia:h*3600+m*60)';
            obj.tiempoTransito=(0:obj.dtTransito:h*3600+m*60)';
            obj.duracionSimulacion=(h*60+m)*60;                  
        end
    end
    
end