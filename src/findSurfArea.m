function [tuberia,h1,h2,y1,y2]=findSurfArea(q,length,h1,h2,y1,y2,tuberia,nodos,SurchargeMethod)
%% findSurfArea
% //    Description:
% //        -Assigns surface area of conduit to its up and downstream nodes
% //    Update History
% =============================================================
%
FUDGE=0.00001;
surfArea1 = 0;
surfArea2 = 0;
fasnh = 1;
xsect = tuberia.seccion;
n1 = tuberia.nodoI;
n2 = tuberia.nodoF;
flowDepth1 = y1;
flowDepth2 = y2;
normalDepth = (flowDepth1 + flowDepth2) / 2;
criticalDepth = normalDepth;
fullDepth = xsect.yFull;

%SUBCRITICAL=1; UP_CRITICAL=2; DN_CRITICAL=3; UP_DRY=4; DN_DRY=5; DRY=6; SPERCRITICAL=7;
if flowDepth1 >= fullDepth && flowDepth2 >= fullDepth
    tuberia.flowClass = 1;
else
    [tuberia.flowClass,criticalDepth,normalDepth,fasnh] = getFlowClass(q,h1,h2,y1,y2,...
        criticalDepth,normalDepth,fasnh,tuberia,nodos);
end

switch tuberia.flowClass
    case 1 %SUBCRITICAL
        flowDepthMid = 0.5 * (flowDepth1 + flowDepth2);
        if flowDepthMid < FUDGE 
           flowDepthMid = FUDGE;
        end
        width1 =   getWidth(xsect, flowDepth1,SurchargeMethod);
        width2 =   getWidth(xsect, flowDepth2,SurchargeMethod);
        widthMid = getWidth(xsect, flowDepthMid,SurchargeMethod);
        surfArea1 = (width1 + widthMid) * length / 4;
        surfArea2 = (widthMid + width2) * length / 4* fasnh;
    case 2 %UP_CRITICAL=2
        flowDepth1 = criticalDepth;
        if normalDepth < criticalDepth
           flowDepth1 = normalDepth;
        end
        flowDepth1 = max(flowDepth1, FUDGE);
        h1 = nodos(n1).invertElev + tuberia.offset1 + flowDepth1;
        flowDepthMid = 0.5 * (flowDepth1 + flowDepth2);
        if flowDepthMid < FUDGE
           flowDepthMid = FUDGE;
        end
        width2   = getWidth(xsect, flowDepth2,SurchargeMethod);
        widthMid = getWidth(xsect, flowDepthMid,SurchargeMethod);
        surfArea2 = (widthMid + width2) * length * 0.5;
    case 3 %DN_CRITICAL
        flowDepth2 = criticalDepth;
        if normalDepth < criticalDepth
           flowDepth2 = normalDepth;
        end
        flowDepth2 = max(flowDepth2, FUDGE);
        h2 = nodos(n2).invertElev + tuberia.offset2 + flowDepth2;
        width1 = getWidth(xsect, flowDepth1,SurchargeMethod);
        flowDepthMid = 0.5 * (flowDepth1 + flowDepth2);
        if flowDepthMid < FUDGE 
           flowDepthMid = FUDGE;
        end
        widthMid = getWidth(xsect, flowDepthMid,SurchargeMethod);
        surfArea1 = (width1 + widthMid) * length * 0.5;
    case 4 %UP_DRY
        flowDepth1 = FUDGE;
        flowDepthMid = 0.5 * (flowDepth1 + flowDepth2);
        if flowDepthMid < FUDGE 
            flowDepthMid = FUDGE;
        end
        width1 = getWidth(xsect, flowDepth1,SurchargeMethod);
        width2 = getWidth(xsect, flowDepth2,SurchargeMethod);
        widthMid = getWidth(xsect, flowDepthMid,SurchargeMethod);
        surfArea2 = (widthMid + width2) * length / 4.;
        if tuberia.offset1 <= 0
            surfArea1 = (width1 + widthMid) * length / 4;
        end
    case 5 %DN_DRY
        flowDepth2 = FUDGE;
        flowDepthMid = 0.5 * (flowDepth1 + flowDepth2);
        if flowDepthMid < FUDGE
           flowDepthMid = FUDGE;
        end
        width1 = getWidth(xsect, flowDepth1,SurchargeMethod);
        width2 = getWidth(xsect, flowDepth2,SurchargeMethod);
        widthMid = getWidth(xsect, flowDepthMid,SurchargeMethod);
        surfArea1 = (widthMid + width1) * length / 4;
        if tuberia.offset2 <= 0
           surfArea2 = (width2 + widthMid) * length / 4;
        end
    case 6 %DRY
        surfArea1 = FUDGE * length / 2;
        surfArea2 = surfArea1;
   
end
tuberia.surfArea1 = surfArea1;
tuberia.surfArea2 = surfArea2;

y1 = flowDepth1;
y2 = flowDepth2;
end
