function Sl=SIGN2(x,y)
%% SIGN2
% //    Description:
% //        -Get sign
% //    Update History
% =============================================================
%
    if y >= 0
        Sl=abs(x);
    else
        Sl=-abs(x);
    end
end