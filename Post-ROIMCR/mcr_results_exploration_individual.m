function mcr_results_exploration_individual(copt,sopt,mz,nsam,time,comp)
%This function provides the tools for the exploration elution profile and spectrum
%from MCR results. In this function there is a first step of elution
%profile visualization in which you can select if want to zoom in some times of interest 
%(although in this first step the X axis represents the position of the
%different retention times). On the other hand, a second step is carried out, providing
%a complete representation of the spectrum and the elution profile zoomed
%in (if you selected in the first step). Every final figure is saved in a
%ppt file called 'graficas.ppt'

%INPUT
%copt: the copt matrix result of the MCR analysis
%sopt: the sopt matrix result of the MCR analysis
%mz: the array of different mz values in sdopt
%nsam: the number of samples in the dataset. IMPORTANT: THESE SAMPLES MUST HAVE THE SAME NUMBER OF RETENTION TIMES 
%time: a 1 column array with the retention times of all samples augmented

[r,c] = size(copt);

tiempo ={};
for n = 1:nsam
    if n == 1
        tiempo{n,1} = time(1:(r/nsam),:);
    elseif n > 1
        tiempo{n,1} = time((r/nsam)*(n-1)+1:(r/nsam)*n,:);
    end
end

pe ={};
for n = 1:nsam
    if n == 1
        pe{n,1} = copt(1:(r/nsam),:);
    elseif n > 1
        pe{n,1} = copt((r/nsam)*(n-1)+1:(r/nsam)*n,:);
    end
end
    
hold on
title(['MCR component ',num2str(comp)])
for n =1:nsam
    plot(pe{n}(:,comp))
    xlabel('Position of times')
end
shg
hold off

zoom = input('Do you want to zoom in? y/n (1/0): ');
    
while zoom ~= 1 && zoom ~= 0
    zoom = input('Do you want to zoom in? y/n (1/0): ');
end
    
if zoom == 0
    clf
    subplot(2,1,1);
    hold on
    for n =1:nsam
        plot(tiempo{n},pe{n}(:,comp));
        title(['Elution profile of component: ',num2str(comp)]);
        xlabel('minutes');
        
    end
    hold off  
        
    [maxi,maxmz]=max(sopt(comp,:));
    maxmz = mz(maxmz);
    subplot(2,1,2);
    bar(mz,sopt(comp,:),100);
    text(maxmz+0.05*maxmz,maxi-0.1*maxi,[num2str(maxmz),' m/z'])
    title(['Pure spectrum of component: ',num2str(comp)]);
    xlabel('mz values');

saveppt('graficas.ppt');
pause
elseif zoom == 1
    interval = input('Introduce the interval of positions you want to zoom in (in 1 column array): ');
    
    if size(interval,1) ~= 2
        error('you should introduce the interval in 1 column array format')
    end
    clf
    subplot(2,1,1);
    hold on
    for n =1:nsam
        plot(tiempo{n}(interval(1):interval(2)),pe{n}(interval(1):interval(2),comp));
        title(['Elution profile of component: ',num2str(comp)]);
        xlabel('minutes');
        
    end
    hold off    
        
    [maxi,maxmz]=max(sopt(comp,:));
    maxmz = mz(maxmz);
    subplot(2,1,2);
    bar(mz,sopt(comp,:),100);
    text(maxmz+0.01*maxmz,maxi-0.05*maxi,[num2str(maxmz),' m/z']);
    title(['Pure spectrum of component: ',num2str(comp)]);
    xlabel('mz values');

saveppt('graficas.ppt');
pause
end


end


