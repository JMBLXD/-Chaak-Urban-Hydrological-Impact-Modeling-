function varargout = moduloHidrologico(varargin)
%% Chaak: Urban Hydrological Impact Modeling
% //    Description:
% //        -Chaak: Urban Hydrological Impact Modeling is a simulation, analysis, and modeling tool for stormwater drainage networks
% //         -Its main objective is to analyze the UHI of a watershed and assess its approach to ZHI through the implementation of SUDS
% //    Update History
% =============================================================
% //	Date          Version     Author                     Notes
% //	21/01/2024    1.00        Becerril Lara Juan Manuel  Initial release
% //	                          Salinas Tapia Humberto  
% //	                          Diaz Delgado Carlos  
% //	                          Garcia Pulido Daury  
%% Credits:
%   TabManager function:
%       Grant (2024). TabManager - Create Tab Panels (uitabgroup) from a GUIDE GUI 
%          (https://www.mathworks.com/matlabcentral/fileexchange/54705-tabmanager-create-tab-panels-uitabgroup-from-a-guide-gui), 
%          MATLAB Central File Exchange. Recuperado January 29, 2024.
%
%   myginput function:
%       Frederic Moisy (2024). MYGINPUT (https://www.mathworks.com/matlabcentral/fileexchange/12770-myginput), 
%           MATLAB Central File Exchange. Recuperado January 29, 2024.
%
%   findjobj function:     
%       Yair Altman (2024). findjobj - find java handles of Matlab graphic objects 
%           (https://www.mathworks.com/matlabcentral/fileexchange/14317-findjobj-find-java-handles-of-matlab-graphic-objects), 
%           MATLAB Central File Exchange. Recuperado January 29, 2024.
%
%   The solution methods for runoff processes and hydraulic transit were based on those used by the Storm Water Management Model (SWMM) 
%   developed by the United States Environmental Protection Agency (EPA).
%   For more information refer to: https://www.epa.gov/water-research/storm-water-management-model-swmm
%%


% MODULOHIDROLOGICO MATLAB code for moduloHidrologico.fig
%      MODULOHIDROLOGICO, by itself, creates a new MODULOHIDROLOGICO or raises the existing
%      singleton*.
%
%      H = MODULOHIDROLOGICO returns the handle to a new MODULOHIDROLOGICO or the handle to
%      the existing singleton*.
%
%      MODULOHIDROLOGICO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODULOHIDROLOGICO.M with the given input arguments.
%
%      MODULOHIDROLOGICO('Property','Value',...) creates a new MODULOHIDROLOGICO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before moduloHidrologico_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to moduloHidrologico_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help moduloHidrologico

% Last Modified by GUIDE v2.5 08-Feb-2024 21:59:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @moduloHidrologico_OpeningFcn, ...
                   'gui_OutputFcn',  @moduloHidrologico_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before moduloHidrologico is made visible.
function moduloHidrologico_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to moduloHidrologico (see VARARGIN)

movegui('center');

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','chaakIcon.png'));
jframe.setFigureIcon(jIcon);

handles.tabManager = TabManager( hObject );
tabGroups = handles.tabManager.TabGroups;
for tgi=1:length(tabGroups)
    set(tabGroups(tgi),'SelectionChangedFcn',@tabChangedCB);
end
set(tabGroups,'visible','off')
pause(0.5)
% Choose default command line output for moduloHidrologico
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

estadoBotones('desactivar',handles)

axes(handles.fondoInicio)
img=imread(fullfile('data','IHU_Fondo.png')); 
imshow(img);
ax = gca;
ax.Toolbar.Visible = 'off';

axes(handles.axes1)
ax = gca;
ax.Interactions = [panInteraction zoomInteraction];
xlim auto
ylim auto
axis equal
axes(handles.axes2)
ax = gca;
ax.Interactions = [panInteraction zoomInteraction];
xlim auto
ylim auto
zoom(gcf,'reset');
axes(handles.axes5)
ax = gca;
ax.Interactions = [panInteraction zoomInteraction];
xlim auto
ylim auto
zoom(gcf,'reset');


% --- Outputs from this function are returned to the command line.
function varargout = moduloHidrologico_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global idioma
% set(handles.moduloHidrologico,'Visible','off')
if strcmp(idioma,'english')
    menuArbol(hObject, eventdata, handles)
    setIngles(handles)
else
    menuArbolEsp(hObject, eventdata, handles)
    setEspanol(handles)
end

jFrame = get(handle(gcf),'JavaFrame');
jMenuBar = jFrame.fHG2Client.getMenuBar;
jArchivo = jMenuBar.getComponent(0);
jNuevo= jArchivo.getMenuComponent(0);
jAbrir= jArchivo.getMenuComponent(1);
jImportar= jArchivo.getMenuComponent(2);
jBackground= jArchivo.getMenuComponent(3);
jGuardar= jArchivo.getMenuComponent(4);
jExit= jArchivo.getMenuComponent(5);
jNuevo.setIcon(javax.swing.ImageIcon(fullfile('data','crear.png')));
jAbrir.setIcon(javax.swing.ImageIcon(fullfile('data','open.png')));
jImportar.setIcon(javax.swing.ImageIcon(fullfile('data','importar.png')));
jBackground.setIcon(javax.swing.ImageIcon(fullfile('data','background.png')));
jGuardar.setIcon(javax.swing.ImageIcon(fullfile('data','guardar15.png')));
jExit.setIcon(javax.swing.ImageIcon(fullfile('data','close.png')));

jResultados = jMenuBar.getComponent(2);
jImpacto=jResultados.getMenuComponent(0);
jGrafico=jResultados.getMenuComponent(1);
jTablaR= jResultados.getMenuComponent(2);
jSHP= jResultados.getMenuComponent(3);
jMat=jResultados.getMenuComponent(4);
jImpacto.setIcon(javax.swing.ImageIcon(fullfile('data','impactoR.png')));
jGrafico.setIcon(javax.swing.ImageIcon(fullfile('data','graficoR.png')));
jTablaR.setIcon(javax.swing.ImageIcon(fullfile('data','resumen.png')));
jSHP.setIcon(javax.swing.ImageIcon(fullfile('data','shp.png')));
jMat.setIcon(javax.swing.ImageIcon(fullfile('data','mat.png')));


colormapNames={fullfile('data',['colormap_','autumn','.png']),fullfile('data',['colormap_','bone','.png']),fullfile('data',['colormap_','cool','.png']),...
    fullfile('data',['colormap_','copper','.png']),fullfile('data',['colormap_','gray','.png']),fullfile('data',['colormap_','hot','.png']),fullfile('data',['colormap_','hsv','.png']),...
    fullfile('data',['colormap_','jet','.png']),fullfile('data',['colormap_','parula','.png']),fullfile('data',['colormap_','pink','.png']),fullfile('data',['colormap_','spring','.png']),...
    fullfile('data',['colormap_','summer','.png']),fullfile('data',['colormap_','turbo','.png']),fullfile('data',['colormap_','winter','.png'])};
htmlStrings = strcat('<html><img width=190 height=20 src="file:',colormapNames,'">');

set(handles.popupmenu19,'String',htmlStrings)

set(handles.panelNodos,'visible','on');
set(handles.panelTuberias,'visible','on');
set(handles.panelCuencas,'visible','on');
set(handles.panelTormentas,'visible','on');

set(handles.panelSCS,'visible','on');
set(handles.panelGeneral,'visible','on');
set(handles.panelTiempo,'visible','on');
set(handles.panelODinamica,'visible','on');
set(handles.panelEscenarios,'visible','on');
set(handles.panelAnimacionPlanta,'visible','on');
set(handles.panelAnimacionPerfil,'visible','on');

set(handles.gen_retencion,'visible','on');
set(handles.gen_detencion,'visible','on');
set(handles.gen_infiltracion,'visible','on');

u{1}=findjobj(handles.panelNodos);
u{2}=findjobj(handles.panelTuberias);
u{3}=findjobj(handles.panelCuencas);
u{4}=findjobj(handles.panelTormentas);
u{5}=findjobj(handles.panelSCS);
u{6}=findjobj(handles.panelGeneral);
u{7}=findjobj(handles.panelTiempo);
u{8}=findjobj(handles.panelODinamica);
u{9}=findjobj(handles.panelEscenarios);
u{10}=findjobj(handles.panelAnimacionPlanta);
u{11}=findjobj(handles.panelAnimacionPerfil);
u{12}=findjobj(handles.gen_retencion);
u{13}=findjobj(handles.gen_detencion);
u{14}=findjobj(handles.gen_infiltracion);

cuestion={handles.panelNodos,handles.panelTuberias,handles.panelCuencas,handles.panelTormentas,handles.panelSCS,handles.panelGeneral,...
    handles.panelTiempo,handles.panelODinamica,handles.panelEscenarios,handles.panelAnimacionPlanta,handles.panelAnimacionPerfil...
    handles.gen_retencion,handles.gen_detencion,...
    handles.gen_infiltracion};

for i=1:length(u)
    panel=javax.swing.JScrollPane(u{i});
    jScrollPanel = javaObjectEDT(panel);
    [jj,hh]=javacomponent(jScrollPanel,[0 0 260 450],handles.moduloHidrologico);
    hh.SizeChangedFcn = @repaintScrollPane;
    jj.repaint;
    hLink = linkprop([cuestion{i},hh],'Visible');
    setappdata(cuestion{i},'attachScrollPanelToLink',hLink);
end

set(handles.slider28, 'Min', 0);
set(handles.slider28, 'Max', 1);
set(handles.slider28, 'SliderStep', [0.5,0.5]);
set(handles.slider28, 'Value', 0.5);

set(handles.slider25, 'Min', 0);
set(handles.slider25, 'Max', 1);
set(handles.slider25, 'SliderStep', [0.5,0.5]);
set(handles.slider25, 'Value', 0.5);

set(handles.slider27, 'Min', 0);
set(handles.slider27, 'Max', 1);
set(handles.slider27, 'SliderStep', [0.5,0.5]);
set(handles.slider27, 'Value', 0.5);

set(handles.slider35, 'Min', 0);
set(handles.slider35, 'Max', 1);
set(handles.slider35, 'SliderStep', [0.5,0.5]);
set(handles.slider35, 'Value', 0.5);

set(handles.slider36, 'Min', 0);
set(handles.slider36, 'Max', 1);
set(handles.slider36, 'SliderStep', [0.5,0.5]);
set(handles.slider36, 'Value', 0.5);

set(handles.slider37, 'Min', 0);
set(handles.slider37, 'Max', 1);
set(handles.slider37, 'SliderStep', [0.5,0.5]);
set(handles.slider37, 'Value', 0.5);

set(handles.slider41, 'Min', 0);
set(handles.slider41, 'Max', 1);
set(handles.slider41, 'SliderStep', [0.5,0.5]);
set(handles.slider41, 'Value', 0.5);

set(handles.slider42, 'Min', 0);
set(handles.slider42, 'Max', 1);
set(handles.slider42, 'SliderStep', [0.5,0.5]);
set(handles.slider42, 'Value', 0.5);

set(handles.slider43, 'Min', 0);
set(handles.slider43, 'Max', 1);
set(handles.slider43, 'SliderStep', [0.5,0.5]);
set(handles.slider43, 'Value', 0.5);

set(handles.slider46, 'Min', 0);
set(handles.slider46, 'Max', 1);
set(handles.slider46, 'SliderStep', [0.5,0.5]);
set(handles.slider46, 'Value', 0.5);

set(handles.slider45, 'Min', 0);
set(handles.slider45, 'Max', 1);
set(handles.slider45, 'SliderStep', [0.5,0.5]);
set(handles.slider45, 'Value', 0.5);

set(handles.panelNodos,'visible','off');
set(handles.panelTuberias,'visible','off');
set(handles.panelCuencas,'visible','off');
set(handles.panelTormentas,'visible','off');
set(handles.panelSCS,'visible','off');
set(handles.panelGeneral,'visible','off');
set(handles.panelTiempo,'visible','off');
set(handles.panelODinamica,'visible','off');
set(handles.panelEscenarios,'visible','off');
set(handles.panelAnimacionPlanta,'visible','off');
set(handles.panelAnimacionPerfil,'visible','off');
set(handles.gen_retencion,'visible','off');
set(handles.gen_detencion,'visible','off');
set(handles.gen_infiltracion,'visible','off');

jButton = java(findjobj(handles.simular));
jButton.setIcon(javax.swing.ImageIcon(fullfile('data','simular.png')));
jButton.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
jButton.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);

set(handles.moduloHidrologico,'Visible','on')
% Get default command line output from handles structure
varargout{1} = handles.output;

%% Language
% //    Description:
% //        -Language spanish
% //    Update History
% =============================================================
% 
function setEspanol (handles)
load(fullfile('data','idioma.mat'),'stringEsp');

for i=1:size(stringEsp)
    if ~isempty(stringEsp{i,1})
        a = findobj('Tag',stringEsp{i,1});
        try
            a.String=stringEsp{i,2};
        end
        try
            a.Tooltip=stringEsp{i,3};
        end
    end
end

set(findall(gcf,'tag','Untitled_1'),'Label','<html><center/><font face="Open Sans" size=4><b><i>Archivo</html>');
set(findall(gcf,'tag','Untitled_9'),'Label','<html><center/><font face="Open Sans" size=4><b><i>Capas</html>');
set(findall(gcf,'tag','Untitled_10'),'Label','<html><center/><font face="Open Sans" size=4><b><i>Resultados</html>');

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Nodo<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Coordenada<br />X</html>','<html><center /><font face="Open Sans" size=4><b><i>Coordenada<br />Y</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Terreno<br />(m)</html>','<html><center /><font face="Open Sans" size=4><b><i>Rasante<br />(m)</html>'...
    '<html><center /><font face="Open Sans" size=4><b><i>Profundidad<br />(m)</html>'};
set(handles.tablaNodos,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Tubería<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Nodo<br/>inicial</html>','<html><center/><font face="Open Sans" size=4><b><i>Nodo<br />final</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Sección</html>','<html><center /><font face="Open Sans" size=4><b><i>Profundidad<br />(m)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Longitud<br/>(m)</html>','<html><center/><font face="Open Sans" size=4><b><i>Rugosidad<br/>(n)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Elevación<br/>entrada (m)</html>','<html><center/><font face="Open Sans" size=4><b><i>Elevación<br/>salida (m)</html>'};
set(handles.tablaTuberias,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Cuenca<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Nodo<br />descarga</html>','<html><center /><font face="Open Sans" size=4><b><i>Área<br />(ha)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Método<br />escorrentÃ­a</html>','<html><center /><font face="Open Sans" size=4><b><i>Método<br />infiltración</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Tormenta</html>','<html><center /><font face="Open Sans" size=4><b><i>SUDS<br />Área (%)</html>'};
set(handles.tablaCuencas,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Cuenca<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Nodo<br />descarga</html>','<html><center /><font face="Open Sans" size=4><b><i>Área<br />(ha)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Método<br/>escorrentÃ­a</html>','<html><center /><font face="Open Sans" size=4><b><i>Método<br />infiltración</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Tormenta</html>'};
set(handles.tablaCuencasR,'ColumnName',headers)
set(handles.tablaCuencasR,'Data',[])

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Tormenta<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Periodo de<br />retorno (años)</html>','<html><center /><font face="Open Sans" size=4><b><i>Duración<br />(min)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Intervalo<br/>análisis (min)</html>','<html><center /><font face="Open Sans" size=4><b><i>Hietograma</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Fecha<br />(dd/mm/yyyy)</html>','<html><center /><font face="Open Sans" size=4><b><i>Hora<br />(hh:mm)</html>'};
set(handles.tablaTormentas,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Sistema<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Cuenca<br/>asociada</html>','<html><center /><font face="Open Sans" size=4><b><i>Área<br/>conectada (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Porción<br/>permeable (%)</html>','<html><center /><font face="Open Sans" size=4><b><i>Porción<br/>impermeable (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Capacidad <br/>volumétrica (m3)</html>','<html><center /><font face="Open Sans" size=4><b><i>Ocupación<br/>inicial (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Coeficiente<br/>de captura</html>'};
set(handles.tablaGenRetencion,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Sistema<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Cuenca<br/>asociada</html>','<html><center /><font face="Open Sans" size=4><b><i>Área<br/>conectada (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Porción<br/>permeable (%)</html>','<html><center /><font face="Open Sans" size=4><b><i>Porción<br/>impermeable (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Control <br/>descarga</html>','<html><center /><font face="Open Sans" size=4><b><i>Elevación<br/>inicial (m)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Coeficiente<br/>de captura</html>'};
set(handles.tablaGenDetencion,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Sistema<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Cuenca<br/>asociada</html>','<html><center /><font face="Open Sans" size=4><b><i>Área<br/>conectada (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Porción<br/>permeable (%)</html>','<html><center /><font face="Open Sans" size=4><b><i>Porción<br/>impermeable (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Superficie<br/>(m2)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Infiltración<br/>máxima (mm/h)</html>','<html><center /><font face="Open Sans" size=4><b><i>Coeficiente<br/>de captura</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Control<br/>infiltración</html>'};
set(handles.tablaGenInfiltracion,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Estado</html>','<html><center /><font face="Open Sans" size=4><b><i>Nombre</html>'};
set(handles.tablaEscenarios,'ColumnName',headers)
set(handles.tablaEscenarios,'Data',[])

set(handles.crearProyecto,'Text','Nuevo')
set(handles.abrirProyecto,'Text','Abrir')
set(handles.Untitled_5,'Text','Importar')
set(handles.Untitled_43,'Text','Eliminar')
set(handles.Untitled_7,'Text','Guardar')
set(handles.Untitled_8,'Text','Salir')
set(handles.cuencasLabel,'Text','Cuencas')

set(handles.layerTuberias,'Text','Tuberías')
set(handles.layerCuencas,'Text','Cuencas')
set(handles.nodosLabel,'Text','Nodos')
set(handles.tuberiasLabel,'Text','Tuberías')
set(handles.cuencasLabel,'Text','Cuencas')

set(handles.Untitled_39,'Text','Impacto hidrológico urbano')
set(handles.Untitled_29,'Text','Gráfico')
set(handles.Untitled_34,'Text','Tabla resumen')
set(handles.Untitled_38,'Text','Exportar modelo SHP')
set(handles.expSystemM,'Text','Exportar modelo MAT')

set(handles.cmLNodos,'Text','Nodos')
set(handles.cmLTuberias,'Text','Tuberías')
set(handles.cmLCuencas,'Text','Cuencas')
set(handles.Untitled_22,'Text','Capas')
set(handles.Untitled_23,'Text','Nodos')
set(handles.Untitled_25,'Text','Tuberías')
set(handles.Untitled_26,'Text','Cuencas')
set(handles.Untitled_28,'Text','Eliminar background')

a=findobj('Title','<html><center/><font face="Open Sans" size=4><b><i>Model</html>');
a.Title='<html><center/><font face="Open Sans" size=4><b><i>Modelo</html>';
b=findobj('Title','<html><center/><font face="Open Sans" size=4><b><i>Plan</html>');
b.Title='<html><center/><font face="Open Sans" size=4><b><i>Planta</html>';
c=findobj('Title','<html><center/><font face="Open Sans" size=4><b><i>Profile</html>');
c.Title='<html><center/><font face="Open Sans" size=4><b><i>Perfil</html>';
%% Language
% //    Description:
% //        -Language english
% //    Update History
% =============================================================
% 
function setIngles(handles)
set(findall(gcf,'tag','Untitled_1'),'Label','<html><center/><font face="Open Sans" size=4><b><i>File</html>');
set(findall(gcf,'tag','Untitled_9'),'Label','<html><center/><font face="Open Sans" size=4><b><i>Layers</html>');
set(findall(gcf,'tag','Untitled_10'),'Label','<html><center/><font face="Open Sans" size=4><b><i>Results</html>');

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Node<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Coordinate<br />X</html>','<html><center /><font face="Open Sans" size=4><b><i>Coordinate<br />Y</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Ground<br />(m)</html>','<html><center /><font face="Open Sans" size=4><b><i>Invert<br />(m)</html>'...
    '<html><center /><font face="Open Sans" size=4><b><i>Depth<br />(m)</html>'};
set(handles.tablaNodos,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Conduit<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Initial<br/>node</html>','<html><center/><font face="Open Sans" size=4><b><i>Final<br />node</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Cross<br/>section</html>','<html><center /><font face="Open Sans" size=4><b><i>Depth<br />(m)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Length<br/>(m)</html>','<html><center/><font face="Open Sans" size=4><b><i>Roughness<br/>(n)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Entry<br/>elevation (m)</html>','<html><center/><font face="Open Sans" size=4><b><i>Exit<br/>elevation (m)</html>'};
set(handles.tablaTuberias,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Catchment<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Outlet<br />node</html>','<html><center /><font face="Open Sans" size=4><b><i>Area<br />(ha)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Runoff<br />method</html>','<html><center /><font face="Open Sans" size=4><b><i>Infiltration<br />method</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Selected <br /> storm </html>','<html><center /><font face="Open Sans" size=4><b><i>SUDS <br />area (%)</html>'};
set(handles.tablaCuencas,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Catchment<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Outlet<br />node</html>','<html><center /><font face="Open Sans" size=4><b><i>Area<br />(ha)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Runoff<br/>method</html>','<html><center /><font face="Open Sans" size=4><b><i>Infiltration<br />method</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Selected<br />storm</html>'};
set(handles.tablaCuencasR,'ColumnName',headers)
set(handles.tablaCuencasR,'Data',[])

headers = {'<html><center /><font face="Open Sans" size=4><b><i>Storm<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Return period<br />(years)</html>','<html><center /><font face="Open Sans" size=4><b><i>Duration<br />(min)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Analysis<br/>interval (min)</html>','<html><center /><font face="Open Sans" size=4><b><i>Hyetograph</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Star date<br />(dd/mm/yyyy)</html>','<html><center /><font face="Open Sans" size=4><b><i>Start time<br />(hh:mm)</html>'};
set(handles.tablaTormentas,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>System<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Related<br/>catchment</html>','<html><center /><font face="Open Sans" size=4><b><i>Related<br/>area (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Pervious<br/>portion (%)</html>','<html><center /><font face="Open Sans" size=4><b><i>Impervious<br/>portion (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Volumetric <br/>capacity (m3)</html>','<html><center /><font face="Open Sans" size=4><b><i>Initial<br/>occupation (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Capture<br/>coefficient</html>'};
set(handles.tablaGenRetencion,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>System<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Related<br/>catchment</html>','<html><center /><font face="Open Sans" size=4><b><i>Related<br/>area (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Pervious<br/>portion (%)</html>','<html><center /><font face="Open Sans" size=4><b><i>Impervious<br/>portion (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Type of <br/>control</html>','<html><center /><font face="Open Sans" size=4><b><i>Initial<br/>elevation (m)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Capture<br/>coefficient</html>'};
set(handles.tablaGenDetencion,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>System<br />ID</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Related<br/>catchment</html>','<html><center /><font face="Open Sans" size=4><b><i>Related<br/>area (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Pervious<br/>portion (%)</html>','<html><center /><font face="Open Sans" size=4><b><i>Impervious<br/>portion (%)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Surface<br/>(m2)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Maximum<br/>infiltration (mm/h)</html>','<html><center /><font face="Open Sans" size=4><b><i>Capture<br/>coefficient</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Type of <br/>control</html>'};
set(handles.tablaGenInfiltracion,'ColumnName',headers)

headers = {'<html><center /><font face="Open Sans" size=4><b><i>State</html>','<html><center /><font face="Open Sans" size=4><b><i>Name</html>'};
set(handles.tablaEscenarios,'ColumnName',headers)
set(handles.tablaEscenarios,'Data',[])

%% Panel display
% //    Description:
% //        -Adjust panel display
% //    Update History
% =============================================================
%  
function repaintScrollPane(hScrollPanel, varargin)
    drawnow
    jScrollPanel = hScrollPanel.JavaPeer;
    offsetX = 0; %or: jScrollPanel.getHorizontalScrollBar.getValue;
    offsetY = 0; %or: jScrollPanel.getVerticalScrollBar.getValue;
    jOffsetPoint = java.awt.Point(offsetX, offsetY);
    jViewport = jScrollPanel.getViewport;
    jViewport.setViewPosition(jOffsetPoint);
    jScrollPanel.repaint;

%% Main menu
% //    Description:
% //        -Create a main menu
% //    Update History
% =============================================================
%
function menuArbol(hObject, eventdata, handles)
    
    import javax.swing.*
    import javax.swing.tree.*;
    
    [I,map] = checkedIcon;
    javaImage_checked = im2java(I,map);
     
    [I,map] = uncheckedIcon;
    javaImage_unchecked = im2java(I,map);
    iconWidth = javaImage_unchecked.getWidth;
    
    sim=uitreenode('v0', 'simulacion','<html><center /><font face="Open Sans"><b><i>Simulation</html>',[], false);
    sim.setIcon(im2java(imread(fullfile('data','drenaje.png'))));
    gen=uitreenode('v0', 'general', 'General options',[], true);
    gen.setIcon(im2java(imread(fullfile('data','configuracion2.png'))));
    sim.add(gen);
    tie=uitreenode('v0', 'tiempo', 'Time parameters',[], true);
    tie.setIcon(im2java(imread(fullfile('data','tiempo.png'))));
    sim.add(tie);
    din=uitreenode('v0', 'odinamica', 'Dynamic wave',[], true);
    din.setIcon(im2java(imread(fullfile('data','dinamica.png'))));
    sim.add(din);

    sud=uitreenode('v0', 'suds','<html><center /><font face="Open Sans"><b><i>SUDS</html>',[], false);
    sud.setIcon(im2java(imread(fullfile('data','suds.png'))));

    genRetention=uitreenode('v0', 'genRetention', 'Retention',[], true);
    genRetention.setIcon(im2java(imread(fullfile('data','tanque.png'))));
    sud.add(genRetention)

    genDetention=uitreenode('v0', 'genDetention', 'Detention',[], true);
    genDetention.setIcon(im2java(imread(fullfile('data','pond.png'))));
    sud.add(genDetention)

    genInfiltration=uitreenode('v0', 'genInfiltration', 'Infiltration',[], true);
    genInfiltration.setIcon(im2java(imread(fullfile('data','infiltracion.png'))));
    sud.add(genInfiltration)

    hidro = uitreenode('v0', 'hidrologico', '<html><center /><font face="Open Sans"><b><i>Hydrologic</html>',[], false);
    hidro.setIcon(im2java(imread(fullfile('data','hidrologico.png'))));
    cue=uitreenode('v0', 'cuenca',  'Catchment',[], true);
    cue.setIcon(im2java(imread(fullfile('data','cuenca.png'))));
    hidro.add(cue);
    tor=uitreenode('v0', 'tormenta','Design storm',[], true);
    tor.setIcon(im2java(imread(fullfile('data','idtr.png'))))
    hidro.add(tor);
    
    hidra = uitreenode('v0', 'hidraulico','<html><center /><font face="Open Sans"><b><i>Hydraulic</html>',[], false);
    hidra.setIcon(im2java(imread(fullfile('data','hidraulico.png'))));
    nod=uitreenode('v0', 'nodo', 'Node',[], true);
    nod.setIcon(im2java(imread(fullfile('data','nodo.png'))))
    hidra.add(nod);
    tub=uitreenode('v0', 'tuberia', 'Conduit',[], true);
    tub.setIcon(im2java(imread(fullfile('data','tuberia.png'))));
    hidra.add(tub);
    
    esc = uitreenode('v0', 'Scenario', '<html><center /><font face="Open Sans"><b><i>Scenarios</html>',[], false);
    esc.setIcon(im2java(imread(fullfile('data','escenarios.png'))));
    res=uitreenode('v0', 'resumen', 'Summary',[], true);
    res.setIcon(im2java(imread(fullfile('data','reporte.png'))));
    esc.add(res)

    capas = uitreenode('v0', 'capas','<html><center /><font face="Open Sans"><b><i>Layers</html>',[], false);
    capas.setIcon(im2java(imread(fullfile('data','layer.png'))));
    
    lnodo=(uitreenode('v0', 'selected','L-Node',[], true));
    lnodo.setIcon(javaImage_checked);
    capas.add(lnodo)
    
    ltub=(uitreenode('v0', 'selected','L-Conduit',[], true));
    ltub.setIcon(javaImage_checked);
    capas.add(ltub)
    
    lcue=(uitreenode('v0', 'selected','L-Catchment',[], true));
    lcue.setIcon(javaImage_checked);
    capas.add(lcue)
    
    lback=(uitreenode('v0', 'selected','L-Background',[], true));
    lback.setIcon(javaImage_checked);
    capas.add(lback)
    
    rnat = uitreenode('v0', 'natural','<html><center /><font face="Open Sans"><b><i>Analysis</html>',[], false);
    rnat.setIcon(im2java(imread(fullfile('data','conocido.png'))));
    hnat=uitreenode('v0', 'scs', 'Natural hydrological response',[], true);
    hnat.setIcon(im2java(imread(fullfile('data','flow.png'))));
    rnat.add(hnat);
    
    animacion = uitreenode('v0', 'animacion','<html><center /><font face="Open Sans"><b><i>Animation</html>',[], false);
    animacion.setIcon(im2java(imread(fullfile('data','animation.png'))));

    planta=uitreenode('v0', 'planta', 'Plan',[], true);
    planta.setIcon(im2java(imread(fullfile('data','street.png'))));
    animacion.add(planta)

    perfil=uitreenode('v0', 'perfil', 'Profile',[], true);
    perfil.setIcon(im2java(imread(fullfile('data','pipe.png'))));
    animacion.add(perfil)

    root = uitreenode('v0', 'Modelo', '<html><center /><font face="Open Sans"><b><i>Model components</html>',[], false);
    root.setIcon(im2java(imread(fullfile('data','modelo.png'))))
    root.add(hidra);
    root.add(hidro);
    root.add(sud);
    root.add(rnat);
    root.add(esc);
    root.add(sim);
    root.add(animacion);
    root.add(capas);
    
    [mtree,container] = uitree('v0', 'Root', root,'Parent', handles.panelMenu);
    set(container, 'Parent', handles.panelMenu);
    mtree.Position = [5,5,255,240];
    mtree.expand(root);
    mtree.expand(hidra);
    mtree.expand(hidro);
    mtree.expand(sud);
    mtree.expand(rnat);
    mtree.expand(esc);
    mtree.expand(sim);
    mtree.expand(animacion);
    mtree.expand(capas);
    set(mtree,'NodeSelectedCallback',@(src, event)myExpandFcn(src, event, handles))
    jtree = handle(mtree.getTree,'CallbackProperties');
    set(jtree, 'MousePressedCallback', @(src, event)mousePressedCallback(src, event, handles));

%% Main menu
% //    Description:
% //        -Create a main menu
% //    Update History
% =============================================================
%
function menuArbolEsp(hObject, eventdata, handles)
    
    import javax.swing.*
    import javax.swing.tree.*;
    
    [I,map] = checkedIcon;
    javaImage_checked = im2java(I,map);
     
    [I,map] = uncheckedIcon;
    javaImage_unchecked = im2java(I,map);
    iconWidth = javaImage_unchecked.getWidth;
    
    sim=uitreenode('v0', 'simulacion','<html><center /><font face="Open Sans"><b><i>Simulación</html>',[], false);
    sim.setIcon(im2java(imread(fullfile('data','drenaje.png'))));
    gen=uitreenode('v0', 'general', 'Opciones generales',[], true);
    gen.setIcon(im2java(imread(fullfile('data','configuracion2.png'))));
    sim.add(gen);
    tie=uitreenode('v0', 'tiempo', 'Parámetros de tiempo',[], true);
    tie.setIcon(im2java(imread(fullfile('data','tiempo.png'))));
    sim.add(tie);
    din=uitreenode('v0', 'odinamica', 'Onda dinámica',[], true);
    din.setIcon(im2java(imread(fullfile('data','dinamica.png'))));
    sim.add(din);

    sud=uitreenode('v0', 'suds','<html><center /><font face="Open Sans"><b><i>SUDS</html>',[], false);
    sud.setIcon(im2java(imread(fullfile('data','suds.png'))));

    genRetention=uitreenode('v0', 'genRetention', 'Retención',[], true);
    genRetention.setIcon(im2java(imread(fullfile('data','tanque.png'))));
    sud.add(genRetention)

    genDetention=uitreenode('v0', 'genDetention', 'Detención',[], true);
    genDetention.setIcon(im2java(imread(fullfile('data','pond.png'))));
    sud.add(genDetention)

    genInfiltration=uitreenode('v0', 'genInfiltration', 'Infiltración',[], true);
    genInfiltration.setIcon(im2java(imread(fullfile('data','infiltracion.png'))));
    sud.add(genInfiltration)

    hidro = uitreenode('v0', 'hidrologico', '<html><center /><font face="Open Sans"><b><i>Hidrológico</html>',[], false);
    hidro.setIcon(im2java(imread(fullfile('data','hidrologico.png'))));
    cue=uitreenode('v0', 'cuenca','Cuenca',[], true);
    cue.setIcon(im2java(imread(fullfile('data','cuenca.png'))));
    hidro.add(cue);
    tor=uitreenode('v0', 'tormenta','Tormenta',[], true);
    tor.setIcon(im2java(imread(fullfile('data','idtr.png'))))
    hidro.add(tor);
    
    hidra = uitreenode('v0', 'hidraulico','<html><center /><font face="Open Sans"><b><i>Hidráulico</html>',[], false);
    hidra.setIcon(im2java(imread(fullfile('data','hidraulico.png'))));
    nod=uitreenode('v0', 'nodo', 'Nodo',[], true);
    nod.setIcon(im2java(imread(fullfile('data','nodo.png'))))
    hidra.add(nod);
    tub=uitreenode('v0', 'tuberia', 'Tubería',[], true);
    tub.setIcon(im2java(imread(fullfile('data','tuberia.png'))));
    hidra.add(tub);
    
    esc = uitreenode('v0', 'Scenario', '<html><center /><font face="Open Sans"><b><i>Escenarios</html>',[], false);
    esc.setIcon(im2java(imread(fullfile('data','escenarios.png'))));
    res=uitreenode('v0', 'resumen', 'Resumen',[], true);
    res.setIcon(im2java(imread(fullfile('data','reporte.png'))));
    esc.add(res)

    capas = uitreenode('v0', 'capas','<html><center /><font face="Open Sans"><b><i>Capas</html>',[], false);
    capas.setIcon(im2java(imread(fullfile('data','layer.png'))));
    
    lnodo=(uitreenode('v0', 'selected','L-Nodo',[], true));
    lnodo.setIcon(javaImage_checked);
    capas.add(lnodo)
    
    ltub=(uitreenode('v0', 'selected','L-Tubería',[], true));
    ltub.setIcon(javaImage_checked);
    capas.add(ltub)
    
    lcue=(uitreenode('v0', 'selected','L-Cuenca',[], true));
    lcue.setIcon(javaImage_checked);
    capas.add(lcue)
    
    lback=(uitreenode('v0', 'selected','L-Background',[], true));
    lback.setIcon(javaImage_checked);
    capas.add(lback)
    
    rnat = uitreenode('v0', 'natural','<html><center /><font face="Open Sans"><b><i>Análisis</html>',[], false);
    rnat.setIcon(im2java(imread(fullfile('data','conocido.png'))));
    hnat=uitreenode('v0', 'scs', 'Respuesta hidrológica natural',[], true);
    hnat.setIcon(im2java(imread(fullfile('data','flow.png'))));
    rnat.add(hnat);
    
    animacion = uitreenode('v0', 'animacion','<html><center /><font face="Open Sans"><b><i>Animación</html>',[], false);
    animacion.setIcon(im2java(imread(fullfile('data','animation.png'))));

    planta=uitreenode('v0', 'planta', 'Planta',[], true);
    planta.setIcon(im2java(imread(fullfile('data','street.png'))));
    animacion.add(planta)

    perfil=uitreenode('v0', 'perfil', 'Perfil',[], true);
    perfil.setIcon(im2java(imread(fullfile('data','pipe.png'))));
    animacion.add(perfil)

    root = uitreenode('v0', 'Modelo', '<html><center /><font face="Open Sans"><b><i>Componentes del modelo</html>',[], false);
    root.setIcon(im2java(imread(fullfile('data','modelo.png'))))
    root.add(hidra);
    root.add(hidro);
    root.add(sud);
    root.add(rnat);
    root.add(esc);
    root.add(sim);
    root.add(animacion);
    root.add(capas);
    
    [mtree,container] = uitree('v0', 'Root', root,'Parent', handles.panelMenu);
    set(container, 'Parent', handles.panelMenu);
    mtree.Position = [5,5,255,240];
    mtree.expand(root);
    mtree.expand(hidra);
    mtree.expand(hidro);
    mtree.expand(sud);
    mtree.expand(rnat);
    mtree.expand(esc);
    mtree.expand(sim);
    mtree.expand(animacion);
    mtree.expand(capas);
    set(mtree,'NodeSelectedCallback',@(src, event)myExpandFcn(src, event, handles))
    jtree = handle(mtree.getTree,'CallbackProperties');
    set(jtree, 'MousePressedCallback', @(src, event)mousePressedCallback(src, event, handles));

%% Uncheck icon
% //    Description:
% //        -Uncheck icon
% //    Update History
% =============================================================
%
function [I,map] = uncheckedIcon()
 I = uint8(...
   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1;
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1;
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1;
    1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]);
 map = ...
  [0.023529,0.4902,0;
   1,1,1;
   0,0,0;
   0.50196,0.50196,0.50196;
   0.50196,0.50196,0.50196;
   0,0,0;
   0,0,0;
   0,0,0];

%% Check icon
% //    Description:
% //        -Check icon
% //    Update History
% =============================================================
%
function [I,map] = checkedIcon()
    I = uint8(...
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0;
     2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,1;
     2,2,2,2,2,2,2,2,2,2,2,2,0,2,3,1;
     2,2,1,1,1,1,1,1,1,1,1,0,2,2,3,1;
     2,2,1,1,1,1,1,1,1,1,0,1,2,2,3,1;
     2,2,1,1,1,1,1,1,1,0,1,1,2,2,3,1;
     2,2,1,1,1,1,1,1,0,0,1,1,2,2,3,1;
     2,2,1,0,0,1,1,0,0,1,1,1,2,2,3,1;
     2,2,1,1,0,0,0,0,1,1,1,1,2,2,3,1;
     2,2,1,1,0,0,0,0,1,1,1,1,2,2,3,1;
     2,2,1,1,1,0,0,1,1,1,1,1,2,2,3,1;
     2,2,1,1,1,0,1,1,1,1,1,1,2,2,3,1;
     2,2,1,1,1,1,1,1,1,1,1,1,2,2,3,1;
     2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1;
     2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1;
     1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1]);
    map = [0.023529,0.4902,0;
        1,1,1;
        0,0,0;
        0.50196,0.50196,0.50196;
        0.50196,0.50196,0.50196;
        0,0,0;
        0,0,0;
        0,0,0];

%% Enable display panel
% //    Description:
% //        -Expand main menu options
% //    Update History
% =============================================================
%
function myExpandFcn(hObject, eventdata, handles)
selectedNodes = hObject.getSelectedNodes;
setPanelVisible(selectedNodes(1).getName.char,handles);

function setPanelVisible(panel,handles)
global ProyectoHidrologico idioma
if isempty(ProyectoHidrologico)
    return
end

if strcmp(panel,'Nodo')
    panel='Node';
elseif strcmp(panel,'Tubería')
    panel='Conduit';
elseif strcmp(panel,'Cuenca')
    panel='Catchment';
elseif strcmp(panel,'Tormenta')
    panel='Design storm';
elseif strcmp(panel,'Retención')
    panel='Retention';
elseif strcmp(panel,'Detención')
    panel='Detention';
elseif strcmp(panel,'Infiltración')
    panel='Infiltration';
elseif strcmp(panel,'Respuesta hidrológica natural')
    panel='Natural hydrological response';
elseif strcmp(panel,'Opciones generales')
    panel='General options';
elseif strcmp(panel,'Parámetros de tiempo')
    panel='Time parameters';
elseif strcmp(panel,'Onda dinámica')
    panel='Dynamic wave';
elseif strcmp(panel,'Resumen')
    panel='Summary';
elseif strcmp(panel,'Planta')
    panel='Plan';
elseif strcmp(panel,'Perfil')
    panel='Profile';
end

switch panel
    case 'Node' 
        set(handles.panelNodos,'visible','on');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    case 'Conduit'
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','on');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
       set(handles.gen_retencion,'visible','off');
       set(handles.gen_detencion,'visible','off');
       set(handles.gen_infiltracion,'visible','off');
    case 'Catchment' 
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','on');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
       set(handles.gen_retencion,'visible','off');
       set(handles.gen_detencion,'visible','off');
       set(handles.gen_infiltracion,'visible','off');
    case 'Design storm' 
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','on');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    case 'Retention'
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','on');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    case 'Detention'
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','on');
        set(handles.gen_infiltracion,'visible','off');
    case 'Infiltration'
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','on');
    case 'Natural hydrological response'
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','on');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');  
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    case 'General options'
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','on');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    case 'Time parameters'
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','on');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    case 'Dynamic wave'
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','on');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    case 'Summary'
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','on');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    case 'Plan'
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');
        if isempty(Scenario)
            if strcmp(idioma,'english')
               Aviso('Simulate hydrological responses','Error','error');
            else
               Aviso('Simular respuesta hidrológica','Error','error');
            end
            return
        end
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','on');
        set(handles.panelAnimacionPerfil,'visible','off');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    case 'Profile'
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');
        if isempty(Scenario)
            if strcmp(idioma,'english')
               Aviso('Simulate hydrological responses','Error','error');
            else
               Aviso('Simular respuesta hidrológica','Error','error');
            end
            return
        end        
        set(handles.panelNodos,'visible','off');
        set(handles.panelTuberias,'visible','off');
        set(handles.panelCuencas,'visible','off');
        set(handles.panelTormentas,'visible','off');
        set(handles.panelSCS,'visible','off');
        set(handles.panelGeneral,'visible','off');
        set(handles.panelTiempo,'visible','off');
        set(handles.panelODinamica,'visible','off');
        set(handles.panelEscenarios,'visible','off');
        set(handles.panelAnimacionPlanta,'visible','off');
        set(handles.panelAnimacionPerfil,'visible','on');
        set(handles.gen_retencion,'visible','off');
        set(handles.gen_detencion,'visible','off');
        set(handles.gen_infiltracion,'visible','off');
    otherwise   
end

%% Main menu: Check/uncheck layer 
% //    Description:
% //        - Mouse inteaction layer options
% //    Update History
% =============================================================
%
function mousePressedCallback(hTree, eventData,handles)
global modelo
clickX = eventData.getX;
clickY = eventData.getY;
treePath = hTree.getPathForLocation(clickX, clickY);
[I,map] = checkedIcon;
javaImage_checked = im2java(I,map);
[I,map] = uncheckedIcon;
javaImage_unchecked = im2java(I,map);
iconWidth = javaImage_unchecked.getWidth;
 
if ~isempty(treePath)

    if clickX <= (hTree.getPathBounds(treePath).x+iconWidth)
        node = treePath.getLastPathComponent;
        nodeValue = node.getValue;
        leyenda=char(node.getName);
        if strcmp(leyenda,'L-Nodo')
            leyenda='L-Node';
        elseif strcmp(leyenda,'L-Tubería')
            leyenda='L-Conduit';
        elseif strcmp(leyenda,'L-Cuenca')
            leyenda='L-Catchment';
        end
        switch nodeValue
          case 'selected'
            node.setValue('unselected');
            node.setIcon(javaImage_unchecked);
            hTree.treeDidChange();

            switch leyenda

                case 'L-Node'
                    set(handles.layerNodos,'Checked','off');
                    set(modelo.graficoNodos,'visible','off');
                    set(modelo.graficoDCuencas,'visible','off');
                    set(modelo.labelNodos,'visible','off');
                    set(handles.nodosLabel,'Checked','off')
                case 'L-Conduit'
                    set(handles.layerTuberias,'Checked','off');
                    set(modelo.graficoTuberias,'visible','off');
                    set(modelo.labelTuberias,'visible','off');
                    set(handles.tuberiasLabel,'Checked','off');
                case 'L-Catchment'
                    set(handles.layerCuencas,'Checked','off');
                    set(modelo.graficoCuencas,'visible','off');
                    set(modelo.graficoDCuencas,'visible','off');
                    set(modelo.graficoCCuencas,'visible','off');
                    set(modelo.labelCuencas,'visible','off');
                    set(handles.cuencasLabel,'Checked','off')
                case 'L-Background'
                    if ~isempty(modelo.background)
                        set(handles.layerFondo,'Checked','off');
                        set(modelo.background,'visible','off');
                    end
            end

          case 'unselected'
            node.setValue('selected');
            node.setIcon(javaImage_checked);
            hTree.treeDidChange();
            switch leyenda
                case 'L-Node'
                    set(modelo.graficoNodos,'visible','on');
                    if strcmp(get(handles.layerCuencas,'Checked'),'on')
                       set(modelo.graficoDCuencas,'visible','on');
                    end
                    set(handles.layerNodos,'Checked','on')
                    set(modelo.labelNodos,'visible','on');
                    set(handles.nodosLabel,'Checked','on')
                case 'L-Conduit'
                    set(modelo.graficoTuberias,'visible','on');
                    set(handles.layerTuberias,'Checked','on');
                    set(modelo.labelTuberias,'visible','on');
                    set(handles.tuberiasLabel,'Checked','on');
                case 'L-Catchment'
                    if strcmp(get(handles.layerNodos,'Checked'),'off')
                        set(handles.layerCuencas,'Checked','on');
                        set(modelo.graficoCuencas,'visible','on');
                        set(modelo.graficoDCuencas,'visible','off');
                        set(modelo.graficoCCuencas,'visible','on');
                        set(modelo.labelCuencas,'visible','on');
                        set(handles.cuencasLabel,'Checked','on')
                    else
                        set(handles.layerCuencas,'Checked','on');
                        set(modelo.graficoCuencas,'visible','on');
                        set(modelo.graficoDCuencas,'visible','on');
                        set(modelo.graficoCCuencas,'visible','on');
                        set(modelo.labelCuencas,'visible','on');
                        set(handles.cuencasLabel,'Checked','on')
                    end
                case 'L-Background'
                    
                    if ~isempty(modelo.background)
                        set(handles.layerFondo,'Checked','on');
                        set(modelo.background,'visible','on');
                    end
            end        
        end
    end
end

%% Enable display panel
% //    Description:
% //        -Change display panel
% //    Update History
% =============================================================
%
function tabChangedCB(src,eventdata,handles)
Nueva_pantalla=eventdata.NewValue.Title;
if strcmp(Nueva_pantalla,'<html><center/><font face="Open Sans" size=4><b><i>Modelo</html>')
    Nueva_pantalla='<html><center/><font face="Open Sans" size=4><b><i>Model</html>';
elseif strcmp(Nueva_pantalla,'<html><center/><font face="Open Sans" size=4><b><i>Planta</html>')
    Nueva_pantalla='<html><center/><font face="Open Sans" size=4><b><i>Plan</html>';
elseif strcmp(Nueva_pantalla,'<html><center/><font face="Open Sans" size=4><b><i>Perfil</html>')
    Nueva_pantalla='<html><center/><font face="Open Sans" size=4><b><i>Profile</html>';
end
switch Nueva_pantalla
    case '<html><center/><font face="Open Sans" size=4><b><i>Model</html>'
        P=findobj(gcf,'Tag','panelAnimacionPlanta');
        set(P,'Visible','off')
        P=findobj(gcf,'Tag','panelAnimacionPerfil');
        set(P,'Visible','off')
    case '<html><center/><font face="Open Sans" size=4><b><i>Plan</html>'
        P=findobj(gcf,'Tag','panelAnimacionPlanta');
        set(P,'Visible','on')
        P=findobj(gcf,'Tag','panelAnimacionPerfil');
        set(P,'Visible','off')

    case '<html><center/><font face="Open Sans" size=4><b><i>Profile</html>'
        P=findobj(gcf,'Tag','panelAnimacionPlanta');
        set(P,'Visible','off')
        P=findobj(gcf,'Tag','panelAnimacionPerfil');
        set(P,'Visible','on')
    otherwise
end

%% Active scenario
% //    Description:
% //        -Select active scenario
% //    Update History
% =============================================================
%
function Scenario=escenarioActual(objetivo,Scenario)
for i=1:length(Scenario)
    if i==objetivo
        Scenario(i).estado=true;
    else
        Scenario(i).estado=false;
    end
end
%% Main menu
% //    Description:
% //        -Create a main menu
% //    Update History
% =============================================================
%



function simular_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
jFrame = get(handle(gcf),'JavaFrame');
jRootPane = jFrame.fHG2Client.getWindow;

% //    Verify project name
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');
if get(handles.checkbox4,'value')
    nombre1={'SUDS'};
else
    nombre1={'Urban'};
end
nombre = inputdlg({'Escenario:'},(''),[1 30],nombre1);
if isempty(nombre)
    if strcmp(idioma,'english')
        Aviso('Enter scenario name','Error','error');
    else
        Aviso('Ingresar nombre de escenario','Error','error');
    end
    return
end

% //    Verify scenario
[~, msg,~] = mkdir(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}]));
nombreEscenario=nombre{1};

if ~isempty(msg) && ~isempty(Scenario)

    if strcmp(idioma,'english')
     answer = questdlg('The file already exists, Do you want to overwrite it?', ...
	    'Create file', ...
	    'Yes','Cancel','Cancel');
    else
     answer = questdlg('Elarchivo ya existe, Desea sobreescribirlo?', ...
	    'Crear archivo', ...
	    'Si','Cancelar','Cancelar');
    end
    switch answer
        case 'Yes'           
            rmdir (fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}]),'s');
            mkdir(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}]));
            todosEscenarios={Scenario.nombre};
            for i=1:length(todosEscenarios)
                if strcmp(todosEscenarios{i},nombreEscenario)
                    Scenario(i)=[];
                    break;
                end
            end
        case 'Si'
            rmdir (fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}]),'s');
            mkdir(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}]));
            todosEscenarios={Scenario.nombre};
            for i=1:length(todosEscenarios)
                if strcmp(todosEscenarios{i},nombreEscenario)
                    Scenario(i)=[];
                    break;
                end
            end
        case 'Cancel'  
            Aviso('The simulation did not take place','Error','error')
            return
        case 'Cancelar'
            Aviso('La simulación no pudo ejecutarse','Error','error')
            return
        otherwise

    end
end

Scenario=[Scenario,escenario(nombreEscenario)];
Scenario=escenarioActual(length(Scenario),Scenario);

statusbarObj = com.mathworks.mwswing.MJStatusBar;
jProgressBar = javax.swing.JProgressBar;
numIds = 10;

set(jProgressBar, 'Minimum',0, 'Maximum',numIds, 'Value',0);
jRootPane.setStatusBarVisible(1);
statusbarObj.add(jProgressBar,'West');

set(jProgressBar,'Value',1);
msg = 'Verify simulation... (10%)';
statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

try
% //    load required files
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
Nodos2=Node;
Cuencas2=Catchment;
Tuberias2=Conduit;

% //    Verify time parameters
if isempty(get(handles.edit4,'string'))
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Verify simulation start','Error','error');
    else
        Aviso('Verificar inicio de simulación','Error','error');
    end
    return
end

if isempty(get(handles.edit27,'string'))
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Verify simulation end','Error','error');
    else
        Aviso('Verificar fin de simulación','Error','error');
    end
    return
end

[y,m,d] = ymd(datetime(get(handles.edit4,'string')));
h=str2double(get(handles.edit5,'string'));
min=str2double(get(handles.edit6,'string'));
if isnan(h) || isnan(min) || h<0 || min<0
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Verify simulation start time','Error','error');
    else
        Aviso('Verificar incio de simulación','Error','error');
    end
    return
else
    h=round(h);
    min=round(min);
end
Scenario(end).startDate=get(handles.edit4,'string');
Scenario(end).startHour=h;
Scenario(end).startMin=min;
Simulation.inicioSimulacion=datetime(y,m,d,h,min,0);

[y,m,d] = ymd(datetime(get(handles.edit27,'string')));
h=str2double(get(handles.edit28,'string'));
min=str2double(get(handles.edit29,'string'));
if isnan(h) || isnan(min) || h<0 || min<0
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Verify simulation end time','Error','error');
    else
        Aviso('Verify fin de simulación','Error','error');
    end
    return
else
    h=round(h);
    min=round(min);
end
Scenario(end).endDate=get(handles.edit27,'string');
Scenario(end).endHour=h;
Scenario(end).endMin=min;
Simulation.finSimulacion=datetime(y,m,d,h,min,0);

if diff([Simulation.inicioSimulacion,Simulation.finSimulacion])<=0
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Verify simulation start and end','Error','error');
    else
        Aviso('Verificar inicio-fin de simulación','Error','error');
    end
    return
end

% //    Verify time steps
dtEscorrentia=str2double(get(handles.edit26,'string'));
dtTransito=str2double(get(handles.edit25,'string'));
dtReporte=str2double(get(handles.edit23,'string'));

if isnan(dtEscorrentia) || isnan(dtTransito) || isnan(dtReporte) || dtEscorrentia<0 || dtTransito<0 || dtReporte<0 
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Verify time steps','Error','error');
    else
        Aviso('Verify pasos de tiempo','Error','error');
    end
    return
else
    h=round(h);
    min=round(min);
end
Scenario(end).stepRunoff=dtEscorrentia;
Scenario(end).stepRouting=dtTransito;
Scenario(end).stepResult =dtReporte;


metodoTransito=get(handles.popupmenu2,'value');
if metodoTransito==2
    Simulation.metodoTransito='onda_cinematica';
elseif metodoTransito==3
    Simulation.metodoTransito='onda_dinamica';
else
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Select method for flood routing','Error','error');
    else
        Aviso('Seleccionar método de tránsito','Error','error');
    end
    return
end
Scenario(end).routing = Simulation.metodoTransito;

Simulation.dtEscorrentia=str2double(get(handles.edit26,'string'));
Simulation.dtTransito=str2double(get(handles.edit25,'string'));
Simulation.dtReporte=str2double(get(handles.edit23,'string'));

Simulation=tiempoTotal(Simulation);

set(jProgressBar,'Value',2);
if strcmp(idioma,'english')
    msg = 'Verify model... (20%)';
else
    msg = 'Verificar modelo... (20%)';
end
statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

% //     Verify storms and hyetographs
for i=1:length(Storm)
    [y,m,d] = ymd(datetime(Storm(i).fechaInicio));
    h=Storm(i).horaInicio;
    min=Storm(i).minInicio;
    Storm(i).inicioTormenta=datetime(y,m,d,h,min,0);
    if diff([Simulation.inicioSimulacion,Storm(i).inicioTormenta])<0
        jRootPane.setStatusBarVisible(0);
        if strcmp(idioma,'english')
            Aviso('Storms must occur within the simulation time','Error','error');
        else
            Aviso('La tormenta debe ocurrir durante el tiempo de simulación','Error','error');
        end
        return;
    end
    [h,m,~]=hms(diff([Simulation.inicioSimulacion,Storm(i).inicioTormenta]));
    Storm(i).hietogramaSimulacion(:,1)=Storm(i).hietogramaSimulacion(:,1)+h*3600+m*60;
    tiempo=(Storm(i).hietogramaSimulacion(1,1):Storm(i).dt*60:Simulation.duracionSimulacion);
    lluvia=interp1(Storm(i).hietogramaSimulacion(:,1),Storm(i).hietogramaSimulacion(:,2),tiempo);
    lluvia(isnan(lluvia))=0;
    hietogramaSimulacion=[tiempo',lluvia'];
    Storm(i).hietogramaSimulacion=hietogramaSimulacion;
end

set(jProgressBar,'Value',3);
if strcmp(idioma,'english')
    msg = 'Runoff simulation ... (30%)';
else
    msg = 'Simulación de la escorrentía superficial ... (30%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

% //    Check SUDS simulation and RHN
Simulation.incluirSUDS=get(handles.checkbox4,'value');
Simulation.incluirRN=get(handles.checkbox5,'value');

Scenario(end).SUDS=get(handles.checkbox4,'value');
Scenario(end).RHN=get(handles.checkbox5,'value');

% //    Runoff simulation
for i=1:length(Catchment)
    switch Catchment(i).escorrentia.metodo
        case 'Onda-Cinematica'
        hietogramaTotal=Storm(Catchment(i).tormenta).hietogramaSimulacion;
        otherwise
        hietogramaTotal=Storm(Catchment(i).tormenta).hietograma;
    end
    Catchment(i)=generarHidrograma(Catchment(i),hietogramaTotal,Simulation);   
end

set(jProgressBar,'Value',4);
if strcmp(idioma,'english')
    msg = 'SUDS simulation ... (40%)';
else
    msg = 'Simulación de SUDS ... (40%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

% // SUDS operation simulation
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
if Simulation.incluirSUDS
    if ~isempty(genRetention)
        for i=1:length(genRetention)
            [Catchment(genRetention(i).cuenca),genRetention(i)] = hidrogramaDirecto(Catchment(genRetention(i).cuenca),genRetention(i));
            genRetention(i) = iniciar(genRetention(i),genRetention(i).hidrogramaDirecto(:,1));
            for j=1:size(genRetention(i).hidrogramaDirecto(:,1),1)
                genRetention(i) = estimarRetencion(genRetention(i),j,genRetention(i).hidrogramaDirecto(j,2),Simulation.dtEscorrentia);
            end

            if ~isempty(Node(Catchment(genRetention(i).cuenca).descarga).Iqinflow)
                Node(Catchment(genRetention(i).cuenca).descarga).Iqinflow(:,2)=Node(Catchment(genRetention(i).cuenca).descarga).Iqinflow(:,2)+genRetention(i).salida(:,2); 
            else
                Node(Catchment(genRetention(i).cuenca).descarga).Iqinflow=genRetention(i).salida;
            end
        
       end
    end
    if ~isempty(genDetention)
        for i=1:length(genDetention)
            [Catchment(genDetention(i).cuenca),genDetention(i)] = hidrogramaDirecto(Catchment(genDetention(i).cuenca),genDetention(i));
            genDetention(i) = iniciar(genDetention(i),genDetention(i).hidrogramaDirecto(:,1));
            for j=1:size(genDetention(i).hidrogramaDirecto(:,1),1)
                genDetention(i) = estimarDetencion(genDetention(i),genDetention(i).hidrogramaDirecto(j,2),j,Simulation.dtEscorrentia);
            end
            if ~isempty(Node(Catchment(genDetention(i).cuenca).descarga).Iqinflow)
                Node(Catchment(genDetention(i).cuenca).descarga).Iqinflow(:,2)=Node(Catchment(genDetention(i).cuenca).descarga).Iqinflow(:,2)+genDetention(i).salida(:,2); 
            else
                Node(Catchment(genDetention(i).cuenca).descarga).Iqinflow=genDetention(i).salida;
            end
        
       end
    end
    if ~isempty(genInfiltration)
        for i=1:length(genInfiltration)
            [Catchment(genInfiltration(i).cuenca),genInfiltration(i)] = hidrogramaDirecto(Catchment(genInfiltration(i).cuenca),genInfiltration(i));
            genInfiltration(i) = iniciar(genInfiltration(i),genInfiltration(i).hidrogramaDirecto(:,1));
            for j=1:size(genInfiltration(i).hidrogramaDirecto(:,1),1)
                genInfiltration(i) = estimarInfiltracionSUD(genInfiltration(i),genInfiltration(i).hidrogramaDirecto(j,2),j,Simulation.dtEscorrentia);
            end
            if ~isempty(Node(Catchment(genInfiltration(i).cuenca).descarga).Iqinflow)
                Node(Catchment(genInfiltration(i).cuenca).descarga).Iqinflow(:,2)=Node(Catchment(genInfiltration(i).cuenca).descarga).Iqinflow(:,2)+genInfiltration(i).salida(:,2); 
            else
                Node(Catchment(genInfiltration(i).cuenca).descarga).Iqinflow=genInfiltration(i).salida;
            end
        
       end
    end
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'genRetention.mat'),'genRetention');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'genDetention.mat'),'genDetention');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'genInfiltration.mat'),'genInfiltration');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
end

set(jProgressBar,'Value',5);
if strcmp(idioma,'english')
    msg = 'NHR simulation ... (50%)';
else
    msg = 'Simulación respuesta hidrológica natural ... (40%)';
end
statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

% //    Evaluate flow to Nodes 
for i=1:length(Catchment)
    if ~isempty(Node(Catchment(i).descarga).Iqinflow)
        Node(Catchment(i).descarga).Iqinflow(:,2)=Node(Catchment(i).descarga).Iqinflow(:,2)+Catchment(i).hidrograma(:,2); 
    else
        Node(Catchment(i).descarga).Iqinflow=Catchment(i).hidrograma;
    end
end

% //    Natural hydrological response simulation
if Simulation.incluirRN==1
    for i=1:length(NaturalResponse)
        Storm((NaturalResponse(i).tormenta))=generarHietograma(Storm((NaturalResponse(i).tormenta)));
        switch NaturalResponse(i).escorrentia.metodo
            case 'Onda-Cinematica'
                NaturalResponse(i).escorrentia=areaDrenado(NaturalResponse(i).escorrentia,NaturalResponse(i));
                hietogramaTotal=Storm(NaturalResponse(i).tormenta).hietogramaSimulacion;
            otherwise
            hietogramaTotal=Storm(NaturalResponse(i).tormenta).hietograma;
        end
        NaturalResponse(i)=generarHidrograma(NaturalResponse(i),hietogramaTotal,Simulation);
    end
end

set(jProgressBar,'Value',6);
if strcmp(idioma,'english')
    msg = 'Routing simulation ... (60%)';
else
    msg = 'Simulación del tránsito hidráulico ... (60%)';
end
statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);
% // Routing simulation 
stormwaterSystem = sistemaHidrologico(Node,Catchment,Conduit,Storm,NaturalResponse);

if Simulation.incluirSUDS
    stormwaterSystem.Retencion=genRetention;
    stormwaterSystem.Detencion=genDetention;
    stormwaterSystem.Infiltracion=genInfiltration;
end
try
    stormwaterSystem=ordenTransito(stormwaterSystem);
    stormwaterSystem = obtenerRutas(stormwaterSystem);
    stormwaterSystem=rutas(stormwaterSystem,Conduit);
catch
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Remove cycles in the system','Error','error');
    else
        Aviso('Remover ciclos del sistema','Error','error');
    end
    return
end

if ~isempty(Node)
    tipo=[Node(:).tipo];
    if ~any(tipo==1)
        switch Simulation.metodoTransito
            case 'onda_dinamica'
                if strcmp(idioma,'english')
                    answer = questdlg('There is no outlet node, do you want to change the last node?','Node','Yes','Cancel','Cancel');
                else
                    answer = questdlg('No existe nodo de salida, desea asignar el nodo final del sistema?','Nodo','Si','Cancelar','Cancelar');
                end
                switch answer
                    case 'Yes'
                        stormwaterSystem.Node(stormwaterSystem.nf).outfall=1;
                        stormwaterSystem.Node(stormwaterSystem.nf).tipo=1;
                    case 'Si'
                        stormwaterSystem.Node(stormwaterSystem.nf).outfall=1;
                        stormwaterSystem.Node(stormwaterSystem.nf).tipo=1;
                    case 'Cancel'
                        jRootPane.setStatusBarVisible(0);
                        Aviso('There is no outlet node','Error','error');
                        return
                     case 'Cancelar'
                         jRootPane.setStatusBarVisible(0);
                        Aviso('No existe nodo de salida','Error','error');
                        return
                end
        end
    end
end

switch Simulation.metodoTransito
    case 'onda_dinamica'
        dinamica.inercia=get(handles.popupmenu53,'Value');
        dinamica.fNormal=get(handles.popupmenu54,'value');
        dinamica.surgencia=get(handles.popupmenu56,'value');       
        dinamica.courant=str2num(get(handles.edit99,'string'))/100;
        dinamica.minDt=str2double(get(handles.edit100,'String'));
        dinamica.minAreaNodal=str2double(get(handles.edit101,'String'));
        dinamica.maxIteraciones=str2double(get(handles.edit102,'String'));
        dinamica.tolerancia=str2double(get(handles.edit103,'String'));
        Simulation.dinamica=dinamica;
        Scenario(end).DW=dinamica;
end

[stormwaterSystem,results,response]=realizarTransito(stormwaterSystem,Simulation);

set(jProgressBar,'Value',7);
if strcmp(idioma,'english')
    msg = 'Save results ... (70%)';
else
    msg = 'Guardar resultados ... (70%)';
end
statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

ax = gca;
xl = xlim;
yl = ylim;
axes(handles.axes2);
cla
xlim(xl)
ylim(yl)
axis equal
[modelo.graficoTuberiasPl,modelo.graficoCuencasPl,modelo.graficoNodosPl]=plotSimulacion(stormwaterSystem);

% // Save results
Tor=cell(1,length(Conduit));
for i=1:length(Conduit)
    Tor{i}=['T-',num2str(i)];
end
set(handles.popupmenu29,'string',Tor);

jTabGroup = findjobj ( 'class' , 'JTabbedPane' );
jTabGroup=jTabGroup(3);
jTabGroup(1). setEnabledAt ( 1 , 1 );
jTabGroup(1). setEnabledAt ( 2 , 1 );
jTabGroup(1).setSelectedIndex(0) 
pause(0.5)

tablaEscenarios(Scenario,handles,'creacion')

stormwaterSystem.Catchment=Catchment;

Simulation.estado='finalizada';

if Simulation.incluirSUDS && (~isempty(genRetention) ||~isempty(genDetention)||~isempty(genInfiltration))
    SUDSResponse=response;
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','SUDSResponse.mat'),'SUDSResponse');
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'SUDSResponse.mat'),'SUDSResponse');
else
    UrbanResponse=response;
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','UrbanResponse.mat'),'UrbanResponse');
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'UrbanResponse.mat'),'UrbanResponse');
end

Node=Nodos2;
Conduit=Tuberias2;
Catchment=Cuencas2;
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'StormwaterSystem.mat'),'stormwaterSystem');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'Simulation.mat'),'Simulation');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'Conduit.mat'),'Conduit');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'Node.mat'),'Node');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'Catchment.mat'),'Catchment');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'Storm.mat'),'Storm')
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'NaturalResponse.mat'),'NaturalResponse');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre{1}],'Results.mat'),'results');

save(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Results.mat'),'results');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');

set(jProgressBar,'Value',7);
if strcmp(idioma,'english')
    msg = 'Estimate mass balance ... (70%)';
else
    msg = 'Estimando balance de masa ... (70%)';
end
statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

if ~strcmp(Simulation.metodoTransito,'onda_dinamica') && Simulation.incluirSUDS
    resumen={'Mass balance:',['Runoff error: ',sprintf('%.2f',mean(results.errorC,"omitnan")),' %'],...
        ['Routing error: ',sprintf('%.2f',mean(results.errorT,"omitnan")),' %'],['Retention error: ',sprintf('%.2f',mean(results.errorR,"omitnan")),' %'],...
        ['Detention error: ',sprintf('%.2f',mean(results.errorD,"omitnan")),' %'],['Infiltration error: ',sprintf('%.2f',mean(results.errorI,"omitnan")),' %']};
elseif ~strcmp(Simulation.metodoTransito,'onda_dinamica')
    resumen={'Mass balance:',['Runoff error: ',sprintf('%.2f',mean(results.errorC,"omitnan")),' %'],...
        ['Routing error: ',sprintf('%.2f',mean(results.errorT,"omitnan")),' %']};
elseif strcmp(Simulation.metodoTransito,'onda_dinamica') && Simulation.incluirSUDS
    resumen={'Mass balance:',['Runoff error: ',sprintf('%.2f',mean(results.errorC,"omitnan")),' %'],...
        ['Routing error: ',sprintf('%.2f',mean(results.errorT,"omitnan")),' %'],['Retention error: ',sprintf('%.2f',mean(results.errorR,"omitnan")),' %'],...
        ['Detention error: ',sprintf('%.2f',mean(results.errorD,"omitnan")),' %'],['Infiltration error: ',sprintf('%.2f',mean(results.errorI,"omitnan")),' %'],['Steps no Converged: ',sprintf('%.0f',sum(results.noConverged,"omitnan"))]};
elseif strcmp(Simulation.metodoTransito,'onda_dinamica')
        resumen={'Mass balance:',['Runoff error: ',sprintf('%.2f',mean(results.errorC,"omitnan")),' %'],...
        ['Routing error: ',sprintf('%.2f',mean(results.errorT,"omitnan")),' %'],['Steps no Converged: ',sprintf('%.0f',sum(results.noConverged,"omitnan"))]};
else
        resumen={'Mass balance:',['Runoff error: ',sprintf('%.2f',mean(results.errorC,"omitnan")),' %'],...
        ['Routing error: ',sprintf('%.2f',mean(results.errorT,"omitnan")),' %']};
end
Aviso(resumen,'Successful','help');
deleteGlobal('parcial')

set(jProgressBar,'Value',10);
if strcmp(idioma,'english')
    msg = 'Successful ... (100%)';
else
    msg = 'Finalizado ... (100%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);
pause(0.5)
catch 
    if strcmp(idioma,'english')
        Aviso('Incomplete simulation','Error','error');
    else
        Aviso('No se pudo realizar la simulación','Error','error');
    end
end
jRootPane.setStatusBarVisible(0);
% hObject    handle to simular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Scenario table actions
% //    Description:
% //        -Create and delete data of scenarios
% //    Update History
% =============================================================
%
function tablaEscenarios(Scenario,handles,varargin)
switch varargin{1}
    case 'creacion'
        Datos=[];
        for i=1:length(Scenario)
            nombre={['<html><tr><td width=9999 align=center>',Scenario(i).nombre]};
            estado={Scenario(i).estado};
            Datos=[Datos;estado,nombre];
        end
    case 'eliminacion'
        if ~isempty(Escenario)
            Datos=get(handles.tablaEscenarios,'data');
            Datos(varargin{2},:)=[];
        end
end
set(handles.tablaEscenarios,'data',Datos)  

%% Natural hydrological response simulation
% //    Description:
% //        -Get natural hydrological response
% //        -Methods
% //    Update History
% =============================================================
%
function NaturalResponse=generarRespuestaNatural(escorrentia,infiltracion,Storm,handles)
global idioma
NaturalResponse=cuencaH(0,0,0);

switch escorrentia
    case 1
        ancho=str2double(get(handles.edit1,'string'));
        pendiente=str2double(get(handles.edit2,'string'));
        impermeable=str2double(get(handles.edit3,'string'));
        nPermeable=str2double(get(handles.edit4,'string'));
        nImpermeable=str2double(get(handles.edit5,'string'));
        dImpermeable=str2double(get(handles.edit6,'string'));
        dPermeable=str2double(get(handles.edit7,'string'));
        sdImpermeable=str2double(get(handles.edit8,'string'));

        if isnan(ancho) || ancho==0 || isnan(pendiente) || pendiente==0 || isnan(impermeable) || isnan(nPermeable) || nPermeable==0  || isnan(nImpermeable) || nImpermeable==0 || isnan(dImpermeable) || isnan(dPermeable) || isnan(sdImpermeable)   
            if strcmp(idioma,'english')
                Aviso('Verify runoff data','Error','error');
            else
                Aviso('Verificar datos de escorrentÃ­a','Error','error');
            end
            return
        end
        NaturalResponse.escorrentia=escorrentiaOC('Onda-Cinematica',ancho,pendiente,impermeable,nPermeable,nImpermeable,dImpermeable,dPermeable,sdImpermeable);

        switch get(handles.popupmenu1,'value')
            case 1
                NaturalResponse.infiltracion=infiltracionNC('SCS-NC',NC);
            case 2
                NaturalResponse.infiltracion=infiltracionNC('SCS-Modificado',NC);
        end

        NaturalResponse.tormenta

    case 2
        tc=str2double(get(handles.edit12,'string'));
        if isnan(tc) || tc==0
            if strcmp(idioma,'english')
                Aviso('Verify runoff data','Error','error');
            else
                Aviso('Verificar datos de escorrentÃ­a','Error','error');
            end
            return
        end

        NaturalResponse.escorrentia=escorrentiaSCS('HU-SCS',tc);

        switch get(handles.popupmenu1,'value')
            case 1
                NaturalResponse.infiltracion=infiltracionNC('SCS-NC',NC);
            case 2
                NaturalResponse.infiltracion=infiltracionNC('SCS-Modificado',NC);
        end

    case 3
        tp=str2double(get(handles.edit9,'string'));
        cp=str2double(get(handles.edit10,'string'));
        if isnan(tp) || tp==0 || isnan(cp) || cp==0
            if strcmp(idioma,'english')
                Aviso('Verify runoff data','Error','error');
            else
                Aviso('Verificar datos de escorrentÃ­a','Error','error');
            end
            return
        end
        NaturalResponse.escorrentia=escorrentiaSnyder('HU-Snyder',tp,cp);

        switch get(handles.popupmenu1,'value')
            case 1
                NaturalResponse.infiltracion=infiltracionNC('SCS-NC',NC);
            case 2
                NaturalResponse.infiltracion=infiltracionNC('SCS-Modificado',NC);
        end

    case 4
        info=get(handles.uitable1,'data');
        for i=1:size(info,1)
            datos(i,1)=info{i,1};
            datos(i,2)=info{i,2};
        end
        NaturalResponse.escorrentia=escorrentiaSCS('H-Conocido',datos);

        switch get(handles.popupmenu1,'value')
            case 1
                NaturalResponse.infiltracion=infiltracionNC('SCS-NC',NC);
            case 2
                NaturalResponse.infiltracion=infiltracionNC('SCS-Modificado',NC);
        end

end


%% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Model visualization
% //    Description:
% //        -Extend option 
% //    Update History
% =============================================================
%
function extend_Callback(hObject, eventdata, handles)

h = zoom(gcf);
switch h.Enable
    case 'off'
        zoom(gcf,'out');
    otherwise
        zoom(gcf,'off');
end
% hObject    handle to extend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Model visualization
% //    Description:
% //        -Zoom option 
% //    Update History
% =============================================================
%
function zoom_Callback(hObject, eventdata, handles)
h = zoom(gcf);
switch h.Enable
    case 'off'
        zoom(gcf,'on');
    otherwise
        zoom(gcf,'off');
end
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Model visualization
% //    Description:
% //        -Pan option 
% //    Update History
% =============================================================
%
function pan_Callback(hObject, eventdata, handles)
h = pan(gcf);
switch h.Enable
    case 'off'
        pan(gcf,'on');
    case 'on'
        pan(gcf,'off');
    otherwise
        pan(gcf,'off');
end
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Storm element
% //    Description:
% //        -Load hyetograph file
% //    Update History
% =============================================================
%
function importarT_Callback(hObject, eventdata, handles)
pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to importarT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Storm element
% //    Description:
% //        -Load IDTr curve file
% //    Update History
% =============================================================
%
function tormentaMP_Callback(hObject, eventdata, handles)
pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to tormentaMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Catchment element
% //    Description:
% //        -Set color of element
% //    Update History
% =============================================================
%
function colorCuenca_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if modelo.estado~=1
    if strcmp(idioma,'english')
        Aviso('Switch to the model tab','Info','warn');
    else
        Aviso('Cambiar a la vista modelo','Info','warn');
    end
    return
end
if strcmp(get(handles.layerCuencas,'Checked'),'off')
    if strcmp(idioma,'english')
        Aviso( 'Enable catchment layer','Info','warn');
    else
        Aviso( 'Activar capa Cuencas','Info','warn');
    end
    return
end
color = uisetcolor(get(handles.boxColorC,'BackgroundColor'));
if color == get(handles.boxColorC,'BackgroundColor')
    return
elseif ~isempty(modelo.cuencas)
    set(handles.boxColorC,'BackgroundColor',color);
    set(modelo.graficoCuencas,'FaceColor',color);
    set(modelo.graficoCCuencas,'MarkerFaceColor',color);
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    for i=1:length(Catchment)
        Catchment(i).color=color;
    end
     save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
end

% hObject    handle to colorCuenca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Catchment element
% //    Description:
% //        -Create and configurate element options
% //    Update History
% =============================================================
%
function crearCuenca_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if modelo.estado~=1
    if strcmp(idioma,'english')
        Aviso('Switch to the model tab','Info','warn');
    else
        Aviso('Cambiar a la vista modelo','Info','warn');
    end
    return
end
if strcmp(get(handles.layerCuencas,'Checked'),'off')
    if strcmp(idioma,'english')
        Aviso( 'Enable catchment layer','Info','warn');
    else
        Aviso( 'Activar capa Cuencas','Info','warn');
    end
    return
end
setPanelVisible('Cuenca',handles);

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');

fig=gcf;
if isempty(Node)
    if strcmp(idioma,'english')
        Aviso('There are no nodes in the system','Error','error');
    else
        Aviso('No existen nodos en el sistema','Error','error');
    end   
    return 
end

TTexto=str2double(get(handles.tamanoLabelC,'String'));
TextColor=get(handles.colorLabelC,'ForegroundColor');
Color=get(handles.boxColorC,'BackgroundColor');
alpha=(10-get(handles.menuC,'value'))/10;

boton=1;
s2='normal';

while boton== 1
    c_info = datacorsor1( fig );
    s1=get (fig, 'SelectionType' );
    if isempty(c_info)&& strcmp(s1,s2)==0
        break;
    elseif isempty(c_info)
        continue;
    end
    if strcmp(s1,s2)==1
        s=c_info.Target;
        nodoSelect=s==modelo.graficoNodos;

        if any(nodoSelect==1)

            nodo=Node(nodoSelect);
            h=impoly(gca);
            setColor(h,Color)
            trazo = getPosition(h);
            Catchment=[Catchment,cuencaH(length(Catchment)+1,nodo,trazo)];
            Catchment(end).area=areaCuenca(Catchment(end));
            Catchment(end).centroide=centroCuenca(Catchment(end));
            Catchment(end).color=Color;
            Catchment(end).labelColor=TextColor;
            Catchment(end).fontSize=TTexto;
            modelo.graficoCuencas=[modelo.graficoCuencas, plotCuenca(Catchment(end))];
            modelo.graficoDCuencas=[modelo.graficoDCuencas,plotDirC(Catchment(end))];
            modelo.graficoCCuencas=[modelo.graficoCCuencas,plotCentroC(Catchment(end))];
            modelo.labelCuencas=[modelo.labelCuencas,plotLabelC(Catchment(end))];
            set(modelo.graficoCuencas(end),'facealpha',alpha)

            if strcmp(get(handles.cuencasLabel,'Checked'),'off')
                set(modelo.labelCuencas(end),'visible','off');
            end


            if get(handles.checkCuencas,'Value')==1
                modelo.bandera={Catchment(end),'creacion'};
                editarGeneral(crearCuencaH);
                if ~isempty(modelo.bandera)
                    Catchment(end)=modelo.bandera;
                end
            end
            tablaCuencas(Catchment,handles,'creacion')
            delete (h)
            ax = gca;
            VPermutar=ax.Children;
            Orden = CuencaOrdenGrafico(VPermutar,modelo.background);
            ax.Children = ax.Children(Orden);
        end 
    end   
end
datacursormode off;
if ~isempty(Catchment)>=1
    set(handles.boxColorC,'Enable','on');
    set(handles.tamanoLabelC,'Enable','on');
    set(handles.colorLabelC,'Enable','on');
end
modelo.cuencas=length(Catchment);
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
% hObject    handle to crearCuenca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Catchment element
% //    Description:
% //        -Manage the table of information for the elements
% //    Update History
% =============================================================
%
function tablaCuencas(Catchment,handles,varargin)
formatSpec = '%.2f';
switch varargin{1}
    case 'creacion'
        ID={['<html><tr><td width=9999 align=center>',num2str(Catchment(end).ID)]};
        ND={['<html><tr><td width=9999 align=center>',num2str(Catchment(end).descarga)]};
        area={['<html><tr><td width=9999 align=center>',num2str(Catchment(end).area,formatSpec)]};
        if ~isempty(Catchment(end).tormenta)
            tormenta={['<html><tr><td width=9999 align=center>',num2str(Catchment(end).tormenta)]};
        else
            tormenta={''};
        end
        if ~isempty(Catchment(end).infiltracion)
            infiltracion={['<html><tr><td width=9999 align=center>',Catchment(end).infiltracion.metodo]};
        else
            infiltracion={''};
        end
        if ~isempty(Catchment(end).escorrentia)
            escorrentia={['<html><tr><td width=9999 align=center>',Catchment(end).escorrentia.metodo]};
        else
            escorrentia={''};
        end
        areaSUDS={['<html><tr><td width=9999 align=center>',num2str(Catchment(end).areaSUDS,formatSpec)]};
        if length(Catchment)==1
            Datos=[ID,ND,area,escorrentia,infiltracion,tormenta,areaSUDS];
        else
            Datos=get(handles.tablaCuencas,'data');
            Datos=[Datos;ID,ND,area,escorrentia,infiltracion,tormenta,areaSUDS];
        end
    case 'edicion'
        r=varargin{2};
        Datos=get(handles.tablaCuencas,'data');
        ID={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).ID)]};
        ND={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).descarga)]};
        area={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).area,formatSpec)]};
        if ~isempty(Catchment(r).tormenta)
            tormenta={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).tormenta)]};
        else
            tormenta={''};
        end
        if ~isempty(Catchment(r).infiltracion)
            infiltracion={['<html><tr><td width=9999 align=center>',Catchment(r).infiltracion.metodo]};
        else
            infiltracion={''};
        end
        if ~isempty(Catchment(r).escorrentia)
            escorrentia={['<html><tr><td width=9999 align=center>',Catchment(r).escorrentia.metodo]};
        else
            escorrentia={''};
        end
        areaSUDS={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).areaSUDS,formatSpec)]};
        Datos(r,1)=ID;
        Datos(r,2)=ND;
        Datos(r,3)=area;
        Datos(r,4)=escorrentia;
        Datos(r,5)=infiltracion;
        Datos(r,6)=tormenta;
        Datos(r,7)=areaSUDS;
    case 'edicionSUDS'
        r=varargin{2};
        Datos=get(handles.tablaCuencas,'data');
        areaSUDS={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).areaSUDS,formatSpec)]};
        Datos(r,7)=areaSUDS;
    case 'eliminacion'     
        if ~isempty(Catchment)
            Datos=cell(length(Catchment),7);
            for i=1:length(Catchment)
                ID={['<html><tr><td width=9999 align=center>',num2str(Catchment(i).ID)]};
                ND={['<html><tr><td width=9999 align=center>',num2str(Catchment(i).descarga)]};
                area={['<html><tr><td width=9999 align=center>',num2str(Catchment(i).area,formatSpec)]};
                if ~isempty(Catchment(i).tormenta)
                    tormenta={['<html><tr><td width=9999 align=center>',num2str(Catchment(i).tormenta)]};
                else
                    tormenta={''};
                end
                if ~isempty(Catchment(i).infiltracion)
                    infiltracion={['<html><tr><td width=9999 align=center>',Catchment(i).infiltracion.metodo]};
                else
                    infiltracion={''};
                end
                if ~isempty(Catchment(i).escorrentia)
                    escorrentia={['<html><tr><td width=9999 align=center>',Catchment(i).escorrentia.metodo]};
                else
                    escorrentia={''};
                end
                areaSUDS={['<html><tr><td width=9999 align=center>',num2str(Catchment(i).areaSUDS,formatSpec)]};

                Datos(i,1)=ID;
                Datos(i,2)=ND;
                Datos(i,3)=area;
                Datos(i,4)=escorrentia;
                Datos(i,5)=infiltracion;
                Datos(i,6)=tormenta;
                Datos(i,7)=areaSUDS;
            end
        else
            Datos=[];
        end
end
set(handles.tablaCuencas,'data',Datos)


%% Catchment element
% //    Description:
% //        -Set color of label
% //    Update History
% =============================================================
%
function colorLabelC_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
switch modelo.estado
    case 1
        if strcmp(get(handles.layerCuencas,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable catchment layer','Info','warn');
            else
                Aviso('Activar capa Cuencas','Info','warn');
            end    
            return
        end
        color = uisetcolor(get(handles.colorLabelC,'ForegroundColor'));
        if color == get(handles.colorLabelC,'ForegroundColor')
            return
        elseif ~isempty(modelo.cuencas)
            set(handles.colorLabelC,'ForegroundColor',color);
            set(modelo.labelCuencas,'Color',color);
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            for i=1:length(Catchment)
                Catchment(i).labelColor=color;
            end
             save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        end
    case 2
        if strcmp(get(handles.layerCuencasR,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable catchment layer','Info','warn');
            else
                Aviso('Activar capa Cuencas','Info','warn');
            end 
            return
        end
        color = uisetcolor(get(handles.colorLabelC,'ForegroundColor'));
        if ~isempty(modelo.cuencas)
            set(modelo.labelCuencasR,'Color',color);
        end
end
% hObject    handle to colorLabelC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Catchment element
% //    Description:
% //        -Set size of font label
% //    Update History
% =============================================================
%
function tamanoLabelC_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
switch modelo.estado
    case 1
        if strcmp(get(handles.layerCuencas,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable catchment layer','Info','warn');
            else
                Aviso('Activar capa Cuencas','Info','warn');
            end 
            return
        elseif isempty(modelo.cuencas)
            if strcmp(idioma,'english')
                Aviso('There are no catchment in the system','Error','error');
            else
                Aviso('No existen cuencas en el sistema','Error','error');
            end 
            return
        end
        modelo.bandera=str2double(get(handles.tamanoLabelC,'string'));
        editarGeneral(editarTamanoH)
        if ~isempty(modelo.bandera)
            set(handles.tamanoLabelC,'string',modelo.bandera);
            set(modelo.labelCuencas,'FontSize',modelo.bandera)
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            for i=1:length(Catchment)
                Catchment(i).fontSize=modelo.bandera;
            end
             save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');    
        end
    case 2
        if strcmp(get(handles.layerCuencasR,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable catchment layer','Info','warn');
            else
                Aviso('Activar capa Cuencas','Info','warn');
            end 
            return
        elseif isempty(modelo.cuencas)
            if strcmp(idioma,'english')
                Aviso('There are no catchment in the system','Error','error');
            else
                Aviso('No existen cuencas en el sistema','Error','error');
            end
            return
        end
        modelo.bandera=str2double(get(handles.tamanoLabelC,'string'));
        editarGeneral(editarTamanoH)
        if ~isempty(modelo.bandera)
            set(modelo.labelCuencasR,'FontSize',modelo.bandera)  
        end
end
% hObject    handle to tamanoLabelC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%% --- Executes on button press in boxColorC.
function boxColorC_Callback(hObject, eventdata, handles)
% hObject    handle to boxColorC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxColorC as text
%        str2double(get(hObject,'String')) returns contents of boxColorC as a double


%% --- Executes during object creation, after setting all properties.
function boxColorC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxColorC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Catchment element
% //    Description:
% //        -Set transparency of element
% //    Update History
% =============================================================
%
function menuC_Callback(hObject, eventdata, handles)
global modelo idioma
switch modelo.estado
    case 1
        if strcmp(get(handles.layerCuencas,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable catchment layer','Info','warn');
            else
                Aviso('Activar capa Cuencas','Info','warn');
            end 
            return
        end     
        alpha=(10-get(handles.menuC,'value'))/10;
        set(modelo.graficoCuencas,'facealpha',alpha)
    case 2
        if strcmp(get(handles.layerCuencasR,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable catchment layer','Info','warn');
            else
                Aviso('Activar capa Cuencas','Info','warn');
            end 
            return
        end     
        alpha=(10-get(handles.menuC,'value'))/10;
        set(modelo.graficoCuencasR,'facealpha',alpha)
end
% hObject    handle to menuC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuC


%% --- Executes during object creation, after setting all properties.
function menuC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Conduit element
% //    Description:
% //        -Set colory of element
% //    Update History
% =============================================================
%
function colorTuberia_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if modelo.estado~=1
    if strcmp(idioma,'english')
        Aviso('Switch to the model tab','Info','warn');
    else
        Aviso('Cambiar a la vista modelo','Info','warn');
    end
    return
end
if strcmp(get(handles.layerTuberias,'Checked'),'off')
    if strcmp(idioma,'english')
        Aviso('Enable conduit layer','Info','warn');
    else
        Aviso('Activar capa Tuberías','Info','warn');
    end
    return
end
color = uisetcolor(get(handles.boxColorT,'BackgroundColor'));
if color == get(handles.boxColorT,'BackgroundColor')
    return
elseif ~isempty(modelo.tuberias)
    set(handles.boxColorT,'BackgroundColor',color);
    set(modelo.graficoTuberias,'Color',color);
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
    for i=1:length(Conduit)
        Conduit(i).color=color;
    end
     save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
end
% hObject    handle to colorTuberia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in boxColorT.
function boxColorT_Callback(hObject, eventdata, handles)
% hObject    handle to boxColorT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxColorT as text
%        str2double(get(hObject,'String')) returns contents of boxColorT as a double


%% --- Executes during object creation, after setting all properties.
function boxColorT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxColorT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Conduit element
% //    Description:
% //        -Create and configurate element options
% //    Update History
% =============================================================
%
function crearTuberia_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if modelo.estado~=1
    if strcmp(idioma,'english')
        Aviso('Switch to the model tab','Info','warn');
    else
        Aviso('Cambiar a la vista modelo','Info','warn');
    end
    return
end
if strcmp(get(handles.layerTuberias,'Checked'),'off')
    if strcmp(idioma,'english')
        Aviso('Enable conduit layer','Info','warn');
    else
        Aviso('Activar capa Tuberías','Info','warn');
    end
    return
end
setPanelVisible('Tubería',handles);

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
modelo.bandera=[];

if isempty(modelo.nodos) || modelo.nodos<=1
    if strcmp(idioma,'english')
        Aviso('To create the element, at least two nodes are required','Info','warn');
    else
        Aviso('Para crear el elemento se necesitan almenos dos nodos','Info','warn');
    end
   return 
end
fig=gcf;
TTexto=str2double(get(handles.tamanoLabelT,'String'));
SizeObj=str2double(get(handles.tamanoTuberia,'String'));
TextColor=get(handles.colorLabelT,'ForegroundColor');
Color=get(handles.boxColorT,'BackgroundColor');
boton = 1;
Ni=[];
Nf=[];
s2='normal';

while boton == 1
    c_info = datacorsor1( fig );
    if isempty(c_info)
        s1=get (fig, 'SelectionType');
        if strcmp(s1,s2)==0
            break;
        end
    else       
        s1=get (fig, 'SelectionType');
        if strcmp(s1,s2)==1 
            s=c_info.Target;

            nodoSelect=s==modelo.graficoNodos;

            if all(nodoSelect==0)
                continue;
            else       
                if any(nodoSelect==1)
                    if isempty(Ni)
                        if ~isempty(Conduit)
                            PNi=[Conduit(:).nodoI];
                            nodosIniciales=modelo.graficoNodos(PNi);
                            checkInicio=modelo.graficoNodos(nodoSelect)==nodosIniciales;
                            if any(checkInicio==1)
                                if strcmp(idioma,'english')
                                    Aviso( 'A node cannot have 2 branches','Info','warn');
                                else
                                    Aviso( 'Un nodo no puede tener dos bifurcaciones','Info','warn');
                                end
                                uiwait
                            else
                                Ni=Node(nodoSelect);
                            end
                        else
                            Ni=Node(nodoSelect);
                        end
                    elseif ~isempty(Ni) && ~isempty(Conduit)
                        nodosIniciales=[Conduit(:).nodoI];
                        nodosFinales=[Conduit(:).nodoF];
                        checkFinal=Node(nodoSelect).ID==nodosIniciales;
                        checkInicio=Ni.ID==nodosFinales;
                        xIxF=checkFinal.*checkInicio;
 
                        if any(xIxF==1)
                            if strcmp(idioma,'english')
                                Aviso( 'The conduit already exists','Info','warn');
                            else
                                Aviso( 'La tuberÃ­a ya existe','Info','warn');
                            end
                            uiwait
                            Ni=[];
                            continue;
                        elseif any(checkInicio==1) && any(checkFinal==1)
                            if strcmp(idioma,'english')
                                Aviso('Cycles cannot be formed','Info','warn');
                            else
                                Aviso('No deben existir ciclos en el sistema','Info','warn');
                            end
                            uiwait
                            Ni=[];
                            continue;
                        end               
                        Nf=Node(nodoSelect);
                    else
                        Nf=Node(nodoSelect);
                    end
                end
            end   
            if isempty(Ni)||isempty(Nf)
                if isempty(Ni)
                    Nf=[];
                    Ni=[];
                end
            elseif Ni.posicion==Nf.posicion
                if strcmp(idioma,'english')
                    Aviso('Select different nodes' ,'Info','warn');
                else
                    Aviso('Seleccionar nodos diferentes' ,'Info','warn');
                end
                Ni=[];
                Nf=[];
                uiwait
            else
                
                Conduit=[Conduit,tuberiaH(length(Conduit)+1,Ni,Nf)];
                Conduit(end).color=Color;
                Conduit(end).labelColor=TextColor;
                Conduit(end).tamano=SizeObj;
                Conduit(end).fontSize=TTexto;

                modelo.graficoTuberias=[modelo.graficoTuberias,plotTuberia(Conduit(end))];
                modelo.labelTuberias=[modelo.labelTuberias,plotLabelT(Conduit(end))];
                if strcmp(get(handles.tuberiasLabel,'Checked'),'off')
                    set(modelo.labelTuberias(end),'visible','off');
                end

                if get(handles.checkTuberias,'Value')==1
                    modelo.bandera={Conduit(end),'creacion'};
                    editarGeneral(crearTuberiaH);
                    if ~isempty(modelo.bandera)
                        Conduit(end)=modelo.bandera;
                    end
                end
                tablaTuberias(Conduit,handles,'creacion')
                ax = gca;
                VPermutar=ax.Children;
                Orden = TuberiaOrdenGrafico(VPermutar,Catchment,modelo.background);
                ax.Children = ax.Children(Orden);
                Ni=[];
                Nf=[];
            end 
        elseif strcmp(s1,s2)==0
            break
        end
    end
end
datacursormode off;

if ~isempty(Conduit)
    set(handles.colorCuenca,'Enable','on')
    set(handles.tamanoTuberia,'Enable','on')
    set(handles.tamanoLabelT,'Enable','on')
    set(handles.colorLabelT,'Enable','on')
end
modelo.tuberias=length(Conduit);
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
% hObject    handle to crearTuberia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Conduit element
% //    Description:
% //        -Manage the table of information for the elements
% //    Update History
% =============================================================
%
function tablaTuberias(Conduit,handles,varargin)
formatSpec = '%.2f';
switch varargin{1}
    case 'creacion'
        ID={['<html><tr><td width=9999 align=center>',num2str(Conduit(end).ID)]};
        NI={['<html><tr><td width=9999 align=center>',num2str(Conduit(end).nodoI)]};
        NF={['<html><tr><td width=9999 align=center>',num2str(Conduit(end).nodoF)]};
        
        if ~isempty(Conduit(end).seccion)
            SEC={['<html><tr><td width=9999 align=center>',Conduit(end).seccion.tipo]};
        switch Conduit(end).seccion.tipo
            case 'circular'
                P={['<html><tr><td width=9999 align=center>',num2str(Conduit(end).seccion.diametro,formatSpec)]};
            otherwise
                P={['<html><tr><td width=9999 align=center>',num2str(Conduit(end).seccion.alto,formatSpec)]};
        end
        else
            P={[]};
            SEC={[]};
        end
        L={['<html><tr><td width=9999 align=center>',num2str(Conduit(end).longitud,formatSpec)]};
        n={['<html><tr><td width=9999 align=center>',num2str(Conduit(end).n,'%.3f')]};
        EI={['<html><tr><td width=9999 align=center>',num2str(Conduit(end).ERNi,formatSpec)]};
        EF={['<html><tr><td width=9999 align=center>',num2str(Conduit(end).ERNf,formatSpec)]};
        if length(Conduit)==1
            Datos=[ID,NI,NF,SEC,P,L,n,EI,EF];
        else
            Datos=get(handles.tablaTuberias,'data');
            Datos=[Datos;ID,NI,NF,SEC,P,L,n,EI,EF];
        end
    case 'edicion'
        r=varargin{2};
        Datos=get(handles.tablaTuberias,'data');

        NI=['<html><tr><td width=9999 align=center>',num2str(Conduit(r).nodoI)];
        NF=['<html><tr><td width=9999 align=center>',num2str(Conduit(r).nodoF)];
        
        if ~isempty(Conduit(r).seccion)
            SEC=['<html><tr><td width=9999 align=center>',Conduit(r).seccion.tipo];
        switch Conduit(r).seccion.tipo
            case 'circular'
                P=['<html><tr><td width=9999 align=center>',num2str(Conduit(r).seccion.diametro,formatSpec)];
            otherwise
                P=['<html><tr><td width=9999 align=center>',num2str(Conduit(r).seccion.alto,formatSpec)];
        end
        else
            P=[];
            SEC=[];
        end
        L=['<html><tr><td width=9999 align=center>',num2str(Conduit(r).longitud,formatSpec)];
        n=['<html><tr><td width=9999 align=center>',num2str(Conduit(r).n,'%.3f')];
        EI=['<html><tr><td width=9999 align=center>',num2str(Conduit(r).ERNi,formatSpec)];
        EF=['<html><tr><td width=9999 align=center>',num2str(Conduit(r).ERNf,formatSpec)];
        Datos{r,2}=NI;
        Datos{r,3}=NF;
        Datos{r,4}=SEC;
        Datos{r,5}=P;
        Datos{r,6}=L;
        Datos{r,7}=n;
        Datos{r,8}=EI;
        Datos{r,9}=EF;

    case 'eliminacion'     
        if ~isempty(Conduit)
            Datos=cell(length(Conduit),9);
            for i=1:length(Conduit)
                ID=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).ID)];
                NI=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).nodoI)];
                NF=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).nodoF)];
                
                if ~isempty(Conduit(i).seccion)
                    SEC=['<html><tr><td width=9999 align=center>',Conduit(i).seccion.tipo];
                switch Conduit(i).seccion.tipo
                    case 'circular'
                        P=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).seccion.diametro,formatSpec)];
                    otherwise
                        P=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).seccion.alto,formatSpec)];
                end
                else
                    P={[]};
                    SEC={[]};
                end
                L=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).longitud,formatSpec)];
                n=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).n,'%.3f')];
                EI=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).ERNi,formatSpec)];
                EF=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).ERNf,formatSpec)];
                Datos{i,1}=ID;
                Datos{i,2}=NI;
                Datos{i,3}=NF;
                Datos{i,4}=SEC;
                Datos{i,5}=P;
                Datos{i,6}=L;
                Datos{i,7}=n;
                Datos{i,8}=EI;
                Datos{i,9}=EF;
            end
        else
            Datos=[];
        end
    case 'actualizacion'
        Datos=get(handles.tablaTuberias,'data');
        for i=1:length(Conduit)
            NI=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).nodoI)];
            NF=['<html><tr><td width=9999 align=center>',num2str(Conduit(i).nodoF)];
            Datos{i,2}=NI;
            Datos{i,3}=NF;
        end

end

set(handles.tablaTuberias,'data',Datos)  

%% Conduit element
% //    Description:
% //        -Set size of element (Line width)
% //    Update History
% =============================================================
%
function tamanoTuberia_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
if modelo.estado~=1
    if strcmp(idioma,'english')
        Aviso('Switch to the model tab','Info','warn');
    else
        Aviso('Cambiar a la vista modelo','Info','warn');
    end
    return
end
if strcmp(get(handles.layerTuberias,'Checked'),'off')
    if strcmp(idioma,'english')
        Aviso('Enable conduit layer','Info','warn');
    else
        Aviso('Activar capa Tuberías','Info','warn');
    end
    return
elseif isempty(modelo.tuberias)
    if strcmp(idioma,'english')
        Aviso('There are no conduits in the system','Error','error');
    else
        Aviso('No existen tuberías en el sistema','Error','error');
    end
    return
end
modelo.bandera=str2double(get(handles.tamanoTuberia,'string'));
editarGeneral(editarTamanoH)
if ~isempty(modelo.bandera)
    set(handles.tamanoTuberia,'string',modelo.bandera);
    set(modelo.graficoTuberias,'LineWidth',modelo.bandera)
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
    for i=1:length(Conduit)
        Conduit(i).tamano=modelo.bandera;
    end
     save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');   
end
% hObject    handle to tamanoTuberia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Conduit element
% //    Description:
% //        -Set color of label
% //    Update History
% =============================================================
%
function colorLabelT_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
switch modelo.estado
    case 1
        if strcmp(get(handles.layerTuberias,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable conduit layer','Info','warn');
            else
                Aviso('Activar capa Tuberías','Info','warn');
            end
            return
        end
        color = uisetcolor(get(handles.colorLabelT,'ForegroundColor'));
        if color == get(handles.colorLabelT,'ForegroundColor')
            return
        elseif ~isempty(modelo.tuberias)
            set(handles.colorLabelT,'ForegroundColor',color);
            set(modelo.labelTuberias,'Color',color);
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
            for i=1:length(Conduit)
                Conduit(i).labelColor=color;
            end
             save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
        end
    case 2
        if strcmp(get(handles.layerTuberiasR,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable conduit layer','Info','warn');
            else
                Aviso('Activar capa Tuberías','Info','warn');
            end
            return
        end
        color = uisetcolor(get(handles.colorLabelT,'ForegroundColor'));
        if ~isempty(modelo.tuberias)
            set(modelo.labelTuberiasR,'Color',color);
        end
end
% hObject    handle to colorLabelT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Conduit element
% //    Description:
% //        -Set size of font label
% //    Update History
% =============================================================
%
function tamanoLabelT_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
switch modelo.estado
    case 1
        if strcmp(get(handles.layerTuberias,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable conduit layer','Info','warn');
            else
                Aviso('Activar capa Tuberías','Info','warn');
            end
            return
        elseif isempty(modelo.tuberias)
            if strcmp(idioma,'english')
                Aviso('There are no conduit in the system','Error','error');
            else
                Aviso('No existen tuberías en el sistema','Error','error');
            end
            return
        end
        modelo.bandera=str2double(get(handles.tamanoLabelT,'string'));
        editarGeneral(editarTamanoH)
        if ~isempty(modelo.bandera)
            set(handles.tamanoLabelT,'string',modelo.bandera);
            set(modelo.labelTuberias,'FontSize',modelo.bandera)
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
            for i=1:length(Conduit)
                Conduit(i).fontSize=modelo.bandera;
            end
             save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');    
        end
    case 2
        if strcmp(get(handles.layerTuberiasR,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable conduit layer','Info','warn');
            else
                Aviso('Activar capa Tuberías','Info','warn');
            end
            return
        elseif isempty(modelo.tuberias)
            if strcmp(idioma,'english')
                Aviso('There are no conduit in the system','Error','error');
            else
                Aviso('No existen tuberías en el sistema','Error','error');
            end
            return
        end
        modelo.bandera=str2double(get(handles.tamanoLabelT,'string'));
        editarGeneral(editarTamanoH)
        if ~isempty(modelo.bandera)
            set(modelo.labelTuberiasR,'FontSize',modelo.bandera)  
        end
end
% hObject    handle to tamanoLabelT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Node element
% //    Description:
% //        -Set size of font label
% //    Update History
% =============================================================
%
function tamanoLabelN_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
switch modelo.estado
    case 1
        if strcmp(get(handles.layerNodos,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable nodes layer','Info','warn');
            else
                Aviso('Activar capa Nodos','Info','warn');
            end
            return
        elseif isempty(modelo.nodos)
            if strcmp(idioma,'english')
                Aviso('There are no nodes in the system','Error','error');
            else
                Aviso('No existen nodos en el sistema','Error','error');
            end
            return
        end
        modelo.bandera=str2double(get(handles.tamanoLabelN,'string'));
        editarGeneral(editarTamanoH)
        if ~isempty(modelo.bandera)
            set(handles.tamanoLabelN,'string',modelo.bandera);
            set(modelo.labelNodos,'FontSize',modelo.bandera)
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
            for i=1:length(Node)
                Node(i).fontSize=modelo.bandera;
            end
             save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');    
        end
    case 2
        if strcmp(get(handles.layerNodosR,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable nodes layer','Info','warn');
            else
                Aviso('Activar capa Nodos','Info','warn');
            end
            return
        elseif isempty(modelo.nodos)
            if strcmp(idioma,'english')
                Aviso('There are no nodes in the system','Error','error');
            else
                Aviso('No existen nodos en el sistema','Error','error');
            end
            return
        end
        modelo.bandera=str2double(get(handles.tamanoLabelN,'string'));
        editarGeneral(editarTamanoH)
        if ~isempty(modelo.bandera)
            set(modelo.labelNodosR,'FontSize',modelo.bandera) 
        end
end
% hObject    handle to tamanoLabelN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Node element
% //    Description:
% //        -Set color of label
% //    Update History
% =============================================================
%
function colorLabelN_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo

switch modelo.estado
    case 1
        if strcmp(get(handles.layerNodos,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable nodes layer','Info','warn');
            else
                Aviso('Activar capa Nodos','Info','warn');
            end
            return
        end
        color = uisetcolor(get(handles.colorLabelN,'ForegroundColor'));
        if color == get(handles.colorLabelN,'ForegroundColor')
            return
        elseif ~isempty(modelo.nodos)
            set(handles.colorLabelN,'ForegroundColor',color);
            set(modelo.labelNodos,'Color',color);
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
            for i=1:length(Node)
                Node(i).labelColor=color;
            end
             save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        end
    case 2
        if strcmp(get(handles.layerNodosR,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable nodes layer','Info','warn');
            else
                Aviso('Activar capa Nodos','Info','warn');
            end
            return
        end
        color = uisetcolor(get(handles.colorLabelN,'ForegroundColor'));
        if ~isempty(modelo.nodos)
            set(modelo.labelNodosR,'Color',color);
        end
end
% hObject    handle to colorLabelN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Node element
% //    Description:
% //        -Set size of element (point)
% //    Update History
% =============================================================
%
function tamanoNodo_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
switch modelo.estado
    case 1
        if strcmp(get(handles.layerNodos,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable nodes layer','Info','warn');
            else
                Aviso('Activar capa Nodos','Info','warn');
            end
            return
        elseif isempty(modelo.nodos)
            if strcmp(idioma,'english')
                Aviso('There are no nodes in the system','Error','error');
            else
                Aviso('No existen nodos en el sistema','Error','error');
            end
            return
        end
        modelo.bandera=str2double(get(handles.tamanoNodo,'string'));
        editarGeneral(editarTamanoH)
        if ~isempty(modelo.bandera)
            set(handles.tamanoNodo,'string',modelo.bandera);
            set(modelo.graficoNodos,'MarkerSize',modelo.bandera)
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
            for i=1:length(Node)
                Node(i).tamano=modelo.bandera;
            end
             save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');    
        end
    case 2
        if strcmp(get(handles.layerNodosR,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable nodes layer','Info','warn');
            else
                Aviso('Activar capa Nodos','Info','warn');
            end
            return
        elseif isempty(modelo.nodos)
            if strcmp(idioma,'english')
                Aviso('There are no nodes in the system','Error','error');
            else
                Aviso('No existen nodos en el sistema','Error','error');
            end
            return
        end
        modelo.bandera=str2double(get(handles.tamanoNodo,'string'));
        editarGeneral(editarTamanoH)
        set(modelo.graficoNodosR,'MarkerSize',modelo.bandera)
end
% hObject    handle to tamanoNodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Node element
% //    Description:
% //        -Create and configurate element options
% //    Update History
% =============================================================
%
function crearNodo_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma

if modelo.estado~=1
    if strcmp(idioma,'english')
        Aviso('Switch to the model tab','Info','warn');
    else
        Aviso('Cambiar a la vista modelo','Info','warn');
    end
    return
end
if strcmp(get(handles.layerNodos,'Checked'),'off')
    if strcmp(idioma,'english')
        Aviso('Enable nodes layer','Info','warn');
    else
        Aviso('Activar capa Nodos','Info','warn');
    end
    return
end
setPanelVisible('Nodo',handles);

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');

TTexto=str2double(get(handles.tamanoLabelN,'String'));
SizeObj=str2double(get(handles.tamanoNodo,'String'));
TextColor=get(handles.colorLabelN,'ForegroundColor');
Color=get(handles.boxColorN,'BackgroundColor');
boton = 1;

while boton == 1   
    [xi,yi,boton] = myginput(1,'crosshair');
    if boton~=1
      break
    end
    xl = xlim;
    yl=ylim;
    z=xi>=xl(1)& xi<=xl(2) & yi>=yl(1)& yi<=yl(2)& boton==1; 
    if z==1
        if ~isempty(Node)
            Vx=[Node(:).corX];
            Vy=[Node(:).corY];
            Px=xi==Vx;
            Py=yi==Vy;
            if any(Px==1 & Py==1)
                if strcmp(idioma,'english')
                    Aviso('The node already exists','Info','warn');
                else
                    Aviso('El nodo ya existe','Info','warn');
                end
                 return
             else
               iden=1;
            end                        
        else
            iden=1;
        end
        if iden==1
            Node=[Node,nodoH(length(Node)+1,xi,yi)];
            Node(end).color=Color;
            Node(end).labelColor=TextColor;
            Node(end).tamano=SizeObj;
            Node(end).fontSize=TTexto;            
            modelo.graficoNodos=[modelo.graficoNodos,plotNodo(Node(end))];
            modelo.labelNodos=[modelo.labelNodos,plotLabelN(Node(end))];
            
            if strcmp(get(handles.nodosLabel,'Checked'),'off')
                set(modelo.labelNodos(end),'visible','off');
            end
            if get(handles.checkNodos,'Value')==1 
                modelo.bandera={Node(end),'creacion'};
                editarGeneral(crearNodoH)
                if ~isempty(modelo.bandera)
                    Node(end)=modelo.bandera;
                end
            end
            tablaNodos(Node,handles,'creacion')
        end                     
    end
    
end
if ~isempty(Node)
    set(handles.colorNodo,'Enable','on')
    set(handles.tamanoNodo,'Enable','on')
    set(handles.tamanoLabelN,'Enable','on')
    set(handles.colorLabelN,'Enable','on')
end

modelo.nodos=length(Node);
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
% hObject    handle to crearNodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Node element
% //    Description:
% //        -Manage the table of information for the elements
% //    Update History
% =============================================================
%
function tablaNodos(Node,handles,varargin)
formatSpec = '%.2f';
formatSpec2 = '%.6f';
switch varargin{1}
    case 'creacion'
        ID={['<html><tr><td width=9999 align=center>',num2str(Node(end).ID)]};
        X={['<html><tr><td width=9999 align=center>',num2str(Node(end).corX,formatSpec2)]};
        Y={['<html><tr><td width=9999 align=center>',num2str(Node(end).corY,formatSpec2 )]};
        ET={['<html><tr><td width=9999 align=center>',num2str(Node(end).elevacionT,formatSpec)]};
        ER={['<html><tr><td width=9999 align=center>',num2str(Node(end).elevacionR,formatSpec)]};
        Des={['<html><tr><td width=9999 align=center>',num2str(Node(end).desnivel,formatSpec)]};
        if length(Node)==1
            Datos=[ID,X,Y,ET,ER,Des];
        else
            Datos=get(handles.tablaNodos,'data');
            Datos=[Datos;ID,X,Y,ET,ER,Des];
        end
    case 'edicion'
        r=varargin{2};
        Datos=get(handles.tablaNodos,'data');
        Datos{r,4}=['<html><tr><td width=9999 align=center>',num2str(Node(r).elevacionT,formatSpec)];
        Datos{r,5}=['<html><tr><td width=9999 align=center>',num2str(Node(r).elevacionR,formatSpec)];
        Datos{r,6}=['<html><tr><td width=9999 align=center>',num2str(Node(r).desnivel,formatSpec)];
    case 'eliminacion'     
        if ~isempty(Node)
            Datos=cell(length(Node),4);
            for i=1:length(Node)
                ID=['<html><tr><td width=9999 align=center>',num2str(Node(i).ID)];
                X=['<html><tr><td width=9999 align=center>',num2str(Node(i).corX,formatSpec2)];
                Y=['<html><tr><td width=9999 align=center>',num2str(Node(i).corY,formatSpec2 )];
                ET=['<html><tr><td width=9999 align=center>',num2str(Node(i).elevacionT,formatSpec)];
                ER=['<html><tr><td width=9999 align=center>',num2str(Node(i).elevacionR,formatSpec)];
                Des=['<html><tr><td width=9999 align=center>',num2str(Node(i).desnivel,formatSpec)];
                Datos{i,1}=ID;
                Datos{i,2}=X;
                Datos{i,3}=Y;
                Datos{i,4}=ET;
                Datos{i,5}=ER;
                Datos{i,6}=Des;
            end
        else
            Datos=[];
        end
end
set(handles.tablaNodos,'data',Datos)   

%% Node element
% //    Description:
% //        -Set color of element
% //    Update History
% =============================================================
%
function colorNodo_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma

switch modelo.estado
    case 1
        if strcmp(get(handles.layerNodos,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable nodes layer','Info','warn');
            else
                Aviso('Activar capa Nodos','Info','warn');
            end
            return
        end
        color = uisetcolor(get(handles.boxColorN,'BackgroundColor'));
        if color == get(handles.boxColorN,'BackgroundColor')
            return
        elseif ~isempty(modelo.nodos)
            set(handles.boxColorN,'BackgroundColor',color);
            set(modelo.graficoNodos,'Color',color);
            set(modelo.graficoNodos,'MarkerFaceColor',color);
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
            for i=1:length(Node)
                Node(i).color=color;
            end
             save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        end
    case 2
        if strcmp(get(handles.layerNodosR,'Checked'),'off')
            if strcmp(idioma,'english')
                Aviso('Enable nodes layer','Info','warn');
            else
                Aviso('Activar capa Nodos','Info','warn');
            end
            return
        end
        color = uisetcolor(get(handles.boxColorN,'BackgroundColor'));
        if color == get(handles.boxColorN,'BackgroundColor')
            return
        elseif ~isempty(modelo.nodos)
            set(modelo.graficoNodosR,'Color',color);
            set(modelo.graficoNodosR,'MarkerFaceColor',color);
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
            for i=1:length(Node)
                Node(i).color=color;
            end
             save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        end
end
% hObject    handle to colorNodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in boxColorN
function boxColorN_Callback(hObject, eventdata, handles)
% hObject    handle to boxColorN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxColorN as text
%        str2double(get(hObject,'String')) returns contents of boxColorN as a double


%% --- Executes during object creation, after setting all properties.
function boxColorN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxColorN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Conduit element
% //    Description:
% //        -Change direction of element
% //    Update History
% =============================================================
%
function pushbutton31_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
if ~isempty(modelo.tuberias)&&modelo.tuberias>0
    Tor=cell(1,modelo.tuberias);
    for i=1:modelo.tuberias
        Tor{i}=['ID-',num2str(i)];
    end
    Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Conduits','SelectionMode','single');
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
        modelo.bandera={Conduit(Z),'edicion'};
        editarGeneral(crearTuberiaH)
        if ~isempty(modelo.bandera)
            nodosIniciales=[Conduit(:).nodoI];
            nodoI=modelo.bandera.nodoI;
            nodoF=modelo.bandera.nodoF;
            u=find(nodoI==nodosIniciales);
            if length(u)>1 || nodoI==nodoF
                modelo.bandera.nodoI=Conduit(Z).nodoI;
                modelo.bandera.nodoF=Conduit(Z).nodoF;
                if strcmp(idioma,'english')
                    Aviso('Unable to update direction','Error','error');
                else
                    Aviso('No es posbile actualizar la dirección','Error','error');
                end
            else
                load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
                modelo.bandera.St=Node(nodoI).elevacionT-Node(nodoF).elevacionT;
                modelo.bandera.IPosicion=Nposicion(Node(nodoI));
                modelo.bandera.FPosicion=Nposicion(Node(nodoF));
                    C=[(modelo.bandera.IPosicion(1)+modelo.bandera.FPosicion(1))/2,(modelo.bandera.IPosicion(2)+modelo.bandera.FPosicion(2))/2];
                modelo.bandera.MPosicion=C;
                X=[modelo.bandera.IPosicion(1),modelo.bandera.FPosicion(1)];
                Y=[modelo.bandera.IPosicion(2),modelo.bandera.FPosicion(2)];
                modelo.graficoTuberias(modelo.bandera.ID).XData=X;
                modelo.graficoTuberias(modelo.bandera.ID).YData=Y;
                modelo.labelTuberias(modelo.bandera.ID).Position=[modelo.bandera.MPosicion(1),modelo.bandera.MPosicion(2)];
            end        
            Conduit(Z)=modelo.bandera;
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
            tablaTuberias(Conduit,handles,'edicion',Z)
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no conduit in the system','Error','error');
    else
        Aviso('No existen tuberías en el sistema','Error','error');
    end
    return
end
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Conduit element
% //    Description:
% //        -Delete element
% //    Update History
% =============================================================
%
function pushbutton32_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if ~isempty(modelo.tuberias)&&modelo.tuberias>0
    Tor=cell(1,modelo.tuberias);
    for i=1:modelo.tuberias
        Tor{i}=['ID-',num2str(i)];
    end
    Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Conduits','SelectionMode','multiple');
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
        Conduit(Z)=[];
        delete(modelo.graficoTuberias(Z));
        delete(modelo.labelTuberias(Z));
        modelo.graficoTuberias(Z)=[];
        modelo.labelTuberias(Z)=[];
        if ~isempty(Conduit)
            for i=1:length(Conduit)
                Conduit(i).ID=i;
                modelo.labelTuberias(i).String= ['T-',num2str(Conduit(i).ID)];
            end
        end
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
        tablaTuberias(Conduit,handles,'eliminacion')
        modelo.tuberias=length(Conduit);
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no conduit in the system','Error','error');
    else
        Aviso('No existen tuberías en el sistema','Error','error');
    end
    return
end
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Storm element
% //    Description:
% //        -Plot hyetograph
% //    Update History
% =============================================================
%
function pushbutton35_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if size(modelo.tormentas,1)==0
    if strcmp(idioma,'english')
        Aviso('There are no storms in the model','Error','error');
    else
        Aviso('No existen tormentas','Error','error');
    end
    return
end

Tor={};
for i=1:length(modelo.tormentas)
    Tor{end+1}=num2str(i);
end

if strcmp(idioma,'english')
    Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Storm');
else
    Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Tormenta');
end

if isempty(Z)
   return;
else
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
    if strcmp(idioma,'english')
        f=figure('Name',['Hyetograph-',num2str(Z)],'NumberTitle','off');
        for i=1:length(Z)
            subplot(length(Z),1,i)
            bar(Storm(Z(i)).hietograma(:,1),Storm(Z(i)).hietograma(:,2));
            grid on
            grid minor
            xlabel('Storm duration (min)');
            ylabel('Precipitation (mm)');
            set(gca,'FontSize',8,'FontUnits','pixels','FontWeight','bold','XGrid',...
            'on','YGrid','on');
            legend({['Storm ID - ',num2str(Z(i))]})
        end
    else
        f=figure('Name',['Hietograma-',num2str(Z)],'NumberTitle','off');
        for i=1:length(Z)
            subplot(length(Z),1,i)
            bar(Storm(Z(i)).hietograma(:,1),Storm(Z(i)).hietograma(:,2));
            grid on
            grid minor
            xlabel('Duración de tormenta (min)');
            ylabel('Precipitación(mm)');
            set(gca,'FontSize',8,'FontUnits','pixels','FontWeight','bold','XGrid',...
            'on','YGrid','on');
            legend({['Tormenta ID - ',num2str(Z(i))]})
        end
    end

    posicion1=get(handles.moduloHidrologico,'Position');
    posicion2=f.Position;
    pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.75;
    pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.35;
    posicion=[pos1,pos2,posicion2(3:4)];
    f.Position=posicion;
end
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Storm element
% //    Description:
% //        -Edit element information
% //    Update History
% =============================================================
%
function pushbutton36_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
if~isempty(modelo.tormentas)&&modelo.tormentas>0
    Tor=cell(1,modelo.tormentas);
    for i=1:modelo.tormentas
        Tor{i}=['ID-',num2str(i)];
    end
    Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Storm','SelectionMode','single');
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');

        switch Storm(Z).tipo
            case 'EcuacionGen'
                modelo.bandera=Storm(Z);
                editarGeneral(editTormentaH)
                if ~isempty(modelo.bandera)
                    Storm(Z)=modelo.bandera;
                end
            case 'hietograma'
                if strcmp(idioma,'english')
                    Aviso('It is not possible to edit the type of storm','Error','error');
                else
                    Aviso('No es posible editar la troementa','Error','error');
                end
                return;
            case 'EcuacionChen'
                modelo.bandera=Storm(Z);
                editarGeneral(editTormentaH)
                if ~isempty(modelo.bandera)
                    Storm(Z)=modelo.bandera;
                end
        end
        if ~isempty(modelo.bandera)
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
            tablaTormentas(Storm,handles,'edicion',Z)
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no storms in the system','Error','error');
    else
        Aviso('No existen tormentas','Error','error');
    end
    return
end
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Storm element
% //    Description:
% //        -Delete element
% //    Update History
% =============================================================
%
function pushbutton37_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if ~isempty(modelo.tormentas)&&modelo.tormentas>0
    Tor=cell(1,modelo.tormentas);
    for i=1:modelo.tormentas
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Storm','SelectionMode','multiple');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Tormenta','SelectionMode','multiple');
    end
    
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        if ~isempty(Catchment)
            IDantiguo=[Storm.ID];
            IDnuevo=IDantiguo;
            IDnuevo(Z)=0;
            tormCuencasAntiguo=[Catchment.tormenta];
            tormCuencasNuevo=tormCuencasAntiguo;
            contador=1;
            for i=1:length(IDantiguo)
                if IDnuevo(i)~=0
                    IDnuevo(i)=contador;
                    contador=contador+1;
                end
            end
    
            for i=1:length(IDantiguo)
                a=IDantiguo(i)==tormCuencasAntiguo;
                tormCuencasNuevo(a)=IDnuevo(i);
            end
    
            for i=1:length(tormCuencasNuevo)
                if tormCuencasNuevo(i)~=0
                    Catchment(i).tormenta=tormCuencasNuevo(i);
                else
                    Catchment(i).tormenta=[];
                end
            end
        end
        Storm(Z)=[];
        if ~isempty(Storm)
            for i=length(Storm)
                Storm(i).ID=i;
            end
        end
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
        tablaCuencas(Catchment,handles,'eliminacion')
        tablaTormentas(Storm,handles,'eliminacion')
        modelo.tormentas=length(Storm);
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no storms in the system','Error','error');
    else
        Aviso('No existen tormentas','Error','error');
    end
    return
end
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Catchment element
% //    Description:
% //        -Edit element information
% //    Update History
% =============================================================
%
function pushbutton33_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
if ~isempty(modelo.cuencas)&& modelo.cuencas>0
    Tor=cell(1,modelo.cuencas);
    for i=1:modelo.cuencas
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Catchment','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Cuenca','SelectionMode','single');
    end
    
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        modelo.bandera={Catchment(Z),'edicion'};
        editarGeneral(crearCuencaH);
        if ~isempty(modelo.bandera)         
            des=Catchment(Z).descarga;
            if modelo.bandera.descarga~=des
                modelo.bandera.corD=[Node(modelo.bandera.descarga).corX,Node(modelo.bandera.descarga).corY];
                modelo.graficoDCuencas(Z).XData=[modelo.bandera.centroide(1),modelo.bandera.corD(1)];
                modelo.graficoDCuencas(Z).YData=[modelo.bandera.centroide(2),modelo.bandera.corD(2)];
            end
            Catchment(Z)=modelo.bandera;
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            tablaCuencas(Catchment,handles,'edicion',Z);
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no catchment in the system','Error','error');
    else
        Aviso('No existen cuencas en el sistema','Error','error');
    end
    return
end  
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Catchment element
% //    Description:
% //        -Delete element
% //    Update History
% =============================================================
%
function pushbutton34_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if ~isempty(modelo.cuencas)&&modelo.cuencas>0
    Tor=cell(1,modelo.cuencas);
    for i=1:modelo.cuencas
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Catchment','SelectionMode','multiple');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Cuenca','SelectionMode','multiple');
    end
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        Catchment(Z)=[];
        delete(modelo.graficoCuencas(Z));
        delete(modelo.labelCuencas(Z));
        delete(modelo.graficoCCuencas(Z));
        delete(modelo.graficoDCuencas(Z));
        modelo.graficoCuencas(Z)=[];
        modelo.graficoCCuencas(Z)=[];
        modelo.graficoDCuencas(Z)=[];
        modelo.labelCuencas(Z)=[];

        if ~isempty(Catchment)
            for i=1:length(Catchment)
                Catchment(i).ID=i;
                modelo.labelCuencas(i).String= ['C-',num2str(Catchment(i).ID)];
            end
        end
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        tablaCuencas(Catchment,handles,'eliminacion')
        modelo.cuencas=length(Catchment);
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no catchment in the system','Error','error');
    else
        Aviso('No existen cuencas en el sistema','Error','error');
    end
    return
end
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Storm element
% //    Description:
% //        -Load hyetograph file
% //    Update History
% =============================================================
%
function pushbutton38_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo    

    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
    if ~isempty(Storm)
        ID=length(Storm)+1;
    else
        ID=1;
    end
    modelo.bandera=tormentaH(ID,'hietograma');
    editarGeneral(editTormentaHC)
    if ~isempty(modelo.bandera)
        Aviso('The data was imported successfully','Success','help');
    else
        return
    end
    Storm=[Storm,modelo.bandera];
    
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
    tablaTormentas(Storm,handles,'creacion')
    modelo.tormentas=length(Storm);

% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Storm element
% //    Description:
% //        -Load IDTr curve file
% //    Update History
% =============================================================
%
function pushbutton39_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if strcmp(idioma,'english')
    [archivo,carpeta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.mat'],'Select data file');
else
    [archivo,carpeta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.mat'],'Seleccionar archivo de datos');
end

if archivo == 0
    return;
else
    C = strsplit(archivo,'.');
    ProyectoHidrologico.nombrePrecipitaciones=C{1};
    load(fullfile(carpeta,archivo),'nombre','estimacion','construccion');
    if estimacion==1 && construccion==1
        if strcmp(idioma,'english')
            Metodo = questdlg('Select preferred acquisition method?', ...
                'Existing IDTr curves', ...
                'Estimation','Construction','Cancel','Cancel');
        else
            Metodo = questdlg('Seleccionar método?', ...
                'Curvas IDTr', ...
                'Estimación','Construcción','Cancelar','Cancelar');
        end

        switch Metodo
            case 'Estimación'
                load(fullfile(carpeta,'Data','estimacion_curvasIDTr.mat'),'curvasIDTr');
                k=curvasIDTr.ecuacion(1);
                m=curvasIDTr.ecuacion(2);
                n=curvasIDTr.ecuacion(3);
                b=curvasIDTr.ecuacion(4);
                tipo='EcuacionChen';
            case 'Construcción'
                load(fullfile(carpeta,'Data','construccion_curvasIDTr.mat'),'curvasIDTr');
                k=curvasIDTr.ecuacion(1);
                m=curvasIDTr.ecuacion(2);
                n=curvasIDTr.ecuacion(3);
                b=0;
                tipo='EcuacionGen';
            case 'Estimation'
                load(fullfile(carpeta,'Data','estimacion_curvasIDTr.mat'),'curvasIDTr');
                k=curvasIDTr.ecuacion(1);
                m=curvasIDTr.ecuacion(2);
                n=curvasIDTr.ecuacion(3);
                b=curvasIDTr.ecuacion(4);
                tipo='EcuacionChen';
            case 'Construction'
                load(fullfile(carpeta,'Data','construccion_curvasIDTr.mat'),'curvasIDTr');
                k=curvasIDTr.ecuacion(1);
                m=curvasIDTr.ecuacion(2);
                n=curvasIDTr.ecuacion(3);
                b=0;
                tipo='EcuacionGen';
            otherwise
                return;
        end
    elseif estimacion==1
           load(fullfile(carpeta,'Data','estimacion_curvasIDTr.mat'),'curvasIDTr');
            k=curvasIDTr.ecuacion(1);
            m=curvasIDTr.ecuacion(2);
            n=curvasIDTr.ecuacion(3);
            b=curvasIDTr.ecuacion(4);
            tipo='EcuacionChen';
    elseif construccion==1
            load(fullfile(carpeta,'Data','construccion_curvasIDTr.mat'),'curvasIDTr');
            k=curvasIDTr.ecuacion(1);
            m=curvasIDTr.ecuacion(2);
            n=curvasIDTr.ecuacion(3);
            b=0;
            tipo='EcuacionGen';
    else
        if strcmp(idioma,'english')
            Aviso('There is no IDTr information','Error','Error');
        else
            Aviso('No existe información IDTr','Error','Error');
        end 
        return
    end

    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
    
    if ~isempty(Storm)
        ID=length(Storm)+1;
    else
        ID=1;
    end

    modelo.bandera=tormentaH(ID,tipo,k,m,n,b);
    editarGeneral(editTormentaH)
    if ~isempty(modelo.bandera)
        if strcmp(idioma,'english')
            Aviso('The data was imported successfully','Success','help');
        else
            Aviso('Los datos se importaron correctamente','Success','help');
        end 
    else
        return
    end
    Storm=[Storm,modelo.bandera];
    
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
    tablaTormentas(Storm,handles,'creacion')
    modelo.tormentas=length(Storm);
end
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Storm element
% //    Description:
% //        -Manage the table of information for the elements
% //    Update History
% =============================================================
%
function tablaTormentas(Storm,handles,varargin)
switch varargin{1}
    case 'creacion'
        ID={['<html><tr><td width=9999 align=center>',num2str(Storm(end).ID)]};
        Tr={['<html><tr><td width=9999 align=center>',num2str(Storm(end).tr)]};
        duracion={['<html><tr><td width=9999 align=center>',num2str(Storm(end).duracion)]};
        intervalo={['<html><tr><td width=9999 align=center>',num2str(Storm(end).dt)]};
        metodoHietograma={['<html><tr><td width=9999 align=center>',Storm(end).metodoHietograma]};
        fecha={['<html><tr><td width=9999 align=center>',Storm(end).fechaInicio]};
        hora={['<html><tr><td width=9999 align=center>',num2str(Storm(end).horaInicio),':',num2str(Storm(end).minInicio)]};
        if length(Storm)==1
            Datos=[ID,Tr,duracion,intervalo,metodoHietograma,fecha,hora];
        else
            Datos=get(handles.tablaTormentas,'data');
            Datos=[Datos;ID,Tr,duracion,intervalo,metodoHietograma,fecha,hora];
        end
    case 'edicion'
        r=varargin{2};
        ID={['<html><tr><td width=9999 align=center>',num2str(Storm(r).ID)]};
        Tr={['<html><tr><td width=9999 align=center>',num2str(Storm(r).tr)]};
        duracion={['<html><tr><td width=9999 align=center>',num2str(Storm(r).duracion)]};
        intervalo={['<html><tr><td width=9999 align=center>',num2str(Storm(r).dt)]};
        metodoHietograma={['<html><tr><td width=9999 align=center>',Storm(r).metodoHietograma]};
        fecha={['<html><tr><td width=9999 align=center>',num2str(Storm(r).fechaInicio)]};
        hora={['<html><tr><td width=9999 align=center>',num2str(Storm(r).horaInicio),':',num2str(Storm(r).minInicio)]};
        Datos=get(handles.tablaTormentas,'data');
        Datos(r,1)=ID;
        Datos(r,2)=Tr;
        Datos(r,3)=duracion;
        Datos(r,4)=intervalo;
        Datos(r,5)=metodoHietograma;
        Datos(r,6)=fecha;
        Datos(r,7)=hora;
    case 'eliminacion'     
        if ~isempty(Storm)
            Datos=cell(length(Storm),2);
            for i=1:length(Storm)
                ID={['<html><tr><td width=9999 align=center>',num2str(Storm(i).ID)]};
                Tr={['<html><tr><td width=9999 align=center>',num2str(Storm(i).tr)]};
                duracion={['<html><tr><td width=9999 align=center>',num2str(Storm(i).duracion)]};
                intervalo={['<html><tr><td width=9999 align=center>',num2str(Storm(i).dt)]};
                metodoHietograma={['<html><tr><td width=9999 align=center>',Storm(i).metodoHietograma]};
                fecha={['<html><tr><td width=9999 align=center>',num2str(Storm(i).fechaInicio)]};
                hora={['<html><tr><td width=9999 align=center>',num2str(Storm(i).horaInicio),':',num2str(Storm(i).minInicio)]};
                Datos(i,1)=ID;
                Datos(i,2)=Tr;
                Datos(i,3)=duracion;
                Datos(i,4)=intervalo;
                Datos(i,5)=metodoHietograma;
                Datos(i,6)=fecha;
                Datos(i,7)=hora;
            end
        else
            Datos=[];
        end
end
if ~isempty(Storm)
    Tor=cell(1,length(Storm)+1);
    Tor{1}=[];
    for i=2:length(Storm)+1
        Tor{i}=['ID-',num2str(i-1)];
    end
    set(handles.popupmenu8,'Enable','on')
else
    Tor{1}='---';
    set(handles.popupmenu8,'Enable','off')
end
set(handles.popupmenu8,'String',Tor)
set(handles.popupmenu8,'value',1)
set(handles.tablaTormentas,'data',Datos)  

%% Storm element
% //    Description:
% //        -Create and configurate element options
% //    Update History
% =============================================================
%
function pushbutton40_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
    
    if ~isempty(Storm)
        ID=length(Storm)+1;
    else
        ID=1;
    end
    modelo.bandera=tormentaH(ID,'EcuacionGen','','','');
        
    editarGeneral(editTormentaH)
    if ~isempty(modelo.bandera)
    else
        if strcmp(idioma,'english')
            Aviso('The storm could not be created','Error','error');
        else
            Aviso('La tormenta no puede crearse','Error','error');
        end 
        return
    end
    Storm=[Storm,modelo.bandera];
    
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
    tablaTormentas(Storm,handles,'creacion')
    modelo.tormentas=length(Storm);
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton48.
function pushbutton48_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Node element
% //    Description:
% //        -Edit element information
% //    Update History
% =============================================================
%
function pushbutton49_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
if ~isempty(modelo.nodos)&&modelo.nodos>0
    Tor=cell(1,modelo.nodos);
    for i=1:modelo.nodos
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Node','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Nodo','SelectionMode','single');
    end 
    
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        modelo.bandera={Node(Z),'edicion'};
        editarGeneral(crearNodoH)
        if ~isempty(modelo.bandera)
            Node(Z)=modelo.bandera;
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
            tablaNodos(Node,handles,'edicion',Z)
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no nodes in the system','Error','error')
    else
        Aviso('TNo existen nodos en el sistema','Error','error')
    end 
    return
end
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Node element
% //    Description:
% //        -Delete element
% //    Update History
% =============================================================
%
function pushbutton50_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if ~isempty(modelo.nodos)&&modelo.nodos>0
    Tor=cell(1,modelo.nodos);
    for i=1:modelo.nodos
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Node','SelectionMode','multiple');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Nodo','SelectionMode','multiple');
    end 

    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        if ~isempty(modelo.tuberias)
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
            nodoI=[Conduit(:).nodoI];
            nodoF=[Conduit(:).nodoF];
        else
            nodoI=[];
            nodoF=[];
        end
        if ~isempty(modelo.cuencas)
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            descarga=[Catchment(:).descarga];
        else
            descarga=[];
        end
        VF=[nodoI,nodoF,descarga];
        VF=unique(VF);
        if ~isempty (VF)
            a=length(Z);
            for i=1:length(VF)
                Z(VF(i)==Z)=[];
            end
            b=length(Z);
            if a~=b
                if strcmp(idioma,'english')
                    Aviso('It is not possible to delete some elements, check dependencies in the system','Error','error');
                else 
                    Aviso('No es posible eliminar el elemento, verificar dependencias en el sistema','Error','error');
                end 
               
            end
            
            if isempty(Z)
                return
            end
        end
        Node(Z)=[];
        delete(modelo.graficoNodos(Z));
        delete(modelo.labelNodos(Z));
        modelo.graficoNodos(Z)=[];
        modelo.labelNodos(Z)=[];
        if ~isempty(Node)
            for i=1:length(Node)
                a=find(Node(i).ID==nodoI);
                b=find(Node(i).ID==nodoF);
                c=find(Node(i).ID==descarga);
                if ~isempty(a)
                    for j=1:length(a)
                        Conduit(a(j)).nodoI=i;
                    end
                end
                if ~isempty(b)
                    for j=1:length(b)
                        Conduit(b(j)).nodoF=i;
                    end
                end
                if ~isempty(c)
                    for j=1:length(c)
                        Catchment(c(j)).descarga=i;
                    end
                end
                Node(i).ID=i;
                modelo.labelNodos(i).String= ['N-',num2str(Node(i).ID)];
            end
        end
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        tablaNodos(Node,handles,'eliminacion')
        modelo.nodos=length(Node);

        if exist('Conduit','var')
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
            tablaTuberias(Conduit,handles,'actualizacion');           
        end
        if exist('Catchment','var')
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            tablaCuencas(Catchment,handles,'actualizacion');
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no nodes in the system','Error','error')
    else
        Aviso('TNo existen nodos en el sistema','Error','error')
    end
    return
end
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Interface configuration
% //    Description:
% //        -Enable/disable buttons
% //    Update History
% =============================================================
%
function estadoBotones(accion,handles)
switch accion
    case 'activar'
        set(handles.crearNodo,'Enable','on')
        set(handles.colorNodo,'Enable','on')
        set(handles.boxColorN,'Enable','on')
        set(handles.tamanoNodo,'Enable','on')
        set(handles.colorLabelN,'Enable','on')
        set(handles.tamanoLabelN,'Enable','on')
        set(handles.crearTuberia,'Enable','on')
        set(handles.colorTuberia,'Enable','on')
        set(handles.boxColorT,'Enable','on')
        set(handles.tamanoTuberia,'Enable','on')
        set(handles.colorLabelT,'Enable','on')
        set(handles.tamanoLabelT,'Enable','on')
        set(handles.crearCuenca,'Enable','on')
        set(handles.colorCuenca,'Enable','on')
        set(handles.boxColorC,'Enable','on')
        set(handles.colorLabelC,'Enable','on')
        set(handles.tamanoLabelC,'Enable','on')
        set(handles.menuC,'Enable','on')
        set(handles.tormentaMP,'Enable','on')
        set(handles.importarT,'Enable','on')
        set(handles.pan,'Enable','on')
        set(handles.zoom,'Enable','on')
        set(handles.extend,'Enable','on')
        set(handles.simular,'Enable','on')
        set(handles.rotar,'Enable','on')
        
    case 'desactivar'
        set(handles.crearNodo,'Enable','inactive')
        set(handles.colorNodo,'Enable','inactive')
        set(handles.boxColorN,'Enable','inactive')
        set(handles.tamanoNodo,'Enable','inactive')
        set(handles.colorLabelN,'Enable','inactive')
        set(handles.tamanoLabelN,'Enable','inactive')
        set(handles.crearTuberia,'Enable','inactive')
        set(handles.colorTuberia,'Enable','inactive')
        set(handles.boxColorT,'Enable','inactive')
        set(handles.tamanoTuberia,'Enable','inactive')
        set(handles.colorLabelT,'Enable','inactive')
        set(handles.tamanoLabelT,'Enable','inactive')
        set(handles.crearCuenca,'Enable','inactive')
        set(handles.colorCuenca,'Enable','inactive')
        set(handles.boxColorC,'Enable','inactive')
        set(handles.colorLabelC,'Enable','inactive')
        set(handles.tamanoLabelC,'Enable','inactive')
        set(handles.menuC,'Enable','inactive')
        set(handles.tormentaMP,'Enable','inactive')
        set(handles.importarT,'Enable','inactive')
        set(handles.pan,'Enable','inactive')
        set(handles.zoom,'Enable','inactive')
        set(handles.extend,'Enable','inactive')
        set(handles.simular,'Enable','inactive')
        set(handles.rotar,'Enable','inactive')
end

%% Project management
% //    Description:
% //        -Create a new project, directories, and required files
% //        -Enter the name and location to save the project
% //    Update History
% =============================================================
%  
function crearProyecto_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
estadoBotones('desactivar',handles)

[archivo,carpeta,~] = uiputfile('*.dat','Save project as','UHI');

if archivo==0
    set(handles.Untitled_7,'enable','off');
    return;
else
    set(handles.Untitled_7,'enable','on');
    C = textscan(archivo,'%s','Delimiter','.');
    nombre= char(C{1}{1});
    ProyectoHidrologico = proyectoHidrologico(nombre,fullfile(carpeta,nombre));
    [~, msg,~] = mkdir(ProyectoHidrologico.carpetaBase);
    [~,~,~] = mkdir(fullfile(ProyectoHidrologico.carpetaBase,'Data'));
end

if ~isempty(msg)
    if strcmp(idioma,'english')
        answer = questdlg('The file already exists, do you want to overwrite it?', ...
	        'Create file','Yes','Cancel','Cancel');
    else
        answer = questdlg('El archivo ya existe, desea sobrescribirlo?', ...
	        'Crear archivo','Si','Cancelar','Cancelar');
    end

    switch answer
        case 'Yes'
            rmdir (ProyectoHidrologico.carpetaBase,'s');
            mkdir(ProyectoHidrologico.carpetaBase);
            mkdir(fullfile(ProyectoHidrologico.carpetaBase,'Data'));
        case 'Cancel'
            set(handles.Untitled_7,'enable','off');
            return
        case 'Si'
            rmdir (ProyectoHidrologico.carpetaBase,'s');
            mkdir(ProyectoHidrologico.carpetaBase);
            mkdir(fullfile(ProyectoHidrologico.carpetaBase,'Data'));
        otherwise
            set(handles.Untitled_7,'enable','off');
            return
    end
end

ProyectoHidrologico.nombreHidrologico=nombre;
modelo = modeloHidrologico(nombre);
Node=[];
Conduit=[];
Catchment=[];
Storm=[];
Scenario=[];
NaturalResponse=[];
Retention=[];
Detention=[];
Infiltration=[];

genRetention=[];
genDetention=[];
genInfiltration=[];
Simulation=simulacion('creada');

save (fullfile(ProyectoHidrologico.carpetaBase,[ProyectoHidrologico.nombreHidrologico,'.mat']),'nombre')
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
inicializar(handles)


if strcmp(idioma,'english')
    Aviso('The project was created successfully','Success','help');
else
    Aviso('El proyecto se creó exitosamente','Success','help');
end
% hObject    handle to crearProyecto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Interface configuration
% //    Description:
% //        -Enable and disable initial model options
% //    Update History
% =============================================================
% 
function inicializar (handles)
    delete(handles.fondoInicio)
    axes(handles.axes1)
    cla
    axes(handles.axes2)
    cla
    axes(handles.axes5)
    cla
    axes(handles.axes6)
    cla

    set(handles.Untitled_7,'enable','on');
    set(handles.Untitled_5,'enable','on');
    set(handles.Untitled_6,'enable','on');
    set(handles.Untitled_9,'enable','on');
    set(handles.Untitled_10,'enable','on');

    set(handles.tablaNodos,'Data',[]);
    set(handles.tablaTuberias,'Data',[]);
    set(handles.tablaCuencas,'Data',[]);
    set(handles.tablaTormentas,'Data',[]);
    set(handles.tablaEscenarios,'Data',[]);
    set(handles.tablaGenInfiltracion,'Data',[]);
    set(handles.tablaGenDetencion,'Data',[]);
    set(handles.tablaGenRetencion,'Data',[]);
    set(handles.tablaCuencasR,'Data',[]);

    set(handles.boxColorN,'BackgroundColor','b');
    set(handles.boxColorT,'BackgroundColor',[0.49  0.18 0.56]);
    set(handles.boxColorC,'BackgroundColor',[0.93  0.69 0.13]);

    set(handles.tamanoNodo,'String',5);
    set(handles.tamanoTuberia,'String',3);
    set(handles.menuC,'Value',5);

    set(handles.colorLabelN,'ForegroundColor','k');
    set(handles.colorLabelT,'ForegroundColor','k');
    set(handles.colorLabelC,'ForegroundColor','k');

    set(handles.tamanoLabelN,'String',8);
    set(handles.tamanoLabelT,'String',8);
    set(handles.tamanoLabelC,'String',8);
 
    estadoBotones('activar',handles)
    tabGroups = handles.tabManager.TabGroups;
    set(tabGroups,'visible','off')
    
    jTabGroup = findjobj ( 'class' , 'JTabbedPane' );
    jTabGroup=jTabGroup(3);
    jTabGroup(1). setEnabledAt ( 0 , 1 );
    jTabGroup(1). setEnabledAt ( 1 , 0 );
    jTabGroup(1). setEnabledAt ( 2 , 0 );
    jTabGroup(1).setSelectedIndex(0) 
    set(tabGroups,'visible','on')

%% Project management
% //    Description:
% //        -Open an existing project
% //        -Select the .mat file from the main directory folder
% //    Update History
% =============================================================
% 
function abrirProyecto_Callback(hObject, eventdata, handles)
    global ProyectoHidrologico modelo idioma
    if strcmp(idioma,'english')
        [archivo,carpeta]=uigetfile('/*.mat','Select data file'); 
    else
        [archivo,carpeta]=uigetfile('/*.mat','Seleccionar archivo'); 
    end
          
    if archivo==0 
        return
    else
        inicializar(handles)
        jFrame = get(handle(gcf),'JavaFrame');
        jRootPane = jFrame.fHG2Client.getWindow;
        statusbarObj = com.mathworks.mwswing.MJStatusBar;
        jProgressBar = javax.swing.JProgressBar;
        numIds = 10;
        set(jProgressBar, 'Minimum',0, 'Maximum',numIds, 'Value',0);
        jRootPane.setStatusBarVisible(1);
        statusbarObj.add(jProgressBar,'West');
    
        set(jProgressBar,'Value',1);
        if strcmp(idioma,'english')
            msg = 'Reading file... (10%)'; 
        else
            msg = 'Leyendo archivo... (10%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);
        ProyectoHidrologico = proyectoHidrologico(archivo,carpeta);
        C = strsplit(archivo,'.');
        ProyectoHidrologico.nombreHidrologico=C{1};

        nombre=ProyectoHidrologico.nombreHidrologico;
        modelo = modeloHidrologico(nombre);
        Catchment=[];
        axes(handles.axes1)
        cla

        set(jProgressBar,'Value',2);
        if strcmp(idioma,'english')
            msg = 'Creating model... (20%)'; 
        else
            msg = 'Creando modelo... (20%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

        
        set(jProgressBar,'Value',3);
        
        if strcmp(idioma,'english')
            msg = 'Creating nodes... (30%)';
        else
            msg = 'Creando nodos... (30%)';
        end
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
            if ~isempty(Node)
                for i=1:length(Node)        
                    modelo.graficoNodos=[modelo.graficoNodos,plotNodo(Node(i))];
                    modelo.labelNodos=[modelo.labelNodos,plotLabelN(Node(i))];
                end
                if length(Node)>1
                    Xmin=min([Node.corX]);
                    Xmax=max([Node.corX]);
                    Ymin=min([Node.corY]);
                    Ymax=max([Node.corY]);
                    dx=Xmax-Xmin;
                    dy=Ymax-Ymin;
                    axis([Xmin-0.1*dx,Xmax+0.1*dx,Ymin-0.1*dy,Ymax+0.1*dy])
                end
                axis equal
                hold on
                tablaNodos(Node,handles,'eliminacion')
                modelo.nodos=length(Node);
            end
        else
            Node=[];
        end
        
        set(jProgressBar,'Value',4);
        if strcmp(idioma,'english')
            msg = 'Creating conduits... (50%)';
        else
            msg = 'Crando tuberías... (50%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
            if ~isempty(Conduit)
                for i=1:length(Conduit)        
                    modelo.graficoTuberias=[modelo.graficoTuberias,plotTuberia(Conduit(i))];
                    modelo.labelTuberias=[modelo.labelTuberias,plotLabelT(Conduit(i))];
                    ax = gca;
                    VPermutar=ax.Children;
                    Orden = TuberiaOrdenGrafico(VPermutar,Catchment,modelo.background);
                    ax.Children = ax.Children(Orden);
                end
                tablaTuberias(Conduit,handles,'eliminacion')
                modelo.tuberias=length(Conduit);
                Tor=cell(1,length(Conduit));
                for i=1:length(Conduit)
                    Tor{i}=['T-',num2str(i)];
                end
                set(handles.popupmenu29,'string',Tor);
            end
        else
            Conduit=[];
        end
        
        set(jProgressBar,'Value',5);
        if strcmp(idioma,'english')
            msg = 'Creating catchment... (70%)';
        else
            msg = 'Creando cuencas... (70%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);
        
        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            if ~isempty(Catchment)
                for i=1:length(Catchment)        
                    modelo.graficoCuencas=[modelo.graficoCuencas, plotCuenca(Catchment(i))];
                    modelo.graficoDCuencas=[modelo.graficoDCuencas,plotDirC(Catchment(i))];
                    modelo.graficoCCuencas=[modelo.graficoCCuencas,plotCentroC(Catchment(i))];
                    modelo.labelCuencas=[modelo.labelCuencas,plotLabelC(Catchment(i))];
                    ax = gca;
                    VPermutar=ax.Children;
                    Orden = CuencaOrdenGrafico(VPermutar,modelo.background);
                    ax.Children = ax.Children(Orden);
                end
                tablaCuencas(Catchment,handles,'eliminacion')
                modelo.cuencas=length(Catchment);
            end
        else
            Catchment=[];
        end


        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
            if ~isempty(genRetention)
                tablaGenRetencion(genRetention,handles,'eliminacion')
                modelo.retencion=length(genRetention);
            end
        else
            genRetention=[];
        end

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
            if ~isempty(genDetention)
                tablaGenDetencion(genDetention,handles,'eliminacion')
                modelo.detencion=length(genDetention);
            end
        else
            genDetention=[];
        end

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
            if ~isempty(genInfiltration)
                tablaGenInfiltracion(genInfiltration,handles,'eliminacion')
                modelo.infiltracion=length(genInfiltration);
            end
        else
            genDInfiltracion=[];
        end

        set(jProgressBar,'Value',6);
        if strcmp(idioma,'english')
            msg = 'Creating storms... (80%)';
        else
            msg = 'Creando tormentas... (80%)';
        end

        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
            if ~isempty(Storm)
                tablaTormentas(Storm,handles,'eliminacion')
            end
            modelo.tormentas=length(Storm);
        end
        
        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
            if ~isempty(NaturalResponse)
                tablaCuencasR(NaturalResponse,handles,'eliminacion')
                modelo.Natural=length(NaturalResponse);
            end
        else
            NaturalResponse=[];
        end
        
        set(jProgressBar,'Value',9);
        if strcmp(idioma,'english')
            msg = 'Loading scenarios... (90%)';
        else
            msg = 'Cargando escenarios... (90%)';
        end
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);
        jTabGroup = findjobj ( 'class' , 'JTabbedPane' );

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
            if ~isempty(Simulation.inicioSimulacion)
                a=string(Simulation.inicioSimulacion);
                b=split(a,' ');
                set(handles.edit4,'string', b(1));
                [h,m] = hms(Simulation.inicioSimulacion);
                set(handles.edit5,'string', h);
                set(handles.edit6,'string', m);
            end

            if ~isempty(Simulation.finSimulacion)
                a=string(Simulation.finSimulacion);
                b=split(a,' ');
                set(handles.edit27,'string', b(1));
                [h,m] = hms(Simulation.finSimulacion);
                set(handles.edit28,'string', h);
                set(handles.edit29,'string', m);
            end

            set(handles.edit23,'string', Simulation.dtReporte);
            set(handles.edit26,'string', Simulation.dtEscorrentia);
            set(handles.edit25,'string', Simulation.dtTransito);
            
            if ~isempty(Simulation.incluirSUDS)
                set(handles.checkbox4,'value',Simulation.incluirSUDS);
            end
            if ~isempty(Simulation.incluirRN)
                set(handles.checkbox5,'value',Simulation.incluirRN);
            end
            if ~isempty(Simulation.metodoTransito)
                switch Simulation.metodoTransito
                    case 'onda_cinematica'
                        set(handles.popupmenu2,'value',2)
                    case 'onda_dinamica'
                        set(handles.popupmenu2,'value',3)
                    otherwise
                        set(handles.popupmenu2,'value',1)
                end
            end
        end

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');
            if ~isempty(Scenario)
                tablaEscenarios(Scenario,handles,'creacion')
                jTabGroup(3). setEnabledAt ( 0 , 1 );
                jTabGroup(3). setEnabledAt ( 1 , 1 );
                jTabGroup(3). setEnabledAt ( 2 , 1 );
                load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
                ax = gca;
                xl = xlim;
                yl = ylim;
                axes(handles.axes2);
                cla
                xlim(xl)
                ylim(yl)
                axis equal
                [modelo.graficoTuberiasPl,modelo.graficoCuencasPl,modelo.graficoNodosPl]=plotSimulacion(stormwaterSystem);
            end
        else
            jTabGroup(3). setEnabledAt ( 0 , 1 );
            jTabGroup(3). setEnabledAt ( 1 , 0 );
            jTabGroup(3). setEnabledAt ( 2 , 0 );
        end

        set(jProgressBar,'Value',10);
        if strcmp(idioma,'english')
            msg = 'Completed... (100%)';
        else
            msg = 'Completado... (100%)';
        end
 
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

    end
    pause(0.5)
    jRootPane.setStatusBarVisible(0);
% hObject    handle to abrirProyecto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to importarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% System
% //    Description:
% //        - Exit
% //    Update History
% =============================================================
%  
function Untitled_8_Callback(hObject, eventdata, handles)
moduloHidrologico_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Node element
% //    Description:
% //        -Turn off/on Node layer
% //    Update History
% =============================================================
%  
function layerNodos_Callback(hObject, eventdata, handles)
global modelo

if strcmp(get(handles.layerNodos,'Checked'),'on')
    set(handles.layerNodos,'Checked','off');
    set(modelo.graficoNodos,'visible','off');
    set(modelo.graficoDCuencas,'visible','off');
    set(modelo.labelNodos,'visible','off');
    set(handles.nodosLabel,'Checked','off')
else
    set(modelo.graficoNodos,'visible','on');
    if strcmp(get(handles.layerCuencas,'Checked'),'on')
       set(modelo.graficoDCuencas,'visible','on');
    end
    set(handles.layerNodos,'Checked','on')
    set(modelo.labelNodos,'visible','on');
    set(handles.nodosLabel,'Checked','on')
end
% hObject    handle to layerNodos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Conduit element
% //    Description:
% //        -Turn off/on Conduit layer
% //    Update History
% =============================================================
%  
function layerTuberias_Callback(hObject, eventdata, handles)
global modelo
if strcmp(get(handles.layerTuberias,'Checked'),'on')
    set(handles.layerTuberias,'Checked','off');
    set(modelo.graficoTuberias,'visible','off');
    set(modelo.labelTuberias,'visible','off');
    set(handles.tuberiasLabel,'Checked','off');
else
    set(modelo.graficoTuberias,'visible','on');
    set(handles.layerTuberias,'Checked','on');
    set(modelo.labelTuberias,'visible','on');
    set(handles.tuberiasLabel,'Checked','on');
end
% hObject    handle to layerTuberias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Catchment element
% //    Description:
% //        -Turn off/on Catchment layer
% //    Update History
% =============================================================
% 
function layerCuencas_Callback(hObject, eventdata, handles)
global modelo
if strcmp(get(handles.layerCuencas,'Checked'),'on')
    set(handles.layerCuencas,'Checked','off');
    set(modelo.graficoCuencas,'visible','off');
    set(modelo.graficoDCuencas,'visible','off');
    set(modelo.graficoCCuencas,'visible','off');
    set(modelo.labelCuencas,'visible','off');
    set(handles.cuencasLabel,'Checked','off')
elseif strcmp(get(handles.layerNodos,'Checked'),'off')
    set(handles.layerCuencas,'Checked','on');
    set(modelo.graficoCuencas,'visible','on');
    set(modelo.graficoDCuencas,'visible','off');
    set(modelo.graficoCCuencas,'visible','on');
    set(modelo.labelCuencas,'visible','on');
    set(handles.cuencasLabel,'Checked','on')
else
    set(handles.layerCuencas,'Checked','on');
    set(modelo.graficoCuencas,'visible','on');
    set(modelo.graficoDCuencas,'visible','on');
    set(modelo.graficoCCuencas,'visible','on');
    set(modelo.labelCuencas,'visible','on');
    set(handles.cuencasLabel,'Checked','on')
end
% hObject    handle to layerCuencas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Background 
% //    Description:
% //        -Turn off/on Background layer
% //    Update History
% =============================================================
% 
function Untitled_14_Callback(hObject, eventdata, handles)
global modelo

if strcmp(get(handles.layerFondo,'Checked'),'on')
    set(handles.layerFondo,'Checked','off');
    set(modelo.background,'visible','off');
else
    set(handles.layerFondo,'Checked','on');
    set(modelo.background,'visible','on');
end
% hObject    handle to Untitled_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_15_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Labels elements
% //    Description:
% //        -Turn off/on labels
% //    Update History
% =============================================================
% 
function allLabel_Callback(hObject, eventdata, handles)
global modelo

if strcmp(get(handles.nodosLabel,'Checked'),'off')||strcmp(get(handles.tuberiasLabel,'Checked'),'off')||strcmp(get(handles.cuencasLabel,'Checked'),'off')
    set(modelo.labelNodos,'visible','on');
    set(modelo.labelTuberias,'visible','on');
    set(modelo.labelCuencas,'visible','on');
    set(handles.nodosLabel,'Checked','on')
    set(handles.tuberiasLabel,'Checked','on')
    set(handles.cuencasLabel,'Checked','on')
else
    set(modelo.labelNodos,'visible','off');
    set(modelo.labelTuberias,'visible','off');
    set(modelo.labelCuencas,'visible','off');
    set(handles.nodosLabel,'Checked','off');
    set(handles.tuberiasLabel,'Checked','off');
    set(handles.cuencasLabel,'Checked','off');
end
% hObject    handle to allLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Node element
% //    Description:
% //        -Turn off/on Node labels
% //    Update History
% =============================================================
% 
function nodosLabel_Callback(hObject, eventdata, handles)
global modelo
if strcmp(get(handles.nodosLabel,'Checked'),'on')
    set(handles.nodosLabel,'Checked','off')
    set(modelo.labelNodos,'visible','off');
elseif strcmp(get(handles.layerNodos,'Checked'),'on')
    set(handles.nodosLabel,'Checked','on')
    set(modelo.labelNodos,'visible','on');
end

% hObject    handle to nodosLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Conduit element
% //    Description:
% //        -Turn off/on Conduit labels
% //    Update History
% =============================================================
% 
function tuberiasLabel_Callback(hObject, eventdata, handles)
global modelo
if strcmp(get(handles.tuberiasLabel,'Checked'),'on')
    set(handles.tuberiasLabel,'Checked','off')
    set(modelo.labelTuberias,'visible','off');
elseif strcmp(get(handles.layerTuberias,'Checked'),'on')
    set(handles.tuberiasLabel,'Checked','on')
    set(modelo.labelTuberias,'visible','on');
end
% hObject    handle to tuberiasLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Catchment element
% //    Description:
% //        -Turn off/on Catchment labels
% //    Update History
% =============================================================
% 
function cuencasLabel_Callback(hObject, eventdata, handles)
global modelo
if strcmp(get(handles.cuencasLabel,'Checked'),'on')
    set(handles.cuencasLabel,'Checked','off')
    set(modelo.labelCuencas,'visible','off');
elseif strcmp(get(handles.layerCuencas,'Checked'),'on')
    set(handles.cuencasLabel,'Checked','on')
    set(modelo.labelCuencas,'visible','on');
end
% hObject    handle to cuencasLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');
    Tor=cell(1,length(Scenario));
    for i=1:length(Scenario)
        Tor{i}=[Scenario(i).nombre];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Scenario','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Escenario','SelectionMode','single');
    end
    
    if ~isempty(Z)
        inicializar(handles)
        jFrame = get(handle(gcf),'JavaFrame');
        jRootPane = jFrame.fHG2Client.getWindow;
        statusbarObj = com.mathworks.mwswing.MJStatusBar;
        jProgressBar = javax.swing.JProgressBar;
        numIds = 10;

        set (jProgressBar, 'Minimum',0, 'Maximum',numIds, 'Value',0);
        jRootPane.setStatusBarVisible(1);
        statusbarObj.add(jProgressBar,'West');

        set(jProgressBar,'Value',1);
        if strcmp(idioma,'english')
            msg = 'Loading scenario... (10%)';
        else
            msg = 'Cargando escenario... (10%)';
        end   
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

        for i=1:length(Scenario)
            Scenario(i).estado=false;
            if i==Z
                Scenario(i).estado=true;
            end
        end
        tablaEscenarios(Scenario,handles,'creacion')

        set(jProgressBar,'Value',2);
        if strcmp(idioma,'english')
            msg = 'Creating model... (20%)';
        else
            msg = 'Creando modelo... (20%)';
        end
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);
            
        set(jProgressBar,'Value',3);
        if strcmp(idioma,'english')
            msg = 'Configuration... (30%)';
        else
            msg = 'Configuración... (30%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);
      
        set(handles.edit4,'string',Scenario(Z).startDate);
        set(handles.edit5,'string',Scenario(Z).startHour);
        set(handles.edit6,'string',Scenario(Z).startMin);

        set(handles.edit27,'string',Scenario(Z).endDate);
        set(handles.edit28,'string',Scenario(Z).endHour);
        set(handles.edit29,'string',Scenario(Z).endMin);

        set(handles.edit26,'string',Scenario(Z).stepRunoff);
        set(handles.edit25,'string',Scenario(Z).stepRouting);
        set(handles.edit23,'string',Scenario(Z).stepResult);

        set(handles.checkbox4,'value',Scenario(Z).SUDS);
        set(handles.checkbox5,'value',Scenario(Z).RHN);

        switch Scenario(Z).routing
            case 'onda_cinematica'
                set(handles.popupmenu2,'value',2)
            case 'onda_dinamica'
                set(handles.popupmenu53,'Value',Scenario(Z).DW.inercia)
                set(handles.popupmenu54,'value',Scenario(Z).DW.fnormal);
                set(handles.popupmenu56,'value',Scenario(Z).DW.surgencia);       
                set(handles.edit99,'string',Scenario(Z).DW.courant*100);
                set(handles.edit100,'String',Scenario(Z).DW.minDt);
                set(handles.edit101,'String',Scenario(Z).DW.minAreaNodal);
                set(handles.edit102,'String',Scenario(Z).DW.maxIteraciones);
                set(handles.edit102,'String',Scenario(Z).DW.tolerancia);
                set(handles.popupmenu2,'value',3)
        end

        Catchment=[];
        axes(handles.axes1)
        cla

        set(jProgressBar,'Value',3);
        if strcmp(idioma,'english')
            msg = 'Creating nodes... (40%)';
        else
            msg = 'Creando nodos... (40%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'Node.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'Node.mat'),'Node');
            if ~isempty(Node)
                for i=1:length(Node)        
                    modelo.graficoNodos=[modelo.graficoNodos,plotNodo(Node(i))];
                    modelo.labelNodos=[modelo.labelNodos,plotLabelN(Node(i))];
                end
                Xmin=min([Node.corX]);
                Xmax=max([Node.corX]);
                Ymin=min([Node.corY]);
                Ymax=max([Node.corY]);
                dx=Xmax-Xmin;
                dy=Ymax-Ymin;
                axis([Xmin-0.1*dx,Xmax+0.1*dx,Ymin-0.1*dy,Ymax+0.1*dy])
                axis equal
                hold on
                tablaNodos(Node,handles,'eliminacion')
                modelo.nodos=length(Node);
            end
        else
            Node=[];
        end
        set(jProgressBar,'Value',5);
        if strcmp(idioma,'english')
            msg = 'Creating conduits... (50%)';
        else
            msg = 'Creating tuberías... (50%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'Conduit.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'Conduit.mat'),'Conduit');
            if ~isempty(Conduit)
                for i=1:length(Conduit)        
                    modelo.graficoTuberias=[modelo.graficoTuberias,plotTuberia(Conduit(i))];
                    modelo.labelTuberias=[modelo.labelTuberias,plotLabelT(Conduit(i))];
                    ax = gca;
                    VPermutar=ax.Children;
                    Orden = TuberiaOrdenGrafico(VPermutar,Catchment,modelo.background);
                    ax.Children = ax.Children(Orden);
                end
                tablaTuberias(Conduit,handles,'eliminacion')
                modelo.tuberias=length(Conduit);
            end
        else
            Conduit=[];
        end


        set(jProgressBar,'Value',6);
        if strcmp(idioma,'english')
            msg = 'Creating catchment... (60%)';
        else
            msg = 'Creando cuencas... (60%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);
        
        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'Catchment.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'Catchment.mat'),'Catchment');
            if ~isempty(Catchment)
                for i=1:length(Catchment)        
                    modelo.graficoCuencas=[modelo.graficoCuencas, plotCuenca(Catchment(i))];
                    modelo.graficoDCuencas=[modelo.graficoDCuencas,plotDirC(Catchment(i))];
                    modelo.graficoCCuencas=[modelo.graficoCCuencas,plotCentroC(Catchment(i))];
                    modelo.labelCuencas=[modelo.labelCuencas,plotLabelC(Catchment(i))];
                    ax = gca;
                    VPermutar=ax.Children;
                    Orden = CuencaOrdenGrafico(VPermutar,modelo.background);
                    ax.Children = ax.Children(Orden);
                end
                tablaCuencas(Catchment,handles,'eliminacion')
                modelo.cuencas=length(Catchment);
            end
        else
            Catchment=[];
        end

        set(jProgressBar,'Value',7);
        if strcmp(idioma,'english')
            msg = 'Creating SUDS... (70%)';
        else
            msg = 'Creando SUDS... (70%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'genRetention.mat'),'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'genRetention.mat'),'genRetention');
            if ~isempty(genRetention)
                tablaGenRetencion(genRetention,handles,'eliminacion')
                modelo.retencion=length(genRetention);
            end
        else
            genRetention=[];
        end

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'genDetention.mat'),'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'genDetention.mat'),'genDetention');
            if ~isempty(genDetention)
                tablaGenDetencion(genDetention,handles,'eliminacion')
                modelo.detencion=length(genDetention);
            end
        else
            genDetention=[];
        end

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'genInfiltration.mat'),'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'genInfiltration.mat'),'genInfiltration');
            if ~isempty(genInfiltration)
                tablaGenInfiltracion(genInfiltration,handles,'eliminacion')
                modelo.infiltracion=length(genInfiltration);
            end
        else
            genDInfiltracion=[];
        end

        set(jProgressBar,'Value',8);
        if strcmp(idioma,'english')
            msg = 'Creating storms... (80%)';
        else
            msg = 'Creando tormentas... (80%)';
        end
        
        statusbarObj.setText(msg);
        jRootPane.setStatusBar(statusbarObj);

        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'Storm.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'Storm.mat'),'Storm');
            if ~isempty(Storm)
                tablaTormentas(Storm,handles,'eliminacion')
            end
            modelo.tormentas=length(Storm);
        end
        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'NaturalResponse.mat'), 'file')
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'NaturalResponse.mat'),'NaturalResponse');
            if ~isempty(NaturalResponse)
                tablaCuencasR(NaturalResponse,handles,'eliminacion')
                modelo.Natural=length(NaturalResponse);
            end
        else
            NaturalResponse=[];
        end
            jTabGroup = findjobj ( 'class' , 'JTabbedPane' );
            jTabGroup(3). setEnabledAt ( 0 , 1 );
            jTabGroup(3). setEnabledAt ( 1 , 1 );
            jTabGroup(3). setEnabledAt ( 2 , 1 );
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'StormwaterSystem.mat'),'stormwaterSystem');
            ax = gca;
            xl = xlim;
            yl = ylim;
            axes(handles.axes2);
            cla
            xlim(xl)
            ylim(yl)
            axis equal
            [modelo.graficoTuberiasPl,modelo.graficoCuencasPl,modelo.graficoNodosPl]=plotSimulacion(stormwaterSystem);
            set(jProgressBar,'Value',10);
            
            if strcmp(idioma,'english')
                msg = 'Completed... (100%)';
            else
                msg = 'Completado... (100%)';
            end
            statusbarObj.setText(msg);
            jRootPane.setStatusBar(statusbarObj);
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(Z).nombre],'Simulation.mat'),'Simulation');
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Results.mat'),'results');

            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Results.mat'),'results');
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
    else
        return;
    end

    pause(0.5)
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Operation completed','Success','help');
    else
        Aviso('Operación completada','Success','help');
    end
    

% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in checkNodos.
function checkNodos_Callback(hObject, eventdata, handles)
% hObject    handle to checkNodos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkNodos


%% --- Executes on button press in checkTuberias.
function checkTuberias_Callback(hObject, eventdata, handles)
% hObject    handle to checkTuberias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkTuberias


%% --- Executes on button press in checkCuencas.
function checkCuencas_Callback(hObject, eventdata, handles)
% hObject    handle to checkCuencas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkCuencas


%% --------------------------------------------------------------------
function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


%% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% --------------------------------------------------------------------
function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


%% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% --------------------------------------------------------------------
function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


%% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% --------------------------------------------------------------------
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

%% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Simulation options
% //    Description:
% //        -Set date of simulation
% //    Update History
% =============================================================
% 
function pushbutton53_Callback(hObject, eventdata, handles)
try
    h=handles.edit4;
    a=uicalendar2('DestinationUI', {h, 'String'});

    f = findobj('tag','moduloHidrologico');
    posicion1=f.Position;
    posicion2=a.Position;
    posicion=[posicion1(1:2)+posicion1(3:4)/2-posicion2(3:4)/2,posicion2(3:4)];
    a.Position=posicion;

    % Now wait for the string to be updated
    waitfor(a); 
    val1 = get(h,'String');
    if isempty(val1)
        set(handles.edit4,'String','');
    end
end
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

%% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Simulation options
% //    Description:
% //        -Set time of simulation
% //    Update History
% =============================================================
% 
function slider1_Callback(hObject, eventdata, handles)
hora=get(handles.slider1,'Value');
hora=hora*23;
set(handles.edit5,'String',hora)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% --------------------------------------------------------------------
function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


%% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Simulation options
% //    Description:
% //        -Set time of simulation
% //    Update History
% =============================================================
% 
function slider2_Callback(hObject, eventdata, handles)
hora=get(handles.slider2,'Value');
hora=hora*59;
set(handles.edit6,'String',hora)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% --------------------------------------------------------------------
function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


%% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Simulation options
% //    Description:
% //        -Set date of simulation
% //    Update History
% =============================================================
% 
function pushbutton61_Callback(hObject, eventdata, handles)
try
    h=handles.edit30;
    a=uicalendar2('DestinationUI', {h, 'String'});
    % Now wait for the string to be updated
    waitfor(a); 
    val1 = get(h,'String');
    if isempty(val1)
        set(handles.edit30,'String','Fecha');
    end
end
% hObject    handle to pushbutton61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


%% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Simulation options
% //    Description:
% //        -Set time of simulation
% //    Update History
% =============================================================
% 
function slider17_Callback(hObject, eventdata, handles)
hora=get(handles.slider17,'Value');
hora=hora*23;
set(handles.edit31,'String',hora)
% hObject    handle to slider17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% --------------------------------------------------------------------
function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


%% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Simulation options
% //    Description:
% //        -Set time of simulation
% //    Update History
% =============================================================
% 
function slider18_Callback(hObject, eventdata, handles)
hora=get(handles.slider18,'Value');
hora=hora*59;
set(handles.edit32,'String',hora)
% hObject    handle to slider18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% --------------------------------------------------------------------
function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


%% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Simulation options
% //    Description:
% //        -Set date of simulation
% //    Update History
% =============================================================
% 
function pushbutton60_Callback(hObject, eventdata, handles)
try
    h=handles.edit27;
    a=uicalendar2('DestinationUI', {h, 'String'});
    f = findobj('tag','moduloHidrologico');
    posicion1=f.Position;
    posicion2=a.Position;
    posicion=[posicion1(1:2)+posicion1(3:4)/2-posicion2(3:4)/2,posicion2(3:4)];
    a.Position=posicion;
    % Now wait for the string to be updated
    waitfor(a); 
    val1 = get(h,'String');
    if isempty(val1)
        set(handles.edit27,'String','Fecha');
    end
end
% hObject    handle to pushbutton60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


%% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Simulation options
% //    Description:
% //        -Set time of simulation
% //    Update History
% =============================================================
% .
function slider15_Callback(hObject, eventdata, handles)
hora=get(handles.slider15,'Value');
hora=hora*23;
set(handles.edit28,'String',hora)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% --------------------------------------------------------------------
function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


%% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Simulation options
% //    Description:
% //        -Set time of simulation
% //    Update History
% =============================================================
% 
function slider16_Callback(hObject, eventdata, handles)
hora=get(handles.slider16,'Value');
hora=hora*59;
set(handles.edit29,'String',hora)
% hObject    handle to slider16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




%% --------------------------------------------------------------------
function Untitled_17_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_22_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_28_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Node element
% //    Description:
% //        -Turn off/on Node layer
% //    Update History
% =============================================================
%  
function Untitled_23_Callback(hObject, eventdata, handles)
    layerNodos_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Conduit element
% //    Description:
% //        -Turn off/on Conduit layer
% //    Update History
% =============================================================
%  
function Untitled_25_Callback(hObject, eventdata, handles)
    layerTuberias_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Catchment element
% //    Description:
% //        -Turn off/on Catchment layer
% //    Update History
% =============================================================
% 
function Untitled_26_Callback(hObject, eventdata, handles)
    layerCuencas_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Background
% //    Description:
% //        -Turn off/on Background layer
% //    Update History
% =============================================================
% 
function Untitled_27_Callback(hObject, eventdata, handles)
    layerFondo_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Model options
% //    Description:
% //        -Turn off/on all labels
% //    Update History
% =============================================================
%  
function cmLabels_Callback(hObject, eventdata, handles)
    allLabel_Callback(hObject, eventdata, handles)
% hObject    handle to cmLabels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Node element
% //    Description:
% //        -Turn off/on Node labels
% //    Update History
% =============================================================
% 
function cmLNodos_Callback(hObject, eventdata, handles)
    nodosLabel_Callback(hObject, eventdata, handles)
% hObject    handle to cmLNodos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Conduit element
% //    Description:
% //        -Turn off/on Conduit labels
% //    Update History
% =============================================================
% 
function cmLTuberias_Callback(hObject, eventdata, handles)
    tuberiasLabel_Callback(hObject, eventdata, handles)
% hObject    handle to cmLTuberias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Catchment element
% //    Description:
% //        -Turn off/on Catchment labels
% //    Update History
% =============================================================
%
function cmLCuencas_Callback(hObject, eventdata, handles)
    cuencasLabel_Callback(hObject, eventdata, handles)
% hObject    handle to cmLCuencas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function menuAxes_Callback(hObject, eventdata, handles)
% hObject    handle to menuAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


%% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


%% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


%% --------------------------------------------------------------------
function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


%% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --------------------------------------------------------------------
function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


%% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in pushbutton63.
function pushbutton63_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


%% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


%% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --------------------------------------------------------------------
function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


%% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Natural hydrological response simulation
% //    Description:
% //        -Edit natural hydrological response information
% //    Update History
% =============================================================
%
function pushbutton64_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
modelo.bandera=[];
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
if ~isempty(NaturalResponse)
    Tor=cell(1,length(NaturalResponse));
    for i=1:length(NaturalResponse)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Catchment','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Cuenca','SelectionMode','single');
    end
    
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        modelo.bandera={NaturalResponse(Z),'edicion'};
        editarGeneral(crearCuencaH);
        if ~isempty(modelo.bandera)         
            NaturalResponse(Z)=modelo.bandera;
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
            tablaCuencasR(NaturalResponse,handles,'edicion',Z);
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no RHN','Error','error');
    else
        Aviso('No existe respuesta hodrológica natural','Error','error');
    end
    return
end  
% hObject    handle to pushbutton64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Natural hydrological response simulation
% //    Description:
% //        -Delete natural hydrological response information
% //    Update History
% =============================================================
%
function pushbutton65_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
if ~isempty(NaturalResponse)
    Tor=cell(1,length(NaturalResponse));
    for i=1:length(NaturalResponse)
        Tor{i}=['ID-',num2str(i)];
    end
    
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Catchment','SelectionMode','multiple');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Cuenca','SelectionMode','multiple');
    end
    
    if ~isempty(Z)
        NaturalResponse(Z)=[];

        if ~isempty(NaturalResponse)
            for i=1:length(NaturalResponse)
                NaturalResponse(i).ID=i;
            end
        end
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
        tablaCuencasR(NaturalResponse,handles,'eliminacion')
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no RHN','Error','error');
    else
        Aviso('No existe respuesta hodrológica natural','Error','error');
    end
    return
end
% hObject    handle to pushbutton65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Natural hydrological response simulation
% //    Description:
% //        -Plot natural hydrological response
% //    Update History
% =============================================================
%
function pushbutton66_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
if isempty(NaturalResponse)
    if strcmp(idioma,'english')
        Aviso('There are no RHN','Error','error');
    else
        Aviso('No existe respuesta hodrológica natural','Error','error');
    end
    return
end
if ~isempty(NaturalResponse)
    Tor=cell(1,length(NaturalResponse));
    for i=1:length(NaturalResponse)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Catchment','SelectionMode','multiple');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Cuenca','SelectionMode','multiple');
    end
    
    if isempty(Z)
        return
    end
    for i=1:length(Z)
        Storm((NaturalResponse(Z(i)).tormenta))=generarHietograma(Storm((NaturalResponse(Z(i)).tormenta)));
        switch NaturalResponse(Z(i)).escorrentia.metodo
            case 'Onda-Cinematica'
                if strcmp(idioma,'english')
                    Aviso('Run general simulation','Info','warn');
                else
                    Aviso('Ejecutar simulación general','Info','warn');
                end
                return
                NaturalResponse(Z(i)).escorrentia=areaDrenado(NaturalResponse(Z(i)).escorrentia,NaturalResponse(Z(i)));
                hietogramaTotal=Storm(NaturalResponse(Z(i)).tormenta).hietogramaSimulacion;
            otherwise
            hietogramaTotal=Storm(NaturalResponse(Z(i)).tormenta).hietograma;
        end
        NaturalResponse(Z(i))=generarHidrograma(NaturalResponse(Z(i)),hietogramaTotal,Simulation);
    end
end
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
a=figure;
posicion2=a.Position;
pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.75;
pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.35;
posicion=[pos1,pos2,posicion2(3:4)];
a.Position=posicion;

hold on
for i=1:length(Z)
    plot(NaturalResponse(Z(i)).hidrograma(:,1)/60,NaturalResponse(Z(i)).hidrograma(:,2),'DisplayName',[num2str(NaturalResponse(Z(i)).ID),'-',NaturalResponse(Z(i)).escorrentia.metodo],'LineWidth',1.5);
end
axes1 = gca;
axes1.FontName='Open Sans';
axes1.FontUnits='points';
axes1.FontSize=9;
axes1.XGrid='on';
axes1.YGrid='on';
if strcmp(idioma,'english')
    xlabel('Time (min)')
    ylabel('Flow rate (m3/s)')
else
    xlabel('Tiempo (min)')
    ylabel('Flujo (m3/s)')
end
legend
% hObject    handle to pushbutton66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Natural hydrological response simulation
% //    Description:
% //        -Create natural hydrological response
% //    Update History
% =============================================================
%
function pushbutton67_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
NaturalResponse=[NaturalResponse,cuencaH(length(NaturalResponse)+1,0,0)];
modelo.bandera={NaturalResponse(end),'natural'};
editarGeneral(crearCuencaH);
if ~isempty(modelo.bandera)
    NaturalResponse(end)=modelo.bandera;
end
tablaCuencasR(NaturalResponse,handles,'creacion')
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
% hObject    handle to pushbutton67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Natural hydrological response simulation
% //    Description:
% //        -Manage the table of information for hydrological response
% //    Update History
% =============================================================
%
function tablaCuencasR(Catchment,handles,varargin)
formatSpec = '%.2f';
switch varargin{1}
    case 'creacion'
        ID={['<html><tr><td width=9999 align=center>',num2str(Catchment(end).ID)]};
        ND={['<html><tr><td width=9999 align=center>',num2str(Catchment(end).descarga)]};
        area={['<html><tr><td width=9999 align=center>',num2str(Catchment(end).area,formatSpec)]};
        if ~isempty(Catchment(end).tormenta)
            tormenta={['<html><tr><td width=9999 align=center>',num2str(Catchment(end).tormenta)]};
        else
            tormenta={''};
        end
        if ~isempty(Catchment(end).infiltracion)
            infiltracion={['<html><tr><td width=9999 align=center>',Catchment(end).infiltracion.metodo]};
        else
            infiltracion={''};
        end
        if ~isempty(Catchment(end).escorrentia)
            escorrentia={['<html><tr><td width=9999 align=center>',Catchment(end).escorrentia.metodo]};
        else
            escorrentia={''};
        end
        
        if length(Catchment)==1
            Datos=[ID,ND,area,escorrentia,infiltracion,tormenta];
        else
            Datos=get(handles.tablaCuencasR,'data');
            Datos=[Datos;ID,ND,area,escorrentia,infiltracion,tormenta];
        end
    case 'edicion'
        r=varargin{2};
        Datos=get(handles.tablaCuencasR,'data');
        ID={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).ID)]};
        ND={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).descarga)]};
        area={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).area,formatSpec)]};
        if ~isempty(Catchment(r).tormenta)
            tormenta={['<html><tr><td width=9999 align=center>',num2str(Catchment(r).tormenta)]};
        else
            tormenta={''};
        end
        if ~isempty(Catchment(r).infiltracion)
            infiltracion={['<html><tr><td width=9999 align=center>',Catchment(r).infiltracion.metodo]};
        else
            infiltracion={''};
        end
        if ~isempty(Catchment(r).escorrentia)
            escorrentia={['<html><tr><td width=9999 align=center>',Catchment(r).escorrentia.metodo]};
        else
            escorrentia={''};
        end
        Datos(r,1)=ID;
        Datos(r,2)=ND;
        Datos(r,3)=area;
        Datos(r,4)=escorrentia;
        Datos(r,5)=infiltracion;
        Datos(r,6)=tormenta;

    case 'eliminacion'     
        if ~isempty(Catchment)
            Datos=cell(length(Catchment),6);
            for i=1:length(Catchment)
                ID={['<html><tr><td width=9999 align=center>',num2str(Catchment(i).ID)]};
                ND={['<html><tr><td width=9999 align=center>',num2str(Catchment(i).descarga)]};
                area={['<html><tr><td width=9999 align=center>',num2str(Catchment(i).area,formatSpec)]};
                if ~isempty(Catchment(i).tormenta)
                    tormenta={['<html><tr><td width=9999 align=center>',num2str(Catchment(i).tormenta)]};
                else
                    tormenta={''};
                end
                if ~isempty(Catchment(i).infiltracion)
                    infiltracion={['<html><tr><td width=9999 align=center>',Catchment(i).infiltracion.metodo]};
                else
                    infiltracion={''};
                end
                if ~isempty(Catchment(i).escorrentia)
                    escorrentia={['<html><tr><td width=9999 align=center>',Catchment(i).escorrentia.metodo]};
                else
                    escorrentia={''};
                end
                Datos(i,1)=ID;
                Datos(i,2)=ND;
                Datos(i,3)=area;
                Datos(i,4)=escorrentia;
                Datos(i,5)=infiltracion;
                Datos(i,6)=tormenta;
            end
        else
            Datos=[];
        end
end
set(handles.tablaCuencasR,'data',Datos)


%% Natural hydrological response simulation
% //    Description:
% //        -Get natural hydrological response
% //    Update History
% =============================================================
%
function pushbutton68_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','NaturalResponse.mat'),'NaturalResponse');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Storm.mat'),'Storm');
Simulation.incluirSUDS=0;
Simulation.dtEscorrentia=30;
if isempty(NaturalResponse)
    if strcmp(idioma,'english')
        Aviso('There are no RHN','Error','error');
    else
        Aviso('No existe respuesta hodrológica natural','Error','error');
    end
    return
end
if ~isempty(NaturalResponse)
    Tor=cell(1,length(NaturalResponse));
    for i=1:length(NaturalResponse)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Catchment','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Cuenca','SelectionMode','single');
    end
    
    if isempty(Z)
        return
    end

    Storm((NaturalResponse(Z).tormenta))=generarHietograma(Storm((NaturalResponse(Z).tormenta)));

    switch NaturalResponse(Z).escorrentia.metodo
        case 'Onda-Cinematica'
        NaturalResponse(Z).escorrentia=areaDrenado(NaturalResponse(Z).escorrentia,NaturalResponse(Z));
        hietogramaTotal=Storm(NaturalResponse(Z).tormenta).hietogramaSimulacion;
        otherwise
        hietogramaTotal=Storm(NaturalResponse(Z).tormenta).hietograma;
    end
        NaturalResponse(Z)=generarHidrograma(NaturalResponse(Z),hietogramaTotal,Simulation);
end
modelo.bandera=NaturalResponse(Z).hidrograma;
tablaRN;
% hObject    handle to pushbutton68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton69.
function pushbutton69_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton70.
function pushbutton70_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: retention system
% //    Description:
% //        -Create and configurate element options
% //    Update History
% =============================================================
%
function pushbutton77_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo
if isempty(modelo.cuencas)&&modelo.cuencas==0
    if strcmp(idioma,'english')
        Aviso('There are no catchment to incorporate SUDS','Error','error');
    else
        Aviso('No existen cuencas para incorporar SUDS','Error','error');
    end
    return
end
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Retencion.mat'),'Retencion');
Retencion=[Retencion,SUDretencion(length(Retencion)+1,'retencion')];
modelo.bandera=Retencion(end);
editarGeneral(crearSUDRetencion);
if ~isempty(modelo.bandera)
    Retencion(end)=modelo.bandera;
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Retencion.mat'),'Retencion');
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    Catchment(Retencion(end).cuenca).sudAlmacenamiento=[Catchment(Retencion(end).cuenca).sudAlmacenamiento,Retencion(end).ID];
    modelo.retencion=length(Retencion);
    Retencion(end) = estimarVEfectivo(Retencion(end));
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
end

% hObject    handle to pushbutton77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton78.
function pushbutton78_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton79.
function pushbutton79_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton81.
function pushbutton81_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton81 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton82.
function pushbutton82_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton83.
function pushbutton83_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton83 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Node element 
% //    Description:
% //        -Asign terrain and invert elevation node from file
% //        -Format file (txt): ID TE IE
% //    Update History
% =============================================================
%
function pushbutton84_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
if strcmp(idioma,'english')
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Select data file');
else
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Seleccionar archivo');
end

if isnumeric(ruta) || isnumeric(nombre)
    return;
end

%ID-ET-ER
info = importdata(fullfile(ruta,nombre));
if size(info,2)~=3
    if strcmp(idioma,'english')
        Aviso('Verify data file','Error','error');
    else
        Aviso('Verificar archivo de datos','Error','error');
    end
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
for i=1:size(A,1)
    if A(i,1)<1 || A(i,1)>length(Node)
        continue;
    else
        if A(i,2)<=A(i,3)
            continue;
        end
        Node(i).elevacionT=A(i,2);
        Node(i).elevacionR=A(i,3);
        Node(i).desnivel=Node(i).elevacionT-Node(i).elevacionR;
    end
end
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
tablaNodos(Node,handles,'eliminacion')
% hObject    handle to pushbutton84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Conduit element 
% //    Description:
% //        -Assign section properties from file
% //        -Format file (txt): Section Properities
% //    Update History
% =============================================================
%
function pushbutton85_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
if strcmp(idioma,'english')
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Select data file');
else
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Seleccionar archivo');
end
if isnumeric(ruta) || isnumeric(nombre)
    return;
end

info = importdata(fullfile(ruta,nombre));

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
for i=1:length(info.textdata)
    switch info.textdata{i}
        case 'circular'
            datos=info.data(i,:);
            datos(isnan(datos))=[];
            if isempty(datos)||length(datos)~=6
                continue
            else
                Conduit(datos(1)).seccion=seccion('circular',datos(2));
                datos(2)=[];
            end
        case 'rectangular'
            datos=info.data(i,:);
            datos(isnan(datos))=[];
            if isempty(datos)||length(datos)~=7
                continue
            else
            Conduit(datos(1)).seccion=seccion('rectangular',datos(2),datos(3));
            datos(2:3)=[];
            end
        case 'boveda'
            datos=info.data(i,:);
            datos(isnan(datos))=[];
            if isempty(datos)||length(datos)~=8
                continue
            else
            Conduit(datos(1)).seccion=seccion('boveda',datos(2),datos(3),datos(4));
            datos(2:4)=[];
            end
    end
    Conduit(datos(1)).longitud=datos(2);
    Conduit(datos(1)).n=datos(3);
    Conduit(datos(1)).ERNi=datos(4);
    Conduit(datos(1)).ERNf=datos(5);
      
    Conduit(datos(1)).Sp=(Conduit(datos(1)).ERNi-Conduit(datos(1)).ERNf)/Conduit(datos(1)).longitud;
    Conduit(datos(1)).beta=sqrt(Conduit(datos(1)).Sp)/Conduit(datos(1)).n;
    Conduit(datos(1)).offset1=Conduit(datos(1)).ERNi- Node(Conduit(datos(1)).nodoI).elevacionR;
    Conduit(datos(1)).offset2=Conduit(datos(1)).ERNf- Node(Conduit(datos(1)).nodoF).elevacionR;
    Conduit(datos(1)).seccion=getSMax(Conduit(datos(1)).seccion);
    Conduit(datos(1)).qFull=(1/Conduit(datos(1)).n)*Conduit(datos(1)).seccion.aFull*sqrt(Conduit(datos(1)).Sp)*Conduit(datos(1)).seccion.rFull^(2/3);
    Conduit(datos(1)).qMax=Conduit(datos(1)).seccion.sMax*sqrt(Conduit(datos(1)).Sp)/Conduit(datos(1)).n;
    Conduit(datos(1)).roughFactor = 9.81 * Conduit(datos(1)).n^2;
end
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
tablaTuberias(Conduit,handles,'eliminacion')
% hObject    handle to pushbutton85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton86.
function pushbutton86_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Storm element 
% //    Description:
% //        -Assign desing storm to catchment
% //    Update History
% =============================================================
%
function popupmenu8_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
tormenta=get(handles.popupmenu8,'value');
if tormenta==1
    return;
end
tormenta=tormenta-1;
if~isempty(modelo.cuencas)&&modelo.cuencas>0
    Tor=cell(1,modelo.cuencas);
    for i=1:modelo.cuencas
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Storm','SelectionMode','multiple');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Tormenta','SelectionMode','multiple');
    end
    
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        for i=1:length(Z)
            Catchment(Z(i)).tormenta=tormenta;
        end
    end
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    if strcmp(idioma,'english')
        Aviso('Operation completed','Success','help');
    else
        Aviso('Opración completa','Success','help');
    end
    
end
tablaCuencas(Catchment,handles,'eliminacion');
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


%% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Catchment element 
% //    Description:
% //        -Assign infiltracion data from file
% //        -Format file (txt): Method Properities
% //    Update History
% =============================================================
%
function pushbutton87_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
if strcmp(idioma,'english')
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Select data file');
else
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Seleccionar archivo');
end
if isnumeric(ruta) || isnumeric(nombre)
    return;
end

info = importdata(fullfile(ruta,nombre));
if size(info.data,2)~=2
    if strcmp(idioma,'english')
        Aviso('Verify data file','Error','error');
    else
        Aviso('Verificar archivo','Error','error');
    end
    return
end

try
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
for i=1:length(info.textdata)
    switch info.textdata{i}
        case 'SCS-NC'
            Catchment(info.data(i,1)).infiltracion=infiltracionNC('SCS-NC',info.data(i,2));
        case 'SCS-Modificado'
            Catchment(info.data(i,1)).infiltracion=infiltracionNC('SCS-Modificado',info.data(i,2));
    end

end
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
tablaCuencas(Catchment,handles,'eliminacion')
if strcmp(idioma,'english')
    Aviso('Operation completed','Success','help');
else
    Aviso('Opración completa','Success','help');
end
catch
    if strcmp(idioma,'english')
        Aviso('Verify data file','Error','error');
    else
        Aviso('Verificar archivo','Error','error');
    end
end
% hObject    handle to pushbutton87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Catchment element 
% //    Description:
% //        -Assign runoff data from file
% //        -Format file (txt): Method Properities
% //    Update History
% =============================================================
%
function pushbutton88_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
if strcmp(idioma,'english')
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Select data file');
else
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Seleccionar archivo');
end
if isnumeric(ruta) || isnumeric(nombre)
    return;
end

try
info = importdata(fullfile(ruta,nombre));

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
for i=1:length(info.textdata)
    switch info.textdata{i}
        case 'Onda-Cinematica'
            datos=info.data(i,:);
            datos(isnan(datos))=[];
            if isempty(datos)||length(datos)~=9
                continue
            else
                Catchment(datos(1)).escorrentia=escorrentiaOC('Onda-Cinematica',datos(2),datos(3),datos(4),datos(5),datos(6),datos(7),datos(8),datos(9));
                Catchment(datos(1)).escorrentia=areaDrenado(Catchment(datos(1)).escorrentia,Catchment(datos(1)));
            end
        case 'HU-SCS'
            datos=info.data(i,:);
            datos(isnan(datos))=[];
            if isempty(datos)||length(datos)~=2
                continue
            else
                Catchment(datos(1)).escorrentia=escorrentiaSCS('HU-SCS',datos(2));
            end
        case 'HU-Snyder'
            datos=info.data(i,:);
            datos(isnan(datos))=[];
            if isempty(datos)||length(datos)~=3
                continue
            else
                Catchment(datos(1)).escorrentia=escorrentiaSnyder('HU-Snyder',datos(2),datos(3));
            end
    end
end
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
tablaCuencas(Catchment,handles,'eliminacion')
if strcmp(idioma,'english')
    Aviso('Operation completed','Success','help');
else
    Aviso('Opración completa','Success','help');
end
catch
    if strcmp(idioma,'english')
        Aviso('Verify data file','Error','error');
    else
        Aviso('Verificar archivo','Error','error');
    end
end

% hObject    handle to pushbutton88 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Define speed animation (plan view)
% //    Update History
% =============================================================
%
function edit43_Callback(hObject, eventdata, handles)
global ProyectoHidrologico
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
velocidad=1/round(str2double(get(handles.edit43,'string')));
tiempoAnimacion=length(Simulation.tiempoTransito)*velocidad;
set(handles.edit46,'string',round(tiempoAnimacion))
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit43 as text
%        str2double(get(hObject,'String')) returns contents of edit43 as a double


%% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Plot specific result from element (plan view)
% //    Update History
% =============================================================
%
function fotograma(handles,i)
global  ProyectoHidrologico modelo

if get(handles.popupmenu9,'value')==1 || get(handles.popupmenu10,'value')==1
    return
end

axes(handles.axes2);
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
variable=get(handles.popupmenu10,'value');

switch get(handles.popupmenu9,'value')
    case 2 %Conduit
        tuberias=stormwaterSystem.Conduit;
        orden=stormwaterSystem.ordenTuberias;
        switch variable
            case 2 % Capacidad
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                set(handles.slider19, 'Value', i);
                for j=1:length(orden)
                    capacidad=max(tuberias(orden(j)).a1(i,2),tuberias(orden(j)).a2(i,2))/tuberias(orden(j)).seccion.aFull;
                    capacidad = round(capacidad,2);
                    if capacidad<=Lmin
                        C=cm(1,:);
                    elseif capacidad>=Lmax
                        C=cm(end,:);
                    else
                        capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                        if capacidad==0
                            capacidad=1;
                        end
                        C=cm(capacidad,:);
                    end
                        set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                end
    
            case 3 % Profundidad
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                set(handles.slider19, 'Value', i);
    
                for j=1:length(orden)
                    capacidad=max(tuberias(orden(j)).y1(i,2),tuberias(orden(j)).y2(i,2))/tuberias(orden(j)).seccion.profundidad;
                    capacidad = round(capacidad,2);
                    if capacidad<=Lmin
                        C=cm(1,:);
                    elseif capacidad>=Lmax
                        C=cm(end,:);
                    else
                        capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                        if capacidad==0
                            capacidad=1;
                        end
                        C=cm(capacidad,:);
                    end
                    set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                end
    
                
            case 5 % Estado
                [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                set(handles.slider19, 'Value', i);
                for j=1:length(orden)
                    capacidad=max(tuberias(orden(j)).q1(i,2),tuberias(orden(j)).q2(i,2))/tuberias(orden(j)).qMax;
                if capacidad<1
                    C=cm(1,:);
                else
                    C=cm(2,:);
                end
                    set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                end
            case 4 %Velocidad                
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                velMax=str2double(get(handles.edit66,'string'));
                set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                set(handles.slider19, 'Value', i);
                for j=1:length(orden)
                    capacidad=max(tuberias(orden(j)).q1(i,2)/tuberias(orden(j)).a1(i,2),tuberias(orden(j)).q2(i,2)/tuberias(orden(j)).a2(i,2));
                    if isnan(capacidad)
                        capacidad=0;
                    end
                    capacidad = round(capacidad/velMax,2);
                    if capacidad<=Lmin/velMax
                        C=cm(1,:);
                    elseif capacidad>=Lmax/velMax
                        C=cm(end,:);
                    else
                        capacidad = round((capacidad-(Lmin/velMax))/(((Lmax/velMax)-(Lmin/velMax))/intervalos));
                        if capacidad==0
                            capacidad=1;
                        end
                        C=cm(capacidad,:);
                    end
                    set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                end
        end
    case 3 %Node
        nodos=stormwaterSystem.Node;
        switch variable
            case 2 %Inundacion
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                inMax=str2double(get(handles.edit66,'string'));
                set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                set(handles.slider19, 'Value', i);
                for j=1:length(nodos)
                    capacidad=nodos(j).hidrogramaNeto(i,2);
                    if isnan(capacidad)
                        capacidad=0;
                    end
                    capacidad = round(capacidad/inMax,2);
                    if capacidad<=Lmin/inMax
                        C=cm(1,:);
                    elseif capacidad>=Lmax/inMax
                        C=cm(end,:);
                    else
                        capacidad = round((capacidad-(Lmin/inMax))/(((Lmax/inMax)-(Lmin/inMax))/intervalos));
                        if capacidad==0
                            capacidad=1;
                        end
                        C=cm(capacidad,:);
                        
                    end
                    set(modelo.graficoNodosPl(j),'Color',C);
                    set(modelo.graficoNodosPl(j),'MarkerFaceColor',C);
                    set(modelo.graficoNodosPl(j),'MarkerSize',5+capacidad);
                    
                end
            case 3 %Estado
                [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                set(handles.slider19, 'Value', i);
                for j=1:length(nodos)
                    capacidad=nodos(j).hidrogramaNeto(i,2);
                    if isnan(capacidad)
                        capacidad=0;
                    end
                    if capacidad<1
                        C=cm(1,:);
                    else
                        C=cm(2,:);
                    end
                    set(modelo.graficoNodosPl(j),'Color',C);
                    set(modelo.graficoNodosPl(j),'MarkerFaceColor',C);
                end
        end
    case 4 %Subcuencas
        cuencas=stormwaterSystem.Catchment;
        switch variable
            case 2 %Escorrentia
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                set(handles.slider19, 'Value', i);
                for j=1:length(cuencas)
                    capacidad=cuencas(j).hidrograma(i,2)/max(cuencas(j).hidrograma(:,2));
                    capacidad = round(capacidad,2);
                    if capacidad<=Lmin
                        C=cm(1,:);
                    elseif capacidad>=Lmax
                        C=cm(end,:);
                    else
                        capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                        if capacidad==0
                            capacidad=1;
                        end
                        C=cm(capacidad,:);
                    end
                        set(modelo.graficoCuencasPl(j),'FaceColor',C);
                        set(modelo.graficoCuencasPl(j),'MarkerFaceColor',C);
                end    
        end
end 


%% Result visualization
% //    Description:
% //        -View temporal result from element (plan view)
% //    Update History
% =============================================================
%
function pushbutton92_Callback(hObject, eventdata, handles)
i=get(handles.slider19, 'Min');
set(handles.slider19, 'Value', i);
fotograma(handles,round(get(handles.slider19,'Value')))
% hObject    handle to pushbutton92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Play animation result from element (plan view)
% //    Update History
% =============================================================
%
function pushbutton94_Callback(hObject, eventdata, handles)
global  ProyectoHidrologico modelo

if get(handles.popupmenu9,'value')==1 || get(handles.popupmenu10,'value')==1
    return
end

axes(handles.axes2);
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
velocidad=1/round(str2double(get(handles.edit43,'string')));

modelo.bandera=0;
variable=get(handles.popupmenu10,'value');

switch get(handles.popupmenu9,'value')
    case 2 %Conduit
        tuberias=stormwaterSystem.Conduit;
        orden=stormwaterSystem.ordenTuberias;
        switch variable
            case 2 % Capacidad         
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(orden)
                        capacidad=max(tuberias(orden(j)).a1(i,2),tuberias(orden(j)).a2(i,2))/tuberias(orden(j)).seccion.aFull;
                        capacidad = round(capacidad,2);
                        if strcmp(get(handles.Untitled_33,'Checked'),'on')
                            I=['C = ',num2str(capacidad,'%0.2f')];
                            Datos=get(modelo.labelNodosPl(orden(j)),'String');
                            Datos{2}=I;
                            set(modelo.labelNodosPl(orden(j)),'String',Datos);
                        end
                        if capacidad<=Lmin
                            C=cm(1,:);
                        elseif capacidad>=Lmax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                        end
                        set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                    end
                    pause (velocidad)
                    if modelo.bandera~=0
                        break
                    end
                end
            case 3 % Profundidad
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(orden)
                         capacidad=max(tuberias(orden(j)).y1(i,2),tuberias(orden(j)).y2(i,2))/tuberias(orden(j)).seccion.profundidad;
                        capacidad = round(capacidad,2);
                        if strcmp(get(handles.Untitled_33,'Checked'),'on')
                            I=['Y = ',num2str(capacidad,'%0.2f')];
                            Datos=get(modelo.labelNodosPl(orden(j)),'String');
                            Datos{2}=I;
                            set(modelo.labelNodosPl(orden(j)),'String',Datos);
                        end
                        if capacidad<=0
                            C=cm(1,:);
                        elseif capacidad>=Lmax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                        end
                        set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
    
                    end
                    pause (velocidad)
                    if modelo.bandera~=0
                        break
                    end
                end
                
            case 5 % Estado
                [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(orden)
                        capacidad=max(tuberias(orden(j)).q1(i,2),tuberias(orden(j)).q2(i,2))/tuberias(orden(j)).qMax;
                        if strcmp(get(handles.Untitled_33,'Checked'),'on')
                            if capacidad<1
                                dato=0;
                            else
                                dato=1;
                            end
                            I=['I = ',num2str(dato,'%0.0f')];
                            Datos=get(modelo.labelNodosPl(orden(j)),'String');
                            Datos{2}=I;
                            set(modelo.labelNodosPl(orden(j)),'String',Datos);
                        end
                        if capacidad<1
                            C=cm(1,:);
                        else
                            C=cm(2,:);
                        end
                        set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                    end
                    pause (velocidad)
                    if modelo.bandera~=0
                        break
                    end
                end
            case 4 %Velocidad
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                velMax=str2double(get(handles.edit66,'string'));
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(orden)
                        capacidad=max(tuberias(orden(j)).q1(i,2)/tuberias(orden(j)).a1(i,2),tuberias(orden(j)).q2(i,2)/tuberias(orden(j)).a2(i,2));
                        if isnan(capacidad)
                            capacidad=0;
                        end
                        if strcmp(get(handles.Untitled_33,'Checked'),'on')
                            I=['V = ',num2str(capacidad,'%0.2f'),' m/s'];
                            Datos=get(modelo.labelNodosPl(orden(j)),'String');
                            Datos{2}=I;
                            set(modelo.labelNodosPl(orden(j)),'String',Datos);
                        end
                        capacidad = round(capacidad/velMax,2);
                        if capacidad<=Lmin/velMax
                            C=cm(1,:);
                        elseif capacidad>=Lmax/velMax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-(Lmin/velMax))/(((Lmax/velMax)-(Lmin/velMax))/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                        end
                        set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                    end
                    pause (velocidad)
                    if modelo.bandera~=0
                        break
                    end
                end
        end
    case 3
        nodos=stormwaterSystem.Node;
        switch variable
            case 2 %Inundacion
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                inMax=str2double(get(handles.edit66,'string'));
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(nodos)
                        capacidad=nodos(j).hidrogramaNeto(i,2);
                        if isnan(capacidad)
                            capacidad=0;
                        end
                        if strcmp(get(handles.Untitled_33,'Checked'),'on')
                            I=['I = ',num2str(capacidad,'%0.2f'),' m3'];
                            Datos=get(modelo.labelNodosPl(j),'String');
                            Datos{2}=I;
                            set(modelo.labelNodosPl(j),'String',Datos);
                        end
                        capacidad = round(capacidad/inMax,2);

                        if capacidad<=Lmin/inMax
                            C=cm(1,:);
                        elseif capacidad>=Lmax/inMax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-(Lmin/inMax))/(((Lmax/inMax)-(Lmin/inMax))/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                            
                        end
                        set(modelo.graficoNodosPl(j),'Color',C);
                        set(modelo.graficoNodosPl(j),'MarkerFaceColor',C);
                        set(modelo.graficoNodosPl(j),'MarkerSize',5+capacidad);
                        
                    end
                    pause (velocidad)
                    if modelo.bandera~=0
                        break
                    end
                end
            case 3 %Estado
                [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(nodos)
                        capacidad=nodos(j).hidrogramaNeto(i,2);
                        
                        if isnan(capacidad)
                            capacidad=0;
                        end
                        if capacidad<=0
                            C=cm(1,:);
                        else
                            C=cm(2,:);
                        end
                        if strcmp(get(handles.Untitled_33,'Checked'),'on')
                            if capacidad<=0
                                dato=0;
                            else
                                dato=1;
                            end
                            I=['I = ',num2str(dato,'%0.0f')];
                            Datos=get(modelo.labelNodosPl(j),'String');
                            Datos{2}=I;
                            set(modelo.labelNodosPl(j),'String',Datos);
                        end
                        set(modelo.graficoNodosPl(j),'Color',C);
                        set(modelo.graficoNodosPl(j),'MarkerFaceColor',C);
                    end
                    pause (velocidad)
                    if modelo.bandera~=0
                        break
                    end
                end
        end
    case 4 %Subcuencas
        cuencas=stormwaterSystem.Catchment;
        switch variable
            case 2 %Escorrentia
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(cuencas)
                        capacidad=cuencas(j).hidrograma(i,2)/max(cuencas(j).hidrograma(:,2));
                        capacidad = round(capacidad,2);
                        if strcmp(get(handles.Untitled_33,'Checked'),'on')
                            I=['Q = ',num2str(capacidad,'%0.2f')];
                            Datos=get(modelo.labelNodosPl(j),'String');
                            Datos{2}=I;
                            set(modelo.labelNodosPl(j),'String',Datos);
                        end
                        if capacidad<=Lmin
                            C=cm(1,:);
                        elseif capacidad>=Lmax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                        end
                            set(modelo.graficoCuencasPl(j),'FaceColor',C);
                            set(modelo.graficoCuencasPl(j),'MarkerFaceColor',C);                            
                    end
                    pause (velocidad)
                    if modelo.bandera~=0
                        break
                    end
                end
        end   
end
% hObject    handle to pushbutton94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Stop animation result from element (plan view)
% //    Update History
% =============================================================
%
function pushbutton95_Callback(hObject, eventdata, handles)
global modelo
modelo.bandera=1;
% hObject    handle to pushbutton95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Previous temporal result from element (plan view)
% //    Update History
% =============================================================
%
function pushbutton93_Callback(hObject, eventdata, handles)
i=get(handles.slider19, 'Value');
if i==get(handles.slider19, 'Min')
    return;
end
set(handles.slider19, 'Value', i-1);
fotograma(handles,get(handles.slider19, 'Value'))
% hObject    handle to pushbutton93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double


%% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Plot current result from element on external figure (plan view)
% //    Update History
% =============================================================
%
function pushbutton99_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma

if get(handles.popupmenu9,'value')==1 || get(handles.popupmenu10,'value')==1
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
axes(handles.axes2);
xl = xlim;
yl = ylim;
f=figure;
f.Color=[1,1,1];
xlim(xl)
ylim(yl)
axis equal
ax = gca;
ax.XColor=[1,1,1];
ax.YColor=[1,1,1];

posicion1=get(handles.moduloHidrologico,'Position');
posicion2=f.Position;
pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.75;
pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.35;
posicion=[pos1,pos2,posicion2(3:4)];
f.Position=posicion;

[graficoTuberiasPl,graficoCuencasPl,graficoNodosPl]=plotSimulacion(stormwaterSystem);
variable=get(handles.popupmenu10,'value');

switch get(handles.popupmenu20,'value')
    case 2
        i=round(get(handles.slider19,'Value'));
        switch get(handles.popupmenu9,'value')
            case 2%Conduit
                tuberias=stormwaterSystem.Conduit;
                orden=stormwaterSystem.ordenTuberias;
                switch variable
                    case 2 % Capacidad
                        [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                        if Lmin>0
                            labels{1}=['<=',labels{1}];
                        end
                        if Lmax<1
                            labels{end}=['>=',labels{end}];
                        end
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=(0:1/intervalos:1);
                        c.TickLabels=labels;
                        if strcmp(idioma,'english')
                            c.Label.String='Hydraulic capacity (%)';
                        else
                            c.Label.String='Capacidad hidráulica(%)';
                        end
                        
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
                        
                        for j=1:length(orden)
                            capacidad=max(tuberias(orden(j)).a1(i,2),tuberias(orden(j)).a2(i,2))/tuberias(orden(j)).seccion.aFull;
                            capacidad = round(capacidad,2);
                            if capacidad<=Lmin
                                C=cm(1,:);
                            elseif capacidad>=Lmax
                                C=cm(end,:);
                            else
                                capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                                if capacidad==0
                                    capacidad=1;
                                end
                                C=cm(capacidad,:);
                            end
                                set(graficoTuberiasPl(orden(j)),'Color',C);
                        end
        
        
                    case 3 % Profundidad
                        [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                        if Lmin>0
                            labels{1}=['<=',labels{1}];
                        end
                        if Lmax<1
                            labels{end}=['>=',labels{end}];
                        end
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=(0:1/intervalos:1);
                        c.TickLabels=labels;
                        if strcmp(idioma,'english')
                            c.Label.String='Flow depth (%)';
                        else
                            c.Label.String='Profundidad de flujo (%)';
                        end
                        
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
                        for j=1:length(orden)
                            capacidad=max(tuberias(orden(j)).y1(i,2),tuberias(orden(j)).y2(i,2))/tuberias(orden(j)).seccion.profundidad;
                            capacidad = round(capacidad,2);
                            if capacidad<=Lmin
                                C=cm(1,:);
                            elseif capacidad>=Lmax
                                C=cm(end,:);
                            else
                                capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                                if capacidad==0
                                    capacidad=1;
                                end
                                C=cm(capacidad,:);
                            end
                            set(graficoTuberiasPl(orden(j)),'Color',C);
                        end
        
                    case 4 % Velocidad
                        [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                        velMax=str2double(get(handles.edit66,'string'));
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=(0:1/intervalos:1);
                        c.TickLabels=labels;
                        if strcmp(idioma,'english')
                            c.Label.String='Velocity (%)';
                        else
                            c.Label.String='Velocidad (%)';
                        end
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
        
                        for j=1:length(orden)
                            capacidad=max(tuberias(orden(j)).q1(i,2)/tuberias(orden(j)).a1(i,2),tuberias(orden(j)).q2(i,2)/tuberias(orden(j)).a2(i,2));
                            if isnan(capacidad)
                                capacidad=0;
                            end
                            capacidad = round(capacidad/velMax,2);
                            if capacidad<=Lmin/velMax
                                C=cm(1,:);
                            elseif capacidad>=Lmax/velMax
                                C=cm(end,:);
                            else
                                capacidad = round((capacidad-(Lmin/velMax))/(((Lmax/velMax)-(Lmin/velMax))/intervalos));
                                if capacidad==0
                                    capacidad=1;
                                end
                                C=cm(capacidad,:);
                            end
                            set(graficoTuberiasPl(orden(j)),'Color',C);
                        end
        
                    case 5 % Estado
                        [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=[0,1];
                        c.TickLabels={'0','1'};
                        if strcmp(idioma,'english')
                            c.Label.String='Functional state';
                        else
                           c.Label.String='Estado funcional';
                        end
                        
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
        
                        for j=1:length(orden)
                            capacidad=max(tuberias(orden(j)).q1(i,2),tuberias(orden(j)).q2(i,2))/tuberias(orden(j)).qMax;
                        if capacidad<1
                            C=cm(1,:);
                        else
                            C=cm(2,:);
                        end
                            set(graficoTuberiasPl(orden(j)),'Color',C);
                        end
                end
            case 3 %Node
                nodos=stormwaterSystem.Node;
                switch variable
                    case 2 %Inundacion
                        [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                        inMax=str2double(get(handles.edit66,'string'));
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=(0:1/intervalos:1);
                        c.TickLabels=labels;
                        if strcmp(idioma,'english')
                            c.Label.String='Flooding (m3)';
                        else
                           c.Label.String='Inundación (m3)';
                        end
                        
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
                        for j=1:length(nodos)
                            capacidad=nodos(j).hidrogramaNeto(i,2);
                            if isnan(capacidad)
                                capacidad=0;
                            end
                            capacidad = round(capacidad/inMax,2);
                            if capacidad<=Lmin/inMax
                                C=cm(1,:);
                            elseif capacidad>=Lmax/inMax
                                C=cm(end,:);
                            else
                                capacidad = round((capacidad-(Lmin/inMax))/(((Lmax/inMax)-(Lmin/inMax))/intervalos));
                                if capacidad==0
                                    capacidad=1;
                                end
                                C=cm(capacidad,:);
                                
                            end
                            set(graficoNodosPl(j),'Color',C);
                            set(graficoNodosPl(j),'MarkerFaceColor',C);
                            set(graficoNodosPl(j),'MarkerSize',5+capacidad);             
                        end
        
                    case 3 %Estado
                        [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=[0,1];
                        c.TickLabels={'0','1'};
                        if strcmp(idioma,'english')
                            c.Label.String='Functional state';
                        else
                           c.Label.String='Estado funcional';
                        end
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
        
                        for j=1:length(nodos)
                            capacidad=nodos(j).hidrogramaNeto(i,2);
                            if isnan(capacidad)
                                capacidad=0;
                            end
                            if capacidad<1
                                C=cm(1,:);
                            else
                                C=cm(2,:);
                            end
                            set(graficoNodosPl(j),'Color',C);
                            set(graficoNodosPl(j),'MarkerFaceColor',C);
                        end
                end
            case 4 %Subcuencas
                cuencas=stormwaterSystem.Catchment;
                switch variable
                    case 2
                        [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                        if Lmin>0
                            labels{1}=['<=',labels{1}];
                        end
                        if Lmax<1
                            labels{end}=['>=',labels{end}];
                        end
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=(0:1/intervalos:1);
                        c.TickLabels=labels;
                        if strcmp(idioma,'english')
                            c.Label.String='Runoff (%)';
                        else
                           c.Label.String='EscorrentÃ­a (%)';
                        end
                        
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
                        for j=1:length(cuencas)
                            capacidad=cuencas(j).hidrograma(i,2)/max(cuencas(j).hidrograma(:,2));
                            capacidad = round(capacidad,2);
                            if capacidad<=Lmin
                                C=cm(1,:);
                            elseif capacidad>=Lmax
                                C=cm(end,:);
                            else
                                capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                                if capacidad==0
                                    capacidad=1;
                                end
                                C=cm(capacidad,:);
                            end
                            set(graficoCuencasPl(j),'FaceColor',C);
                            set(graficoCuencasPl(j),'MarkerFaceColor',C);
                        end  
                end
        
        end

    case 4
        switch get(handles.popupmenu9,'value')
            case 2%Conduit
                tuberias=stormwaterSystem.Conduit;
                orden=stormwaterSystem.ordenTuberias;
                switch variable
                    case 2 % Capacidad
                        [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                        if Lmin>0
                            labels{1}=['<=',labels{1}];
                        end
                        if Lmax<1
                            labels{end}=['>=',labels{end}];
                        end
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=(0:1/intervalos:1);
                        c.TickLabels=labels;
                        if strcmp(idioma,'english')
                            c.Label.String='Hydraulic capacity (%)';
                        else
                            c.Label.String='Capacidad hidráulica(%)';
                        end
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
                        
                        for j=1:length(orden)
                            capacidad=max(max(tuberias(orden(j)).a1(:,2)),max(tuberias(orden(j)).a2(:,2)))/tuberias(orden(j)).seccion.aFull;
                            capacidad = round(capacidad,2);
                            if capacidad<=Lmin
                                C=cm(1,:);
                            elseif capacidad>=Lmax
                                C=cm(end,:);
                            else
                                capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                                if capacidad==0
                                    capacidad=1;
                                end
                                C=cm(capacidad,:);
                            end
                                set(graficoTuberiasPl(orden(j)),'Color',C);
                        end
        
        
                    case 3 % Profundidad
                        [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                        if Lmin>0
                            labels{1}=['<=',labels{1}];
                        end
                        if Lmax<1
                            labels{end}=['>=',labels{end}];
                        end
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=(0:1/intervalos:1);
                        c.TickLabels=labels;
                        if strcmp(idioma,'english')
                            c.Label.String='Flow depth (%)';
                        else
                            c.Label.String='Profundidad de flujo (%)';
                        end
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
                        y1=zeros(size(tuberias(orden(1)).a1,1),1);
                        y2=y1;
                        for j=1:length(orden)
                            capacidad=max(max(tuberias(orden(j)).y1(:,2)),max(tuberias(orden(j)).y2(:,2)))/tuberias(orden(j)).seccion.profundidad;
                            capacidad = round(capacidad,2);
                            if capacidad<=Lmin
                                C=cm(1,:);
                            elseif capacidad>=Lmax
                                C=cm(end,:);
                            else
                                capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                                if capacidad==0
                                    capacidad=1;
                                end
                                C=cm(capacidad,:);
                            end
                            set(graficoTuberiasPl(orden(j)),'Color',C);
                        end
        
                    case 4 % Velocidad
                        [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                        velMax=str2double(get(handles.edit66,'string'));
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=(0:1/intervalos:1);
                        c.TickLabels=labels;
                        if strcmp(idioma,'english')
                            c.Label.String='Velocity (%)';
                        else
                            c.Label.String='Velocidad (%)';
                        end
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
        
                        for j=1:length(orden)
                            capacidad=max(max(tuberias(orden(j)).q1(:,2)./tuberias(orden(j)).a1(:,2)),max(tuberias(orden(j)).q2(:,2)./tuberias(orden(j)).a2(:,2)));
                            if isnan(capacidad)
                                capacidad=0;
                            end
                            capacidad = round(capacidad/velMax,2);
                            if capacidad<=Lmin/velMax
                                C=cm(1,:);
                            elseif capacidad>=Lmax/velMax
                                C=cm(end,:);
                            else
                                capacidad = round((capacidad-(Lmin/velMax))/(((Lmax/velMax)-(Lmin/velMax))/intervalos));
                                if capacidad==0
                                    capacidad=1;
                                end
                                C=cm(capacidad,:);
                            end
                            set(graficoTuberiasPl(orden(j)),'Color',C);
                        end
        
                    case 5 % Estado
                        [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=[0,1];
                        c.TickLabels={'0','1'};
                        if strcmp(idioma,'english')
                            c.Label.String='Functional state';
                        else
                           c.Label.String='Estado funcional';
                        end
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
        
                        for j=1:length(orden)
                            capacidad=max(tuberias(orden(j)).q1(:,2),tuberias(orden(j)).q2(:,2))/tuberias(orden(j)).qMax;
                        if capacidad<1
                            C=cm(1,:);
                        else
                            C=cm(2,:);
                        end
                            set(graficoTuberiasPl(orden(j)),'Color',C);
                        end
                end
            case 3 %Node
                nodos=stormwaterSystem.Node;
                switch variable
                    case 2 %Inundacion
                        [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                        inMax=str2double(get(handles.edit66,'string'));
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=(0:1/intervalos:1);
                        c.TickLabels=labels;
                        if strcmp(idioma,'english')
                            c.Label.String='Flooding (m3)';
                        else
                           c.Label.String='Inundación (m3)';
                        end
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
                        for j=1:length(nodos)
                            capacidad=max(nodos(j).hidrogramaNeto(:,2));
                            if isnan(capacidad)
                                capacidad=0;
                            end
                            capacidad = round(capacidad/inMax,2);
                            if capacidad<=Lmin/inMax
                                C=cm(1,:);
                            elseif capacidad>=Lmax/inMax
                                C=cm(end,:);
                            else
                                capacidad = round((capacidad-(Lmin/inMax))/(((Lmax/inMax)-(Lmin/inMax))/intervalos));
                                if capacidad==0
                                    capacidad=1;
                                end
                                C=cm(capacidad,:);
                                
                            end
                            set(graficoNodosPl(j),'Color',C);
                            set(graficoNodosPl(j),'MarkerFaceColor',C);
                            set(graficoNodosPl(j),'MarkerSize',5+capacidad);             
                        end
        
                    case 3 %Estado
                        [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                        colormap (cm)
                        c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                        c.Visible='off';
                        c.Ticks=[0,1];
                        c.TickLabels={'0','1'};
                        if strcmp(idioma,'english')
                            c.Label.String='Functional state';
                        else
                           c.Label.String='Estado funcional';
                        end
                        c.Label.FontName='Open Sans';
                        c.Label.FontSize=8;
                        c.Label.FontWeight='bold';
        
                        for j=1:length(nodos)
                            capacidad=max(nodos(j).hidrogramaNeto(:,2));
                            if isnan(capacidad)
                                capacidad=0;
                            end
                            if capacidad<1
                                C=cm(1,:);
                            else
                                C=cm(2,:);
                            end
                            set(graficoNodosPl(j),'Color',C);
                            set(graficoNodosPl(j),'MarkerFaceColor',C);
                        end
                end
        
        end

end

switch get(handles.popupmenu22,'value')
   case 1
       c.Location="eastoutside";
        switch get(handles.popupmenu21,'value')
            case 1
                c.Position(3)=0.3*c.Position(3);
            case 2
                c.Position(3)=0.3*c.Position(3);
                c.Position(4)=0.75*c.Position(4);
            case 3
                c.Position(3)=0.3*c.Position(3);
                c.Position(4)=0.5*c.Position(4);
        end
   case 2
        c.Location="westoutside";
        switch get(handles.popupmenu21,'value')
            case 1
                c.Position(3)=0.3*c.Position(3);
            case 2
                c.Position(3)=0.3*c.Position(3);
                c.Position(4)=0.75*c.Position(4);
            case 3
                c.Position(3)=0.3*c.Position(3);
                c.Position(4)=0.5*c.Position(4);
        end
    case 3
        c.Location="northoutside";
        switch get(handles.popupmenu21,'value')
            case 1
                c.Position(4)=0.3*c.Position(4);
            case 2
                c.Position(3)=0.75*c.Position(3);
                c.Position(4)=0.3*c.Position(4);
            case 3
                c.Position(3)=0.5*c.Position(3);
                c.Position(4)=0.3*c.Position(4);
        end
    case 4
        c.Location="southoutside";
        switch get(handles.popupmenu21,'value')
            case 1
                c.Position(4)=0.3*c.Position(4);
            case 2
                c.Position(3)=0.75*c.Position(3);
                c.Position(4)=0.3*c.Position(4);
            case 3
                c.Position(3)=0.5*c.Position(3);
                c.Position(4)=0.3*c.Position(4);
        end
end
c.Visible='on';

% hObject    handle to pushbutton99 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ------------------------------------------------------------------------
function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


%% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Save result from element to video (plan view)
% //    Update History
% =============================================================
%
function pushbutton98_Callback(hObject, eventdata, handles)
global  ProyectoHidrologico modelo idioma

if get(handles.popupmenu9,'value')==1 || get(handles.popupmenu10,'value')==1
    return
end
 nombre=get(handles.edit44,'string');
if isempty(nombre)
    if strcmp(idioma,'english')
        Aviso('Enter video name','Error','error');
    else
       Aviso('Ingresar nombre del video','Error','error');
    end
    return
end

axes(handles.axes2);
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
velocidad=1/round(str2double(get(handles.edit43,'string')));

jFrame = get(handle(gcf),'JavaFrame');
jRootPane = jFrame.fHG2Client.getWindow;
statusbarObj = com.mathworks.mwswing.MJStatusBar;
jProgressBar = javax.swing.JProgressBar;
numIds = 10;
set(jProgressBar, 'Minimum',0, 'Maximum',numIds, 'Value',0);
jRootPane.setStatusBarVisible(1);

statusbarObj.add(jProgressBar,'West');
set(jProgressBar,'Value',1);
if strcmp(idioma,'english')
    msg = 'Configurate file... (10%)';
else
   msg = 'Configurando archivo... (10%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

ax=gca;
ax.Units = 'pixels';
pos = ax.Position;
ti = ax.TightInset;
rect = [-5,-10, pos(3)+10, pos(4)+10];
Fotos=[];
modelo.bandera=0;
variable=get(handles.popupmenu10,'value');

set(jProgressBar,'Value',5);
if strcmp(idioma,'english')
    msg = 'Generate frames... (50%)';
else
   msg = 'Generando frames... (50%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

switch get(handles.popupmenu9,'value')
    case 2 %Conduit
        tuberias=stormwaterSystem.Conduit;
        orden=stormwaterSystem.ordenTuberias;
        switch variable
            case 2 % Capacidad         
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(orden)
                        capacidad=max(tuberias(orden(j)).a1(i,2),tuberias(orden(j)).a2(i,2))/tuberias(orden(j)).seccion.aFull;
                        capacidad = round(capacidad,2);
                        if capacidad<=Lmin
                            C=cm(1,:);
                        elseif capacidad>=Lmax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                        end
                        set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                    end
                    Fotos=[Fotos,getframe(ax,rect)];
                    if modelo.bandera~=0
                        break
                    end
                end
            case 3 % Profundidad
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(orden)
                        y1=getYofA(tuberias(orden(j)).seccion,tuberias(orden(j)).a1(i,2));
                        y2=getYofA(tuberias(orden(j)).seccion,tuberias(orden(j)).a2(i,2));
    
                        capacidad=max(y1,y2)/tuberias(orden(j)).seccion.profundidad;
                        capacidad = round(capacidad,2);
                        if capacidad<=0
                            C=cm(1,:);
                        elseif capacidad>=Lmax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                        end
                        set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
    
                    end
                    Fotos=[Fotos,getframe(ax,rect)];
                    if modelo.bandera~=0
                        break
                    end
                end
                
            case 5 % Estado
                [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(orden)
                        capacidad=max(tuberias(orden(j)).q1(i,2),tuberias(orden(j)).q2(i,2))/tuberias(orden(j)).qMax;
                        if capacidad<1
                            C=cm(1,:);
                        else
                            C=cm(2,:);
                        end
                        set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                    end
                    Fotos=[Fotos,getframe(ax,rect)];
                    if modelo.bandera~=0
                        break
                    end
                end
            case 4 %Velocidad
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                velMax=str2double(get(handles.edit66,'string'));
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(orden)
                        capacidad=max(tuberias(orden(j)).q1(i,2)/tuberias(orden(j)).a1(i,2),tuberias(orden(j)).q2(i,2)/tuberias(orden(j)).a2(i,2));
                        if isnan(capacidad)
                            capacidad=0;
                        end
                        capacidad = round(capacidad/velMax,2);
                        if capacidad<=Lmin/velMax
                            C=cm(1,:);
                        elseif capacidad>=Lmax/velMax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-(Lmin/velMax))/(((Lmax/velMax)-(Lmin/velMax))/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                        end
                        set(modelo.graficoTuberiasPl(orden(j)),'Color',C);
                    end
                    Fotos=[Fotos,getframe(ax,rect)];
                    if modelo.bandera~=0
                        break
                    end
                end
        end
    case 3
        nodos=stormwaterSystem.Node;
        switch variable
            case 2 %Inundacion
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                inMax=str2double(get(handles.edit66,'string'));
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(nodos)
                        capacidad=nodos(j).hidrogramaNeto(i,2);
                        if isnan(capacidad)
                            capacidad=0;
                        end
                        capacidad = round(capacidad/inMax,2);
                        if capacidad<=Lmin/inMax
                            C=cm(1,:);
                        elseif capacidad>=Lmax/inMax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-(Lmin/inMax))/(((Lmax/inMax)-(Lmin/inMax))/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                            
                        end
                        set(modelo.graficoNodosPl(j),'Color',C);
                        set(modelo.graficoNodosPl(j),'MarkerFaceColor',C);
                        set(modelo.graficoNodosPl(j),'MarkerSize',5+capacidad);
                        
                    end
                    Fotos=[Fotos,getframe(ax,rect)];
                    if modelo.bandera~=0
                        break
                    end
                end
            case 3 %Estado
                [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(nodos)
                        capacidad=nodos(j).hidrogramaNeto(i,2);
                        if isnan(capacidad)
                            capacidad=0;
                        end
                        if capacidad<1
                            C=cm(1,:);
                        else
                            C=cm(2,:);
                        end
                        set(modelo.graficoNodosPl(j),'Color',C);
                        set(modelo.graficoNodosPl(j),'MarkerFaceColor',C);
                    end
                    Fotos=[Fotos,getframe(ax,rect)];
                    if modelo.bandera~=0
                        break
                    end
                end
        end
    case 4 %Subcuencas
        cuencas=stormwaterSystem.Catchment;
        switch variable
            case 2 %Escorrentia
                [cm,Lmin,Lmax,intervalos,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                for i=round(get(handles.slider19,'Value')):length(Simulation.tiempoTransito)
                    set(handles.text95,'string',['min: ',num2str(Simulation.tiempoTransito(i)/60)])
                    set(handles.slider19, 'Value', i);
                    for j=1:length(cuencas)
                        capacidad=cuencas(j).hidrograma(i,2)/max(cuencas(j).hidrograma(:,2));
                        capacidad = round(capacidad,2);
                        if capacidad<=Lmin
                            C=cm(1,:);
                        elseif capacidad>=Lmax
                            C=cm(end,:);
                        else
                            capacidad = round((capacidad-Lmin)/((Lmax-Lmin)/intervalos));
                            if capacidad==0
                                capacidad=1;
                            end
                            C=cm(capacidad,:);
                        end
                            set(modelo.graficoCuencasPl(j),'FaceColor',C);
                            set(modelo.graficoCuencasPl(j),'MarkerFaceColor',C);                            
                    end
                    Fotos=[Fotos,getframe(ax,rect)];
                    if modelo.bandera~=0
                        break
                    end
                end
        end   
end

set(jProgressBar,'Value',5);
if strcmp(idioma,'english')
    msg = 'Save video... (50%)';
else
   msg = 'Guardar video... (50%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

if isempty(Fotos)
    pause(0.5)
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Operation incompleted','Error','error');
    else
       Aviso('Operación incompleta','Error','error');
    end
    return
end

v = VideoWriter(fullfile(ProyectoHidrologico.carpetaBase,'Data',[nombre,'.avi']));
v.Quality = 100;
v.FrameRate = 1/velocidad;  
open(v)
writeVideo(v,Fotos)
close(v)

set(jProgressBar,'Value',10);
if strcmp(idioma,'english')
    msg = 'Completed... (100%)';
else
   msg = 'Completado... (100%)';
end

fotograma(handles,round(get(handles.slider19, 'Value')))
statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);
pause(0.5)
jRootPane.setStatusBarVisible(0);

% hObject    handle to pushbutton98 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -View temporal result from element (plan view)
% //    Update History
% =============================================================
%
function slider19_Callback(hObject, eventdata, handles)
fotograma(handles,round(get(handles.slider19, 'Value')))
% hObject    handle to slider19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Result visualization
% //    Description:
% //        -Next temporal result from element (plan view)
% //    Update History
% =============================================================
%
function pushbutton96_Callback(hObject, eventdata, handles)
i=get(handles.slider19, 'Value');
if i==get(handles.slider19, 'Max')
    return;
end
set(handles.slider19, 'Value', i+1);
fotograma(handles,get(handles.slider19, 'Value'))
% hObject    handle to pushbutton96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Final result from element (plan view)
% //    Update History
% =============================================================
%
function pushbutton97_Callback(hObject, eventdata, handles)
i=get(handles.slider19, 'Max');
set(handles.slider19, 'Value', i);
fotograma(handles,get(handles.slider19, 'Value'))
% hObject    handle to pushbutton97 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ------------------------------------------------------------------------
function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit46 as text
%        str2double(get(hObject,'String')) returns contents of edit46 as a double


%% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Select element to view result (plan view)
% //    Update History
% =============================================================
%
function popupmenu9_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
axes(handles.axes2);
set(handles.popupmenu10,'value',1);
switch get(handles.popupmenu20,'value')
    case 1

    otherwise
        set(handles.popupmenu10,'value',1)
        switch get(handles.popupmenu9,'value')
            case 1
                set(handles.popupmenu10,'string',{'---'})
            case 2
                if strcmp(idioma,'english')
                    variables={' ','Capacity','Depth','Velocity','State'};
                else
                   variables={' ','Capacidad','Profundidad','Velocidad','Estado'};
                end
                
                set(handles.popupmenu10,'string',variables)
                load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
                
                if ~isempty(modelo.labelNodosPl)
                    try
                    delete(modelo.labelNodosPl)
                    end
                    modelo.labelNodosPl=[];
                end
                labels=zeros(length(Conduit),1);
                for i=1:length(Conduit)
                    labels(i)=plotLabelTR(Conduit(i)); 
                end
                modelo.labelNodosPl=labels;
            case 3
                if strcmp(idioma,'english')
                    variables={' ','Flooding','State'};
                else
                   variables={' ','Inundación','Estado'};
                end
                
                set(handles.popupmenu10,'string',variables)
                load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
                if ~isempty(modelo.labelNodosPl)
                    delete(modelo.labelNodosPl)
                    modelo.labelNodosPl=[];
                end
                labels=zeros(length(Node),1);
                for i=1:length(Node)
                    labels(i)=plotLabelNR(Node(i)); 
                end
                modelo.labelNodosPl=labels;
                
            case 4
                if strcmp(idioma,'english')
                    variables={' ','Runoff'};
                else
                   variables={' ','EscorrentÃ­a'};
                end
                
                set(handles.popupmenu10,'string',variables)
                load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
                if ~isempty(modelo.labelNodosPl)
                    delete(modelo.labelNodosPl)
                    modelo.labelNodosPl=[];
                end
                labels=zeros(length(Catchment),1);
                for i=1:length(Catchment)
                    labels(i)=plotLabelCR(Catchment(i)); 
                end
                modelo.labelNodosPl=labels;
        end
        set(handles.popupmenu10,'enable','on');
end
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


%% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //    Update History
% =============================================================
%
function [cm,Lmin,Lmax,intervalos,labels]=barraColor(caso,handles)
intervalos=round(str2double(get(handles.edit67,'string')));
Lmin=round(str2double(get(handles.edit64,'string')),1);
Lmax=round(str2double(get(handles.edit66,'string')),1);
labels=cell(intervalos+1,1);
for i=1:intervalos+1
    labels{i}=num2str(round(Lmin+(i-1)*(Lmax-Lmin)/intervalos,2));
end
switch caso
    case 1
        cm=autumn(intervalos);
    case 2
        cm=bone(intervalos);
    case 3
        cm=cool(intervalos);
    case 4
        cm=copper(intervalos);
    case 5
        cm=gray(intervalos);
    case 6
        cm=hot(intervalos);
    case 7
        cm=hsv(intervalos);
    case 8
        cm=jet(intervalos);
    case 9
        cm=parula(intervalos);
    case 10
        cm=pink(intervalos);
    case 11
        cm=spring(intervalos);
    case 12
        cm=summer(intervalos);
    case 13 
        cm=turbo(intervalos);
    case 14
        cm=winter(intervalos);
end


%% Result visualization
% //    Description:
% //        -Select variable to view (plan view)
% //    Update History
% =============================================================
%
function popupmenu10_Callback(hObject, eventdata, handles)
global  ProyectoHidrologico 

if get(handles.popupmenu9,'value')==1 || get(handles.popupmenu10,'value')==1
    return
end

axes(handles.axes2);
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');

set(handles.slider19, 'Min', 1);
set(handles.slider19, 'Max', length(Simulation.tiempoTransito));
set(handles.slider19, 'Value', 1);
set(handles.slider19, 'SliderStep',[1/(length(Simulation.tiempoTransito)-1), 1/(length(Simulation.tiempoTransito)-1)]);
variable=get(handles.popupmenu10,'value');

switch get(handles.popupmenu9,'value')
    case 2 %Conductos
        switch variable
            case 2 % Capacidad
                set(handles.edit67,'string',10);
                set(handles.edit64,'string',0);
                set(handles.edit66,'string',1);
                set(handles.popupmenu19,'value',8);
    
            case 3 % Profundidad
                set(handles.edit67,'string',10);
                set(handles.edit64,'string',0);
                set(handles.edit66,'string',1);
                set(handles.popupmenu19,'value',3);
                
            case 4 % Velocidad
               tuberias=stormwaterSystem.Conduit;
                velMax=0;
                for i=1:length(tuberias)
                    vel=max(max(tuberias(i).q1(:,2)./tuberias(i).a1(:,2)),max(tuberias(i).q2(:,2)./tuberias(i).a2(:,2)));
                    if vel>velMax
                        velMax=vel;
                    end
                end
                set(handles.edit67,'string',10);
                set(handles.edit64,'string',0);
                set(handles.edit66,'string',round(velMax,2));
                set(handles.popupmenu19,'value',13)
    
            case 5 % Estado
                set(handles.edit64,'string',0);
                set(handles.edit66,'string',1);
                set(handles.popupmenu19,'value',14)
                set(handles.edit67,'string',2);
        end
    case 3 %Node
        switch variable              
            case 2 % Entradas
               nodos=stormwaterSystem.Node;
                inMax=0;
                for i=1:length(nodos)
                    in=max(nodos(i).hidrogramaNeto(:,2));
                    if in>inMax
                        inMax=in;
                    end
                end

                if round(inMax,2)==0
                    inMax=1;
                end
                set(handles.edit67,'string',10);
                set(handles.edit64,'string',0);
                set(handles.edit66,'string',round(inMax,2));
                set(handles.popupmenu19,'value',13)
    
            case 3 % Estado
                set(handles.edit64,'string',0);
                set(handles.edit66,'string',1);
                set(handles.popupmenu19,'value',14)
                set(handles.edit67,'string',2);
        end
    case 4 %Subcuencas
        switch variable
            case 2 %Escorrentia
                set(handles.edit67,'string',10);
                set(handles.edit64,'string',0);
                set(handles.edit66,'string',1);
                set(handles.popupmenu19,'value',8);
        end
end

%inicializar
popupmenu19_Callback(hObject, eventdata, handles)

% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10


%% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //    Update History
% =============================================================
%
function popupmenu19_Callback(hObject, eventdata, handles)
global  modelo idioma

if get(handles.popupmenu9,'value')==1 || get(handles.popupmenu10,'value')==1
    return
end

axes(handles.axes2);
variable=get(handles.popupmenu10,'value');
delete(modelo.escala);

switch get(handles.popupmenu9,'value')
    case 2%Conduit
        switch variable
            case 2 % Capacidad
                [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                if Lmin>0
                    labels{1}=['<=',labels{1}];
                end
                if Lmax<1
                    labels{end}=['>=',labels{end}];
                end
                colormap (cm)
                c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                c.Visible='off';
                c.Ticks=(0:1/intervalos:1);
                c.TickLabels=labels;
                if strcmp(idioma,'english')
                    c.Label.String='Hydraulic capacity (%)';
                else
                   c.Label.String='Capacidad hidráulica (%)';
                end
                
                c.Label.FontName='Open Sans';
                c.Label.FontSize=8;
                c.Label.FontWeight='bold';
                modelo.escala=c;
            case 3 % Profundidad
                [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                if Lmin>0
                    labels{1}=['<=',labels{1}];
                end
                if Lmax<1
                    labels{end}=['>=',labels{end}];
                end
                colormap (cm)
                c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                c.Visible='off';
                c.Ticks=(0:1/intervalos:1);
                c.TickLabels=labels;
                if strcmp(idioma,'english')
                    c.Label.String='Flow depth (%)';
                else
                   c.Label.String='Profundidad de flujo (%)';
                end
                
                c.Label.FontName='Open Sans';
                c.Label.FontSize=8;
                c.Label.FontWeight='bold';
                modelo.escala=c;
            case 4 % Velocidad
                [cm,~,~,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                colormap (cm)
                c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                c.Visible='off';
                c.Ticks=(0:1/intervalos:1);
                c.TickLabels=labels;
                if strcmp(idioma,'english')
                    c.Label.String='Velocity (m/s)';
                else
                   c.Label.String='Velocidad (m/s)';
                end
                
                c.Label.FontName='Open Sans';
                c.Label.FontSize=8;
                c.Label.FontWeight='bold';
                modelo.escala=c;
            case 5 % Estado
                [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                colormap (cm)
                c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                c.Visible='off';
                c.Ticks=[0,1];
                c.TickLabels={'0','1'};
                if strcmp(idioma,'english')
                    c.Label.String='Functional state';
                else
                   c.Label.String='Estado funcional';
                end
                
                c.Label.FontName='Open Sans';
                c.Label.FontSize=8;
                c.Label.FontWeight='bold';
                modelo.escala=c;
        end
    case 3 %Node
        switch variable
            case 2 %Inundacion
                [cm,~,~,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                colormap (cm)
                c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                c.Visible='off';
                c.Ticks=(0:1/intervalos:1);
                c.TickLabels=labels;
                if strcmp(idioma,'english')
                    c.Label.String='Flooding (m3)';
                else
                   c.Label.String='Inundación (m3)';
                end
                
                c.Label.FontName='Open Sans';
                c.Label.FontSize=8;
                c.Label.FontWeight='bold';
                modelo.escala=c;
            case 3 %Estado
                [cm,~,~,~,~]=barraColor(get(handles.popupmenu19,'value'),handles);
                colormap (cm)
                c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                c.Visible='off';
                c.Ticks=[0,1];
                c.TickLabels={'0','1'};
                if strcmp(idioma,'english')
                    c.Label.String='Functional state';
                else
                   c.Label.String='Estado funcional';
                end
                
                c.Label.FontName='Open Sans';
                c.Label.FontSize=8;
                c.Label.FontWeight='bold';
                modelo.escala=c;
        end
    case 4 %Subcuencas
        switch variable
            case 2 %Escorrentia
                [cm,Lmin,Lmax,intervalos,labels]=barraColor(get(handles.popupmenu19,'value'),handles);
                if Lmin>0
                    labels{1}=['<=',labels{1}];
                end
                if Lmax<1
                    labels{end}=['>=',labels{end}];
                end
                colormap (cm)
                c=colorbar(gca,'Location','west','FontName','Open Sans', 'FontSize',8,'FontWeight','bold');
                c.Visible='off';
                c.Ticks=(0:1/intervalos:1);
                c.TickLabels=labels;
                if strcmp(idioma,'english')
                    c.Label.String='Runoff (%)';
                else
                   c.Label.String='EscorrentÃ­a (%)';
                end
                
                c.Label.FontName='Open Sans';
                c.Label.FontSize=8;
                c.Label.FontWeight='bold';
                modelo.escala=c;
        end

end

set(handles.slider19,'value',1)
fotograma(handles,1)
popupmenu22_Callback(hObject, eventdata, handles)
c.Visible='on';
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu19


%% --- Executes during object creation, after setting all properties.
function popupmenu19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //        -Increase/decrease lower limit
% //    Update History
% =============================================================
%
function slider25_Callback(hObject, eventdata, handles)
incremento=get(handles.slider25,'value');
set(handles.slider25, 'Value', 0.5);
valor=str2double(get(handles.edit64,'string'));
valor2=str2double(get(handles.edit66,'string'));
if incremento==1
    valor=valor+0.1;
else
    valor=valor-0.1;
end

if valor<0 ||valor>=valor2
    return
else
    set(handles.edit64,'string',valor)
    edit64_Callback(hObject, eventdata, handles)
end
% hObject    handle to slider25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //        -Increase/decrease lower limit
% //    Update History
% =============================================================
%
function edit64_Callback(hObject, eventdata, handles)
global idioma
    categoria=get(handles.popupmenu9,'value');
    variable=get(handles.popupmenu10,'value');
    if categoria==1 || variable==5
        return
    end
    
    Lmin=round(str2double(get(handles.edit64,'string')),2);
    Lmax=round(str2double(get(handles.edit66,'string')),2);
    if isnan(Lmin) || Lmin<0
        if strcmp(idioma,'english')
            Aviso('Invalid value','Error','error');
        else
           Aviso('Valor inválido','Error','error');
        end
        
        set(handles.edit64,'string',0)
        return
    elseif Lmin>=Lmax
        Aviso('Wrong lower bound','Error','error');
        set(handles.edit64,'string',0)
        return
    elseif Lmin>1
        if variable==4
            set(handles.edit64,'string',Lmin)
        else
            set(handles.edit64,'string',0)
        end
    else
        set(handles.edit64,'string',Lmin)
    end
    
    popupmenu19_Callback(hObject, eventdata, handles)

    set(handles.slider19,'value',1)
    fotograma(handles,1)
% hObject    handle to edit64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit64 as text
%        str2double(get(hObject,'String')) returns contents of edit64 as a double


%% --- Executes during object creation, after setting all properties.
function edit64_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //        -Increase/decrease upper limit
% //    Update History
% =============================================================
%
function edit66_Callback(hObject, eventdata, handles)
global idioma
    categoria=get(handles.popupmenu9,'value');
    variable=get(handles.popupmenu10,'value');
    if categoria==1 || variable==5
        return
    end
    
    Lmin=round(str2double(get(handles.edit64,'string')),2);
    Lmax=round(str2double(get(handles.edit66,'string')),2);
    if isnan(Lmax) || Lmax<=0
        if strcmp(idioma,'english')
            Aviso('Invalid value','Error','error');
        else
           Aviso('Valor inválido','Error','error');
        end
        set(handles.edit66,'string',1)
        return
    elseif Lmin>=Lmax
        if strcmp(idioma,'english')
            Aviso('Wrong upper limit','Error','error');
        else
           Aviso('LÃ­mite superior incorrecto','Error','error');
        end
        
        set(handles.edit66,'string',1)
        return
    elseif variable~=4 && Lmax>1
        set(handles.edit66,'string',1)
    else
        set(handles.edit66,'string',Lmax)
    end
    
    %inicializar
    popupmenu19_Callback(hObject, eventdata, handles)
    set(handles.slider19,'value',1)
    fotograma(handles,1)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit66 as text
%        str2double(get(hObject,'String')) returns contents of edit66 as a double


%% --- Executes during object creation, after setting all properties.
function edit66_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //        -Increase/decrease upper limit
% //    Update History
% =============================================================
%
function slider27_Callback(hObject, eventdata, handles)
incremento=get(handles.slider27,'value');
set(handles.slider27, 'Value', 0.5);
valor2=str2double(get(handles.edit64,'string'));
valor=str2double(get(handles.edit66,'string'));
if incremento==1
    valor=valor+0.1;
else
    valor=valor-0.1;
end

if valor<=valor2 
    return
else
    set(handles.edit66,'string',valor)
    edit66_Callback(hObject, eventdata, handles)
end
% hObject    handle to slider27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //        -Define number of colors
% //    Update History
% =============================================================
%
function edit67_Callback(hObject, eventdata, handles)
global idioma
    categoria=get(handles.popupmenu9,'value');
    variable=get(handles.popupmenu10,'value');
    if categoria==1 || variable==5
        return
    end
    
    intervalo=round(str2double(get(handles.edit67,'string')));
    if isnan(intervalo) || intervalo<=0
       if strcmp(idioma,'english')
            Aviso('Invalid value','Error','error');
        else
           Aviso('Valor inválido','Error','error');
        end
        set(handles.edit67,'string',10)
        return
    elseif intervalo>50
        set(handles.edit67,'string',50)
    else
        set(handles.edit67,'string',intervalo)
    end
    
    popupmenu19_Callback(hObject, eventdata, handles)

% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit67 as text
%        str2double(get(hObject,'String')) returns contents of edit67 as a double


%% --- Executes during object creation, after setting all properties.
function edit67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //        -Define number of colors
% //    Update History
% =============================================================
%
function slider28_Callback(hObject, eventdata, handles)
incremento=get(handles.slider28,'value');
set(handles.slider28, 'Value', 0.5);
valor=str2double(get(handles.edit67,'string'));
if incremento==1
    valor=valor+1;
else
    valor=valor-1;
end

if valor<=1 ||valor>=51
    return
else
    set(handles.edit67,'string',valor)
    edit67_Callback(hObject, eventdata, handles)
end
% hObject    handle to slider28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Result visualization
% //    Description:
% //        -Select category of result to view (plan view)
% //    Update History
% =============================================================
%
function popupmenu20_Callback(hObject, eventdata, handles)
switch get(handles.popupmenu20,'value')
    case 2
        set(handles.popupmenu9,'enable','on')
    case 3
        set(handles.popupmenu9,'enable','on')
    otherwise
        set(handles.popupmenu9,'enable','off')
        set(handles.popupmenu9,'value',1);
        set(handles.popupmenu10,'value',1);
        popupmenu9_Callback(hObject, eventdata, handles)
        set(handles.popupmenu10,'enable','off')
end
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu20 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu20


%% --- Executes during object creation, after setting all properties.
function popupmenu20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //        -Define size of labels
% //    Update History
% =============================================================
%
function popupmenu21_Callback(hObject, eventdata, handles)
global modelo
if isempty(modelo.escala)
    return
end
switch get(handles.popupmenu22,'value')
   case 1
        switch get(handles.popupmenu21,'value')
            case 1
                modelo.escala.Position=[0.98,0.01,0.011,0.95];
            case 2
                modelo.escala.Position=[0.98,0.01,0.011,0.75];
            case 3
                modelo.escala.Position=[0.98,0.01,0.011,0.5];
        end
   case 2
        switch get(handles.popupmenu21,'value')
            case 1
                modelo.escala.Position=[0.01,0.01,0.011,0.95];
            case 2
                modelo.escala.Position=[0.01,0.01,0.011,0.75];
            case 3
                modelo.escala.Position=[0.01,0.01,0.011,0.5];
        end
    case 3
        switch get(handles.popupmenu21,'value')
            case 1
                modelo.escala.Position=[0.02,0.97,0.95,0.02];
            case 2
                modelo.escala.Position=[0.02,0.97,0.75,0.02];
            case 3
                modelo.escala.Position=[0.02,0.97,0.5,0.02];
        end
    case 4
        switch get(handles.popupmenu21,'value')
            case 1
                modelo.escala.Position=[0.02,0.01,0.95,0.02];
            case 2
                modelo.escala.Position=[0.02,0.01,0.75,0.02];
            case 3
                modelo.escala.Position=[0.02,0.01,0.5,0.02];
        end
end
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu21


%% --- Executes during object creation, after setting all properties.
function popupmenu21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Configure color bar (plan view)
% //        -Define location of color bar
% //    Update History
% =============================================================
%
function popupmenu22_Callback(hObject, eventdata, handles)
global modelo
if isempty(modelo.escala)
    return
end
switch get(handles.popupmenu22,'value')
    case 1
        modelo.escala.Location='east';
    case 2
        modelo.escala.Location='west';
    case 3
        modelo.escala.Location='north';
    case 4
        modelo.escala.Location='south';
end
popupmenu21_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu22 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu22


%% --- Executes during object creation, after setting all properties.
function popupmenu22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Define the initial conduit of the profile (profile view)
% //    Update History
% =============================================================
%
function popupmenu29_Callback(hObject, eventdata, handles)
global ProyectoHidrologico
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
    rutas=stormwaterSystem.rutasTuberia;
    TubI=get(handles.popupmenu29,'value');
    for i=1:size(rutas,1)
        a=find(TubI==rutas(i,:));
        if ~isempty(a)
            ruta=(rutas(i,a(1):end));
            ruta(ruta==0)=[];
            break
        end
    end
    Tor=cell(1,length(ruta));
    for i=1:length(ruta)
        Tor{i}=['T-',num2str(ruta(i))];
    end

    set(handles.popupmenu30,'string',Tor);
    set(handles.popupmenu30,'value',1);
    set(handles.popupmenu30,'Enable','on');

    axes(handles.axes5);
    ax = gca;
    ax.Toolbar.Visible = 'off';
    zoom off
    cla
    axes(handles.axes6);
    ax = gca;
    ax.Toolbar.Visible = 'off';
    zoom off
    cla
    set(handles.axes5,'visible','off')
    set(handles.axes6,'visible','off')
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu29 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu29


%% --- Executes during object creation, after setting all properties.
function popupmenu29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Plot de profile selected (profile view)
% //    Update History
% =============================================================
%
function pushbutton151_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
axes(handles.axes5);
ax = gca;
ax.Toolbar.Visible = 'off';
zoom off
cla
axes(handles.axes6);
ax = gca;
ax.Toolbar.Visible = 'off';
zoom off
cla
set(handles.axes5,'visible','off')
set(handles.axes6,'visible','off')

if strcmp(get(handles.popupmenu30,'Enable'),'off')
    Aviso('Select initial and final condui','Error','error');
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
rutas=stormwaterSystem.rutasTuberia;
a=get(handles.popupmenu29,'value');
textT=get(handles.popupmenu30,'string');
tubF=textT{get(handles.popupmenu30,'value')};
B=split(tubF,'-');
b=str2double(B(end));

perfil={};
for i=1:size(rutas,1)
   inicio=find(a==rutas(i,:));
   if ~isempty(inicio)
       fin=find(b==rutas(i,:));
       if~isempty(fin)
           perfil{1}=rutas(i,inicio:fin);
           break
       else
           continue;
       end
   else
       continue;
   end

end
if isempty(perfil)
    if strcmp(idioma,'english')
        Aviso('Profile not found','Error','error');
    else
       Aviso('Perfil no encontrado','Error','error');
    end
    return
end

nodosDibujados=[[Conduit(perfil{1}).nodoF],[Conduit(perfil{1}).nodoI]];
nodosDibujados=unique(nodosDibujados);
nd=Node(nodosDibujados);
emin=round(min([nd.elevacionR])-1.5,1);
set(handles.edit92,'string',emin)
emax=round(max([nd.elevacionT])+0.5,1);
set(handles.edit86,'string',emax)


axes(handles.axes6);
Xmin=min([Node.corX])-10;
Xmax=max([Node.corX])+10;
Ymin=min([Node.corY])-10;
Ymax=max([Node.corY])+10;
axis([Ymin Ymax Xmin Xmax])
xlim auto
ylim auto
axis equal
hold on
for i=1:length(Conduit)
    plotTuberiaRef(Conduit(i));
end
Tuberias2=stormwaterSystem.Conduit(perfil{1});
for i=1:length(Tuberias2)
    plotTuberiaAct(Tuberias2(i));
end
% set(handles.axes6,'visible','on');

axes(handles.axes5);
colores=zeros(6,3);
colores(1,:)=get(handles.pushbutton176,'BackgroundColor');
colores(2,:)=get(handles.pushbutton177,'BackgroundColor');
colores(3,:)=get(handles.pushbutton180,'BackgroundColor');
colores(4,:)=get(handles.pushbutton181,'BackgroundColor');
colores(5,:)=get(handles.pushbutton182,'BackgroundColor');
colores(6,:)=get(handles.pushbutton183,'BackgroundColor');
linea=cell(4,1);
switch get(handles.popupmenu36,'value')
    case 1
        linea{1}='-';
    case 2
        linea{1}='--';
    case 3
        linea{1}=':';
    case 4
        linea{1}='-.';
end
switch get(handles.popupmenu37,'value')
    case 1
        linea{2}='-';
    case 2
        linea{2}='--';
    case 3
        linea{2}=':';
    case 4
        linea{2}='-.';
end
switch get(handles.popupmenu40,'value')
    case 1
        linea{3}='-';
    case 2
        linea{3}='--';
    case 3
        linea{3}=':';
    case 4
        linea{3}='-.';
end
switch get(handles.popupmenu41,'value')
    case 1
        linea{4}='-';
    case 2
        linea{4}='--';
    case 3
        linea{4}=':';
    case 4
        linea{4}='-.';
end
grosor=zeros(4,1);
grosor(1)=round(str2double(get(handles.edit84,'string')),1);
grosor(2)=round(str2double(get(handles.edit85,'string')),1);
grosor(3)=round(str2double(get(handles.edit90,'string')),1);
grosor(4)=round(str2double(get(handles.edit91,'string')),1);

infoNodo=zeros(4,1);
infoNodo(1)=1;
infoNodo(2)=get(handles.checkbox18,'value');
infoNodo(3)=get(handles.checkbox19,'value');
infoNodo(4)=get(handles.checkbox20,'value');

infoTuberia=zeros(4,1);
infoTuberia(1)=1;
infoTuberia(2)=get(handles.checkbox26,'value');
infoTuberia(3)=get(handles.checkbox27,'value');
infoTuberia(4)=get(handles.checkbox28,'value');

ubicacion=zeros(2,1);
ubicacion(1)=round(str2double(get(handles.edit86,'string')),1);
ubicacion(2)=round(str2double(get(handles.edit92,'string')),1);

[modelo.graficoRelleno1Pr,modelo.graficoRelleno2Pr,modelo.graficoReferenciaPr,modelo.graficoTuberiaRPr,...
    modelo.graficoTirantePr,modelo.graficoTerrenoPr,modelo.graficoRasantePr,modelo.graficoCoronaPr,modelo.graficoPozoRPr,...
    modelo.graficoPozoPr,modelo.labelPozoPr,modelo.labelTuberiaPr]...
    =plotPerfilRevision(stormwaterSystem,stormwaterSystem.Conduit(perfil{1}),1,colores,linea,grosor,infoNodo,infoTuberia,ubicacion);

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');

set(handles.slider31, 'Min', 1);
set(handles.slider31, 'Max', length(Simulation.tiempoTransito));
set(handles.slider31, 'Value', 1);
set(handles.slider31, 'SliderStep',[1/(length(Simulation.tiempoTransito)-1), 1/(length(Simulation.tiempoTransito)-1)]);

% set(handles.axes5,'visible','on')


%% Result visualization
% //    Description:
% //        -Plot temporal flow depth (profile view)
% //    Update History
% =============================================================
%
function fotograma2(handles,k)
global modelo ProyectoHidrologico idioma
if strcmp(get(handles.popupmenu30,'Enable'),'off')
    if strcmp(idioma,'english')
        Aviso('Select initial and final conduit','Error','error');
    else
       Aviso('Seleccionar conducto incial y final','Error','error');
    end
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
rutas=stormwaterSystem.rutasTuberia;
a=get(handles.popupmenu29,'value');
textT=get(handles.popupmenu30,'string');
tubF=textT{get(handles.popupmenu30,'value')};
B=split(tubF,'-');
b=str2double(B(end));

perfil={};
for i=1:size(rutas,1)
   inicio=find(a==rutas(i,:));
   if ~isempty(inicio)
       fin=find(b==rutas(i,:));
       if~isempty(fin)
           perfil{1}=rutas(i,inicio:fin);
           break
       else
           continue;
       end
   else
       continue;
   end

end
if isempty(perfil)
    if strcmp(idioma,'english')
        Aviso('Profile not found','Error','error');
    else
       Aviso('Perfil no encontrado','Error','error');
    end
    return
end

tuberias=stormwaterSystem.Conduit(perfil{1});
for i=1:length(perfil{1})
    tirante=[tuberias(i).ERNi+tuberias(i).y1(k,2),tuberias(i).ERNf+tuberias(i).y2(k,2)];
    modelo.graficoTirantePr(i).Vertices(1:2,2)=tirante;
    if get(handles.checkbox26,'value')==1
        Q=['Q = ',num2str(mean([tuberias(i).q1(k,2);tuberias(i).q2(k,2)]),'%0.2f'),' m3'];
        Datos=get(modelo.labelTuberiaPr(i),'String');
        Datos{2}=Q;
        set(modelo.labelTuberiaPr(i),'String',Datos);
    end
end
set(handles.text167,'string',['min: ',num2str(Simulation.tiempoTransito(k)/60)])
% hObject    handle to pushbutton151 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Define the initial conduit of the profile (profile view)
% //    Update History
% =============================================================
%
function popupmenu30_Callback(hObject, eventdata, handles)
axes(handles.axes5);
ax = gca;
ax.Toolbar.Visible = 'off';
zoom off
cla
axes(handles.axes6);
ax = gca;
ax.Toolbar.Visible = 'off';
zoom off
cla
set(handles.axes5,'visible','off')
set(handles.axes6,'visible','off')
% hObject    handle to popupmenu30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu30 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu30


%% --- Executes during object creation, after setting all properties.
function popupmenu30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ------------------------------------------------------------------------
function edit76_Callback(hObject, eventdata, handles)
% hObject    handle to edit76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit76 as text
%        str2double(get(hObject,'String')) returns contents of edit76 as a double


%% --- Executes during object creation, after setting all properties.
function edit76_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Define speed animation (profile view)
% //    Update History
% =============================================================
%
function edit75_Callback(hObject, eventdata, handles)
global ProyectoHidrologico
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
velocidad=1/round(str2double(get(handles.edit75,'string')));
tiempoAnimacion=length(Simulation.tiempoTransito)*velocidad;
set(handles.edit76,'string',round(tiempoAnimacion))
% hObject    handle to edit75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit75 as text
%        str2double(get(hObject,'String')) returns contents of edit75 as a double


%% --- Executes during object creation, after setting all properties.
function edit75_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Final flow depth result (profile view)
% //    Update History
% =============================================================
%
function pushbutton159_Callback(hObject, eventdata, handles)
i=get(handles.slider31, 'Max');
set(handles.slider31, 'Value', i);
fotograma2(handles,round(get(handles.slider31,'Value')))
% hObject    handle to pushbutton159 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Next temporal flow depth (profile view)
% //    Update History
% =============================================================
%
function pushbutton158_Callback(hObject, eventdata, handles)
i=get(handles.slider31, 'Value');
if i==get(handles.slider31, 'Max')
    return;
end
set(handles.slider31, 'Value', i+1);
fotograma2(handles,round(get(handles.slider31, 'Value')))
% hObject    handle to pushbutton158 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Stop animation flow depth evolution (profile view)
% //    Update History
% =============================================================
%
function pushbutton157_Callback(hObject, eventdata, handles)
global modelo
modelo.bandera=1;
% hObject    handle to pushbutton157 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Play animation flow depth evolution (profile view)
% //    Update History
% =============================================================
%
function pushbutton156_Callback(hObject, eventdata, handles)
global  ProyectoHidrologico modelo idioma

axes(handles.axes5);
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
velocidad=1/round(str2double(get(handles.edit75,'string')));

modelo.bandera=0;

rutas=stormwaterSystem.rutasTuberia;
a=get(handles.popupmenu29,'value');
textT=get(handles.popupmenu30,'string');
tubF=textT{get(handles.popupmenu30,'value')};
B=split(tubF,'-');
b=str2double(B(end));

perfil={};
for i=1:size(rutas,1)
   inicio=find(a==rutas(i,:));
   if ~isempty(inicio)
       fin=find(b==rutas(i,:));
       if~isempty(fin)
           perfil{1}=rutas(i,inicio:fin);
           break
       else
           continue;
       end
   else
       continue;
   end

end
if isempty(perfil)
    if strcmp(idioma,'english')
        Aviso('Profile not found','Error','error');
    else
       Aviso('Perfil no encontrado','Error','error');
    end
    return
end

tuberias=stormwaterSystem.Conduit(perfil{1});
for k=round(get(handles.slider31,'Value')):length(Simulation.tiempoTransito)
    for i=1:length(perfil{1})
        tirante=[tuberias(i).ERNi+tuberias(i).y1(k,2),tuberias(i).ERNf+tuberias(i).y2(k,2)];
        if get(handles.checkbox26,'value')==1
            Q=['Q = ',num2str(mean([tuberias(i).q1(k,2);tuberias(i).q2(k,2)]),'%0.2f'),' m3'];
            Datos=get(modelo.labelTuberiaPr(i),'String');
            Datos{2}=Q;
            set(modelo.labelTuberiaPr(i),'String',Datos);
        end
        modelo.graficoTirantePr(i).Vertices(1:2,2)=tirante;
    end
    set(handles.text167,'string',['min: ',num2str(Simulation.tiempoTransito(k)/60)])
    set(handles.slider31, 'Value', k);
    pause (velocidad)
    if modelo.bandera~=0
        break
    end
end

% hObject    handle to pushbutton156 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Previous temporal flow depth (profile view)
% //    Update History
% =============================================================
%  
function pushbutton155_Callback(hObject, eventdata, handles)
i=get(handles.slider31, 'Value');
if i==get(handles.slider31, 'Min')
    return;
end
set(handles.slider31, 'Value', i-1);
fotograma2(handles,round(get(handles.slider31, 'Value')))
% hObject    handle to pushbutton155 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -First flow depth result (profile view)
% //    Update History
% =============================================================
%
function pushbutton154_Callback(hObject, eventdata, handles)
i=get(handles.slider31, 'Min');
set(handles.slider31, 'Value', i);
fotograma2(handles,round(get(handles.slider31,'Value')))
% hObject    handle to pushbutton154 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -View temporal flow depth result (profile view)
% //    Update History
% =============================================================
%
function slider31_Callback(hObject, eventdata, handles)
fotograma2(handles,round(get(handles.slider31, 'Value')))
% hObject    handle to slider31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Result visualization
% //    Description:
% //        -Save flow depth evolution result to video (profile view)
% //    Update History
% =============================================================
%
function pushbutton153_Callback(hObject, eventdata, handles)
global  ProyectoHidrologico modelo idioma

 nombre=get(handles.edit74,'string');
if isempty(nombre)
    if strcmp(idioma,'english')
        Aviso('Enter video name','Error','error');
    else
       Aviso('Ingresar nombre de video','Error','error');
    end
    return
end

axes(handles.axes5);
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Simulation.mat'),'Simulation');
velocidad=1/round(str2double(get(handles.edit75,'string')));

jFrame = get(handle(gcf),'JavaFrame');
jRootPane = jFrame.fHG2Client.getWindow;
statusbarObj = com.mathworks.mwswing.MJStatusBar;
jProgressBar = javax.swing.JProgressBar;
numIds = 10;
set(jProgressBar, 'Minimum',0, 'Maximum',numIds, 'Value',0);
jRootPane.setStatusBarVisible(1);

statusbarObj.add(jProgressBar,'West');
set(jProgressBar,'Value',1);
if strcmp(idioma,'english')
    msg = 'Configurate file... (10%)';
else
   msg = 'Configurando archivo... (10%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

ax=gca;
ax.Units = 'pixels';
pos = ax.Position;
ti = ax.TightInset;
rect = [-5,-15, pos(3)+10, pos(4)+15];
Fotos=[];
modelo.bandera=0;

set(jProgressBar,'Value',5);
if strcmp(idioma,'english')
    msg = 'Generate frames... (50%)';
else
   msg = 'Generando frames... (50%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

rutas=stormwaterSystem.rutasTuberia;
a=get(handles.popupmenu29,'value');
textT=get(handles.popupmenu30,'string');
tubF=textT{get(handles.popupmenu30,'value')};
B=split(tubF,'-');
b=str2double(B(end));

perfil={};
for i=1:size(rutas,1)
   inicio=find(a==rutas(i,:));
   if ~isempty(inicio)
       fin=find(b==rutas(i,:));
       if~isempty(fin)
           perfil{1}=rutas(i,inicio:fin);
           break
       else
           continue;
       end
   else
       continue;
   end

end
if isempty(perfil)
    if strcmp(idioma,'english')
       Aviso('Profile not found','Error','error');
    else
       Aviso('Perfil no encontrado','Error','error');
    end
    return
end

tuberias=stormwaterSystem.Conduit(perfil{1});
for k=round(get(handles.slider31,'Value')):length(Simulation.tiempoTransito)
    for i=1:length(perfil{1})
        tirante=[tuberias(i).ERNi+tuberias(i).y1(k,2),tuberias(i).ERNf+tuberias(i).y2(k,2)];
        modelo.graficoTirantePr(i).Vertices(1:2,2)=tirante;
    end
    set(handles.text167,'string',['min: ',num2str(Simulation.tiempoTransito(k)/60)])
    set(handles.slider31, 'Value', k);
    Fotos=[Fotos,getframe(ax,rect)];
    if modelo.bandera~=0
        break
    end
end


set(jProgressBar,'Value',5);
if strcmp(idioma,'english')
   msg = 'Save video... (90%)';
else
   msg = 'Guardando video... (90%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

if isempty(Fotos)
    pause(0.5)
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
       Aviso('Incomplete operation','Error','error');
    else
       Aviso('Operación incompleta','Error','error');
    end
    return
end
 v = VideoWriter(fullfile(ProyectoHidrologico.carpetaBase,'Data',[nombre,'.avi']));
 v.Quality = 100;
 v.FrameRate = 1/velocidad;  
open(v)
writeVideo(v,Fotos)
close(v)

set(jProgressBar,'Value',10);
if strcmp(idioma,'english')
   msg = 'Completed... (100%)';
else
   msg = 'Finalizando... (100%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);
pause(0.5)
jRootPane.setStatusBarVisible(0);
% hObject    handle to pushbutton153 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ------------------------------------------------------------------------
function edit74_Callback(hObject, eventdata, handles)
% hObject    handle to edit74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit74 as text
%        str2double(get(hObject,'String')) returns contents of edit74 as a double


%% --- Executes during object creation, after setting all properties.
function edit74_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Plot current flow depth result on external figure (profile view)
% //    Update History
% =============================================================
%
function pushbutton152_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma

if strcmp(get(handles.popupmenu30,'Enable'),'off')
    if strcmp(idioma,'english')
       Aviso('Select initial and final conduit','Error','error');
    else
       Aviso('Seleccionar tuberÃ­a inicial y final','Error','error');
    end
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
axes(handles.axes5);
xl = xlim;
yl = ylim;
f=figure;
f.Color=[1,1,1];
xlim(xl)
ylim(yl)
ax = gca;
ax.XColor=[1,1,1];
ax.YColor=[1,1,1];
hold on

posicion1=get(handles.moduloHidrologico,'Position');
posicion2=f.Position;
pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.75;
pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.35;
posicion=[pos1,pos2,posicion2(3:4)];
f.Position=posicion;

rutas=stormwaterSystem.rutasTuberia;
a=get(handles.popupmenu29,'value');
textT=get(handles.popupmenu30,'string');
tubF=textT{get(handles.popupmenu30,'value')};
B=split(tubF,'-');
b=str2double(B(end));

perfil={};
for i=1:size(rutas,1)
   inicio=find(a==rutas(i,:));
   if ~isempty(inicio)
       fin=find(b==rutas(i,:));
       if~isempty(fin)
           perfil{1}=rutas(i,inicio:fin);
           break
       else
           continue;
       end
   else
       continue;
   end

end
if isempty(perfil)
    if strcmp(idioma,'english')
       Aviso('Profile not found','Error','error');
    else
       Aviso('Perfil no encontrado','Error','error');
    end
    return
end

nodosDibujados=[[Conduit(perfil{1}).nodoF],[Conduit(perfil{1}).nodoI]];
nodosDibujados=unique(nodosDibujados);
nd=Node(nodosDibujados);
emin=round(min([nd.elevacionR])-1.5,1);
set(handles.edit92,'string',emin)
emax=round(max([nd.elevacionT])+0.5,1);
set(handles.edit86,'string',emax)

colores=zeros(6,3);
colores(1,:)=get(handles.pushbutton176,'BackgroundColor');
colores(2,:)=get(handles.pushbutton177,'BackgroundColor');
colores(3,:)=get(handles.pushbutton180,'BackgroundColor');
colores(4,:)=get(handles.pushbutton181,'BackgroundColor');
colores(5,:)=get(handles.pushbutton182,'BackgroundColor');
colores(6,:)=get(handles.pushbutton183,'BackgroundColor');
linea=cell(4,1);
switch get(handles.popupmenu36,'value')
    case 1
        linea{1}='-';
    case 2
        linea{1}='--';
    case 3
        linea{1}=':';
    case 4
        linea{1}='-.';
end
switch get(handles.popupmenu37,'value')
    case 1
        linea{2}='-';
    case 2
        linea{2}='--';
    case 3
        linea{2}=':';
    case 4
        linea{2}='-.';
end
switch get(handles.popupmenu40,'value')
    case 1
        linea{3}='-';
    case 2
        linea{3}='--';
    case 3
        linea{3}=':';
    case 4
        linea{3}='-.';
end
switch get(handles.popupmenu41,'value')
    case 1
        linea{4}='-';
    case 2
        linea{4}='--';
    case 3
        linea{4}=':';
    case 4
        linea{4}='-.';
end
grosor=zeros(4,1);
grosor(1)=round(str2double(get(handles.edit84,'string')),1);
grosor(2)=round(str2double(get(handles.edit85,'string')),1);
grosor(3)=round(str2double(get(handles.edit90,'string')),1);
grosor(4)=round(str2double(get(handles.edit91,'string')),1);

infoNodo=zeros(4,1);
infoNodo(1)=1;
infoNodo(2)=get(handles.checkbox18,'value');
infoNodo(3)=get(handles.checkbox19,'value');
infoNodo(4)=get(handles.checkbox20,'value');

infoTuberia=zeros(4,1);
infoTuberia(1)=1;
infoTuberia(2)=get(handles.checkbox26,'value');
infoTuberia(3)=get(handles.checkbox27,'value');
infoTuberia(4)=get(handles.checkbox28,'value');

ubicacion=zeros(2,1);
ubicacion(1)=round(str2double(get(handles.edit86,'string')),1);
ubicacion(2)=round(str2double(get(handles.edit92,'string')),1);

[~,~,~,~,~,~,~,~,~,~,~,~]...
    =plotPerfilRevision(stormwaterSystem,stormwaterSystem.Conduit(perfil{1}),round(get(handles.slider31,'Value')),colores,linea,grosor,infoNodo,infoTuberia,ubicacion);

% hObject    handle to pushbutton152 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in checkbox25.
function checkbox25_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox25


%% Result visualization
% //    Description:
% //        -On/off flow depth labels (profile view)
% //    Update History
% =============================================================
%
function checkbox26_Callback(hObject, eventdata, handles)
actualizarLabelTuberiaPr(handles)
% hObject    handle to checkbox26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox26


%% Result visualization
% //    Description:
% //        -On/off length labels (profile view)
% //    Update History
% =============================================================
%
function checkbox27_Callback(hObject, eventdata, handles)
actualizarLabelTuberiaPr(handles)
% hObject    handle to checkbox27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox27


%% Result visualization
% //    Description:
% //        -On/off slope labels (profile view)
% //    Update History
% =============================================================
%
function checkbox28_Callback(hObject, eventdata, handles)
actualizarLabelTuberiaPr(handles)
% hObject    handle to checkbox28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox28


%% Result visualization
% //    Description:
% //        -Update label information for flow depth evolution (profile view)
% //    Update History
% =============================================================
%
function actualizarLabelTuberiaPr(handles)
global ProyectoHidrologico modelo idioma
infoTuberia=zeros(4,1);
infoTuberia(1)=1;
infoTuberia(2)=get(handles.checkbox26,'value');
infoTuberia(3)=get(handles.checkbox27,'value');
infoTuberia(4)=get(handles.checkbox28,'value');

ubicacion=round(str2double(get(handles.edit92,'string')),1);

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
rutas=stormwaterSystem.rutasTuberia;
a=get(handles.popupmenu29,'value');
textT=get(handles.popupmenu30,'string');
tubF=textT{get(handles.popupmenu30,'value')};
B=split(tubF,'-');
b=str2double(B(end));

perfil={};
for i=1:size(rutas,1)
   inicio=find(a==rutas(i,:));
   if ~isempty(inicio)
       fin=find(b==rutas(i,:));
       if~isempty(fin)
           perfil{1}=rutas(i,inicio:fin);
           break
       else
           continue;
       end
   else
       continue;
   end

end
if isempty(perfil)
    if strcmp(idioma,'english')
       Aviso('Profile not found','Error','error');
    else
       Aviso('Perfil no encontrado','Error','error');
    end
    return
end

tuberias=stormwaterSystem.Conduit(perfil{1});
k=round(get(handles.slider31, 'Value'));

for i=1:length(tuberias)
    if strcmp(idioma,'english')
       infoTuberiaCom={['Conduit - ',num2str(tuberias(i).ID,'%0.0f')],['Q = ',num2str(mean([tuberias(i).q1(k,2);tuberias(i).q2(k,2)]),'%0.2f'),' m3'],['L = ',num2str(tuberias(i).longitud,'%0.2f'),' m'],['S = ',num2str(tuberias(i).Sp*100,2),'%']};
    else
       infoTuberiaCom={['Tubería - ',num2str(tuberias(i).ID,'%0.0f')],['Q = ',num2str(mean([tuberias(i).q1(k,2);tuberias(i).q2(k,2)]),'%0.2f'),' m3'],['L = ',num2str(tuberias(i).longitud,'%0.2f'),' m'],['S = ',num2str(tuberias(i).Sp*100,2),'%']};
    end
    
    infoTuberiaF=infoTuberiaCom(logical(infoTuberia));
    set(modelo.labelTuberiaPr(i),'String',infoTuberiaF)
end

%% Result visualization
% //    Description:
% //        -Set line weight for conduit plot (profile view)
% //    Update History
% =============================================================
%
function edit90_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoCoronaPr)
    return
end
grosor=round(str2double(get(handles.edit90,'string')),1);
if isempty(grosor)||isnan(grosor)||grosor<=0
    return
end
set(modelo.graficoCoronaPr,'LineWidth',grosor);
set(modelo.graficoRasantePr,'LineWidth',grosor);
% hObject    handle to edit90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit90 as text
%        str2double(get(hObject,'String')) returns contents of edit90 as a double


%% --- Executes during object creation, after setting all properties.
function edit90_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set line weight for counduit plot (profile view)
% //    Update History
% =============================================================
%
function slider41_Callback(hObject, eventdata, handles)
incremento=get(handles.slider41,'value');
set(handles.slider41, 'Value', 0.5);
valor=str2double(get(handles.edit90,'string'));
if incremento==1
    valor=valor+0.5;
else
    valor=valor-0.5;
end

if valor<=0
    return
else
    set(handles.edit90,'string',valor)
    edit90_Callback(hObject, eventdata, handles)
end
% hObject    handle to slider41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Result visualization
% //    Description:
% //        -Set line color for counduit plot (profile view)
% //    Update History
% =============================================================
%
function pushbutton180_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoCoronaPr)
    return
end
color = uisetcolor(get(handles.pushbutton180,'BackgroundColor'));
if color == get(handles.pushbutton180,'BackgroundColor')
    return
else
     set(handles.pushbutton180,'BackgroundColor',color)
     set(modelo.graficoCoronaPr,'Color',color)
     set(modelo.graficoRasantePr,'Color',color)
end
% hObject    handle to pushbutton180 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Set line type for counduit plot (profile view)
% //    Update History
% =============================================================
%
function popupmenu40_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoCoronaPr)
    return
end

switch get(handles.popupmenu40,'value')
    case 1
        set(modelo.graficoCoronaPr,'LineStyle','-');
        set(modelo.graficoRasantePr,'LineStyle','-');
    case 2
        set(modelo.graficoCoronaPr,'LineStyle','--');
        set(modelo.graficoRasantePr,'LineStyle','--');
    case 3
        set(modelo.graficoCoronaPr,'LineStyle',':');
        set(modelo.graficoRasantePr,'LineStyle',':');
    case 4
        set(modelo.graficoCoronaPr,'LineStyle','-.');
        set(modelo.graficoRasantePr,'LineStyle','-.');
end
% hObject    handle to popupmenu40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu40 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu40


%% --- Executes during object creation, after setting all properties.
function popupmenu40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set line type for ground plot (profile view)
% //    Update History
% =============================================================
%
function popupmenu41_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoTerrenoPr)
    return
end

switch get(handles.popupmenu41,'value')
    case 1
        set(modelo.graficoTerrenoPr,'LineStyle','-');
    case 2
        set(modelo.graficoTerrenoPr,'LineStyle','--');
    case 3
        set(modelo.graficoTerrenoPr,'LineStyle',':');
    case 4
        set(modelo.graficoTerrenoPr,'LineStyle','-.');
end
% hObject    handle to popupmenu41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu41 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu41


%% --- Executes during object creation, after setting all properties.
function popupmenu41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set line weight for ground plot (profile view)
% //    Update History
% =============================================================
%
function edit91_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoTerrenoPr)
    return
end
grosor=round(str2double(get(handles.edit91,'string')),1);
if isempty(grosor)||isnan(grosor)||grosor<=0
    return
end
set(modelo.graficoTerrenoPr,'LineWidth',grosor);
% hObject    handle to edit91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit91 as text
%        str2double(get(hObject,'String')) returns contents of edit91 as a double


%% --- Executes during object creation, after setting all properties.
function edit91_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set line weight for ground plot (profile view)
% //    Update History
% =============================================================
%
function slider42_Callback(hObject, eventdata, handles)
incremento=get(handles.slider42,'value');
set(handles.slider42, 'Value', 0.5);
valor=str2double(get(handles.edit91,'string'));
if incremento==1
    valor=valor+0.5;
else
    valor=valor-0.5;
end

if valor<=0
    return
else
    set(handles.edit91,'string',valor)
    edit91_Callback(hObject, eventdata, handles)
end
% hObject    handle to slider42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Result visualization
% //    Description:
% //        -Set line color for ground plot (profile view)
% //    Update History
% =============================================================
%
function pushbutton181_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoRelleno1Pr)
    return
end
color = uisetcolor(get(handles.pushbutton181,'BackgroundColor'));
if color == get(handles.pushbutton181,'BackgroundColor')
    return
else
     set(handles.pushbutton181,'BackgroundColor',color)
     set(modelo.graficoTerrenoPr,'Color',color)
end
% hObject    handle to pushbutton181 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Set location for conduit labels (profile view)
% //    Update History
% =============================================================
%
function edit92_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.labelTuberiaPr)
    return
end
ubicacion=round(str2double(get(handles.edit92,'string')),1);
if isempty(ubicacion)||isnan(ubicacion)
    return
end
for i=1:length(modelo.labelTuberiaPr)
    posicion=modelo.labelTuberiaPr(i).Position;
    posicion(2)=ubicacion;
    modelo.labelTuberiaPr(i).Position=posicion;
end

% hObject    handle to edit92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit92 as text
%        str2double(get(hObject,'String')) returns contents of edit92 as a double


%% --- Executes during object creation, after setting all properties.
function edit92_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set location for labels (profile view)
% //    Update History
% =============================================================
%
function slider43_Callback(hObject, eventdata, handles)
incremento=get(handles.slider43,'value');
set(handles.slider43, 'Value', 0.5);
valor=str2double(get(handles.edit92,'string'));
if incremento==1
    valor=valor+0.1;
else
    valor=valor-0.1;
end
set(handles.edit92,'string',valor)
edit92_Callback(hObject, eventdata, handles)
% hObject    handle to slider43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


%% Result visualization
% //    Description:
% //        -On/off node ground elevation labels (profile view)
% //    Update History
% =============================================================
%
function checkbox18_Callback(hObject, eventdata, handles)
actualizarLabelNodoPr(handles)
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18


%% Result visualization
% //    Description:
% //        -Update label node information for flow depth evolution (profile view)
% //    Update History
% =============================================================
%
function actualizarLabelNodoPr(handles)
global ProyectoHidrologico modelo idioma
infoNodo=zeros(4,1);
infoNodo(1)=1;
infoNodo(2)=get(handles.checkbox18,'value');
infoNodo(3)=get(handles.checkbox19,'value');
infoNodo(4)=get(handles.checkbox20,'value');

ubicacion=round(str2double(get(handles.edit86,'string')),1);

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','StormwaterSystem.mat'),'stormwaterSystem');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
rutas=stormwaterSystem.rutasTuberia;
a=get(handles.popupmenu29,'value');
textT=get(handles.popupmenu30,'string');
tubF=textT{get(handles.popupmenu30,'value')};
B=split(tubF,'-');
b=str2double(B(end));

perfil={};
for i=1:size(rutas,1)
   inicio=find(a==rutas(i,:));
   if ~isempty(inicio)
       fin=find(b==rutas(i,:));
       if~isempty(fin)
           perfil{1}=rutas(i,inicio:fin);
           break
       else
           continue;
       end
   else
       continue;
   end

end
if isempty(perfil)
    if strcmp(idioma,'english')
       Aviso('Profile not found','Error','error');
    else
       Aviso('Perfil no encontrado','Error','error');
    end
    return
end

nodosDibujados=[[Conduit(perfil{1}).nodoI],[Conduit(perfil{1}).nodoF]];
nodosDibujados=unique(nodosDibujados);
nd=Node(nodosDibujados);

for i=1:length(modelo.labelPozoPr)
    if strcmp(idioma,'english')
       infoNodoCom={['Node - ',num2str(nd(i).ID,'%0.0f')],num2str(nd(i).elevacionT,'%0.2f'),num2str(nd(i).elevacionR,'%0.2f'),num2str(nd(i).desnivel,'%0.2f')};
    else
       infoNodoCom={['Nodo - ',num2str(nd(i).ID,'%0.0f')],num2str(nd(i).elevacionT,'%0.2f'),num2str(nd(i).elevacionR,'%0.2f'),num2str(nd(i).desnivel,'%0.2f')};
    end
    infoNodoF=infoNodoCom(logical(infoNodo));
    set(modelo.labelPozoPr(i),'String',infoNodoF);
end


%% Result visualization
% //    Description:
% //        -On/off ground node invert elevation labels (profile view)
% //    Update History
% =============================================================
%
function checkbox19_Callback(hObject, eventdata, handles)
actualizarLabelNodoPr(handles)
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19


%% Result visualization
% //    Description:
% //        -On/off node flow depth labels (profile view)
% //    Update History
% =============================================================
%
function checkbox20_Callback(hObject, eventdata, handles)
actualizarLabelNodoPr(handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


%% Result visualization
% //    Description:
% //        -Set line weight for node plot (profile view)
% //    Update History
% =============================================================
%
function edit84_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoPozoPr)
    return
end
grosor=round(str2double(get(handles.edit84,'string')),1);
if isempty(grosor)||isnan(grosor)||grosor<=0
    return
end
set(modelo.graficoPozoPr,'LineWidth',grosor);
% hObject    handle to edit84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit84 as text
%        str2double(get(hObject,'String')) returns contents of edit84 as a double


%% --- Executes during object creation, after setting all properties.
function edit84_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set line weight for node plot (profile view)
% //    Update History
% =============================================================
%
function slider35_Callback(hObject, eventdata, handles)
incremento=get(handles.slider35,'value');
set(handles.slider35, 'Value', 0.5);
valor=str2double(get(handles.edit84,'string'));
if incremento==1
    valor=valor+0.5;
else
    valor=valor-0.5;
end

if valor<=0
    return
else
    set(handles.edit84,'string',valor)
    edit84_Callback(hObject, eventdata, handles)
end
% hObject    handle to slider35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Result visualization
% //    Description:
% //        -Set line color for node plot (profile view)
% //    Update History
% =============================================================
%
function pushbutton176_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoPozoPr)
    return
end
color = uisetcolor(get(handles.pushbutton176,'BackgroundColor'));
if color == get(handles.pushbutton176,'BackgroundColor')
    return
else
     set(handles.pushbutton176,'BackgroundColor',color)
     set(modelo.graficoPozoPr,'Color',color)
end

% hObject    handle to pushbutton176 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu36.
function popupmenu36_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoPozoPr)
    return
end

switch get(handles.popupmenu36,'value')
    case 1
        set(modelo.graficoPozoPr,'LineStyle','-');
    case 2
        set(modelo.graficoPozoPr,'LineStyle','--');
    case 3
        set(modelo.graficoPozoPr,'LineStyle',':');
    case 4
        set(modelo.graficoPozoPr,'LineStyle','-.');
end
% hObject    handle to popupmenu36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu36 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu36


% --- Executes during object creation, after setting all properties.
function popupmenu36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set line type for node reference plot (profile view)
% //    Update History
% =============================================================
%
function popupmenu37_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoReferenciaPr)
    return
end

switch get(handles.popupmenu37,'value')
    case 1
        set(modelo.graficoReferenciaPr,'LineStyle','-');
    case 2
        set(modelo.graficoReferenciaPr,'LineStyle','--');
    case 3
        set(modelo.graficoReferenciaPr,'LineStyle',':');
    case 4
        set(modelo.graficoReferenciaPr,'LineStyle','-.');
end
% hObject    handle to popupmenu37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu37 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu37


%% --- Executes during object creation, after setting all properties.
function popupmenu37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set line weight for node reference plot (profile view)
% //    Update History
% =============================================================
%
function edit85_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoReferenciaPr)
    return
end
grosor=round(str2double(get(handles.edit85,'string')),1);
if isempty(grosor)||isnan(grosor)||grosor<=0
    return
end
set(modelo.graficoReferenciaPr,'LineWidth',grosor);

% hObject    handle to edit85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit85 as text
%        str2double(get(hObject,'String')) returns contents of edit85 as a double


%% --- Executes during object creation, after setting all properties.
function edit85_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set line weight for node reference plot (profile view)
% //    Update History
% =============================================================
%
function slider36_Callback(hObject, eventdata, handles)
incremento=get(handles.slider36,'value');
set(handles.slider36, 'Value', 0.5);
valor=str2double(get(handles.edit85,'string'));
if incremento==1
    valor=valor+0.5;
else
    valor=valor-0.5;
end

if valor<=0
    return
else
    set(handles.edit85,'string',valor)
    edit85_Callback(hObject, eventdata, handles)
end
% hObject    handle to slider36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Result visualization
% //    Description:
% //        -Set line color for node reference plot (profile view)
% //    Update History
% =============================================================
%
function pushbutton177_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoReferenciaPr)
    return
end
color = uisetcolor(get(handles.pushbutton177,'BackgroundColor'));
if color == get(handles.pushbutton177,'BackgroundColor')
    return
else
     set(handles.pushbutton177,'BackgroundColor',color)
     set(modelo.graficoReferenciaPr,'Color',color)
end
% hObject    handle to pushbutton177 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Set location for node labels (profile view)
% //    Update History
% =============================================================
%
function edit86_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.labelPozoPr)
    return
end
ubicacion=round(str2double(get(handles.edit86,'string')),1);
if isempty(ubicacion)||isnan(ubicacion)
    return
end
for i=1:length(modelo.labelPozoPr)
    posicion=modelo.labelPozoPr(i).Position;
    posicion(2)=ubicacion;
    modelo.labelPozoPr(i).Position=posicion;
end

% hObject    handle to edit86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit86 as text
%        str2double(get(hObject,'String')) returns contents of edit86 as a double


%% --- Executes during object creation, after setting all properties.
function edit86_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Result visualization
% //    Description:
% //        -Set location for node labels (profile view)
% //    Update History
% =============================================================
%
function slider37_Callback(hObject, eventdata, handles)
incremento=get(handles.slider37,'value');
set(handles.slider37, 'Value', 0.5);
valor=str2double(get(handles.edit86,'string'));
if incremento==1
    valor=valor+0.1;
else
    valor=valor-0.1;
end
set(handles.edit86,'string',valor)
edit86_Callback(hObject, eventdata, handles)

% hObject    handle to slider37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



%% Result visualization
% //    Description:
% //        -Set color for ground fill (profile view)
% //    Update History
% =============================================================
%
function pushbutton182_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoRelleno1Pr)
    return
end
color = uisetcolor(get(handles.pushbutton182,'BackgroundColor'));
if color == get(handles.pushbutton182,'BackgroundColor')
    return
else
     set(handles.pushbutton182,'BackgroundColor',color)
     set(modelo.graficoRelleno1Pr,'FaceColor',color)
     set(modelo.graficoRelleno2Pr,'FaceColor',color)
end
% hObject    handle to pushbutton182 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Set color for flow depth (profile view)
% //    Update History
% =============================================================
%
function pushbutton183_Callback(hObject, eventdata, handles)
global modelo

if isempty(modelo.graficoTirantePr)
    return
end
color = uisetcolor(get(handles.pushbutton183,'BackgroundColor'));
if color == get(handles.pushbutton183,'BackgroundColor')
    return
else
     set(handles.pushbutton183,'BackgroundColor',color)
     set(modelo.graficoTirantePr,'FaceColor',color)
end
% hObject    handle to pushbutton183 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Call interface to generate graph specific result
% //    Update History
% =============================================================
%
function Untitled_29_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');

if isempty(Scenario)
    if strcmp(idioma,'english')
       Aviso('Simulate hydrological responses','Error','error');
    else
       Aviso('Simular respuesta hidrológica','Error','error');
    end
    return
end
graficasSimulacion;

% hObject    handle to Untitled_29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes when user attempts to close moduloHidrologico.
function moduloHidrologico_CloseRequestFcn(hObject, eventdata, handles)
global idioma
if strcmp(idioma,'english')
   answer = questdlg('Do you want exit?','','Yes','No','No');
else
   answer = questdlg('Desea salir?','','Si','No','No');
end

switch answer
    case 'Yes'
        deleteGlobal('total')
        delete(gcf);     
    case 'No'
        return
    otherwise
        deleteGlobal('total')
        delete(gcf);
end
% hObject    handle to moduloHidrologico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


%% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to capaMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to resultadosMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% 


%% --------------------------------------------------------------------
function labelsPl_Callback(hObject, eventdata, handles)
% hObject    handle to labelsPl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function layersPl_Callback(hObject, eventdata, handles)
% hObject    handle to layersPl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% --------------------------------------------------------------------
function Untitled_38_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
try
if strcmp(idioma,'english')
   nombre = inputdlg({'Save model:'},(''),[1 30],{'Model_1'});
else
   nombre = inputdlg({'Guardar modelo:'},(''),[1 30],{'Model_1'});
end

if isempty(nombre)
    if strcmp(idioma,'english')
       Aviso('Enter file name','Error','error');
    else
       Aviso('Ingresar nombre del archivo','Error','error');
    end
    return
end
nombre=nombre{1};

[~, msg,~] = mkdir(fullfile(ProyectoHidrologico.carpetaBase,nombre));

if ~isempty(msg)
    if strcmp(idioma,'english')
        answer = questdlg('The file already exists, do you want to overwrite it?', ...
	    'Export model','Yes','Cancel','Cancel');
    else
        answer = questdlg('El archivo ya existe, desea sobrescribirlo?', ...
	    'Exportar modelo','Si','Cancelar','Cancelar');
    end

    switch answer
        case 'Yes'
            rmdir (fullfile(ProyectoHidrologico.carpetaBase,nombre),'s');
            mkdir(fullfile(ProyectoHidrologico.carpetaBase,nombre));
        case 'Si'
            rmdir (fullfile(ProyectoHidrologico.carpetaBase,nombre),'s');
            mkdir(fullfile(ProyectoHidrologico.carpetaBase,nombre));
        case 'Cancel'
            return
        otherwise
            return
    end
end

    jFrame = get(handle(gcf),'JavaFrame');
    jRootPane = jFrame.fHG2Client.getWindow;
    statusbarObj = com.mathworks.mwswing.MJStatusBar;
    jProgressBar = javax.swing.JProgressBar;
    numIds = 10;
    set(jProgressBar, 'Minimum',0, 'Maximum',numIds, 'Value',0);
    statusbarObj.add(jProgressBar,'West');
    
    set(jProgressBar,'Value',1);
    if strcmp(idioma,'english')
       msg = 'Starting process... (10%)';
    else
       msg = 'Iniciando proceso... (10%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
    jRootPane.setStatusBarVisible(1);
    
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');

    set(jProgressBar,'Value',3);
    if strcmp(idioma,'english')
       msg = 'Generating nodes... (30%)';
    else
       msg = 'Generando nodos... (30%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
    datosNodos = struct([]) ;

    for i = 1:length(Node)
        datosNodos(i).Geometry = 'Point' ;
        datosNodos(i).X=Node(i).corX ; 
        datosNodos(i).Y=Node(i).corY;
        datosNodos(i).Node_Id=Node(i).ID; 
        datosNodos(i).Z =round(Node(i).elevacionT,2);
        datosNodos(i).Invert=round(Node(i).elevacionR,2);
        datosNodos(i).Depth=round(Node(i).desnivel,2);     
    end
    shapewrite(datosNodos,fullfile(ProyectoHidrologico.carpetaBase,nombre,'Node.shp'))
    set(jProgressBar,'Value',60);
    if strcmp(idioma,'english')
       msg = 'Generating conduits... (50%)';
    else
       msg = 'Generando tuberías... (50%)';
    end

    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
    datosTuberias = struct([]) ;

    for i = 1:length(Conduit)
        datosTuberias(i).Geometry = 'Line' ;
        datosTuberias(i).X=modelo.graficoTuberias(i).XData; 
        datosTuberias(i).Y =modelo.graficoTuberias(i).YData; 
        datosTuberias(i).Conduit_Id=Conduit(i).ID; 
        datosTuberias(i).Node_I =Conduit(i).nodoI;
        datosTuberias(i).Node_F=Conduit(i).nodoF;
        
        switch Conduit(i).seccion.tipo
            case 'circular'
                datosTuberias(i).Section=Conduit(i).seccion.tipo;
                datosTuberias(i).Diameter=round(Conduit(i).seccion.diametro,2);
        end
        datosTuberias(i).Length=round(Conduit(i).longitud,2);
        datosTuberias(i).Roughness=round(Conduit(i).n,3);
        datosTuberias(i).InvertNi=round(Conduit(i).ERNi,2);
        datosTuberias(i).InvertNf=round(Conduit(i).ERNf,2);
    end
    shapewrite(datosTuberias,fullfile(ProyectoHidrologico.carpetaBase,nombre,'Conduit.shp'))
    set(jProgressBar,'Value',90);
    if strcmp(idioma,'english')
       msg = 'Generating catchment... (70%)';
    else
       msg = 'Generando cuencas... (70%)';
    end

    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
    datosCuencas= struct([]);

    for i = 1:length(Catchment)
        datosCuencas(i).Geometry = 'Polygon' ;
        datosCuencas(i).X=modelo.graficoCuencas(i).XData;
        datosCuencas(i).Y =modelo.graficoCuencas(i).YData;
        datosCuencas(i).Catch_Id=Catchment(i).ID; 
        datosCuencas(i).Node_Dra =Catchment(i).descarga;
        datosCuencas(i).Area=round(Catchment(i).area,2);
    end
    shapewrite(datosCuencas,fullfile(ProyectoHidrologico.carpetaBase,nombre,'Catchment.shp'))
    
    set(jProgressBar,'Value',10);
    if strcmp(idioma,'english')
       msg = 'Finishing process... (99%)';
    else
       msg = 'Finalizando proceso... (99%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
    pause(0.5)
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
       Aviso({'The model was exported successfully',['Folder: ',fullfile(ProyectoHidrologico.carpetaBase,nombre)]},'Success','help');
    else
       Aviso({'El modelo se generó exitosamente',['Folder: ',fullfile(ProyectoHidrologico.carpetaBase,nombre)]},'Success','help');
    end  

catch
    jFrame = get(handle(gcf),'JavaFrame');
    jRootPane = jFrame.fHG2Client.getWindow;
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
       Aviso('The model could not be exported','Error','error');
    else
       Aviso('El modelo no puede exportarse, verificar componentes','Error','error');
    end 
    
end

% hObject    handle to Untitled_38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Result visualization
% //    Description:
% //        -Plot urban hydrological impact result
% //    Update History
% =============================================================
%
function Untitled_39_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');

if isempty(Scenario)
    if strcmp(idioma,'english')
       Aviso('Simulate hydrological responses','Error','error');
    else
       Aviso('Simular respuesta hidrológica','Error','error');
    end
    return
end
impactoHidrologico;

% hObject    handle to Untitled_39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Background
% //    Description:
% //        -Import shp file format 
% //    Update History
% =============================================================
%
function Untitled_40_Callback(hObject, eventdata, handles)
global modelo idioma
% try
if strcmp(idioma,'english')
   [archivo,ruta]=uigetfile('*.shp','Select file');
else
   [archivo,ruta]=uigetfile('*.shp','Seleccionar archivo');
end

if archivo==0

 return;
else
    ruta=[ruta,archivo];
    fondo = readgeotable(ruta);

    axes(handles.axes1);

%     hold on
%     xlim auto
%     ylim auto
    if ~isempty(modelo.background)
        delete(modelo.background);
        modelo.background=[];
    end
    modelo.background=mapshow(handles.axes1,fondo,'LineStyle','-',"FaceColor",[0.94 0.94 0.94],'FaceAlpha', 0.1);
    ax=handles.axes1;
    VPermutar=ax.Children;   
    Dim=size(VPermutar,1);
    Vec=(1:1:Dim);
    F=Vec(1);
    Vec(1)=[];
    Vec=[Vec,F];
    ax.Children = ax.Children(Vec);
end
% hObject    handle to Untitled_40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function resultadoLabelPl_Callback(hObject, eventdata, handles)
% hObject    handle to resultadoLabelPl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function menuAxesPl_Callback(hObject, eventdata, handles)
% hObject    handle to menuAxesPl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_31_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_32_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_34_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');

if isempty(Scenario)
    if strcmp(idioma,'english')
       Aviso('Simulate hydrological responses','Error','error');
    else
       Aviso('Simular respuesta hidrológica','Error','error');
    end
    return
end
tablaResultados;
% hObject    handle to Untitled_34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Labels result elements
% //    Description:
% //        -Turn off/on all labels
% //    Update History
% =============================================================
% 
function Untitled_33_Callback(hObject, eventdata, handles)
global modelo

if strcmp(get(handles.Untitled_33,'Checked'),'off')
    set(modelo.labelNodosPl,'visible','on');
    set(handles.Untitled_33,'Checked','on')
else
    set(modelo.labelNodosPl,'visible','off');
    set(handles.Untitled_33,'Checked','off')
end 
% hObject    handle to Untitled_33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_30_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton187.
function pushbutton187_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton187 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton194.
function pushbutton194_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton194 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton195.
function pushbutton195_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton195 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on selection change in popupmenu46.
function popupmenu46_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu46 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu46


%% --- Executes during object creation, after setting all properties.
function popupmenu46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in popupmenu47.
function popupmenu47_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu47 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu47


%% --- Executes during object creation, after setting all properties.
function popupmenu47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in popupmenu49.
function popupmenu49_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu49 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu49


%% --- Executes during object creation, after setting all properties.
function popupmenu49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ------------------------------------------------------------------------
function edit94_Callback(hObject, eventdata, handles)
% hObject    handle to edit94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit94 as text
%        str2double(get(hObject,'String')) returns contents of edit94 as a double


%% --- Executes during object creation, after setting all properties.
function edit94_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ------------------------------------------------------------------------
function edit95_Callback(hObject, eventdata, handles)
% hObject    handle to edit95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit95 as text
%        str2double(get(hObject,'String')) returns contents of edit95 as a double


%% --- Executes during object creation, after setting all properties.
function edit95_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in checkbox29.
function checkbox29_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox29


%% ------------------------------------------------------------------------
function edit96_Callback(hObject, eventdata, handles)
% hObject    handle to edit96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit96 as text
%        str2double(get(hObject,'String')) returns contents of edit96 as a double


%% --- Executes during object creation, after setting all properties.
function edit96_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%  -----------------------------------------------------------------------
function edit97_Callback(hObject, eventdata, handles)
% hObject    handle to edit97 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit97 as text
%        str2double(get(hObject,'String')) returns contents of edit97 as a double


%% --- Executes during object creation, after setting all properties.
function edit97_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit97 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ------------------------------------------------------------------------
function edit98_Callback(hObject, eventdata, handles)
% hObject    handle to edit98 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit98 as text
%        str2double(get(hObject,'String')) returns contents of edit98 as a double


%% --- Executes during object creation, after setting all properties.
function edit98_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit98 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in popupmenu53.
function popupmenu53_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu53 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu53


%% --- Executes during object creation, after setting all properties.
function popupmenu53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in popupmenu54.
function popupmenu54_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu54 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu54


%% --- Executes during object creation, after setting all properties.
function popupmenu54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in popupmenu55.
function popupmenu55_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu55 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu55


%% --- Executes during object creation, after setting all properties.
function popupmenu55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in popupmenu56.
function popupmenu56_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu56 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu56


%% --- Executes during object creation, after setting all properties.
function popupmenu56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on slider movement.
function slider45_Callback(hObject, eventdata, handles)
global idioma
trials=str2double(get(handles.edit99,'string'));
if isnan(trials)||isempty(trials)||trials<=0||trials>100
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    
    set(handles.edit99,'string','75');
    return
end

incremento=get(handles.slider45,'value');
set(handles.slider45, 'Value', 0.5);

if incremento==1
    trials=trials+25;
else
    trials=trials-25;
end

if trials<=0
    set(handles.edit99,'string','75');
    return
end

% hObject    handle to slider45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% ------------------------------------------------------------------------
function edit99_Callback(hObject, eventdata, handles)
% hObject    handle to edit99 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit99 as text
%        str2double(get(hObject,'String')) returns contents of edit99 as a double


%% --- Executes during object creation, after setting all properties.
function edit99_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit99 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in checkbox31.
function checkbox31_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox31


%% ------------------------------------------------------------------------
function edit100_Callback(hObject, eventdata, handles)
% hObject    handle to edit100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit100 as text
%        str2double(get(hObject,'String')) returns contents of edit100 as a double


%% --- Executes during object creation, after setting all properties.
function edit100_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ------------------------------------------------------------------------
function edit101_Callback(hObject, eventdata, handles)
% hObject    handle to edit101 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit101 as text
%        str2double(get(hObject,'String')) returns contents of edit101 as a double


%% --- Executes during object creation, after setting all properties.
function edit101_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit101 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on slider movement.
function slider46_Callback(hObject, eventdata, handles)
global idioma
trials=str2double(get(handles.edit102,'string'));
if isnan(trials)||isempty(trials)||trials<=0
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    set(handles.edit102,'string','8');
    return
end

incremento=get(handles.slider46,'value');
set(handles.slider46, 'Value', 0.5);

if incremento==1
    trials=trials+1;
else
    trials=trials-1;
end

if trials<=0
    set(handles.edit102,'string','8');
    return
end

% hObject    handle to slider46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%% --- Executes during object creation, after setting all properties.
function slider46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% ------------------------------------------------------------------------
function edit102_Callback(hObject, eventdata, handles)
% hObject    handle to edit102 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit102 as text
%        str2double(get(hObject,'String')) returns contents of edit102 as a double


%% --- Executes during object creation, after setting all properties.
function edit102_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit102 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ------------------------------------------------------------------------
function edit103_Callback(hObject, eventdata, handles)
% hObject    handle to edit103 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit103 as text
%        str2double(get(hObject,'String')) returns contents of edit103 as a double


%% --- Executes during object creation, after setting all properties.
function edit103_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit103 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in pushbutton205.
function pushbutton205_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton205 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in pushbutton206.
function pushbutton206_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton206 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: retention system
% //    Description:
% //        -Edit element options
% //    Update History
% =============================================================
%
function pushbutton211_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
if ~isempty(genRetention)
    Tor=cell(1,length(genRetention));
    for i=1:length(genRetention)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','System','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Sistema','SelectionMode','single');
    end
    
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        modelo.bandera=genRetention(Z);
        RCuencas=Catchment;
        [Catchment(genRetention(Z).cuenca),estado]=eliminarSUD(Catchment(genRetention(Z).cuenca),genRetention(Z));
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');

        editarGeneral(crearGenRetencion);
        
        if ~isempty(modelo.bandera)
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            [Catchment(modelo.bandera.cuenca),estado]=validarSUD(Catchment(modelo.bandera.cuenca),modelo.bandera);
            if estado==1        
                genRetention(Z)=modelo.bandera;
                tablaGenRetencion(genRetention,handles,'edicion',Z)
                tablaCuencas(Catchment,handles,'edicionSUDS',genRetention(Z).cuenca);
                save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
                save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            else
                Catchment=RCuencas;
                save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
                if strcmp(idioma,'english')
                    Aviso('Operation incompleted','Error','error');
                else
                    Aviso('Operación incompleta','Error','error');
                end
                
            end
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no SUDS in the system','Error','error');
    else
        Aviso('No existen SUDS en el sistema','Error','error');
    end
    return
end
% hObject    handle to pushbutton211 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: retention system
% //    Description:
% //        -Delete element
% //    Update History
% =============================================================
%
function pushbutton212_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
if ~isempty(genRetention)
    Tor=cell(1,length(genRetention));
    for i=1:length(genRetention)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','System','SelectionMode','multiple');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Sistema','SelectionMode','multiple');
    end
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        if ~isempty(Catchment)
            for i=1:length(Z)
                [Catchment(genRetention(Z(i)).cuenca),estado]=eliminarSUD(Catchment(genRetention(Z(i)).cuenca),genRetention(Z(i)));
                if ~estado
                    if strcmp(idioma,'english')
                        Aviso('Operation incompleted','Error','error');
                    else
                        Aviso('Operación incompleta','Error','error');
                    end
                    return;
                end
            end
            
            genRetention(Z)=[];
            if ~isempty(genRetention)
                for i=length(genRetention)
                    genRetention(i).ID=i;
                end
            end
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
            tablaCuencas(Catchment,handles,'eliminacion')
            tablaGenRetencion(genRetention,handles,'eliminacion')

        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no SUDS in the system','Error','error');
    else
        Aviso('No existen SUDS en el sistema','Error','error');
    end
    return
end
% hObject    handle to pushbutton212 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: retention system
% //    Description:
% //        -Create and configurate element options
% //    Update History
% =============================================================
%
function pushbutton213_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if isempty(modelo.cuencas) || modelo.cuencas==0
    if strcmp(idioma,'english')
        Aviso('There are no catchment in the model','Error','error');
    else
        Aviso('No existen cuencas en el modelo','Error','error');
    end
    return
end
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
genRetention=[genRetention,retencion(length(genRetention)+1,'retencion')];
modelo.bandera=genRetention(end);
editarGeneral(crearGenRetencion);
if ~isempty(modelo.bandera)
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    [Catchment(modelo.bandera.cuenca),estado]=validarSUD(Catchment(modelo.bandera.cuenca),modelo.bandera);
    if estado==1        
        genRetention(end)=modelo.bandera;
        tablaGenRetencion(genRetention,handles,'creacion')
        tablaCuencas(Catchment,handles,'edicionSUDS',genRetention(end).cuenca);
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    else
        if strcmp(idioma,'english')
            Aviso('Verify area','Error','error');
        else
            Aviso('Verificar área','Error','error');
        end
    end
end
% hObject    handle to pushbutton213 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% SUDS: retention system
% //    Description:
% //        -Manage the table of information for the elements
% //    Update History
% =============================================================
%
function tablaGenRetencion(genRetention,handles,varargin)
formatSpec = '%.2f';
formatSpec2 = '%.6f';
formatSpec3 = '%.0f';
switch varargin{1}
    case 'creacion'
        ID={['<html><tr><td width=9999 align=center>',num2str(genRetention(end).ID)]};
        cuenca={['<html><tr><td width=9999 align=center>',num2str(genRetention(end).cuenca)]};
        area={['<html><tr><td width=9999 align=center>',num2str(genRetention(end).areaConectada*100)]};
        pp={['<html><tr><td width=9999 align=center>',num2str(genRetention(end).permeable*100)]};
        pimp={['<html><tr><td width=9999 align=center>',num2str(genRetention(end).impermeable*100)]};
        vol={['<html><tr><td width=9999 align=center>',num2str(genRetention(end).volumenTotal,formatSpec)]};
        capacidad={['<html><tr><td width=9999 align=center>',num2str(genRetention(end).capacidadInicial*100)]};
        captacion={['<html><tr><td width=9999 align=center>',num2str(genRetention(end).captacion,formatSpec)]};
        if length(genRetention)==1
            Datos=[ID,cuenca,area,pp,pimp,vol,capacidad,captacion];
        else
            Datos=get(handles.tablaGenRetencion,'data');
            Datos=[Datos;ID,cuenca,area,pp,pimp,vol,capacidad,captacion];
        end
    case 'edicion'
        r=varargin{2};
        Datos=get(handles.tablaGenRetencion,'data');
        Datos{r,2}=['<html><tr><td width=9999 align=center>',num2str(genRetention(r).cuenca)];
        Datos{r,3}=['<html><tr><td width=9999 align=center>',num2str(genRetention(r).areaConectada*100)];
        Datos{r,4}=['<html><tr><td width=9999 align=center>',num2str(genRetention(r).permeable*100)];
        Datos{r,5}=['<html><tr><td width=9999 align=center>',num2str(genRetention(r).impermeable*100)];
        Datos{r,6}=['<html><tr><td width=9999 align=center>',num2str(genRetention(r).volumenTotal,formatSpec)];
        Datos{r,7}=['<html><tr><td width=9999 align=center>',num2str(genRetention(r).capacidadInicial*100)];
        Datos{r,8}=['<html><tr><td width=9999 align=center>',num2str(genRetention(r).captacion,formatSpec)];
    case 'eliminacion'     
        if ~isempty(genRetention)
            Datos=cell(length(genRetention),8);
            for i=1:length(genRetention)
                ID={['<html><tr><td width=9999 align=center>',num2str(genRetention(i).ID)]};
                cuenca={['<html><tr><td width=9999 align=center>',num2str(genRetention(i).cuenca)]};
                area={['<html><tr><td width=9999 align=center>',num2str(genRetention(i).areaConectada*100)]};
                pp={['<html><tr><td width=9999 align=center>',num2str(genRetention(i).permeable*100)]};
                pimp={['<html><tr><td width=9999 align=center>',num2str(genRetention(i).impermeable*100)]};
                vol={['<html><tr><td width=9999 align=center>',num2str(genRetention(i).volumenTotal,formatSpec)]};
                capacidad={['<html><tr><td width=9999 align=center>',num2str(genRetention(i).capacidadInicial*100)]};
                captacion={['<html><tr><td width=9999 align=center>',num2str(genRetention(i).captacion,formatSpec)]};
                Datos(i,1)=ID;
                Datos(i,2)=cuenca;
                Datos(i,3)=area;
                Datos(i,4)=pp;
                Datos(i,5)=pimp;
                Datos(i,6)=vol;
                Datos(i,7)=capacidad;
                Datos(i,8)=captacion;
            end
        else
            Datos=[];
        end
end

set(handles.tablaGenRetencion,'data',Datos)  


%% SUDS: detention system
% //    Description:
% //        -Manage the table of information for the elements
% //    Update History
% =============================================================
%
function tablaGenDetencion(genDetention,handles,varargin)
formatSpec = '%.2f';
switch varargin{1}
    case 'creacion'
        ID={['<html><tr><td width=9999 align=center>',num2str(genDetention(end).ID)]};
        cuenca={['<html><tr><td width=9999 align=center>',num2str(genDetention(end).cuenca)]};
        area={['<html><tr><td width=9999 align=center>',num2str(genDetention(end).areaConectada*100)]};
        pp={['<html><tr><td width=9999 align=center>',num2str(genDetention(end).permeable*100)]};
        pimp={['<html><tr><td width=9999 align=center>',num2str(genDetention(end).impermeable*100)]};
        control={['<html><tr><td width=9999 align=center>',genDetention(end).datosControl.tipo]};
        hInicial={['<html><tr><td width=9999 align=center>',num2str(genDetention(end).hInicial)]};
        captacion={['<html><tr><td width=9999 align=center>',num2str(genDetention(end).captacion,formatSpec)]};
        if length(genDetention)==1
            Datos=[ID,cuenca,area,pp,pimp,control,hInicial,captacion];
        else
            Datos=get(handles.tablaGenDetencion,'data');
            Datos=[Datos;ID,cuenca,area,pp,pimp,control,hInicial,captacion];
        end
    case 'edicion'
        r=varargin{2};
        Datos=get(handles.tablaGenDetencion,'data');
        Datos{r,2}=['<html><tr><td width=9999 align=center>',num2str(genDetention(r).cuenca)];
        Datos{r,3}=['<html><tr><td width=9999 align=center>',num2str(genDetention(r).areaConectada*100)];
        Datos{r,4}=['<html><tr><td width=9999 align=center>',num2str(genDetention(r).permeable*100)];
        Datos{r,5}=['<html><tr><td width=9999 align=center>',num2str(genDetention(r).impermeable*100)];
        Datos{r,6}=['<html><tr><td width=9999 align=center>',genDetention(r).datosControl.tipo];
        Datos{r,7}=['<html><tr><td width=9999 align=center>',num2str(genDetention(r).hInicial)];
        Datos{r,8}=['<html><tr><td width=9999 align=center>',num2str(genDetention(r).captacion,formatSpec)];
    case 'eliminacion'     
        if ~isempty(genDetention)
            Datos=cell(length(genDetention),8);
            for i=1:length(genDetention)
                ID={['<html><tr><td width=9999 align=center>',num2str(genDetention(i).ID)]};
                cuenca={['<html><tr><td width=9999 align=center>',num2str(genDetention(i).cuenca)]};
                area={['<html><tr><td width=9999 align=center>',num2str(genDetention(i).areaConectada*100)]};
                pp={['<html><tr><td width=9999 align=center>',num2str(genDetention(i).permeable*100)]};
                pimp={['<html><tr><td width=9999 align=center>',num2str(genDetention(i).impermeable*100)]};
                control={['<html><tr><td width=9999 align=center>',genDetention(i).datosControl.tipo]};
                hInicial={['<html><tr><td width=9999 align=center>',num2str(genDetention(i).hInicial)]};
                captacion={['<html><tr><td width=9999 align=center>',num2str(genDetention(i).captacion,formatSpec)]};
                Datos(i,1)=ID;
                Datos(i,2)=cuenca;
                Datos(i,3)=area;
                Datos(i,4)=pp;
                Datos(i,5)=pimp;
                Datos(i,6)=control;
                Datos(i,7)=hInicial;
                Datos(i,8)=captacion;
            end
        else
            Datos=[];
        end
end

set(handles.tablaGenDetencion,'data',Datos)  

%% SUDS: infiltration system
% //    Description:
% //        -Manage the table of information for the elements
% //    Update History
% =============================================================
%
function tablaGenInfiltracion(genInfiltration,handles,varargin)
formatSpec = '%.2f';
switch varargin{1}
    case 'creacion'
        ID={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(end).ID)]};
        cuenca={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(end).cuenca)]};
        area={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(end).areaConectada*100)]};
        pp={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(end).permeable*100)]};
        pimp={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(end).impermeable*100)]};
        superficie={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(end).superficie,formatSpec)]};
        infilMax={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(end).infilMax,formatSpec)]};
        captacion={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(end).captacion,formatSpec)]};
        control={['<html><tr><td width=9999 align=center>',genInfiltration(end).control]};

        if length(genInfiltration)==1
            Datos=[ID,cuenca,area,pp,pimp,superficie,infilMax,captacion,control];
        else
            Datos=get(handles.tablaGenInfiltracion,'data');
            Datos=[Datos;ID,cuenca,area,pp,pimp,superficie,infilMax,captacion,control];
        end
    case 'edicion'
        r=varargin{2};
        Datos=get(handles.tablaGenInfiltracion,'data');
        Datos{r,2}=['<html><tr><td width=9999 align=center>',num2str(genInfiltration(r).cuenca)];
        Datos{r,3}=['<html><tr><td width=9999 align=center>',num2str(genInfiltration(r).areaConectada*100)];
        Datos{r,4}=['<html><tr><td width=9999 align=center>',num2str(genInfiltration(r).permeable*100)];
        Datos{r,5}=['<html><tr><td width=9999 align=center>',num2str(genInfiltration(r).impermeable*100)];
        Datos{r,6}=['<html><tr><td width=9999 align=center>',num2str(genInfiltration(r).superficie,formatSpec)];
        Datos{r,7}=['<html><tr><td width=9999 align=center>',num2str(genInfiltration(r).infilMax,formatSpec)];
        Datos{r,8}=['<html><tr><td width=9999 align=center>',num2str(genInfiltration(r).captacion,formatSpec)];
        Datos{r,9}=['<html><tr><td width=9999 align=center>',genInfiltration(r).control];
    case 'eliminacion'     
        if ~isempty(genInfiltration)
            Datos=cell(length(genInfiltration),8);
            for i=1:length(genInfiltration)
                ID={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(i).ID)]};
                cuenca={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(i).cuenca)]};
                area={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(i).areaConectada*100)]};
                pp={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(i).permeable*100)]};
                pimp={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(i).impermeable*100)]};
                superficie={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(i).superficie,formatSpec)]};
                infilMax={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(i).infilMax,formatSpec)]};
                captacion={['<html><tr><td width=9999 align=center>',num2str(genInfiltration(i).captacion,formatSpec)]};
                control={['<html><tr><td width=9999 align=center>',genInfiltration(i).control]};
                Datos(i,1)=ID;
                Datos(i,2)=cuenca;
                Datos(i,3)=area;
                Datos(i,4)=pp;
                Datos(i,5)=pimp;
                Datos(i,6)=superficie;
                Datos(i,7)=infilMax;
                Datos(i,8)=captacion;
                Datos(i,9)=control;
            end
        else
            Datos=[];
        end
end

set(handles.tablaGenInfiltracion,'data',Datos)  


%% SUDS: detention system
% //    Description:
% //        -Edit element options
% //    Update History
% =============================================================
%
function pushbutton214_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
if ~isempty(genDetention)
    Tor=cell(1,length(genDetention));
    for i=1:length(genDetention)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','System','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Sistema','SelectionMode','single');
    end
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        modelo.bandera=genDetention(Z);
        RCuencas=Catchment;
        [Catchment(genDetention(Z).cuenca),estado]=eliminarSUD(Catchment(genDetention(Z).cuenca),genDetention(Z));
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');

        editarGeneral(crearGenDetencion);
        
        if ~isempty(modelo.bandera)
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            [Catchment(modelo.bandera.cuenca),estado]=validarSUD(Catchment(modelo.bandera.cuenca),modelo.bandera);
            if estado==1        
                genDetention(Z)=modelo.bandera;
                tablaGenDetencion(genDetention,handles,'edicion',Z)
                tablaCuencas(Catchment,handles,'edicionSUDS',genDetention(end).cuenca);
                save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
                save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            else
                Catchment=RCuencas;
                save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
                if strcmp(idioma,'english')
                    Aviso('Operation incompleted','Error','error');
                else
                    Aviso('Operación incompleta','Error','error');
                end
            end
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no SUDS in the system','Error','error');
    else
        Aviso('No existen SUDS en el sistema','Error','error');
    end
    return
end
% hObject    handle to pushbutton214 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: detention system
% //    Description:
% //        -Delete element
% //    Update History
% =============================================================
%
function pushbutton215_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
if ~isempty(genDetention)
    Tor=cell(1,length(genDetention));
    for i=1:length(genDetention)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','System','SelectionMode','multiple');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Sistema','SelectionMode','multiple');
    end
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');

        if ~isempty(Catchment)
            for i=1:length(Z)
                [Catchment(genDetention(Z(i)).cuenca),estado]=eliminarSUD(Catchment(genDetention(Z(i)).cuenca),genDetention(Z(i)));
                if ~estado
                    if strcmp(idioma,'english')
                        Aviso('Operation incompleted','Error','error');
                    else
                        Aviso('Operación incompleta','Error','error');
                    end
                    return;
                end
            end
            genDetention(Z)=[];
            if ~isempty(genDetention)
                for i=length(genDetention)
                    genDetention(i).ID=i;
                end
            end
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
            tablaCuencas(Catchment,handles,'eliminacion')
            tablaGenDetencion(genDetention,handles,'eliminacion')
        end

    end
else
    if strcmp(idioma,'english')
        Aviso('There are no SUDS in the system','Error','error');
    else
        Aviso('No existen SUDS en el sistema','Error','error');
    end
end
% hObject    handle to pushbutton215 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: detention system
% //    Description:
% //        -Create and configurate element options
% //    Update History
% =============================================================
%
function pushbutton216_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if isempty(modelo.cuencas) || modelo.cuencas==0
    if strcmp(idioma,'english')
        Aviso('There are no catchment in the model','Error','error');
    else
        Aviso('No existen cuencas en el modelo','Error','error');
    end
    return
end
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
genDetention=[genDetention,detencion(length(genDetention)+1,'detencion')];
modelo.bandera=genDetention(end);
editarGeneral(crearGenDetencion);
if ~isempty(modelo.bandera)
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    [Catchment(modelo.bandera.cuenca),estado]=validarSUD(Catchment(modelo.bandera.cuenca),modelo.bandera);
    if estado==1        
        genDetention(end)=modelo.bandera;
        tablaGenDetencion(genDetention,handles,'creacion')
        tablaCuencas(Catchment,handles,'edicionSUDS',genDetention(end).cuenca);
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    else
        if strcmp(idioma,'english')
            Aviso('Verify area','Error','error');
        else
            Aviso('Verificar área','Error','error');
        end
    end
end
% hObject    handle to pushbutton216 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: infiltration system
% //    Description:
% //        -Edit element options
% //    Update History
% =============================================================
%
function pushbutton217_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
if ~isempty(genInfiltration)
    Tor=cell(1,length(genInfiltration));
    for i=1:length(genInfiltration)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','System','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Sistema','SelectionMode','single');
    end
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        modelo.bandera=genInfiltration(Z);
        RCuencas=Catchment;
        [Catchment(genInfiltration(Z).cuenca),estado]=eliminarSUD(Catchment(genInfiltration(Z).cuenca),genInfiltration(Z));
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');

        editarGeneral(crearGenInfiltracion);
        
        if ~isempty(modelo.bandera)
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            [Catchment(modelo.bandera.cuenca),estado]=validarSUD(Catchment(modelo.bandera.cuenca),modelo.bandera);
            if estado==1        
                genInfiltration(Z)=modelo.bandera;
                tablaGenInfiltracion(genInfiltration,handles,'edicion',Z)
                tablaCuencas(Catchment,handles,'edicionSUDS',genInfiltration(end).cuenca);
                save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
                save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            else
                Catchment=RCuencas;
                save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
                if strcmp(idioma,'english')
                    Aviso('Operation incompleted','Error','error');
                else
                    Aviso('Operación incompleta','Error','error');
                end
            end
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no SUDS in the system','Error','error');
    else
        Aviso('No existen SUDS en el sistema','Error','error');
    end
    return
end
% hObject    handle to pushbutton217 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: infiltration system
% //    Description:
% //        -Delete element
% //    Update History
% =============================================================
%
function pushbutton218_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
if ~isempty(genInfiltration)
    Tor=cell(1,length(genInfiltration));
    for i=1:length(genInfiltration)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','System','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Sistema','SelectionMode','single');
    end
    if ~isempty(Z)
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        if ~isempty(Catchment)
            for i=1:length(Z)
                [Catchment(genInfiltration(Z(i)).cuenca),estado]=eliminarSUD(Catchment(genInfiltration(Z(i)).cuenca),genInfiltration(Z(i)));
                if ~estado
                    if strcmp(idioma,'english')
                        Aviso('Operation incompleted','Error','error');
                    else
                        Aviso('Operación incompleta','Error','error');
                    end
                    return;
                end
            end
            genInfiltration(Z)=[];
            if ~isempty(genInfiltration)
                for i=length(genInfiltration)
                    genInfiltration(i).ID=i;
                end
            end
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
            save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
            tablaCuencas(Catchment,handles,'eliminacion')
            tablaGenInfiltracion(genInfiltration,handles,'eliminacion')            
        end
    end
else
    if strcmp(idioma,'english')
        Aviso('There are no SUDS in the system','Error','error');
    else
        Aviso('No existen SUDS en el sistema','Error','error');
    end
    return
end
% hObject    handle to pushbutton218 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: infiltration system
% //    Description:
% //        -Create and configurate element options
% //    Update History
% =============================================================
%
function pushbutton219_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if isempty(modelo.cuencas) || modelo.cuencas==0
    if strcmp(idioma,'english')
        Aviso('There are no catchment in the model','Error','error');
    else
        Aviso('No existen cuencas en el modelo','Error','error');
    end
    return
end
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
genInfiltration=[genInfiltration,infiltracionSud(length(genInfiltration)+1,'infiltracion')];
modelo.bandera=genInfiltration(end);
editarGeneral(crearGenInfiltracion);
if ~isempty(modelo.bandera)
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    [Catchment(modelo.bandera.cuenca),estado]=validarSUD(Catchment(modelo.bandera.cuenca),modelo.bandera);
    if estado==1        
        genInfiltration(end)=modelo.bandera;
        tablaGenInfiltracion(genInfiltration,handles,'creacion')
        tablaCuencas(Catchment,handles,'edicionSUDS',genInfiltration(end).cuenca);
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    else
        if strcmp(idioma,'english')
            Aviso('Verify area','Error','error');
        else
            Aviso('Verificar área','Error','error');
        end
    end
end
% hObject    handle to pushbutton219 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ------------------------------------------------------------------------
function edit104_Callback(hObject, eventdata, handles)
% hObject    handle to edit104 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit104 as text
%        str2double(get(hObject,'String')) returns contents of edit104 as a double


%% --- Executes during object creation, after setting all properties.
function edit104_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit104 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Model visualization
% //    Description:
% //        -Rotate option 
% //    Update History
% =============================================================
%
function rotar_Callback(hObject, eventdata, handles)

ax=gca;
ax.DataAspectRatio=[1 1 1];
view=ax.View;
switch view(1)
    case 0
        view(1)=90;
    case 90
        view(1)=180;
    case 180
        view(1)=270;
    case 270
        view(1)=360;
    case 360
        view(1)=90;
end
ax.View=view;
% hObject    handle to rotar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Background
% //    Description:
% //        -Import Tiff file format 
% //    Update History
% =============================================================
%
function Untitled_41_Callback(hObject, eventdata, handles)
global modelo idioma
% try
if strcmp(idioma,'english')
    [archivo,ruta]=uigetfile('*.tif','Select file');
else
    [archivo,ruta]=uigetfile('*.tif','Seleccionar archivo');
end

if archivo==0

 return;
else
    [fondo, cmap] = imread ( [ruta,archivo] );
    P=strsplit(archivo,'.');
    archivo2=[P{1},'.tfw'];
    if ~exist([ruta,archivo2],'file')
        if strcmp(idioma,'english')
            Aviso('The TWF reference file does not exist','Error','error');
        else
            Aviso('La referencia no existe','Error','error');
        end
        
        delete(fondo)
        delete(cmap)
        return;
    end

    R1 = worldfileread ( [ruta,archivo2], 'planar' , size (fondo));
    axes(handles.axes1);

    hold on
    xlim auto
    ylim auto
    if ~isempty(modelo.background)
        delete(modelo.background);
        modelo.background=[];
    end

    modelo.background=mapshow(handles.axes1,fondo,cmap,R1);
    ax=handles.axes1;
    VPermutar=ax.Children;   
    Dim=size(VPermutar,1);
    Vec=(1:1:Dim);
    F=Vec(1);
    Vec(1)=[];
    Vec=[Vec,F];
    ax.Children = ax.Children(Vec);

end
% hObject    handle to Untitled_41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_42_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --------------------------------------------------------------------
function Untitled_43_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton221.
function pushbutton221_Callback(hObject, eventdata, handles)


%% SUDS: detention system
% //    Description:
% //        -Create and configurate element options
% //        -Import file (txt) with system configuration
% //    Update History
% =============================================================
%
function pushbutton223_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma

[nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Select data file');
if isnumeric(ruta) || isnumeric(nombre)
    return;
end

datos = importdata(fullfile(ruta,nombre));
if size(datos.data,2)~=3 || size(datos.textdata,2)~=7
    if strcmp(idioma,'english')
        Aviso('Verify data file','Error','error');
    else
        Aviso('Verificar archivo','Error','error');
    end
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
for i=1:size(datos.data,1)
        switch datos.textdata{i,7}
            case 'orificio'
                datosControl.conductos=datos.data(i,1);
                datosControl.diametro=datos.data(i,2);
                datosControl.cd=datos.data(i,3);
                datosControl.tipo='orificio';
            case 'vertedor'
                datosControl.conductos=datos.data(i,1);
                datosControl.diametro=datos.data(i,2);
                datosControl.cd=datos.data(i,3);
                datosControl.tipo='orificio';
            otherwise
                if strcmp(idioma,'english')
                    Aviso('Verify type control','Eror','error');
                else
                    Aviso('Verificar tipo de control','Eror','error');
                end
                return
        end
        genDetention=[genDetention,detencion(length(genDetention)+1,'detencion')];
        genDetention(end)=parametros(genDetention(end),str2double(datos.textdata{i,1}),str2double(datos.textdata{i,2})/100,str2double(datos.textdata{i,3})/100,...
            str2double(datos.textdata{i,4})/100,datosControl,str2double(datos.textdata{i,5}),str2double(datos.textdata{i,6}));

    [Catchment(str2double(datos.textdata{i,1})),estado]=validarSUD(Catchment(str2double(datos.textdata{i,1})),genDetention(end));
    if estado==1        
        tablaGenDetencion(genDetention,handles,'eliminacion')
        tablaCuencas(Catchment,handles,'edicionSUDS',genDetention(end).cuenca);
    else
        if strcmp(idioma,'english')
            Aviso('Verify area','Error','error');
        else
            Aviso('Verificar área','Error','error');
        end
        return
    end
end
if strcmp(idioma,'english')
    Aviso('Operation completed','Success','help');
else
    Aviso('Operación completa','Success','help');
end
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');

% hObject    handle to pushbutton223 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: infiltration system
% //    Description:
% //        -Create and configurate element options
% //        -Import file (txt) with system configuration
% //    Update History
% =============================================================
%
function pushbutton222_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
if strcmp(idioma,'english')
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Select data file');
else
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Seleccionar archivo');
end

if isnumeric(ruta) || isnumeric(nombre)
    return;
end

datos = importdata(fullfile(ruta,nombre));
if size(datos.textdata,2)~=8
    if strcmp(idioma,'english')
        Aviso('Verify data file','Error','error');
    else
        Aviso('Verificar archivo','Error','error');
    end
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
for i=1:size(datos.textdata,1)
    switch datos.textdata{i,8}
        case 'constante'
            datosControl.tipo='constante';
            datosControl.tasa=datos.data(i);
        case 'variable'
            datosControl.tipo='variable';
            datosControl.tasa=[];
        otherwise
            if strcmp(idioma,'english')
                Aviso('Verify data file','Error','error');
            else
                Aviso('Verificar archivo','Error','error');
            end
            return
    end
        genInfiltration=[genInfiltration,infiltracionSud(length(genInfiltration)+1,'infiltracion')];
        genInfiltration(end)=parametros(genInfiltration(end),str2double(datos.textdata{i,1}),str2double(datos.textdata{i,2})/100,...
            str2double(datos.textdata{i,3})/100,str2double(datos.textdata{i,4})/100,datosControl,str2double(datos.textdata{i,5}),str2double(datos.textdata{i,6}),str2double(datos.textdata{i,7}));
        [Catchment(str2double(datos.textdata{i,1})),estado]=validarSUD(Catchment(str2double(datos.textdata{i,1})),genInfiltration(end));
    if estado==1        
        tablaGenInfiltracion(genInfiltration,handles,'creacion')
        tablaCuencas(Catchment,handles,'edicionSUDS',genInfiltration(end).cuenca);

    else
        if strcmp(idioma,'english')
            Aviso('Verify area','Error','error');
        else
            Aviso('Verificar área','Error','error');
        end
    end
end
if strcmp(idioma,'english')
    Aviso('Operation completed','Success','help');
else
    Aviso('Operación completa','Success','help');
end

save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');

% hObject    handle to pushbutton222 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% SUDS: retention system
% //    Description:
% //        -Create and configurate element options
% //        -Import file (txt) with system configuration
% //    Update History
% =============================================================
%
function pushbutton224_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma

[nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Select data file');
if isnumeric(ruta) || isnumeric(nombre)
    return;
end

datos = importdata(fullfile(ruta,nombre));
if size(datos,2)~=7
    if strcmp(idioma,'english')
        Aviso('Verify data file','Error','error');
    else
        Aviso('Verificar archivo','Error','error');
    end
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');

for i=1:size(datos,1)
        genRetention=[genRetention,retencion(length(genRetention)+1,'retencion')];
        genRetention(end)=parametros(genRetention(end),datos(i,1),datos(i,2)/100,datos(i,3)/100,datos(i,4)/100,datos(i,5),datos(i,6),datos(i,7));
        [Catchment(datos(i,1)),estado]=validarSUD(Catchment(datos(i,1)),genRetention(end));
    if estado==1        
        tablaGenRetencion(genRetention,handles,'creacion')
        tablaCuencas(Catchment,handles,'edicionSUDS',genRetention(end).cuenca);
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
        save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    else
        if strcmp(idioma,'english')
            Aviso('Verify area','Error','error');
        else
            Aviso('Verificar área','Error','error');
        end
    end
end
if strcmp(idioma,'english')
    Aviso('Operation completed','Success','help');
else
    Aviso('Operación completa','Success','help');
end
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
% hObject    handle to pushbutton227 (see GCBO)
% hObject    handle to pushbutton224 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Model construction
% //    Description:
% //        -Import stormwater system 
% //    Update History
% =============================================================
%
function impSystemMat_Callback(hObject, eventdata, handles)

global ProyectoHidrologico modelo idioma
if strcmp(idioma,'english')
    [archivo,carpeta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.mat'],'Select data file');
else
    [archivo,carpeta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.mat'],'Seleccionar archivo');
end

if archivo==0 
    return;
else
    jFrame = get(handle(gcf),'JavaFrame');
    jRootPane = jFrame.fHG2Client.getWindow;
    statusbarObj = com.mathworks.mwswing.MJStatusBar;
    jProgressBar = javax.swing.JProgressBar;
    numIds = 10;
    set(jProgressBar, 'Minimum',0, 'Maximum',numIds, 'Value',0);
    jRootPane.setStatusBarVisible(1);
    statusbarObj.add(jProgressBar,'West');
    
    set(jProgressBar,'Value',1);
    if strcmp(idioma,'english')
        msg = 'Reading file... (10%)';
    else
        msg = 'Cargando archivo... (10%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
       
    axes(handles.axes1)
    cla
    
    set(jProgressBar,'Value',2);
    if strcmp(idioma,'english')
        msg = 'Generating model... (20%)';
    else
        msg = 'Generando modelo... (20%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
    
    modelo.graficoNodos=[];
    modelo.labelNodos=[];
    modelo.graficoTuberias=[];
    modelo.labelTuberias=[];
    Catchment=[];
    modelo.graficoCuencas=[];
    modelo.graficoDCuencas=[];
    modelo.graficoCCuencas=[];
    modelo.labelCuencas=[];
    
    set(jProgressBar,'Value',3);
    if strcmp(idioma,'english')
        msg = 'Creating nodes... (30%)';
    else
        msg = 'Creando nodos... (30%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
    
    Node=[];
    Conduit=[];
    Catchment=[];

    load(fullfile(carpeta,archivo),'Node');
    for i=1:length(Node)
        modelo.graficoNodos=[modelo.graficoNodos,plotNodo(Node(i))];
        modelo.labelNodos=[modelo.labelNodos,plotLabelN(Node(i))];
    end
    tablaNodos(Node,handles,'eliminacion')
    modelo.nodos=length(Node);
    set(jProgressBar,'Value',4);
    if strcmp(idioma,'english')
        msg = 'Creating conduits... (40%)';
    else
        msg = 'Creando tuberías... (40%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
    
    load(fullfile(carpeta,archivo),'Conduit');
    for i=1:length(Conduit)
        modelo.graficoTuberias=[modelo.graficoTuberias,plotTuberia(Conduit(i))];
        modelo.labelTuberias=[modelo.labelTuberias,plotLabelT(Conduit(i))];
        ax = gca;
        VPermutar=ax.Children;
        Orden = TuberiaOrdenGrafico(VPermutar,Catchment,modelo.background);
        ax.Children = ax.Children(Orden);
    end
    tablaTuberias(Conduit,handles,'eliminacion')
    modelo.tuberias=length(Conduit);
    
    set(jProgressBar,'Value',5);
    if strcmp(idioma,'english')
        msg = 'Creating catchment... (50%)';
    else
        msg = 'Creando cuencas... (50%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);
    load(fullfile(carpeta,archivo),'Catchment');

    for i=1:length(Catchment)
        modelo.graficoCuencas=[modelo.graficoCuencas, plotCuenca(Catchment(i))];
        modelo.graficoDCuencas=[modelo.graficoDCuencas,plotDirC(Catchment(i))];
        modelo.graficoCCuencas=[modelo.graficoCCuencas,plotCentroC(Catchment(i))];
        modelo.labelCuencas=[modelo.labelCuencas,plotLabelC(Catchment(i))];
        ax = gca;
        VPermutar=ax.Children;
        Orden = CuencaOrdenGrafico(VPermutar,modelo.background);
        ax.Children = ax.Children(Orden);
    end
    tablaCuencas(Catchment,handles,'eliminacion')
    modelo.cuencas=length(Catchment);
        
    set(jProgressBar,'Value',10);
    if strcmp(idioma,'english')
        msg = 'Operation completed... (100%)';
    else
        msg = 'Operación completada... (100%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);    
 end
pause(0.5)
jRootPane.setStatusBarVisible(0);

axis equal
%     load(fullfile(carpeta,archivo),'Node','Conduit','Catchment','genInfiltration','genDetention','genRetention');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
% hObject    handle to importarRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to impSystemMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function expSystemM_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
if strcmp(idioma,'english')
    nombre = inputdlg({'Save model:'},(''),[1 30],{'Model_1'});
else
    nombre = inputdlg({'Guardar modelo:'},(''),[1 30],{'Model_1'});
end
    
if isempty(nombre)
    if strcmp(idioma,'english')
        Aviso('Enter project name','Error','error');
    else
        Aviso('Nombre del proyecto','Error','error');
    end
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');

save(fullfile(ProyectoHidrologico.carpetaBase,[ProyectoHidrologico.nombreHidrologico,'_',nombre{1},'.mat']),...
    'Node','Conduit','Catchment','genRetention','genDetention','genInfiltration');
if strcmp(idioma,'english')
    Aviso({'The model was exported successfully',['File: ',fullfile(ProyectoHidrologico.carpetaBase,[ProyectoHidrologico.nombreHidrologico,'_',nombre{1},'.mat'])]},'Success','help');
else
    Aviso({'El modelo se exportó exitosamente',['File: ',fullfile(ProyectoHidrologico.carpetaBase,[ProyectoHidrologico.nombreHidrologico,'_',nombre{1},'.mat'])]},'Success','help');
end

% hObject    handle to expSystemM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




%% Model construction
% //    Description:
% //        -Import stormwater system 
% //    Update History
% =============================================================
%
function importSystemShp_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
if strcmp(idioma,'english')
    h=Aviso('The directory must contain the necessary files to configure the model','Info','warn');
    a='Select folder';
else
    h=Aviso('El directorio debe contener los archivos necesarios para configurar el modelo','Info','warn');
    a='Seleccionar carpeta';
end

uiwait(h)

ruta=uigetdir(fullfile(ProyectoHidrologico.carpetaBase),a);

if ruta == 0
    return;
end

jFrame = get(handle(gcf),'JavaFrame');
jRootPane = jFrame.fHG2Client.getWindow;
statusbarObj = com.mathworks.mwswing.MJStatusBar;
jProgressBar = javax.swing.JProgressBar;
numIds = 10;
set(jProgressBar, 'Minimum',0, 'Maximum',numIds, 'Value',0);
jRootPane.setStatusBarVisible(1);
statusbarObj.add(jProgressBar,'West');

set(jProgressBar,'Value',1);
if strcmp(idioma,'english')
    msg = 'Reading files... (10%)';
else
    msg = 'Leyendo archivos... (10%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);
try
    NodosShp = shaperead(fullfile(ruta,'Node.shp'));
    TuberiasShp = shaperead(fullfile(ruta,'Conduit.shp'));
    CuencasShp = shaperead(fullfile(ruta,'Catchment.shp'));
    
    Node=[];
    Conduit=[];
    Catchment=[];
    
    axes(handles.axes1)
    cla
    Xmin=min([NodosShp.X])-10;
    Xmax=max([NodosShp.X])+10;
    Ymin=min([NodosShp.Y])-10;
    Ymax=max([NodosShp.Y])+10;
    axis([Ymin Ymax Xmin Xmax])
    xlim auto
    ylim auto
    axis equal
    zoom(gcf,'reset');

    nodoID=[NodosShp.Node_Id];
    xi=[NodosShp.X];
    yi=[NodosShp.Y];
    elevacionT=[NodosShp.Z];
    elevacionR=[NodosShp.Invert];


    TTexto=str2double(get(handles.tamanoLabelN,'String'));
    SizeObj=str2double(get(handles.tamanoNodo,'String'));
    TextColor=get(handles.colorLabelN,'ForegroundColor');
    Color=get(handles.boxColorN,'BackgroundColor');

    for i=1:size(NodosShp,1)
        Node=[Node,nodoH(length(Node)+1,xi(i),yi(i))];
        Node(end).color=Color;
        Node(end).labelColor=TextColor;
        Node(end).tamano=SizeObj;
        Node(end).fontSize=TTexto;
        Node(end).elevacionT=elevacionT(i);
        Node(end).elevacionR=elevacionR(i);
        Node(end).desnivel=elevacionT(i)-elevacionR(i);
        Node(end).fullDepth=Node(end).desnivel;
        Node(end).XNodo=XNodo(Node(end));
        modelo.graficoNodos=[modelo.graficoNodos,plotNodo(Node(end))];
        modelo.labelNodos=[modelo.labelNodos,plotLabelN(Node(end))];
        
    end

tablaNodos(Node,handles,'eliminacion')
modelo.nodos=length(Node);
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
set(handles.colorNodo,'Enable','on')
set(handles.tamanoNodo,'Enable','on')
set(handles.tamanoLabelN,'Enable','on')
set(handles.colorLabelN,'Enable','on')

set(jProgressBar,'Value',4);
if strcmp(idioma,'english')
    msg = 'Creating nodes... (40%)';
else
    msg = 'Creando nodos... (40%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

tuberiaSeccion={TuberiasShp.Section};
Ni=[TuberiasShp.Node_I];
Nf=[TuberiasShp.Node_F];
L=[TuberiasShp.Length];
n=[TuberiasShp.Roughness];
ERNi=[TuberiasShp.InvertNi];
ERNf=[TuberiasShp.InvertNf];

TTexto=str2double(get(handles.tamanoLabelT,'String'));
SizeObj=str2double(get(handles.tamanoTuberia,'String'));
TextColor=get(handles.colorLabelT,'ForegroundColor');
Color=get(handles.boxColorT,'BackgroundColor');

for i=1:size(TuberiasShp,1)
    Conduit=[Conduit,tuberiaH(length(Conduit)+1,Node(Ni(i)),Node(Nf(i)))];
    Conduit(end).color=Color;
    Conduit(end).labelColor=TextColor;
    Conduit(end).tamano=SizeObj;
    Conduit(end).fontSize=TTexto;
    modelo.graficoTuberias=[modelo.graficoTuberias,plotTuberia(Conduit(end))];
    modelo.labelTuberias=[modelo.labelTuberias,plotLabelT(Conduit(end))];
    ax = gca;
    VPermutar=ax.Children;
    Orden = TuberiaOrdenGrafico(VPermutar,Catchment,modelo.background);
    ax.Children = ax.Children(Orden);
    switch tuberiaSeccion{i}
        case 'circular'
            diametro=[TuberiasShp.Diameter];
            Conduit(end).seccion=seccion('circular',diametro(i));
    end
    Conduit(end).longitud=L(i);
    Conduit(end).modLength=L(i);
    Conduit(end).nodoI=Ni(i);
    Conduit(end).nodoF=Nf(i);
    Conduit(end).n=n(i);
    Conduit(end).ERNi=ERNi(i);
    Conduit(end).ERNf=ERNf(i);
    
    Conduit(end).Sp=(Conduit(end).ERNi-Conduit(end).ERNf)/Conduit(end).longitud;
    Conduit(end).beta=sqrt(Conduit(end).Sp)/Conduit(end).n;
    Conduit(end).offset1=Conduit(end).ERNi- Node(Conduit(end).nodoI).elevacionR;
    Conduit(end).offset2=Conduit(end).ERNf- Node(Conduit(end).nodoF).elevacionR;
    Conduit(end).seccion=getSMax(Conduit(end).seccion);
    Conduit(end).qFull=(1/Conduit(end).n)*Conduit(end).seccion.aFull*sqrt(Conduit(end).Sp)*Conduit(end).seccion.rFull^(2/3);
    Conduit(end).qMax=Conduit(end).seccion.sMax*sqrt(Conduit(end).Sp)/Conduit(end).n;
    Conduit(end).roughFactor = 9.81 * Conduit(end).n^2;
end


tablaTuberias(Conduit,handles,'eliminacion')
modelo.tuberias=length(Conduit);
save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');

set(jProgressBar,'Value',7);
if strcmp(idioma,'english')
    msg = 'Creating conduits... (70%)';
else
    msg = 'Creando tuberías... (70%)';
end

statusbarObj.setText(msg);
jRootPane.setStatusBar(statusbarObj);

set(handles.colorCuenca,'Enable','on')
set(handles.tamanoTuberia,'Enable','on')
set(handles.tamanoLabelT,'Enable','on')
set(handles.colorLabelT,'Enable','on')

cuencaDes=[CuencasShp.Node_Dra];
cuencaX={CuencasShp.X};
cuencaY={CuencasShp.Y};
cuencaA=[CuencasShp.Area];

TTexto=str2double(get(handles.tamanoLabelC,'String'));
TextColor=get(handles.colorLabelC,'ForegroundColor');
Color=get(handles.boxColorC,'BackgroundColor');

    for i=1:size(CuencasShp,1)
        trazo=[cuencaX{i}',cuencaY{i}'];
        trazo(end,:)=[];
        Catchment=[Catchment,cuencaH(length(Catchment)+1,Node(cuencaDes(i)),trazo)];
        Catchment(end).area=cuencaA(i);
        Catchment(end).centroide=centroCuenca(Catchment(end));
        Catchment(end).color=Color;
        Catchment(end).labelColor=TextColor;
        Catchment(end).fontSize=TTexto;
        modelo.graficoCuencas=[modelo.graficoCuencas, plotCuenca(Catchment(end))];
        modelo.graficoDCuencas=[modelo.graficoDCuencas,plotDirC(Catchment(end))];
        modelo.graficoCCuencas=[modelo.graficoCCuencas,plotCentroC(Catchment(end))];
        modelo.labelCuencas=[modelo.labelCuencas,plotLabelC(Catchment(end))];  

        ax = gca;
        VPermutar=ax.Children;
        Orden = CuencaOrdenGrafico(VPermutar,modelo.background);
        ax.Children = ax.Children(Orden);
    end

    delete (h)
    tablaCuencas(Catchment,handles,'eliminacion')
    modelo.cuencas=length(Catchment);
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
    set(jProgressBar,'Value',10);
    if strcmp(idioma,'english')
        msg = 'Creating catchment... (100%)';
    else
        msg = 'Creando cuencas... (100%)';
    end
    
    statusbarObj.setText(msg);
    jRootPane.setStatusBar(statusbarObj);

    set(handles.boxColorC,'Enable','on');
    set(handles.tamanoLabelC,'Enable','on');
    set(handles.colorLabelC,'Enable','on');
    
    set(modelo.labelNodos,'visible','off');
    set(modelo.labelTuberias,'visible','off');
    set(modelo.labelCuencas,'visible','off');
    set(handles.nodosLabel,'Checked','off')
    set(handles.tuberiasLabel,'Checked','off')
    set(handles.cuencasLabel,'Checked','off')
    
    pause(0.5)
    statusbarObj.setText('Finishing... (100%)');
    pause(0.5)
    jRootPane.setStatusBarVisible(0);
catch
    jRootPane.setStatusBarVisible(0);
    if strcmp(idioma,'english')
        Aviso('Verify data file','Error','error');
    else
        Aviso('Verificar archivo','Error','error');
    end    
end
% hObject    handle to importSystemShp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% SUDS: detention system
% //    Description:
% //        -Create and configurate element options
% //        -Import file (txt) with system configuration
% //    Update History
% =============================================================
%
function pushbutton229_Callback(hObject, eventdata, handles)

global ProyectoHidrologico idioma

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
if ~isempty(genDetention)
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Select data file');
    if isnumeric(ruta) || isnumeric(nombre)
        return;
    end
    
    datos = importdata(fullfile(ruta,nombre));
    if mod(size(datos),2)~=0 
        if strcmp(idioma,'english')
            Aviso('Verify data file','Error','error');
        else
            Aviso('Verificar archivo','Error','error');
        end
        return
    end
    
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
    
    for i=1:2:size(datos,2)
        curva=datos(:,i:i+1);
        idSud=curva(1,1);
        curva(1,:)=[];
        genDetention(idSud)=HA(genDetention(idSud),curva);
    end
    if strcmp(idioma,'english')
        Aviso('Operation completed','Success','help');
    else
        Aviso('Operación completa','Success','help');
    end
    
    save(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
else
    if strcmp(idioma,'english')
        Aviso('There are no SUDS in the system','Error','error');
    else
        Aviso('No existen SUDS en el sistema','Error','error');
    end
end
% hObject    handle to pushbutton223 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to pushbutton229 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton99_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton99 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

