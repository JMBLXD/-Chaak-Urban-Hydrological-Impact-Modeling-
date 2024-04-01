function theta=getThetaOfPsi(psi)
%% getThetaOfPsi
% //    Description:
% //        -Get theta of psi
% //    Update History
% =============================================================
%
    if (psi > 0.90)  
        theta = 4.17 + 1.12 * (psi - 0.90) / 0.176;
    elseif (psi > 0.5)   
        theta = 3.14 + 1.03 * (psi - 0.5) / 0.4;
    elseif (psi > 0.015) 
        theta = 1.2 + 1.94 * (psi - 0.015) / 0.485;
    else                  
        theta = 0.12103 - 55.5075 * psi + 15.62254 * sqrt(psi);
    end
    theta1 = theta;
    ap = (2.0*pi) * psi;

    for k=1:40
        theta = abs(theta);
        tt = theta - sin(theta);
        tt23  = tt^(2/3);
        t3 = theta^( 1/3);
        d = ap * theta / t3 - tt * tt23;
        d = d / ( ap*(2/3)/t3 - (5/3)*tt23*(1.0-cos(theta)) );
        theta = theta - d;
        if ( abs(d) <= 0.0001 ) 
             return
        end      
    end
    theta=theta1;
end