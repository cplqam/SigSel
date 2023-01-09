function res_final = charge_determination(file,signals,error)
%This function allows to complete the otput of 'fragmentation_list.m' with
%the charge of the selected mz 

%INPUT
%file: a cell with the data of all samples in a single column exported from
%rawConverterer in ms1 mode with the charge information (string array, from
%first row with value Sin thhe first column to the end, separator:space and tab)
%signals: resultado1 from 'fragmentation_list.m' function
%erros: the mzerror used in the ROI compression step

%OUTPUT
%res_final: the same cell array of resultado1 but with the charge
%information

n_s = input('Number of samples: ');
result = {};

charge_0 = input('Have you eliminated the siganals with charge state 0 or not defined? 1/0 (y/n): ');

if charge_0 == 1
    file_final = {};
    charge_1 = input('Have you eliminated the siganals with charge state 1? 1/0 (y/n): ');
    for n = 1:n_s
        file_selected = file{n};
        if charge_1 == 1
            file_filtered = charge_determination_auxiliar(file_selected,1);
        elseif charge_1 == 0
            file_filtered = charge_determination_auxiliar(file_selected,0);
        else
            error('You have to select wether you eliminated charge 1 signals')
        end
        file_final{n,1} = file_filtered;
    end

elseif charge_0 == 0
    file_final = {};
    for n = 1:n_s
        file_selected = file{n};
        
        k = find(file_selected(:,1) == 0);
        file_selected(k,:) = [];

        file_final{n,1} = file_selected;
    end
end

for n = 1:n_s
    res = signals{n,1};
    cargas = file_final{n,1};
    
    cargas(:,3) = round(cargas(:,3),2);

    r = size(res,1);
    row = size(cargas,1);
    for n2 = 1:r
        i = 0;
        mz = res(n2,1);

        l_s = mz + error;
        l_i = mz - error;
        for n3 = 1:row
            val = cargas(n3,1);
            if (l_s > val) & (val > l_i)
                i = [i;cargas(n3,3)];
            end
        end
        
        if size(i,1) >1
            i = i(2:end,:);
            if mode(i) == 0
                i = max(i);
            else
                i = mode(i);
            end
        end
        res(n2,4) =i;
    end
    res_final{n,1} = res;
    n
end
end

