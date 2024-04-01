function varargout = crearNodoH(varargin)
%% crearNodoH
% //    Description:
% //        -Set node parameters
% //    Update History
% =============================================================
%
% CREARNODOH MATLAB code for crearNodoH.fig
%      CREARNODOH, by itself, creates a new CREARNODOH or raises the existing
%      singleton*.
%
%      H = CREARNODOH returns the handle to a new CREARNODOH or the handle to
%      the existing singleton*.
%
%      CREARNODOH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREARNODOH.M with the given input arguments.
%
%      CREARNODOH('Property','Value',...) creates a new CREARNODOH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before crearNodoH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crearNodoH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help crearNodoH

% Last Modified by GUIDE v2.5 12-Aug-2022 14:36:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crearNodoH_OpeningFcn, ...
                   'gui_OutputFcn',  @crearNodoH_OutputFcn, ...
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


% --- Executes just before crearNodoH is made visible.
function crearNodoH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crearNodoH (see VARARGIN)
global modelo idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.crearNodo,'Position');
posicion=[posicion1(1:2)+posicion1(3:4)/2,posicion2(3:4)];
set(handles.crearNodo,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','nodoT.png'));
jframe.setFigureIcon(jIcon);

switch modelo.bandera{2}
    case 'creacion'
        set(handles.edit3,'enable','off');
        set(handles.edit2,'enable','off');
    otherwise
        set(handles.edit3,'enable','off');
        set(handles.edit2,'enable','off');
end
modelo.bandera=modelo.bandera{1};

set(handles.edit1,'string',modelo.bandera.elevacionT);
set(handles.edit4,'string',modelo.bandera.elevacionR);
set(handles.edit3,'string',sprintf('%f',modelo.bandera.corX));
set(handles.edit2,'string',sprintf('%f',modelo.bandera.corY));

if strcmp(idioma,'spanish')
    set(handles.text4,'string','Coordenada X');
    set(handles.text5,'string','Coordenada X');
    set(handles.text2,'string','Elevación de terreno');
    set(handles.text6,'string','Elevación de rasante');
end
set(handles.crearNodo,'Visible','on')
% Choose default command line output for crearNodoH
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes crearNodoH wait for user response (see UIRESUME)
% uiwait(handles.crearNodoH);


% --- Outputs from this function are returned to the command line.
function varargout = crearNodoH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global modelo idioma
ET=str2double(get(handles.edit1,'string'));
ER=str2double(get(handles.edit4,'string'));
X=str2double(get(handles.edit3,'string'));
Y=str2double(get(handles.edit2,'string'));
if ET<0 || ER < 0
    if strcmp(idioma,'english')
        Aviso('Verify data elevation','Error','error');
    else
        Aviso('Verificar elevación','Error','error');
    end
    return
elseif isnan(ET) || isnan(ER)
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return
end

if isnan(X) || isnan(Y) ||isempty(X) || isempty(Y)
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return
end

if X~=modelo.bandera.corX
    modelo.bandera.corX=X;
end

if Y~=modelo.bandera.corY
    modelo.bandera.corY=Y;
end

modelo.bandera.posicion=[modelo.bandera.corX,modelo.bandera.corY];
modelo.bandera.elevacionT=ET;
modelo.bandera.elevacionR=ER;
modelo.bandera.desnivel=ET-ER;
modelo.bandera.fullDepth=modelo.bandera.desnivel;
modelo.bandera.surDepth=modelo.bandera.desnivel;
modelo.bandera.XNodo=XNodo(modelo.bandera);
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

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close crearNodoH.
function crearNodo_CloseRequestFcn(hObject, eventdata, handles)
global modelo
delete(hObject);
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
