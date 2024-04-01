classdef escorrentiaOC
%% Kinematic wave runoff method
% //    Description:
% //        -Runoff method
% //    Update History
% =============================================================
%
    properties
        metodo              % Runoff method
        ancho               % Overland flow width (m)
        pendiente           % Slope (m/m)
        zonaImpermeable     % Fraction impervious (%)
        nPermeable          % Roughness pervious area
        nImpermeable        % Roughness impervious area
        dImpermeable        % Depression storage impervious area (m)  
        dPermeable          % Depression storage pervious area (m)   
        sdImpermeable       % Impervious area with no depression storage (%)
        subAreas            % Subareas
        areaPerm            % Pervious area (m2)
        areaImp             % Impervious area (m2)
        areaSDImp           % Sd-impervious area (m2)
    end

    methods
        function obj = escorrentiaOC(metodo,ancho,pendiente,zonaImpermeable,nPermeable,nImpermeable,dImpermeable,dPermeable,sdImpermeable)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.metodo=metodo;
            obj.ancho=ancho;
            obj.pendiente=pendiente;
            obj.zonaImpermeable=min(zonaImpermeable,100);
            obj.nPermeable=nPermeable;
            obj.nImpermeable=nImpermeable;
            obj.dImpermeable=dImpermeable;
            obj.dPermeable=dPermeable;
            obj.sdImpermeable=sdImpermeable;  
        end
        function obj=areaDrenado(obj,cuenca)
        % //    Description:
        % //        -Convert units area 
        % //    Update History
        % =============================================================
        %
            obj.areaPerm=(cuenca.area*(1-obj.zonaImpermeable/100))*10000;
            obj.areaImp=(cuenca.area*obj.zonaImpermeable/100)*(1-obj.sdImpermeable/100)*10000;
            obj.areaSDImp=cuenca.area*(obj.zonaImpermeable/100)*(obj.sdImpermeable/100)*10000;
        end
    end
end