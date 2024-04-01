function varargout = graficasSimulacion(varargin)
%% graficasSimulacion
% //    Description:
% //        -Get result graph
% //    Update History
% =============================================================
%
% GRAFICASSIMULACION MATLAB code for graficasSimulacion.fig
%      GRAFICASSIMULACION, by itself, creates a new GRAFICASSIMULACION or raises the existing
%      singleton*.
%
%      H = GRAFICASSIMULACION returns the handle to a new GRAFICASSIMULACION or the handle to
%      the existing singleton*.
%
%      GRAFICASSIMULACION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAFICASSIMULACION.M with the given input arguments.
%
%      GRAFICASSIMULACION('Property','Value',...) creates a new GRAFICASSIMULACION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before graficasSimulacion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to graficasSimulacion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help graficasSimulacion

% Last Modified by GUIDE v2.5 18-Feb-2024 18:18:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @graficasSimulacion_OpeningFcn, ...
                   'gui_OutputFcn',  @graficasSimulacion_OutputFcn, ...
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


% --- Executes just before graficasSimulacion is made visible.
function graficasSimulacion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to graficasSimulacion (see VARARGIN)
global modelo idioma
modelo.bandera=0;
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.graficasSimulacion,'Position');
pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.75;
pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.35;
posicion=[pos1,pos2,posicion2(3:4)];
set(handles.graficasSimulacion,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','resultadosT.png'));
jframe.setFigureIcon(jIcon);

set(handles.slider1, 'Min', 0);
set(handles.slider1, 'Max', 1);
set(handles.slider1, 'SliderStep', [0.5,0.5]);
set(handles.slider1, 'Value', 0.5);

if strcmp(idioma,'spanish')
    set(handles.text3,'string','Graficar serie');
    set(handles.text2,'string','Elemento:');
    set(handles.text4,'string','Identificador:');
    set(handles.text6,'string','Opciones gráficas');
    set(handles.text13,'string','Gráfico');
    set(handles.text9,'string','Línea:');
    set(handles.text10,'string','Tipo');
    set(handles.text8,'string','Ancho');
    set(handles.text11,'string','Opciones de eje');
    set(handles.text12,'string','Unidades');
    set(handles.pushbutton5,'Tooltip','Agregar gráfico');
    set(handles.pushbutton4,'Tooltip','Eliminar gráfico actual');
    set(handles.pushbutton3,'Tooltip','Gráficar');
end

set(handles.graficasSimulacion,'visible','on')
% Choose default command line output for graficasSimulacion
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes graficasSimulacion wait for user response (see UIRESUME)
% uiwait(handles.graficasSimulacion);


% --- Outputs from this function are returned to the command line.
function varargout = graficasSimulacion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ProyectoHidrologico nodosRef tuberiasRef cuencasRef unidades

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');

axes(handles.axesGraf)
ax = gca;
ax.Interactions = [panInteraction zoomInteraction];

axes(handles.axesRef)
ax = gca;
ax.Interactions = [panInteraction zoomInteraction];

Xmin=min([Node.corX])-10;
Xmax=max([Node.corX])+10;
Ymin=min([Node.corY])-10;
Ymax=max([Node.corY])+10;
axis([Ymin Ymax Xmin Xmax])
xlim auto
ylim auto
axis equal
hold on
for i=1:length(Catchment)
    cuencasRef(i)=plotCuencaRef(Catchment(i));
end
for i=1:length(Conduit)
    tuberiasRef(i)=plotTuberiaRef(Conduit(i));
end
for i=1:length(Node)
    nodosRef(i)=plotNodoRef(Node(i));
end
unidades=1;
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
axes(handles.axesGraf);
ax=gca;
if isempty(ax.Children)
    return
else
    actual=get(handles.popupmenu6,'value');
    graficos=ax.Children;
    color=get(graficos(actual),'Color');
    set(handles.pushbutton1,'BackgroundColor',color)
    grosor=get(graficos(actual),'LineWidth');
    set(handles.edit1,'string',grosor)
    linea=get(graficos(actual),'LineStyle');
    switch linea
        case '-'
            set(handles.popupmenu4,'value',1);
        case '--'
            set(handles.popupmenu4,'value',2);
        case ':'
            set(handles.popupmenu4,'value',3);
        case '-.'
            set(handles.popupmenu4,'value',4);
    end
end
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global modelo 
axes(handles.axesGraf);
ax=gca;
graficos=ax.Children;
if isempty(graficos)
    return
end

posicion1=get(handles.graficasSimulacion,'Position');
f=figure;
f.Color=[1,1,1];
posicion2=f.Position;
pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.75;
pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.35;
posicion=[pos1,pos2,posicion2(3:4)];
f.Position=posicion;

hold on
for i=length(graficos):-1:1
    switch modelo.bandera
        case 1
            plot(graficos(i).XData,graficos(i).YData,'LineStyle',graficos(i).LineStyle,'LineWidth',graficos(i).LineWidth,'Color',graficos(i).Color)
            ax=gca;
            ax.FontSize=9;
            if get(handles.popupmenu5,'value')==1
                ylabel('Flow (m3/s)') 
                xlabel('Time (min)')
            else
                ylabel('Flow (l/s)') 
                xlabel('Time (min)')
            end
            ax.YGrid='on';
            ax.XGrid='on';
            if get(handles.checkbox1,'value')==1
                ax.YMinorGrid='on';
                ax.XMinorGrid='on';
            end
            nombres=get(handles.popupmenu6,'string');
            B = flipud(nombres);
            legend(gca,B)
        case 2
            plot(graficos(i).XData,graficos(i).YData,'LineStyle',graficos(i).LineStyle,'LineWidth',graficos(i).LineWidth,'Color',graficos(i).Color)
            ax=gca;
            ax.FontSize=9;
            if get(handles.popupmenu5,'value')==1
                ylabel('Elevation (m)') 
                xlabel('Time (min)')
            else
                ylabel('Elevation (cm)') 
                xlabel('Time (min)')
            end
            ax.YGrid='on';
            ax.XGrid='on';
            if get(handles.checkbox1,'value')==1
                ax.YMinorGrid='on';
                ax.XMinorGrid='on';
            end
            nombres=get(handles.popupmenu6,'string');
            B = flipud(nombres);
            legend(gca,B)
        case 3
            plot(graficos(i).XData,graficos(i).YData,'LineStyle',graficos(i).LineStyle,'LineWidth',graficos(i).LineWidth)
            if get(handles.popupmenu5,'value')==1
                ylabel('Precipitation (m)') 
                xlabel('Time (min)')
            else
                ylabel('Precipitation (cm)') 
                xlabel('Time (min)')
            end
            ax.YGrid='on';
            ax.XGrid='on';
            if get(handles.checkbox1,'value')==1
                ax.YMinorGrid='on';
                ax.XMinorGrid='on';
            end
            nombres=get(handles.popupmenu6,'string');
            B = flipud(nombres);
            legend(gca,B)
    end
end


% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global modelo nodosRef tuberiasRef cuencasRef 
axes(handles.axesGraf);
ax=gca;
if isempty(ax.Children)
    return
else
    actual=get(handles.popupmenu6,'value');
    graficos=ax.Children;
    lista=get(handles.popupmenu6,'string');
    
    if iscell(lista)
        actualizar=lista(actual);
    else
        actualizar={lista};
    end
    delete(graficos(actual));
    dd=split(actualizar,'-');
    switch dd{1}
        case 'Node '
            set(nodosRef(str2double(dd{2})),'MarkerFaceColor',[0.8 0.8 0.8]);
        case 'Conduit '
            set(tuberiasRef(str2double(dd{2})),'Color',[0.8 0.8 0.8]);
        case 'Catchment '
            set(cuencasRef(str2double(dd{2})),'FaceColor',[0.8 0.8 0.8]);
    end
    if length(graficos)==1
        set(handles.popupmenu6,'Value',1);
        nuevo={'---'};
        set(handles.popupmenu6,'string',nuevo);
        modelo.bandera=0;
        ylabel('') 
        xlabel('')
        set(handles.popupmenu5,'Value',1);
        set(handles.popupmenu5,'string',{'---'});
    else
        set(handles.popupmenu6,'Value',1);
        lista(actual)=[];
        set(handles.popupmenu6,'string',lista);
    end
end
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
axes(handles.axesGraf);
ax=gca;
if isempty(ax.Children)
    return
else
    grosor=round(str2double(get(handles.edit1,'string')),1);
    if isnan(grosor) || grosor<=0
        return
    else
        actual=get(handles.popupmenu6,'value');
        graficos=ax.Children;
        set(graficos(actual),'LineWidth',grosor)
    end

end
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


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
incremento=get(handles.slider1,'value');
set(handles.slider1, 'Value', 0.5);
valor=str2double(get(handles.edit1,'string'));
if incremento==1
    valor=valor+0.5;
else
    valor=valor-0.5;
end

if valor<=0
    return
else
    set(handles.edit1,'string',valor)
    edit1_Callback(hObject, eventdata, handles)
end
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
axes(handles.axesGraf);
ax=gca;
if isempty(ax.Children)
    return
else
    color = uisetcolor(get(handles.pushbutton1,'BackgroundColor'));
    if color == get(handles.pushbutton1,'BackgroundColor')
        return
    else
        set(handles.pushbutton1,'BackgroundColor',color)
        actual=get(handles.popupmenu6,'value');
        graficos=ax.Children;
        set(graficos(actual),'Color',color)
    end

end
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
axes(handles.axesGraf);
ax=gca;
if isempty(ax.Children)
    return
else
    switch get(handles.popupmenu4,'value')
        case 1
            linea='-';
        case 2
            linea='--';
        case 3
            linea=':';
        case 4
            linea='-.';
    end
    actual=get(handles.popupmenu6,'value');
    graficos=ax.Children;
    set(graficos(actual),'LineStyle',linea)

end
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
global unidades modelo
axes(handles.axesGraf);
ax=gca;
graficos=ax.Children;
if unidades==get(handles.popupmenu5,'value') || isempty(graficos)
    return
end 


switch modelo.bandera
    case 1
        if get(handles.popupmenu5,'value')==1
            ylabel('Flow (m3/s)');
            for i=1:length(graficos)
                graficos(i).YData=graficos(i).YData/1000;
            end
            unidades=1;
        else
            ylabel('Flow (l/s)');
            for i=1:length(graficos)
                graficos(i).YData=graficos(i).YData*1000;
            end
            unidades=2;
        end

    case 2
        if get(handles.popupmenu5,'value')==1
            ylabel('Water depth (m)');
            for i=1:length(graficos)
                graficos(i).YData=graficos(i).YData/100;
            end
            unidades=1;
        else
            ylabel('Water depth (cm)');
            for i=1:length(graficos)
                graficos(i).YData=graficos(i).YData*100;
            end
            unidades=2;
        end
    case 3
        if get(handles.popupmenu5,'value')==1
            ylabel('Water depth (mm)');
            for i=1:length(graficos)
                graficos(i).YData=graficos(i).YData*10;
            end
            unidades=1;
        else
            ylabel('Water depth (cm)');
            for i=1:length(graficos)
                graficos(i).YData=graficos(i).YData/10;
            end
            unidades=2;
        end
end
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
estado=logical(get(handles.checkbox1,'value'));
axes(handles.axesGraf)
ax=gca;
if estado
    ax.XMinorGrid='on';
    ax.YMinorGrid='on';
else
    ax.XMinorGrid='off';
    ax.YMinorGrid='off';
end
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
global ProyectoHidrologico
if get(handles.popupmenu1,'value')==1
    return;
end
set(handles.popupmenu2,'value',1);
set(handles.popupmenu3,'value',1);

switch get(handles.popupmenu1,'value')
    case 1
        return
    case 2
        
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        lista=cell(1,length(Node));
        for i=1:length(Node)
            lista{i}=['Node - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Surface runoff','Total flow','Flooding'});
        set(handles.pushbutton1,'BackgroundColor',[0,0,1])
    case 3
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
        lista=cell(1,length(Conduit));
        for i=1:length(Conduit)
            lista{i}=['Conduit - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Inflow','Outflow','Depth'});
        set(handles.pushbutton1,'BackgroundColor',[0.4660 0.6740 0.1880])
    case 4
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        lista=cell(1,length(Catchment));
        for i=1:length(Catchment)
            lista{i}=['Cuenca - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Runoff','Infiltration','Precipitation'});
        set(handles.pushbutton1,'BackgroundColor',[0.8500 0.3250 0.0980])
    case 5
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
        lista=cell(1,length(genRetention));
        for i=1:length(genRetention)
            lista{i}=['SUDS - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Inflow','Outflow','Directed runoff','Evolution'});
        set(handles.pushbutton1,'BackgroundColor',[0,0,1])
    case 6
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
        lista=cell(1,length(genDetention));
        for i=1:length(genDetention)
            lista{i}=['SUDS - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Inflow','Outflow','Directed runoff','Evolution'});
        set(handles.pushbutton1,'BackgroundColor',[0,0,1])
    case 7
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
        lista=cell(1,length(genInfiltration));
        for i=1:length(genInfiltration)
            lista{i}=['SUDS - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Inflow','Outflow','Directed runoff','Evolution'});
        set(handles.pushbutton1,'BackgroundColor',[0,0,1])
end
% hObject    h      andle to popupmenu1 (see GCBO)
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
global ProyectoHidrologico

switch get(handles.popupmenu1,'value')
    case 1
        return
    case 2
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Node.mat'),'Node');
        lista=cell(1,length(Node));
        for i=1:length(Node)
            lista{i}=['Node - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Surface runoff','Total flow','Flooding'});
    case 3
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Conduit.mat'),'Conduit');
        lista=cell(1,length(Conduit));
        for i=1:length(Conduit)
            lista{i}=['Conduit - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Inflow','Outflow','Depth'});
    case 4
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
        lista=cell(1,length(Catchment));
        for i=1:length(Catchment)
            lista{i}=['Catchment - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Runoff','Infiltration','Precipitation'});
    case 5
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
        lista=cell(1,length(genRetention));
        for i=1:length(genRetention)
            lista{i}=['SUDS - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Inflow','Outflow','Directed runoff','Evolution'});
    case 6
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
        lista=cell(1,length(genDetention));
        for i=1:length(genDetention)
            lista{i}=['SUDS - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Inflow','Outflow','Directed runoff','Evolution'});
    case 7
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
        lista=cell(1,length(genInfiltration));
        for i=1:length(genInfiltration)
            lista{i}=['SUDS - ',num2str(i)];
        end
        set(handles.popupmenu2,'string',lista);
        set(handles.popupmenu3,'string',{'Inflow','Outflow','Directed runoff','Evolution'});
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo nodosRef tuberiasRef cuencasRef unidades idioma
tol=1e-6;

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Results.mat'),'results');

axes(handles.axesGraf);
hold on
ax=gca;
color=get(handles.pushbutton1,'BackgroundColor');
switch get(handles.popupmenu4,'value')
    case 1
        linea='-';
    case 2
        linea='--';
    case 3
        linea=':';
    case 4
        linea='-.';
end
grosor=round(str2double(get(handles.edit1,'string')),1);

switch get(handles.popupmenu1,'value')
    case 2
        switch get(handles.popupmenu3,'value')
            case 1
                if modelo.bandera ==1 || modelo.bandera==0
                    a=results.directoNodo(:,2*get(handles.popupmenu2,'value')-1)/60;
                    b=results.directoNodo(:,2*get(handles.popupmenu2,'value'));
                    b(b<=tol)=0;
                    plot(a,b,'LineStyle',linea,'LineWidth',grosor,'Color',color)
                    if strcmp(idioma,'english')
                        tipo='Surface runoff';
                    else
                        tipo='Escorrentía directa';
                    end
                    
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 2
                if modelo.bandera ==1 || modelo.bandera==0
                    a=results.totalNodo(:,2*get(handles.popupmenu2,'value')-1)/60;
                    b=results.totalNodo(:,2*get(handles.popupmenu2,'value'));
                    b(b<=tol)=0;
                    plot(a,b,'LineStyle',linea,'LineWidth',grosor,'Color',color)
                    if strcmp(idioma,'english')
                        tipo='Total flow';
                    else
                        tipo='Flujo total';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 3 
                if modelo.bandera ==1 || modelo.bandera==0
                    a=results.inundacion(:,2*get(handles.popupmenu2,'value')-1)/60;
                    b=results.inundacion(:,2*get(handles.popupmenu2,'value'));
                    b(b<=tol)=0;
                    plot(a,b,'LineStyle',linea,'LineWidth',grosor,'Color',color)
                    if strcmp(idioma,'english')
                        tipo='Flooding';
                    else
                        tipo='Inundación';
                    end
                    
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
                
        end
        if strcmp(idioma,'english')
            nombre=['Node - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        else
            nombre=['Nodo - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        end
        
        set(nodosRef(get(handles.popupmenu2,'value')),'MarkerFaceColor',[1,0,0]);
    case 3
        switch get(handles.popupmenu3,'value')
            case 1
                if modelo.bandera ==1 || modelo.bandera==0
                    a=results.entradaTuberia(:,2*get(handles.popupmenu2,'value')-1)/60;
                    b=results.entradaTuberia(:,2*get(handles.popupmenu2,'value'));
                    b(b<=tol)=0;
                    plot(a,b,'LineStyle',linea,'LineWidth',grosor,'Color',color)
                    if strcmp(idioma,'english')
                        tipo='Inflow';
                    else
                        tipo='Entrada';
                    end
                    
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 2
                if modelo.bandera ==1 || modelo.bandera==0
                    a=results.salidaTuberia(:,2*get(handles.popupmenu2,'value')-1)/60;
                    b=results.salidaTuberia(:,2*get(handles.popupmenu2,'value'));
                    b(b<=tol)=0;
                    plot(a,b,'LineStyle',linea,'LineWidth',grosor,'Color',color)
                    modelo.bandera=1;
                    if strcmp(idioma,'english')
                        tipo='Outflow';
                    else
                        tipo='Salida';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end

            case 3
                if modelo.bandera ==2 || modelo.bandera==0
                    a=results.tirante(:,2*get(handles.popupmenu2,'value')-1)/60;
                    b=results.tirante(:,2*get(handles.popupmenu2,'value'));
                    b(b<=tol)=0;
                    plot(a,b,'LineStyle',linea,'LineWidth',grosor,'Color',color)
                    if strcmp(idioma,'english')
                        tipo='Depth';
                    else
                        tipo='Profundidad';
                    end
                    
                    modelo.bandera=2;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
                end
        if strcmp(idioma,'english')
            nombre=['Conduit - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        else
            nombre=['Tubería - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        end
        
        set(tuberiasRef(get(handles.popupmenu2,'value')),'Color',[1,0,0]);
    case 4
        switch get(handles.popupmenu3,'value')
            case 1
                if modelo.bandera ==1 || modelo.bandera==0
                    a=results.escorrentia(:,2*get(handles.popupmenu2,'value')-1)/60;
                    b=results.escorrentia(:,2*get(handles.popupmenu2,'value'));
                    b(b<=tol)=0;
                    plot(a,b,'LineStyle',linea,'LineWidth',grosor,'Color',color)
                    if strcmp(idioma,'english')
                        tipo='Runoff';
                    else
                        tipo='Escorrentía superficial';
                    end
                    
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 2
                if modelo.bandera ==3 || modelo.bandera==0
                    a=results.hietogramas(:,2*get(handles.popupmenu2,'value')-1)/60;
                    b=results.infiltracion(:,get(handles.popupmenu2,'value'))*1000;
                    b(b<=tol)=0;
                    plot(a(1:length(b)),b,'LineStyle',linea,'LineWidth',grosor)
                    if strcmp(idioma,'english')
                        tipo='Infiltration';
                    else
                        tipo='Infiltración';
                    end
                    modelo.bandera=3;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 3
                if modelo.bandera ==3 || modelo.bandera==0
                    a=results.hietogramas(:,2*get(handles.popupmenu2,'value')-1)/60;
                    b=results.hietogramas(:,2*get(handles.popupmenu2,'value'))*1000;
                    b(b<=tol)=0;
                    plot(a,b,'LineStyle',linea,'LineWidth',grosor)
                    if strcmp(idioma,'english')
                        tipo='Precipitation';
                    else
                        tipo='Precipitación';
                    end
                    
                    modelo.bandera=3;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
        end
        if strcmp(idioma,'english')
            nombre=['Catchment - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        else
            nombre=['Cuenca - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        end
        
        set(cuencasRef(get(handles.popupmenu2,'value')),'FaceColor',[1,0,0]);
    case 5
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genRetention.mat'),'genRetention');
        switch get(handles.popupmenu3,'value')
            case 1
                if modelo.bandera ==1 || modelo.bandera==0
                    plotEntrada(genRetention(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Inflow';
                    else
                        tipo='Entrada';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 2
                if modelo.bandera ==1 || modelo.bandera==0
                    plotSalida(genRetention(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Outflow';
                    else
                        tipo='Salida';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 3
                if modelo.bandera ==1 || modelo.bandera==0
                    plotEntradaD(genRetention(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Runoff';
                    else
                        tipo='Escorrentía directa';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 4
                if modelo.bandera ==4 || modelo.bandera==0
                    plotEvolucion(genRetention(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Volume';
                    else
                        tipo='Volumen';
                    end
                    modelo.bandera=4;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
        end
        if strcmp(idioma,'english')
            nombre=['Retention - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        else
            nombre=['Retención - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        end

        set(cuencasRef(genRetention(get(handles.popupmenu2,'value')).cuenca),'FaceColor',[0.49,0.18,0.56]);
    case 6
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genDetention.mat'),'genDetention');
        switch get(handles.popupmenu3,'value')
            case 1
                if modelo.bandera ==1 || modelo.bandera==0
                    plotEntrada(genDetention(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Inflow';
                    else
                        tipo='Entrada';
                    end
                    modelo.bandera=1;
                else
                     if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 2
                if modelo.bandera ==1 || modelo.bandera==0
                    plotSalida(genDetention(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Outflow';
                    else
                        tipo='Salida';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 3
                if modelo.bandera ==1 || modelo.bandera==0
                    plotEntradaD(genDetention(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Runoff';
                    else
                        tipo='Escorrentía directa';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 4
                if modelo.bandera ==2 || modelo.bandera==0
                    plotEvolucion(genDetention(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Depth';
                    else
                        tipo='Profundidad';
                    end
                    modelo.bandera=2;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
        end
        if strcmp(idioma,'english')
            nombre=['Detention - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        else
            nombre=['Detención - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        end
        set(cuencasRef(genDetention(get(handles.popupmenu2,'value')).cuenca),'FaceColor',[0.49,0.18,0.56]);
    case 7
        load(fullfile(ProyectoHidrologico.carpetaBase,'Data','genInfiltration.mat'),'genInfiltration');
        switch get(handles.popupmenu3,'value')
            case 1
                if modelo.bandera ==1 || modelo.bandera==0
                    plotEntrada(genInfiltration(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Inflow';
                    else
                        tipo='Entrada';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 2
                if modelo.bandera ==1 || modelo.bandera==0
                    plotSalida(genInfiltration(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Outflow';
                    else
                        tipo='Salida';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 3
                if modelo.bandera ==1 || modelo.bandera==0
                    plotEntradaD(genInfiltration(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Runoff';
                    else
                        tipo='Escorrentía directa';
                    end
                    modelo.bandera=1;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
            case 4
                if modelo.bandera ==5 || modelo.bandera==0
                    plotEvolucion(genInfiltration(get(handles.popupmenu2,'value')),linea,grosor,color)
                    if strcmp(idioma,'english')
                        tipo='Depth';
                    else
                        tipo='Profundidad';
                    end
                    modelo.bandera=5;
                else
                    if strcmp(idioma,'english')
                        Aviso('Choose compatible charts','Error','error');
                    else
                        Aviso('Elegir gráficos compatibles','Error','error');
                    end
                    return
                end
        end
        if strcmp(idioma,'english')
            nombre=['Infiltration - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        else
            nombre=['Infiltración - ',num2str(get(handles.popupmenu2,'value')),' - ',tipo];
        end
        
        set(cuencasRef(genInfiltration(get(handles.popupmenu2,'value')).cuenca),'FaceColor',[0.49,0.18,0.56]);
end

if isempty(ax.Children)
    return
elseif length(ax.Children) ==1
    set(handles.popupmenu6,'string',nombre);
    legend(gca,nombre);
else
    actual=get(handles.popupmenu6,'string');
    nuevo={nombre};
    set(handles.popupmenu6,'string',[nuevo;actual;]);
    legend(gca,[actual;nuevo]);
end

switch modelo.bandera
    case 1
        if strcmp(idioma,'english')
            ylabel('Flow (m3/s)') 
            xlabel('Time (min)') 
        else
            ylabel('Flujo (m3/s)') 
            xlabel('Tiempo (min)') 
        end

        ax.FontSize=9;
        if length(ax.Children) ==1
            set(handles.popupmenu5,'string',{'m3/s','l/s'});
            unidades=1;
        end
    case 2
        if strcmp(idioma,'english')
            ylabel('Depth (m)') 
            xlabel('Time (min)') 
        else
            ylabel('Profundidad (m3/s)') 
            xlabel('Tiempo (min)') 
        end
        ax.FontSize=9;
        if length(ax.Children) ==1
            set(handles.popupmenu5,'string',{'m','cm'});
            unidades=1;
        end
    case 3
        if strcmp(idioma,'english')
            ylabel('Precipitation (mm)') 
            xlabel('Time (min)') 
        else
            ylabel('Precipitación (mm)') 
            xlabel('Tiempo (min)') 
        end
        ax.FontSize=9;
        if length(ax.Children) ==1
            set(handles.popupmenu5,'string',{'mm','cm'});
            unidades=1;
        end
    case 4
        if strcmp(idioma,'english')
            ylabel('Volume (m3)') 
            xlabel('Time (min)') 
        else
            ylabel('Volumen (m3)') 
            xlabel('Tiempo (min)') 
        end
        ax.FontSize=9;
        if length(ax.Children) ==1
            set(handles.popupmenu5,'string',{'mm','cm'});
            unidades=1;
        end
    case 5
        if strcmp(idioma,'english')
            ylabel('Infiltration (mm)') 
            xlabel('Time (min)') 
        else
            ylabel('Infiltración (mm)') 
            xlabel('Tiempo (min)') 
        end 
        ax.FontSize=9;
        if length(ax.Children) ==1
            set(handles.popupmenu5,'string',{'mm','cm'});
            unidades=1;
        end
end

if unidades ==2
    grafico=ax.Children(1);
    switch modelo.bandera
        case 1
            grafico.YData=grafico.YData*1000;
    
        case 2
            grafico.YData=grafico.YData*100;
        case 3
           grafico.YData=grafico.YData/10;
        case 5
           grafico.YData=grafico.YData/10;
    end
end 


% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close graficasSimulacion.
function graficasSimulacion_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to graficasSimulacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deleteGlobal('parcial')
% Hint: delete(hObject) closes the figure
delete(hObject);
