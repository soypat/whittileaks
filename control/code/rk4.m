function [Xt] = rk4(F, tspan ,cond)
% Toma una funcion anonima F que esta en funcion de un vector de variables
% X y tiempo y. Esta funcion representa el cambio de la variable X.
%       .
%       X  = F( X, t )
%
% Devuelve la evolucion a lo largo del vector tiempo tspan. Se precisa
% condiciones iniciales cond.
% Ejemplo:
% Xt = rk4(F, tspan ,cond)
Nt = length(tspan); % time steps  
n = size(cond,1);
Xt = zeros(n,Nt);
%% Condiciones de borde
Xt(:,1) = cond;
%% Resolucion Runge Kutta orden 4
for it = 1:Nt-1
    t=tspan(it);
    dt = diff(tspan(it:it+1));
    X = Xt(:,it);
    a = F(X, t);
    b = F(X+dt/2.*a, t);
    c = F(X+dt/2.*b, t);
    d = F(X+dt.*c, t);
    Xt(:,it+1) = X + dt/6*(a+2*(b+c)+d);
end
end