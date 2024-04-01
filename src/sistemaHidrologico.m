classdef sistemaHidrologico
%% Stormwater system
% //    Description:
% //        -stormwater system object
% //    Update History
% =============================================================
%
    properties
        Node                % Nodes (obj)
        Catchment           % Catchment (obj)
        Conduit             % Conduits (obj)
        Storm               % Storms (obj)
        Natural             % Natural response (catchment obj)
        Retencion=[];       % Retention (obj)
        Detencion=[];       % Detention (obj)
        Infiltracion=[];    % Infiltration (obj)
        MCuencas            % Basic information of catchment elements
        MNodos              % Basic information of node elements
        MTuberias           % Basic information of conduits elements
        nodoFinal           % Basic information of catchment elements
        rutasTuberia        % Conduit route
        rutasNodo           % Node route
        rutaPerfil          % Profile
        estado              % Condition of simulation
        ordenNodos          % Topological nodes sort
        ordenTuberias       % Topological conduits sort
        nf                  % System discharge node
        convergedNodos=[];  % Converged nodes for DW routing
        convergedTuberias=[];% Converged conduits for DW routing
        noConverged=[];     % No converged steps for DW routing
    end
    
    methods
        function obj = sistemaHidrologico(Node,Catchment,Conduit,Storm,Natural)
        % //    Description:
        % //        -Create object
        % //    Update History
        % =============================================================
        %
            obj.Node = Node;
            obj.Catchment = Catchment;
            obj.Conduit = Conduit;
            obj.Storm = Storm;
            obj.Natural=Natural;
            
            obj.MNodos = zeros(size(Node,2),3);
            obj.MNodos(:,1) = [Node(:).ID];
            obj.MNodos(:,2) = [Node(:).elevacionT];
            obj.MNodos(:,3) = [Node(:).elevacionR]; 
            
            obj.MCuencas = zeros(size(Catchment,2),5);
            obj.MCuencas(:,1) = [Catchment(:).ID];
            obj.MCuencas(:,2) = [Catchment(:).descarga];
            obj.MCuencas(:,3) = [Catchment(:).area];
            
            obj.MTuberias = zeros(size(Conduit,2),4);
            obj.MTuberias(:,1) = [Conduit(:).ID];
            obj.MTuberias(:,2) = [Conduit(:).nodoI];    
            obj.MTuberias(:,3) = [Conduit(:).nodoF] ;  
            obj.MTuberias(:,4) = [Conduit(:).longitud];
      
        end

        function obj=ordenTransito(obj)
        % //    Description:
        % //        -Get topological nodes sort
        % //        -Get topological conduits sort
        % //        -Get system discharge node
        % //    Update History
        % =============================================================
        %
            DNodos=obj.MNodos;
            DTuberias=obj.MTuberias;
            for i=1:size(DNodos,1)
            k=find(DNodos(i,1)==DTuberias(:,2));
                if size(k)>0
                else
                    nodoF=DNodos(i,1);
                end
            end         
            nodosID=DNodos(:,1);
            Ni=DTuberias(:,2);
            Nj=DTuberias(:,3);
            p=1;
            i=1;
            ordenN=nodosID*0;
            while size(nodosID,1)>1 
                u=find(nodosID(i)==Nj);
                v=find(nodosID(i)==Ni);
                if isempty(u)
                    ordenN(p)=nodosID(i);
                    Ni(v)=[];
                    Nj(v)=[];
                    nodosID(i)=[];
                    p=p+1;
                    i=1;
                else
                    i=i+1;
                end
            end
            ordenN(ordenN==0)=[];
            Ni=DTuberias(:,2);
            ordenT=zeros(size(DTuberias,1),1);
            obj.MTuberias=DTuberias*0;
            k=1;
            for i=1:size(ordenN,1)
                u=find(ordenN(i)==Ni);
                for j=1:size(u,1)
                    v=u(j);
                    ordenT(k)=DTuberias(v,1);
                    obj.MTuberias(k,1)=DTuberias(v,1);
                    obj.MTuberias(k,2)=DTuberias(v,2);
                    obj.MTuberias(k,3)=DTuberias(v,3);
                    k=k+1;
                end
            end
            obj.ordenNodos=ordenN;
            obj.ordenTuberias=ordenT;
            obj.nf=nodoF;
        end

        function [obj,estado] = obtenerRutas(obj)
        % //    Description:
        % //        -Get conduit route
        % //        -Get node route
        % //    Update History
        % =============================================================
        %
        rutasT=[];
        estado=1;
        Ni=obj.MTuberias(:,2);
        Nj=obj.MTuberias(:,3);
        ID_Tub=obj.MTuberias(:,1);
        hoja=ones(length(Ni),1);
        nhoja=ones(length(Ni),1);
        for i=1:length(Ni)
             k=find(Ni(i)==Nj);
           if k~=0
               hoja(i)=0;
           else
               nhoja(i)=0;
           end
        end
        hoja=hoja.*Ni;
        hoja(hoja==0)=[];
        rutasN=zeros(length(hoja),length(Ni));
        rutasN=[hoja,rutasN];
        for j=1:length(Ni)
            for m=1:length(hoja)
                u=rutasN(m,j)==Ni;
                if sum(u)==0
                    continue;
                end      
                if length(Nj(u))>1
                    Aviso('Verify conduit direction','Error','error');
                    estado=0;
                    return;
                else    
                rutasN(m,j+1)=Nj(u);
                end
            end
        
        end 
        rutasN(:,sum(rutasN,1)==0) = [];       
        for j=2:size(rutasN,2)
            for m=1:size(rutasN,1)
                if rutasN(m,j)==rutasN(m,j-1) || rutasN(m,j-1)==0
                    rutasN(m,j)=0;
                end
            end
        end
        rutasT=rutasN*0;
        for j=1:size(rutasN,2)
            for m=1:length(hoja)
                u=rutasN(m,j)==Ni;
                if sum(u)==0
                    continue;
                end
                rutasT(m,j)=ID_Tub(u);
            end
        end 
        obj.rutasNodo=rutasN;
        obj.rutasTuberia=rutasT;
        end

        function [obj,resultados,respuesta]=realizarTransito(obj,Simulacion)
        % //    Description:
        % //        -Execute routing
        % //    Update History
        % =============================================================
        %            
            switch Simulacion.metodoTransito
                case 'onda_cinematica'
                    [obj] = transitoCinematica(obj,Simulacion);
                    obj=resultadosAdicionalesOC(obj);         
                    [resultados,respuesta]=saveResultados(obj);

                case 'onda_dinamica'
                    [~,~,obj,resultadosDinamica] = transitoDinamica(obj,Simulacion);
                    obj=resultadosAdicionalesOD(obj,resultadosDinamica,Simulacion);
                    [resultados,respuesta]=saveResultados(obj,resultadosDinamica);
            end
        end
        function [obj] = transitoCinematica(obj,Simulacion)
        % //    Description:
        % //        -Execute kinematic wave routing
        % //    Update History
        % =============================================================
        %
            tStep=Simulacion.dtTransito;
            nodos=obj.Node;
            tuberias=obj.Conduit;
            datos=obj.MTuberias;
            vectorTiempo=Simulacion.tiempoTransito;
            
            for i=1:size(nodos,2)
                nodos(i).entradaTotal=[vectorTiempo,vectorTiempo*0];
                nodos(i).hidrogramaFinal=[vectorTiempo,vectorTiempo*0];
                nodos(i).hidrogramaDirecto=[vectorTiempo,vectorTiempo*0];
                nodos(i).hidrogramaDirecto=caudalEntrada(nodos(i));
                nodos(i).qinflow=[vectorTiempo,vectorTiempo*0];
                nodos(i).qinflow2=[vectorTiempo,vectorTiempo*0];
                nodos(i).qoutflow=[vectorTiempo,vectorTiempo*0];
                nodos(i).hidrogramaNeto=[vectorTiempo,vectorTiempo*0];
            end
            for i=1:size(tuberias,2)
                tuberias(i).q1=[vectorTiempo,vectorTiempo*0];
                tuberias(i).q2=[vectorTiempo,vectorTiempo*0];
                tuberias(i).a1=[vectorTiempo,vectorTiempo*0];
                tuberias(i).a2=[vectorTiempo,vectorTiempo*0];
            end
            h = findobj('tag','moduloHidrologico');
            posicion1=h.Position;
            f = waitbar(0,'Please wait...');
            f.WindowStyle='modal';
            f.Units='pixels';
            posicion2=f.Position;
            pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.6;
            pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.5;
            posicion=[pos1,pos2,posicion2(3:4)];
            f.Position=posicion;
            pause(0.5)
            PTbarra=1/(size(vectorTiempo,1)-1); 
            for i=1:size(vectorTiempo,1)
            waitbar(PTbarra*i,f,['Kinematic wave: ',sprintf('%.1f',vectorTiempo(i)/60),' min'])
                for j=1:size(datos,1)
                    nodos(datos(j,2)).qinflow2(i,2)=nodos(datos(j,2)).qinflow(i,2)+nodos(datos(j,2)).hidrogramaDirecto(i,2);           
                    if i<size(vectorTiempo,1)
                        [ qoutflow,~,~,tuberias(datos(j,1))] = kinwave( tuberias(datos(j,1)),tStep,nodos(datos(j,2)).qinflow2(i,2),i );
                        nodos(datos(j,3)).qinflow(i+1,2)=nodos(datos(j,3)).qinflow(i+1,2)+qoutflow;
                        nodos(datos(j,2)).qoutflow(i,2)=tuberias(datos(j,1)).q1(i+1,2);
                    end              
                if i>1
                    nodos(datos(j,2)).hidrogramaNeto(i,2)=max(0,0.5*(nodos(datos(j,2)).qinflow2(i,2)...
                        +nodos(datos(j,2)).qinflow2(i-1,2))...
                        -0.5*(nodos(datos(j,2)).qoutflow(i,2)+nodos(datos(j,2)).qoutflow(i-1,2)));
                end
                end
                
            end
            waitbar(1,f,'Successful simulation...');
            close(f)
            obj.Node=nodos;
            obj.Conduit=tuberias;
        end

        function [nodos,tuberias,obj,res] = transitoDinamica(obj,Simulacion)
        % //    Description:
        % //        -Execute dynamic wave routing
        % //    Update History
        % =============================================================
        %
        
            nodos=obj.Node;
            tuberias=obj.Conduit;
            nodosHoja=obj.rutasNodo(:,1);
            for i=1:length(nodosHoja)
                nodos(nodosHoja(i)).degree=-1;
            end
            
            DW=routingDW(Simulacion);

            timeTotal=0;
            [h,m,~] = hms(diff([Simulacion.inicioSimulacion,Simulacion.finSimulacion]));
            vectorTiempo=(0:DW.RouteStep:h*3600+m*60)';
            for i=1:length(nodos)
                nodos(i)=inicializarNodo(nodos(i));
                nodos(i).hidrogramaDirecto=[vectorTiempo,vectorTiempo*0];
                nodos(i).hidrogramaDirecto=caudalEntrada(nodos(i));
            end
            for i=1:length(tuberias)
                tuberias(i)=inicializarTuberia(tuberias(i));
            end

            [DW,nodos,tuberias]=inicializarDW(DW,nodos,tuberias);

            [nodos] = initNodeDepthsDW(nodos,tuberias);
            [tuberias] = initLinkDepthsDW(tuberias,nodos);
            [nodos] = iniNodoDW(nodos,tuberias);
            [tuberias] = initLinksDW(tuberias);

            timeSave=[];
            nodosInflow=[];
            nodosOutflow=[];
            tuberiasInflow=[];
            tuberiasOutflow=[];
            nodosOverflow=[];
            nodosDepth=[];
            nodosVolume=[];
            tuberiasDepth=[];
            tuberiasA1=[];
            tuberiasA2=[];
            tuberiasVolumen=[];
            convNodos=[];
            convTuberias=[];
            noConv=[];

            h = findobj('tag','moduloHidrologico');
            posicion1=h.Position;
            f = waitbar(0,'Please wait...');
            f.WindowStyle='modal';
            f.Units='pixels';
            posicion2=f.Position;
            pos1=posicion1(1)+abs(posicion2(3)-posicion1(3))*0.6;
            pos2=posicion1(2)+abs(posicion2(4)-posicion1(4))*0.5;
            posicion=[pos1,pos2,posicion2(3:4)];
            f.Position=posicion;
            pause(0.5)

            while timeTotal < Simulacion.duracionSimulacion
                waitbar(round(timeTotal/Simulacion.duracionSimulacion,2),f,['Dynamic wave: ',sprintf('%.1f',timeTotal/60),' min'])
                
                [DW,nodos,tuberias]=getStepDW(DW,nodos,tuberias);
                timeTotal=timeTotal+DW.VariableStep;
            
                for k=1:length(nodos)
                    nodos(k).oldLatFlow  = nodos(k).newLatFlow;
                    nodos(k).newLatFlow=interp1(nodos(k).hidrogramaDirecto(:,1),nodos(k).hidrogramaDirecto(:,2),timeTotal) ;
                    nodos(k) = setOldHydState( nodos(k) );
                end
            
                for k=1:length(tuberias)
                    tuberias(k)= setOldHydState(tuberias(k) );
                end           

                [~,NonConvergeCount,nodos,tuberias]=executeDW(DW,tuberias,nodos);
                noConv=[noConv,NonConvergeCount];
                timeSave=[timeSave,timeTotal];
                [nodosInflow,nodosOutflow,nodosOverflow,nodosDepth,nodosVolume,convNodos] = resultadosDinamicaNodos(nodos,nodosInflow,nodosOutflow,nodosOverflow,nodosDepth,nodosVolume,convNodos);
                [tuberiasInflow,tuberiasOutflow,tuberiasDepth,tuberiasVolumen,tuberiasA1,tuberiasA2,convTuberias] = resultadosDinamicaTuberias(tuberias,tuberiasInflow,tuberiasOutflow,tuberiasDepth,tuberiasVolumen,tuberiasA1,tuberiasA2,convTuberias);
            end
            waitbar(1,f,'Successful simulation...');
            close(f)

            res.nodosInflow=nodosInflow;
            res.nodosOutflow=nodosOutflow;
            res.nodosOverflow=nodosOverflow;
            res.nodosDepth=nodosDepth;
            res.nodosVolumen=nodosVolume;
            res.time=timeSave;
            res.tuberiasInflow=tuberiasInflow;
            res.tuberiasOutflow=tuberiasOutflow;
            res.tuberiasDepth=tuberiasDepth;
            res.tuberiasVolumen=tuberiasVolumen;
            res.tuberiasA1=tuberiasA1;
            res.tuberiasA2=tuberiasA2;
            res.time=timeSave;
            res.convergedNodos=convNodos;
            res.convergedTuberias=convTuberias;
            res.noConverged=noConv;

        end

        function [h,gc,g]=plotSimulacion(obj)
        % //    Description:
        % //        -Plot result (plan view)
        % //    Update History
        % =============================================================
        %
            hold on
            lab2={};
            Tub2=[];
            Diam=[];
            gc=zeros(1,length(obj.Catchment));
            gdc=gcr;
            gcc=gcr;
            for i=1:length(obj.Catchment)
                gc(i)=plotCuenca(obj.Catchment(i));
                gdc(i)=plotDirC(obj.Catchment(i));
                gcc(i)=plotCentroC(obj.Catchment(i));
            end
            secciones=([obj.Conduit(:).seccion]);
            dmax=max([secciones(:).profundidad]);
            h=zeros(1,length(obj.Conduit));
            for i=1:length(obj.Conduit)
                h(i)=plotTuberia(obj.Conduit(i));
                set(h(i),'LineWidth',5*(obj.Conduit(i).seccion.profundidad/dmax));
            end
            g=zeros(1,length(obj.Node));
            for i=1:length(obj.Node)
                g(i)=plotNodo(obj.Node(i));
            end

        end

        function obj=resultadosAdicionalesOC(obj)
        % //    Description:
        % //        -Sort results for kinematic wave 
        % //    Update History
        % =============================================================
        %
            tuberias=obj.Conduit;
            for i=1:length(tuberias)
                y1=tuberias(i).a1;
                y1(:,2)=0;
                y2=y1;
                for j=1:length(y1)
                    y1(j,2)=circ_getYofA(tuberias(i).seccion,tuberias(i).a1(j,2));
                    y2(j,2)=circ_getYofA(tuberias(i).seccion,tuberias(i).a2(j,2));
                end
                tuberias(i).y1=y1;
                tuberias(i).y2=y2;
            end
            obj.Conduit=tuberias;
        end
        
        function obj=resultadosAdicionalesOD(obj,resultados,Simulacion)
        % //    Description:
        % //        -Sort results for dynamic wave 
        % //    Update History
        % =============================================================
        %
            vectorTiempo=Simulacion.tiempoTransito;
            nodos=obj.Node;
            tuberias=obj.Conduit;
            for i=1:size(nodos,2)
                nodos(i).hidrogramaDirecto=[vectorTiempo,vectorTiempo*0];
                nodos(i).hidrogramaDirecto=caudalEntrada(nodos(i));
                nodos(i).qinflow2=[vectorTiempo,vectorTiempo*0];
                nodos(i).qinflow2(:,2)=interp1(resultados.time',resultados.nodosInflow(:,i),nodos(i).qinflow2(:,1),'linear','extrap');
                nodos(i).qinflow=nodos(i).qinflow2;
                nodos(i).qoutflow=[vectorTiempo,vectorTiempo*0];
                nodos(i).qoutflow(:,2)=interp1(resultados.time',resultados.nodosOutflow(:,i),nodos(i).qoutflow(:,1),'linear','extrap');
                nodos(i).hidrogramaNeto=[vectorTiempo,vectorTiempo*0];
                nodos(i).hidrogramaNeto(:,2)=interp1(resultados.time',resultados.nodosOverflow(:,i),nodos(i).hidrogramaNeto(:,1),'linear','extrap');
            end
            for i=1:size(tuberias,2)
                tuberias(i).q1=[vectorTiempo,vectorTiempo*0];
                tuberias(i).q1(:,2)=interp1(resultados.time',resultados.tuberiasInflow(:,i),tuberias(i).q1(:,1),'linear','extrap');
                tuberias(i).q1(isnan(tuberias(i).q1))=0;
                tuberias(i).q2=[vectorTiempo,vectorTiempo*0];
                tuberias(i).q2(:,2)=interp1(resultados.time',resultados.tuberiasOutflow(:,i),tuberias(i).q2(:,1),'linear','extrap');
                tuberias(i).q2(isnan(tuberias(i).q2))=0;
                tuberias(i).a1=[vectorTiempo,vectorTiempo*0];
                tuberias(i).a1(:,2)=interp1(resultados.time',resultados.tuberiasA1(:,i),tuberias(i).a1(:,1),'linear','extrap');
                tuberias(i).a1(isnan(tuberias(i).a1))=0;
                tuberias(i).a2=[vectorTiempo,vectorTiempo*0];
                tuberias(i).a2(:,2)=interp1(resultados.time',resultados.tuberiasA2(:,i),tuberias(i).a2(:,1),'linear','extrap');
                tuberias(i).a2(isnan(tuberias(i).a2))=0;
                y1=tuberias(i).a1;
                y1(:,2)=0;
                y2=y1;
                for j=1:length(y1)
                    y1(j,2)=circ_getYofA(tuberias(i).seccion,tuberias(i).a1(j,2));
                    y2(j,2)=circ_getYofA(tuberias(i).seccion,tuberias(i).a2(j,2));
                end
                tuberias(i).y1=y1;
                tuberias(i).y2=y2;
            end
            obj.Node=nodos;
            obj.Conduit=tuberias;
            obj.convergedNodos=resultados.convergedNodos;
            obj.convergedTuberias=resultados.convergedTuberias;
            obj.noConverged=resultados.noConverged;
            
        end

        function obj=rutas(obj,Conduit)
        % //    Description:
        % //        -Get profiles 
        % //    Update History
        % =============================================================
        %
            Rutas=obj.rutasTuberia;
            cap=zeros(size(Rutas,1),1);
            for i=1:size(Rutas,1)
                ruta1=Rutas(i,:);
                ruta1(ruta1==0)=[];
                longitud=[Conduit(ruta1).longitud];
                seccion=[Conduit(ruta1).seccion];
                area=[seccion(:).aMax];
                cap(i)=sum(longitud.*area);
            end
            [~,I]=sort(cap,'descend');
            Rutas=Rutas(I,:);
            rutaLarga=Rutas(1,:);
            rutaLarga(rutaLarga==0)=[];
            
            rutasFinal=cell(size(Rutas,1));
            Rutas(1,:)=[];
            rutasFinal{1}=rutaLarga;
            memoria=rutaLarga;
            for i=1:size(Rutas,1)
                prueba=Rutas(i,:);
                prueba(prueba==0)=[];
                repetidos=intersect(prueba,memoria);
                rutasFinal{i+1}=prueba(1:end-length(repetidos));
                memoria=[memoria,prueba];
            end
            obj.rutaPerfil=rutasFinal;
        end
        function [graficoRelleno1Pr,graficoRelleno2Pr,graficoReferenciaPr,graficoTuberiaRPr,graficoTirantePr,graficoTerrenoPr,graficoRasantePr,graficoCoronaPr,graficoPozoRPr,graficoPozoPr,labelPozoPr,labelTuberiaPr]=plotPerfilRevision(obj,tuberias,k,colores,linea,grosor,infoNodo,infoTuberia,ubicacion)
        % //    Description:
        % //        -Plot result (profile view)
        % //    Update History
        % =============================================================
        %
        global idioma
        nodos=obj.Node;
        p=0;
        axes1=gca;
        cla;

        for i=1:1:length(tuberias)
            nodoI=nodos(tuberias(i).nodoI);
            nodoF=nodos(tuberias(i).nodoF);
            baseI=nodoI.base;
            baseF=nodoF.base;
            Pozo1X=[p,p+baseI,p+baseI,p,p];
            Pozo1Y=[nodoI.elevacionR,nodoI.elevacionR,nodoI.elevacionT,nodoI.elevacionT,nodoI.elevacionR];
            TX=[p+baseI,p+tuberias(i).longitud-0.5*baseF-0.5*baseI];
            TY=[nodoI.elevacionT,nodoF.elevacionT];
    
            RX=[p+baseI,p+tuberias(i).longitud-0.5*baseF-0.5*baseI];
            RY=[tuberias(i).ERNi,tuberias(i).ERNf];
            DX=[p+baseI,p+tuberias(i).longitud-0.5*baseF-0.5*baseI];
            DY=[tuberias(i).ERNi+tuberias(i).seccion.profundidad,tuberias(i).ERNf+tuberias(i).seccion.profundidad];
            tirante=[tuberias(i).ERNi+tuberias(i).y1(k,2),tuberias(i).ERNf+tuberias(i).y2(k,2)];
            rellenoX=[DX,TX(2),TX(1),TX(1)];
            rellenoY=[DY,TY(2),TY(1),TY(1)];
            TubX=[DX,RX(2),RX(1),RX(1)];
            TubY=[DY,RY(2),RY(1),RY(1)];
            pY=[tirante,RY(2),RY(1),RY(1)];
            nodosDibujados=[[tuberias.nodoF],[tuberias.nodoI]];
            nodosDibujados=unique(nodosDibujados);
            nd=nodos(nodosDibujados);
            emin=min([nd.elevacionR]);
            emax=max([nd.elevacionT]);
            if i~=length(tuberias)
                graficoRelleno1Pr(i)=area([RX(1)-baseI,RX],[RY(1),RY]);
                graficoRelleno2Pr(i)=patch(rellenoX,rellenoY,colores(5,:));
                graficoReferenciaPr(i)=plot([p+0.5*baseI,p+0.5*baseI],[0,emax+0.5],'LineStyle',linea{2},'LineWidth', grosor(2),'Color',colores(2,:));   
            else
                graficoRelleno1Pr(i)=area([RX(1)-baseI,RX,RX(2)+baseI],[RY(1),RY,RY(2)]);
                graficoRelleno2Pr(i)=patch(rellenoX,rellenoY,colores(4,:));
                graficoReferenciaPr(i)=plot([p+0.5*baseI,p+0.5*baseI],[0,emax+0.5],'LineStyle',linea{2},'LineWidth', grosor(2),'Color',colores(2,:));
                graficoReferenciaPr(i+1)=plot([p+tuberias(i).longitud-0.5*baseF,p+tuberias(i).longitud-0.5*baseF],[0,emax+0.5],'LineStyle',linea{2},'LineWidth', grosor(2),'Color',colores(2,:));    
            end
            graficoRelleno1Pr(i).FaceColor = colores(5,:);
            graficoRelleno1Pr(i).FaceAlpha = 0.6;
            graficoRelleno1Pr(i).LineStyle='none';
            graficoRelleno1Pr(i).EdgeColor=colores(5,:);
            graficoRelleno1Pr(i).EdgeAlpha=0;
            graficoRelleno1Pr(i).LineWidth=0.1;
            graficoRelleno2Pr(i).FaceColor = colores(5,:);
            graficoRelleno2Pr(i).FaceAlpha = 0.6;
            graficoRelleno2Pr(i).EdgeColor=colores(5,:);
            graficoRelleno2Pr(i).LineWidth=0.1;
            graficoRelleno2Pr(i).LineStyle='none';

            graficoTuberiaRPr(i)=patch(TubX,TubY,[0.9 0.9 0.9]);
            graficoTuberiaRPr(i).FaceAlpha=0.5;
            graficoTirantePr(i)=patch(TubX,pY,colores(6,:));
            graficoTirantePr(i).FaceAlpha=1;
            graficoTirantePr(i).LineStyle='none';
                
            graficoTerrenoPr(i)=plot(TX,TY,'LineStyle',linea{4},'LineWidth', grosor(4),'Color',colores(4,:));
            
            graficoRasantePr(i)=plot(RX,RY,'LineStyle',linea{3},'LineWidth', grosor(3),'Color',colores(3,:));
            graficoCoronaPr(i)=plot(DX,DY,'LineStyle',linea{3},'LineWidth', grosor(3),'Color',colores(3,:));
            graficoPozoRPr(i)=patch(Pozo1X,Pozo1Y,[0.9 0.9 0.9]);
            graficoPozoRPr(i).FaceAlpha=1;
            graficoPozoRPr(i).LineStyle='none';
            graficoPozoPr(i)=plot(Pozo1X,Pozo1Y,'LineStyle',linea{1},'LineWidth',grosor(1),'Color',colores(1,:));
            if strcmp(idioma,'english')
                infoNodoCom={['Node - ',num2str(nodoI.ID,'%0.0f')],num2str(nodoI.elevacionT,'%0.2f'),num2str(nodoI.elevacionR,'%0.2f'),num2str(nodoI.desnivel,'%0.2f')};
                infoTuberiaCom={['Conduit - ',num2str(tuberias(i).ID,'%0.0f')],['Q = ',num2str(mean([tuberias(i).q1(k,2);tuberias(i).q2(k,2)]),'%0.2f'),' m3'],['L = ',num2str(tuberias(i).longitud,'%0.2f'),' m'],['S = ',num2str(tuberias(i).Sp*100,2),'%']};
            else
                infoNodoCom={['Nodo - ',num2str(nodoI.ID,'%0.0f')],num2str(nodoI.elevacionT,'%0.2f'),num2str(nodoI.elevacionR,'%0.2f'),num2str(nodoI.desnivel,'%0.2f')};
                infoTuberiaCom={['Tubería - ',num2str(tuberias(i).ID,'%0.0f')],['Q = ',num2str(mean([tuberias(i).q1(k,2);tuberias(i).q2(k,2)]),'%0.2f'),' m3'],['L = ',num2str(tuberias(i).longitud,'%0.2f'),' m'],['S = ',num2str(tuberias(i).Sp*100,2),'%']};
            end
            
            

            infoNodoF=infoNodoCom(logical(infoNodo));
            infoTuberiaF=infoTuberiaCom(logical(infoTuberia));
            if ~isempty(infoNodoF)
                labelPozoPr(i)=text(Pozo1X(4),ubicacion(1),infoNodoF,...
                                'Color',[0 0 0],'FontSize',8,'FontWeight','bold','VerticalAlignment','bottom',...
                                'HorizontalAlignment','center');
            else
                labelPozoPr(i)=text(Pozo1X(4),ubicacion(1),['Node - ',num2str(nodoI.ID,'%0.0f')],...
                                'Color',[0 0 0],'FontSize',8,'FontWeight','bold','VerticalAlignment','bottom',...
                                'HorizontalAlignment','center');
            end

            if ~isempty(infoTuberiaF)
                labelTuberiaPr(i)=text(p+(tuberias(i).longitud/2)+baseI,ubicacion(2),infoTuberiaF,...
                    'Color',[0 0 0],'FontSize',8,'FontWeight','bold','VerticalAlignment','bottom',...
                    'HorizontalAlignment','center');
            else
                labelTuberiaPr(i)=text(p+(tuberias(i).longitud/2)+baseI,ubicacion(2),['Conduit - ',num2str(tuberias(i).ID,'%0.0f')],...
                    'Color',[0 0 0],'FontSize',8,'FontWeight','bold','VerticalAlignment','bottom',...
                    'HorizontalAlignment','center');
            end
                    
            p=p+tuberias(i).longitud-0.5*baseI-0.5*baseF;
        
            if i==length(tuberias)
               PozoFX=[p,p+baseF,p+baseF,p,p];
               PozoFY=[nodoF.elevacionR,nodoF.elevacionR,nodoF.elevacionT,nodoF.elevacionT,nodoF.elevacionR];
               graficoPozoRPr(i+1)=patch(PozoFX,PozoFY,[0.9 0.9 0.9]);
               graficoPozoRPr(i+1).FaceAlpha=1;
               graficoPozoRPr(i+1).LineStyle='none';
               graficoPozoPr(i+1)=plot(PozoFX,PozoFY,'LineStyle',linea{1},'LineWidth',grosor(1),'Color',colores(1,:));
               if strcmp(idioma,'english')
                    infoNodoCom={['Node - ',num2str(nodoF.ID,'%0.0f')],num2str(nodoF.elevacionT,'%0.2f'),num2str(nodoF.elevacionR,'%0.2f'),num2str(nodoF.desnivel,'%0.2f')};
               else
                    infoNodoCom={['Nodo - ',num2str(nodoF.ID,'%0.0f')],num2str(nodoF.elevacionT,'%0.2f'),num2str(nodoF.elevacionR,'%0.2f'),num2str(nodoF.desnivel,'%0.2f')};
               end

               infoNodoF=infoNodoCom(logical(infoNodo));
               if ~isempty(infoNodoF)
                   labelPozoPr(i+1)= text(PozoFX(4),ubicacion(1),infoNodoF,...
                                    'Color',[0 0 0],'FontSize',8,'FontWeight','bold','VerticalAlignment','bottom',...
                                    'HorizontalAlignment','center');
               else
                   labelPozoPr(i+1)= text(PozoFX(4),ubicacion(1),['Nodo - ',num2str(nodoF.ID,'%0.0f')],...
                                    'Color',[0 0 0],'FontSize',8,'FontWeight','bold','VerticalAlignment','bottom',...
                                    'HorizontalAlignment','center');
               end
            end
            
        end
        xlim([-10,p+10]);
        ylim([emin-2,nodos(tuberias(1).nodoI).elevacionT+3]);
        set(axes1,'FontUnits','points','FontWeight','bold','FontSize',8,'FontName','Segoe UI','Box','off','TickDir','out',...
            'XGrid','on','XMinorGrid','on','XMinorTick','on',...
            'YGrid','on','YMinorGrid','on','YMinorTick','on');

       if strcmp(idioma,'english')
           title(['Profile Conduit ',num2str(tuberias(1).ID),' - Conduit ', num2str(tuberias(end).ID)])
           xlabel('Length (m)') 
           ylabel('Elevation (msnm)')
       else
           title(['Perfil Tubería ',num2str(tuberias(1).ID),' - Tubería ', num2str(tuberias(end).ID)])
           xlabel('Longitud (m)') 
           ylabel('Elevación (msnm)')
       end
 
        axes1.FontSize=8;
        grid on
        end
    end
end
