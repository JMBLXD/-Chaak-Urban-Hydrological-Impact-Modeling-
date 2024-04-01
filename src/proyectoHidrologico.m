classdef proyectoHidrologico
%% Project information
% //    Description:
% //        -Project object
% //    Update History
% =============================================================
% 
    properties
        nombre              % Name of the main file with extension
        carpetaBase         % Project folder
        nombreHidrologico   % Name of the main file without extension
    end
    methods
        function obj = proyectoHidrologico(nombre,carpetaBase)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.nombre = nombre;
            obj.carpetaBase = carpetaBase;
        end
    end
end