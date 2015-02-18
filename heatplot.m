clear
[filename, pathname]=uigetfile('*.mat')%'oxford_2014.mat';
load([pathname filename])
close all

tbase=500; %amount of baseline collected
ta=500; %amount of time after the TMS pulse
gauss_size=5;

counter=0; %Will count the number of cells used 
allptsh=[];
normptsh=[];
for k=1:size(s,2)
    if(length(s(k).Pulses)>0) & median(diff(s(k).Pulses))>4 %& ...
            %size(s(k).Stim,1)>0 & strcmp(s(k).Stim(1),'Stim')==1 &...
            %size(s(k).Intensity,1)>0 & strcmp(s(k).Intensity(1),'90')==1
        pulses=s(k).Pulses;
        firerate=s(k).FireRate;
        for g=1:max(s(k).clusters)
            cluster=find(s(k).clusters==g);
            if length(cluster)>0 & length(cluster)>length(pulses)
                
                [spk_d,trl_fr,bin_start_times,baseline,mean_trl_fr]=...
                    psth1block(pulses,tbase+gauss_size,ta+gauss_size, 1000*s(k).times(cluster), gauss_size,0);
                close;
                if size(s(k).Stim,1)>0 & strcmp(s(k).Stim(1),'Stim')==1
                    stim=1;
                elseif size(s(k).Stim,1)>0 & strcmp(s(k).Stim(1),'Sham')==1
                    stim=0;
                else
                    continue
                end
                if size(s(k).Intensity,1)>0
                    inten=str2num(s(k).Intensity{1});
                else
                    continue    
                end
                if size(inten)==0
                    continue
                end
                counter=counter+1;
                allptsh=[allptsh; stim inten mean_trl_fr];
                normptsh=[normptsh; stim inten mean_trl_fr/max(abs(mean_trl_fr))];
            end
        end
    end
end
figure
subplot(1,2,1)
imagesc(allptsh(:,3:end))
line([500 500],[0 828],'Color','k')
ylabel('Cells-All Intensities')
xlabel('Time (ms)')
%title('Stim')
% figure
subplot(1,2,2)
imagesc(normptsh(:,3:end))
line([500 500],[0 828],'Color','k')
ylabel('Cells-All Intensities')
xlabel('Time (ms)')
%title('Norm Sham')

% for n=1:10
% pos=find(shamps(:,2)<=n*10 & shamps(:,2)>10*(n-1));
% subplot(2,5,n);imagesc(shamps(pos,3:end),[-1 1])
% title(['Sham ' num2str(n) '0%'])
% line([500 500],[0 length(pos)+1],'Color','k')
% end
% for n=1:10
% pos=find(stimps(:,2)<=n*10 & stimps(:,2)>10*(n-1));
% subplot(2,5,n);imagesc(stimps(pos,3:end),[-1 1])
% title(['Stim ' num2str(n) '0%'])
% line([500 500],[0 length(pos)+1],'Color','k')
% end