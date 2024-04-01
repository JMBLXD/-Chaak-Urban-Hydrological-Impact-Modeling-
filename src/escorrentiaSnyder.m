classdef escorrentiaSnyder
%% Snyder runoff method
% //    Description:
% //        -Runoff method
% //    Update History
% =============================================================
%
    properties
        metodo  % Runoff method
        tp      % Peak time
        cp      % Peak coefficient
    end

    methods
        function obj = escorrentiaSnyder(metodo,tp,cp)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.metodo=metodo;
            obj.tp=tp;
            obj.cp=cp;
        end

    end
end