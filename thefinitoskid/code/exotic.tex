%% Elemento exotico Q5 rectangular 2D. (Q4 con nodo extra en 0,0)
%  clear; close all; clc
% reset(symengine)
%% Obtención de funciones de forma
clear dN N dNaux
syms x y real
X = [1 x y x^2 x*y];
A = [1 -1 -1  1  1
     1  1 -1  1 -1
     1  1  1  1  1
     1 -1  1  1 -1
     1  0  0  0 0];  
shapefuns = X/A;

N(1,1:2:2*length(shapefuns))=shapefuns;
N(2,2:2:2*length(shapefuns))=shapefuns; %Tiene la forma de las funciones de forma encontradas en el cook pg 206, ecuacion (6.2-2). Despues veo si me sirven
dN(1,1:2:2*length(shapefuns))=diff(shapefuns,x);
dN(2,2:2:2*length(shapefuns))=diff(shapefuns,y);
dNaux=[diff(shapefuns,x);diff(shapefuns,y)]; %Para calcular jacobiano
%% Datos
E = 200E3; %[MPa]
nu = 0.3;
% lam = E*nu/(1+nu)/(1-2*nu);
% mu = E/2/(1+nu);
t = 1;

%% Nodos y Elementos
nod = [-1 -1
        1 -1
        1  1
        -1  1
        0  0]*1E3; %conversion a mm
nnod = size(nod,1);
elem = [1 2 3 4 5];
nelem = size(elem,1);

%% DOF
dofpornodo = 2;
nodporelem = 5;
doftot = dofpornodo*nnod;
dof = reshape((1:doftot),dofpornodo,nnod)';

%% Constitutiva (PlaneStrain)
Cstrain = E/((1 + nu)*(1 - 2*nu))*[ 1 - nu      nu            0.0;nu       1 - nu         0.0;0.0        0.0     (1 - 2*nu)/2 ];
%% Gauss para regla de 2x2 (numeración de nodos como figura 6.3-3 pág 212)
a   = 1/sqrt(3);
upg = [ -a  -a; -a   a;a  -a;a   a ];% Ubicaciones puntos de Gauss
npg = size(upg,1);
wpg = ones(npg,1); %Weight vale 1 para orden n=2 tabla pg 210.
%% Matriz de rigidez
Kglobal = zeros(doftot);
for e = 1:nelem
    Ke = zeros(dofpornodo*nodporelem);
    nodelem = nod(elem(e,:),:);
    signo=NaN;
    for ipg = 1:npg
        % Punto de Gauss
        x = upg(ipg,1);
        y = upg(ipg,2);  
        
        J =subs(dNaux)*nodelem;
        
        if ~isnan(signo) && sign(det(J))~=signo || signo==0 %verifica el bienestar de los elementos
            warning('\nJacobian sign change or singularity detected element %0.0f\n',e)
        end
        signo=sign(det(J));

        dNxy=J\subs(dN);
        
        B=zeros(size(Cstrain,2),size(Ke,1)); %Segunda Forma
        B(1:2,:)=dNxy;
        B(3,2:end)=dNxy(1,1:end-1);
        B(3,1:end-1)=B(3,1:end-1)+dNxy(2,2:end);
        
        
        Ke = Ke + B'*Cstrain*B*wpg(ipg)*det(J);
    end
    dofs = dof(elem(e,:),:);
    dofs = reshape(dofs',[],1);
    Kglobal(dofs,dofs) = Kglobal(dofs,dofs) + Ke;
end

%% BC
fixity=false(doftot,1);
fixity([1 2 4])=true;
free=~fixity;

%% Cargas
P = zeros(doftot/2,2);
q = 0.002; %[N/mm]
f =@(x) q*x;
a   = 1/sqrt(3);
upg = [-a a];    
npg = size(upg,2);
wpg = ones(npg,1);

surfacenodes=[4 3]; %Según el orden de numeración en tu matriz elementos (elem). en este caso 4 apunta a 4, y 5 apunta a 3
for e = 1:nelem
    nodelem = nod(elem(e,:),:);
    for ipg = 1:npg
        x = upg(ipg);
        y = 1; %El truco que no te querían mostrar para aplicar una carga superficial. Te parás sobre la linea!
        Ns=subs(N);

        dNs=subs(dN);
        sig = f(x);
        J = subs(dNaux)*nodelem;
        %Usamos la forma de cook de 6.9-5
        %Si queremos que sea generalizado, reemplazamos 4 y 3 por
        %surfacenodes(1) y (2)
        P(elem(e,4),:) = P(elem(e,4),:) + subs(shapefuns(4))*wpg(ipg)*[0 sig*J(1,1)]; %La integral 6.9-5 del Cook
        P(elem(e,3),:) = P(elem(e,3),:) + subs(shapefuns(3))*wpg(ipg)*[0 sig*J(1,1)];
    end
end
P = reshape(P',[],1);
%% Solver
Dred = Kglobal(free,free)\P(free);
D = zeros(doftot,1);
D(free) = Dred;
cnodfinal = nod+reshape(D,dofpornodo,nnod)'*10000000;%Para que se vean los desplz.
figure
hold on; grid on; axis equal;
plot(nod(:,1),nod(:,2),'.')
plot(cnodfinal(:,1),cnodfinal(:,2),'.')

%% Gauss para regla de 2x2 (numeración de nodos como figura 6.3-3 pág 212)
a   = 1/sqrt(3);
% Ubicaciones puntos de Gauss
upg = [ -a  -a
        -a   a
         a  -a
         a   a ];    
% Número de puntos de Gauss
npg = size(upg,1);
wpg = ones(npg,1);

%% Tensiones en Puntos Gauss
stressg = zeros(nelem,nodporelem-1,3);
for e = 1:nelem
    nodelem = nod(elem(e,:),:);
    dofs = reshape(dof(elem(e,:),:)',[],1);
    for in = 1:npg
        x = upg(in,1);
        y = upg(in,2);  

        J = subs(dNaux)*nodelem;
        
        dNxy = J\subs(dN);
        
        B=zeros(size(Cstrain,2),size(Ke,1)); %Segunda Forma
        B(1:2,:)=dNxy;
        B(3,2:end)=dNxy(1,1:end-1);
        B(3,1:end-1)=B(3,1:end-1)+dNxy(2,2:end);
            
        stressg(e,in,:) = Cstrain*B*D(dofs);
     end
end

%% Tensiones en nodos
uNod=[-1 -1; 1 -1; 1 1;-1 1; 0 0]; %posiciones nodos xi(ksi), eta
stress = zeros(nodporelem,nelem,3); %de la forma catedra
for e = 1:nelem
    nodelem = nod(elem(e,:),:);
    dofs = reshape(dof(elem(e,:),:)',[],1);
    for inod = 1:nodporelem
        x = uNod(inod,1);
        y = uNod(inod,2);
        
        J = subs(dNaux)*nodelem;
        
        dNxy = J\subs(dN);
        
        B=zeros(size(Cstrain,2),size(Ke,1)); %Segunda Forma
        B(1:2,:)=dNxy;
        B(3,2:end)=dNxy(1,1:end-1);
        B(3,1:end-1)=B(3,1:end-1)+dNxy(2,2:end);
        
        stress(inod,e,:) = Cstrain*B*D(dofs);
    end
end
sigvm=sqrt(stress(:,:,1).^2+stress(:,:,2).^2-stress(:,:,1).*stress(:,:,2)+3*stress(:,:,3).^2);
%como tengo un nodo no convencional, lo saco para el bandplot
bandplot(elem(1:4),nod(1:4,:),stress(1:4,:,3)')