%% FuncForm Q4
clear dN N dNaux X dNxx dNyy dNxy 
syms x y real
syms dNaux real
X = [1 x y x*y];
q4nod = [-1 -1
        1  -1
        1  1
       -1  1];
A = zeros(size(q4nod,1),length(X));
for i=1:size(q4nod,1)
    x=q4nod(i,1); y = q4nod(i,2);
    A(i,:) = double(subs(X));
end
syms x y real
N = X*inv(A);
dNaux = [diff(N,x);diff(N,y)];