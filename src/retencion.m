classdef retencion
%% SUDS: Retention element
% //    Description:
% //        -Retention object
% //    Update History
% =============================================================
%
    properties
        ID                      % Identifier
        tipo                    % Type 
        areaConectada           % Direct drainage area (fraction of catchment)    
        permeable               % Pervious area (fraction pervious)
        impermeable             % Impervious area (fraction impervious)
        volumenTotal            % Total storage volume (m3)
        volumenOcupado          % Current storage occupancy (m3)
        volumenDisponible       % Current available storage volume (m3)
        capacidadInicial        % Initial storage occupancy (fraction)
        captacion               % Flow inlet coefficient (fraction)
        corX                    % Location X coordinate
        corY                    % Location Y coordinate
        cuenca                  % Catchment associated with the system (ID)
        evolucion               % Temporal storage evolution (volume: m3, time: s)
        hidrograma              % Temporal inflow (flow: m3/s, time: s)
        salida                  % Temporal outflow (flow: m3/s, time: s)
        hidrogramaDirecto       % Total runoff directed (flow: m3/s, time: s)
    end

    methods
        function obj = retencion(id,tipo)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.ID=id;
            obj.tipo=tipo;
        end
        function obj=parametros(obj,cuenca,areaConectada,permeable,impermeable,volumen,capacidadInicial,captacion)
        % //    Description:
        % //        -Set parameters for the system
        % //    Update History
        % =============================================================
        %
            obj.cuenca=cuenca;
            obj.areaConectada=areaConectada;
            obj.permeable=permeable;
            obj.impermeable=impermeable;
            obj.volumenTotal=volumen;
            obj.capacidadInicial=capacidadInicial;
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
            obj.volumenOcupado=obj.volumenTotal*obj.capacidadInicial;
            obj.volumenDisponible=obj.volumenTotal-obj.volumenOcupado;
        end

        function obj=estimarRetencion(obj,i,entrada,dt)
        % //    Description:
        % //        -Estimate retention
        % //    Update History
        % =============================================================
        %
            if obj.volumenDisponible>obj.captacion*entrada*dt
                obj.hidrograma(i,2)=entrada*obj.captacion;
                obj.volumenOcupado=obj.volumenOcupado+obj.captacion*entrada*dt;
                obj.volumenDisponible=obj.volumenDisponible-obj.captacion*entrada*dt;
                obj.salida(i,2)=(1-obj.captacion)*entrada;
            elseif obj.volumenDisponible>0
                obj.salida(i,2)=entrada-(obj.volumenDisponible/dt);
                obj.volumenOcupado=obj.volumenOcupado+obj.volumenDisponible;
                obj.hidrograma(i,2)=(obj.volumenDisponible/dt);
                obj.volumenDisponible=0;
            else
                obj.salida(i,2)=entrada;
                obj.hidrograma(i,2)=0;
            end
            obj.evolucion(i,2)=obj.volumenOcupado;           
        end
        function plotEvolucion(obj,lineStyle,lineWidth,color)
        % //    Description:
        % //        -Plot storage evolution
        % //    Update History
        % =============================================================
        %
            plot(obj.evolucion(:,1)/60,obj.evolucion(:,2),'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
        end
        function plotEntrada(obj,lineStyle,lineWidth,color)
        % //    Description:
        % //        -Plot inlet flow
        % //    Update History
        % =============================================================
        %
            plot(obj.hidrograma(:,1)/60,obj.hidrograma(:,2),'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
        end
        function plotEntradaD(obj,lineStyle,lineWidth,color)
        % //    Description:
        % //        -Plot runoff directed
        % //    Update History
        % =============================================================
        %
            plot(obj.hidrogramaDirecto(:,1)/60,obj.hidrogramaDirecto(:,2),'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
        end
        function plotSalida(obj,lineStyle,lineWidth,color)
        % //    Description:
        % //        -Plot outflow flow
        % //    Update History
        % =============================================================
        %
            plot(obj.salida(:,1)/60,obj.salida(:,2),'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
        end
    end
end