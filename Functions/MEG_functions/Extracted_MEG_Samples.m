
%% ###############   Spikes Detection using SCSA  ############################
% This script detects epyliptic spikes bases on SCSA and FFT

% Important: the input data are stored in "./Input_data/*.mat' files  containning:
% [y0: MEG electrodes without Spikes ] , [original_file : name of data] 
% [y : MEG electrodes with Spikes]     , [noisy_file : name of spiked data] 
% [ t: time  ]  ,  [ Spike_startes: starting  detection time]  ,  [Spike_stops: stopping detection time]
% [ Time_spike : the exact spike detection  time ]   
%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Nov,  2017
%  

%% ###########################################################################
% clear all;  close all ; 
format shortG;  addpath ./Functions ;Include_function ;%log_html_file
clearvars Conf_Elctr Bi_Elctr
global  t  suff  Electrode_list  ;

%% The input parameters
Electrode_list=1:26;%2:4;%                   % the list of electrods to be used
L_max=100;                              % Spikes frame size
Frame_Step=2;                         % sliding  frame step size
% Thresholds
bmin=-2.49e-11;bmax=2.49e-11;


%% #########################   Display   ################################
fprintf('########################################################################\n');
fprintf('|          Spikes Detection for Epileptic signal Project 2018            \n');
fprintf('########################################################################\n\n');

fprintf('\n --> Extract  classification samples from input MEG Data: ');
d_data0=string(strcat('- Sampling:  L=',num2str(L_max),', Frame Step=',num2str(Frame_Step)));
fprintf(' \n %s\n ',d_data0);

%% #########################    Load data   ################################
ext='./Input_data/MEG_Epy_KSU/MEG_signals/*.mat';
[filename rep]= uigetfile({ext}, 'File selector')  ;
chemin = fullfile(rep, ext);   list = dir(chemin);  
cname=strcat(rep, filename);   load(cname); 

%% The obtained results will be saved in:
meta= strcat('Load the spikes event in ', {' '},noisy_file,' data using: frame size =',num2str(L_max),' with step =',num2str(Frame_Step),' in Electrodes [',num2str(Electrode_list),']');

data_path=strcat('./Input_data/Extracted_spikes_data/',noisy_file,'/');
if exist(data_path)~=7; mkdir(data_path);end 

%%  Take  a small part from the signal to be studied
% cut_slot_from_signals;
Bi_Elctr(Electrode_list)=1; Conf_Elctr=bi2de(Bi_Elctr);

%% Extract the region where we have spikes
for EN_L=0          % Enable automatic segment size to be spikes size
    for EN_b=0      % Enable Thresholding S<bmin and S> bmax will be considered as spikes condidate
           
        clearvars  suff Xsp Xsp0 X y
    
        % Extract the spikes
        [Xsp,Xsp0,L_max,L_min]=Extract_the_spikes_dataset_Threshold(EN_L, L_max,Frame_Step, EN_b,bmin,bmax,t,Y,Y0,Spike_stops,Spike_startes,Time_spike);
       
        suff=strcat('_Electrods',num2str(Conf_Elctr),'_AutoL',num2str(EN_L),'_L',num2str(L_max),'_FrStep',num2str(Frame_Step),'_Th',num2str(EN_b));


        X=[Xsp;Xsp0];
        y=[ones(size(Xsp,1),1); zeros(size(Xsp,1),1) ];
        save(strcat(data_path,num2str(size(X,1)),'_',num2str(size(X,2)),'_',noisy_file,suff,'.mat'),'Conf_Elctr','Electrode_list','Frame_Step','Xsp','Xsp0','X','y','L_max','EN_L','EN_b','bmin','bmax','suff',...
                                                                                                    'fs','Y','Y0','nb_slice','t','noisy_file','original_file','SNR_dB','Electrode','SE','Time_spike', 'Spike_startes','Spike_stops')

    end
end

close all
figr=43;figure(figr);
    plot(Xsp','r', 'LineWidth',2 ); hold on;% ylim([-1.5e-10 2E-10])
    plot(Xsp0','g', 'LineWidth',1 );  hold off
    legend('Positive  Class  ')%, 'Negative Class  ')
    title(strcat(noisy_file, {' '}, 'Electrods: ',num2str(Electrode_list),', L=', num2str(L_max), ',Step=', num2str(Frame_Step) ))
    xlabel('samples')
    ylabel('Intensity')
    % ylim([-1.5e-10 2E-10])
    set(gca,'fontsize',16)
    
    %% save the figure of te used data
    name=strcat(num2str(size(X,1)),'_','_',num2str(size(X,2)),'_',noisy_file,suff);
    save_figure(data_path,figr,name) 
close all
