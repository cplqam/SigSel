function [MSroi_new,mzroi_new] = delete_mz_from_components(d,mz,s,perc)
%This function is a new version of 'mz_components_new.m'. In this function you
%can select which component you want to delete to repeat MCR analysis
%without those mzROI signals

%INPUT
%d -> MSroi
%mz -> The set of mz (mzroi)
%s ->  St matrix from MCR-ALS analysis  
%perc -> Percentage of max intensity from which the rest of the signals are considered
%       not background (0-1)

components_d = input('Delete components: ');

res = {};
dimensiones  = size(s);

row = dimensiones(1);
col = dimensiones(2);

if max(components_d) > row
     error('Warning: the number of component selected is out of range')
end

for n1 = 1:row;
    r = [];
    r2 = [];
    for n2 = 1:col;
       if s(n1,n2) >= perc;
           r = [r,n2];
       end
    end
    for position = r;
       r2 =[r2,mz(position)];
    end
    res{n1,1} = r2;

end
comp = {};
for n = 1:row;
    comp{n,1} = n;
end
resultados =struct('Components',comp,'mz_values',res);

mz_del = [];
for n = components_d
    mz_del = [mz_del,resultados(n).mz_values];
end

pos = [];
for n = mz_del
    pos = [pos,find(mz == n)];
end

d(:,pos) = [];
mz(pos) = [];

MSroi_new = d;
mzroi_new = mz;
end

