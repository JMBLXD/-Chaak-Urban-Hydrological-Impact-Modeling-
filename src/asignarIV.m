function varargout = asignarIV(varargin)
%% asignarIV
% //    Description:
% //        -Set curve elevation-area data
% //    Update History
% =============================================================
%
% ASIGNARIV MATLAB code for asignarIV.fig
%      ASIGNARIV, by itself, creates a new ASIGNARIV or raises the existing
%      singleton*.
%
%      H = ASIGNARIV returns the handle to a new ASIGNARIV or the handle to
%      the existing singleton*.
%
%      ASIGNARIV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASIGNARIV.M with the given input arguments.
%
%      ASIGNARIV('Property','Value',...) creates a new ASIGNARIV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before asignarIV_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to asignarIV_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help asignarIV

% Last Modified by GUIDE v2.5 18-Feb-2024 16:00:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @asignarIV_OpeningFcn, ...
                   'gui_OutputFcn',  @asignarIV_OutputFcn, ...
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


% --- Executes just before asignarIV is made visible.
function asignarIV_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to asignarIV (see VARARGIN)
global idioma
if strcmp(idioma,'english')
    headers = {'<html><center /><font face="Open Sans" size=4><b><i>Time<br />(s)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Infiltration<br />(mm/h)</html>'};
else
    headers = {'<html><center /><font face="Open Sans" size=4><b><i>Tiempo<br />(m)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Infiltración<br/>(mm/h)</html>'};
end
set(handles.uitable1,'ColumnName',headers)
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.asignarIV,'Position');
posicion=[(posicion1(1:2)+posicion1(3:4)/2)-(posicion2(3:4)/2),posicion2(3:4)];
set(handles.asignarIV,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','pond.png'));
jframe.setFigureIcon(jIcon);

set(handles.asignarIV,'visible','on')
% Choose default command line output for asignarIV
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes asignarIV wait for user response (see UIRESUME)
% uiwait(handles.asignarIV);


% --- Outputs from this function are returned to the command line.
function varargout = asignarIV_OutputFcn(hObject, eventdata, handles)
global modelo
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(modelo.bandera.infilCurva)
    set(handles.uitable1,'data',modelo.bandera.infilCurva)
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
curva=zeros(size(datos));
for i=1:size(datos)
    if isnumeric(datos{i,1})
       curva(i,1)=datos{i,1};
    else
        curva(i,1)=str2double(datos{i,1});
    end

    if isnumeric(datos{i,2})
       curva(i,2)=datos{i,2};
    else
        curva(i,2)=str2double(datos{i,2});
    end
end
curva(isnan(curva))=0;

B = sort(curva(:,1),'ascend');
if all(B==curva(:,1))
    modelo.bandera.infilCurva=curva;
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
    plot(datos(:,1),datos(:,2),'DisplayName','Infiltration curve',LineWidth=1.5);
    xlabel('Time (s)')
    ylabel('Infiltration (mm/h)')
    legend
else
    plot(datos(:,1),datos(:,2),'DisplayName','Curva infiltración',LineWidth=1.5);

    xlabel('Tiempo (s)')
    ylabel('Infiltración (mm/h)')
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


% --- Executes when user attempts to close asignarIV.
function asignarIV_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to asignarIV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(hObject);
