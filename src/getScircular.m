function s=getScircular(alpha)
%% getScircular
% //    Description:
% //        -Get S for circular cross section
% //    Update History
% =============================================================
%
    if ( alpha >= 1) 
        s=1.0;
        return
    end
    if ( alpha <= 0 ) 
        s= 0;
        return
    end
    if ( alpha <= 1.0e-5 )
        theta = (37.6911*alpha)^ (1/3);
        s=(theta^( 13/3)) / 124.4797;
        return 
    end
    theta = getThetaOfAlpha(alpha);
    s=((theta - sin(theta))^( 5/3)) / (2.0 * pi) / (theta^( 2/3));
    return
end