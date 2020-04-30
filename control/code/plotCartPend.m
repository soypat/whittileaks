function [ax] = plotCartPend(ax,X,L,M,m)
    y = 0;
    x=X(1);q = X(2);
    xm = x + sin(q)*L;
    ym = y + -L * cos(q);
    cla(ax)
    scatter(ax,xm,ym,'ko') %grafico masa
    hold on
    plot(ax,[x xm],[y ym],'k-') % grafico varilla
    plot(ax,[0 0],[-L/2 L/2],'r--') % linea vertical sobre x=0
    sz = [2 1]*L/16*M/m;
    pos = [x y] - sz/2;
    rectangle(ax,'Position',[pos sz])
    daspect([1 1 1])
end