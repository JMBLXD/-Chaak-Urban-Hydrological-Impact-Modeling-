function varargout = Chaak(varargin)
% CHAAK MATLAB code for Chaak.fig
%      CHAAK, by itself, creates a new CHAAK or raises the existing
%      singleton*.
%
%      H = CHAAK returns the handle to a new CHAAK or the handle to
%      the existing singleton*.
%
%      CHAAK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHAAK.M with the given input arguments.
%
%      CHAAK('Property','Value',...) creates a new CHAAK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Chaak_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Chaak_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Chaak

% Last Modified by GUIDE v2.5 31-Mar-2024 10:29:37

% Begin initialization code - DO NOT EDIT
% javax.swing.UIManager.setLookAndFeel('javax.swing.plaf.nimbus.NimbusLookAndFeel')
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Chaak_OpeningFcn, ...
                   'gui_OutputFcn',  @Chaak_OutputFcn, ...
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


% --- Executes just before Chaak is made visible.
function Chaak_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Chaak (see VARARGIN)
global idioma
movegui('center');
axes(handles.axes1)
img=imread(fullfile('data','portadaChaak.jpg')); 
imshow(img);
axis off  
 idioma='english';
% Choose default command line output for Chaak
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Chaak_OutputFcn(hObject, eventdata, handles)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','chaakIcon.png'));
jframe.setFigureIcon(jIcon);
set(handles.Chaak_V1,'visible','on')
set(findall(gcf,'tag','Untitled_1'),'Label','<html><center/><font face="Open Sans" size=4><b><i>Language</html>');

jButton = java(findjobj(handles.pushbutton1));
jButton.setIcon(javax.swing.ImageIcon(fullfile('data','power.png')));
jButton.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
jButton.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);

jButton = java(findjobj(handles.pushbutton2));
jButton.setIcon(javax.swing.ImageIcon(fullfile('data','info2.png')));
jButton.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
jButton.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);

% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% % % % varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
close(gcf);
moduloHidrologico;
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
Info;
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
global idioma
set(handles.Untitled_3,'Checked','off')
set(handles.Untitled_2,'Checked','on')

set(findall(gcf,'tag','Untitled_1'),'Label','<html><center/><font face="Open Sans" size=4><b><i>Language</html>');
set(handles.Untitled_2,'Text','English');
set(handles.Untitled_3,'Text','Spanish');
set(handles.pushbutton2,'string','About')

jButton = java(findjobj(handles.pushbutton1));
jButton.setIcon(javax.swing.ImageIcon(fullfile('data','power.png')));
jButton.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
jButton.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
 idioma='english';
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
global idioma
set(handles.Untitled_2,'Checked','off')
set(handles.Untitled_3,'Checked','on')


set(findall(gcf,'tag','Untitled_1'),'Label','<html><center/><font face="Open Sans" size=4><b><i>Lenguaje</html>');
set(handles.Untitled_2,'Text','Ingles');
set(handles.Untitled_3,'Text','Español');
set(handles.pushbutton1,'string','Acerca')

jButton = java(findjobj(handles.pushbutton1));
jButton.setIcon(javax.swing.ImageIcon(fullfile('data','power.png')));
jButton.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
jButton.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
 idioma='spanish';
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
