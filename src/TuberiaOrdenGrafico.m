function Orden = TuberiaOrdenGrafico(VPermutar,MCuencas,Fondo)
%% TuberiaOrdenGrafico
% //    Description:
% //        -Swap graphics (model view)
% //    Update History
% =============================================================
%
if ~isempty(Fondo)
    NCuencas=size(MCuencas,2)*4;
    Tamano=size(VPermutar,1);
    Longitud=(3:1:Tamano);
    Tuberia=(1:1:2);
    Orden=[Longitud(1:end-NCuencas),Tuberia,Longitud(end-NCuencas:end)];
elseif ~isempty(MCuencas)
    NCuencas=size(MCuencas,2)*4;
    Tamano=size(VPermutar,1);
    Longitud=(3:1:Tamano);
    Tuberia=(1:1:2);
    Orden=[Longitud(1:end-NCuencas),Tuberia,Longitud(end-NCuencas:end)];
else
    NCuencas=size(MCuencas,2)*4;
    Tamano=size(VPermutar,1);
    Longitud=(3:1:Tamano);
    Tuberia=(1:1:2);
    Orden=[Longitud(1:end-NCuencas),Tuberia];
end

end

