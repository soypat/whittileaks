t4dominio
material3d
%% Dofinitions
Ndofpornod = 3; Ndn = Ndofpornod;
n2d = @(n) repmat(n*Ndn,Ndn,1) - (Ndn-1:-1:0)'; % forma generalizada
[Nnod, Ndim] = size(nodos);
[Nelem, Nnodporelem] = size(elementos);
Ndofporelem  =  Ndofpornod*Nnodporelem;
dof = Ndofpornod*Nnod;
DOF = reshape(1:dof,Ndofpornod,[])';
%% Puntos Gauss (orden 0) + integracion
t4shapefun
pg.u = .25*ones(1,3); pg.w =1; pg.n = 1;
K = sparse(dof,dof);
for e = 1:Nelem
    ke = zeros(Ndofporelem,Ndofporelem);
    meindof = reshape(DOF(elementos(e,:),:)',1,[]);
    elenod = nodos(elementos(e,:),:);
    for ipg = 1:pg.n
        r = pg.u(ipg,1); s = pg.u(ipg,2);t = pg.u(ipg,3);
        Ns = eval(N);
        dNs = eval(dN); % Para T4 dN es constante.
        jac = dNs*elenod;
        Djac = det(jac)/6; % Para tetrahedros se divide por seis
        dNxyz = jac\dNs;
        B=zeros(size(E,2),Ndofpornod * Nnodporelem); % B es 6x60
        B(1,1:3:end-2) = dNxyz(1,:); %  dNxy es 6x20 OJO
        B(2,2:3:end-1) = dNxyz(2,:); %  
        B(3,3:3:end)   = dNxyz(3,:); %  dz %VER PAGINA 80 Cook. Ec (3.1-9)
        B(4,1:3:end-2) = dNxyz(2,:); %dy
        B(4,2:3:end-1) = dNxyz(1,:); %dx
        B(5,2:3:end-1) = dNxyz(3,:); %dz
        B(5,3:3:end)   = dNxyz(2,:); %dy
        B(6,1:3:end-2) = dNxyz(3,:); %dz
        B(6,3:3:end)   = dNxyz(1,:); %dx
        ke = ke + B'*E*B*pg.w(ipg)*Djac;
    end
    K(meindof,meindof) = K(meindof,meindof) + ke;
end