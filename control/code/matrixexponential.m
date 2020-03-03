A = rand(3);
t1 = 0.5; 
fprintf('e^(At)=');disp(exp(A*t1));
fprintf('e^(At)=');disp(expt(t1,1e4,A));
function y = expt(t,n,A)
    y = ones(size(A,1));
    for i=1:n
        y = y + (A*t).^i/factorial(i);
    end
end
