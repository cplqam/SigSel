function list_txt(lista)
%INPUT 
%lista: output from 'fragmentation_list.m' or filter_selection (they have the same estructure) 

%OUTPUT
%.txt file with all signals and their retention times

row = size(lista,1);

for n = 1:row
    a = num2str(n);
    m = strcat('muestra',a,'.txt');
    fileid = fopen(m, 'w');
    fprintf(fileid, '%s %s %s\n', '"Retention Time"','"m/z"','"charge"');
    
    matriz = lista{n,1};
    r = size(matriz,1);
    [~, s] = sort(matriz(:, 2));
    m = matriz(s,:);
    
    for i = 1:r
        charge = round(m(i,4),0);
        fprintf(fileid, '%f %f %f\n',m(i,2),m(i,1),charge);
    end
    fclose(fileid);
    1
end
end

