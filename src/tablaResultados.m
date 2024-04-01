function varargout = tablaResultados(varargin)
%% tablaResultados
% //    Description:
% //        -Summary simulation results
% //    Update History
% =============================================================
%
% TABLARESULTADOS MATLAB code for tablaResultados.fig
%      TABLARESULTADOS, by itself, creates a new TABLARESULTADOS or raises the existing
%      singleton*.
%
%      H = TABLARESULTADOS returns the handle to a new TABLARESULTADOS or the handle to
%      the existing singleton*.
%
%      TABLARESULTADOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABLARESULTADOS.M with the given input arguments.
%
%      TABLARESULTADOS('Property','Value',...) creates a new TABLARESULTADOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tablaResultados_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tablaResultados_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tablaResultados

% Last Modified by GUIDE v2.5 16-Jan-2024 01:00:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tablaResultados_OpeningFcn, ...
                   'gui_OutputFcn',  @tablaResultados_OutputFcn, ...
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


% --- Executes just before tablaResultados is made visible.
function tablaResultados_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tablaResultados (see VARARGIN)
global idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.tablaResultados,'Position');
pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.75;
pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.35;
posicion=[pos1,pos2,posicion2(3:4)];
set(handles.tablaResultados,'Position',posicion)

if strcmp(idioma,'spanish')
    set(handles.text3,'string','Serie')
    set(handles.text2,'string','Elemento:')
    set(handles.pushbutton2,'Tooltip','Ver datos')
    set(handles.pushbutton1,'Tooltip','Exportar')
end

set(handles.tablaResultados,'visible','on')
% Choose default command line output for tablaResultados
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tablaResultados wait for user response (see UIRESUME)
% uiwait(handles.tablaResultados);


% --- Outputs from this function are returned to the command line.
function varargout = tablaResultados_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
switch get(handles.popupmenu1,'value')
    case 1
        return
    case 2
        set(handles.popupmenu2,'string',{'Surface runoff','Total flow','Flooding'});
    case 3
        set(handles.popupmenu2,'string',{'Inflow','Outflow','Depth'});
    case 4
        set(handles.popupmenu2,'string',{'Runoff','Infiltration','Precipitation'});
end
set(handles.uitable1,'visible','off');
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
set(handles.uitable1,'visible','off');
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma

variable=get(handles.popupmenu2,'value');
lista=get(handles.popupmenu2,'string');

nombre = inputdlg({'Save model:'},(''),[1 30],{'Model_1'});
if isempty(nombre)
    if strcmp(idioma,'english')
        Aviso('Enter file name','Error','error');
    else
        Aviso('Ingresar mombre','Error','error');
    end
    return
end
nombre=nombre{1};
nombre=[nombre,'_',lista{variable},'.txt'];
datos=modelo.bandera{1};
headers=modelo.bandera{2};
if isempty(datos)
    if strcmp(idioma,'english')
        Aviso('No data available','Error','error')
    else
        Aviso('Sin datos disponibles','Error','error')
    end
    
    return
end
tablaDatos=cell(size(datos,1)+1,size(datos,2));
for i=1:(size(datos,1)+1)
    for j=1:size(datos,2)
        if i==1
            tablaDatos{i,j}=headers{j};
        elseif j==1 && i>1
            tablaDatos{i,j}=num2str(datos(i-1,j),'%0.1f');
        else
            tablaDatos{i,j}=num2str(datos(i-1,j),'%0.1f');
        end
    end
end
writecell(tablaDatos,fullfile(ProyectoHidrologico.carpetaBase,nombre));
if strcmp(idioma,'english')
    Aviso({'The model was exported successfully',['File: ',fullfile(ProyectoHidrologico.carpetaBase,nombre)]},'Success','help');
else
    Aviso({'El modelo se exportó correctamente',['File: ',fullfile(ProyectoHidrologico.carpetaBase,nombre)]},'Success','help');
end

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global modelo ProyectoHidrologico idioma
tipo=get(handles.popupmenu1,'value');
variable=get(handles.popupmenu2,'value');
tol=1e-6;
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Results.mat'),'results');

switch tipo
    case 2
        Tor=cell(1,modelo.nodos);
        for i=1:modelo.nodos
            Tor{i}=['ID-',num2str(i)];
        end
        if strcmp(idioma,'english')
            Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Node','SelectionMode','multiple');
        else
            Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Nodo','SelectionMode','multiple');
        end
        
        if isempty(Z)
            if strcmp(idioma,'english')
                Aviso('Select node','Error','error')
            else
                Aviso('Seleccionar nodo','Error','error')
            end
            return
        end
        headers=cell(length(Z)+1,1);
        headers2=cell(length(Z)+1,1);
        if strcmp(idioma,'english')
            headers{1}='<html><center /><font face="Open Sans" size=4><b><i>Time<br/>(min)</html>';
            headers2{1}='Time';
        else
            headers{1}='<html><center /><font face="Open Sans" size=4><b><i>Tiempo<br/>(min)</html>';
            headers2{1}='Tiempo';
        end

        for i=1:length(Z)
            if strcmp(idioma,'english')
                headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Node-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                headers2{i+1}=['Node-',num2str(Z(i))];
            else
                headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Nodo-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                headers2{i+1}=['Nodo-',num2str(Z(i))];
            end

        end
        switch variable
            case 1
                datos=results.directoNodo(:,2*Z);
                datos=[results.directoNodo(:,1)/60,datos];
            case 2
                datos=results.totalNodo(:,2*Z);
                datos=[results.totalNodo(:,1)/60,datos];
            case 3
                datos=results.inundacion(:,2*Z);

        end
        datos(datos<=tol)=0;
        tablaDatos=cell(size(datos));
        for i=1:size(datos,1)*size(datos,2)
            if i>size(datos,1)
                tablaDatos{i}=strcat(sprintf('<html><tr align=center><td width=%d>',150),num2str(datos(i),'%0.3f'));
            else
                tablaDatos{i}=strcat(sprintf('<html><tr align=center><td width=%d>',150),num2str(datos(i),'%0.1f'));
            end
        end

    case 3
        Tor=cell(1,modelo.tuberias);
        for i=1:modelo.tuberias
            Tor{i}=['ID-',num2str(i)];
        end
        if strcmp(idioma,'english')
            Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Conduit','SelectionMode','multiple');
        else
            Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Tubería','SelectionMode','multiple');
        end
        
        headers=cell(length(Z)+1,1);
        headers2=cell(length(Z)+1,1);
        if strcmp(idioma,'english')
            headers{1}='<html><center /><font face="Open Sans" size=4><b><i>Time<br/>(min)</html>';
            headers2{1}='Time';
        else
            headers{1}='<html><center /><font face="Open Sans" size=4><b><i>Tiempo<br/>(min)</html>';
            headers2{1}='Tiempo';
        end
        switch variable
            case 1
                for i=1:length(Z)
                    if strcmp(idioma,'english')
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Conduit-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                        headers2{i+1}=['Conduit-',num2str(Z(i))];
                    else
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Tubería-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                        headers2{i+1}=['Tubería-',num2str(Z(i))];
                    end

                end
                datos=results.entradaTuberia(:,2*Z);
                datos=[results.entradaTuberia(:,1)/60,datos];
            case 2
                for i=1:length(Z)
                    if strcmp(idioma,'english')
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Conduit-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                        headers2{i+1}=['Conduit-',num2str(Z(i))];
                    else
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Tubería-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                        headers2{i+1}=['Tubería-',num2str(Z(i))];
                    end

                end
                datos=results.salidaTuberia(:,2*Z);
                datos=[results.salidaTuberia(:,1)/60,datos];
            case 3
                for i=1:length(Z)
                   if strcmp(idioma,'english')
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Conduit-',num2str(Z(i)),'<br/>(m)</html>'];
                        headers2{i+1}=['Conduit-',num2str(Z(i))];
                    else
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Tubería-',num2str(Z(i)),'<br/>(m)</html>'];
                        headers2{i+1}=['Tubería-',num2str(Z(i))];
                    end

                end
                datos=results.tirante(:,2*Z);
                datos=[results.tirante(:,1)/60,datos];
        end
        datos(datos<=tol)=0;
        tablaDatos=cell(size(datos));
        for i=1:size(datos,1)*size(datos,2)
            if i>size(datos,1)
                tablaDatos{i}=strcat(sprintf('<html><tr align=center><td width=%d>',150),num2str(datos(i),'%0.3f'));
            else
                tablaDatos{i}=strcat(sprintf('<html><tr align=center><td width=%d>',150),num2str(datos(i),'%0.1f'));
            end
        end

    case 4
        Tor=cell(1,modelo.cuencas);
        for i=1:modelo.cuencas
            Tor{i}=['ID-',num2str(i)];
        end
        if strcmp(idioma,'english')
            Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Catchment','SelectionMode','multiple');
        else
            Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Cuenca','SelectionMode','multiple');
        end
        
        headers=cell(length(Z)+1,1);
        headers2=cell(length(Z)+1,1);
        if strcmp(idioma,'english')
            headers{1}='<html><center /><font face="Open Sans" size=4><b><i>Time<br/>(min)</html>';
            headers2{1}='Time';
        else
            headers{1}='<html><center /><font face="Open Sans" size=4><b><i>Tiempo<br/>(min)</html>';
            headers2{1}='Tiempo';
        end
        switch variable
            case 1
                for i=1:length(Z)
                   if strcmp(idioma,'english')
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Catchment-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                        headers2{i+1}=['Catchment-',num2str(Z(i))];
                    else
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Cuenca-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                        headers2{i+1}=['Cuenca-',num2str(Z(i))];
                    end

                end
                datos=results.escorrentia(:,2*Z);
                datos=[results.escorrentia(:,1)/60,datos];
            case 2
                for i=1:length(Z)
                   if strcmp(idioma,'english')
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Catchment-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                        headers2{i+1}=['Catchment-',num2str(Z(i))];
                    else
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Cuenca-',num2str(Z(i)),'<br/>(m3/s)</html>'];
                        headers2{i+1}=['Cuenca-',num2str(Z(i))];
                    end

                end
                datos=results.infiltracion(:,Z)*1000;
                datos=[results.hietogramas(1:size(datos,1),1)/60,datos];
            case 3
                for i=1:length(Z)
                    if strcmp(idioma,'english')
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Catchment-',num2str(Z(i)),'<br/>(mm)</html>'];
                        headers2{i+1}=['Catchment-',num2str(Z(i))];
                    else
                        headers{i+1}=['<html><center /><font face="Open Sans" size=4><b><i>','Cuenca-',num2str(Z(i)),'<br/>(mm)</html>'];
                        headers2{i+1}=['Cuenca-',num2str(Z(i))];
                    end
                end
                datos=results.hietogramas(:,2*Z)*1000;
                datos=[results.hietogramas(:,1)/60,datos];
        end
        datos(datos<=tol)=0;
        tablaDatos=cell(size(datos));
        for i=1:size(datos,1)*size(datos,2)
            if i>size(datos,1)
                tablaDatos{i}=strcat(sprintf('<html><tr align=center><td width=%d>',150),num2str(datos(i),'%0.3f'));
            else
                tablaDatos{i}=strcat(sprintf('<html><tr align=center><td width=%d>',150),num2str(datos(i),'%0.1f'));
            end
        end
end
set(handles.uitable1,'ColumnName',headers)
set(handles.uitable1,'data',tablaDatos);
set(handles.uitable1,'visible','on');
modelo.bandera={datos,headers2};
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
