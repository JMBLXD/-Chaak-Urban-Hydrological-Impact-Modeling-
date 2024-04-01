classdef tormentaH
%% Storm element
% //    Description:
% //        -Storm object
% //        -Equation form i = K(tr^m)/(b+d)^n 
% //    Update History
% =============================================================
%    
    properties
        ID                          % Identifier
        k                           % Coefficient
        m                           % Exponente
        n                           % Exponent
        b                           % Constant
        tipo                        % Format storm 
        tr                          % Return period (years)
        duracion                    % Duration (min)
        dt                          % Interval (min)
        metodoHietograma='none';    % Hyetogram method
        fechaInicio=''              % Date start
        horaInicio                  % hour start
        minInicio                   % Minute start
        inicioTormenta              % Start
        duracionHietograma          % Duration
        hietograma                  % Data hyetogram (pricipitation: mm, time: s)
        hietogramaSimulacion        % Data hyetogram (precipitation:m, time: s)
        precipitacionTotal          % Cumulative precipitation (mm)

    end

    methods
       function obj=tormentaH(id,tipo,varargin)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.ID=id;
            obj.tipo=tipo;
            switch tipo
                case 'EcuacionGen'
                    obj.k=varargin{1};
                    obj.m=varargin{2};
                    obj.n=varargin{3};
                    obj.b=0;
                case 'EcuacionChen'
                    obj.k=varargin{1};
                    obj.m=varargin{2};
                    obj.n=varargin{3};
                    obj.b=varargin{4};
                case 'hietograma'
                    obj.metodoHietograma='conocido';
            end

       end

        function obj = generarHietograma(obj)
        % //    Description:
        % //        -Get hyetograph 
        % //    Update History
        % =============================================================
        %
            idf=[obj.k,obj.m,obj.n,obj.b];
            switch obj.metodoHietograma
                case 'simetrico'
                    obj.hietograma =hietogramaSimetrico(obj.tipo,obj.duracion,obj.dt,idf,obj.tr);
                case 'bloques alternos'
                    obj.hietograma =bloquesAlternos(obj.tipo,obj.duracion,obj.dt,idf,obj.tr);
            end
            obj.precipitacionTotal=sum(obj.hietograma(:,2));
            obj.duracionHietograma=obj.hietograma(end,1);
            obj.hietogramaSimulacion=obj.hietograma;
            obj.hietogramaSimulacion(:,1)=obj.hietograma(:,1)*60;
            obj.hietogramaSimulacion(:,2)=(obj.hietograma(:,2)/1000);
        end 
    end
end