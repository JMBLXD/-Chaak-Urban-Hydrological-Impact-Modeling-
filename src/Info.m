function varargout = Info(varargin)
% info MATLAB code for info.fig
%      info, by itself, creates a new info or raises the existing
%      singleton*.
%
%      H = info returns the handle to a new info or the handle to
%      the existing singleton*.
%
%      info('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in info.M with the given input arguments.
%
%      info('Property','Value',...) creates a new info or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Info_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Info_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help info

% Last Modified by GUIDE v2.5 17-Feb-2024 22:39:21

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Info_OpeningFcn, ...
                   'gui_OutputFcn',  @Info_OutputFcn, ...
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


% --- Executes just before info is made visible.
function Info_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to info (see VARARGIN)

% Choose default command line output for info
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','chaakIcon.png'));
jframe.setFigureIcon(jIcon);

h = findobj('tag','Chaak_V1');
posicion1=h.Position;
posicion2=get(handles.Info,'Position');
pos1=posicion1(1)-abs(posicion2(3)-posicion1(3))*0.5;
pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.5;
posicion=[pos1,pos2,posicion2(3:4)];
set(handles.Info,'Position',posicion)

axes(handles.axes2)
img=imread(fullfile('data','IITCA.png')); 
imshow(img);
axis off 

axes(handles.axes1)
img=imread(fullfile('data','UAEM.png')); 
imshow(img);
axis off

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes info wait for user response (see UIRESUME)
% uiwait(handles.Info);


% --- Outputs from this function are returned to the command line.
function varargout = Info_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Info,'visible','on')
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in regresarayudaArta.
function regresarayudaArta_Callback(hObject, eventdata, handles)
% hObject    handle to regresarayudaArta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
