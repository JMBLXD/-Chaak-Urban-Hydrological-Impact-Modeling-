classdef cuencaH
%% Catchment elementsaveResultados
% //    Description:
% //        -Catchment object
% //    Update History
% =============================================================
%
    properties
        ID                          % Identifier
        descarga                    % Outlet node ID
        corD                        % Location outlet node
        trazo                       % Contour points
        area                        % Area (ha)
        areaSUDS = 0;               % Portion of the area connected to SUDS (fraction)
        areaPermSUDS = 0;           % Portion of the pervious area connected to SUDS (fraction)
        areaImpSUDS = 0;            % Portion of the impervious area connected to SUDS (fraction)
        centroide                   % Centroid
        color                       % Color  
        labelColor                  % Label color
        fontSize                    % Font size
        tormenta                    % Rainfall event ID
        infiltracion                % Infiltration method (obj)
        escorrentia                 % Runoff method (obj)
        hietogramaEfectivo          % Effective precipitation
        hietogramaTotal             % Total precipitation (m)
        hietogramaESUDS             % Effective precipitation SUDS
        hidrograma                  % Runoff (m3/s)
        fechaInicio                 % Date start simulation
        horaInicio                  % Hour start simulation
        minInicio                   % Minute start simulation
        qEscorrentia                % Volume runoff (m3)
        hidrogramaPermeable         % Pervious runoff (m3/s)
        hidrogramaImpermeable       % Impervious runoff    
        hidrogramaSDImpermeable     % SDImpervious runoff
        sudAlmacenamiento           % SUDS retention
        sudDetencion                % SUDS detention
        sudInfiltracion             % SUDS infiltration
        precipitacionInfiltrada     % Infiltration (m/interval)
        f                           % Infiltration rate
        rx1                         % Depth flow pervious area
        rx2                         % Depth flow impervious area
        rx3                         % Depth flow sd-impervious area
    end
    
    methods
        function Obj = cuencaH(id,nodo,trazo)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            Obj.ID=id;
            if isobject(nodo)
                Obj.descarga=nodo.ID;
                Obj.corD=[nodo.corX,nodo.corY];
            else
                Obj.descarga=nodo;
            end
            Obj.areaSUDS=0;
            Obj.trazo=trazo;
            Obj.color=[0.93 0.69 0.13];
            Obj.labelColor=[0 0 0];
            Obj.fontSize=8;
        end

        function obj=generarHidrograma(obj,hietogramaTotal,simulacion)
        % //    Description:
        % //        -Get hydrogram
        % //    Update History
        % =============================================================
        %
            switch obj.escorrentia.metodo
                case 'HU-SCS'
                    hietogramaE = hietogramaESCS(hietogramaTotal,obj.infiltracion.NC);
                    obj.precipitacionInfiltrada=sum(hietogramaTotal(:,2))-sum(hietogramaE(:,2));
                    obj.hidrograma = hidrogramaSCS(hietogramaE,obj.escorrentia.tc,obj.area);
                    obj.hidrograma(:,1)=obj.hidrograma(:,1)*60;
                case 'HU-Snyder'
                    hietogramaE = hietogramaESCS(hietogramaTotal,obj.infiltracion.NC);
                    obj.hidrograma = hidrogramaSnyder(hietogramaE,obj.escorrentia.tp,obj.escorrentia.cp,obj.area);
                    obj.precipitacionInfiltrada=sum(hietogramaTotal(:,2))-sum(hietogramaE(:,2));
                    obj.hidrograma(:,1)=obj.hidrograma(:,1)*60;
                case 'Onda-Cinematica'
                    obj.hietogramaTotal=hietogramaTotal;
                    obj = hidrogramaOC(obj,simulacion);
                case 'H-Conocido'
                    obj.hidrograma=obj.escorrentia.datos;
            end
        end

        function obj= estimarInfiltracion(obj,ix,d,step)
        % //    Description:
        % //        -Get infiltration
        % //    Update History
        % =============================================================
        %
            ix=ix/step;
            f1=0;
            fa=ix+(d/step);

            if ix>0
                if ( obj.infiltracion.T >= obj.infiltracion.Tmax )
                    obj.infiltracion.P = 0;
                    obj.infiltracion.F = 0;
                    obj.infiltracion.f = 0;
                    obj.infiltracion.Se = obj.infiltracion.S;
                end
                obj.infiltracion.T = 0;
                obj.infiltracion.P=obj.infiltracion.P+ix*step;
                F1=obj.infiltracion.P*(1-obj.infiltracion.P/(obj.infiltracion.P+obj.infiltracion.Se));
                f1=(F1-obj.infiltracion.F)/step;
                if ( f1 < 0 || obj.infiltracion.S <= 0 )
                    f1= 0;
                end
            else
                if d>0.004167*2.54/1000 && obj.infiltracion.S > 0
                 f1=obj.infiltracion.f;
                    if ( f1*step > obj.infiltracion.S ) 
                        f1 = obj.infiltracion.S / step;
                    end
                else
                    obj.infiltracion.T =obj.infiltracion.T+step;
                end
            end
    
            if f1 > 0
                f1=min(f1,fa);
                f1=max(f1, 0);
                obj.infiltracion.F=obj.infiltracion.F+f1*step;
                if obj.infiltracion.regen>0
                    obj.infiltracion.S=obj.infiltracion.S-f1*step;
                    if obj.infiltracion.S<0
                        obj.infiltracion.S=0;
                    end
                end
            else
                obj.infiltracion.S=obj.infiltracion.S+obj.infiltracion.regen*obj.infiltracion.Smax*step;
                if obj.infiltracion.S>obj.infiltracion.Smax
                    obj.infiltracion.S=obj.infiltracion.Smax;
                end
            end
            obj.infiltracion.f=f1;
    
            if isempty(obj.precipitacionInfiltrada)
                obj.precipitacionInfiltrada=obj.infiltracion.f*step;
            else
                obj.precipitacionInfiltrada=[obj.precipitacionInfiltrada;obj.infiltracion.f*step];
            end
        end


        function a=areaCuenca(Obj)
        % //    Description:
        % //        -Get area by contour points
        % //    Update History
        % =============================================================
        %
            if ~isempty(Obj.trazo)
                 sum=0;
                 sum1=0;
                 x=Obj.trazo(:,1);
                 y=Obj.trazo(:,2);
                 for i=1:length(x)
                     j=i+1;
                 if j==length(x)+1
                     j=1;
                 end
                     sum=sum+x(i)*y(j);
                     sum1=sum1+y(i)*x(j);
                 end
                 a=abs((sum-sum1)/2)/10000;
            else
                a=0;
            end 
        end
        
        function centro=centroCuenca(Obj)
        % //    Description:
        % //        -Get centroid
        % //    Update History
        % =============================================================
        %
            if ~isempty(Obj.trazo)
                sum=0;
                sum1=0;
                x=Obj.trazo(:,1);
                y=Obj.trazo(:,2);
                for i=1:length(x)
                    j=i+1;
                    if j==length(x)+1
                        j=1;
                    end
                    sum=sum+x(i)*y(j);
                    sum1=sum1+y(i)*x(j);
                end
                a=(sum-sum1)/2;
            end 
            sum=0;
            sum1=0;
            sum2=0;
            sum3=0;
            for i=1:length(x)
                j=i+1;
                if j==length(x)+1
                    j=1;
                end
                sum=sum+x(i)*y(j)*(x(i)+x(j));
                sum1=sum1+y(i)*x(j)*(x(i)+x(j));

                sum2=sum2+x(i)*y(j)*(y(i)+y(j));
                sum3=sum3+y(i)*x(j)*(y(i)+y(j));

            end
            centro=[(sum-sum1)/(6*a),(sum2-sum3)/(6*a)];
        end
        
        function h=plotCuenca(Obj)
        % //    Description:
        % //        -Plot object (model view)
        % //    Update History
        % =============================================================
        %
            poly=Obj.trazo;
            if poly~=0            
                X=poly(:,1);
                Y=poly(:,2);
                h=fill(X,Y,Obj.color);
                set(h,'facealpha',.1)
            end                
        end
        function h=plotCuencaRef(Obj)
        % //    Description:
        % //        -Plot object (reference)
        % //    Update History
        % =============================================================
        %
            poly=Obj.trazo;
            if poly~=0            
                X=poly(:,1);
                Y=poly(:,2);
                h=fill(X,Y,[0.8,0.8,0.8]);
                set(h,'facealpha',.1)
            end                
        end
        function CentroCuenca=plotCentroC(Obj)
        % //    Description:
        % //        -Plot object centroid (model view)
        % //    Update History
        % =============================================================
        %
            poly=Obj.trazo;
            if poly==0
            else
            CentroCuenca=plot(Obj.centroide(1),Obj.centroide(2),'Color','k','Marker','s','MarkerFaceColor',Obj.color,'MarkerSize',3);
            end                
        end

        function LCuenca=plotLabelC(Obj)
        % //    Description:
        % //        -Create label (model view)
        % //    Update History
        % =============================================================
        %  
            poly=Obj.trazo;
            if poly==0
            else
            LCuenca=text(Obj.centroide(1),Obj.centroide(2),['C- ',num2str(Obj.ID)],...
                'Color',Obj.labelColor,'FontSize',Obj.fontSize,'FontWeight','normal','VerticalAlignment','bottom');
            end                
        end

        function LCuenca=plotLabelCR(Obj)
        % //    Description:
        % //        -Create label (plan view)
        % //    Update History
        % =============================================================
            poly=Obj.trazo;
            if poly==0
            else
            LCuenca=text(Obj.centroide(1),Obj.centroide(2),{['C- ',num2str(Obj.ID)],'-'},...
                'Color',Obj.labelColor,'FontSize',Obj.fontSize,'FontWeight','normal','VerticalAlignment','bottom');
            end                
        end

        function DirCuenca=plotDirC(Obj)
        % //    Description:
        % //        -Plot object discharge direction (model view)
        % //    Update History
        % =============================================================
        %
            poly=Obj.trazo;
            if poly==0
            else
              DirCuenca=plot([Obj.centroide(1),Obj.corD(1)],[Obj.centroide(2),Obj.corD(2)],'--k');
            end                
        end

        function [obj,estado]=validarSUD(obj,sistema)
        % //    Description:
        % //        -Validate SUDS creation
        % //    Update History
        % =============================================================
        %
            areaC=obj.areaSUDS + sistema.areaConectada;
            areaPerm=obj.areaPermSUDS+sistema.areaConectada*sistema.permeable;
            areaImp=obj.areaImpSUDS+sistema.areaConectada*sistema.impermeable;

            switch obj.escorrentia.metodo
                case 'Onda-Cinematica'
                if (areaC>1 || areaPerm>(1-obj.escorrentia.zonaImpermeable/100) || areaImp>(obj.escorrentia.zonaImpermeable/100))
                    estado=0;
                    return
                else
                    obj.areaSUDS=areaC;
                    obj.areaPermSUDS=areaPerm;
                    obj.areaImpSUDS=areaImp;
                    estado=1;
                end
            end
        end

        function [obj,estado]=eliminarSUD(obj,sistema)
        % //    Description:
        % //        -Validate SUDS elimination
        % //    Update History
        % =============================================================
        %
            areaC=obj.areaSUDS - sistema.areaConectada;
            areaPerm=obj.areaPermSUDS-sistema.areaConectada*sistema.permeable;
            areaImp=obj.areaImpSUDS-sistema.areaConectada*sistema.impermeable;

            switch obj.escorrentia.metodo
                case 'Onda-Cinematica'
                if (areaC<0 || areaPerm<0 || areaImp<0)
                    estado=0;
                    return
                else
                    obj.areaSUDS=areaC;
                    obj.areaPermSUDS=areaPerm;
                    obj.areaImpSUDS=areaImp;
                    estado=1;
                end
            end
        end
        
        function [obj,sud] = hidrogramaDirecto(obj,sud)
        % //    Description:
        % //        -Estimate direct runoff 
        % //    Update History
        % =============================================================
        %
            hidrogramaDirecto=[];
            switch obj.escorrentia.metodo
                case 'Onda-Cinematica'
                    hidrogramaP=obj.hidrogramaPermeable;
                    hidrogramaIMP=obj.hidrogramaImpermeable;
                    hidrogramaIMP(:,2)=hidrogramaIMP(:,2)+obj.hidrogramaSDImpermeable(:,2);
                    hidrogramaP(:,2)=hidrogramaP(:,2)*(sud.areaConectada*sud.permeable)/(1-obj.escorrentia.zonaImpermeable/100);
                    hidrogramaIMP(:,2)=hidrogramaIMP(:,2)*sud.areaConectada*sud.impermeable/(obj.escorrentia.zonaImpermeable/100);
                    hidrogramaDirecto=hidrogramaP;
                    hidrogramaDirecto(:,2)=hidrogramaDirecto(:,2)+hidrogramaIMP(:,2);
                    obj.hidrograma(:,2)=obj.hidrograma(:,2)-hidrogramaDirecto(:,2);
                otherwise
                    hidrogramaDirecto=obj.hidrograma;
                    hidrogramaDirecto(:,2)=sud.areaConectada*hidrogramaDirecto(:,2);
                    obj.hidrograma(:,2)=obj.hidrograma(:,2)-hidrogramaDirecto(:,2);
            end
            sud.hidrogramaDirecto=hidrogramaDirecto;
        end

        function estado=validarSuds(obj,retencion,detencion,infiltracion)
        % //    Description:
        % //        -Validate all SUDS
        % //    Update History
        % =============================================================
        %
            switch obj.escorrentia
                case 'Onda-Cinematica'
                    for i=1:length(retencion)
                        if retencion(i).cuenca==obj.ID
                           areaTotal=areaTotal+retencion(i).areaConectada;
                           areaPermeable=areaPermeable+retencion(i).areaConectada*retencion(i).permeable;
                           areaImpermeable=areaImpermeable+retencion(i).areaConectada*retencion(i).impermeable;
                        end                 
                    end
                    for i=1:length(detencion)
                        if detencion(i).cuenca==obj.ID
                           areaTotal=areaTotal+detencion(i).areaConectada;
                           areaPermeable=areaPermeable+detencion(i).areaConectada*detencion(i).permeable;
                           areaImpermeable=areaImpermeable+detencion(i).areaConectada*detencion(i).impermeable;
                        end                 
                    end
                    for i=1:length(infiltracion)
                        if infiltracion(i).cuenca==obj.ID
                           areaTotal=areaTotal+infiltracion(i).areaConectada;
                           areaPermeable=areaPermeable+infiltracion(i).areaConectada*infiltracion(i).permeable;
                           areaImpermeable=areaImpermeable+infiltracion(i).areaConectada*infiltracion(i).impermeable;
                        end                 
                    end
                    if areaTotal>1 || areaPermeable>1-(obj.escorrentia.zonaImpermeable/100) ||...
                        areaImpermeable>obj.escorrentia.zonaImpermeable/100
                        estado=0;
                        return
                    end
                    estado=1;
                otherwise
                    for i=1:length(retencion)
                        if retencion(i).cuenca==obj.ID
                           areaTotal=areaTotal+retencion(i).areaConectada;
                        end                 
                    end
                    for i=1:length(detencion)
                        if detencion(i).cuenca==obj.ID
                           areaTotal=areaTotal+detencion(i).areaConectada;
                        end                 
                    end
                    for i=1:length(infiltracion)
                        if infiltracion(i).cuenca==obj.ID
                           areaTotal=areaTotal+infiltracion(i).areaConectada;
                        end                 
                    end
                    if areaTotal>1
                        estado=0;
                        return
                    end
                    estado=1;
            end
        end

    end
    
end


