classdef detencion
%% SUDS: Detention element
% //    Description:
% //        -Detention object
% //    Update History
% =============================================================
%
    properties
        ID                  % Identifier
        tipo                % Type 
        cuenca              % Catchment associated with the system
        areaConectada       % Direct drainage area (fraction) 
        permeable           % Pervious area (fraction)
        impermeable         % Impervious area (fraction)
        control             % Discharge control
        datosControl        % Data discharge control 
        captacion           % Flow inlet coefficient
        h                   % Current depth flow (m)
        hInicial            % Initial depth flow (m)
        curvaHA             % Curve elevation-area (m-m2)
        curvaHV             % Curve elevation-volume (m-m3)
        hmax                % Maximum depth flow (m)    
        vmax                % Maximum volume storage (m3)  
        hidrogramaDirecto   % Total runoff directed (m3/s)
        hidrograma          % Temporal inflow (m3/s)
        salida              % Temporal outflow (m3/s)
        evolucion           % Temporal storage evolution (m-s) 
        
    end

    methods
        function obj = detencion(id,tipo)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.ID=id;
            obj.tipo=tipo;
        end

        function obj=parametros(obj,cuenca,areaConectada,permeable,impermeable,datosControl,captacion,hInicial)
        % //    Description:
        % //        -Set parameters for the system
        % //    Update History
        % =============================================================
        %
            obj.cuenca=cuenca;
            obj.control=datosControl.tipo;
            obj.datosControl=datosControl;
            obj.captacion=captacion;
            obj.areaConectada=areaConectada;
            obj.permeable=permeable;
            obj.impermeable=impermeable;
            obj.hInicial=hInicial;
        end
        function obj=HA(obj,curva)
        % //    Description:
        % //        -Get curve elevation-area
        % //    Update History
        % =============================================================
        %
            if size(curva,1)>1 && size(curva,2)>1 && all(curva(:,1)>=0)
                a=sort(curva(:,1));
                if all(a==curva(:,1))
                    obj.curvaHA=curva;
                    obj.hmax=max(curva(:,1));
                    curvaV=curva;
                    curvaV(:,2)=curvaV(:,2)*0;
                    for i=1:size(curva,1)
                        curvaV(i,2)=trapz(curva(1:i,1),curva(1:i,2));
                    end
                    obj.curvaHV=curvaV;
                    obj.vmax=curvaV(end,2);
                end
            end

        end
        function obj=iniciar(obj,tiempoSimulacion)
        % //    Description:
        % //        -Initialize system
        % //    Update History
        % =============================================================
        %
            obj.hidrograma=obj.hidrogramaDirecto;
            obj.hidrograma(:,2)=obj.hidrogramaDirecto(:,2)*obj.captacion;
            obj.salida=[tiempoSimulacion,tiempoSimulacion*0];
            obj.h=obj.hInicial;
            obj.evolucion=obj.salida;

        end
        function obj = estimarDetencion(obj,entrada,i,dt)
        % //    Description:
        % //        -Estimate detention
        % //    Update History
        % =============================================================
        %
                obj.evolucion(i,2)=obj.h;              
                obj.salida(i,2)=qSalida(obj,obj.h);
                vact=interp1(obj.curvaHV(:,1),obj.curvaHV(:,2),obj.h)-obj.salida(i,2)*dt;
                if vact+(entrada*obj.captacion*dt)>obj.vmax
                    obj.hidrograma(i,2)=(obj.vmax-vact)/dt;
                    obj.salida(i,2)=obj.salida(i,2)+entrada-obj.hidrograma(i,2);
                else
                    obj.hidrograma(i,2)=entrada*obj.captacion;
                    obj.salida(i,2)=obj.salida(i,2)+(1-obj.captacion)*entrada;
                end
                
                K1=dt*((interp1(obj.hidrograma(:,1),obj.hidrograma(:,2),obj.hidrograma(i,1))-qSalida(obj,obj.h))/getAH(obj,obj.h));
                K2=dt*((interp1(obj.hidrograma(:,1),obj.hidrograma(:,2),obj.hidrograma(i,1)+dt/2)-qSalida(obj,obj.h+K1/2))/getAH(obj,obj.h+K1/2));
                K3=dt*((interp1(obj.hidrograma(:,1),obj.hidrograma(:,2),obj.hidrograma(i,1)+dt/2)-qSalida(obj,obj.h+K2/2))/getAH(obj,obj.h+K2/2));
                K4=dt*((interp1(obj.hidrograma(:,1),obj.hidrograma(:,2),obj.hidrograma(i,1)+dt)-qSalida(obj,obj.h+K3))/getAH(obj,obj.h+K3));
                obj.h=obj.h+(1/6)*(K1+2*K2+2*K3+K4);

                if obj.h>obj.curvaHA(end,1)
                    obj.h=obj.curvaHA(end,1);
                elseif obj.h<0 || isnan(obj.h)
                    obj.h=0;
                end
        end

        function qs=qSalida(obj,h)
        % //    Description:
        % //        -Estimate outflow
        % //    Update History
        % =============================================================
        %
            switch obj.control
                case 'orificio'
                    if h<=0
                        qs=0;
                        return
                    else
                        if h<obj.hmax
                            qs=obj.datosControl.conductos*obj.datosControl.cd*((pi/4)*obj.datosControl.diametro^2)*sqrt(2*9.81*h);
                        else
                            qs=obj.datosControl.conductos*obj.datosControl.cd*((pi/4)*obj.datosControl.diametro^2)*sqrt(2*9.81*obj.hmax);
                        end
                    end
                case 'vertedor'
                    if h<=obj.datosControl.cresta
                        qs=0;
                        return
                    else
                        hef=h-obj.datosControl.cresta;
                        qs=obj.datosControl.cd*obj.datosControl.longitud*hef^(3/2);
                        return
                    end 
            end
        end
        function area=getAH(obj,h)
        % //    Description:
        % //        -Get area from height
        % //    Update History
        % =============================================================
        %   
            if h<0
                h=0;
            end
            if h<obj.curvaHA(end,1)
                area=interp1(obj.curvaHA(:,1),obj.curvaHA(:,2),h);
            else
                area=obj.curvaHA(end,2);
            end
        end
        
        function plotEvolucion(obj,lineStyle,lineWidth,color)
        % //    Description:
        % //        -Plot storage evolution
        % //    Update History
        % =============================================================
        %
            plot(obj.evolucion(:,1),obj.evolucion(:,2),'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
        end
        function plotEntrada(obj,lineStyle,lineWidth,color)
        % //    Description:
        % //        -Plot inlet flow
        % //    Update History
        % =============================================================
        %
            plot(obj.hidrograma(:,1)/60,obj.hidrograma(:,2)+obj.salida(:,2),'LineStyle',lineStyle,'LineWidth',lineWidth,'Color',color);
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