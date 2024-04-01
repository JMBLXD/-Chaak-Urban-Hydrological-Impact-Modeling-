function varargout = crearGenInfiltracion(varargin)
%% crearGenInfiltracion
% //    Description:
% //        -Set infiltration suds parameters
% //    Update History
% =============================================================
%
% CREARGENINFILTRACION MATLAB code for crearGenInfiltracion.fig
%      CREARGENINFILTRACION, by itself, creates a new CREARGENINFILTRACION or raises the existing
%      singleton*.
%
%      H = CREARGENINFILTRACION returns the handle to a new CREARGENINFILTRACION or the handle to
%      the existing singleton*.
%
%      CREARGENINFILTRACION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREARGENINFILTRACION.M with the given input arguments.
%
%      CREARGENINFILTRACION('Property','Value',...) creates a new CREARGENINFILTRACION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before crearGenInfiltracion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crearGenInfiltracion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help crearGenInfiltracion

% Last Modified by GUIDE v2.5 28-Jul-2023 00:28:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crearGenInfiltracion_OpeningFcn, ...
                   'gui_OutputFcn',  @crearGenInfiltracion_OutputFcn, ...
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


% --- Executes just before crearGenInfiltracion is made visible.
function crearGenInfiltracion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crearGenInfiltracion (see VARARGIN)
global modelo idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.crearGenInfiltracion,'Position');
posicion=[(posicion1(1:2)+posicion1(3:4)/2)-(posicion2(3:4)/2),posicion2(3:4)];
set(handles.crearGenInfiltracion,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','pond.png'));
jframe.setFigureIcon(jIcon);

if ~isempty(modelo.cuencas)&&modelo.cuencas~=0
    Tor=cell(1,modelo.cuencas+1);
    Tor{1}='';
    for i=2:modelo.cuencas+1
        Tor{i}=[num2str(i-1)];
    end
else
    Tor{1}='---';
    set(handles.popupmenu1,'Enable','off')
end
set(handles.popupmenu1,'String',Tor)

set(handles.edit1,'string',modelo.bandera.areaConectada*100);
set(handles.edit2,'string',modelo.bandera.permeable*100);
set(handles.edit3,'string',modelo.bandera.impermeable*100);
set(handles.edit6,'string',modelo.bandera.superficie);
set(handles.edit4,'string',modelo.bandera.infilMax);
set(handles.edit5,'string',modelo.bandera.captacion);
if ~isempty(modelo.bandera.cuenca)
    set(handles.popupmenu1,'value',modelo.bandera.cuenca+1);
    set(handles.popupmenu1,'Enable','off');
end
if ~isempty(modelo.bandera.control)
    switch modelo.bandera.control
        case 'constante'
            set(handles.popupmenu2,'value',2);
            set(handles.edit7,'string',modelo.bandera.infilTasa);
        case 'variable'
            set(handles.popupmenu2,'value',3);
            set(handles.popupmenu2,'value',1);
        otherwise
            set(handles.popupmenu2,'value',1);
    end
    popupmenu2_Callback(hObject, eventdata, handles)
end

if strcmp(idioma,'spanish')
    set(handles.crearGenInfiltracion,'Name','Infiltración');
    set(handles.text2,'string','Cuenca asociada');
    set(handles.text4,'string','Área asociada');
    set(handles.text6,'string','Porción permeable');
    set(handles.text8,'string','Porción impermeable');
    set(handles.text14,'string','Superficie');
    set(handles.text10,'string','Máxima infiltración');
    set(handles.text12,'string','Coeficiente de captura');
    set(handles.text11,'string','Control de infiltración');
    set(handles.text9,'string','Curva de infiltración');
    set(handles.popupmenu2,'string',{'','Constante','Variable'});
end
set(handles.crearGenInfiltracion,'visible','on');
% Choose default command line output for crearGenInfiltracion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes crearGenInfiltracion wait for user response (see UIRESUME)
% uiwait(handles.crearGenInfiltracion);


% --- Outputs from this function are returned to the command line.
function varargout = crearGenInfiltracion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global modelo idioma
cuenca=get(handles.popupmenu1,'value')-1;
areaConectada=str2double(get(handles.edit1,'string'))/100;
permeable=str2double(get(handles.edit2,'string'))/100;
impermeable=str2double(get(handles.edit3,'string'))/100;
superficie=str2double(get(handles.edit6,'string'));
infilMax=str2double(get(handles.edit4,'string'));
captacion=str2double(get(handles.edit5,'string'));
control=get(handles.popupmenu2,'value');
if control==2
    datosControl.tipo='constante';
    datosControl.tasa=str2double(get(handles.edit7,'string'));
    if isnan(datosControl.tasa) || datosControl.tasa<0
        datosControl.tasa=[];
    end
elseif control==3
    datosControl.tipo='variable';
    if isempty(modelo.bandera.infilCurva)
        datosControl.tasa=[];
    else
        datosControl.tasa=modelo.bandera.infilCurva;
    end
end
if (cuenca==0 || areaConectada > 1 || areaConectada < 0 || isnan(areaConectada)...
    ||permeable > 1 || permeable < 0 || isnan(permeable) || impermeable > 1 || impermeable < 0 || isnan(impermeable)...
    || superficie < 0 || isnan(superficie)|| captacion > 1 || captacion < 0 || isnan(captacion) ...
    || infilMax < 0 || isnan(infilMax) || isempty(datosControl.tasa) || control==1)

    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar dato','Error','error');
    end
    return

end

modelo.bandera=parametros(modelo.bandera,cuenca,areaConectada,permeable,impermeable,datosControl,superficie,infilMax,captacion);

delete(gcbf)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
delete(gcbf);
global modelo
modelo.bandera=[];
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global modelo idioma
cuenca=get(handles.popupmenu1,'value')-1;
if cuenca~=0
    areaC=str2double(get(handles.edit1,'string'));
    if isnan(areaC) || areaC<0
        areaC=0;
        pp=0;
        pimp=0;
    else
        pp=str2double(get(handles.edit2,'string'));
        pimp=str2double(get(handles.edit3,'string'));
    end
    modelo.bandera.cuenca=cuenca;
    modelo.bandera.areaConectada=areaC/100;
    modelo.bandera.permeable=pp/100;
    modelo.bandera.impermeable=pimp/100;
    editarGeneral(asignarAreasGen);
    set(handles.edit1,'string',modelo.bandera.areaConectada*100)
    set(handles.edit2,'string',modelo.bandera.permeable*100)
    set(handles.edit3,'string',modelo.bandera.impermeable*100)
else
    if strcmp(idioma,'english')
        Aviso('Select catchment','Error','error');
    else
        Aviso('Seleccionar cuenca','Error','error');
    end
end
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
cuencaID=get(handles.popupmenu1,'value')-1;
if cuencaID<1
    if strcmp(idioma,'english')
        Aviso('Select catchment','Error','error');
    else
        Aviso('Seleccionar cuenca','Error','error');
    end
    return
end
if isempty(Catchment(cuencaID).escorrentia)
    if strcmp(idioma,'english')
        Aviso('Catchment does not have a runoff method','Error','error');
    else
        Aviso('La cuenca seleccionada no tiene asignado ningun método de escorrentía','Error','error');
    end 
    set(handles.popupmenu1,'value',1);
    return
end
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
global idioma
valor=get(handles.popupmenu2,'value');
switch valor
    case 2
        if strcmp(idioma,'english')
            set(handles.text9,'string','Infiltration rate');
        else
            set(handles.text9,'string','Tasa de infiltración');
        end
        
        set(handles.text9,'visible','on');
        set(handles.edit7,'visible','on');
        set(handles.text16,'visible','on');
        set(handles.pushbutton2,'visible','off');
        set(handles.checkbox2,'visible','off');
    case 3
        if strcmp(idioma,'english')
            set(handles.text9,'string','Infiltration curve');
        else
            set(handles.text9,'string','Curva de infiltración');
        end
        
        set(handles.text9,'visible','on');
        set(handles.edit7,'visible','off');
        set(handles.text16,'visible','off');
        set(handles.pushbutton2,'visible','on');
        set(handles.checkbox2,'visible','on');
    otherwise
        set(handles.text9,'visible','off');
        set(handles.edit7,'visible','off');
        set(handles.text16,'visible','off');
        set(handles.pushbutton2,'visible','off');
        set(handles.checkbox2,'visible','off');
end
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global modelo
editarGeneral(asignarIV);

if isempty(modelo.bandera.infilCurva)
    set(handles.checkbox2,'value',0);
else
    set(handles.checkbox2,'value',1);
end
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
valor=get(handles.checkbox2,'value');
if valor
    set(handles.checkbox2,'value',0);
else
    set(handles.checkbox2,'value',1);
end
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close crearGenInfiltracion.
function crearGenInfiltracion_CloseRequestFcn(hObject, eventdata, handles)
delete(gcbf);
global modelo
modelo.bandera=[];
% hObject    handle to crearGenInfiltracion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
