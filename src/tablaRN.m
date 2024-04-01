function varargout = tablaRN(varargin)
%% tablaRN
% //    Description:
% //        -Natural response data
% //    Update History
% =============================================================
%
% TABLARN MATLAB code for tablaRN.fig
%      TABLARN, by itself, creates a new TABLARN or raises the existing
%      singleton*.
%
%      H = TABLARN returns the handle to a new TABLARN or the handle to
%      the existing singleton*.
%
%      TABLARN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABLARN.M with the given input arguments.
%
%      TABLARN('Property','Value',...) creates a new TABLARN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tablaRN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tablaRN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tablaRN

% Last Modified by GUIDE v2.5 28-Sep-2022 15:43:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tablaRN_OpeningFcn, ...
                   'gui_OutputFcn',  @tablaRN_OutputFcn, ...
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


% --- Executes just before tablaRN is made visible.
function tablaRN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tablaRN (see VARARGIN)

% Choose default command line output for tablaRN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tablaRN wait for user response (see UIRESUME)
% uiwait(handles.tablaRN);


% --- Outputs from this function are returned to the command line.
function varargout = tablaRN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global modelo idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.tablaRN,'Position');
posicion=[posicion1(1:2)+posicion1(3:4)/2,posicion2(3:4)];
set(handles.tablaRN,'Position',posicion)

if strcmp(idioma,'english')
    headers={'<html><center /><font face="Open Sans" size=4><b><i>Time<br />(min)</html>','<html><center /><font face="Open Sans" size=4><b><i>Flow<br/>(m<sup>3</sup>/s)</html>'};
else
    headers={'<html><center /><font face="Open Sans" size=4><b><i>Tiempo<br />(min)</html>','<html><center /><font face="Open Sans" size=4><b><i>Caudal<br/>(m<sup>3</sup>/s)</html>'};
end

set(handles.uitable1,'ColumnName',headers)
datos=modelo.bandera;
datos(:,1)=datos(:,1)/60;
datos=round(datos,4);
set(handles.uitable1,'data',datos)
set(handles.tablaRN,'visible','on')
% Get default command line output from handles structure
varargout{1} = handles.output;
