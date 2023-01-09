function [resultado] = filter_selection(file,samples,components)
%This function provides a selection of those signals belong to components
%of interest in a predefined samples

%INPUT
%file: 'resultado1' from fragmentation_list.m or 'res_final' from charge_determination.m 
%whether charge is required
%samples: an array of samples of interes inside 'file' variable
%components: the components selected as components of interest for
%selecting only those signals belong to these components (MUST BE IN 1 COLUMN)

%OUTPUT
%resultado: a file with samples of interest indicated in 'samples'
%variables with those signals belong to components of interest

file = file(samples,1);

row = size(file,1);
resultado = {};

for n = 1:row
    list = [];
    sam = file{n,1};
    c = sam(:,3);
    for comp = 1:size(components,1)
        compo = components(comp);
        a = find(c==compo);
        list = [list;a];
    end
    resultado{n,1} = sam(list,:);
end
end

