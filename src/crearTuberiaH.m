function varargout = crearTuberiaH(varargin)
%% crearTuberiaH
% //    Description:
% //        -Set conduit parameters
% //    Update History
% =============================================================
%
% CREARTUBERIAH MATLAB code for crearTuberiaH.fig
%      CREARTUBERIAH, by itself, creates a new CREARTUBERIAH or raises the existing
%      singleton*.
%
%      H = CREARTUBERIAH returns the handle to a new CREARTUBERIAH or the handle to
%      the existing singleton*.
%
%      CREARTUBERIAH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREARTUBERIAH.M with the given input arguments.
%
%      CREARTUBERIAH('Property','Value',...) creates a new CREARTUBERIAH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before crearTuberiaH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crearTuberiaH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help crearTuberiaH

% Last Modified by GUIDE v2.5 04-Jan-2024 15:47:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crearTuberiaH_OpeningFcn, ...
                   'gui_OutputFcn',  @crearTuberiaH_OutputFcn, ...
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


% --- Executes just before crearTuberiaH is made visible.
function crearTuberiaH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crearTuberiaH (see VARARGIN)
global modelo idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.crearTuberia1,'Position');
posicion=[posicion1(1)+posicion1(3)/2,posicion1(2)+posicion1(4)/4,posicion2(3:4)];
set(handles.crearTuberia1,'Position',posicion)

Tor=cell(1,modelo.nodos);
for i=1:modelo.nodos
    Tor{i}=['ID-',num2str(i)];
end
set(handles.popupmenu1,'String',Tor)
set(handles.popupmenu2,'String',Tor)

switch modelo.bandera{2}
    case 'creacion'
        set(handles.popupmenu1,'enable','off');
        set(handles.popupmenu2,'enable','off');
end
modelo.bandera=modelo.bandera{1};

set(handles.popupmenu1,'value',modelo.bandera.nodoI)
set(handles.popupmenu2,'value',modelo.bandera.nodoF)

set(handles.edit1,'string',round(modelo.bandera.longitud,2));
set(handles.edit2,'string',round(modelo.bandera.n,3));
set(handles.edit3,'string',round(modelo.bandera.ERNi,2));
set(handles.edit4,'string',round(modelo.bandera.ERNf,2));

if ~isempty(modelo.bandera.seccion)
    switch modelo.bandera.seccion.tipo
        case 'circular'
            set(handles.boxDiametro,'string',round(modelo.bandera.seccion.diametro,2));
            set(handles.popupmenu3,'value',2);
    end
    popupmenu3_Callback(hObject, eventdata, handles)
end

if strcmp(idioma,'spanish')
   set(handles.text14,'string','Sección transversal');
   set(handles.text23,'string','Diámetro');
   set(handles.text4,'string','Nodo inicial');
   set(handles.text5,'string','Nodo final');
   set(handles.text2,'string','Longitud');
   set(handles.text6,'string','Rugosidad');
   set(handles.text8,'string','Elevación de entrada');
   set(handles.text10,'string','Elevación salida');
end
set(handles.crearTuberia1,'visible','on');
% Choose default command line output for crearTuberiaH
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes crearTuberiaH wait for user response (see UIRESUME)
% uiwait(handles.crearTuberia1);


% --- Outputs from this function are returned to the command line.
function varargout = crearTuberiaH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
L=str2double(get(handles.edit1,'string'));
n=str2double(get(handles.edit2,'string'));
ERNi=str2double(get(handles.edit3,'string'));
ERNf=str2double(get(handles.edit4,'string'));
Ni=get(handles.popupmenu1,'value');
Nf=get(handles.popupmenu2,'value');
if Ni==Nf
    if strcmp(idioma,'english')
        Aviso('Select different nodes','Error','error');
    else
        Aviso('Seleccionar nodos diferentes','Error','error');
    end
    return
end

if L<0 || n<=0
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return
elseif isnan(L) || isnan(n) || isnan(ERNi) || isnan(ERNf)
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return
end
if ERNi<ERNf
    if strcmp(idioma,'english')
        Aviso('Verify data elevation','Error','error');
    else
        Aviso('Verificar elevación','Error','error');
    end
    return
end
sec=get(handles.popupmenu3,'value');
switch sec
    case 2
        D=str2double(get(handles.boxDiametro,'string'));
        if D<=0 
            if strcmp(idioma,'english')
                Aviso('Verify diameter','Error','error');
            else
                Aviso('Verificar diámetro','Error','error');
            end
            return
        elseif isnan(D) 
            if strcmp(idioma,'english')
                Aviso('Verify data value','Error','error');
            else
                Aviso('Verificar valor','Error','error');
            end
            return
        end
        modelo.bandera.seccion=seccion('circular',D);

    otherwise
        if strcmp(idioma,'english')
            Aviso('Select cross section','Error','error');
        else
            Aviso('Seleccionar sección transversal','Error','error');
        end
        return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');

modelo.bandera.longitud=L;
modelo.bandera.modLength=L;
modelo.bandera.nodoI=Ni;
modelo.bandera.nodoF=Nf;
modelo.bandera.n=n;
modelo.bandera.ERNi=ERNi;
modelo.bandera.ERNf=ERNf;

modelo.bandera.Sp=(modelo.bandera.ERNi-modelo.bandera.ERNf)/modelo.bandera.longitud;
modelo.bandera.beta=sqrt(modelo.bandera.Sp)/modelo.bandera.n;
modelo.bandera.offset1=modelo.bandera.ERNi- Node(modelo.bandera.nodoI).elevacionR;
modelo.bandera.offset2=modelo.bandera.ERNf- Node(modelo.bandera.nodoF).elevacionR;
modelo.bandera.seccion=getSMax(modelo.bandera.seccion);
modelo.bandera.qFull=(1/modelo.bandera.n)*modelo.bandera.seccion.aFull*sqrt(modelo.bandera.Sp)*modelo.bandera.seccion.rFull^(2/3);
modelo.bandera.qMax=modelo.bandera.seccion.sMax*sqrt(modelo.bandera.Sp)/modelo.bandera.n;
modelo.bandera.roughFactor = 9.81 * modelo.bandera.n^2;
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
% --- Executes during object creation, after setting all properties.


% --- Executes when user attempts to close crearTuberiaH.
function crearTuberiaH_CloseRequestFcn(hObject, eventdata, handles)
global modelo
delete(hObject);
modelo.bandera=[];
% Hint: delete(hObject) closes the figure
delete(hObject);

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

op=get(handles.popupmenu3,'value');
switch op
    case 2
        set(handles.panelCircular,'visible','on');

    otherwise
        set(handles.panelCircular,'visible','off'); 
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


function boxDiametro_Callback(hObject, eventdata, handles)
% hObject    handle to boxDiametro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxDiametro as text
%        str2double(get(hObject,'String')) returns contents of boxDiametro as a double


% --- Executes during object creation, after setting all properties.
function boxDiametro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxDiametro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close crearTuberia1.
function crearTuberia1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to crearTuberia1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
