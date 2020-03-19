function  [] = bandplotopti(elementos,nodos,variable,graphArg)
% BANDPLOTOPTI  Graficador de variables. CC-BY-NC-SA Patricio Whittingslow
% 2019. Optimizado para caras opacas.
%
% BANDPLOTOPTI(elementos,nodos,variable,graphArg)
% 
% Típica numeración de los nodos de los elementos:
%  4---7---3
%  |       |
%  8   9   6
%  |       |
%  1---5---2
% Ejemplo dado Q9
%
% Acepta los elementos H20, H8, T10, T4, CST, LST, Q8/Q9, Q4
% con numeración de ADINA o del Cook
% elementos: Matriz de conectividades.
% nodos:     Matriz de coordenadas nodales, 2D o 3D según tipo elemento
% variable:  Matriz m x n con la variable a graficar, donde [m n] = size(elementos).
% graphArg: Vector opcional con información de como graficar. 
% graphArg = [opacidadCaras, graficarNodos, graficarElementos, colorLinea,
%  AdinaColors]
%
% opacidadCaras: 0|1. Opcion opaca [1] solo grafica caras exteriores.
% graficarNodos: 0|1|2. Numera los nodos. Opcion 2 solo grafica nodos
% presentes en elementos. Se recomienda usar 1 o 0.
% graficarElementos: 0|1. Numera los elementos. Usar con opacidad baja.
% colorLinea: [0-7]. Color delimitador de elementos. 1 es negro. 0 es
% transparente. 2-7 RGB y CMY.
% AdinaColors: 0|1. Si es 1 grafica colores con estilo de ADINA. 
%
% Ejemplo:
%
% BANDPLOTOPTI(elementos,nodos,Sigma_xx,[1 0 0 1 1])
%
% Ejemplo de uso como meshplot. Grafica nodos y elementos
%
% BANDPLOTOPTI(elementos,nodos,Sigma_xx,[0 1 1 1 0])

%% MODIFICAR SEGUN USO
lineColor='k'; % color de bordes de elemento, por defecto 'k' para negro. 'none' para ningun color
opacidadCaras = 1; % transparencia de caras de elementos. 1 es opaco
nColores=10; % numero de colores graficados
graficarNodos = true; % grafica número de nodos
graficarElementos = true; %grafica número de elementos

if nargin>3
sizeGraphArg = size(graphArg);
if numel(sizeGraphArg)>=1 && sizeGraphArg(1)~=0
    opacidadCaras = graphArg(1);
    switch numel(graphArg)
        case 2
            graficarNodos = graphArg(2);
        case {3,4,5}
            graficarNodos = graphArg(2);
            graficarElementos = graphArg(3);
            if numel(graphArg)>=4 
                switch graphArg(4)
                    case 1
                        lineColor='k';
                    case 0
                        lineColor='none';
                    case 2
                        lineColor='r';
                    case 3
                        lineColor='g';
                    case 4
                        lineColor='b';
                    case 5
                        lineColor='c';
                    case 6
                        lineColor='m';
                    case 7
                        lineColor='y';
                end
            end
            if numel(graphArg)==5
            if graphArg(5) == 1
             adinaColor = [
                42     0   255
                 0    42   255
                 0   128   255
                 0   212   255
                 0   255   212
                 0   255   128
                 0   255    42
                42   255     0
               128   255     0
               212   255     0
               255   212     0
               255   128     0
               255    42     0
               255     0    42]/255;
             nColores = size(adinaColor,1);
            end
            end
    end
end
end
%% Error check
[Nnod , Ndim]= size(nodos);
isValidVariable = all(size(variable) == size(elementos));
if ~isValidVariable
    error('size(elementos) debe ser igual a size(variable)')
end

%% Limites de variable graficado
tol = 1E-5;
lims = [min(min(variable)) max(max(variable))];
if diff(lims) < lims(2)*tol
    lims = lims + [-1 1]*lims(2)*tol;
end


[Nelem, Nnodporelem] = size(elementos);
if Ndim==3
switch Nnodporelem
    case {10} %CTETRA
        vNod = [1 5 2 10 4 7;
                1 5 2 8 3 6
                1 6 3 9 4 7
                2 10 4 9 3 8];
    case {4} %T4 (LTETRA)
        vNod = [1 2 4
                1 2 3
                1 3 4
                2 4 3];
    case {8} %H8
        vNod = [1 2 3 4
                1 2 6 5
                2 6 7 3
                1 5 8 4
                5 6 7 8
                4 3 7 8];
    case {20} %CHEXA (H20)
       vNod = [1 9 2 10 3 11 4 12
                2 18 6 14 7 19 3 10
                4 12 1 17 5 16 8 20
                5 13 6 14 7 15 8 16
                1 9 2 18 6 13 5 17
                4 11 3 19 7 15 8 20];
    otherwise
        error('Elemento 3D desconocido.')
end
end

if Ndim == 2
    opacidadCaras=1;
    switch Nnodporelem
        case {3,4} % Caso lineales, CST y Q4
            vNod = 1:Nnodporelem;
        case {6} % LST
            vNod = [1 4 2 5 3 6];
        case {8,9} %Q8 y Q9
            vNod = [1 5 2 6 3 7 4 8];
        otherwise
            warning('Elemento 2D desconocido.')
            vNod = 1:Nnodporelem;
    end
end
[Nf, Nvertex] = size(vNod);
%% Graficador de superficies optimizada para caras opacas

faceVar = reshape(variable(:,vNod')',size(vNod,2),[])';
faces = reshape(elementos(:,vNod')',size(vNod,2),[])';
Nfaces = size(faces,1);
sortF = sort(faces,2);

isExteriorFace = true(Nfaces,1);
for f = 1:Nfaces
    if  mod(f,Nf)==0  && graficarNodos == 2 
       e = ceil(f/Nf);
       idx = elementos(e,:);
       text(nodos(idx,1),nodos(idx,2),nodos(idx,3),split(num2str(idx)),'VerticalAlignment','bottom','Color','r','FontSize',8);
    end
    if ~isExteriorFace(f) && opacidadCaras==1
        continue
    end
    repetidas = sum(sortF(f,:) == sortF,2) == Nvertex; % esta linea es lentisima
    if sum(repetidas)>1 && opacidadCaras==1
        isExteriorFace = isExteriorFace & ~repetidas;
        continue
    end
    figFaces = patch('Faces',1:Nvertex,'Vertices',nodos(faces(f,:),:),'FaceVertexCData',faceVar(f,:)');
    hold on
    set(figFaces,'FaceColor','interp','EdgeColor',lineColor,'CDataMapping','scaled');
    if opacidadCaras~=1
        alpha(figFaces,opacidadCaras);
    end

end
%% Número de elementos graficado
if graficarElementos && (opacidadCaras~=1 || Ndim==2)
    idx = reshape(elementos',1,[])';
    nex = mean(reshape(nodos(idx,1)',Nnodporelem,[]));
    ney = mean(reshape(nodos(idx,2)',Nnodporelem,[]));
    if Ndim==2
        text( nex , ney ,split(num2str(1:Nelem)),'VerticalAlignment','bottom','Color','b','FontSize',8);
    else
        nez = mean(reshape(nodos(idx,3)',Nnodporelem,[]));
        text( nex , ney , nez ,split(num2str(1:Nelem)),'VerticalAlignment','bottom','Color','b','FontSize',8);
    end
end


%% Grafico nombre de nodos
if graficarNodos==1
    idx = 1:Nnod;
    if Ndim == 2
        text(nodos(idx,1),nodos(idx,2),split(num2str(idx)),'VerticalAlignment','bottom','Color','r','FontSize',8);
    else
        text(nodos(idx,1),nodos(idx,2),nodos(idx,3),split(num2str(idx)),'VerticalAlignment','bottom','Color','r','FontSize',8);
    end
end
% Acomodo escalas y demás
if opacidadCaras>0
    if nColores == 14
        colormap(adinaColor)
        caxis(lims);
    else
        colormap(jet(nColores));
        caxis(lims);
    end

    if nColores <= 20
        nTicks = nColores;
    else
        nTicks = 20;
    end
    if diff(lims)<=eps*nColores
        lims(1)=lims(1)-1; lims(2)=lims(2)+1;
    end
    ticks = lims(1):((diff(lims))/nTicks):lims(2);
    tickLabels = cell(size(ticks));
    for iTick = 1:length(ticks)
        tickLabels{iTick} = sprintf('%6.5E',ticks(iTick));
    end
    colorbar('YTick',ticks,'YTickLabel',tickLabels);
end

if Ndim==3
    view(3)
end
if graficarNodos
    xlabel('x');ylabel('y');zlabel('z');
    maxyz=max(nodos);minxyz = min(nodos);
    xlim([minxyz(1) maxyz(1)]);ylim([minxyz(2) maxyz(2)]);%zlim([minxyz(3) maxyz(3)])
else
    set(gca,'XTick',[],'YTick',[],'ZTick',[],'YColor',[1 1 1],'ZColor',[1 1 1],'visible','on');
end
daspect([1 1 1]);
box on
axis auto

