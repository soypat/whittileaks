% Damped mass spring system. c=0.5
% Bode
g = @(s) 1./(s.^2 + 0.5*s + 1);

stp = @(t) (t > 0) + (t == 0)/2;
imp = @(t) 1e9*(t==0);
[x,bde,phase]=bodetocsv(g, '../../plots/bd_dampedmass.csv',100);

% Transfer
s = tf('s'); t = linspace(0,10);
G = 1/(s^2 + .5*s +1);
y = lsim(G,stp(t),t);

return
plot(t,y)
figure(1)
semilogx(x,bde)
figure(2)
semilogx(x,phase)
