classdef respuestaNatural
%% Natural hydrological response 
% //    Description:
% //        -Natural response object
% //    Update History
% =============================================================
%
    properties
        metodo                  % Method of estimation
        tormenta                % Associated rainfall event (obj)
        area                    % Catchment area (ha)
        tc                      % Time of concentration (min)
        tp                      % Peak time 
        cp                      % Peak coefficient
        NC                      % SCS curve number
        hietogramaEfectivo      % Effective precipitation
        hidrograma              % Natural response 
        fechaInicio             % Start date simulation 
        horaInicio              % Start hour simulation 
        minInicio               % Start minute simulation
        ancho                   % Width of overland flow path (m)
        pendiente               % Average surface slope (m/m)
        impermeable             % Impervious area (fraction)
        nPermeable              % Roughness for pervious area
        nImpermeable            % Roughness for impervious area
        dImpermeable            % Depth of depression storage on impervious area (mm)
        dPermeable              % Depth of depression storage on pervious area (mm)
        sdImpermeable           % Impervious area with no depression storage (%)
    end

    methods
        function obj = respuestaNatural(metodo,varargin)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.metodo=metodo;
            switch metodo
                case 'SCS'
                    obj.tormenta=varargin{1};
                    obj.area=varargin{2};
                    obj.tc=varargin{3};
                    obj.NC=varargin{4};
                case 'Snyder'
                    obj.tormenta=varargin{1};
                    obj.area=varargin{2};
                    obj.tp=varargin{3};
                    obj.cp=varargin{4};
                    obj.NC=varargin{5};
                case 'Onda Cinematica'
                    obj.tormenta=varargin{1};
                    obj.area=varargin{2};
                    obj.ancho=varargin{3};
                    obj.pendiente=varargin{4};
                    obj.impermeable=varargin{5};
                    obj.nPermeable=varargin{6};
                    obj.nImpermeable=varargin{7};
                    obj.dImpermeable=varargin{8};
                    obj.dPermeable=varargin{9};
                    obj.sdImpermeable=varargin{10};
                case 'Conocido'
                    obj.hidrograma=varargin{1};
                    obj.fechaInicio=varargin{2};
                    obj.horaInicio=varargin{3};
                    obj.minInicio=varargin{4};
            end
        end
        function hidrograma=generarHidrograma(obj,hietogramaTotal)
        % //    Description:
        % //        -Estimate natural hydrological response 
        % //    Update History
        % =============================================================
        %
            hietogramaE = hietogramaESCS(hietogramaTotal,obj.NC);
            switch obj.metodo
                case 'SCS'
                    hidrograma = hidrogramaSCS(hietogramaE,obj.tc,obj.area);
                case 'Snyder'
                    hidrograma = hidrogramaSnyder(hietogramaE,obj.tp,obj.cp,obj.area);
                case 'Onda Cinematica'
                    hietogramaE = hietogramaESCS(hietogramaTotal,obj.NC);
            end
        end
    end
end