clear all;clc;
%% Seleccion de problema
s = -1; % s=1 pendulo normal.  s=-1  pendulo invertido
%% Puntos de Equilibrio y condiciones iniciales
if s == 1
    x_eq = [0 0 0 0]';
    x0 = [-3 1 0 0];
elseif s==-1
    x_eq = [0 pi 0 0]';
    x0 = [-3 pi+.1 0 0]';
end
%% Constantes fisicos
L = 2;
g = 10;
m = 1;
M = 5;
k = 0; % constante de resorte
b = 0; % Friccion de pendulo
d = 0; % Friccion de carro

%% Sistema NO-LINEAL
F = @(X,u,t) -k*X(1) - d*X(3) + u(1); % Fuerza sobre carro
% X = [x; q; Dx; Dq] donde q es el angulo (medido desde vertical, q=pi corresponde para pendulo invertido)
D2x = @(X,u,t)( F(X,u,t) + m*L*X(4)^2*sin(X(2)) +m*g*sin(X(2))*cos(X(2)) +...
    b/L*X(4)*cos(X(2)) )/(M+m*sin(X(2))^2);
D2q= @(X,u,t) (-F(X,u,t)*cos(X(2)) - m*L*X(4)^2*sin(X(2))*cos(X(2))- ...
    (m+M)*g*sin(X(2)) -(1+M/m)*b/L*X(4))/L/(M+m*sin(X(2))^2);
Y = @(X,u,t) [X(3); X(4); D2x(X,u,t); D2q(X,u,t)];

%% SISTEMA LINEAL   X = [x; q; Dx; Dq]

A = [0      0             1      0;
     0      0             0      1;
   -k/M    m*g/M        -d/M     s*b/L/M;
   s*k/M/L  s*-(m+M)*g/L/M   s*d/M/L  (1+M/m)*b/L^2/M];
n = size(A,1); % dimension de espacio de estados

%% CONTROL de sistema lineal. u = F
B = [0 0 1/M -s*1/M/L]'; % Fuerza neta sobre carro de input
p = size(B,2); % number of inputs
C = zeros(n);
C(2,2) = 1; % medimos el angulo
D = zeros(n,p); % no feedthrough
%% Funcion costo (LQR)
Q = diag([1 10 1 100]);
R =1e-4;
Kr = lqr(A,B,Q,R);
%% Peturbaciones (Vd) y ruido (Vn) para filtro kalman (no implementado)
Vd = .1*eye(n);
Vn = 1*eye(n);
Baum = [B Vd 0*B]; % matrices B y D del sistema aumentado
Daum = [D 0*D Vn];

sys = ss(A,B,C,D);
%% Solucion temporal con runge kutta O4
ts = .01; % Tiempo de sampleo de nuestras mediciones
tend = 10; % Finalizacion de la simulacion
tsrk = ts/10; % paso de tiempo del sistema no lineal
Nt = ceil(tend/ts); % nro de sampleos a hacer durante simulacion
tspan = linspace(0,tend,Nt);
Xt = zeros(n,Nt);
% Comienza la simulacion en t=0
Xt(:,1) = x0;
for it = 1:Nt-1
    t = tspan(it);
    tspanrk = t:tsrk:t+ts;
    Xreal = Xt(:,it);
    u = -Kr*(Xreal - x_eq);
    Xtrk = rk4sys(Y,u, tspanrk, Xreal);
    Xt(:,it+1) = Xtrk(:,end);
    if sum(isnan(Xreal))>0 || sum(Xreal>1000)>0
        error('Nan found or SS variable too large. stop execution.')
    end
    
end
x = Xt(1,:); q = Xt(2,:); Dx=Xt(3,:); Dq = Xt(4,:);


%% Graficar evolucion
figure(1);
ax = axes();
anifps = 30 ; 
anistep = floor(Nt/120); % 4 second animation, at 30 fps is 120 frames
for it = 1:anistep:Nt
    xlim(ax,[min(x)-L max(x)+L]);ylim(ax,[-L L]);
    pause(1/anifps)
    ax = plotCartPend(ax,Xt(:,it),L,M,m);
    drawnow
end
