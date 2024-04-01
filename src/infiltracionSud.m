classdef infiltracionSud
%% SUDS: Infiltration element
% //    Description:
% //        -Infiltration object
% //    Update History
% =============================================================
%
    properties
        ID                      % Identifier
        tipo                    % Type
        cuenca                  % Catchment associated with the system
        areaConectada           % Direct drainage area (fraction)
        permeable               % Pervious area (fraction)
        impermeable             % Impervious area (fraction)
        control                 % Infiltration control type 
        infilMax                % Infiltration maximum permissible (mm)
        infilTasa               % Constant rate infiltration (mm/h) 
        infilCurva              % Curve rate infiltration (mm/h) 
        captacion               % Flow inlet coefficient
        superficie              % Surface infiltration (m/2)
        hidrograma              % Temporal inflow (m3/s)
        hidrogramaDirecto       % Total runoff directed (m3/s)
        salida                  % Temporal outflow (m3/s)
        evolucion               % Temporal infiltration evolution (mm)
        infilTotal              % Cumulative infiltration (m)
    end

    methods
        function obj = infiltracionSud(id,tipo)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.ID=id;
            obj.tipo=tipo;
        end
        function obj=parametros(obj,cuenca,areaConectada,permeable,impermeable,datosControl,superficie,infilMax,captacion)
        % //    Description:
        % //        -Set parameters for the system
        % //    Update History
        % =============================================================
        %
            obj.cuenca=cuenca;
            obj.areaConectada=areaConectada;
            obj.permeable=permeable;
            obj.impermeable=impermeable;
            obj.control=datosControl.tipo;
            switch datosControl.tipo
                case 'constante'
                    obj.infilTasa=datosControl.tasa;
                case 'variable'
                    obj.infilCurva=datosControl.tasa;
            end
            obj.superficie=superficie;
            obj.infilMax=infilMax;
            obj.captacion=captacion;
        end
        
        function obj=iniciar(obj,tiempoSimulacion)
        % //    Description:
        % //        -Initialize system
        % //    Update History
        % =============================================================
        %
            obj.hidrograma=[tiempoSimulacion,tiempoSimulacion*0];
            obj.salida=obj.hidrograma;
            obj.evolucion=obj.hidrograma;
            obj.infilTotal=0;
        end

        function obj=estimarInfiltracionSUD(obj,entrada,i,dt)
        % //    Description:
        % //        -Estimate infiltration
        % //    Update History
        % =============================================================
        %
            entrada=entrada*obj.captacion;
            obj.hidrograma(i,2)=entrada;
            if obj.infilTotal>=obj.infilMax
               obj.salida(i,2)=entrada;
               obj.evolucion(i,2)=0;
               return
            end
            h=(entrada*dt)/obj.superficie;
            switch obj.control
                case 'constante'
                    tasa=obj.infilTasa/3600;
                case 'variable'
                    tasa=interp1(obj.infilCurva(:,1),obj.infilCurva,obj.hidrograma(i,1))/3600;
            end
            if isnan(tasa) || tasa<0
                tasa=0;
            end
            infil=tasa/100*dt;
            if infil>h
                infil=h;
            end
            if obj.infilTotal+infil>obj.infilMax/1000
                infil=obj.infilMax/1000-obj.infilTotal;
            end
            obj.salida(i,2)=(h-infil)*obj.superficie/dt;
            obj.infilTotal=obj.infilTotal+infil;
            obj.evolucion(i,2)=infil;
        end
        
        function plotEvolucion(obj,lineStyle,lineWidth,color)
         % //    Description:
        % //        -Plot infiltration evolution
        % //    Update History
        % =============================================================
        %
            plot(obj.evolucion(:,1),obj.evolucion(:,2)*1000,'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
        end
        function plotEntrada(obj,lineStyle,lineWidth,color)
        % //    Description:
        % //        -Plot inlet flow
        % //    Update History
        % =============================================================
        %
            plot(obj.hidrograma(:,1),obj.hidrograma(:,2),'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
        end
        function plotEntradaD(obj,lineStyle,lineWidth,color)
        % //    Description:
        % //        -Plot runoff directed
        % //    Update History
        % =============================================================
        %
            plot(obj.hidrogramaDirecto(:,1),obj.hidrogramaDirecto(:,2),'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
        end
        function plotSalida(obj,lineStyle,lineWidth,color)
        % //    Description:
        % //        -Plot outflow flow
        % //    Update History
        % =============================================================
        %
            plot(obj.salida(:,1),obj.salida(:,2),'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
        end

    end
end