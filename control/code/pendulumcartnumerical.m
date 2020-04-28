% Constantes fisicos
L = .5;
g = 9.81;
m = 1;
M = 5;
k = 0; % constante de resorte
b = 0; % Friccion de pendulo
u = 0; % Friccion de carro

% X = [x; q; Dx; Dq] donde q es el angulo (medido desde vertical, q=pi corresponde para pendulo invertido)
D2q= @(X,F) (-F*cos(X(2)) - m*L*X(4)^2*sin(X(2))*cos(X(2))-(m+M)*g*sin(X(2)) -(1+M/m)*b/L*X(4))/L/(M+m*sin(X(2))^2);
D2x = @(X,F)( F + m*L*X(4)^2*sin(X(2)) +m*g*sin(X(2))*cos(X(2)) + b/L*X(4)*cos(X(2)) )/(M+m*sin(X(2))^2);
Y = @(X,F) [X(3); X(4); D2x(X,F); D2q(X,F)];
F = @(X,t) -k*X(1) - u*X(3); % Fuerza sobre carro
%% CONTROL PARA SISTEMA LINEAL   X = [x; q; Dx; Dq]
A = [0   0           1      0;
     0   0           0      1;
   -k/M m*g/M     -u/M     b/L/M;
   k/M/L -(m+M)*g/L/M u/M/L  (1+M/m)*b/L^2/M];
B = [0 0 1 -1]; % Fuerza neta sobre carro de input
C = [0 0 0 0
     0 1 0 0  % medimos solo el angulo
     0 0 0 0
     0 0 0 0];

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