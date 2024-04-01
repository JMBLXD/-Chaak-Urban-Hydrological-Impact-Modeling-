function area=getAcircular(psi)
%% getAcircular
% //    Description:
% //        -Computes area at psi for circular cross section
% //    Update History
% =============================================================
%
    if psi >= 1  
        area = 1;
        return
    end
    if psi <= 0 
        area=0;
        return
    end
    if psi <= 1.0e-6
        theta = (124.4797*psi)^(3/13);
        area=(theta*theta*theta) / 37.6911;
        return
    end
    theta = getThetaOfPsi(psi);
    area=(theta - sin(theta)) / (2* pi);
end