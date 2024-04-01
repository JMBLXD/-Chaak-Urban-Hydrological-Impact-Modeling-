function varargout = editarTamanoH(varargin)
%% editarTamanoH
% //    Description:
% //        -Edit size element
% //    Update History
% =============================================================
%
% EDITARTAMANOH MATLAB code for editarTamanoH.fig
%      EDITARTAMANOH, by itself, creates a new EDITARTAMANOH or raises the existing
%      singleton*.
%
%      H = EDITARTAMANOH returns the handle to a new EDITARTAMANOH or the handle to
%      the existing singleton*.
%
%      EDITARTAMANOH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITARTAMANOH.M with the given input arguments.
%
%      EDITARTAMANOH('Property','Value',...) creates a new EDITARTAMANOH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before editarTamanoH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to editarTamanoH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help editarTamanoH

% Last Modified by GUIDE v2.5 13-Aug-2022 02:25:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @editarTamanoH_OpeningFcn, ...
                   'gui_OutputFcn',  @editarTamanoH_OutputFcn, ...
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


% --- Executes just before editarTamanoH is made visible.
function editarTamanoH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to editarTamanoH (see VARARGIN)
global modelo
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.editarTamano,'Position');
posicion=[posicion1(1:2)+posicion1(3:4)/2,posicion2(3:4)];
set(handles.editarTamano,'Position',posicion)
set(handles.editarTamano,'visible','on')

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','resize.png'));
jframe.setFigureIcon(jIcon);

set(handles.edit1,'string',modelo.bandera);
% Choose default command line output for editarTamanoH
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes editarTamanoH wait for user response (see UIRESUME)
% uiwait(handles.editarTamanoH);


% --- Outputs from this function are returned to the command line.
function varargout = editarTamanoH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global modelo
tamano=str2double(get(handles.edit1,'string'));
if tamano<=0
    Aviso('Verify data value','Error','error');
    return
elseif isnan(tamano)
    Aviso('Verify data value','Error','error');
    return
end
modelo.bandera=tamano;
delete(gcbf)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(gcbf);
global modelo
modelo.bandera='';
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


% --- Executes when user attempts to close editarTamanoH.
function editarTamano_CloseRequestFcn(hObject, eventdata, handles)
global modelo
delete(hObject);
modelo.bandera='';
% Hint: delete(hObject) closes the figure
delete(hObject);
