function varargout = crearGenDetencion(varargin)
%% crearGenDetencion
% //    Description:
% //        -Set detention suds parameters
% //    Update History
% =============================================================
%
% CREARGENDETENCION MATLAB code for crearGenDetencion.fig
%      CREARGENDETENCION, by itself, creates a new CREARGENDETENCION or raises the existing
%      singleton*.
%
%      H = CREARGENDETENCION returns the handle to a new CREARGENDETENCION or the handle to
%      the existing singleton*.
%
%      CREARGENDETENCION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREARGENDETENCION.M with the given input arguments.
%
%      CREARGENDETENCION('Property','Value',...) creates a new CREARGENDETENCION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before crearGenDetencion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crearGenDetencion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help crearGenDetencion

% Last Modified by GUIDE v2.5 26-Jul-2023 22:06:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crearGenDetencion_OpeningFcn, ...
                   'gui_OutputFcn',  @crearGenDetencion_OutputFcn, ...
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


% --- Executes just before crearGenDetencion is made visible.
function crearGenDetencion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crearGenDetencion (see VARARGIN)
global modelo idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.crearGenDetencion,'Position');
posicion=[(posicion1(1:2)+posicion1(3:4)/2)-(posicion2(3:4)/2),posicion2(3:4)];
set(handles.crearGenDetencion,'Position',posicion)

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
set(handles.crearGenDetencion,'visible','on');

set(handles.edit1,'string',modelo.bandera.areaConectada*100);
set(handles.edit2,'string',modelo.bandera.permeable*100);
set(handles.edit3,'string',modelo.bandera.impermeable*100);
set(handles.edit6,'string',modelo.bandera.hInicial);
set(handles.edit7,'string',modelo.bandera.captacion);
if ~isempty(modelo.bandera.cuenca)
    set(handles.popupmenu1,'value',modelo.bandera.cuenca+1);
    set(handles.popupmenu1,'Enable','off');
end
if ~isempty(modelo.bandera.datosControl)
    set(handles.checkbox1,'value',1);
end
if ~isempty(modelo.bandera.curvaHA)
    set(handles.checkbox2,'value',1);
end

if strcmp(idioma,'spanish')
    set(handles.crearGenDetencion,'Name','Detención');
    set(handles.text2,'string','Cuenca asociada');
    set(handles.text4,'string','Área asociada');
    set(handles.text6,'string','Porción permeable');
    set(handles.text8,'string','Porción impermeable');
    set(handles.text14,'string','Control de descarga');
    set(handles.text12,'string','Curva área-elevación');
    set(handles.text13,'string','Elevación inicial del agua');
    set(handles.text15,'string','Coeficiente de captura');
end

set(handles.crearGenDetencion,'visible','on');
% Choose default command line output for crearGenDetencion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes crearGenDetencion wait for user response (see UIRESUME)
% uiwait(handles.crearGenDetencion);


% --- Outputs from this function are returned to the command line.
function varargout = crearGenDetencion_OutputFcn(hObject, eventdata, handles) 
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
hInicial=str2double(get(handles.edit6,'string'));
captacion=str2double(get(handles.edit7,'string'));
control=get(handles.checkbox1,'value');
curva=get(handles.checkbox2,'value');
if (cuenca==0 || areaConectada > 1 || areaConectada < 0 || isnan(areaConectada)...
    ||permeable > 1 || permeable < 0 || isnan(permeable) || impermeable > 1 || impermeable < 0 || isnan(impermeable)...
    || hInicial < 0 || isnan(hInicial)|| captacion > 1 || captacion < 0 || isnan(captacion) ||...
    isempty(modelo.bandera.datosControl)|| isempty(modelo.bandera.curvaHA) || ~control || ~curva)
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar dato','Error','error');
    end
    return

end

modelo.bandera=parametros(modelo.bandera,cuenca,areaConectada,permeable,impermeable,modelo.bandera.datosControl,captacion,hInicial);

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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global modelo
editarGeneral(asignarCHA);

if isempty(modelo.bandera.curvaHA)
    set(handles.checkbox2,'value',0);
else
    set(handles.checkbox2,'value',1);
end
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes when user attempts to close crearGenDetencion.
function crearGenDetencion_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to crearGenDetencion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global modelo
delete(hObject);
modelo.bandera=[];
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
global modelo
editarGeneral(asignarDescargaGen);
if isempty(modelo.bandera.datosControl)
    set(handles.checkbox1,'value',0);
else
    set(handles.checkbox1,'value',1);
end
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
valor=get(handles.checkbox1,'value');
if valor
    set(handles.checkbox1,'value',0);
else
    set(handles.checkbox1,'value',1);
end
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


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
