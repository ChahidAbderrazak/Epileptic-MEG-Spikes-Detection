
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
format shortG;  addpath ./Functions ;Include_function ;log_html_file
global  t     suff

%% The obtained results will be saved in:
data_path='./Input_data/Extracted_spikes_data/';
meta='Load the spikes event in one windows- without notmalization';

%% #########################    Load data   ################################
ext='./Input_data/*.mat';
[filename rep]= uigetfile({ext}, 'File selector')  ;
chemin = fullfile(rep, ext);   list = dir(chemin);  
cname=strcat(rep, filename);   load(cname); 

%%  Take  a small part from the signal to be studied
% cut_slot_from_signals;

%% Extract the region where we have spikes
for EN_L=0          % Enable automatic segment size to be spikes size
    for EN_b=0      % Enable Thresholding S<bmin and S> bmax will be considered as spikes condidate
           
        clearvars suff Xsp Xsp0 X y L_max

        % Spikes segments
        L_max=100;
        Frame_Step=50;
        
        % Thresholds
        bmin=-2.49e-11;bmax=2.49e-11;
    
        % Extract the spikes
        [Xsp,Xsp0,L_max,L_min]=Extract_the_spikes_dataset_Threshold(EN_L, L_max,Frame_Step, EN_b,bmin,bmax,t,Y,Y0,Spike_stops,Spike_startes,Time_spike);
       
        suff=strcat('_AutoL',num2str(EN_L),'_L',num2str(L_max),'_FrStep',num2str(Frame_Step),'_Th',num2str(EN_b));


        X=[Xsp;Xsp0];
        y=[ones(size(Xsp,1),1); zeros(size(Xsp,1),1) ];
        save(strcat(data_path,num2str(size(X,1)),'_MEG_Extracted_',suff,'.mat'),'Xsp','Xsp0','X','y','L_max','EN_L','EN_b','bmin','bmax','suff')

    end
end

close all
figure;plot(Xsp','r'); hold on;% ylim([-1.5e-10 2E-10])
 plot(Xsp0','g'); ylim([-1.5e-10 2E-10])

