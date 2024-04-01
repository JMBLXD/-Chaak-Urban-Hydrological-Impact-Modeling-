function [q, tuberia]= checkNormalFlow( q, y1, y2, a1, r1,tuberia,nodos,NormalFlowLtd)
%% checkNormalFlow
% //    Description:
% //        -Checks if flow in link should be replaced by normal flow
% //    Update History
% =============================================================
%
    FUDGE=0.00001;     
    n1=tuberia.nodoI;
    n2=tuberia.nodoF;
    hasOutfall=(nodos(n1).tipo==1 || nodos(n2).tipo==1);
    check=false;

    if NormalFlowLtd==1||NormalFlowLtd==3 || hasOutfall
        if y1<y2
            check=true;
        end
    end
    if ~check &&(NormalFlowLtd==2||NormalFlowLtd==3)&& ~hasOutfall
        if y1>FUDGE && y2>FUDGE
            f1 = link_getFroude(q/a1,y1,tuberia );
            if f1>1
                check=true;
            end
        end

    end

    if check
        qNorm=tuberia.beta*a1*r1^(2/3);
        if qNorm<q
            tuberia.normalFlow=true;
            q=qNorm;
            return
        end
    end
    q=q;    
end