%% Material Acero
young = 200e9;
nu = .29;
lambda = young*nu/(1+nu)/(1-2*nu);
G = young/(2+2*nu);
E = [lambda+2*G lambda lambda 0 0 0; %Relacion constitutiva 3D
           lambda lambda+2*G lambda 0 0 0;
           lambda lambda lambda+2*G 0 0 0;
           0     0     0     G    0  0;
           0     0     0     0    G  0;
           0     0     0     0    0  G];