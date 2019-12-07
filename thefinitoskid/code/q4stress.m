%% Tensiones en nodos directo
% Matriz 3D para guardar tensiones
stress = zeros(size(E,2),Nnodporelem,Nelem); 
for e = 1:Nelem
    elemnod = nodos(elementos(e,:),:);
    meindof = elemdof(e,:);
    for n = 1:Nnodporelem % Obtengo tensiones en nodos directamente
        x = q4nod(n,1);  y = q4nod(n,2);
        J =subs(dNaux)*elemnod;
        dNxy=J\subs(dNaux);
        B=zeros(size(E,2),size(ke,1)); % Strain Displacement Matrix
        B(1,1:2:end-1)=dNxy(1,:);
        B(2,2:2:end)=dNxy(2,:);
        B(3,1:2:end-1)=dNxy(2,:);
        B(3,2:2:end)=dNxy(1,:);
        stress(:,n,e) = E*B*D(meindof);
    end
end
Sxx = squeeze(stress(1,:,:)); %Tensiones xx por elemento, por nodo
Syy = squeeze(stress(2,:,:));
Sxy = squeeze(stress(3,:,:));
Svm2d = sqrt( Sxx.^2 + Syy.^2 + 3*Sxy.^2 ); % Von mises. Tension efectiva
