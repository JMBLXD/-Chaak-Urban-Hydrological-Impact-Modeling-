function varargout = asignarDescargaGen(varargin)
%% asignarDescargaGen
% //    Description:
% //        -Set discharge control parameters
% //    Update History
% =============================================================
%
% ASIGNARDESCARGAGEN MATLAB code for asignarDescargaGen.fig
%      ASIGNARDESCARGAGEN, by itself, creates a new ASIGNARDESCARGAGEN or raises the existing
%      singleton*.
%
%      H = ASIGNARDESCARGAGEN returns the handle to a new ASIGNARDESCARGAGEN or the handle to
%      the existing singleton*.
%
%      ASIGNARDESCARGAGEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASIGNARDESCARGAGEN.M with the given input arguments.
%
%      ASIGNARDESCARGAGEN('Property','Value',...) creates a new ASIGNARDESCARGAGEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before asignarDescargaGen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to asignarDescargaGen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help asignarDescargaGen

% Last Modified by GUIDE v2.5 26-Jul-2023 02:35:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @asignarDescargaGen_OpeningFcn, ...
                   'gui_OutputFcn',  @asignarDescargaGen_OutputFcn, ...
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


% --- Executes just before asignarDescargaGen is made visible.
function asignarDescargaGen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to asignarDescargaGen (see VARARGIN)
global modelo
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.asignarDescargaGen,'Position');
posicion=[(posicion1(1:2)+posicion1(3:4)/2)-(posicion2(3:4)/2),posicion2(3:4)];
set(handles.asignarDescargaGen,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','discharge.png'));
jframe.setFigureIcon(jIcon);

if ~isempty(modelo.bandera.datosControl)
    control=modelo.bandera.datosControl.tipo;
    switch control
        case 'orificio'
            set(handles.popupmenu3,'value',2)
            set(handles.edit1,'string',modelo.bandera.datosControl.conductos)
            set(handles.edit2,'string',modelo.bandera.datosControl.diametro)
            set(handles.edit3,'string',modelo.bandera.datosControl.cd)
        case 'vertedor'
            set(handles.popupmenu3,'value',3)
            set(handles.edit9,'string',modelo.bandera.datosControl.cresta)
            set(handles.edit10,'string',modelo.bandera.datosControl.longitud)
            set(handles.edit11,'string',modelo.bandera.datosControl.cd)
    end

end
popupmenu3_Callback(hObject, eventdata, handles)
set(handles.asignarDescargaGen,'visible','on');
% Choose default command line output for asignarDescargaGen
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes asignarDescargaGen wait for user response (see UIRESUME)
% uiwait(handles.asignarDescargaGen);


% --- Outputs from this function are returned to the command line.
function varargout = asignarDescargaGen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global modelo
control=get(handles.popupmenu3,'value');

switch control
    case 2
        datosControl.tipo='orificio';
        conductos=str2double(get(handles.edit1,'string'));
        diametro=str2double(get(handles.edit2,'string'));
        cd=str2double(get(handles.edit3,'string'));
        if (isnan(conductos) || conductos < 0 || isnan(diametro) || diametro<0 ||...
                isnan(cd) || cd<0 ||cd>1)
            Aviso('Verificar datos');
            return
        end
        datosControl.conductos=round(conductos);
        datosControl.diametro=diametro;
        datosControl.cd=cd;

    case 3
        datosControl.tipo='vertedor';
        cresta=str2double(get(handles.edit9,'string'));
        longitud=str2double(get(handles.edit10,'string'));
        cd=str2double(get(handles.edit11,'string'));
        if (isnan(cresta) || cresta < 0 || isnan(longitud) || longitud<0 ||...
                isnan(cd) || cd<0 ||cd>1)
            Aviso('Verificar datos');
            return
        end
        datosControl.cresta=cresta;
        datosControl.longitud=longitud;
        datosControl.cd=cd;
    otherwise
        Aviso('Seleccionar tipo de contro');
        return
end

modelo.bandera.datosControl=datosControl;

delete(gcbf);

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
delete(gcbf);

% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
tipo=get(handles.popupmenu3,'value');
switch tipo
    case 2
        set(handles.panelVertedor,'visible','off');
        set(handles.panelOrificio,'visible','on');
    case 3
        set(handles.panelVertedor,'visible','on');
        set(handles.panelOrificio,'visible','off');
    otherwise
        set(handles.panelVertedor,'visible','off');
        set(handles.panelOrificio,'visible','off');
end
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


% --- Executes when user attempts to close asignarDescargaGen.
function asignarDescargaGen_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to asignarDescargaGen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
