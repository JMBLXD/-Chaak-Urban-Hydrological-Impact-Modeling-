classdef routingDW
%% Dynamic Wave Routing
% //    Description:
% //        -DW object
% //        -Solves the momentum equation for flow in a conduit under dynamic wave flow routing
% //    Update History
% =============================================================
% 
    properties
        EXTRAN_CROWN_CUTOFF = 0.96;     % Crown cutoff for surcharged Extran method
        SLOT_CROWN_CUTOFF = 0.985257;   % Crown cutoff for surcharged Preissman slot method
        CourantFactor                   % Adjust time step
        SurchargeMethod                 % Surcharged method
        RouteStep                       % Route step (s)
        MinRouteStep                    % Min route step (s)
        MinSurfArea                     % Min surface area nodal (m2)
        HeadTol                         % Head tolerance (m)
        MaxTrials                       % Max trial for convergence
        AllowPonding=false;             % Allow water pond at nodes
        InertDamping                    % Degree of inertial damping
        NormalFlowLtd                   % Normal flow limited
        VariableStep=0;                 % time step 
        FUDGE=0.00001;                  % Minimum flow depth ond area
        Omega=0.5                       % Under-relaxation parameter    
        CrownCutoff                     % Fractional pipe crown cutoff
        NonConvergeCount                % Number if non-converging steps
        MAXVELOCITY = 15.24;            % Max. allowable velocity (m/s)
        GRAVITY=9.81;                   % Gravity (m/s2)

    end

    methods
        function obj=routingDW(Simulacion)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.CourantFactor=Simulacion.dinamica.courant;
            obj.SurchargeMethod=Simulacion.dinamica.surgencia;
            obj.RouteStep=Simulacion.dtTransito;
            obj.MinRouteStep=Simulacion.dinamica.minDt;
            obj.InertDamping=Simulacion.dinamica.inercia;
            obj.NormalFlowLtd=Simulacion.dinamica.fNormal;
            if obj.MinRouteStep > Simulacion.dtTransito
                obj.MinRouteStep = Simulacion.dtTransito;
            end
            if obj.MinRouteStep < 0.001
                obj.MinRouteStep = 0.001;
            end
            if Simulacion.dinamica.minAreaNodal <= 1.17
                obj.MinSurfArea = 1.17;
            else
                obj.MinSurfArea=Simulacion.dinamica.minAreaNodal;
            end
            if  Simulacion.dinamica.tolerancia <= 0 
                obj.HeadTol = 0.0001;
            else
                obj.HeadTol=Simulacion.dinamica.tolerancia;
            end

            if Simulacion.dinamica.maxIteraciones <= 0
                obj.MaxTrials = 8;
            else
                obj.MaxTrials=Simulacion.dinamica.maxIteraciones;
            end
        end

        function [obj,nodos,tuberias]=inicializarDW(obj,nodos,tuberias)
        %% inicializarDW
        % //    Description:
        % //        -Initializes dynamic wave routing method
        % //    Update History
        % =============================================================
        %
            for i=1:length(nodos)
                nodos(i).XNodo.newSurfArea = 0;
                nodos(i).XNodo.oldSurfArea = 0;
                nodos(i).invertElev=nodos(i).elevacionR;
                nodos(i).crownElev=nodos(i).invertElev;
                nodos(i).inflow=0;
                nodos(i).outflow=0;
            end
        
            for i=1:length(tuberias)
                j=tuberias(i).nodoI;
                z=nodos(j).invertElev+tuberias(i).offset1+tuberias(i).seccion.profundidad;
                nodos(j).crownElev=max(nodos(j).crownElev,z);
                j=tuberias(i).nodoF;
                z=nodos(j).invertElev+tuberias(i).offset2+tuberias(i).seccion.profundidad;
                nodos(j).crownElev=max(nodos(j).crownElev,z);
                %SUBCRITICAL=1; UP_CRITICAL=2; DN_CRITICAL=3; UP_DRY=4; DN_DRY=5; DRY=6; SPERCRITICAL=7;
                tuberias(i).flowClass = 6;
                tuberias(i).dqdh = 0;

                if obj.SurchargeMethod==2
                    obj.CrownCutoff = obj.SLOT_CROWN_CUTOFF;            
                else
                    obj.CrownCutoff = obj.EXTRAN_CROWN_CUTOFF;
                end
            end
        end

        function [obj,nodos,tuberias]=getStepDW(obj,nodos,tuberias)
        %% getStepDW
        % //    Description:
        % //        -Computes variable routing time step if applicable
        % //    Update History
        % =============================================================
        %   
            if obj.CourantFactor == 0
               obj.VariableStep=obj.RouteStep;
                return; 
            end
            if obj.RouteStep < 0.001
                obj.VariableStep=obj.RouteStep;
                return; 
            end
            if obj.VariableStep == 0
                obj.VariableStep = obj.MinRouteStep;
            else
                [obj.VariableStep,nodos,tuberias] = getVariableStep(obj,nodos,tuberias);
            end
            obj.VariableStep = floor(1000 * obj.VariableStep) / 1000;
        end
        function [minStep,nodos,tuberias]=getVariableStep(obj,nodos,tuberias)
        %% getVariableStep
        % //    Description:
        % //        -Finds time step that satisfies stability criterion but is no greater than the user-supplied maximum time step
        % //    Update History
        % =============================================================
        %
            IDTub = -1;
            INode = -1; 
            minStep = obj.RouteStep;
            [stepTub,IDTub] = getLinkStep(obj,minStep,tuberias);
            [stepNode,IDNode]= getNodeStep(obj,stepTub,nodos);
            minStep = stepTub;
            if stepNode < minStep 
                 minStep = stepNode ;
                 IDTub = -1;
            end
            if IDNode > 0 
                nodos(IDNode).timeCourantCritical =nodos(IDNode).timeCourantCritical+ 1;
            elseif IDTub > 0
                tuberias(IDTub).timeCourantCritical =tuberias(IDTub).timeCourantCritical+ 1;
            end
            if minStep < obj.MinRouteStep 
                minStep = obj.MinRouteStep;
            end
        end

        function [step,IDTub]= getLinkStep(obj,minStep,tuberias)
        %% getLinkStep
        % //    Description:
        % //        -Finds critical time step for conduits based on Courant criterion
        % //    Update History
        % =============================================================
        %
        tol=obj.FUDGE; 
        step = minStep;
        IDTub=-1;
        for i=1:length(tuberias)
            switch tuberias(i).tipo
                case 'CONDUIT'
                    q = abs(tuberias(i).newFlow) / tuberias(i).barrels;
                    if q <= tol || tuberias(i).a1 <= tol || tuberias(i).froude <= 0.01
                        continue;
                    end
                    t = tuberias(i).newVolume / tuberias(i).barrels / q;
                    t = t * tuberias(i).froude / (1 + tuberias(i).froude) * obj.CourantFactor;
                    if t < step
                       step = t;
                       IDTub = tuberias(i).ID;
                    end
            end
          
        end
        end
        function [step,IDNode]=getNodeStep(obj,stepMin,nodos)
        %% getNodeStep
        % //    Description:
        % //        -Finds critical time step for nodes based on maximum allowable projected change in depth
        % //    Update History
        % =============================================================
        %
        tol=obj.FUDGE; 
        step = stepMin;
        IDNode=-1;
        for i=1:length(nodos)
            if (nodos(i).tipo==1) 
                continue;
            end
            if nodos(i).newDepth <= tol 
                continue;
            end
            if nodos(i).newDepth + tol >= nodos(i).crownElev - nodos(i).invertElev 
                continue;
            end
            maxDepth = (nodos(i).crownElev - nodos(i).invertElev) * 0.25;
            if maxDepth < tol
                continue;
            end
            dYdT = nodos(i).XNodo.dYdT;
            if dYdT < tol
                continue;
            end
            t1 = maxDepth / dYdT;
            if t1 < step
               step = t1;
               IDNode = nodos(i).ID;
            end
        end
        end

        function [Steps,NonConvergeCount,nodos,tuberias]=executeDW(obj,tuberias,nodos)
        %% executeDW
        % //    Description:
        % //        -Routes flows through drainage network over current time step
        % //    Update History
        % =============================================================
        %   
        tStep=obj.VariableStep;
        Steps = 0 ;
        NonConvergeCount=0;
        converged = false;
        [nodos,tuberias]=initRoutingStep(nodos,tuberias);
        
        while ( Steps < obj.MaxTrials )
            nodos=initNodeStates(nodos);
            
            for i=1:length(tuberias)
                if ~tuberias(i).bypassed 
                    [tuberias(i)]=findConduitFlow(obj,Steps,tuberias(i),nodos);
                end
            end

            for i=1:length(tuberias)
                n1 = tuberias(i).nodoI;
                n2 = tuberias(i).nodoF;
                q = tuberias(i).newFlow;
                uniformLossRate = 0;
                
                if strcmp(tuberias(i).tipo,'CONDUIT')
                   uniformLossRate =0;
                   barrels = tuberias(i).barrels;
                end

                if q >= 0
                   nodos(n1).outflow =nodos(n1).outflow + q ;
                   nodos(n2).inflow  =nodos(n2).inflow + q;
                else
                   nodos(n1).inflow = nodos(n1).inflow - q;
                   nodos(n2).outflow = nodos(n2).outflow - q - uniformLossRate;
                end
                    nodos(n1).XNodo.newSurfArea =nodos(n1).XNodo.newSurfArea + tuberias(i).surfArea1 * barrels;
                    nodos(n2).XNodo.newSurfArea =nodos(n2).XNodo.newSurfArea + tuberias(i).surfArea2 * barrels;
                    nodos(n1).XNodo.sumdqdh =nodos(n1).XNodo.sumdqdh + tuberias(i).dqdh;
                    nodos(n2).XNodo.sumdqdh =nodos(n2).XNodo.sumdqdh + tuberias(i).dqdh;
            end
            
            for i=1:length(tuberias)
                nodos=setOutfallDepth(tuberias(i),nodos);
            end

            converged=true;
            for i=1:length(nodos)
                if nodos(i).tipo==1
                    continue;
                end
                yOld = nodos(i).newDepth;
                nodos(i)=setNodeDepth(obj,nodos(i),Steps);
                nodos(i).XNodo.converged = true;
                if  abs(yOld - nodos(i).newDepth) > obj.HeadTol
                    nodos(i).XNodo.converged = false;
                    converged=false;
                end
            end

            Steps=Steps+1;
            if ( Steps > 1 )
                if converged
                    break;
                end
                for i=1:length(tuberias)
                if nodos(tuberias(i).nodoI).XNodo.converged && nodos(tuberias(i).nodoF).XNodo.converged
                    tuberias(i).bypassed =true;
                else
                    tuberias(i).bypassed =false;
                end
            end
            end   
        end

        if ~converged 
            NonConvergeCount=NonConvergeCount+1;
        end

        for i=1:length(tuberias)
            tuberias(i).capacityLimited =false;
            if tuberias(i).a1 >= tuberias(i).seccion.aFull
                n1 = tuberias(i).nodoI;
                n2 = tuberias(i).nodoF;
                h1 = nodos(n1).newDepth + nodos(n1).invertElev;
                h2 = nodos(n2).newDepth + nodos(n2).invertElev;
                if (h1 - h2) > abs(tuberias(i).Sp) * getLength(tuberias(i)) 
                    tuberias(i).capacityLimited = true;
                end
            end
        end
        end

        function [tuberia]=findConduitFlow(obj,steps,tuberia,nodos)
            %% findConduitFlow
            % //    Description:
            % //        -Updates flow in conduit link by solving finite difference form of continuity and momentum equations
            % //    Update History
            % =============================================================
            % 
           
            isFull =0;
            xsect = tuberia.seccion;
            
            barrels = tuberia.barrels;
            qOld = tuberia.oldFlow / barrels;
            qLast = tuberia.q1;
            
            n1 = tuberia.nodoI;
            n2 = tuberia.nodoF;
            z1 = nodos(n1).invertElev + tuberia.offset1;
            z2 = nodos(n2).invertElev + tuberia.offset2;
            h1 = nodos(n1).newDepth + nodos(n1).invertElev;
            h2 = nodos(n2).newDepth + nodos(n2).invertElev;
            h1 = max(h1,z1);
            h2 = max(h2,z2);
            
            y1 = h1 - z1;
            y2 = h2 - z2;
            y1 = max(y1, obj.FUDGE);
            y2 = max(y2, obj.FUDGE);
            
            if obj.SurchargeMethod~=2
                y1 = min(y1, xsect.yFull);
                y2 = min(y2, xsect.yFull);
            end
            
            aOld = tuberia.a2;
            aOld = max(aOld, obj.FUDGE);
            
            length=getLength(tuberia);
            
            [tuberia,h1,h2,y1,y2]=findSurfArea(qLast,length,h1,h2,y1,y2,tuberia,nodos,obj.SurchargeMethod);
            
            wSlot = getSlotWidth(xsect,y1,obj.CrownCutoff,obj.SurchargeMethod); 
            a1 = getArea(xsect,y1,wSlot);            
            r1 = getHydRad(xsect,y1);
            
            wSlot = getSlotWidth(xsect,y2,obj.CrownCutoff,obj.SurchargeMethod);                  
            a2 = getArea(xsect,y2,wSlot);  
            yMid = 0.5 * (y1 + y2);
            
            wSlot = getSlotWidth(xsect,yMid,obj.CrownCutoff,obj.SurchargeMethod);  
            aMid = getArea(xsect, yMid,wSlot);
            rMid = getHydRad(xsect,yMid);
            
            if ( y1 >= xsect.yFull && y2 >= xsect.yFull) 
               isFull = true;
            end
            if ( tuberia.flowClass==6 || tuberia.flowClass==4 ||...
                tuberia.flowClass==5|| aMid <= obj.FUDGE )
                tuberia.a1 = 0.5 * (a1 + a2);
                tuberia.q1 = 0;
                tuberia.q2 = 0;
                tuberia.dqdh  = obj.GRAVITY * obj.VariableStep * aMid / length * barrels;
                tuberia.froude = 0;
                tuberia.newDepth = min(yMid, tuberia.seccion.yFull);
                tuberia.newVolume = tuberia.a1 * getLength(tuberia) * barrels;
                tuberia.newFlow = 0;
                return;
            end
            
            v = qLast / aMid;
            if abs(v) > obj.MAXVELOCITY 
                v = obj.MAXVELOCITY * qLast/abs(qLast);
            end
            
            tuberia.froude = getFroude(v, yMid,tuberia);
            
            
            if tuberia.flowClass==1 && tuberia.froude > 1 
               tuberia.flowClass = 7;
            end
            
            if tuberia.froude <= 0.5  
               sigma = 1;
            elseif tuberia.froude >= 1
               sigma = 0;
            else
               sigma = 2 * (1 - tuberia.froude);
            end
            
            rho = 1;
            if ~isFull && qLast > 0 && h1 >= h2
               rho = sigma;
            end
            aWtd = a1 + (aMid - a1) * rho;
            rWtd = r1 + (rMid - r1) * rho;
            
            if obj.InertDamping==3
                sigma = 1;
            elseif obj.InertDamping==2
                sigma = 0;
            end
            
            if isFull
                sigma = 0;
            end
            
            dq1 = obj.VariableStep *tuberia.roughFactor / (rWtd^1.33333)*abs(v);
            
            dq2 = obj.VariableStep * obj.GRAVITY * aWtd * (h2 - h1) / length;
            dq3 = 0;
            dq4 = 0;
            
            if sigma > 0
               dq3 = 2 * v * (aMid - aOld) * sigma;
               dq4 = obj.VariableStep * v * v * (a2 - a1) / length * sigma;
            end
            
            dq5 = 0;
            dq6=0;
            
            denom = 1.0 + dq1 + dq5;
            q = (qOld - dq2 + dq3 + dq4 + dq6) / denom; 
            tuberia.dqdh = 1 / denom  * obj.GRAVITY * obj.VariableStep * aWtd / length * barrels;
            tuberia.inletControl = false;
            tuberia.normalFlow = false;
            
            if q > 0.0
               if ( y1 < tuberia.seccion.yFull && (tuberia.flowClass == 1 ||...
                       tuberia.flowClass == 7))
                   [q,tuberia] = checkNormalFlow( q, y1, y2, a1, r1,tuberia,nodos,obj.NormalFlowLtd);
               end
            end
            
            if steps > 0
               q = (1.0 - obj.Omega) * qLast + obj.Omega * q;
               if q * qLast < 0
            %        q =0.001* q/abs(q);
                   q = 0.00003 * q/abs(q);
               end
            end
            
            if q >  obj.FUDGE && nodos(n1).newDepth <= obj.FUDGE
                q =  obj.FUDGE;
            end
            if q < -obj.FUDGE && nodos(n2).newDepth <= obj.FUDGE 
               q = -obj.FUDGE;
            end
            
            tuberia.a1 = aMid;
            tuberia.q1 = q;
            tuberia.q2 = q;
            tuberia.newDepth  = min(yMid, xsect.yFull);
            aMid = (a1 + a2) / 2;
            % aMid = min(aMid, xsect.aFull);
            tuberia.fullState = getFullState(a1, a2, tuberia);
            tuberia.newVolume = aMid * getLength(tuberia) * barrels;
            tuberia.newFlow = q * barrels;
        end
        
        function nodo=setNodeDepth(obj,nodo,Steps)
        %% setNodeDepth
        % //    Description:
        % //        -Sets depth at non-outfall node after current time step
        % //    Update History
        % =============================================================
        % 
        isSurcharged=false;
        canPond = (obj.AllowPonding==1 && nodo.pondedArea > 0.0);
        canPond =false;
        isPonded = (canPond==1 && nodo.newDepth > nodo.fullDepth);
        yCrown = nodo.crownElev - nodo.invertElev;
        yOld = nodo.oldDepth;
        yLast = nodo.newDepth;
        nodo.overflow = 0;
        surfArea = nodo.XNodo.newSurfArea;
        surfArea = max(surfArea, obj.MinSurfArea);
        dQ = nodo.inflow - nodo.outflow;
        dV = 0.5 * (nodo.oldNetInflow + dQ) * obj.VariableStep;
        
        if obj.SurchargeMethod==1
            if isPonded
                isSurcharged = false;
            elseif nodo.tipo==2 
                isSurcharged = (nodo.surDepth > 0 && yLast > nodo.fullDepth);
            else
                isSurcharged = (yCrown > 0 && yLast > yCrown);
            end
        end
        
        if ~isSurcharged
           dy = dV / surfArea;
           yNew = yOld + dy;
           if ~isPonded
               nodo.XNodo.oldSurfArea = surfArea;
           end
           if Steps > 0 
               yNew = (1 - obj.Omega) * yLast + obj.Omega * yNew;
           end
           if isPonded && yNew < nodo.fullDepth 
               yNew = nodo.fullDepth - obj.FUDGE;
           end
        else
            corr = 1;
            if nodo.degree < 0 
                corr = 0.6;
            end
            denom = nodo.XNodo.sumdqdh;
            if yLast < 1.25 * yCrown 
                f = (yLast - yCrown) / yCrown;
                denom = denom + (nodo.XNodo.oldSurfArea/obj.VariableStep - nodo.sumdqdh) * exp(-15 * f);
            end
             if denom == 0 
                 dy = 0;
             else
                 dy = corr * dQ / denom;
             end
             
             yNew = yLast + dy;
             if yNew < yCrown 
                 yNew = yCrown - obj.FUDGE;
             end
             if canPond && yNew > nodo.fullDepth 
                 yNew = nodo.fullDepth + obj.FUDGE;
             end
        end
        
        if yNew < 0 
           yNew = 0;
        end
        
        yMax = nodo.fullDepth;
        
        if ~canPond 
            yMax = yMax + nodo.surDepth;
        end
        
        if yNew > yMax
            [yNew,nodo]=getFloodedDepth(nodo,canPond,dV,yNew,yMax,obj.VariableStep);
        else
            nodo.newVolume = getVolume(nodo,yNew);
        end
        
        nodo.XNodo.dYdT = abs(yNew - yOld) / obj.VariableStep;
        
        nodo.newDepth = yNew;
        
        end


    end
end