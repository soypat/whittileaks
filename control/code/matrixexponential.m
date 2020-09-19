A = rand(3);
t0 = 0.5; 
fprintf('e^(At)=');disp(expt(t0,1e5,A));
function y = expt(t,n,A)
    y = eye(size(A));
    for i=1:n
        y = y + (A*t)^i/factorial(i);
    end
end
