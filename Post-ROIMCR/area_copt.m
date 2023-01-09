function [area,height] = area_copt(copt,nsamp,nrows)
% [ area,height] = area_copt(copt,nexp,nrows )
% copt is from mcr-als
% nexp nr. of samples/experiments
% nrows nr of rows of each experiment
% if nrows is not assigned in the inoput 
% nrwow=nrows of copt / nsamp
% area have the peak areas of all the components in copt for the 9 samples
% area(nsamp,nc)
% the same for the heights height(nsamp,nc)

[nr,nc]=size(copt);
area=zeros(nsamp,nc);
height=zeros(nsamp,nc);
if nargin < 3
    nrows(1:nsamp)=nr/nsamp;
end
nrows_total=sum(nrows);
if nrows_total ~= nr
    error('Warning: sum of the individual nr. of rows is not equal to the size of copt')
end 
inic=1;
for i=1:nsamp
    iend=inic+nrows(i)-1;
    for j=1:nc
        area(i,j)=sum(copt(inic:iend,j));
        height(i,j)=max(copt(inic:iend,j));
     end
    inic=iend+1;
end
for j=1:nc
    display(['areas and heights in the different samples for comp. nr. ',num2str(j)])
    subplot(2,1,1),bar(area(1:nsamp,j))
    subplot(2,1,2),bar(height(1:nsamp,j))
    % pause (1)
end
subplot(2,2,1),plot(area)
title('areas per sample')
subplot(2,2,2),plot(area')
title('areas per component')
subplot(2,2,3),plot(height)
title('heights per sample')
subplot(2,2,4),plot(height')
title('heights per component')

