%#ok<*ASGLU>
% Damped mass spring system. c=0.5
% Bode
g = @(s) 1./(s.^2 + 0.5*s + 1);

stp = @(t) (t > 0) + (t == 0)/2;
imp = @(t) 1e9*(t==0);
[x,bde,phase]=bodetocsv(g, '../../plots/bd_dampedmass.csv',100);
L = @(s) 1./(s);
[x,bde,phase]=bodetocsv(L, '../../plots/bd_integrator.csv',10); 
S = @(s) (1+L(s)).^-1;
T = @(s) S(s).*L(s);
[x,bde,phase]=bodetocsv(S, '../../plots/bd_sensitivity.csv',50);

[x,bde,phase]=bodetocsv(T, '../../plots/bd_Csensitivity.csv',50);
subplot(2,1,1);
semilogx(x,bde)
hold on
subplot(2,1,2)
semilogx(x,phase)
return
% Transfer
s = tf('s'); t = linspace(0,10);
G = 1/(s^2 + .5*s +1);
y = lsim(G,stp(t),t);

return
plot(t,y)

figure(1)
subplot(2,1,1);
semilogx(x,bde)
hold on
subplot(2,1,2)
semilogx(x,phase)
