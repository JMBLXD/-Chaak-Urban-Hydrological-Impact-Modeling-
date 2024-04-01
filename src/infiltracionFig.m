function varargout = infiltracionFig(varargin)
%% infiltracionFig
% //    Description:
% //        -Assign infiltration method 
% //    Update History
% =============================================================
%
% INFILTRACIONFIG MATLAB code for infiltracionFig.fig
%      INFILTRACIONFIG, by itself, creates a new INFILTRACIONFIG or raises the existing
%      singleton*.
%
%      H = INFILTRACIONFIG returns the handle to a new INFILTRACIONFIG or the handle to
%      the existing singleton*.
%
%      INFILTRACIONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INFILTRACIONFIG.M with the given input arguments.
%
%      INFILTRACIONFIG('Property','Value',...) creates a new INFILTRACIONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before infiltracionFig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to infiltracionFig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help infiltracionFig

% Last Modified by GUIDE v2.5 24-Aug-2022 23:57:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @infiltracionFig_OpeningFcn, ...
                   'gui_OutputFcn',  @infiltracionFig_OutputFcn, ...
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


% --- Executes just before infiltracionFig is made visible.
function infiltracionFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to infiltracionFig (see VARARGIN)
global idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.infiltracionFig,'Position');
posicion=[posicion1(1:2)+posicion1(3:4)/2,posicion2(3:4)];
set(handles.infiltracionFig,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','soilT.png'));
jframe.setFigureIcon(jIcon);

if strcmp(idioma,'spanish')
    set(handles.text26,'string','Método');
    set(handles.text22,'string','Número de curva');
    set(handles.popupmenu1,'string',{'SCS-NC','SCS-Modificado'});
end
set(handles.infiltracionFig,'visible','on')
% Choose default command line output for infiltracionFig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes infiltracionFig wait for user response (see UIRESUME)
% uiwait(handles.infiltracionFig);


% --- Outputs from this function are returned to the command line.
function varargout = infiltracionFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global modelo


if ~isempty(modelo.bandera.infiltracion)
    switch modelo.bandera.infiltracion.metodo
        case 'SCS-NC'
            set(handles.popupmenu1,'value',1);
        case 'SCS-Modificado'
            set(handles.popupmenu1,'value',2);    
    end
    set(handles.edit12,'string',modelo.bandera.infiltracion.NC);
end

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global modelo idioma
NC=str2double(get(handles.edit12,'string'));
if isnan(NC)||isempty(NC) || NC==0
    if strcmp(idioma,'english')
        Aviso('Verify curve number','Error','error');
    else
        Aviso('Verificar número de curva','Error','error');
    end
    return
end
switch get(handles.popupmenu1,'value')
    case 1
        modelo.bandera.infiltracion=infiltracionNC('SCS-NC',NC);
    case 2
        modelo.bandera.infiltracion=infiltracionNC('SCS-Modificado',NC);
end
delete(gcbf)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(gcbf);
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit1220 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1220 as text
%        str2double(get(hObject,'String')) returns contents of edit1220 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1220 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
