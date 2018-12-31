 
%% ###############   Epileptic Spikes Detection 2019  ############################
% This script detects epileptic spikes bases onsignal processing methods

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Dec,  2018
%
%% ###########################################################################



clear all;  close all ;format shortG;  addpath ./Functions ;Include_function ;%log_html_file
global Normalization y h filename  root_folder 

%% load  MEG data  
    % Load_saved_data
     Extracted_MEG_Samples

%% For test purpose, use small data set by rndom sampling
%     X=[Xsp;Xsp0];
%     y=[ones(size(Xsp,1),1); zeros(size(Xsp,1),1) ];
%      random_sampling_X
    
 
   
%% Cross Validation parameters
Classification_Parameters

 %% Feature generation  & Classification
%     % Raw Data
%         Raw_Data_classification;
%         
%     % SCSA
%         SCSA_classification;
 
      
    % PWM
        PWM_Classification;
 
 
 