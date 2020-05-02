function [] = makecsv(filename, mat, header)
%     
    if length(header)~=size(mat,2)
        error('Numero de encabezados debe ser igual a size(mat,2)')
    end
    
    fid = fopen(filename,'w');
    [N, heads] = size(mat);
    fprintf(fid,'%s',header{1});
    for i = 2:heads
        fprintf(fid,',%s',header{i});
    end
    fprintf(fid,'\n');
    for i=1:N
        temp = sprintf('%d,', mat(i,:));
       fprintf(fid,'%s\n',temp(1:end-1));
    end
    fclose(fid);
end

