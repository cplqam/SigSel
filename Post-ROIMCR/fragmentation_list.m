function [resultado1, resultado2] = fragmentation_list(copt,times,signals,mz,per,m_time)
%this function provides 2 list of ions with their retention times as a
%result of ROIMCR for each sample. It has 2 auxiliar functions: fl_list.m and attached_fl.m 

%INPUT
%copt: matrix of elution profile result of filtered MCR components
%times: an array with the amount of retenction times of each sample
%signals: a cell array result of unique_components.m (result1)
%mz: a list of mz result of mz_components.m
%per: the percentaje of maximum intensity as a signal (0-1, per=1 is recommended)
%m_time: the total times matrix 

%OUTPUT
%2 different ways to expose the list of mz and retention times at each
%sample
%resultado1: 
%   1st column --> mz
%   2nd column --> RT
%   3rd column --> component 

n_s = input('Number of samples: ');

%matrices de cada muestra según los RTs
matrix = {};
for n = 1:n_s
    if n == 1
        matrix{n,1} = copt(1:times(n),:);
    elseif n == 2
        matrix{n,1} = copt(times(n-1)+1:sum(times(1:n)),:);
    elseif n > 2
        matrix{n,1} = copt(sum(times(1:n-1))+1:sum(times(1:n)),:);
    end
end

%matrices de tiempos segun RTs
matrix_t = {};
for n = 1:n_s
    if n == 1
        matrix_t{n,1} = m_time(1:times(n),:);
    elseif n == 2
        matrix_t{n,1} = m_time(times(n-1)+1:sum(times(1:n)),:);
    elseif n > 2
        matrix_t{n,1} = m_time(sum(times(1:n-1))+1:sum(times(1:n)),:);
    end
end

col = size(signals,2);
%se seleccionan las componentes
r = {};
for n = 1:col
    comp = copt(:,n);
    sig = signals{n};
    cont = 1;
    p = {};
    for c = sig     
        m = matrix{c};
        t = matrix_t{c};
        component = m(:,n);
        maxi = max(component);
        value = maxi*per;
        tim = find(component >= value);
        t_def = t(tim);
        p(cont,1:2) = {c,t_def};
        cont = cont + 1;
    end
    r(n,1:2) = {p,mz(n).mz_values};
end

res = {};
for n = 1:size(r,1)
    res{n,1} = n;
    res{n,2} = r{n,1}(:,1);
    res{n,3} = transpose(r{n,2});
    res{n,4} = r{n,1}(:,2);
end

resultado2 = {};

for n = 1:n_s
    a = {};
    resultado2{n,1} = attached_fl(res,n,a);
end

resultado1 = {};

for sample = 1:n_s
    a = [];
    resultado1{sample,1} = fl_list(resultado2,a,sample);
    display(['Sample ',num2str(sample)])
end

end