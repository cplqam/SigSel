function [result] = charge_determination_auxiliar(fichero, char_1)
%This function is an auxiliar funtion to charge_determination.m
%Clear the signals with charge state 0 and 1 if it is necessary 

%INPUT
%fichero: txt file from RawConverter in ms1 format
%   Characteristics of exportation from RawConverterer: numeric matrix,
%   replace unexportable values for 0, select coma and tabulator as
%   column separator and select only 4 columns
%char_1: num, select if signals with charge state 1 have been eliminated.
%   1 if it is True 
%   0 If it is False
%
%OUTPUT
%result: data metrix,
%           1st column --> mz
%           2nd column --> intensity
%           3rd column --> charge
%           4th column --> scan number


k = find(fichero(:,1) == 0);
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

if char_1== 1
    carga_1 = find(carga == 1);
    filas = [carga_0;carga_1];
elseif char_1 == 0
    filas = [carga_0];
end

fichero(filas,:) = [];
result = fichero;
end

