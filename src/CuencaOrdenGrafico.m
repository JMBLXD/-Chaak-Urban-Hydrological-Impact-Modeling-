function Orden = CuencaOrdenGrafico(VPermutar,Fondo)
%% CuencaOrdenGrafico
% //    Description:
% //        -Swap graphics (model view)
% //    Update History
% =============================================================
%
if ~isempty(Fondo)
    Tamano=size(VPermutar,1);
    Longitud=(5:1:Tamano);
    cuenca=(1:1:4);
    Orden=[Longitud(1:end-1),cuenca,Longitud(end)];
else
    Tamano=size(VPermutar,1);
    Longitud=(5:1:Tamano);
    cuenca=(1:1:4);
    Orden=[Longitud(1:end),cuenca]; 
end
end

