clear % Conviene siempre empezar con un espacio de trabajo liberado
q4shapefun % se crean las funciones de forma
nodos = [0 0;
         1 0
         1 1
         0 1
         2 0
         2 1]; %[metros]
elementos = [1 2 3 4;
             2 5 6 3];
%% DOFINITIONS
Ndofpornod = 2; 
[Nnod, Ndim] = size(nodos);
[Nelem, Nnodporelem] = size(elementos);
dof = Ndofpornod*Nnod;
Ndofporelem = Ndofpornod*Nnodporelem;
n2d = @(n) [n*2 - 1; n*2];
%% Obtencion de elemdof
elemdof = zeros(Nelem,Ndofporelem);
for e = 1:Nelem
    elemdof(e,:)= reshape(n2d(elementos(e,:)),[],1);
end
%% Propiedades del material
young = 200E9;                            % Modulo de Young acero [Pa]
nu = 0.3;                                 % Poisson
t = 1E-2;                                 % espesor [metros]
E = young/(1-nu^2)*[1 nu 0;nu 1 0;0 0 (1-nu)/2]; %plane stress
%% Gauss para regla de 2x2 
a   = 1/sqrt(3);
upg = [ -a  -a;a  -a;a  a;-a  a ];% Ubicaciones puntos de Gauss
npg = size(upg,1);
wpg = ones(npg,1); %Weight vale 1 para orden n=1, grado precision 2
%% Obtencion Matriz Rigidez
K = zeros(dof);
for e = 1:Nelem
    meindof = elemdof(e,:);
    ke = zeros(Ndofporelem);
    elemnod = nodos(elementos(e,:),:);
    for ipg = 1:npg
        x = upg(ipg,1);
        y = upg(ipg,2);  
        J = eval(dN)*elemnod; % se podrian precargar los resultados de 
        dNxy = J\eval(dN);    % la integracion para problemas con muchos elementos
        B=zeros(size(E,2),size(ke,1)); %Stress-Strain Matrix
        B(1,1:2:end) = dNxy(1,:);
        B(2,2:2:end) = dNxy(2,:); 
        B(3,1:2:end) = dNxy(2,:); % 3.6-6 Cook
        B(3,2:2:end) = dNxy(1,:);
        ke = ke + B'*E*B*wpg(ipg)*det(J)*t;
    end
    K(meindof,meindof) = K(meindof,meindof) + ke;
end
%% Obtencion vector columna de cargas R
R = zeros(dof,1);
R(n2d(5)) = [-10e3 -5e3]; % -20kN en x, -10kN en y
R(n2d(6)) = [10e3 -5e3];  % [Newton]
%% Condiciones de Borde isostaticas
isFixed = false(dof,1);
isFixed(n2d(1)) = [true false]; % Roller apoyado en x nodo 1
isFixed(n2d(4)) = [true true];  % Apoyo simple nodo 4
%% Solucion del sistema lineal
Dr = K(~isFixed,~isFixed)\R(~isFixed);
D = zeros(dof,1);
D(~isFixed) = Dr;
Dxy = reshape(D,2,[])';
escala = 1000; % Escala para amplificar desplazamientos
posdef = nodos + escala*Dxy;
q4stress