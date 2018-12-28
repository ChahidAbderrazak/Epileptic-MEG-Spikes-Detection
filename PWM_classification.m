
%% ###############  MEG with PWM based  Feature Generation   ############################
% This script uses PWM based features  

% Important: the input data are stored in "./Input_data/DSP_features/*.mat' files  containning:
% [X: MEG electrodes with/without Spikes ] 
% [y : MEG electrodesl class ]     
 
%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Nov,  2018
%  
clear all;  close all ;format shortG;  addpath ./Functions ;Include_function ;%log_html_file
global y h filename Normalization root_folder  Levels

root_folder='./Feature_Selection/PWM_based_Features/';

%% ###########################################################################
type_clf='SVM';% 'LR';%   
K=5;                     % K-folds CV 

% -------------------------------------------------------------------------------
% Load Extracted features from MEG
Load_saved_data

   
%% Generate the PWM based features  
Levels=10;
feature_type='PWM_';
if exist(root_folder)~=7, mkdir(root_folder);end 


%% Run the K-Cross Validation
% Raw data
[accuracy,Avg_accuracy, sensitivity, specificity, precision, gmean, f1score0]=K_Fold_CrossValidation(X, y, K, type_clf);

% PWM features
[accuracy,Avg_accuracy, sensitivity, specificity, precision, gmean, f1score0]=K_Fold_CrossValidation_for_PWM(X, y, K, type_clf);



 fprintf('The End \n\n')

