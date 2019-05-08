%Diagrama Moody
    rev=3000:1000:1e8+1;
    edv=[0 0.0005 .001 .002 .004 .006 .008 .01 .015 .02 .03 .04 .05];
    Ned=length(edv);
    N=length(rev);
    cbw=@(m,R,eD) -2*log10(eD/3.7+(m*2.51)/R);
    fev=zeros(98,1);
    prec=1E-4;
%Variable Assignment
    e=1;
    x=1E3;
    rightticks=zeros(11,1);
%Diagram Generation
fig=figure;
blk=[0 0 0];
set(fig,'defaultAxesColorOrder',[blk; blk])
for j=1:Ned
    
    for i=1:N
        e=1;
        x0=10;
        while e>prec
           x=feval(cbw,x0,rev(i),edv(j));
           e=abs(x-x0);
           x0=x;
        end
        fev(i)=1/x^2;
    end
    semilogx(rev,fev,'b-')
    hold on
    rightticks(j)=fev(end);
end
title("Diagrama Moody",'interpreter','latex','fontsize',18);
yl=ylim;
xlabel("Numero de Reynolds",'interpreter','latex','fontsize',14)
ylabel("Factor de Friccion de Darcy ($f$)",'interpreter','latex','fontsize',14)
yticks('manual')
yyaxis right
ylim(yl)
yticks(rightticks)
yticklabels(edv)
ylabel("Rugosidad Relativa ($\epsilon/D$)",'interpreter','latex','fontsize',14)
grid on






