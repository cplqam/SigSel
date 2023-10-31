function [result, result_c0,result_c1,result_cresto] = charge_exploration(file)
%This function provides an exploration of the charge distribution of the
%m/z signals. Also, it provides a set of data with the information of the charge 0,
%1 and the ret of the charges

%INPUT
%file: a cell with the data of all samples in a single column exported in txt format from
%rawConverterer in ms1 mode. Import parameters: numeric matrix,
%replace unexportable values for 0, select space, coma and tabulator as
%column separator and select only 4 columns from the row with 'S' as 
%a value in the first column (row 17 aprox) til the end

%OUTPUT
%result: the information of all signals(mz,intensity,charge,unknown,scan
%and rt)
%result_c0: the information of the signals with charge 0:
    %1st column: the same info that the result output
    %2nd column: the number of mz signals with this charge+
    %3rd column: the percentaje that the mz signals with this charge
    %represent
%result_c1: the same output that result_c0, but for mz with charge 1
%result_cresto: the same output that result_c0, but for mz with other
%charges

n_s = size(file,1);
result = {};
result_c0 = {};
result_c1 = {};
result_cresto = {};
for n = 1:n_s
    resultado = [];
    m = file{n};
    r = size(m,1);
    for i = 1:r
        row = m(i,:);
        if row(1) == 0 & row(2) ~= 0
            scan = row(3);
        elseif row(2) == 0 & m(i-1,2) ~= 0
            rt = row(3);
        else
            m(i,5) = scan;
            m(i,6) = rt;
        end
    end
    
    %Delete the rows with missiong values (they are not signals)
    s_f = find(m(:,1) == 0);
    
    m(s_f,:) = [];
    result{n,1} = m;
    
   r2 = size(m,1);

   %Count the signals with charge 0
   c_0 = find(m(:,3) == 0);
   num_0 = size(c_0,1);
   result_c0{n,1} = m(c_0,:);
   result_c0{n,2} = num_0;
   result_c0{n,3} = (num_0/r2)*100;
   display(['Number of mz with charge 0: ',num2str(num_0)])
   
   %Count the signals with charge 1
   c_1 = find(m(:,3) == 1);
   num_1 = size(c_1,1);
   result_c1{n,1} = m(c_1,:);
   result_c1{n,2} = num_1;
   result_c1{n,3} = (num_1/r2)*100;
   display(['Number of mz with charge 1: ',num2str(num_1)])
   
   %Count the signals with other charges
   c_resto = find(m(:,3) > 1);
   num_resto = size(c_resto,1);
   result_cresto{n,1} = m(c_resto,:);
   result_cresto{n,2} = num_resto;
   result_cresto{n,3} = (num_resto/r2)*100;
   display(['Number of mz with charge defferent to 1 or 0: ',num2str(num_resto)])

   piechart = input('Do you want a graphical representation? y/n (1/0): ');
    
   if piechart == 1
       tot_sig = result_c0{n,2} + result_c1{n,2} + result_cresto{n,2};
       x = [result_c0{n,2}/tot_sig, result_c1{n,2}/tot_sig, result_cresto{n,2}/tot_sig];
       labels = {'Signals with charge 0','Signals with charge 1', 'Signals with other charge'};
       pie(x)
       legend(labels,'Location','northeastoutside','Orientation','vertical')
   end

end
end
