function [full_peaks, full_time] = mzxml_information_roimcr(file)
%This function provides a workflow for achieving the necesary information
%to carry out the ROI compression from a raw data transformed to mzxml
%format using Proteowizard or RawConverterer software. This function also
%provides to select Retention Times of interest following the instructions.

%INPUT 
%file: A file in mzxml format obtained from .raw format using Proteowizard or RawConverterer software

%OUTPUT
%full_peaks: a cell with the mz and intensity at selected RTs 
%full_times: a cell with RT selected


a = input('the transformation of Raw data to mzxml was performed by Proteowizard(0) or RawConverterer(1): ');

if a > 1
    error('Warning: you should specify the origen of the file')
end

matriz = file.scan;
dimens = size(matriz,1);

b = input('Do you want to eliminate MS2 Scans? yes(0), no(1): ');
if b == 0
    scan = {matriz(1:dimens).msLevel};
    pos = find(cell2array(scan) == 1);
    matriz = [matriz(pos)];
elseif b == 1
    matriz = matriz;
end

dimens = size(matriz,1);

if a == 1
    t = {matriz(1:dimens).retentionTime};
    times = [];
    for n = 1:dimens
        tiem = t{n};
        tiem = erase(tiem,'PT');
        tiem = erase(tiem,'S');
        tiem = replace(tiem,',','.');
        tiem = str2num(tiem);
        times = [times;tiem];
    end
elseif a == 0
    t = {matriz(1:dimens).retentionTime};
    times = [];
    for n = 1:dimens
        tiem = t{n};
        tiem = erase(tiem,'PT');
        tiem = erase(tiem,'S');
        tiem = str2num(tiem);
        times = [times;tiem];
    end
end

mas_int = {};
for v = 1:dimens
    dim2 = size(matriz(v).peaks.mz);
    t2 = dim2(1);
    m = [];
    i = [];
    for celda = 1:t2;
        if mod(celda,2) == 0;
            i = [i;matriz(v).peaks.mz(celda)];
        else
            m = [m;matriz(v).peaks.mz(celda)];
        end
    end
    m_i = [m,i];
    mas_int{v,1} = m_i; 
end

b = input('Do you want to select all full ms retention times? yes(0), no(1): ');

if b == 1
    n = input('Select every every n times: ');
    
    times = times(1:n:dimens);
    mas_int = mas_int(1:n:dimens);
elseif b == 0
else
    error('Warning: select if you want to use all retention times')
end

c = input('Do you want to select all or an interval of retention times? all(0), interval(1): ');

if c == 0
    full_time = times;
    full_peaks = mas_int;
elseif c == 1
    n = input('Select the interval: ');
    
    inte = size(n,2);
    if inte == 1
        full_time = times(n(1):end);
    elseif inte == 2
        full_time = times(n(1):n(2));
    elseif inte > 2
        error('Warning: the number of interval values must not exceeds 2')
    end
    
    if inte == 1
        full_peaks = mas_int(n(1):end);
    elseif inte == 2
        full_peaks = mas_int(n(1):n(2));
    end
else
    error('Warning: select if you want to use an interval of retention times')
end
  
end

