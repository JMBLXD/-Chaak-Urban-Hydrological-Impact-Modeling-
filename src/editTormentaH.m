function varargout = editTormentaH(varargin)
%% editTormentaH
% //    Description:
% //        -Edit storm parameters
% //    Update History
% =============================================================
%
% EDITTORMENTAH MATLAB code for edittormentah.fig
%      EDITTORMENTAH, by itself, creates a new EDITTORMENTAH or raises the existing
%      singleton*.
%
%      H = EDITTORMENTAH returns the handle to a new EDITTORMENTAH or the handle to
%      the existing singleton*.
%
%      EDITTORMENTAH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITTORMENTAH.M with the given input arguments.
%
%      EDITTORMENTAH('Property','Value',...) creates a new EDITTORMENTAH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before editTormentaH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to editTormentaH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edittormentah

% Last Modified by GUIDE v2.5 24-Mar-2023 14:59:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @editTormentaH_OpeningFcn, ...
                   'gui_OutputFcn',  @editTormentaH_OutputFcn, ...
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


% --- Executes just before edittormentah is made visible.
function editTormentaH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edittormentah (see VARARGIN)
% Choose default command line output for edittormentah
global modelo idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.editTormentaH,'Position');
posicion=[posicion1(1:2)+posicion1(3:4)/2-posicion2(3:4)/2,posicion2(3:4)];
set(handles.editTormentaH,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','stormT.png'));
jframe.setFigureIcon(jIcon);

set(handles.edit1,'string',num2str(modelo.bandera.k,'%0.3f'));
set(handles.edit2,'string',num2str(modelo.bandera.m,'%0.3f'));
set(handles.edit3,'string',num2str(modelo.bandera.n,'%0.3f'));
set(handles.edit11,'string',num2str(modelo.bandera.b,'%0.3f'));

if ~isempty(modelo.bandera.tr)
    set(handles.edit4,'string',modelo.bandera.tr);
else
    set(handles.edit4,'string',5);
end
if ~isempty(modelo.bandera.duracion)
    set(handles.edit5,'string',modelo.bandera.duracion);
else
    set(handles.edit5,'string',60);
end
if ~isempty(modelo.bandera.dt)
    set(handles.edit6,'string',modelo.bandera.dt);
else
    set(handles.edit6,'string',5);
end
switch modelo.bandera.metodoHietograma
    case 'simetrico'
        set(handles.popupmenu1,'value',2);
    case 'bloques alternos'
        set(handles.popupmenu1,'value',3);
    otherwise
        set(handles.popupmenu1,'value',1);
end

if ~isempty(modelo.bandera.fechaInicio)
    set(handles.edit7,'string',modelo.bandera.fechaInicio);
else
end
if ~isempty(modelo.bandera.horaInicio)
    set(handles.edit8,'string',modelo.bandera.horaInicio);
else
    set(handles.edit8,'string',0);
end
if ~isempty(modelo.bandera.minInicio)
    set(handles.edit10,'string',modelo.bandera.minInicio);
else
    set(handles.edit10,'string',0);
end

if strcmp(idioma,'spanish')
    set(handles.text5,'string','Coeficiente K');
    set(handles.text7,'string','Exponente m');
    set(handles.text9,'string','Exponente n');
    set(handles.text24,'string','Constante b');
    set(handles.text11,'string','Periodo de retorno');
    set(handles.text13,'string','Duración de tormenta');
    set(handles.text15,'string','Intervalo de análisis');
    set(handles.text17,'string','Hietograma');
    set(handles.text18,'string','Fecha de inicio');
    set(handles.text21,'string','Tiempo de inicio');
    set(handles.text12,'string','(años)');
    set(handles.text23,'string','(hora)');
    set(handles.popupmenu1,'string',{'','Simétrico','Bloques alternos'});
end

set(handles.editTormentaH,'visible','on')
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes edittormentah wait for user response (see UIRESUME)
% uiwait(handles.edittormentah);


% --- Outputs from this function are returned to the command line.
function varargout = editTormentaH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.editTormentaH,'visible','on')
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global modelo idioma
K=str2double(get(handles.edit1,'String'));
m=str2double(get(handles.edit2,'String'));
n=str2double(get(handles.edit3,'String'));
tr=str2double(get(handles.edit4,'String'));
duracion=str2double(get(handles.edit5,'String'));
dt=str2double(get(handles.edit6,'String'));
metodoHietograma=get(handles.popupmenu1,'Value');
fecha=get(handles.edit7,'String');
hora=str2double(get(handles.edit8,'String'));
minuto=str2double(get(handles.edit10,'String'));

if isempty(K)||isempty(m)||isempty(n)||isempty(duracion)||isempty(dt)||isempty(tr)||isempty(fecha)||isempty(hora)||isempty(minuto)||metodoHietograma==1
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return;
end

if isnan(K)||isnan(m)||isnan(n)||isnan(duracion)||isnan(dt)||isnan(tr)||isnan(hora)||isnan(minuto)
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return;
end

if K==0||m==0||n==0||duracion==0||dt==0||tr==0
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return;
end

modelo.bandera.tr=tr;
modelo.bandera.duracion=duracion;
modelo.bandera.dt=dt;
switch metodoHietograma
    case 2
        modelo.bandera.metodoHietograma='simetrico';
    case 3
        modelo.bandera.metodoHietograma='bloques alternos';
    otherwise
        modelo.bandera.metodoHietograma='none';
end

    modelo.bandera.k=K;


    modelo.bandera.m=m;


    modelo.bandera.n=n;


modelo.bandera.fechaInicio=fecha;
modelo.bandera.horaInicio=hora;
modelo.bandera.minInicio=minuto;
modelo.bandera = generarHietograma(modelo.bandera);
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


% --- Executes during object deletion, before destroying properties.
function editTormentaH_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to edittormentah (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close edittormentah.
function editTormentaH_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to edittormentah (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(gcbf);
global modelo
modelo.bandera=[];
% Hint: delete(hObject) closes the figure
delete(hObject);



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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
h=handles.edit7;
a=uicalendar2('DestinationUI', {h, 'String'});

f = findobj('tag','editTormentaH');
posicion1=f.Position;
posicion2=a.Position;
posicion=[posicion1(1:2)+posicion1(3:4)/2-posicion2(3:4)/2,posicion2(3:4)];
a.Position=posicion;

% Now wait for the string to be updated
waitfor(h,'String'); 
try
    val1 = get(h,'String');
    if isempty(val1)
        set(handles.edit7,'String','FECHA');
    end
end
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit8_Callback(hObject, eventdata, handles)
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


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
hora=get(handles.slider1,'Value');
hora=hora*23;
set(handles.edit8,'String',hora)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
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


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
min=get(handles.slider2,'Value');
min=min*59;
set(handles.edit10,'String',min)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
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
