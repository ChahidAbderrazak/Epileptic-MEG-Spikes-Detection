
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
clear all;  close all ; addpath ./Functions ;Include_function ;log_html_file
global  t y y0 store_decomposition Results_path post_save_tag   


%% The obtained results will be saved in:
Results_path=strcat('./Results/', char(datetime('today')),'/Spikes_FFT'); %'./Results/Upsampling'; %

%% load saved signal
Load_saved_data
%%  Take  a small part from the signal to be studied
% cut_slot_from_signals;

for Sig2study=[1];                                            % from the list of loaded sognal what are the sigals to be studied

    %% upload a new electrode signal 
    if  Sig2study > N
    break;
    end
    upload_New_Sample

    %% Filter the data Low pass filter
%     Pre_filter_MEG_signals

    %% PLot the detection for the actual electrode
    plot_Signals

end

%% Plot the final results
figr=12;counter=1;Figure1_MEG
