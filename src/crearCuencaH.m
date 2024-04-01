function varargout = crearCuencaH(varargin)
%% crearCuencaH
% //    Description:
% //        -Set catchment parameters
% //    Update History
% =============================================================
%
% CREARCUENCAH MATLAB code for crearCuencaH.fig
%      CREARCUENCAH, by itself, creates a new CREARCUENCAH or raises the existing
%      singleton*.
%
%      H = CREARCUENCAH returns the handle to a new CREARCUENCAH or the handle to
%      the existing singleton*.
%
%      CREARCUENCAH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREARCUENCAH.M with the given input arguments.
%
%      CREARCUENCAH('Property','Value',...) creates a new CREARCUENCAH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before crearCuencaH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crearCuencaH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help crearCuencaH

% Last Modified by GUIDE v2.5 22-Aug-2022 18:54:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crearCuencaH_OpeningFcn, ...
                   'gui_OutputFcn',  @crearCuencaH_OutputFcn, ...
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


% --- Executes just before crearCuencaH is made visible.
function crearCuencaH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crearCuencaH (see VARARGIN)
global modelo idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.crearCuenca,'Position');
posicion=[posicion1(1:2)+posicion1(3:4)/2,posicion2(3:4)];
set(handles.crearCuenca,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','cuenca.png'));
jframe.setFigureIcon(jIcon);

if ~isempty(modelo.nodos)&&modelo.nodos~=0
    Tor=cell(1,modelo.nodos);
    for i=1:modelo.nodos
        Tor{i}=['ID-',num2str(i)];
    end
else
    Tor{1}='---';
    set(handles.popupmenu2,'Enable','off')
end
set(handles.popupmenu2,'String',Tor)

if ~isempty(modelo.tormentas)&&modelo.tormentas~=0
    Tor=cell(1,modelo.tormentas);
    for i=1:modelo.tormentas
        Tor{i}=['ID-',num2str(i)];
    end
else
    Tor{1}='---';
    set(handles.popupmenu3,'Enable','off')
end
set(handles.popupmenu3,'String',Tor)

switch modelo.bandera{2}
    case 'creacion'
        set(handles.popupmenu2,'enable','off');
end
modelo.bandera=modelo.bandera{1};

if ~isempty(modelo.bandera.tormenta)
    set(handles.popupmenu3,'value',modelo.bandera.tormenta);
end

if ~isempty(modelo.bandera.infiltracion)
    set(handles.edit20,'string',modelo.bandera.infiltracion.metodo);
else
    set(handles.edit20,'string','');
end

if ~isempty(modelo.bandera.escorrentia)
    set(handles.edit21,'string',modelo.bandera.escorrentia.metodo);
else
    set(handles.edit21,'string','');
end

set(handles.edit1,'string',modelo.bandera.area);
if  ~isempty(modelo.bandera.descarga)&&modelo.bandera.descarga~=0
    set(handles.popupmenu2,'value',modelo.bandera.descarga);
end

if strcmp(idioma,'spanish')
    set(handles.text9,'String','Nodo de  salida');
    set(handles.text2,'String','Área');
    set(handles.text10,'String','Tormenta');
    set(handles.text12,'String','Método de infiltración');
    set(handles.text11,'String','Método de escorrentía');
end

set(handles.crearCuenca,'visible','on')
% Choose default command line output for crearCuencaH
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes crearCuencaH wait for user response (see UIRESUME)
% uiwait(handles.crearCuencaH);


% --- Outputs from this function are returned to the command line.
function varargout = crearCuencaH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global modelo idioma
area=str2double(get(handles.edit1,'string'));
if ~isempty(modelo.tormentas)
    tormenta=get(handles.popupmenu3,'value');
else
    tormenta=[];
end

descarga=get(handles.popupmenu2,'value');

if area<0
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return
elseif isnan(area)
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return
end
modelo.bandera.area=area;
if isempty(modelo.nodos)||modelo.nodos==0
    modelo.bandera.descarga=[];
else
    modelo.bandera.descarga=descarga;
end
modelo.bandera.tormenta=tormenta;

if ~isempty(modelo.bandera.escorrentia)
    switch modelo.bandera.escorrentia.metodo
        case 'Onda-Cinematica' 
            modelo.bandera.escorrentia=areaDrenado(modelo.bandera.escorrentia,modelo.bandera);
    end
end

delete(gcbf)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(gcbf);
global modelo
modelo.bandera=[];
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit1_Callback(hObject, eventdata, handles)
global modelo
area=str2double(get(handles.edit1,'string'));
if area<0 
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    set(handles.edit1,'string','');
    return
elseif isnan(area)
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    set(handles.edit1,'string','');
    return
end
modelo.bandera.area=area;

% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close crearCuencaH.
function crearCuenca_CloseRequestFcn(hObject, eventdata, handles)
global modelo
delete(hObject);
modelo.bandera=[];
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global modelo
editarGeneral(infiltracionFig);
if ~isempty(modelo.bandera.infiltracion)
    set(handles.edit20,'string',modelo.bandera.infiltracion.metodo);
else
    set(handles.edit20,'string','----');
end
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global modelo
editarGeneral(escorrentiaFig);
if ~isempty(modelo.bandera.escorrentia)
    set(handles.edit21,'string',modelo.bandera.escorrentia.metodo);
else
    set(handles.edit21,'string','----');
end
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
