function varargout = crearGenRetencion(varargin)
%% crearGenRetencion
% //    Description:
% //        -Set retention suds parameters
% //    Update History
% =============================================================
%
% CREARGENRETENCION MATLAB code for crearGenRetencion.fig
%      CREARGENRETENCION, by itself, creates a new CREARGENRETENCION or raises the existing
%      singleton*.
%
%      H = CREARGENRETENCION returns the handle to a new CREARGENRETENCION or the handle to
%      the existing singleton*.
%
%      CREARGENRETENCION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREARGENRETENCION.M with the given input arguments.
%
%      CREARGENRETENCION('Property','Value',...) creates a new CREARGENRETENCION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before crearGenRetencion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crearGenRetencion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help crearGenRetencion

% Last Modified by GUIDE v2.5 04-Jan-2024 19:52:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crearGenRetencion_OpeningFcn, ...
                   'gui_OutputFcn',  @crearGenRetencion_OutputFcn, ...
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


% --- Executes just before crearGenRetencion is made visible.
function crearGenRetencion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crearGenRetencion (see VARARGIN)
global modelo idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.crearGenRetencion,'Position');
posicion=[(posicion1(1:2)+posicion1(3:4)/2)-(posicion2(3:4)/2),posicion2(3:4)];
set(handles.crearGenRetencion,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','tanque.png'));
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

set(handles.edit5,'string',modelo.bandera.areaConectada*100);
set(handles.edit6,'string',modelo.bandera.permeable*100);
set(handles.edit7,'string',modelo.bandera.impermeable*100);
set(handles.edit8,'string',modelo.bandera.volumenTotal);
set(handles.edit9,'string',modelo.bandera.capacidadInicial*100);
set(handles.edit10,'string',modelo.bandera.captacion);
if ~isempty(modelo.bandera.cuenca)
    set(handles.popupmenu1,'value',modelo.bandera.cuenca+1);
    set(handles.popupmenu1,'Enable','off');
end

if strcmp(idioma,'spanish')
    set(handles.crearGenRetencion,'Name','Retención');
    set(handles.text8,'string','Cuenca asociada');
    set(handles.text10,'string','Área asociada');
    set(handles.text12,'string','Porción permeable');
    set(handles.text14,'string','Porción impermeable');
    set(handles.text16,'string','Capacidad volumétrica');
    set(handles.text18,'string','Ocupación inicial');
    set(handles.text20,'string','Coeficiente de captura');
end
set(handles.crearGenRetencion,'visible','on');

% Choose default command line output for crearGenRetencion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes crearGenRetencion wait for user response (see UIRESUME)
% uiwait(handles.crearGenRetencion);


% --- Outputs from this function are returned to the command line.
function varargout = crearGenRetencion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global modelo idioma

cuenca=get(handles.popupmenu1,'value')-1;
areaConectada=str2double(get(handles.edit5,'string'))/100;
permeable=str2double(get(handles.edit6,'string'))/100;
impermeable=str2double(get(handles.edit7,'string'))/100;
volumen=str2double(get(handles.edit8,'string'));
capacidadInicial=str2double(get(handles.edit9,'string'))/100;
captacion=str2double(get(handles.edit10,'string'));

if (cuenca==0 || areaConectada > 1 || areaConectada < 0 || isnan(areaConectada)...
    ||permeable > 1 || permeable < 0 || isnan(permeable) || impermeable > 1 || impermeable < 0 || isnan(impermeable)...
    || volumen < 0 || isnan(volumen) || capacidadInicial > 1 || capacidadInicial < 0 || isnan(capacidadInicial)...
    || captacion > 1 || captacion < 0 || isnan(captacion))
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar dato','Error','error');
    end
    return

end

modelo.bandera=parametros(modelo.bandera,cuenca,areaConectada,permeable,impermeable,volumen,capacidadInicial,captacion);

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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global modelo idioma
cuenca=get(handles.popupmenu1,'value')-1;
if cuenca~=0
    areaC=str2double(get(handles.edit5,'string'));
    if isnan(areaC) || areaC<0
        areaC=0;
        pp=0;
        pimp=0;
    else
        pp=str2double(get(handles.edit6,'string'));
        pimp=str2double(get(handles.edit7,'string'));
    end
    modelo.bandera.cuenca=cuenca;
    modelo.bandera.areaConectada=areaC/100;
    modelo.bandera.permeable=pp/100;
    modelo.bandera.impermeable=pimp/100;
    editarGeneral(asignarAreasGen);
    set(handles.edit5,'string',modelo.bandera.areaConectada*100)
    set(handles.edit6,'string',modelo.bandera.permeable*100)
    set(handles.edit7,'string',modelo.bandera.impermeable*100)
else
    if strcmp(idioma,'english')
        Aviso('Select catchment','Error','error');
    else
        Aviso('Seleccionar cuenca','Error','error');
    end
end
% hObject    handle to pushbutton3 (see GCBO)
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



function edit8_Callback(hObject, eventdata, handles)
global idioma
cap=str2double(get(handles.edit8,'string'));
if isnan(cap) || cap <= 0
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar dato','Error','error');
    end
    set(handles.edit8,'string','')
    return
end
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
global idioma
in=str2double(get(handles.edit9,'string'));
if isnan(in) || in < 0 || in > 100
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar dato','Error','error');
    end
    set(handles.edit9,'string','')
    return
end
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



function edit10_Callback(hObject, eventdata, handles)
global idioma
cap=str2double(get(handles.edit10,'string'));
if isnan(cap) || cap <= 0 || cap > 1
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar dato','Error','error');
    end
    set(handles.edit10,'string','')
    return
end
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


% --- Executes when user attempts to close crearGenRetencion.
function crearGenRetencion_CloseRequestFcn(hObject, eventdata, handles)
global modelo
delete(hObject);
modelo.bandera=[];
% Hint: delete(hObject) closes the figure
