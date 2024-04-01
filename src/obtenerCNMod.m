function CNF = obtenerCNMod(CN)
%% obtenerCNMod
% //    Description:
% //        -Get modified curve number
% //    Update History
% =============================================================
%
S=(25400/CN)-254;
if 0<=CN && CN<=70
    Ia=0.075*S;
elseif 70<=CN && CN<=80
    Ia=0.10*S;
elseif 80<=CN && CN<=90
    Ia=0.15*S;
elseif 90<=CN && CN<=100
     Ia=0.2*S;
end

CN3=23*CN/(10+0.13*CN); %Conversion de CN2 a CN3 
P100=80;

S=(25400/CN3)-254; %Abstraccion maxima del suelo
Iamod=0.2*S;
Q=(P100-Iamod)^2/(P100-Iamod+S);

Smod=((P100-Ia)^2/Q)+Ia-P100;
CNmod=25400/(Smod+254);

CNF=10*CNmod/(23-0.13*CNmod);

end
