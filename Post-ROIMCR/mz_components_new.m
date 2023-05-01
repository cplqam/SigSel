function [results] = mz_components_new(mz,s,perc)
%From this function, the mz values for each component are obtained
%INPUT
%mz -> mzroi array
%s -> S matriz from MCR-ALS  
%perc -> Percentaje of maximum intensity a signal is considered to be in 1 component (0-1)
%OUTPUT
%Struct variable in which echa row contains the component number, the mzROI
%values and their position in St matrix

res = {};
pos = {};
[row,col]  = size(s);

for n1 = 1:row;
    r = [];
    r2 = [];
    maximo = max(s(n1,:));
    for n2 = 1:col;
       if s(n1,n2) >= maximo*perc;
           r = [r,n2];
       end
    end
    for position = r;
       r2 =[r2,mz(position)];
    end
    res{n1,1} = r2;
    pos{n1,1} = r;

end
comp = {};
for n = 1:row;
    comp{n,1} = n;
end
results =struct('Components',comp,'mz_values',res, 'positions_in_St', pos);
end
