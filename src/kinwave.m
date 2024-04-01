function [ qoutflow,result,qinflow,tuberia] = kinwave( tuberia,tStep,qinflow,iteracion )
%% kinwave
% //    Description:
% //        -Kinematic wave flow routing 
% //    Update History
% =============================================================
%
global WX WT Epsil Beta1
WX=0.6;
WT=0.6;
Epsil=9.290304e-5;
TINY =1e-6;
C1=0;
C2=0;
Afull=0;
Qfull=0;

[qoutflow,result]=kinwave_execute(qinflow, tStep);
function [qoutflow,result]=kinwave_execute(qinflow,tStep)
    result=1;
    pXsect = tuberia.seccion;
    Qfull = tuberia.qFull;
    Afull = tuberia.seccion.aFull;
    Beta1 = tuberia.beta / Qfull;

    q1 = tuberia.q1(iteracion,2) / Qfull;
    q2 = tuberia.q2(iteracion,2) / Qfull;
    q3=0;

    qin = (qinflow) / Qfull;

    a1 = tuberia.a1(iteracion,2) / Afull;
    a2 = tuberia.a2(iteracion,2) / Afull;

    if ( qin >= 1.0 ) 
        ain = 1.0;
    else
        ain = xsect_getAofS(pXsect, qin/Beta1) / Afull;
    end
        
    if ( qin <= TINY && q2 <= TINY )
        qout = 0.0;
        aout = 0.0;
    else

        dxdt = getLength(tuberia) / tStep * Afull / Qfull;
        dq   = q2 - q1;
        C1   = dxdt * (WT / WX);
        C2   = (1.0 - WT) * (ain - a1);
        C2   = C2 - WT * a2;
        C2   = C2 * dxdt / WX;
        C2   = C2 + (1.0 - WX) / WX * dq - qin;
        C2   = C2 + q3 / WX;

        aout = a2;

        [aout,result] = solveContinuity(qin,ain,aout);

        if ( result == -1 )
            result=1;
        end
        if ( result <= 0 ) 
            result = 1;
        end

        qout = Beta1 * xsect_getSofA(pXsect, aout*Afull);
        if ( qin > 1.0 ) 
            qin = 1.0;
        end
    end
        
        tuberia.q1(iteracion+1,2) = qin * Qfull;
        tuberia.a1(iteracion+1,2) = ain * Afull;
        tuberia.q2(iteracion+1,2) = qout * Qfull;
        tuberia.a2(iteracion+1,2) = aout * Afull;
        qinflow  = tuberia.q1(iteracion+1,2);
        qoutflow = tuberia.q2(iteracion+1,2);
        return     
end


function [aout,n]=solveContinuity(qin,ain,aout)
tol = Epsil; 
     
aHi = 1.0;
fHi = 1.0 + C1 + C2;   
aLo =(tuberia.seccion.aMax) / Afull;
if ( aLo < aHi )
    fLo = ( Beta1 * tuberia.seccion.sMax ) + (C1 * aLo) + C2;
else
    fLo = fHi;
end     
if ( fHi*fLo > 0.0 )
    aHi = aLo;
    fHi = fLo;
    aLo = 0.0;
    fLo = C2;
end             

if ( fHi*fLo <= 0.0 )

    if ( aout < aLo || aout > aHi ) 
        aout = 0.5*(aLo + aHi);
    end
    if ( fLo > fHi )
        aTmp = aLo;
        aLo  = aHi;
        aHi  = aTmp;
    end
    [n,aout] = findroot_Newton2(aLo, aHi, aout, tol);
    if ( n <= 0 ) 
        n = -1;
    end
elseif ( fLo < 0.0 )
    if ( qin > 1.0 ) 
        aout = ain;
    else
        aout = 1.0;
    end 
            n = -2;
elseif ( fLo > 0 )
    aout = 0.0;
    n = -3;
else
    n = -1;
       
end
   return  
end


function [n,rts]=findroot_Newton2(x1,x2,rts,xacc) 
MAXIT=80;
n=0;
x = rts;
xlo = x1;
xhi = x2;
dxold = abs(x2-x1);
dx = dxold;
[f,df]=evalContinuity(x);
n=n+1;

for pp=1:MAXIT
    if ( ( ( (x-xhi)*df-f)*((x-xlo)*df-f) >= 0.0 || (abs(2.0*f) > abs(dxold*df) ) ) )
        dxold = dx;
        dx = 0.5*(xhi-xlo);
        x = xlo + dx;
        if ( xlo == x ) 
            break;
        end
    else
        dxold = dx;
        dx = f/df;
        temp = x;
        x =x- dx;
        if ( temp == x ) 
            break;
        end
    end
    if ( abs(dx) < xacc )
        break;
    end
    [f,df]=evalContinuity(x);
    n=n+1;
    if ( f < 0.0 ) 
        xlo = x;
    else
        xhi = x;
    end
end

rts = x;
if ( n <= MAXIT)
    return
else
n=0;
    return
end

end

% //=============================================================================

function [f,df]=evalContinuity(a)
% //
% //  Input:   a = outlet normalized area
% //  Output:  f = value of continuity eqn.
% //           df = derivative of continuity eqn.
% //  Purpose: computes value of continuity equation (f) and its derivative (df)
% //           w.r.t. normalized area for link with normalized outlet area 'a'.

    f  = (Beta1 * xsect_getSofA(tuberia.seccion, a*Afull)) + (C1 * a) + C2;
    df = (Beta1 * Afull * xsect_getdSdA(tuberia.seccion, a*Afull)) + C1;

end

end


