function [pg] = gauss(quad)
% GAUSS Obtiene puntos de cuadratura sobre una linea, superficie o volumen
% para los elementos finitos. El output contiene los siguientes campos:
%
% u: Posiciones de los puntos gauss
% w: Pesos de los puntos gauss
% n: Cantidad de puntos gauss
%
% Ejemplos
%   pg = gauss([3 3]) %Cuadratura superficie 3x3 de 9 puntos gauss (Orden 2)
%   pg = gauss([5 5 5]) % Cuadratura volumen 5x5x5 de 125 puntos gauss (Orden 4)
 
    if max(quad) > 5 || min(quad) < 1
        error('Ingresar un vector con numero indicando cantidad de puntos gauss en una dimension.');
    elseif length(quad)>3
        error('Longitud de vector ingresado no puede exceder 3 (dimension)!');
    end
    x4 = [sqrt( (3-2*sqrt(6/5))/7 ), sqrt( (3+2*sqrt(6/5))/7 )];
    x5 = [1/3*sqrt(5 - 2*sqrt(10/7)), 1/3*sqrt(5 + 2*sqrt(10/7))];
    w4 = [18+sqrt(30) 18-sqrt(30)]/36;
    w5 = [322+13*sqrt(70) 322-13*sqrt(70)]/900;
    % Vectores precargados
    X = {  0
           [-sqrt(1/3) sqrt(1/3)]
           [-sqrt(3/5) 0 sqrt(3/5)]
           [-x4(2) -x4(1) x4(1) x4(2)]
           [-x5(2) -x5(1) 0 x5(1) x5(2)]};
    W = {   2
            [1 1]
            [5/9 8/9 5/9]
            [w4(2) w4(1) w4(1) w4(2)]
            [w5(2) w5(1) 128/225 w5(1) w5(2)]};
    dim = length(quad);
    pg.n = prod(quad); % Cantidad de puntos gauss
    pg.u = zeros(pg.n,dim); % Posiciones
    pg.w = zeros(pg.n,1); %Pesos
    
    weightcols = zeros(pg.n,dim); % Auxiliar para calcular pesos
    for d = 1:dim
        xpg = X{quad(d)};
        wpg = W{quad(d)};
        if d == dim
            pg.u(:,dim) = repmat(xpg',pg.n/length(xpg),1);
            weightcols(:,dim) = repmat(wpg',pg.n/length(xpg),1);
            break
        end
        col = [];
        colw = [];
        for k = 1:pg.n/(prod(quad(d+1:end))*length(xpg))
            for j = 1:quad(d)
                col = [col; repmat(xpg(j)', prod(quad(d+1:end)),1)];
                colw = [colw; repmat(wpg(j)', prod(quad(d+1:end)),1)];
            end
        end
        pg.u(:,d) = col;
        weightcols(:,d) = colw;
    end
    pg.w = prod(weightcols,2);
end