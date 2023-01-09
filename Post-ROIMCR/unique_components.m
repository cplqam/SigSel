function [result1,result2] = unique_components(copt, times,per)
%This function provides a list of those components which only have signal
%in 1 sample and a list of samples where each compontent is represented

%INPUT
%copt: elution profile matrix result of MCRALS
%times: number of times of each matrix
%per: Percentaje of maximum signal used as threshold tintensity at each
%component

%OUTPUT
%result1: number of sampleas have signal at each component
%result2: components which has only signal in 1 sample


n_s = input('Number of samples: ');

col = size(copt,2);
maximos = [];

for n = 1:col
    component = copt(:,n);
    maximos = [maximos,max(component)];
end

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

componentes = {};
unicos = [];

for n = 1:col
    c = [];
    m = maximos(n);
    limite = per*m;    
    for i = 1:n_s
        m = max(matrix{i}(:,n));
        if m >= limite
            c = [c,i];
        end
        componentes{n} = c;
    end
    if size(c,2) == 1
        unicos = [unicos,n];
    end
end

result1 = componentes;
result2 = unicos;
end

