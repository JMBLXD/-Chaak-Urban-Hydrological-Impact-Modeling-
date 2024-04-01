classdef seccion
%% Conduit cross section
% //    Description:
% //        -Cross section geometry object
% //    Update History
% =============================================================
%   
    properties
        tipo            % Type
        diametro        % Diameter (m)
        profundidad     % Depth (m)
        aFull           % Full area (m2)
        aMax            % Area at maximun flow (m2)
        sMax            % Section factor at maxaximun flow (m^4/3)
        wMax            % Width at widest point (m)
        sFull           % Section factor when full (m^4/3)
        rFull           % Hydraulic radius when full (m)
        yFull           % Depth when full (m)
        ywMax           % Depth at widest point (m)
        s               % Section factor (m^4/3)
        qc              % Critical flow (m3/s)
        xstart=[];

    end
    
    methods
        function obj=seccion(tipo,varargin)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.tipo=tipo;
            switch obj.tipo
                case 'circular'
                    obj.diametro=varargin{1};
                    obj.aFull=(pi/4)*obj.diametro^2;
                    obj.aMax=0.9756*obj.aFull;
                    obj.rFull=0.25*obj.diametro;
                    obj.sFull=obj.aFull*obj.rFull^(2/3);
                    obj.yFull=obj.diametro;
                    obj.wMax=obj.diametro;
                    obj.profundidad=obj.diametro;
                    obj.ywMax=0.5*obj.yFull;
            end
        end

        function obj=getSMax(obj)
        % //    Description:
        % //        -Get section factor at maxaximun flow
        % //    Update History
        % =============================================================
        %
            switch obj.tipo
            case 'circular'
                obj.sMax=1.08*obj.sFull;
            end
        end

        function area = xsect_getAofS(obj,s)
        % //    Description:
        % //        -Computes area at a given section factor
        % //    Update History
        % =============================================================
        %
            psi=s/obj.sFull;
            if ( s <= 0.0 ) 
                area=0;
                return;
            end
            if ( s > obj.sMax ) 
                s = obj.sMax;
            end
            switch ( obj.tipo )
                case 'dummy'
                    area=0;
                case 'circular'
                    area=circ_getAofS(obj,s);
            end
        
        end
    
        function [f,df]=evalSofA(obj,a,s)
        % //    Description:
        % //        -Function used in conjunction with getAofS() that evaluates f = S(a) - s and df = dS(a)/dA
        % //    Update History
        % =============================================================
        %
            s1 = xsect_getSofA(obj,a);
            f = s1-s;
            df = xsect_getdSdA(obj, a);
        end

        % //    Description:
        % //        -Computes area at a given section factor for circular
        % //         cross section
        % //    Update History
        % =============================================================
        %
        function area=circ_getAofS(obj, s)
            psi = s / obj.sFull;
            if (psi == 0.0)
                area=0;
                return
            end
            if (psi >= 1.0) 
                area=obj.aFull;
                return
            end
            if (psi <= 0.015) 
                area=obj.aFull * getAcircular(psi);
                return
            else
                delta=1/50;
                x=(0:delta:1);
                %  s/sFull vs a/aFull
                 tablaS_Circ=[0.0, 0.00529, 0.01432, 0.02559, 0.03859, 0.05304, 0.06877, 0.08551, 0.10326,...
                      0.12195, 0.14144, 0.16162, 0.18251, 0.2041,  0.22636, 0.24918, 0.27246,...
                      0.29614, 0.32027, 0.34485, 0.36989, 0.39531, 0.42105, 0.44704, 0.47329,...
                      0.4998,  0.52658, 0.55354, 0.58064, 0.60777, 0.63499, 0.66232, 0.68995,...
                      0.7177,  0.74538, 0.77275, 0.79979, 0.82658, 0.8532,  0.87954, 0.90546,...
                      0.93095, 0.95577, 0.97976, 1.00291, 1.02443, 1.04465, 1.06135, 1.08208,...
                      1.07662, 1.0];
                area=obj.aFull*interp1(tablaS_Circ,x,psi);
            end
        
        end

        function w = xsect_getWofY(obj, y)
        % //    Description:
        % //        -Computes top width at a given depth
        % //    Update History
        % =============================================================
        %
        yNorm = y / obj.yFull;
            switch ( obj.tipo )
                case 'circular'
                    delta=1/50;
                    x=(0:delta:1);
                    %  y/yFull vs w/wFull
                     tabla=[0,0.28,0.3919,0.475,0.5426,0.6,0.6499,0.694,0.7332,0.7684,0.8,0.8285,0.8542...
                         0.8773,0.898,0.9165,0.933,0.9474,0.96,0.9708,0.9798,0.9871,0.9928,0.9968,0.9992...
                         1,0.9992,0.9968,0.9928,0.9871,0.9798,0.9708,0.96,0.9474,0.933,0.9165,0.898,0.8773...
                         0.8542,0.8285,0.8,0.7684,0.7332,0.694,0.6499,0.6,0.5426,0.475,0.3919,0.28,0];
                    w=obj.wMax* interp1(x,tabla,yNorm);
            end
        end


        function s  = xsect_getSofA(obj,a)
        % //    Description:
        % //        -Computes section factor at a given area
        % //    Update History
        % =============================================================
        %
            alpha = a / obj.aFull;
            switch obj.tipo
                case 'circular' 
                    if ( alpha < 0.04 ) 
                        s=obj.sFull * getScircular(alpha);
                    else
                    delta=1/50;
                    x=(0:delta:1);
                    %  s/sFull vs a/aFull
                      tablaS_Circ=[0.0, 0.00529, 0.01432, 0.02559, 0.03859, 0.05304, 0.06877, 0.08551, 0.10326,...
                          0.12195, 0.14144, 0.16162, 0.18251, 0.2041,  0.22636, 0.24918, 0.27246,...
                          0.29614, 0.32027, 0.34485, 0.36989, 0.39531, 0.42105, 0.44704, 0.47329,...
                          0.4998,  0.52658, 0.55354, 0.58064, 0.60777, 0.63499, 0.66232, 0.68995,...
                          0.7177,  0.74538, 0.77275, 0.79979, 0.82658, 0.8532,  0.87954, 0.90546,...
                          0.93095, 0.95577, 0.97976, 1.00291, 1.02443, 1.04465, 1.06135, 1.08208,...
                          1.07662, 1.0];
                    s= obj.sFull*interp1(x,tablaS_Circ,alpha);

                    end
            end
        end


        function dsda=xsect_getdSdA(obj,a)
        % //    Description:
        % //        -Computes derivative of its section factor with respect to area at a given area
        % //    Update History
        % =============================================================
        %
            switch obj.tipo
                case 'circular'
                    alpha = a / obj.aFull;
                    if ( alpha <= 1.0e-30 ) 
                        dsda=1.0e-30;
                        return;
                    end
                    da = 0.002;
                    a1 = alpha - 0.001;
                    a2 = alpha + 0.001;
                    if ( a1 < 0.0 )
                        a1 = 0.0;
    	                da = alpha + 0.001;
                    end
                    s1 = getScircular(a1);
                    s2 = getScircular(a2);
                    ds = (s2 - s1) / da;
                    if ( ds <= 1.0e-30 )
                        ds = 1.0e-30;
                    end
                    dsda= obj.sFull * ds / obj.aFull;
            end
        end

        function y=getYofA(obj,area)
        % //    Description:
        % //        -Computes depth at a given area
        % //    Update History
        % =============================================================
        %
            alpha=area/obj.aFull;
            switch obj.tipo
                case 'circular'
                    y=circ_getYofA(obj,area);
            end
        end

        function y=circ_getYofA(obj,area)
        % //    Description:
        % //        -Computes depth at a given area for circular cross section
        % //    Update History
        % =============================================================
        %
            alpha=area/obj.aFull;
            if alpha<0.04
                y=obj.yFull*getYCircular(alpha);
            else
                delta=1/50;
                x=(0:delta:1);
                %  y/yFull vs a/aFull
                tablaY_Circ=[0.0, 0.05236, 0.08369, 0.11025, 0.13423, 0.15643, 0.17755, 0.19772, 0.21704,...
                  0.23581, 0.25412, 0.27194, 0.28948, 0.30653, 0.32349, 0.34017, 0.35666,...
                  0.37298, 0.38915, 0.40521, 0.42117, 0.43704, 0.45284, 0.46858, 0.4843,...
                  0.50000, 0.51572, 0.53146, 0.54723, 0.56305, 0.57892, 0.59487, 0.61093,...
                  0.62710, 0.64342, 0.65991, 0.67659, 0.69350, 0.71068, 0.72816, 0.74602,...
                  0.76424, 0.78297, 0.80235, 0.82240, 0.84353, 0.86563, 0.88970, 0.91444,...
                  0.94749, 1.0];
                y=obj.yFull*interp1(x,tablaY_Circ,alpha);
            end
        end

        function yCrit=xsect_getYcrit(obj,q)
        % //    Description:
        % //        -Computes critical depth at a specific flow rate
        % //    Update History
        % =============================================================
        %
            GRAVITY=9.81;
            q2g = (q^2) / GRAVITY;
            if q2g == 0.0 
                yCrit=0;
                return;
            end
            
            switch (obj.tipo)
                otherwise
                    y = 1.01 * (q2g /obj.yFull)^(1/4);
                    if y >= obj.yFull
                        y = 0.97 * obj.yFull;
                    end
                   
                    r = obj.aFull / (pi / 4 * (obj.yFull^2));
                    if r >= 0.5 && r <= 2
                            y = getYcritEnum(obj, q, y);        
                    else
                            y= getYcritRidder(obj, q, y);
                    end               
            
            end
            yCrit=min(y, obj.yFull);
        end

        function yc = getYcritRidder( obj, q, y0 )
        % //    Description:
        % //        -Solves a * sqrt(a(y)*g / w(y)) - q for y using Ridder's 
        % //         root finding method with starting guess of y0
        % //    Update History
        % =============================================================
        %
            y1 = 0;
            y2=0.99 * obj.yFull;
            obj.qc=0;
            q2 = getQcritical(obj,y2);
            if q2 < q 
                yc=obj.yFull;
                return;
            end
            q0 = getQcritical(obj,y0);
            q1 = getQcritical(obj,0.5*obj.yFull);
            if q0 > q 
                y2 = y0;
                 if ( q1 < q ) 
                     y1 = 0.5*obj.yFull;
                 end
            else
                y1 = y0;
                    if q1 > q 
                        y2 = 0.5*obj.yFull;
                    end
            end
            
            obj.qc = q;
            
            yc = findroot_Ridder(obj,y1, y2, 0.001);
        
        end
        
        function yc = getYcritEnum(obj, q, y0)
        % //    Description:
        % //        -Solves a * sqrt(a(y)*g / w(y)) - q for y using interval 
        % //         enumeration with starting guess of y0
        % //    Update History
        % =============================================================
        %
            dy=obj.yFull/25;
            i1=fix(y0/dy);
            obj.qc=0;
            q0=getQcritical(obj,i1*dy);
            if q0<q
                yc=obj.yFull;
                for i=i1+1:25
                    qc1=getQcritical(obj,i*dy);
                    if qc1>=q
                        yc=((q-q0)/(qc1-q0)+(i-1))*dy;
                        break;
                    end
                end
                q0=qc1;
            else
                yc=0;
                for i=i1-1:-1:0
                    qc1=getQcritical(obj,i*dy);
                    if qc1<q
                        yc=((q-qc1)/(q0-qc1)+i)*dy;
                        break;
                    end
                    q0=qc1;
                end
            end

        end

        function Qc = getQcritical(obj,yc)
        % //    Description:
        % //        -Finds difference between critical flow at depth yc and 
        % //         some target value
        % //    Update History
        % =============================================================
        %
            GRAVITY=9.81;
            a = xsect_getAofY(obj,yc);
            w = xsect_getWofY(obj, yc);
            qc1 = -obj.qc;
            if  w > 0
                qc1 = a * sqrt(GRAVITY * a / w) - obj.qc;
            end
            Qc=qc1;
        end
        
        function a=xsect_getAofY(obj,y)
        % //    Description:
        % //        -Computes area at a given depth
        % //    Update History
        % =============================================================
        %
            yNorm = y / obj.yFull;
            if y<=0
                a=0;
                return
            end
            switch obj.tipo
                case 'circular'
                    delta=1/50;
                    x=(0:delta:1);
                    %  y/yFull vs a/aFull
                    tablaY_Circ=[0.0,.00471,.0134,.024446,.0374,.05208,.0680,.08505,.1033,.12236,...
                    .1423,.16310,.1845,.20665,.2292,.25236,.2759,.29985,.3242,.34874,...
                    .3736,.39878,.4237,.44907,.4745,.500,.5255,.55093,.5763,.60135,...
                    .6264,.65126,.6758,.70015,.7241,.74764,.7708,.79335,.8154,.83690,...
                    .8576,.87764,.8967,.91495,.9320,.94792,.9626,.97555,.9866,.99516,1.000];
                    a=obj.aFull*interp1(x,tablaY_Circ,yNorm);
            end

        end

        function yc = findroot_Ridder(obj,x1, x2, xacc)
        % //    Description:
        % //        -Using a Ridder's method, find the root between x1 and x2
        % //    Update History
        % =============================================================
        %
            MAXIT=60;
            flo  = getQcritical(obj,x1);
            fhi  = getQcritical(obj,x2);
            if flo == 0
                yc=x1;
                return;
            end
            if fhi == 0
                yc=x2;
                return;
            end
            mid= 0.5*(x1+x2);
            if (flo > 0 && fhi < 0) || (flo < 0 && fhi > 0) 
                xlo = x1;
                xhi = x2;
                for j=1:MAXIT
                    xm = 0.5*(xlo + xhi);
                    fm  = getQcritical(obj,xm);
                    s = sqrt( fm*fm - flo*fhi );
                    if s == 0
                        yc=mid;
                        return
                    end

                    if flo >= fhi
                        pp=1;
                    else
                        pp=-1;
                    end
                    xnew = xm + (xm-xlo)*( (pp)*fm/s );
                    if abs(xnew - mid) <= xacc
                        break;
                    end
                    mid = xnew;
                    fnew = getQcritical(obj,mid);
                    if ( SIGN2(fm,fnew) ~= fm)
                        xlo = xm;
                        flo = fm;
                        xhi = mid;
                        fhi = fnew;
                    elseif ( SIGN2(flo, fnew) ~= flo )
                        xhi = mid;
                        fhi = fnew;
                    elseif ( SIGN2(fhi, fnew) ~= fhi)
                        xlo = mid;
                        flo = fnew;
                    else
                        yc=mid;
                        return;
                    end
                    if abs(xhi - xlo) <= xacc
                        yc=mid;
                        return;
                    end
                end
                yc=mid;
                return;
            end
            yc=-1.e20;
        end


        function area=getArea(xsect,y,wSlot)
        % //    Description:
        % //        -Computes area of flow cross-section in a conduit
        % //    Update History
        % =============================================================
        %
            if y >= xsect.yFull 
                area=xsect.aFull + (y - xsect.yFull) * wSlot;
                return 
            end
            area=xsect_getAofY(xsect,y);
        end

        function RH=getHydRad(xsect,y)
        % //    Description:
        % //        -Computes hydraulic radius at a given depth
        % //    Update History
        % =============================================================
        % 
            if y >= xsect.yFull
                RH=xsect.rFull;
                return; 
            end
            RH=xsect_getRofY(xsect, y);
        end
        
        function RH = xsect_getRofY(xsect,y)
        % //    Description:
        % //        -Computes hydraulic radius at a given depth
        % //    Update History
        % =============================================================
        % 
            yNorm = y / xsect.yFull;    
            switch ( xsect.tipo )
                case 'circular'
                    delta=1/50;
                    x=(0:delta:1);
                    %  y/yFull vs R/RFull
                    tabla=[0.01,0.0528,0.1048,0.1556,0.2052,0.254,0.3016,0.3484,0.3944,0.4388,0.4824...
                     0.5248,0.5664,0.6064,0.6456,0.6836,0.7204,0.7564,0.7912,0.8244,0.8568,0.888...
                     0.9176,0.9464,0.9736,1,1.024,1.048,1.07,1.0912,1.11,1.1272,1.144,1.1596,1.174...
                     1.1848,1.194,1.2024,1.21,1.2148,1.217,1.2172,1.215,1.2104,1.203,1.192,1.178...
                     1.1584,1.132,1.094,1];
                    RH=xsect.rFull * interp1(x,tabla,yNorm);
            end
        end
        
        function y =xsect_getYofA(obj,a)
        % //    Description:
        % //        -Computes depth at a given area.
        % //    Update History
        % =============================================================
        % 
            alpha=a/obj.aFull;
            switch obj.tipo
                case 'circular'
                    y=circ_getYofA(obj,a);            
            end
        end
        
        function SlotWidth=getSlotWidth(xsect,y,CrownCutoff,SurchargeMethod)
            %% getSlotWidth
            % //    Description:
            % //        -Get Preissmann slot width 
            % //    Update History
            % =============================================================
            %
            yNorm = y / xsect.yFull;
            
            if SurchargeMethod~=2 || yNorm < CrownCutoff
                SlotWidth=0;
                return 
            end
            
            if (yNorm > 1.78) 
               SlotWidth= 0.01 * xsect.wMax;
                return 
            end
            
            SlotWidth=xsect.wMax * 0.5423 * exp(-(yNorm^2.4));
        end

        function wSlot=getWidth( xsect, y,SurchargeMethod)
            %% getWidth
            % //    Description:
            % //        -Get width 
            % //    Update History
            % =============================================================
            %
            CrownCutoff = 0.985257;
            wSlot = getSlotWidth(xsect, y,CrownCutoff,SurchargeMethod);
            if (wSlot > 0.0) 
                return;
            end
            if (y / xsect.yFull >= CrownCutoff )
                y = CrownCutoff * xsect.yFull;
            end
            wSlot=xsect_getWofY(xsect, y);
        end
    end   
end

