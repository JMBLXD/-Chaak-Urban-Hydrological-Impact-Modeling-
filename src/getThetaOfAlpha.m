function theta=getThetaOfAlpha(alpha)
%% getThetaOfAlpha
% //    Description:
% //        -Get theta of alpha
% //    Update History
% =============================================================
%
    if ( alpha > 0.04 ) 
        theta = 1.2 + 5.08 * (alpha - 0.04) / 0.96;
    else
        theta = 0.031715 - 12.79384 * alpha + 8.28479 * sqrt(alpha);
    end
    theta1 = theta;
    ap  = (2*pi) * alpha;
    for k = 1:40
        d = - (ap - theta + sin(theta)) / (1- cos(theta));
        if ( d > 1.0 ) 
            if d>=0
                d=1;
            else
                d=-1;
            end
        end
        theta = theta - d;
        if ( abs(d) <= 0.0001 ) 
            return;
        end
    end
    theta= theta1;
end
