function varargout = impactoHidrologico(varargin)
%% impactoHidrologico
% //    Description:
% //        -Get hydrological impact analysis
% //    Update History
% =============================================================
%
% IMPACTOHIDROLOGICO MATLAB code for impactoHidrologico.fig
%      IMPACTOHIDROLOGICO, by itself, creates a new IMPACTOHIDROLOGICO or raises the existing
%      singleton*.
%
%      H = IMPACTOHIDROLOGICO returns the handle to a new IMPACTOHIDROLOGICO or the handle to
%      the existing singleton*.
%
%      IMPACTOHIDROLOGICO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMPACTOHIDROLOGICO.M with the given input arguments.
%
%      IMPACTOHIDROLOGICO('Property','Value',...) creates a new IMPACTOHIDROLOGICO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before impactoHidrologico_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to impactoHidrologico_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help impactoHidrologico

% Last Modified by GUIDE v2.5 02-Feb-2024 12:03:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @impactoHidrologico_OpeningFcn, ...
                   'gui_OutputFcn',  @impactoHidrologico_OutputFcn, ...
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


% --- Executes just before impactoHidrologico is made visible.
function impactoHidrologico_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to impactoHidrologico (see VARARGIN)
 
global modelo ProyectoHidrologico idioma

h= findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.estimarImpacto,'Position');
pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.75;
pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.35;
posicion=[pos1,pos2,posicion2(3:4)];
set(handles.estimarImpacto,'Position',posicion)
set(handles.estimarImpacto,'visible','on')

grafico.RHN=false;
grafico.RHU=false;
grafico.RHSUDS=false;
modelo.bandera=grafico;

axes1=handles.axes1;
axes1.FontName='Open Sans';
axes1.FontUnits='points';
axes1.FontSize=9;
axes1.XGrid='on';
axes1.YGrid='on';
hold on

xlabel('Simulation time (min)');
ylabel('Flow rate (m3/s)');
legend(axes1,'show');

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Scenario.mat'),'Scenario');

if ~isempty(Scenario) 
    natural={'----------'};
    urbana={'----------'};
    suds={'----------'};
    for i=1:length(Scenario)
        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(i).nombre],'NaturalResponse.mat'))
            load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(i).nombre],'NaturalResponse.mat'),'NaturalResponse')
            if ~isempty(NaturalResponse)
                natural =[natural;{Scenario(i).nombre}];
            end
        end
        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(i).nombre],'UrbanResponse.mat'))
            urbana =[urbana;{Scenario(i).nombre}];
        end
        if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',Scenario(i).nombre],'SUDSResponse.mat'))
            suds =[suds;{Scenario(i).nombre}];
        end
    end
end

if ~isempty(natural)
    set(handles.popupmenu10,'string',natural)
end
if ~isempty(urbana)
    set(handles.popupmenu11,'string',urbana)
end
if ~isempty(suds)
    set(handles.popupmenu12,'string',suds)
end

if strcmp(idioma,'spanish')
    set(handles.text11,'string','Respuesta hidrológica')
    set(handles.text12,'string','Urbana')
    set(handles.text14,'string','Tiempo pico')
    set(handles.text20,'string','Caudal pico')
    set(handles.text21,'string','Escorrentía')
    set(handles.text29,'string','Urbana')
    set(handles.text26,'string','Tiempo pico')
    set(handles.text27,'string','Caudal pico')
    set(handles.text28,'string','Escorrentía')
    set(handles.text48,'string','Tiempo pico')
    set(handles.text49,'string','Caudal pico')
    set(handles.text50,'string','Escorrentía')
    set(handles.text39,'string','Impacto hidrológico')
    set(handles.text33,'string','Tiempo pico')
    set(handles.text34,'string','Caudal pico')
    set(handles.text35,'string','Escorrentía')
    set(handles.text59,'string','Beneficios hidrológicos SUDS')
    set(handles.text57,'string','Tiempo pico')
    set(handles.text56,'string','Caudal pico')
    set(handles.text55,'string','Escorrentía')
    set(handles.text40,'string','Opciones gráficas')
    set(handles.text47,'string','Gráfico')
    set(handles.popupmenu9,'string',{'Natural','Urbana','SUDS'})
    set(handles.text43,'string','Línea')
    set(handles.text44,'string','Tipo')
    set(handles.text42,'string','Ancho')
    set(handles.text45,'string','Opciones de eje')
    set(handles.text62,'string','Tamaño')
end

% Choose default command line output for impactoHidrologico
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes impactoHidrologico wait for user response (see UIRESUME)
% uiwait(handles.estimarImpacto);


% --- Outputs from this function are returned to the command line.
function varargout = impactoHidrologico_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.estimarImpacto,'visible','on')
% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
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


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit16_Callback(hObject, eventdata, handles)
global modelo idioma
ax=(handles.axes1);
if isempty(ax.Children)
    return;
end
g = str2double(get(handles.edit16,'string'));
if isempty(g) || isnan(g)
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return
end

switch get(handles.popupmenu9,'value')
    case 1
        if modelo.bandera.RHU && modelo.bandera.RHSUDS && modelo.bandera.RHN
            grafico=ax.Children(2);
        elseif modelo.bandera.RHSUDS && modelo.bandera.RHN
            grafico=ax.Children(2);
        elseif modelo.bandera.RHN
            grafico=ax.Children(1);
        end
    case 2
       if modelo.bandera.RHU
          grafico=ax.Children(end);
       end
    case 3
       if modelo.bandera.RHU
           grafico=ax.Children(1);
       end
end
grafico.LineWidth=g;
set(handles.edit16,'string',g);
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
incremento=get(handles.slider2,'value');
set(handles.slider2, 'Value', 0.5);
valor=str2double(get(handles.edit16,'string'));
if incremento>0.5
    valor=valor+0.5;
else
    valor=valor-0.5;
end

if valor<=0
    return
else
    set(handles.edit16,'string',valor)
    edit16_Callback(hObject, eventdata, handles)
end
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


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
global modelo
ax=(handles.axes1);
if isempty(ax.Children)
    return;
end
color = uisetcolor(get(handles.pushbutton8,'BackgroundColor'));
if color == get(handles.pushbutton8,'BackgroundColor')
    return
end

switch get(handles.popupmenu9,'value')
    case 1
        if modelo.bandera.RHU && modelo.bandera.RHSUDS && modelo.bandera.RHN
            grafico=ax.Children(2);
        elseif modelo.bandera.RHSUDS && modelo.bandera.RHN
            grafico=ax.Children(2);
        elseif modelo.bandera.RHN
            grafico=ax.Children(1);
        end
    case 2
       if modelo.bandera.RHU
          grafico=ax.Children(end);
       end
    case 3
       if modelo.bandera.RHU
           grafico=ax.Children(1);
       end
end
grafico.Color=color;
set(handles.pushbutton8,'BackgroundColor',color)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
global modelo
ax=(handles.axes1);

if isempty(ax.Children)
    return;
end
switch get(handles.popupmenu7,'value')
    case 1
        linea='-';
    case 2
        linea='--';
    case 3
        linea=':';
    case 4
        linea='-.';
end


switch get(handles.popupmenu9,'value')
    case 1
        if modelo.bandera.RHU && modelo.bandera.RHSUDS && modelo.bandera.RHN
            grafico=ax.Children(2);
        elseif modelo.bandera.RHSUDS && modelo.bandera.RHN
            grafico=ax.Children(2);
        elseif modelo.bandera.RHN
            grafico=ax.Children(1);
        end
    case 2
       if modelo.bandera.RHU
          grafico=ax.Children(end);
       end
    case 3
       if modelo.bandera.RHU
           grafico=ax.Children(1);
       end
end

grafico.LineStyle=linea;
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
estado=logical(get(handles.checkbox2,'value'));
axes(handles.axes1)
ax=gca;
if estado
    ax.XMinorGrid='on';
    ax.YMinorGrid='on';
else
    ax.XMinorGrid='off';
    ax.YMinorGrid='off';
end
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
global modelo

id=get(handles.popupmenu9,'value');
ax=(handles.axes1);
if isempty(ax.Children)
    return;
end

switch id
    case 1
        if ~isempty(ax.Children) && (modelo.bandera.RHN && ~modelo.bandera.RHSUDS)
            grafico=ax.Children(1);
        elseif modelo.bandera.RHN && modelo.bandera.RHSUDS
            grafico=ax.Children(2);
        else
            return
        end
    case 2
        if modelo.bandera.RHU
            grafico=ax.Children(end);
        end
    case 3
        if modelo.bandera.RHSUDS
            grafico=ax.Children(1);
        end
end
set(handles.pushbutton8,'BackgroundColor',grafico.Color);
set(handles.edit16,'string',grafico.LineWidth);
switch grafico.LineStyle
    case '-'
        set(handles.popupmenu7,'value',1);
    case '--'
        set(handles.popupmenu7,'value',2);
    case ':'
        set(handles.popupmenu7,'value',3);
    case '-.'
        set(handles.popupmenu7,'value',4);
end
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
global modelo
h= findobj('tag','estimarImpacto');
posicion1=h.Position;
posicion2=get(handles.uipanel1,'Position');
pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.75;
pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.35;
posicion=[pos1,pos2,posicion2(3:4)];

ax=(handles.axes1);
f2 = figure();
f2.Position=posicion;
ax2 = copyobj(ax,f2);
legend;
if modelo.bandera.RHN && modelo.bandera.RHU && ~modelo.bandera.RHSUDS
annotation(f2,'textbox',...
    [0.65 0.6 0.27 0.15],...
    'String',{'Urban hydrological impact',['Peak flow =',get(handles.edit14,'string'),' m3/s'],['Peak time = ',get(handles.edit13,'string'),' min'],...
    ['Runoff = ',get(handles.edit15,'string'),' mm/m2']},...
    'BackgroundColor',[1 0.968627452850342 0.921568632125854],'FontName','Open Sans','FontUnits','points','FontSize',ax.FontSize,'Interpreter','latex','FitBoxToText','on');
end
if modelo.bandera.RHN && modelo.bandera.RHU && modelo.bandera.RHSUDS
annotation(f2,'textbox',...
    [0.65 0.6 0.27 0.15],...
    'String',{'Urban hydrological impact',['Peak flow =',get(handles.edit14,'string'),' m3/s'],['Peak time = ',get(handles.edit13,'string'),' min'],...
    ['Runoff = ',get(handles.edit15,'string'),' mm/m2']},...
    'BackgroundColor',[1 0.968627452850342 0.921568632125854],'FontName','Open Sans','FontUnits','points','FontSize',ax.FontSize,'Interpreter','latex','FitBoxToText','on');
annotation(f2,'textbox',...
    [0.65 0.4 0.27 0.15],...
    'String',{'SUDS impact',['Peak flow =',get(handles.edit21,'string'),' m3/s'],['Peak time = ',get(handles.edit22,'string'),' min'],...
    ['Runoff = ',get(handles.edit20,'string'),' mm/m2']},...
    'BackgroundColor',[1 0.968627452850342 0.921568632125854],'FontName','Open Sans','FontUnits','points','FontSize',ax.FontSize,'Interpreter','latex','FitBoxToText','on');
end
if modelo.bandera.RHN
    if modelo.bandera.RHU && modelo.bandera.RHSUDS && modelo.bandera.RHN
        grafico=ax2.Children(2);
    elseif modelo.bandera.RHSUDS && modelo.bandera.RHN
        grafico=ax2.Children(2);
    elseif modelo.bandera.RHN
        grafico=ax2.Children(1);
    end
    y=max(grafico.YData);
    u=y==grafico.YData;
    x=grafico.XData(u);
    x=x(1);
    dt = datatip(grafico,x,y);
    grafico.DataTipTemplate.Interpreter='latex';
    grafico.DataTipTemplate.FontName='Open Sans';
    a=dataTipTextRow('Peak time (min): ',grafico.XData,'%0.1f');
    grafico.DataTipTemplate.DataTipRows(1)=a;
    b=dataTipTextRow('Peak flow (m3/s): ',grafico.YData,'%0.2f');
    grafico.DataTipTemplate.DataTipRows(2)=b;
    
    
end

if modelo.bandera.RHU
    grafico=ax2.Children(end);
    y=max(grafico.YData);
    u=y==grafico.YData;
    x=grafico.XData(u);
    x=x(1);
    dt = datatip(grafico,x,y);
    grafico.DataTipTemplate.Interpreter='latex';
    grafico.DataTipTemplate.FontName='Open Sans';
    a=dataTipTextRow('Peak time (min): ',grafico.XData,'%0.1f');
    grafico.DataTipTemplate.DataTipRows(1)=a;
    b=dataTipTextRow('Peak flow (m3/s): ',grafico.YData,'%0.2f');
    grafico.DataTipTemplate.DataTipRows(2)=b;
end

if modelo.bandera.RHSUDS
    grafico=ax2.Children(1);
    y=max(grafico.YData);
    u=y==grafico.YData;
    x=grafico.XData(u);
    x=x(1);
    dt = datatip(grafico,x,y);
    
    grafico.DataTipTemplate.Interpreter='latex';
    grafico.DataTipTemplate.FontName='Open Sans';
    a=dataTipTextRow('Peak time (min): ',grafico.XData,'%0.1f');
    grafico.DataTipTemplate.DataTipRows(1)=a;
    b=dataTipTextRow('Peak flow (m3/s): ',grafico.YData,'%0.2f');
    grafico.DataTipTemplate.DataTipRows(2)=b;
end
a=findall(gca);
for i=1:length(a)
    h=a(i);
    switch h.Type
        case 'hggroup'
            set(h,'BackgroundAlpha', 0)
            set(h,'EdgeColor','none')
    end
end

% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
global modelo
ax=(handles.axes1);
switch get(handles.popupmenu9,'value')
    case 1
        if modelo.bandera.RHU && modelo.bandera.RHSUDS && modelo.bandera.RHN
            delete(ax.Children(2));
        elseif modelo.bandera.RHSUDS && modelo.bandera.RHN
            delete(ax.Children(2));
        elseif modelo.bandera.RHN
            delete(ax.Children(1));
        end
        set(handles.edit2,'string','');
        set(handles.edit5,'string','');
        set(handles.edit6,'string','');
        modelo.bandera.RHN=false;
    case 2
       if modelo.bandera.RHU
           delete(ax.Children(end));
           modelo.bandera.RHU=false;
       end
        set(handles.edit10,'string','');
        set(handles.edit11,'string','');
        set(handles.edit12,'string','');
    case 3
       if modelo.bandera.RHSUDS
           delete(ax.Children(1));
           modelo.bandera.RHSUDS=false;
           set(handles.edit17,'string','');
           set(handles.edit18,'string','');
           set(handles.edit19,'string','');
       end
end
evaluarImpacto(handles);
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
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



function evaluarImpacto (handles)
global modelo

if modelo.bandera.RHN && modelo.bandera.RHU && ~modelo.bandera.RHSUDS
    peakTN=str2double(get(handles.edit5,'string'));
    peakN=str2double(get(handles.edit2,'string'));
    runoffN=str2double(get(handles.edit6,'string'));

    peakTU=str2double(get(handles.edit10,'string'));
    peakU=str2double(get(handles.edit11,'string'));
    runoffU=str2double(get(handles.edit12,'string'));

    set(handles.edit13,'string',sprintf('%.2f',peakTU-peakTN));
    set(handles.edit14,'string',sprintf('%.2f',peakU-peakN));
    set(handles.edit15,'string',sprintf('%.2f',runoffU-runoffN));

    if peakTU-peakTN<0
        set(handles.edit13,'ForegroundColor',[1 0 0]);
    else
        set(handles.edit13,'ForegroundColor',[0.47 0.67 0.19]);
    end
    
    if peakU-peakN>0
        set(handles.edit14,'ForegroundColor',[1 0 0]);
    else
        set(handles.edit14,'ForegroundColor',[0.47 0.67 0.19]);
    end
    if runoffU-runoffN>0
        set(handles.edit15,'ForegroundColor',[1 0 0]);
    else
        set(handles.edit15,'ForegroundColor',[0.47 0.67 0.19]);
    end
    set(handles.edit22,'string','');
    set(handles.edit21,'string','');
    set(handles.edit20,'string','');

elseif modelo.bandera.RHN && modelo.bandera.RHU && modelo.bandera.RHSUDS
    peakTN=str2double(get(handles.edit5,'string'));
    peakN=str2double(get(handles.edit2,'string'));
    runoffN=str2double(get(handles.edit6,'string'));

    peakTSUDS=str2double(get(handles.edit17,'string'));
    peakSUDS=str2double(get(handles.edit18,'string'));
    runoffSUDS=str2double(get(handles.edit19,'string'));
    
    peakTU=str2double(get(handles.edit10,'string'));
    peakU=str2double(get(handles.edit11,'string'));
    runoffU=str2double(get(handles.edit12,'string'));

    set(handles.edit13,'string',sprintf('%.2f',peakTU-peakTN));
    set(handles.edit14,'string',sprintf('%.2f',peakU-peakN));
    set(handles.edit15,'string',sprintf('%.2f',runoffU-runoffN));

    if peakTU-peakTN<0
        set(handles.edit13,'ForegroundColor',[1 0 0]);
    else
        set(handles.edit13,'ForegroundColor',[0.47 0.67 0.19]);
    end
    
    if peakU-peakN>0
        set(handles.edit14,'ForegroundColor',[1 0 0]);
    else
        set(handles.edit14,'ForegroundColor',[0.47 0.67 0.19]);
    end
    if runoffU-runoffN>0
        set(handles.edit15,'ForegroundColor',[1 0 0]);
    else
        set(handles.edit15,'ForegroundColor',[0.47 0.67 0.19]);
    end

    set(handles.edit22,'string',sprintf('%.2f',peakTSUDS-peakTU));
    set(handles.edit21,'string',sprintf('%.2f',peakU-peakSUDS));
    set(handles.edit20,'string',sprintf('%.2f',runoffU-runoffSUDS));

   if peakTSUDS-peakTU<0
        set(handles.edit22,'ForegroundColor',[1 0 0]);
    else
        set(handles.edit22,'ForegroundColor',[0.47 0.67 0.19]);
    end
    
    if peakU-peakSUDS<0
        set(handles.edit21,'ForegroundColor',[1 0 0]);
    else
        set(handles.edit21,'ForegroundColor',[0.47 0.67 0.19]);
    end
    if runoffU-runoffN<0
        set(handles.edit20,'ForegroundColor',[1 0 0]);
    else
        set(handles.edit20,'ForegroundColor',[0.47 0.67 0.19]);
    end

elseif (~modelo.bandera.RHU && ~modelo.bandera.RHSUDS) || ~modelo.bandera.RHN
    set(handles.edit13,'string','');
    set(handles.edit14,'string','');
    set(handles.edit15,'string','');
    
elseif ~modelo.bandera.RHSUDS
    set(handles.edit22,'string','');
    set(handles.edit21,'string','');
    set(handles.edit20,'string','');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
global idioma
ax=(handles.axes1);
if isempty(ax.Children)
    return;
end
g = str2double(get(handles.edit23,'string'));
if isempty(g) || isnan(g)
    if strcmp(idioma,'english')
        Aviso('Verify value','Error','error');
    else
        Aviso('Verificar valor','Error','error');
    end
    return
end

ax.FontSize=g;
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
incremento=get(handles.slider3,'value');
set(handles.slider3, 'Value', 0.5);
valor=str2double(get(handles.edit23,'string'));
if incremento>0.5
    valor=valor+0.5;
else
    valor=valor-0.5;
end

if valor<=0
    return
else
    set(handles.edit23,'string',valor)
    edit23_Callback(hObject, eventdata, handles)
end
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
tol=1e-6;
archivo=get(handles.popupmenu10,'value');

if archivo==1
    return
end

respuestas=get(handles.popupmenu10,'string');
nombre=respuestas{archivo};

if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'NaturalResponse.mat'))
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'NaturalResponse.mat'),'NaturalResponse');
    if isempty(NaturalResponse)
        if strcmp(idioma,'english')
            Aviso('There are no hydrological responses','Error','error');
        else
            Aviso('No existe respuesta hidrológica','Error','error');
        end
        return
    end
else
    if strcmp(idioma,'english')
        Aviso('Select natural response','Error','error');
    else
        Aviso('Seleccionar respuesta natural','Error','error');
    end
    
    set(handles.edit2,'string','');
    set(handles.edit5,'string','');
    set(handles.edit6,'string','');
    return;
end

ax=(handles.axes1);
if modelo.bandera.RHU && modelo.bandera.RHSUDS && modelo.bandera.RHN
    delete(ax.Children(2));
elseif modelo.bandera.RHSUDS && modelo.bandera.RHN
    delete(ax.Children(2));
elseif modelo.bandera.RHN
    delete(ax.Children(1));
end

if length(NaturalResponse)==1
    RHN=NaturalResponse;
else
    Tor=cell(1,length(NaturalResponse));
    for i=1:length(NaturalResponse)
        Tor{i}=['ID-',num2str(i)];
    end
    if strcmp(idioma,'english')
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Natural response','SelectionMode','single');
    else
        Z = listdlg('ListString',Tor,'ListSize',[200,150],'Name','Respuesta natural','SelectionMode','single');
    end
    
    if ~isempty(Z)
        RHN=NaturalResponse(Z);
    else
        return;
    end
end
if isempty(RHN.hidrograma)
    if strcmp(idioma,'english')
        Aviso('No data avaible','Error','error');
    else
        Aviso('No existen datos disponibles','Error','error');
    end
    return
end

set(handles.popupmenu9,'value',1)
set(handles.popupmenu7,'value',1)
set(handles.pushbutton8,'BackgroundColor',[0.47 0.67 0.19]);

axes(handles.axes1);
hold on
ax=gca;
color=get(handles.pushbutton8,'BackgroundColor');
switch get(handles.popupmenu7,'value')
    case 1
        linea='-';
    case 2
        linea='--';
    case 3
        linea=':';
    case 4
        linea='-.';
end
grosor=round(str2double(get(handles.edit16,'string')),1);
a=RHN.hidrograma(:,1)/60;
b=RHN.hidrograma(:,2);
b(b<=tol)=0;
plot(a,b,'DisplayName','Natural','LineStyle',linea,'LineWidth',grosor,'Color',color)

vol=trapz(RHN.hidrograma(:,1),RHN.hidrograma(:,2));
peak=max(RHN.hidrograma(:,2));
u=find(RHN.hidrograma(:,2)==peak);
time=RHN.hidrograma(u(1),1);

area=RHN.area*10000;
set(handles.edit2,'string',sprintf('%.2f',peak));
set(handles.edit5,'string',sprintf('%.2f',time/60));
set(handles.edit6,'string',sprintf('%.2f',1000*vol/area));
modelo.bandera.RHN=true;
evaluarImpacto(handles);

if modelo.bandera.RHU && modelo.bandera.RHSUDS
    ax.Children=ax.Children([2,1,3]);
elseif modelo.bandera.RHSUDS
    ax.Children=ax.Children([2,1]);
end

% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
tol=1e-6;
archivo=get(handles.popupmenu11,'value');

if archivo==1
    return
end

respuestas=get(handles.popupmenu11,'string');
nombre=respuestas{archivo};

if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'UrbanResponse.mat'))
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'UrbanResponse.mat'),'UrbanResponse');
    if isempty(UrbanResponse)
        if strcmp(idioma,'english')
            Aviso('There are no hydrological responses','Error','error');
        else
            Aviso('No existe respuesta hidrológica','Error','error');
        end
        return
    end
else
    if strcmp(idioma,'english')
        Aviso('Select urban response','Error','error');
    else
        Aviso('Seleccionar respuesta urbana','Error','error');
    end
    
    set(handles.edit11,'string','');
    set(handles.edit10,'string','');
    set(handles.edit12,'string','');
    return;
end
ax=(handles.axes1);
if modelo.bandera.RHU
    delete(ax.Children(end));
end
load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'UrbanResponse.mat'),'UrbanResponse');
if ~exist('UrbanResponse') || size(UrbanResponse,2)>2
    if strcmp(idioma,'english')
        Aviso('Empty file','Error','error');
    else
        Aviso('Archivo vacío','Error','error');
    end
    
    set(handles.edit11,'string','');
    set(handles.edit10,'string','');
    set(handles.edit12,'string','');
    return
end
set(handles.popupmenu9,'value',2)
set(handles.popupmenu9,'value',2)
set(handles.pushbutton8,'BackgroundColor',[1 0 0]);

axes(handles.axes1);
hold on
ax=gca;
color=get(handles.pushbutton8,'BackgroundColor');
switch get(handles.popupmenu7,'value')
    case 1
        linea='-';
    case 2
        linea='--';
    case 3
        linea=':';
    case 4
        linea='-.';
end
grosor=round(str2double(get(handles.edit16,'string')),1);

a=UrbanResponse(:,1)/60;
b=UrbanResponse(:,2);
b(b<=tol)=0;

if strcmp(idioma,'english')
    plot(a,b,'DisplayName','Urban','LineStyle',linea,'LineWidth',grosor,'Color',color)
else
    plot(a,b,'DisplayName','Urbana','LineStyle',linea,'LineWidth',grosor,'Color',color)
end

vol=trapz(UrbanResponse(:,1),UrbanResponse(:,2));
peak=max(UrbanResponse(:,2));
u=find(UrbanResponse(:,2)==peak);
time=UrbanResponse(u(1),1);
load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'StormwaterSystem.mat'),'stormwaterSystem');
cuencas=stormwaterSystem.Catchment;
area=sum([cuencas.area],'omitnan')*10000;
set(handles.edit11,'string',sprintf('%.2f',peak));
set(handles.edit10,'string',sprintf('%.2f',time/60));
set(handles.edit12,'string',sprintf('%.2f',1000*vol/area));
modelo.bandera.RHU=true;
evaluarImpacto(handles);

if modelo.bandera.RHN && modelo.bandera.RHSUDS
    ax.Children=ax.Children([2,3,1]);
elseif modelo.bandera.RHSUDS || modelo.bandera.RHN
    ax.Children=ax.Children([2,1]);
end
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
global ProyectoHidrologico modelo idioma
tol=1e-6;
archivo=get(handles.popupmenu12,'value');
respuestas=get(handles.popupmenu12,'string');
nombre=respuestas{archivo};

if exist(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'SUDSResponse.mat'))
    load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'SUDSResponse.mat'),'SUDSResponse');
    if isempty(SUDSResponse)
        if strcmp(idioma,'english')
            Aviso('There are no hydrological responses','Error','error');
        else
            Aviso('No existe respuesta hidrológica','Error','error');
        end
        return
    end
else
    if strcmp(idioma,'english')
        Aviso('Select SUDS response','Error','error');
    else
        Aviso('Seleccionar respuesta SUDS','Error','error');
    end
    
    set(handles.edit18,'string','');
    set(handles.edit17,'string','');
    set(handles.edit19,'string','');
    return;
end

ax=(handles.axes1);
if modelo.bandera.RHSUDS
    delete(ax.Children(1));
end
load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'SUDSResponse.mat'),'SUDSResponse');
if ~exist("SUDSResponse") || size(SUDSResponse,2)>2
    if strcmp(idioma,'english')
        Aviso('Empty file','Error','error');
    else
        Aviso('Archivo vacío','Error','error');
    end
    set(handles.edit18,'string','');
    set(handles.edit17,'string','');
    set(handles.edit19,'string','');
    return
end

set(handles.popupmenu9,'value',3)
set(handles.popupmenu9,'value',3)
set(handles.pushbutton8,'BackgroundColor',[0.49 0.18 0.56]);
axes(handles.axes1);
hold on
ax=gca;
color=get(handles.pushbutton8,'BackgroundColor');
switch get(handles.popupmenu7,'value')
    case 1
        linea='-';
    case 2
        linea='--';
    case 3
        linea=':';
    case 4
        linea='-.';
end
grosor=round(str2double(get(handles.edit16,'string')),1);
a=SUDSResponse(:,1)/60;
b=SUDSResponse(:,2);
b(b<=tol)=0;
plot(a,b,'DisplayName','SUDS','LineStyle',linea,'LineWidth',grosor,'Color',color)

vol=trapz(SUDSResponse(:,1),SUDSResponse(:,2));
peak=max(SUDSResponse(:,2));
u=find(SUDSResponse(:,2)==peak);
time=SUDSResponse(u(1),1);

load(fullfile(ProyectoHidrologico.carpetaBase,'Data',['Sim_',nombre],'StormwaterSystem.mat'),'stormwaterSystem');
cuencas=stormwaterSystem.Catchment;
area=sum([cuencas.area],'omitnan')*10000;
set(handles.edit18,'string',sprintf('%.2f',peak));
set(handles.edit17,'string',sprintf('%.2f',time/60));
set(handles.edit19,'string',sprintf('%.2f',1000*vol/area));
modelo.bandera.RHSUDS=true;
evaluarImpacto(handles);
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
