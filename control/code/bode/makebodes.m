% Damped mass spring system. c=0.5
g = @(s) 1./(s.^2 + 0.5*s + 1);
[x,bde,phase]=bodetocsv(g,'../../plots/bd_dampedmass.csv',100);

return
figure(1)
semilogx(x,bde)
figure(2)
semilogx(x,phase)
