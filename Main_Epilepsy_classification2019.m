 
%% ###############   Epileptic Spikes Detection 2019  ############################
% This script detects epileptic spikes bases onsignal processing methods

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Dec,  2018
%
%% ###########################################################################
warning('off');
clear all;  close all ;format shortG;  addpath ./Functions ;Include_function ;%log_html_file
global y h filename  root_folder 

%% load  MEG data  
%     Extracted_MEG_Samples
%     Combine_patients_datasets
    Load_saved_data
% noisy_file=Fuse_strings(unique(noisy_file));

%% Cross Validation parameters
global Normalization
K=5;
type_clf= 'LR';%'SVM';% 
CV_type='KFold';%  'LOO';%                                   strcat(num2str(K),'-Folds_CV');%   


%% ###########################################################################
beta=0;EN_starplus=0;

if exist('Comp_results_Table','var') == 0 , Comp_results_Table = table;  end                   % Table to save results

for Normalization=0%0:1;
   
    
    %% Feature generation  & Classification
        Classification_Parameters
        
%% ###  Raw Data-based Classification
    tic
        Raw_Data_classification;
    Time_raw=toc                   

%% ### PWM-based Classification
    list_M=2*[2:5];
%     list_k=[0.05:0.05:0.5]; 
    
    
%    %% PWM-based features
%     tic
%         PWM2_Classification;
%     Time_PWM2=toc

    %% PWM8-based features
    tic
        PWM8_Classification;
    Time_PWM8=toc

%% ###  SCSA-based Classification
    tic
        SCSA_classification;
    Time_SCSA=toc                   
    
end
 
fprintf('\n################  The End ################\n\n')
