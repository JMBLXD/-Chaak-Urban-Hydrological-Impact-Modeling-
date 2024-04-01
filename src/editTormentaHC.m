function varargout = editTormentaHC(varargin)
%% editTormentaHC
% //    Description:
% //        -Edit storm parameters
% //    Update History
% =============================================================
%
% EDITTORMENTAHC MATLAB code for edittormentahc.fig
%      EDITTORMENTAHC, by itself, creates a new EDITTORMENTAHC or raises the existing
%      singleton*.
%
%      H = EDITTORMENTAHC returns the handle to a new EDITTORMENTAHC or the handle to
%      the existing singleton*.
%
%      EDITTORMENTAHC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITTORMENTAHC.M with the given input arguments.
%
%      EDITTORMENTAHC('Property','Value',...) creates a new EDITTORMENTAHC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before editTormentaHC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to editTormentaHC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edittormentahc

% Last Modified by GUIDE v2.5 09-Sep-2022 22:23:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @editTormentaHC_OpeningFcn, ...
                   'gui_OutputFcn',  @editTormentaHC_OutputFcn, ...
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


% --- Executes just before edittormentahc is made visible.
function editTormentaHC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edittormentahc (see VARARGIN)
% Choose default command line output for edittormentahc
global modelo idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.editTormentaHC,'Position');
posicion=[posicion1(1:2)+posicion1(3:4)/2-posicion2(3:4)/2,posicion2(3:4)];
set(handles.editTormentaHC,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','stormT.png'));
jframe.setFigureIcon(jIcon);

if strcmp(idioma,'english')
    headers = {'<html><center /><font face="Open Sans" size=4><b><i>Time<br/>(min)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Precipitation<br />(mm)</html>'};
else
    headers = {'<html><center /><font face="Open Sans" size=4><b><i>Tiempo<br/>(min)</html>',...
    '<html><center /><font face="Open Sans" size=4><b><i>Precipitación<br />(mm)</html>'};
end

set(handles.uitable1,'ColumnName',headers)

if ~isempty(modelo.bandera.tr)
    set(handles.edit4,'string',modelo.bandera.tr);
else
    set(handles.edit4,'string',5);
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

if ~isempty(modelo.bandera.hietograma)
    set(handles.uitable1,'data',modelo.bandera.hietograma)
else
    set(handles.uitable1,'data',{})
end

if strcmp(idioma,'spanish')
    set(handles.text11,'String','Periodo de retorno');
    set(handles.text18,'String','Fecha de inicio');
    set(handles.text21,'String','Tiempo de inicio');
    set(handles.text12,'String','(años)');
    set(handles.text23,'String','(hora)');
end

set(handles.editTormentaHC,'visible','on')
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes edittormentahc wait for user response (see UIRESUME)
% uiwait(handles.edittormentahc);


% --- Outputs from this function are returned to the command line.
function varargout = editTormentaHC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.editTormentaHC,'visible','on')
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global modelo idioma
try
tr=str2double(get(handles.edit4,'String'));
fecha=get(handles.edit7,'String');
hora=str2double(get(handles.edit8,'String'));
minuto=str2double(get(handles.edit10,'String'));
info=get(handles.uitable1,'data');
info=get(handles.uitable1,'data');
for i=1:size(info,1)
    datos(i,1)=info{i,1};
    datos(i,2)=info{i,2};
end
if isempty(tr)||isempty(fecha)||isempty(hora)||isempty(minuto)||isempty(datos)
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return;
end

if isnan(tr)||isnan(hora)||isnan(minuto)
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return;
end

if tr==0
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return;
end

% ID=modelo.bandera{2};
% tipo=modelo.bandera{1};
% tormenta=tormentaH(ID,tipo,tr,datos,fecha,hora,minuto);
% 
% modelo.bandera=tormenta;

modelo.bandera.tr=tr;
modelo.bandera.hietograma=datos;
modelo.bandera.fechaInicio=fecha;
modelo.bandera.horaInicio=hora;
modelo.bandera.minInicio=minuto;
modelo.bandera.duracion=modelo.bandera.hietograma(end,1);
modelo.bandera.dt=modelo.bandera.hietograma(2,1)-modelo.bandera.hietograma(1,1);

modelo.bandera = generarHietograma(modelo.bandera);
delete(gcbf)
catch
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return
end
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
delete(gcbf);
global modelo
% Aviso('Error, no se asignó periodo de retorno');
modelo.bandera='';
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
function editTormentaHC_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to edittormentahc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close edittormentahc.
function editTormentaHC_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to edittormentahc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global red
delete(hObject);
red.bandera='';
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
uicalendar2('DestinationUI', {h, 'String'});
% Now wait for the string to be updated
waitfor(h,'String'); 
val1 = get(h,'String');
if isempty(val1)
    set(handles.edit7,'String','Fecha');
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


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
global idioma
if strcmp(idioma,'english')
    [nombre,ruta]=uigetfile('*.txt','Select file');
else
    [nombre,ruta]=uigetfile('*.txt','Seleccionar archivo');
end

if nombre==0
    return
end
R_archivo=[ruta,nombre];
num = importdata(R_archivo);
if size(num,2)~=2
    if strcmp(idioma,'english')
        Aviso('Verify data file','Error','error');
    else
        Aviso('Verificar archivo','Error','error');
    end
    return
end
Datos=cell(size(num,1),size(num,2));
for i=1:size(num,1)
    for j=1:size(num,2)
        Datos{i,j}=num(i,j);
    end
end
set(handles.uitable1,'Data',Datos)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
global idioma
figure
info=get(handles.uitable1,'data');
for i=1:size(info,1)
    if ~isempty(info{i,1})
        datos(i,1)=info{i,1};
    else
        datos(i,1)=0;
    end
    if ~isempty(info{i,2})
        datos(i,2)=info{i,2};
    else
        datos(i,2)=0;
    end
end
bar(datos(:,1),datos(:,2));
grid on
grid minor
if strcmp(idioma,'english')
    xlabel('Storm duration (min)');
    ylabel('Precipitation (mm)');
else
    xlabel('Duración de tormenta (min)');
    ylabel('Precipitación (mm)');
end

set(gca,'FontSize',8,'FontUnits','pixels','FontWeight','bold','XGrid',...
'on','YGrid','on');

ylim(gca,[0 max(datos(:,2))*1.1]);
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
tablap=get(handles.uitable1,'Data');
tablap(end+1,:)={'' ''};
set(handles.uitable1,'Data',tablap);
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
