classdef nodoH
%% Node element
% //    Description:
% //        -Node object
% //    Update History
% =============================================================
% 
    properties
        ID                      % Identifier
        corX                    % Location X coordinate
        corY                    % Location Y coordinate
        elevacionT              % Ground elevation (m)
        elevacionR              % Invert elevation (m)
        desnivel                % Depth (m)
        entranD=[]              % Number of inlet conduits
        salenD=[]               % Number of inlet conduits
        base=1;                 % Base area (m2)
        posicion                % Position (X,Y)
        color                   % Color
        tamano                  % Size
        labelColor              % Label color
        fontSize                % Font size
        tipo=3;                 % Type of element: outlet=1; storage=2; junction=3;
        entradaTotal            % Total inflow (m3/s)
        hidrogramaFinal         % Temporal inflow (m3/s)
        hidrogramaDirecto       % Runoff directed (m3/s)
        hidrogramaNeto          % Floodind (m3/s)
        qinflow2=0;             % Current inflow (m3/s)
        qinflow=0;              % Current inflow (m3/s)
        qoutflow=0;             % Current inflow (m3/s)
        Iqinflow=[];            % Lateral flow (m3/s)
        outfall                 % Outfall type code
        crownElev               % Top of highest flowing closed conduit (m)
        invertElev              % Invert elevation (m)
        inflow=0;               % Total inflow (m3/s)
        outflow=0;              % Total outflow (m3/s)
        AllowPonding=false;     % Flooding storage 
        newDepth=0;             % Current water depth (m)
        fullDepth               % Distance from invert to surface (m)
        newVolume=0;            % Current volume (m3)
        surDepth=0;             % Added depth under surcharge (m)
        oldDepth=0;             % Previous water depth (m)
        oldVolume=0;            % Previous volume (m3)
        initDepth=0;            % Initial storage level (m)     
        fullVolume=0;           % Maximum storage available (m3)
        newLatFlow=0;           % Current lateral inflow (m3/s)
        oldLatFlow=0;           % Previous lateral inflow (m3/s)
        oldFlowInflow=0;        % Previous flow inflow (m3/s)
        oldNetInflow=0;         % Previous net inflow (m3/s)
        Outfall=1               % Outfall type code 
        degree=1;               % Number of outflow links
        overflow=0;             % Overflow rate (m3/s) 
        sumdqdh=0;              % Sum of dqdh from adjoining links
        timeCourantCritical=0;  % Time critical
        XNodo
    end
    
    methods
        function Obj = nodoH(ID,x,y)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            Obj.ID=ID;
            Obj.corX=x;
            Obj.corY=y;
            Obj.elevacionT=0;
            Obj.elevacionR=0;
            Obj.posicion=[Obj.corX,Obj.corY];
            Obj.color=[0 0 1];
            Obj.tamano=5;
            Obj.labelColor=[0 0 0];
            Obj.fontSize=8;
        end    
        
        function g=plotNodo(Obj)
        % //    Description:
        % //        -Plot object (model view)
        % //    Update History
        % =============================================================
        %
            if Obj.corX==0 && Obj.corY==0
                Aviso('Verify node','Error','error');
                g=[];
                return
            else
               g=plot(Obj.corX,Obj.corY,'Color',Obj.color,'Marker','o','MarkerFaceColor',Obj.color,'MarkerSize',Obj.tamano);
            end
        end

        function t=plotLabelN(Obj)
        % //    Description:
        % //        -Create label (model view)
        % //    Update History
        % =============================================================
        %   
            t=text(Obj.corX,Obj.corY,['N-',num2str(Obj.ID)],'Color',Obj.labelColor,'FontSize',Obj.fontSize,...
                'FontWeight','normal','HorizontalAlignment','left', 'VerticalAlignment','Top');
        end 

        function t=plotLabelNR(Obj) 
        % //    Description:
        % //        -Create label (plan view)
        % //    Update History
        % =============================================================
        % 
            t=text(Obj.corX,Obj.corY,{['N-',num2str(Obj.ID)],'-'},'Color',Obj.labelColor,'FontSize',Obj.fontSize,...
                'FontWeight','normal','HorizontalAlignment','left', 'VerticalAlignment','Top');
        end

        function a=Nposicion(Obj)
        % //    Description:
        % //        -Get node position
        % //    Update History
        % =============================================================
        % 
                 a=[Obj.corX,Obj.corY];
        end

        function g=plotNodoRef(Obj)
        % //    Description:
        % //        -Plot object (reference)
        % //    Update History
        % =============================================================
        %
            if Obj.corX==0 && Obj.corY==0
                Aviso('Verify node','Error','error');
                g=[];
                return
            else
               g=plot(Obj.corX,Obj.corY,'Color','k','Marker','o','MarkerFaceColor',[0.8 0.8 0.8],'MarkerSize',4);
            end
        end

        function qinflow=caudalEntrada(Obj)
        % //    Description:
        % //        -Set direct runoff
        % //    Update History
        % =============================================================
        % 
            Hidrograma=Obj.Iqinflow;
            qentrada=Obj.hidrogramaDirecto;
            if ~isempty(Hidrograma)
            vq = interp1(Hidrograma(:,1),Hidrograma(:,2),qentrada(:,1));
            qentrada(:,2)=vq;
            qinflow=qentrada;
            else
                qinflow=qentrada;
            end
        end

        function Obj = inicializarNodo(Obj)
        %% inicializarNodo
        % //    Description:
        % //        -Initializes a node's state variables at start of simulation
        % //    Update History
        % =============================================================
        %
            Obj.oldDepth = Obj.initDepth;
            Obj.newDepth = Obj.oldDepth;
            Obj.crownElev = Obj.invertElev;
        
%             Obj.fullVolume = node_getVolume(Obj, Obj.fullDepth);
%             Obj.oldVolume = node_getVolume(Obj, Obj.oldDepth);
%             Obj.newVolume = Obj.oldVolume;
        
            Obj.oldLatFlow = 0.0;
            Obj.newLatFlow = 0.0;
%             Obj.losses = 0.0;
        end
        function [Obj] = iniNodoDW(Obj,tuberias)
        %% iniNodoDW
        % //    Description:
        % //        -Sets initial inflow/outflow and volume for each node
        % //    Update History
        % =============================================================
        %
            for i=1:length(Obj)
                Obj(i).inflow = Obj(i).newLatFlow;
                Obj(i).outflow = 0;
                Obj(i).newVolume = 0;
            end
        
            for i=1:length(tuberias)
                if tuberias(i).newFlow>=0
                    Obj(tuberias(i).nodoI).outflow=Obj(tuberias(i).nodoI).outflow + tuberias(i).newFlow;
                    Obj(tuberias(i).nodoF).inflow=Obj(tuberias(i).nodoF).inflow + tuberias(i).newFlow;
                else
                    Obj(tuberias(i).nodoI).inflow=Obj(tuberias(i).nodoI).inflow - tuberias(i).newFlow;
                    Obj(tuberias(i).nodoF).outflow=Obj(tuberias(i).nodoF).outflow - tuberias(i).newFlow;            
                end
            end
        end
        function [Obj] = initNodeDepthsDW(Obj,tuberias)
        %% initNodeDepthsDW
        % //    Description:
        % //        -Sets initial depth at nodes for Dynamic Wave flow routing
        % //    Update History
        % =============================================================
        %
        FUDGE=0.00001;
            for i=1:length(Obj)
                Obj(i).inflow=0;
                Obj(i).outflow=0;
            end
            for i=1:length(tuberias)
                if tuberias(i).newDepth>FUDGE 
                    y=tuberias(i).newDepth+tuberias(i).offset1;
                else
                    y=0;
                end
                n=tuberias(i).nodoI;
                Obj(n).inflow=Obj(n).inflow + y;
                Obj(n).outflow=Obj(n).outflow + 1;
                n=tuberias(i).nodoF;
                Obj(n).inflow=Obj(n).inflow + y;
                Obj(n).outflow=Obj(n).outflow + 1;
            end
        
            for i=1:length(Obj)
                if Obj(i).tipo==1
                    continue;
                end
                if Obj(i).tipo==2
                    continue;
                end
                if Obj(i).initDepth > 0
                    continue;
                end
                if Obj(i).outflow > 0
                    Obj(i).newDepth=Obj(i).inflow / Obj(i).outflow;
                end
            end
        
            for i=1:length(tuberias)
                Obj = setOutfallDepth(tuberias(i),Obj);
            end
        end
        function Obj = setOutletDepth(Obj,yNorm,yCrit,z)
        %% setOutletDepth
        % //    Description:
        % //        -Sets water depth at a node that serves as an outlet point
        % //    Update History
        % =============================================================
        %
        switch Obj.tipo
            case 2
                return;
            case 1
                Obj=outfall_setOutletDepth(Obj, yNorm, yCrit,z);
            otherwise
                if z > 0
                    Obj.newDepth = 0;
                else
                    Obj.newDepth = min(yNorm, yCrit);
                end   
        end
        end
        function Obj = outfall_setOutletDepth(Obj, yNorm, yCrit, z)
        %% outfall_setOutletDepth
        % //    Description:
        % //        -Sets water depth at an outfall node
        % //    Update History
        % =============================================================
        %
        switch Obj.Outfall
            case 1
                if z > 0
                    Obj.newDepth = 0;
                else
                    Obj.newDepth = min(yNorm, yCrit);
                end
                return;
            case 2
                if z > 0
                    Obj.newDepth = 0;
                else
                    Obj.newDepth = yNorm;
                end
                return;
            otherwise
                stage = Obj.invertElev;
        end
        yCrit = min(yCrit, yNorm);
        if yCrit + z + Obj.invertElev < stage
            yNew = stage - Obj.invertElev;
        elseif z > 0
            if stage < Obj.invertElev + z
                yNew = max(0, (stage - Obj.invertElev));
            else
                yNew = z + yCrit;
            end
        else
            yNew = yCrit;
        end
        Obj.newDepth = yNew;
        end
        function Vol = getVolume(Obj,d)
        %% getVolume
        % //    Description:
        % //        -Computes volume stored at a node from its water depth
        % //    Update History
        % =============================================================
        %
        switch Obj.tipo
            otherwise
                if Obj.fullDepth > 0
                    Vol=Obj.fullVolume * (d / Obj.fullDepth);
                else
                    Vol=0;
                end
        end
        end
        function obj = setOldHydState(obj)
        %% node_setOldHydState
        % //    Description:
        % //        -Replaces a node's old hydraulic state values with new ones
        % //    Update History
        % =============================================================
        %
            obj.oldDepth    = obj.newDepth;
            obj.oldVolume   = obj.newVolume;
            obj.oldFlowInflow = obj.inflow;
            obj.oldNetInflow = obj.inflow - obj.outflow;
        end
    end
end

