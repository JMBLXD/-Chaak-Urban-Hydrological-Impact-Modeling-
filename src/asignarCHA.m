function varargout = asignarCHA(varargin)
%% asignarCHA
% //    Description:
% //        -Set curve elevation-area data
% //    Update History
% =============================================================
%
% ASIGNARCHA MATLAB code for asignarCHA.fig
%      ASIGNARCHA, by itself, creates a new ASIGNARCHA or raises the existing
%      singleton*.
%
%      H = ASIGNARCHA returns the handle to a new ASIGNARCHA or the handle to
%      the existing singleton*.
%
%      ASIGNARCHA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASIGNARCHA.M with the given input arguments.
%
%      ASIGNARCHA('Property','Value',...) creates a new ASIGNARCHA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before asignarCHA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to asignarCHA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help asignarCHA

% Last Modified by GUIDE v2.5 03-Jan-2024 14:17:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @asignarCHA_OpeningFcn, ...
                   'gui_OutputFcn',  @asignarCHA_OutputFcn, ...
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


% --- Executes just before asignarCHA is made visible.
function asignarCHA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to asignarCHA (see VARARGIN)
global idioma
if strcmp(idioma,'english')
    headers = {'<html><center /><font face="Open Sans" size=4><b><i>Elevation<br />(m)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Area<br />(m2)</html>'};
else
    headers = {'<html><center /><font face="Open Sans" size=4><b><i>Elevación<br />(m)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Área<br/>(m2)</html>'};
end
set(handles.uitable1,'ColumnName',headers)
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.asignarCHA,'Position');
posicion=[(posicion1(1:2)+posicion1(3:4)/2)-(posicion2(3:4)/2),posicion2(3:4)];
set(handles.asignarCHA,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','pond.png'));
jframe.setFigureIcon(jIcon);

set(handles.asignarCHA,'visible','on')
% Choose default command line output for asignarCHA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes asignarCHA wait for user response (see UIRESUME)
% uiwait(handles.asignarCHA);


% --- Outputs from this function are returned to the command line.
function varargout = asignarCHA_OutputFcn(hObject, eventdata, handles)
global modelo
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(modelo.bandera.curvaHA)
    set(handles.uitable1,'data',modelo.bandera.curvaHA)
end

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
if strcmp(idioma,'english')
    [nombre,ruta]=uigetfile('*.txt',fullfile(ProyectoHidrologico.carpetaBase),'Select data file');
else
    [nombre,ruta]=uigetfile('*.txt',fullfile(ProyectoHidrologico.carpetaBase),'Seleccionar archivo');
end
if isnumeric(ruta) || isnumeric(nombre)
    return;
end

datos = importdata(fullfile(ruta,nombre));

datos(isnan(datos))=[];
if ~isempty(datos)||size(datos,2)==2
    data=cell(size(datos));
    for i=1:size(data,1)
        data{i,1}=datos(i,1);
        data{i,2}=datos(i,2);
    end
    set(handles.uitable1,'data',data)
else
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar dato','Error','error');
    end
end

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
data=get(handles.uitable1,'data');
if isempty(data)
    return
end
Tor=cell(1,size(data,1));
for i=1:size(data,1)
    Tor{i}=[num2str(i)];
end
Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Row','SelectionMode','single');

if ~isempty(Z)
    data(Z,:)=[];
    set(handles.uitable1,'data',data)
end
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
data=get(handles.uitable1,'data');
if iscell(data)
    add={'',''};
else
    add=[0,0];
end
% add={'',''};
data=[data;add];
set(handles.uitable1,'data',data)

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)

% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global  modelo idioma

datos=get(handles.uitable1,'data');
curvaHA=zeros(size(datos));
for i=1:size(datos)
    if isnumeric(datos{i,1})
       curvaHA(i,1)=datos{i,1};
    else
        curvaHA(i,1)=str2double(datos{i,1});
    end

    if isnumeric(datos{i,2})
       curvaHA(i,2)=datos{i,2};
    else
        curvaHA(i,2)=str2double(datos{i,2});
    end
end
curvaHA(isnan(curvaHA))=0;

B = sort(curvaHA(:,1),'ascend');
if all(B==curvaHA(:,1))
    modelo.bandera=HA(modelo.bandera,curvaHA);
    delete(gcbf)
else
    if strcmp(idioma,'english')
        Aviso('Verify curve data','Error','error');
    else
        Aviso('Verificar curva','Error','error');
    end  
end
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
delete(gcbf);
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global idioma
datos=get(handles.uitable1,'data');
if isempty(datos)
    if strcmp(idioma,'english')
        Aviso('No data','Error','error');
    else
         Aviso('Sin datos','Error','error');
    end 
   
    return
end
f=figure;
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(f,'Position');
posicion=[(posicion1(1:2)+posicion1(3:4)/2)-(posicion2(3:4)/2),posicion2(3:4)];
f.Position=posicion;
hold on

if strcmp(idioma,'english')
    plot(datos(:,1),datos(:,2),'DisplayName','Elevation-Area curve',LineWidth=1.5);
    xlabel('Elevation (m)')
    ylabel('Area (m^{2})')
    legend
else
    plot(datos(:,1),datos(:,2),'DisplayName','Curva Área-Elevación',LineWidth=1.5);

    xlabel('Elevación (m)')
    ylabel('Área (m^{2})')
    legend
end 

axes1 = gca;
axes1.FontName='Open Sans';
axes1.FontUnits='points';
axes1.FontSize=9;
axes1.XGrid='on';
axes1.YGrid='on';


% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close asignarCHA.
function asignarCHA_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to asignarCHA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(hObject);
