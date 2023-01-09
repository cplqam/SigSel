function [result,result2,rts] = charge_selection(fichero)
%This function selects the mz with charges 0 and 1 that its interesting to
%be deleted from raw data

%INPUT
%fichero: txt file from RawConverter in ms1 format
%   Characteristics of exportation from RawConverterer: numeric matrix,
%   replace unexportable values for 0, select coma and tabulator as
%   column separator and select only 4 columns
%
%OUTPUT
%result: data metrix,
%           1st column --> mz
%           2nd column --> intensity
%           3rd column --> charge
%           4th column --> scan number
%result2: cell array, the input for the ROI compression with the mz and
%         intensity of the signals
%rt: array, the retention times


k = find(fichero(:,1) == 0);
ret_time = fichero(k,:);
rts = [];
for n = 2:size(ret_time,1)
    if ret_time(n-1,2) ~= 0
        rts = [rts; ret_time(n,3)];
    end
end

fichero(k,:) = [];

r = size(fichero,1);
t = 1;

for l = 1:r
    if l == 1
        fichero(l,4) = 1;
    else
        fichero(l,4) = t;
    end
    if l < r
        if fichero(l,1) > fichero((l+1),1)
            t = t+1;
        end
    end
end


carga  = fichero(:,3);
filas = [];

carga_0 = find(carga == 0);
c1 = input('Do you want to eliminate charge 1? 1/0 (y/n): '); 
if c1== 1
    carga_1 = find(carga == 1);
    filas = [carga_0;carga_1];
elseif c1== 0
    filas = [carga_0];
else
    error('You have to select wether you want to eliminate charge 1 signals')
end

fichero(filas,:) = [];
result = fichero;

%saco el full peaks
display(['This sample has: ',num2str(max(fichero(:,4))), ' Retention times'])
n_s = input('Number of RTs: ');

result2 = {};
for n = 1:n_s
    pos = find(result(:,4) == n);
    result2{n,1} = result(pos,[1,2]);
end

end

