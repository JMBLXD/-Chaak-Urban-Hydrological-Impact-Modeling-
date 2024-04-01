function y=getYCircular(alpha)
%% getYCircular
% //    Description:
% //        -Get circular section depth at area 
% //    Update History
% =============================================================
%
    if alpha >= 1
       y=1;
       return
    end
    if alpha <= 0.0
        y=0;
        return
    end
    if alpha <= 1e-5 
        theta = (37.6911*alpha)^(1/3);
        y=theta * theta / 16;
        return
    end
    theta = getThetaOfAlpha(alpha);
    y= (1 - cos(theta/2)) / 2;
end