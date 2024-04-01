classdef modeloHidrologico
%% Stormwater system
% //    Description:
% //        -Stormwater object
% //    Update History
% =============================================================
%    
    properties
        Nodos                   % Node (obj)
        Tuberias                % Conduit (obj)
        Cuencas                 % Catchment (obj)
        escenarioActual         % Current scenario
        nombre                  % Scenario name
        nodos=[];               % Number of nodes
        tuberias=[];            % Number of conduits
        cuencas=[];             % Number of catchments
        tormentas=[];           % Number of storms
        Natural=[];             % Number of natural responses
        graficoNodos=[];        % Node graph (model view)
        labelNodos=[];          % Node label (model view)
        graficoTuberias=[];     % Conduit graph (model view)
        labelTuberias=[];       % Conduit label (model view)
        graficoCuencas=[];      % Catchment graph (model view)
        graficoDCuencas=[];     % Catchment auxiliary graph (model view)
        graficoCCuencas=[];     % Catchment auxiliary graph (model view)
        labelCuencas=[];        % Catchment label (model view)
        background=[];          % Background (model view)
        graficoTuberiasPl=[];   % Conduit graph (plan view)
        graficoCuencasPl=[];    % Catchment graph (plan view)
        graficoNodosPl=[];      % Node graph (plan view)
        labelNodosPl=[];        % Node label (plan view)
        labelTuberiasPl=[];     % Conduit label (plan view)
        labelCuencasPl=[];      % Catchment label (plan view)       
        graficoRelleno1Pr=[];   % Conduit auxiliary graph (profile view)
        graficoRelleno2Pr=[];   % Conduit auxiliary graph (profile view)
        graficoReferenciaPr=[]; % Node auxiliary graph (profile view)
        graficoTuberiaRPr=[];   % Conduit graph (profile view)
        graficoTirantePr=[];    % Flow graph (profile view)
        graficoTerrenoPr=[];    % Ground graph (profile view)
        graficoRasantePr=[];    % Invert graph (profile view)
        graficoCoronaPr=[];     % Crown graph (profile view)
        graficoPozoRPr=[];      % Node graph (profile view)
        graficoPozoPr=[];       % Node graph (profile view)
        labelPozoPr=[];         % Node label(profile view)
        labelTuberiaPr=[];      % Conduit label (profile view)
        ordenTopologico         % Sort elements
        transito                % Routing method
        suds                    % Verify SUDS
        retencion               % Retention system (obj)
        detencion               % Detention system (obj)
        infiltracion            % Infiltration system (obj)
        bandera                 % Auxiliary flag   
        estado=1;               % State: Edit:1; Revew: 2
        escala
    end
    
    methods
        function obj = modeloHidrologico(nombre)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.nombre=nombre;
            obj.nodos = [];
            obj.tuberias = [];
            obj.cuencas = [];
            obj.graficoNodos = [];
            obj.labelNodos = [];
            obj.graficoTuberias = [];
            obj.labelTuberias = [];
            obj.graficoCuencas = [];
            obj.graficoDCuencas = [];
            obj.graficoCCuencas = [];
            obj.labelCuencas = [];   
            obj.graficoTuberiasPl=[];
        end
        function obj=inicializarGraficos(obj)
        % //    Description:
        % //        -Remove existing graphs 
        % //    Update History
        % =============================================================
        %  
            obj.graficoTuberiasPl=[];
            obj.graficoCuencasPl=[];
            obj.graficoNodosPl=[];
            obj.labelNodosPl=[];
            obj.labelTuberiasPl=[];
            obj.labelCuencasPl=[];
        end
    end
end