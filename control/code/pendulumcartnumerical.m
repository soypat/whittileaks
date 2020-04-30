clear all;clc
% Constantes fisicos
L = 2;
g = 10;
m = 1;
M = 5;
k = 0; % constante de resorte
b = 0; % Friccion de pendulo
d = 1; % Friccion de carro

%% Se define el sistema no-lineal
F = @(X,u,t) -k*X(1) - d*X(3) + u(1); % Fuerza sobre carro
% X = [x; q; Dx; Dq] donde q es el angulo (medido desde vertical, q=pi corresponde para pendulo invertido)
D2x = @(X,u,t)( F(X,u,t) + m*L*X(4)^2*sin(X(2)) +m*g*sin(X(2))*cos(X(2)) + b/L*X(4)*cos(X(2)) )/(M+m*sin(X(2))^2);
D2q= @(X,u,t) (-F(X,u,t)*cos(X(2)) - m*L*X(4)^2*sin(X(2))*cos(X(2))-(m+M)*g*sin(X(2)) -(1+M/m)*b/L*X(4))/L/(M+m*sin(X(2))^2);
Y = @(X,u,t) [X(3); X(4); D2x(X,u,t); D2q(X,u,t)];

%% SISTEMA LINEAL   X = [x; q; Dx; Dq]
s = -1; % s=1 pendulo normal.  s=-1  pendulo invertido
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
% Funcion costo LQR
Q = diag([1 1 10 100]);
R = 0.01;
Kr = lqr(A,B,Q,R);
% Peturbaciones (Vd) y ruido (Vn)
Vd = .1*eye(n);
Vn = 1*eye(n);
Baum = [B Vd 0*B]; % matrices B y D del sistema aumentado
Daum = [D 0*D Vn];

sys = ss(A,B,C,D);
% Kf = (lqr(A',C',Vd,Vn))'; % Ideal Kalman filter for system
% Kf = lqe(A,Vd,C,Vd,Vn);
load('cb.mat')

if s == 1
    x_eq = [0 0 0 0]';
elseif s==-1
    x_eq = [0 pi 0 0]';
end

ts = .05; % Tiempo de sampleo de nuestras mediciones
tend = 10; % Finalizacion de la simulacion
tsrk = ts/30; % paso de tiempo del sistema no lineal
Nt = ceil(tend/ts); % nro de sampleos a hacer durante simulacion
tspan = linspace(0,tend,Nt);
Xt = zeros(n,Nt);
% Comienza la simulacion en t=0
Xt(:,1) = x_eq+0.01;
% u = -Kr*Xt);

for it = 1:Nt-1
    t = tspan(it);
    tspanrk = t:tsrk:t+ts;
    Xreal = Xt(:,it);
    pause(0.05)

    u = Kr*(Xreal - x_eq);
    Xtrk = rk4sys(Y, 0, tspanrk, Xreal);
    Xt(:,it+1) = Xtrk(:,end);
%     if t>
    
end
x = Xt(1,:); q = Xt(2,:); Dx=Xt(3,:); Dq = Xt(4,:);


%% Graficar evolucion
figure(1);
ax = axes();
for it = 1:Nt
    xlim(ax,[min(x)-L max(x)+L]);ylim(ax,[-L L]);
    pause(.03)
    ax = plotCartPend(ax,Xt(:,it),L,M,m);
    drawnow
end
figure(2)
comet(q,Dq)
% plot(tspan,Xt(2,:))

return
%% RK4 time
tend = 20; % end of simulation time
Nt = 1000; % time steps  
dt = tend/(Nt-1);
tspan = linspace(0,tend,Nt);
Xt = zeros(4,Nt);
%% Condiciones de borde
Xt(1,1) = 0;  % x
Xt(2,1) = pi; % q pendulo invertido => q=pi
Xt(3,1) = 0;  % Dx
Xt(4,1) = 0;  % Dq
%% Resolucion Runge Kutta orden 4
for it = 1:Nt-1
    t=tspan(it);
    X = Xt(:,it);
    forz = F(X,t);
    a = Y(X,forz);
    b = Y(X+dt/2.*a,forz);
    c = Y(X+dt/2.*b,forz);
    d = Y(X+dt.*c,forz);
    Xt(:,it+1) = X + dt/6*(a+2*(b+c)+d);
end
x = Xt(1,:); q = Xt(2,:); Dx=Xt(3,:); Dq = Xt(4,:);
plot(tspan,q)