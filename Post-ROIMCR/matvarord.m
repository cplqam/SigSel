function [dred,mzred,colelim,cred,sred,cnew,snew,r2new,r2old]=matvarord(d,c,s,time,mz);
[nr,n]=size(c);
[n,nc]=size(s);
cnew=zeros(size(c));
snew=zeros(size(s));
dred=zeros(size(d));
cred=zeros(size(c));
sred=zeros(size(s));
r2old=zeros(n+1);
r2new=zeros(n+1);
rthreshold=0.1;
colelim=[];
ispelim=[];
ispkept=[];

close all
display=input('do you want to plot the reordered profiles and spectra, y/n 1/0? ');
inspect=input('do you want to inspect, eliminate and reorder the data matrix, y/n 1/0? ');
ithres=input(['by default the relative treshold spectral intensity value is 0.1, do you want to keep it y/n 1/0? ']);
if ithres==0, rthreshold=input('rel. threshold value is:? '); end

r2old(n+1)=lofr(d,c,s);
disp(['explained variance by all components is ',num2str(r2old(n+1))]);

for i=1:n,
    r2old(i)=lofr(d,c(:,i),s(i,:));
    disp(['explained variance by component ',num2str(i),' is ',num2str(r2old(i))]);
end
[r2new(1:n),ir2] = sort(r2old(1:n),'descend');
disp(['new order of the components is ',num2str(ir2)])
cnew=c(:,ir2);
snew=s(ir2,:);


for i=1:n
    if display==1,
        
        figure(1)
        
        if nargin<3,
            subplot(2,1,1),plot(cnew(:,i))
            title(['concn profile of component: ',num2str(i)]);
            xlabel(['explained variance: ',num2str(r2new(i))])
            subplot(2,1,2),plot(snew(i,:)')
            title(['pure spectrum of component: ',num2str(i)]);
            xlabel(['explained variance: ',num2str(r2new(i))])
        else
            subplot(2,1,1),plot(time,cnew(:,i))
            title(['concn profile of component: ',num2str(i)]);
            xlabel(['explained variance: ',num2str(r2new(i))])
            subplot(2,1,2),plot(mz,snew(i,:)')
            title(['pure spectrum of component: ',num2str(i)]);
            xlabel(['explained variance: ',num2str(r2new(i))])
            % pause
        end
    end
    disp(['process spectrum nr. ',num2str(i)]);
    
    % degfault is threshold=0.1*max(s(i,:))
    threshold=rthreshold*max(s(i,:));
    
    [row,col,v] = find(snew(i,:)>threshold);
    ncol=length(col);
    if ncol>20, col=col(1:20);ncol=20;end
        
    if display==1, figure(2), plot(mz,s(i,:));end
    maxmzold=0;
    
    for k=1:ncol
        maxmz=mz(col(k));
        maxi=s(i,col(k));
        if k==1 | abs(maxmz-maxmzold) > 0.01
            if display ==1,text(maxmz+0.01*maxmz,maxi-0.02*maxi,[num2str(maxmz),' m/z']);end
        end
        maxmzold=maxmz;
        mzidentif(i,k)=maxmz;
        inidentif(i,k)=maxi;
        colidentif(i,k)=col(k);
    end
    
    if display ==1, title(['pure spectrum of component: ',num2str(i)]); pause (1), end
    
    if inspect==1
        ielimin=input('do you want to eliminate this component and the mz values of this component from the data matrix y/n 1/0 ? ');
        if ielimin==1
            colelim=[colelim,colidentif(i,1:ncol)];
            ispelim=[ispelim,i];
        else
            ispkept=[ispkept,i];
        end
    end
         
 
end

disp('proceed to the elimination of the nonb-desired components and of the mz correponding to these components in the MS data matrix')
ncolelim=length(colelim);
disp(['number of data columns (mz) to eliminate are: ',num2str(ncolelim)]) 
nispelim=length(ispelim);
disp(['number of components to eliminate are: ',num2str(nispelim)])

cred=cnew;
sred=snew;
dred=d;
mzred=mz;
cred(:,ispelim)=[];
sred(ispelim,:)=[];
sred(:,colelim)=[];
dred(:,colelim)=[];
mzred(colelim)=[];

end

%`possibility of inspect spectra to discard anomalous m/z values in the
%original data matrix
