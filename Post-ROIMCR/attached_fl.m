function samp = attached_fl(res,number,samp)
%It is an auxiliar function inside fragmentation_list.m for not replying
%code. This function provides an association between the mz of each
%component and the retention times of that component for aech sample 

for n = 1:size(res,1)
    pos = 0;
    row = res(n,:);
    long = size(row{2},1);
    for s = 1:long
        num = [row{1,2}(s)];
        num = cell2mat(num);
        if num == number
            pos = s;
        end
    end
    if pos > 0
        samp(n,2) = row{1,4}(pos);
        samp{n,3} = n;
        pos = 0;
    end
end
[samp{:,1}] = res{:,3}; 

p = [];
for i = 1:size(samp,1)
    a = samp(i,:);
    if size(a{2},1) > 0
        p = [p,i];
    end
end
samp = [samp(p,:)];
end

