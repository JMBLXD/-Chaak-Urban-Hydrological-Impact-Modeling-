classdef escorrentiaConocido
%% Hydrogram data
% //    Description:
% //        -Runoff method
% //    Update History
% =============================================================
%
    properties
        metodo  % Method
        datos   % Data (m3/s)
    end

    methods
        function obj = escorrentiaConocido(metodo,datos)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %    
            obj.metodo=metodo;
            obj.datos=datos;
        end

    end
end