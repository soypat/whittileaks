function [re, im, robust] = nyq(g)

    maxDist = 0.05;
    N = 100000;
    x=linspace(-1e3,1e3,N)';
    y = g(-x*1i);
    keepers = false(N,1);
    re = real(y); im = imag(y);
    robust = sqrt((re+1).^2 + im.^2);
    lastgraphed = 1;
    for i = 2:N
        if sqrt((re(i) - re(lastgraphed))^2+(im(i)-im(lastgraphed))^2)>maxDist
            lastgraphed = i;
            keepers(i) = true;
        end
    end
    
    re=re(keepers); im = im(keepers);robust = robust(keepers);
end

