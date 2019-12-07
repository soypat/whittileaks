%% Graficador de tensiones para Q4
for e = 1:Nelem
    elenod = elementos(e,:);
    h=patch('Faces',1:4,'Vertices',posdef(elenod,:),...
            'FaceVertexCData',Sxx(:,e));
    set(h,'FaceColor','interp','CDataMapping','scaled');
end
colormap(jet(10)); %10 es el numero de colores en el bandplot
Slims = [min(min(Sxx)) max(max(Sxx))];
caxis(Slims);
daspect([1 1 1]);
title('\sigma_{xx} [Pa]');xlabel('x [m]');ylabel('y [m]')
colorbar('YTick',Slims(1):diff(Slims)/5:Slims(2));
