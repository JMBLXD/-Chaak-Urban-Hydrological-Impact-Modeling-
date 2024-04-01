function [ hidro ] = Odesolve(n,alpha1,Dstore1,eps,h1,yini,HPEfectiva,j,cuenca)
%% Odesolve
% //    Description:
% //        -Get kinematic wave runoff 
% //    Update History
% =============================================================
%
MAXSTP=200;
TINY=1e-30;
SAFETY=0.9;
PGROW=-0.2;
PSHRNK=-0.25;
ERRCON=(5/SAFETY)^(1/PGROW);
nmax=n;
y=[];
alpha=alpha1;
Dstore=Dstore1;
ystart=yini;
yscal=[];
h=h1;
x1=HPEfectiva(j,1);
x2=HPEfectiva(j+1,1);

ix=HPEfectiva(j,2)/(x2-x1);
fx=cuenca.f;

[hidro]=odesolve_integrate(n,x1,x2,eps,h1);

function [hidro,Res]=odesolve_integrate(n,x1,x2,eps,h1)
        hidro=[];
        x=x1;
        h=h1;
        if (nmax<n)
            Res= 1;
            return;
        end
        y=ystart;
        for nstep=1:1:MAXSTP

            dydx=derivs(x,y);
            yscal= abs(y)+abs(dydx*h) + TINY;
            if ((x+h-x2)*(x+h-x1) > 0.0) 
                h = x2 - x;
            end
            [x,hdid,hnext,errcode] = rkqs(x,h,eps);

            if errcode~=0
                break;
            end
            if ((x-x2)*(x2-x1) >= 0.0)
                ystart=y;
                Res=0;
                
            end
            if abs(hnext<=0)
                Res=2;
                break;
            end
                h = hnext;
                if y<0
                    y=0;
                end
                hidro=[hidro;nstep,x,y];

        end



    end

    function dddt= derivs(x,y)
        
        rx=y-Dstore;        
        if rx<0
            rx=0;
        else
            rx=alpha*rx^(5/3);
        end
        dddt=ix-rx-fx;
    end

    function [x,hdid,hnext,bandera]=rkqs(x,htry,eps)
        xold=x;
        h=htry;
        bandera=2;
        while bandera~=0
            [ytemp,yerr]=rkck(xold, h);
            errmax=0;
            err=abs(yerr/yscal);
            if (err>errmax)
                errmax=err;
            end
            errmax=errmax/eps;
            if (errmax>1)
                htemp = SAFETY*h*errmax^PSHRNK;
                if h>0
                    if (htemp > 0.1*h)
                        h=htemp;
                    else
                        h=0.1*h;
                    end
                else
                    if (htemp < 0.1*h)
                        h=htemp;
                    else
                        h=0.1*h;
                    end
                end
                xnew = xold + h;
                if (xnew == xold)
                    bandera=2;
                end
                continue;
            else
                if (errmax > ERRCON)
                    hnext = SAFETY*h*errmax^PGROW;
                else
                    hnext = 5.0*h;
                end
                    hdid=h;
                    x=x+hdid;
                    y=ytemp;
                    bandera=0;
            end
             
        end
    end

    function [ytemp,yerr]=rkck(x,h)
        a2=0.2;
        a3=0.3;
        a4=0.6;
        a5=1.0;
        a6=0.875;
        b21=0.2;
        b31=3.0/40.0;
        b32=9.0/40.0;
        b41=0.3;
        b42= -0.9;
        b43=1.2;
        b51= -11.0/54.0;
        b52=2.5;
        b53= -70.0/27.0;
        b54=35.0/27.0;
        b61=1631.0/55296.0;
        b62=175.0/512.0;
        b63=575.0/13824.0;
        b64=44275.0/110592.0;
        b65=253.0/4096.0;
        c1=37.0/378.0;
        c3=250.0/621.0;
        c4=125.0/594.0;
        c6=512.0/1771.0;
        dc5= -277.0/14336.0;
        dc1=c1-2825.0/27648.0;
        dc3=c3-18575.0/48384.0;
        dc4=c4-13525.0/55296.0;
        dc6=c6-0.25;

        ak1=derivs(x,y);
        ak2=derivs(x+a2*h,y + b21*h*ak1);
        ak3=derivs(x+a3*h,y +h*(b31*ak1+b32*ak2));
        ak4=derivs(x+a4*h,y + h*(b41*ak1+b42*ak2 + b43*ak3));
        ak5=derivs(x+a5*h,y + h*(b51*ak1+b52*ak2 + b53*ak3 + b54*ak4));
        ak6=derivs(x+a6*h,y + h*(b61*ak1+b62*ak2 + b63*ak3 + b64*ak4+ b65*ak5));
        ytemp= y + h*(c1*ak1 + c3*ak3 + c4*ak4 + c6*ak6);
        yerr= h*(dc1*ak1 +dc3*ak3 + dc4*ak4 + dc5*ak5 + dc6*ak6);
    end

function f1=curvenum_getInfil(infil)
    f1=0;
    fa = ix + y/h;
    if ix>0 
        if infil.T >= infil.Max
            infil.P=0;
            infil.F=0;
            infil.f=0;
            infil.Se=infil.S;
        end
        infil.T=0;
        infil.P=infil.P+ ix*h;
        F1 = infil.P * (1.0 - infil.P / (infil.P + infil.Se));
        f1 = (F1 - infil.F) / h;
        if ( f1 < 0.0 || infil.S <= 0.0 ) 
            f1 = 0.0;
        end
    else
        if ( y > 1.3e-3 && infil.S > 0.0 )
            f1 = infil.f;
            if ( f1*h > infil.S ) 
                f1 = infil.S / h;
            end
        else
            infil.T =infil.T+h;
        end
    end
       if ( f1 > 0.0 )
        f1 = min(f1, fa);
        f1 = max(f1, 0);

        infil.F =infil.F+ f1 * h;

        if ( infil.regen > 0.0 )
            infil.S=infil.S- f1 * h;
            if ( infil.S < 0.0 ) 
                infil.S = 0.0;
            end
        end
       else
       infil.S=infil.S + infil.regen * infil.Smax * h;
        if ( infil.S > infil.Smax ) 
            infil.S = infil.Smax;
        end
        infil.f = f1;
       end
end

end
