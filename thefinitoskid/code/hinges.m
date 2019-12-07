function [nodeDofs,elenod,nudos,Le,phide,Ndof] = ...
gennodedofs(nod,elenod,eletype)
%GENNODEDOFS genera matriz nodeDofs
[Ne,~]=size(elenod);
[N,~]=size(nod);
hinges=length(eletype(eletype==4 | eletype==44 | eletype==3 | eletype==33));
Le=zeros(Ne,1);
phide=zeros(Ne,1);
Ndof=N*3+hinges;
%HINGES (ROTULAS)
hingedlist=zeros(1,hinges);
j=0;
Nt=N+hinges;
nodeDofs=zeros(Nt,3);
nudos=zeros(Nt,1);
for i=1:N
    nodeDofs(i,:)=[i*3-2 i*3-1 i*3];
end
%Termino de llenar nodeDofs y lleno nudos
for i = 1:Ne
    nodestart=elenod(i,1);
    nodeend=elenod(i,2);
    lx=nod(nodeend,1)-nod(nodestart,1);
    ly=nod(nodeend,2)-nod(nodestart,2);
    Le(i)=sqrt(lx^2+ly^2);
    phide(i)=atan2d(ly,lx);%angulo en degrees
    switch eletype(i)
        case {2,22}
            nudos(nodestart)=nudos(nodestart)+1;
            nudos(nodeend)=nudos(nodeend)+1;
        case {3,33}
            j=j+1;
            nudos(nodeend)=nudos(nodeend)+1;
            hingedlist(j)=i; 
            elenod(i,1)=N+j;
            nodeDofs(N+j,:)=[nodestart*3-2 nodestart*3-1 N*3+j];
        case {4,44}
            j=j+1;
            nudos(nodestart)=nudos(nodestart)+1;
            hingedlist(j)=i; 
            elenod(i,2)=N+j;
            nodeDofs(N+j,:)=[nodeend*3-2 nodeend*3-1 N*3+j];
    end
end