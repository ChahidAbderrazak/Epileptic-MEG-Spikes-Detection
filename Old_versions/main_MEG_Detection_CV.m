
%% ###############   Spikes Detection using SCSA  ############################
% This script detects epyliptic spikes bases on SCSA and FFT

% Important: the input data are stored in "./Input_data/ready/*.mat' files  containning:
% [X: MEG electrodes without Spikes ] , [original_file : name of data] 
% [y : MEG electrodes with Spikes]     , [noisy_file : name of spiked data] 
 
%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Nov,  2017
%  
%% ###########################################################################
clear all;  close all ; addpath ./Functions ;Include_function ;log_html_file
global  t   store_decomposition Results_path post_save_tag   


%% The obtained results will be saved in:
Results_path=strcat('./Results/', char(datetime('today')),'/Spikes_FFT'); %'./Results/Upsampling'; %

%% Start the code
load_prepared_data   % Load the prepared spike / No spikes data

%% Normalize the data
Xn=normalize_0_1(data);
%% SCSA feature based 
gm=0.5; fs=1;
h=2*max(max(Xn));

[F_SCSA_h1, S_SCSA_h1, B_SCSA_h1, P_SCSA_h1,AF_SCSA_h1]=SCSA_Transform_features(Xn,h,gm,fs);

%% Cross validation 
K=5;
[accuracy,Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score]=K_Fold_CrossValidation(X, y, K, 'LR')

fprintf('The End \n\n')


