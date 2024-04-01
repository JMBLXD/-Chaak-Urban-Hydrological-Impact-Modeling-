function varargout = asignarAreasGen(varargin)
%% asignarAreasGen
% //    Description:
% //        -Set SUDS catchment area 
% //    Update History
% =============================================================
%
% ASIGNARAREASGEN MATLAB code for asignarAreasGen.fig
%      ASIGNARAREASGEN, by itself, creates a new ASIGNARAREASGEN or raises the existing
%      singleton*.
%
%      H = ASIGNARAREASGEN returns the handle to a new ASIGNARAREASGEN or the handle to
%      the existing singleton*.
%
%      ASIGNARAREASGEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASIGNARAREASGEN.M with the given input arguments.
%
%      ASIGNARAREASGEN('Property','Value',...) creates a new ASIGNARAREASGEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before asignarAreasGen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to asignarAreasGen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help asignarAreasGen

% Last Modified by GUIDE v2.5 23-Jul-2023 18:06:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @asignarAreasGen_OpeningFcn, ...
                   'gui_OutputFcn',  @asignarAreasGen_OutputFcn, ...
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


% --- Executes just before asignarAreasGen is made visible.
function asignarAreasGen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to asignarAreasGen (see VARARGIN)
global modelo ProyectoHidrologico idioma
h = findobj('tag','moduloHidrologico');
posicion1=h.Position;
posicion2=get(handles.asignarAreasGen,'Position');
posicion=[(posicion1(1:2)+posicion1(3:4)/2)-(posicion2(3:4)/2),posicion2(3:4)];
set(handles.asignarAreasGen,'Position',posicion)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(gcf,'javaframe');
jIcon=javax.swing.ImageIcon(fullfile('data','tanque.png'));
jframe.setFigureIcon(jIcon);

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
ID=modelo.bandera.cuenca;
set(handles.edit7,'string',ID);
set(handles.edit14,'string',Catchment(ID).escorrentia.metodo);

areaD=(1-Catchment(ID).areaSUDS-modelo.bandera.areaConectada);
set(handles.edit1,'string',areaD*100);

switch Catchment(ID).escorrentia.metodo
    case 'Onda-Cinematica'
        pp=modelo.bandera.permeable*modelo.bandera.areaConectada;
        pimp=modelo.bandera.impermeable*modelo.bandera.areaConectada;
        set(handles.edit2,'string',(1-Catchment(ID).escorrentia.zonaImpermeable/100-Catchment(ID).areaPermSUDS-pp)/areaD*100);
        set(handles.edit3,'string',((Catchment(ID).escorrentia.zonaImpermeable/100)-Catchment(ID).areaImpSUDS-pimp)/areaD*100);
        set(handles.edit9,'enable','on');
        set(handles.edit10,'enable','on');
        set(handles.edit8,'string',modelo.bandera.areaConectada*100);
        set(handles.edit9,'string',modelo.bandera.permeable*100);
        set(handles.edit10,'string',modelo.bandera.impermeable*100);
        set(handles.edit14,'string','Kinematic wave');
    otherwise
        set(handles.edit8,'string',modelo.bandera.areaConectada*100);
        set(handles.edit2,'string','---');
        set(handles.edit3,'string','---');
        set(handles.edit9,'string','---');
        set(handles.edit10,'string','---');
end
if strcmp (idioma,'spanish')
    set(handles.text21,'string','Cuenca');
    set(handles.text29,'string','Método Escorrentía');
    set(handles.text2,'string','Área disponible');
    set(handles.text14,'string','Área conectada');
    set(handles.text6,'string','Porción permeable');
    set(handles.text8,'string','Porción impermeable');
    set(handles.text19,'string','Porción permeable');
    set(handles.text17,'string','Porción impermeable');
    set(handles.text17,'string','Porción impermeable');
    set(handles.asignarAreasGen,'name','Asignar área')
end 
set(handles.asignarAreasGen,'visible','on');
% Choose default command line output for asignarAreasGen
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes asignarAreasGen wait for user response (see UIRESUME)
% uiwait(handles.asignarAreasGen);



% --- Outputs from this function are returned to the command line.
function varargout = asignarAreasGen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
global modelo ProyectoHidrologico
valor=get(handles.radiobutton1,'value');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
ID=modelo.bandera.cuenca;
if valor
    set(handles.text3,'string','(%)');
    set(handles.text5,'string','(%)');
    set(handles.text7,'string','(%)');
    set(handles.text15,'string','(%)');
    set(handles.text16,'string','(%)');
    set(handles.text18,'string','(%)');
    areaC=str2double(get(handles.edit8,'string'))/Catchment(ID).area;
    if isnan(areaC)|| areaC==0
        areaC=0;
        set(handles.edit10,'string',0);
        set(handles.edit9,'string',0);
    else
        areaT=areaC*Catchment(ID).area;
        pimp=str2double(get(handles.edit10,'string'))/areaT;
        set(handles.edit10,'string',pimp*100);
        set(handles.edit9,'string',(1-pimp)*100);
    end
    set(handles.edit8,'string',areaC*100);
    set(handles.edit1,'string',(1-Catchment(ID).areaSUDS-areaC)*100);
    areaT=(1-Catchment(ID).areaSUDS-areaC)*Catchment(ID).area;
    pimp=str2double(get(handles.edit3,'string'))/areaT;
    set(handles.edit3,'string',pimp*100);
    set(handles.edit2,'string',(1-pimp)*100);
else
    set(handles.text3,'string','(ha)');
    set(handles.text5,'string','(ha)');
    set(handles.text7,'string','(ha)');
    set(handles.text15,'string','(ha)');
    set(handles.text16,'string','(ha)');
    set(handles.text18,'string','(ha)');
    areaC=str2double(get(handles.edit8,'string'))/100;
    if isnan(areaC) || areaC==0
        areaC=0;
        set(handles.edit9,'string',0);
        set(handles.edit10,'string',0);
    else
        pimp=str2double(get(handles.edit10,'string'))/100;
        set(handles.edit9,'string',areaC*Catchment(ID).area*(1-pimp));
        set(handles.edit10,'string',areaC*Catchment(ID).area*pimp);
    end
    set(handles.edit8,'string',areaC*Catchment(ID).area);
    set(handles.edit1,'string',(1-Catchment(ID).areaSUDS-areaC)*Catchment(ID).area);
    pimp=str2double(get(handles.edit3,'string'))/100;
    set(handles.edit2,'string',(1-Catchment(ID).areaSUDS-areaC)*Catchment(ID).area*(1-pimp));
    set(handles.edit3,'string',(1-Catchment(ID).areaSUDS-areaC)*Catchment(ID).area*pimp);

end

% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global modelo ProyectoHidrologico
valor=get(handles.radiobutton1,'value');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
ID=modelo.bandera.cuenca;
if ~valor
    areaC=str2double(get(handles.edit8,'string'));
    if isnan(areaC)|| areaC==0
        areaC=0;
        pp=0;
        pimp=0;
    else
        pp=str2double(get(handles.edit9,'string'))/areaC;
        pimp=str2double(get(handles.edit10,'string'))/areaC;
        areaC=areaC/Catchment(ID).area;
    end
else
    areaC=str2double(get(handles.edit8,'string'))/100;
    pp=str2double(get(handles.edit9,'string'))/100;
    pimp=str2double(get(handles.edit10,'string'))/100;
end
modelo.bandera.areaConectada=areaC;
modelo.bandera.permeable=pp;
modelo.bandera.impermeable=pimp;
delete(gcbf)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
delete(gcbf);
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit10_Callback(hObject, eventdata, handles)
global modelo ProyectoHidrologico idioma
valor=get(handles.radiobutton1,'value');
pimpc=str2double(get(handles.edit10,'string'));
areaC=str2double(get(handles.edit8,'string'));
if isnan(pimpc) || isnan(areaC) || areaC==0
    edit8_Callback(hObject, eventdata, handles)
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar dato','Error','error');
    end
    return
end

load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
ID=modelo.bandera.cuenca;
areaT=1-Catchment(ID).areaSUDS;
areaD=str2double(get(handles.edit1,'string'));

if valor
    pimpc=pimpc/100;
    pimpo=(Catchment(ID).escorrentia.zonaImpermeable/100-Catchment(ID).areaPermSUDS)/areaT;
    areaC=areaC/100;
    areaD=areaD/100;
    pimpd=(pimpo-pimpc*areaC)/areaD;
    if pimpd>=0 && pimpd <= 1
        set(handles.edit2,'string',pimpd*100);
        set(handles.edit3,'string',(1-pimpd)*100);
        set(handles.edit10,'string',(1-pimpc)*100)
    else
        if strcmp(idioma,'english')
            Aviso('The value exceeds the available area','Error','error');
        else
            Aviso('El valor excede el área disponible','Error','error');
        end
        ppc=str2double(get(handles.edit9,'string'))/100;
        set(handles.edit10,'string',(1-ppcp)*100);
        return;
    end
else
    pimpc=(pimpc/str2double(get(handles.edit8,'string')));
    pimpo=(Catchment(ID).escorrentia.zonaImpermeable/100-Catchment(ID).areaPermSUDS)/areaT;
    areaC=areaC/Catchment(ID).area;
    areaD=areaD/Catchment(ID).area;
    pimpd=(pimpo-pimpc*areaC)/areaD;

    if pimpd>=0 && pimpd <= 1
        set(handles.edit2,'string',pimpd*Catchment(ID).area*areaD);
        set(handles.edit3,'string',(1-pimpd)*Catchment(ID).area*areaD);
        set(handles.edit9,'string',(1-pimpc)*Catchment(ID).area*areaC)
    else
        if strcmp(idioma,'english')
            Aviso('The value exceeds the available area','Error','error');
        else
            Aviso('El valor excede el área disponible','Error','error');
        end
        ppc=str2double(get(handles.edit9,'string'))/(Catchment(ID).area*areaC);
        set(handles.edit10,'string',(1-ppc)*Catchment(ID).area*areaC);
        return;
    end
end
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



function edit9_Callback(hObject, eventdata, handles)
global modelo ProyectoHidrologico idioma
valor=get(handles.radiobutton1,'value');
ppc=str2double(get(handles.edit9,'string'));
areaC=str2double(get(handles.edit8,'string'));
if isnan(ppc) || isnan(areaC) || areaC==0
    edit8_Callback(hObject, eventdata, handles)
    if strcmp(idioma,'english')
        Aviso('Verify data value','Error','error');
    else
        Aviso('Verificar dato','Error','error');
    end
    return
end
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
ID=modelo.bandera.cuenca;
areaT=1-Catchment(ID).areaSUDS;
areaD=str2double(get(handles.edit1,'string'));
if valor
    ppc=ppc/100;
    ppo=(1-Catchment(ID).escorrentia.zonaImpermeable/100-Catchment(ID).areaPermSUDS)/areaT;
    areaC=areaC/100;
    areaD=areaD/100;
    ppd=(ppo-ppc*areaC)/areaD;
    if ppd>=0 && ppd <= 1
        set(handles.edit2,'string',ppd*100);
        set(handles.edit3,'string',(1-ppd)*100);
        set(handles.edit10,'string',(1-ppc)*100)
    else
        if strcmp(idioma,'english')
            Aviso('The value exceeds the available area','Error','error');
        else
            Aviso('El valor excede el área disponible','Error','error');
        end
        pimp=str2double(get(handles.edit10,'string'))/100;
        set(handles.edit9,'string',(1-pimp)*100);
        return;
    end
else
    ppc=(ppc/str2double(get(handles.edit8,'string')));
    ppo=(1-Catchment(ID).escorrentia.zonaImpermeable/100-Catchment(ID).areaPermSUDS)/areaT;
    areaC=areaC/Catchment(ID).area;
    areaD=areaD/Catchment(ID).area;
    ppd=(ppo-ppc*areaC)/areaD;

    if ppd>=0 && ppd <= 1 && (1-ppc)*Catchment(ID).area*areaC>0
        set(handles.edit2,'string',ppd*Catchment(ID).area*areaD);
        set(handles.edit3,'string',(1-ppd)*Catchment(ID).area*areaD);
        set(handles.edit10,'string',(1-ppc)*Catchment(ID).area*areaC);
    else
        if strcmp(idioma,'english')
            Aviso('The value exceeds the available area','Error','error');
        else
            Aviso('El valor excede el área disponible','Error','error');
        end
        pimp=str2double(get(handles.edit10,'string'))/(Catchment(ID).area*areaC);
        set(handles.edit9,'string',(1-pimp)*Catchment(ID).area*areaC);
        return;
    end
end
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


function edit8_Callback(hObject, eventdata, handles)
global modelo ProyectoHidrologico idioma
valor=get(handles.radiobutton1,'value');
load(fullfile(ProyectoHidrologico.carpetaBase,'Data','Catchment.mat'),'Catchment');
ID=modelo.bandera.cuenca;
areaT=(1-Catchment(ID).areaSUDS);
if valor   
    areaC=str2double(get(handles.edit8,'string'))/100;
    if areaC>areaT || isnan(areaC)
        if strcmp(idioma,'english')
            Aviso('Verify connected area','Error','error');
        else
            Aviso('Vrificar el área conectada','Error','error');
        end
        
        set(handles.edit8,'string',0);
        set(handles.edit9,'string',0);
        set(handles.edit10,'string',0);
        set(handles.edit1,'string',areaT*100);

        switch Catchment(ID).escorrentia.metodo
            case 'Onda-Cinematica'    
                set(handles.edit3,'string',(Catchment(ID).escorrentia.zonaImpermeable/100-Catchment(ID).areaPermSUDS)/areaT*100);
                set(handles.edit2,'string',((1-Catchment(ID).escorrentia.zonaImpermeable/100)-Catchment(ID).areaImpSUDS)/areaT*100);
                set(handles.edit9,'enable','on');
                set(handles.edit10,'enable','on');
            otherwise
                set(handles.edit2,'string','---');
                set(handles.edit3,'string','---');
        end

        return;
    end
    set(handles.edit3,'string',(Catchment(ID).escorrentia.zonaImpermeable/100-Catchment(ID).areaImpSUDS)/areaT*100);
    set(handles.edit2,'string',((1-Catchment(ID).escorrentia.zonaImpermeable/100)-Catchment(ID).areaPermSUDS)/areaT*100);
    set(handles.edit1,'string',(areaT-areaC)*100);
    set(handles.edit9,'string',get(handles.edit2,'string'));
    set(handles.edit10,'string',get(handles.edit3,'string'));
else

    areaC=str2double(get(handles.edit8,'string'))/Catchment(ID).area;
    areaD=areaT-areaC;
    
    if areaC>areaT || isnan(areaC)
        if strcmp(idioma,'english')
            Aviso('Verify connected area','Error','error');
        else
            Aviso('Vrificar el área conectada','Error','error');
        end
        set(handles.edit8,'string',0);
        set(handles.edit9,'string',0);
        set(handles.edit10,'string',0);
        set(handles.edit1,'string',areaT*Catchment(ID).area);
        switch Catchment(ID).escorrentia.metodo
            case 'Onda-Cinematica'
                areaD=areaT;
                set(handles.edit2,'string',((1-Catchment(ID).escorrentia.zonaImpermeable/100)-Catchment(ID).areaPermSUDS)/areaT*areaD);
                set(handles.edit3,'string',((Catchment(ID).escorrentia.zonaImpermeable)/100-Catchment(ID).areaImpSUDS)/areaT*areaD);
                set(handles.edit9,'enable','on');
                set(handles.edit10,'enable','on');
            otherwise
                set(handles.edit2,'string','---');
                set(handles.edit3,'string','---');
        end
        return;
    end
    set(handles.edit2,'string',((1-Catchment(ID).escorrentia.zonaImpermeable/100)-Catchment(ID).areaPermSUDS)/areaT*areaD);
    set(handles.edit3,'string',((Catchment(ID).escorrentia.zonaImpermeable)/100-Catchment(ID).areaImpSUDS)/areaT*areaD);
    set(handles.edit1,'string',areaD);
    set(handles.edit9,'string',((1-Catchment(ID).escorrentia.zonaImpermeable/100)-Catchment(ID).areaPermSUDS)/areaT*areaC);
    set(handles.edit10,'string',((Catchment(ID).escorrentia.zonaImpermeable)/100-Catchment(ID).areaImpSUDS)/areaT*areaC);
end

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
