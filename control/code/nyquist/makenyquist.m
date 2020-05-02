%Nyquist
path(path,'../')
g = @(s) 1./(s.^2 + 0.5*s + 1);
% s = tf('s');
% G = 1/(s^2 + .5*s + 1);
% nyquist(G)

[re,im,rob] = nyq(g);
r = min(rob);
th = 0:pi/80:2*pi;
xc = r * cos(th) - 1;
yc = r * sin(th);
makecsv('../../plots/nyq_dampedmass.csv',[re im],{'real','imag'})
plot(xc,yc)
hold on
plot(re,im,'.--')
daspect([1 1 1])