
%% #################      Spikes data preparation    #########################
% This script prepare the data for .mat usage.  Plese make ayre that you
% have  healthyX.mat  amd spikesX.mat files that containes all te electrods
% measurments.  

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Nov,  2017
%  
%% ###########################################################################

clear all; close all; addpath ./Functions
%% Load the Healthy MEG
fs=1000;
Sig2study=1;                            % from the list of electrodes, the electrod number signal what will be studied
spikes=1;                               % if the electrod has epyiptic spikes=1 else spikes=0
SNR_dB='Spikes'; nb_slice=1;            % To diferenciate the data
Plot_electrods = 1;                 % If you want to plot all the electrods amples seperatelly Plot_electrods=1 else Plot_electrods=0
Results_path='./MEG_signals';

%% ############################   START HERE    ##############################
% Read the healthy signal
fprintf('\nChoose the healthy MEG signal.\n')
ext='./MEG_Data_Set/*.mat';[filename0 rep]= uigetfile({ext}, 'File selector')  ;
cname0=strcat(rep, filename0); 
original_file=filename0(1:end-4);
load(cname0)
eval(['Y0=',original_file,';'])     

%% 
N0=max(size(Y0));
t0=0:1/fs:(N0-1)/fs;
figr=1;
% Plot the Two signals
figure(figr);
for i=1:26

plot(t0,Y0(i,:)), hold on;
lgnd_healty{i}=strcat('Electrode n ',num2str(i));
end
hold off;
A=legend(lgnd_healty);
A.FontSize=14;
title('The input MEG  electrodes for the healthy patient 1');


%% Save The figures
name=strcat(original_file,'Electrode_all');
save_figure(Results_path,figr,name) 



%% Load the Affected  MEG with Spikes
fprintf('\nChoose the Affected  MEG with Spikes.')
SE_case=original_file(end);
ext=strcat(ext(1:end-4),SE_case,'.mat');
[filename rep]= uigetfile({ext}, 'File selector')  ;
cname=strcat(rep, filename); 
noisy_file=filename(1:end-4);
load(cname);
eval(['y=',noisy_file,';'])     
fprintf('\nPlease wait few seconds :)')


N1=max(size(y));
t1=0:1/fs:(N1-1)/fs;

%% Plot the Two signals
figr=figr+1;figure(figr);
for i=1:26
plot(t1,y(i,:)), hold on;
lgnd_spikes{i}=strcat('Electrode n ',num2str(i));
end
hold off;
A=legend(lgnd_spikes);
A.FontSize=14;
title('The input MEG  electrodes for the patient 1');


%% Save The figures
name=strcat(noisy_file,'Electrode_all');
save_figure(Results_path,figr,name) 

%% Load Spikes 
cname1=strcat(rep, '\Spikes_locations',SE_case,'.xlsx');
fprintf('\nloading the spikes locations.')
[Electrode,SE,Time_spike,Spike_startes,Spike_stops] = importfile(cname1);


%% Take the 1st elctrodes in both cases
N=min(N0,N1);
if N1>N0
    t_all=t0;
else
    t_all=t1;
end

[N M]=size(y);  [N0 M0]=size(Y0);  N=min(N,N0);M=min(M,M0);
Y=y(1:N,1:M);   Y0=Y0(1:N,1:M);   t=t_all(:,1:M);

%% Save data
save(strcat(Results_path,'/Spikes',SE_case,'_electrode_all.mat'),'fs','Y','Y0','nb_slice','t','noisy_file','original_file','SNR_dB','Electrode','SE','Time_spike', 'Spike_startes','Spike_stops')
clearvars t_all y y0;
% 
% Results_path_Sep=strcat(Results_path,'/Separated_Electrodes')
% %% Plot all the electrodes MEG signals (Healthy + unhealthy with spikes)
% Time_spike0=Time_spike;    Spike_startes0=Spike_startes;         Spike_stops0=Spike_stops;  
% if Plot_electrods==1
% fprintf('\n loading Each electrod seperatelly.')
% 
%     for j=1:max(size(Electrode))
%     fprintf('.')
%     Sig2study=Electrode(j);
%     y0=Y0(Sig2study,1:M);
%     y=Y(Sig2study,1:M);
%     Time_spike=Time_spike0(Sig2study);
%     Spike_startes=Spike_startes0(Sig2study);         
%     Spike_stops=Spike_stops0(Sig2study);  
%     
%     %% Plot the Two lectrodes signals
%     figr=figr+1;figure(figr);
%     plot(t,y0), hold on;
%     plot(t,y), hold off;
%     h1 = vline(Time_spike,'k','Spike time ');
%     lgnd_spikes{i}=strcat('Electrode n ',num2str(i));
%     hold off;
%     xlim([t(1) t(end)])
%     A=legend(lgnd_spikes(Sig2study));
%     A.FontSize=14;
%     title(strcat('The  MEG  electrode ',num2str(Sig2study) ,'. For a healthy an non-healthy patient',num2str(SE(Sig2study))));
% 
%     % create a zoom metabolites
%     axes('position',[.25 .65 .56 .2])
%     box on % put box around new pair of axes
%     indexOfInterest = (t <=Spike_stops ) & (t >=Spike_startes); % range of t near perturbation
% 
%     plot(t(indexOfInterest),y0(indexOfInterest), 'LineWidth',3);hold on
%     plot(t(indexOfInterest),y(indexOfInterest), 'LineWidth',1.7);hold on
%     h2 = vline([Spike_startes Time_spike Spike_stops],{'r','k','r'},{'Start','Spike time','Stop'});
%     title(strcat('The Spikes event [Zoom]'))
% 
%     %% Save The figures
%     name=strcat('Spikes',SE_case,'_electrode',num2str(Sig2study));
%     save_figure(Results_path_Sep,figr,name) 
% 
%     %% Save data
%     save(strcat(Results_path_Sep,'/Spikes',SE_case,'_electrode_',num2str(Sig2study),'.mat'),'fs','y','y0','nb_slice','t','noisy_file','original_file','SNR_dB','Sig2study','Electrode','SE','Time_spike', 'Spike_startes','Spike_stops')
%     end
% end

disp('############## THE END  ##############')