classdef tuberiaH 
%% Conduit element
% //    Description:
% //        -Conduit object
% //    Update History
% =============================================================
%
    properties
        ID                      % Identifier
        nodoI                   % Upstream node
        nodoF                   % Downstream node
        seccion                 % Geometric characteristics of the section (Obj)
        longitud                % Plan length (m)
        IPosicion               % Upstream position
        FPosicion               % Dowmstream position
        MPosicion               % Mid-position
        tipo='CONDUIT';         % Type 
        color                   % Color 
        tamano                  % Size
        labelColor              % Label color
        fontSize                % Font size
        Sp                      % Conduit slope (m/m)        
        St                      % Terrain slope (m/m)
        ERNi                    % Upstream invert elevation (m)
        ERNf                    % Downstream invert elevation (m) 
        ETNi                    % Upstream terrain elevation (m)
        ETNf                    % Downstream terrain elevation (m)
        n                       % Roughness
        q0=0;                   % Initial flow (m3/s)
        q1=0;                   % Upstream flow (m3/s)
        q2=0;                   % Dowmstream flow (m3/s)
        a1=0;                   % Upstream hydraulic area (m2)
        a2=0;                   % Dowmstream hydraulic area (m2)
        q1Old=0;                % Previous value of q1
        q2Old=0;                % Previous value of q2
        modLength               % Modified conduit length
        offset1                 % Height above upstream node invert (m)
        offset2                 % Height above dowmstream node invert (m)
        qFull                   % Flow when section is full (m3/s)
        qMax                    % Maximum flow capacity (m3/s)
        roughFactor             % Roughness factor for dynamic wave routing
        beta                    % Discharge factor
        y1=0;                   % Upstream flow depth (m)
        y2=0;                   % Dowmstream flow depth (m)
        flowClass               % Flow classification 
        dqdh                    % Change in flow with respect to head
        newDepth=0;             % Current flow depth (m)
        barrels=1;              % Number of barrels (current only work with 1 element)
        froude                  % Froude number
        newVolume=0;            % Current flow volume (m3)
        oldVolume=0;            % Previous flow volume (m3)
        bypassed                % Bypass dynwave calculated flag
        surfArea1=0;            % Upstream surface area (m2)
        surfArea2=0;            % Downstream surface area (m2)
        fullState               % FullState (1 is full state)
        newFlow=0;              % Current flow rate (m3/s)
        oldDepth=0;             % Previous flow depth (m3/s)
        oldFlow =0;             % Previous flow rate (m3/s)
        capacityLimited=0;      % Capacity limited flag
        inletControl = 0;       % Culvert inlet control flag
        normalFlow = 0;         % Normal flow limited flag
        timeCourantCritical=0;  % Time critical
    end
    
    methods
        function Obj = tuberiaH(id,Ni,Nf)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            Obj.ID=id;
            Obj.nodoI=Ni.ID;
            Obj.nodoF=Nf.ID;
            Obj.St=Ni.elevacionT-Nf.elevacionT;
            Obj.longitud= norm(Nposicion(Ni)-Nposicion(Nf));
            Obj.IPosicion=Nposicion(Ni);
            Obj.FPosicion=Nposicion(Nf);
                C=[(Obj.IPosicion(1)+Obj.FPosicion(1))/2,(Obj.IPosicion(2)+Obj.FPosicion(2))/2];
            Obj.MPosicion=C;
            Obj.color=[0.49 0.18 0.56];
            Obj.tamano=3;
            Obj.labelColor=[0 0 0];
            Obj.fontSize=8;
        end 
        function h=plotTuberia(Obj)
        % //    Description:
        % //        -Plot object (model view)
        % //    Update History
        % =============================================================
        %
                if Obj.IPosicion(1)~=Obj.FPosicion(1) || Obj.IPosicion(2)~=Obj.FPosicion(2)
                    X=[Obj.IPosicion(1),Obj.FPosicion(1)];
                    Y=[Obj.IPosicion(2),Obj.FPosicion(2)]; 
                    h=plot(X,Y,'Color',Obj.color,'LineWidth',Obj.tamano);
                end               
        end

        function h=plotTuberiaRef(Obj)
        % //    Description:
        % //        -Plot object (reference)
        % //    Update History
        % =============================================================
        %
                if Obj.IPosicion(1)~=Obj.FPosicion(1) || Obj.IPosicion(2)~=Obj.FPosicion(2)
                    X=[Obj.IPosicion(1),Obj.FPosicion(1)];
                    Y=[Obj.IPosicion(2),Obj.FPosicion(2)]; 
                    h=plot(X,Y,'Color',[0.8 0.8 0.8],'LineWidth',2);
                end               
        end

        function h=plotTuberiaAct(Obj)
        % //    Description:
        % //        -Plot object (profile view)
        % //    Update History
        % =============================================================
        %
                if Obj.IPosicion(1)~=Obj.FPosicion(1) || Obj.IPosicion(2)~=Obj.FPosicion(2)
                    X=[Obj.IPosicion(1),Obj.FPosicion(1)];
                    Y=[Obj.IPosicion(2),Obj.FPosicion(2)]; 
                    h=plot(X,Y,'Color','r','LineWidth',1);
                end               
        end

        function LabelTuberia=plotLabelT(Obj)
        % //    Description:
        % //        -Create label (model view)
        % //    Update History
        % =============================================================
        %           
                if Obj.IPosicion(1)~=Obj.FPosicion(1) || Obj.IPosicion(2)~=Obj.FPosicion(2)
                    LabelTuberia=text(Obj.MPosicion(1),Obj.MPosicion(2),['T-',num2str(Obj.ID)],'Color',Obj.labelColor,'FontSize',Obj.fontSize,'FontWeight','normal','HorizontalAlignment','left', 'VerticalAlignment','Top');
                end     
        end

        function LabelTuberia=plotLabelTR(Obj)
        % //    Description:
        % //        -Create label (plan view)
        % //    Update History
        % =============================================================
        %    
                if Obj.IPosicion(1)~=Obj.FPosicion(1) || Obj.IPosicion(2)~=Obj.FPosicion(2)
                    LabelTuberia=text(Obj.MPosicion(1),Obj.MPosicion(2),{['T-',num2str(Obj.ID)],'-'},'Color',Obj.labelColor,'FontSize',Obj.fontSize,'FontWeight','normal','HorizontalAlignment','left', 'VerticalAlignment','Top');
                end     
        end 
        function Obj = inicializarTuberia(Obj)
        %% link_initState
        % //    Description:
        % //        -Initializes a conduits's state variables at start of simulation
        % //    Update History
        % =============================================================
        %
            Obj.oldFlow=Obj.q0;
            Obj.newFlow=Obj.q0;
            Obj.oldDepth  = 0.0;
            Obj.newDepth  = 0.0;
            Obj.oldVolume = 0.0;
            Obj.newVolume = 0.0;
            Obj.inletControl  = 0;
            Obj.normalFlow    = 0;
            Obj.newDepth = getYnorm(Obj.q0 / Obj.barrels,Obj);
            Obj.oldDepth = Obj.newDepth;        
        end

        function [yNorm] = getYnorm(q,Obj)
        %% getYnorm
        % //    Description:
        % //        -Computes normal depth for given flow rate
        % //    Update History
        % =============================================================
        %
            q = abs(q);
            
            if q > Obj.qMax
                q = Obj.qMax;
            end
            
            if q <= 0
                yNorm=0;
                return;
            end
            
            s = q / Obj.beta;
            a =xsect_getAofS(Obj.seccion,s);
            y =xsect_getYofA(Obj.seccion,a);
            yNorm=y;
        
        end

        function nodos = setOutfallDepth(Obj,nodos)
        %% setOutfallDepth
        % //    Description:
        % //        -Sets depth at outfall node connected to conduit
        % //    Update History
        % =============================================================
        %
        yCrit=0;
        yNorm=0;
        
        if nodos(Obj.nodoF).tipo == 1
            n = Obj.nodoF;
            z = Obj.offset2;
        elseif nodos(Obj.nodoI).tipo == 1
            n = Obj.nodoI;
            z = Obj.offset1;
        else
            return;
        end
        
        if strcmp(Obj.tipo,'CONDUIT')
           q = abs(Obj.newFlow / Obj.barrels);
           yNorm = getYnorm(q,Obj);
           yCrit=xsect_getYcrit(Obj.seccion,q);
        end
        
        nodos(n)=setOutletDepth(nodos(n),yNorm,yCrit,z);
        end
        
        function [Obj] = initLinkDepthsDW(Obj,nodos)
        %% initLinksDW
        % //    Description:
        % //        -Sets initial flow depths in conduits under Dyn. Wave routing
        % //    Update History
        % =============================================================
        %
        FUDGE=0.00001;
            for i=1:length(Obj)
                switch Obj(i).tipo
                    case 'CONDUIT'
                        if Obj(i).q0 ~= 0
                            continue;
                        end
                        y1=nodos(Obj(i).nodoI).newDepth-Obj(i).offset1;
                        y1=max(y1,0);
                        y1=min(y1,Obj(i).seccion.yFull);
                        y2=nodos(Obj(i).nodoF).newDepth-Obj(i).offset2;
                        y2=max(y2,0);
                        y2=min(y2,Obj(i).seccion.yFull);
                        y=0.5*(y1+y2);
                        y=max(y,FUDGE);
                        Obj(i).newDepth=y;
                end
            end
        end

        function [Obj] = initLinksDW(Obj)
        %% initLinksDW
        % //    Description:
        % //        -Sets initial upstream/downstream conditions in conduits
        % //    Update History
        % =============================================================
        %
            for i=1:length(Obj)
                switch Obj(i).tipo
                    case 'CONDUIT'
                        Obj(i).q1=Obj(i).newFlow/Obj(i).barrels;
                        Obj(i).q2=Obj(i).q1;
                        Obj(i).a1=xsect_getAofY(Obj(i).seccion,Obj(i).newDepth);
                        Obj(i).a2=Obj(i).a1;
                        Obj(i).newVolume=Obj(i).a1*getLength(Obj(i))*Obj(i).barrels;
                        Obj(i).oldVolume=Obj(i).newVolume;
                end
            end
        end
        function long = getLength(Obj)
        %% getLength
        % //    Description:
        % //        -Finds true length of a conduit
        % //    Update History
        % =============================================================
        %
            if strcmp(Obj.tipo,'CONDUIT')
                long=Obj.longitud/cos(atan(Obj.Sp));
            else
                long=0;
            end
        end
        function Obj = setOldHydState(Obj )
        %% setOldHydState
        % //    Description:
        % //        -Replaces conduit's old hydraulic state values with current ones
        % //    Update History
        % =============================================================
        %
            Obj.oldDepth  = Obj.newDepth;
            Obj.oldFlow   = Obj.newFlow;
            Obj.oldVolume = Obj.newVolume;
        
            switch Obj.tipo
                case 'CONDUIT'
                    Obj.q1Old = Obj.q1;
                    Obj.q2Old = Obj.q2;
            end
        
        end

        function fullState = getFullState(a1,a2,Obj)
        %% getFullState
        % //    Description:
        % //        -Determines if a conduit is upstream, downstream or completely full
        % //    Update History
        % =============================================================
        %
        aFull=Obj.seccion.aFull;
        if a1>=aFull
            if a2>aFull
                fullState=3;
                return;
            else
                fullState=1;
                return
            end
        end
        if a2>aFull
            fullState=2;
            return;
        end
        fullState=0;
        end

        function Fr  = getFroude(v,y,Obj )
        %% getFroude
        % //    Description:
        % //        -Computes Froude Number for given velocity and flow depth
        % //    Update History
        % =============================================================
        %
        GRAVITY=9.81;
        FUDGE=0.00001; 
        xsect = Obj.seccion;
        if ( y <= FUDGE )
            Fr=0;
            return; 
        end
        if xsect.yFull - y <= FUDGE
           Fr=0;
           return;
        end
        y = xsect_getAofY(xsect, y) / xsect_getWofY(xsect, y);
        Fr=abs(v) / sqrt(GRAVITY * y);
        end

    end
    
end

