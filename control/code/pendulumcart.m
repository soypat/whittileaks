%% Inverted Pendulum
% M:  Cart mass
% m:  Pendulum mass
% L:  Pendulum length
% q: pendulum angle (theta)
% t:  time

syms x(t) q(t)% M m L F g
Dq = diff(q,t);
Dx = diff(x,t);
assume(t,'real')

k=0;
F = 0;
L = 1;
g = 1;
m = 1;
M = 5;
b = 0.1; % Pendulum fruction
u = 0.1; % Cart friction
Iz= m*L^2;
% First
% ode1 = (M + m) * diff(x,t,2)  -  m * L * diff(q,t,2) * cos(q)  +  m * L * Dq^2 *sin(q)  ==  F;
% ode2 = -cos(q) * m * diff(x,t,2)  +  m * L * diff(q,t,2)  -  m * g * sin(q) == 0;

% SECOND
% ode1 = (M + m) * diff(x,t,2)  + b*Dx +   m * L * diff(q,t,2) * cos(q)  -  m * L * Dq^2 *sin(q)  ==  F;
% ode2 =  m * L * diff(x,t,2) * cos(q)  +  (Iz + m * L^2) * diff(q,t,2)  +  m * g * L * sin(q) == 0;

ode1 = (m + M)*diff(x,t,t) == - m* L * diff(q,t,t) * cos(q) + m* L*diff(q,t)^2 *sin(q) + F;
ode2 = diff(x,t,t) * cos(q) + L*diff(q,t,t)  + g*sin(q) == 0;

odeQ = diff(q,t,t) ==( -m*L*Dq^2*sin(q)*cos(q)-(m+M)*g*sin(q) +k*x*cos(q)+u*Dx*cos(q)-(q+M/m)*b/L*Dq)/L/(M+m*sin(q)^2);
odeX = diff(x,t,t) ==( m*L*Dq^2*sin(q) +m*g*sin(q)*cos(q) - (M+m)*g*sin(q)-k*x-u*Dx+b/L*Dq*cos(q) )/(M+m*sin(q)^2);

x_cond  =  x(0) == 0;
q_cond  =  q(0) == 1e-3;
Dx_cond = Dx(0) == 0;
Dq_cond = Dq(0) == 0;

tspan = [0 10];
% F_cond  =  F == 0;
% L_cond  =  L == 1;
% g_cond  =  g == 1;
% m_cond  =  m == .1;
% M_cond  =  M == 1;

minCond = [x_cond;Dx_cond;q_cond;Dq_cond];
conds = [x_cond;Dx_cond;q_cond;Dq_cond;F_cond;M_cond;m_cond;L_cond;g_cond];
odes = [odeX;odeQ];

sol = dsolve(odes, minCond)
% [tout, yout] = ode45(odes,tspan,minCond)