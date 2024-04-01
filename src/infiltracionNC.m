classdef infiltracionNC
%% Curve number infiltration element
% //    Description:
% //        -Infiltration object
% //    Update History
% =============================================================
%  
    properties
    metodo          % Method 
    NC              % SCS curve number 
    Smax            % Maximum infiltration capacity (m)
    S               % Current infiltration capacity (m)
    P               % Current cumulative precipitation (m)
    F               % Current cumulative infiltration (m)
    T=0;            % Current inter-event time (s)
    Tmax=0;         % Maximum inter-event time (s)
    Se              % Current event infiltration capacity (m)
    f               % Previous infiltration rate (m/s)
    regen=0;        % Infiltration capacity regeneration constant (1/s)
    Max             % Maximum infiltration capacity (m)
    end
    
    methods
        function obj=infiltracionNC(metodo,NC)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.metodo=metodo;
            obj.NC=NC;
            if (NC < 10) 
                obj.NC=10;
            end
            if (obj.NC> 99) 
               obj.NC = 99;
            end
            obj.Smax=((25400/obj.NC)-254)/1000;
            obj.S  = obj.Smax;
            obj.P  = 0;
            obj.F  = 0;
            obj.T  = 0;
            obj.Se = obj.Smax;
            obj.f  = 0;
            obj.Max=obj.Smax;
            obj.regen=1/(4*86400);
            obj.Tmax = 0.06 / obj.regen;
        end
        function obj=iniciarInfiltracion(obj)
        % //    Description:
        % //        -Initializes state of Curve Number infiltration for a catchment
        % //    Update History
        % =============================================================
        %
            obj.Smax=((25400/obj.NC)-254)/1000;
            obj.S  = obj.Smax;
            obj.P  = 0;
            obj.F  = 0;
            obj.T  = 0;
            obj.Se = obj.Smax;
            obj.f  = 0;
        end
    end
    
end