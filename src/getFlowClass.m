function [flowClass,yC,yN,fasnh]=getFlowClass(q,h1,h2,y1,y2,fasnh,yC,yN,tuberia,nodos)
%% getFlowClass
% //    Description:
% //        -Determines flow class for a conduit based on depths at each end
% //    Update History
% =============================================================
%
FUDGE=0.00001;
n1 = tuberia.nodoI;
n2 = tuberia.nodoF;

z1 = tuberia.offset1;
z2 = tuberia.offset2;
if nodos(n1).tipo==1
    z1 = max(0,z1 - nodos(n1).newDepth);
end
if  nodos(n2).tipo==1
    z2 = max(0, z2 - nodos(n2).newDepth);
end
flowClass = 1;
fasnh =1;

if ( y1 > FUDGE && y2 > FUDGE )
    if q < 0
        if z1 > 0
           yN = getYnorm(abs(q),tuberia);
           yC = xsect_getYcrit(tuberia.seccion,abs(q));
           ycMin = min(yN,yC);
           if y1 < ycMin 
               flowClass = 2;
           end
        end
    else
        if z2 > 0.0 
           yN = getYnorm(abs(q),tuberia);
           yC = xsect_getYcrit(tuberia.seccion,abs(q));
           ycMin = min(yN,yC);
           ycMax = max(yN,yC);
           if y2 < ycMin  
               flowClass = 3;
           elseif y2 < ycMax 
               if ycMax - ycMin < FUDGE 
                   fasnh = 0;
               else
                   fasnh = (ycMax - y2) / (ycMax - ycMin);
               end
           end
            
        end
    end
elseif ( y1 <= FUDGE && y2 <= FUDGE )
    flowClass = 6;
elseif y2 > FUDGE 
    if ( h2 < nodos(n1).invertElev+tuberia.offset1) 
        flowClass = 4;
    elseif z1 > 0
       yN = getYnorm(abs(q),tuberia);
       yC = xsect_getYcrit(tuberia.seccion,abs(q));
       flowClass = 2;
    end
else
    if h1 < nodos(n2).invertElev + tuberia.offset2
        flowClass = 5;
    elseif z2 > 0
       yN = getYnorm(abs(q),tuberia);
       yC = xsect_getYcrit(tuberia.seccion,abs(q));
       flowClass = 3;
    end
end
end
