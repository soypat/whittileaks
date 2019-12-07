%% FuncForm Q4
syms x y real
X = [1 x y x*y];
q4nod = [-1  -1
          1  -1
          1   1
         -1   1];
A = zeros(size(q4nod,1),length(X));
for i=1:size(q4nod,1)
    x=q4nod(i,1); y = q4nod(i,2);
    A(i,:) = eval(X);
end
syms x y real
N = X*inv(A);
dN = [diff(N,x);diff(N,y)];