%% FForma T4
syms r s t
unod = [0  0  0
        1  0  0
        0  1  0
        0  0  1];
X = [1 r s t];
A = nan(length(X));
k=0;
for inod = unod'
   k = k + 1;
   r = inod(1); s = inod(2); t = inod(3);
   A(k,:) = subs(X);
end
syms r s t
X = subs(X);
N = X/A;
dN = [diff(N,r); diff(N,s); diff(N,t)];