function [result] = fl_list(cell_mat,samp,n)
%It is an auxiliar function inside fragmentation_list.m for not replying
%code. This function transform the cell format results to a matrix of 2 columns
%with mz and time

%INPUT
%cell_mat: cell variable with the list of signals and times
%sample: variable name in which we want to create the list
%n: position the sample has in cell_mat

%OUTPUT
%result: a 2 column matrix with the mz and its time



sample = cell_mat{n};
r = size(sample,1);
for n2 = 1:r
    component = sample(n2,:);
    v1 = component{:,1};
    v2 = component{:,2};
    comp = component{:,3};
    r_v1 = size(v1,1);
    r_v2 = size(v2,1);
    for i = 1:r_v1
        m = v1(i);
        for i2 = 1:r_v2
            t = v2(i2);
            samp = [samp;m,t,comp];
        end
    end
end 
result = samp;
end

