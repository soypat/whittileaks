function [x,bde,phase] = bodetocsv(g, fname,N)
% parameters
    minPhase = 1; %degrees in absolute magnitude
    maxPhase = 179;
    % code
    xtest = logspace(-8,2);
    phase = angle(g(xtest.*1i))*180/pi;
    changes = [find(phase<-minPhase,1,'first') find(phase<-maxPhase,1,'first')];
    lims = xtest(changes);
    x = logspace(log10(lims(1)),log10(lims(2)),N)';
    bde = 20*log10(abs(g(x*1i)));
    phase = angle(g(x.*1i))*180/pi;
    fid = fopen(fname,'w');
    fprintf(fid,'%s\n',['x,','bode,','phase']);
    for i=1:N
       fprintf(fid,'%f,%f,%f\n',x(i),bde(i),phase(i));
    end
    fclose(fid);
end