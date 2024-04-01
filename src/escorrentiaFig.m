function varargout = escorrentiaFig(varargin)
%% escorrentiaFig
% //    Description:
% //        -Set runoff parameters
% //    Update History
% =============================================================
%
% ESCORRENTIAFIG MATLAB code for escorrentiaFig.fig
%      ESCORRENTIAFIG, by itself, creates a new ESCORRENTIAFIG or raises the existing
%      singleton*.
%
%      H = ESCORRENTIAFIG returns the handle to a new ESCORRENTIAFIG or the handle to
%      the existing singleton*.
%
%      ESCORRENTIAFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESCORRENTIAFIG.M with the given input arguments.
%
%      ESCORRENTIAFIG('Property','Value',...) creates a new ESCORRENTIAFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before escorrentiaFig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to escorrentiaFig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help escorrentiaFig

% Last Modified by GUIDE v2.5 10-Sep-2022 00:50:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @escorrentiaFig_OpeningFcn, ...
                   'gui_OutputFcn',  @escorrentiaFig_OutputFcn, ...
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


% --- Executes just before escorrentiaFig is made visible.
function escorrentiaFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to escorrentiaFig (see VARARGIN)
global idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.escorrentiaFig,'Position');
posicion=[posicion1(1:2)+posicion1(3:4)/2,posicion2(3:4)];
set(handles.escorrentiaFig,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','dinamicaT.png'));
jframe.setFigureIcon(jIcon);

if strcmp(idioma,'spanish')
    set(handles.text26,'string','Método');
    set(handles.popupmenu1,'string',{'Onda cinemática','HU-SCS','HU-Snyder','H-Conocido'})
    set(handles.text22,'string','Tiempo de concentración');
    set(handles.text18,'string','Tiempo pico');
    set(handles.text20,'string','Coeficiente caudal pico');
    set(handles.text2,'string','Ancho');
    set(handles.text4,'string','Pendiente');
    set(handles.text6,'string','Área impermeable');
    set(handles.text8,'string','n-área permeable');
    set(handles.text10,'string','n-área impermeable');
    set(handles.text12,'string','d-impermeable');
    set(handles.text14,'string','d-permeable');
    set(handles.text16,'string','~d-impermeable');
end

set(handles.escorrentiaFig,'visible','on')
% Choose default command line output for escorrentiaFig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes escorrentiaFig wait for user response (see UIRESUME)
% uiwait(handles.escorrentiaFig);


% --- Outputs from this function are returned to the command line.
function varargout = escorrentiaFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global modelo idioma
if strcmp(idioma,'english')
    headers = {'<html><center /><font face="Open Sans" size=4><b><i>Tieme<br/>(min)</html>','<html><center /><font face="Open Sans" size=4><b><i>Flow<br/>(m<sup>3</sup>/s)</html>'};
else
    headers = {'<html><center /><font face="Open Sans" size=4><b><i>Tiempo<br/>(min)</html>','<html><center /><font face="Open Sans" size=4><b><i>Caudal<br/>(m<sup>3</sup>/s)</html>'};
end
set(handles.uitable1,'ColumnName',headers)

if ~isempty(modelo.bandera.escorrentia)
    switch modelo.bandera.escorrentia.metodo
        case 'Onda-Cinematica'
            set(handles.edit1,'string',modelo.bandera.escorrentia.ancho);
            set(handles.edit2,'string',modelo.bandera.escorrentia.pendiente);
            set(handles.edit3,'string',modelo.bandera.escorrentia.zonaImpermeable);
            set(handles.edit4,'string',modelo.bandera.escorrentia.nPermeable);
            set(handles.edit5,'string',modelo.bandera.escorrentia.nImpermeable);
            set(handles.edit6,'string',modelo.bandera.escorrentia.dImpermeable);
            set(handles.edit7,'string',modelo.bandera.escorrentia.dPermeable);
            set(handles.edit8,'string',modelo.bandera.escorrentia.sdImpermeable);
            set(handles.panelOC,'visible','on');
            set(handles.popupmenu1,'value',1);
        case 'HU-SCS'
            set(handles.edit12,'string',modelo.bandera.escorrentia.tc);
            set(handles.panelSCS,'visible','on');
            set(handles.popupmenu1,'value',2);
        case 'HU-Snyder'
            set(handles.edit9,'string',modelo.bandera.escorrentia.tp);
            set(handles.edit10,'string',modelo.bandera.escorrentia.cp);
            set(handles.panelSnyder,'visible','on');
            set(handles.popupmenu1,'value',3);
        case 'H-Conocido'
            set(handles.uitable1,'data',modelo.bandera.escorrentia.datos);
            set(handles.panelConocido,'visible','on');
            set(handles.popupmenu1,'value',4);
        otherwise
            set(handles.panelOC,'visible','on');
            set(handles.popupmenu1,'value',1);
    end
else
    set(handles.panelOC,'visible','on');
    set(handles.popupmenu1,'value',1);
end

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global modelo idioma

switch get(handles.popupmenu1,'value')
    case 1
        ancho=str2double(get(handles.edit1,'string'));
        pendiente=str2double(get(handles.edit2,'string'));
        impermeable=str2double(get(handles.edit3,'string'));
        nPermeable=str2double(get(handles.edit4,'string'));
        nImpermeable=str2double(get(handles.edit5,'string'));
        dImpermeable=str2double(get(handles.edit6,'string'));
        dPermeable=str2double(get(handles.edit7,'string'));
        sdImpermeable=str2double(get(handles.edit8,'string'));

        if isnan(ancho) || ancho==0 || isnan(pendiente) || pendiente==0 || isnan(impermeable) || isnan(nPermeable) || nPermeable==0  || isnan(nImpermeable) || nImpermeable==0 || isnan(dImpermeable) || isnan(dPermeable) || isnan(sdImpermeable)   
            if strcmp(idioma,'english')
                Aviso('Verify value','Error','error');
            else
                Aviso('Verificar valor','Error','error');
            end
            return
        end
        modelo.bandera.escorrentia=escorrentiaOC('Onda-Cinematica',ancho,pendiente,impermeable,nPermeable,nImpermeable,dImpermeable,dPermeable,sdImpermeable);
    case 2
        tc=str2double(get(handles.edit12,'string'));
        if isnan(tc) || tc==0
            if strcmp(idioma,'english')
                Aviso('Verify value','Error','error');
            else
                Aviso('Verificar valor','Error','error');
            end
            return
        end

        modelo.bandera.escorrentia=escorrentiaSCS('HU-SCS',tc);
    case 3
        tp=str2double(get(handles.edit9,'string'));
        cp=str2double(get(handles.edit10,'string'));
        if isnan(tp) || tp==0 || isnan(cp) || cp==0
            if strcmp(idioma,'english')
                Aviso('Verify value','Error','error');
            else
                Aviso('Verificar valor','Error','error');
            end
            return
        end
        modelo.bandera.escorrentia=escorrentiaSnyder('HU-Snyder',tp,cp);
    case 4
        try
            info=get(handles.uitable1,'data');
            for i=1:size(info,1)
                datos(i,1)=info{i,1};
                datos(i,2)=info{i,2};
            end
        catch
            datos=[];
        end
        modelo.bandera.escorrentia=escorrentiaSCS('H-Conocido',datos);
end
delete(gcbf);
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
set(handles.panelOC,'visible','off');
set(handles.panelSCS,'visible','off');
set(handles.panelSnyder,'visible','off');
set(handles.panelConocido,'visible','off');
switch get(handles.popupmenu1,'value')
    case 1
        set(handles.panelOC,'visible','on');
    case 2
        set(handles.panelSCS,'visible','on');
    case 3
        set(handles.panelSnyder,'visible','on');
    case 4
        set(handles.panelConocido,'visible','on');
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



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global ProyectoHidrologico idioma
if strcmp(idioma,'english')
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Select data file');
else
    [nombre,ruta]=uigetfile([fullfile(ProyectoHidrologico.carpetaBase),'/*.txt'],'Seleccionar archivo');
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
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
figure
info=get(handles.uitable1,'data');
for i=1:size(info,1)
    datos(i,1)=info{i,1};
    datos(i,2)=info{i,2};
end
plot(datos(:,1),datos(:,2));
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
