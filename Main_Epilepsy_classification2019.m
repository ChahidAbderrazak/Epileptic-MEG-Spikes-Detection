   
%% ###############   Epileptic Spikes Detection 2019  ############################
% This script detects epileptic spikes bases onsignal processing methods

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Dec,  2018
%
%% ###########################################################################
warning('off');
% clear all;  close all ;format shortG;  addpath ./Functions ;Include_function ;%log_html_file
global y h filename  root_folder 

%% load  MEG data  
%     Extracted_MEG_Samples
%     Combine_patients_datasets
%     Load_saved_data
% noisy_file=Fuse_strings(unique(noisy_file));
 
% %% Cross Validation parameters
% global Normalization  type_clf feature_type 
% K=5;
% type_clf= 'LR';% 'SVM';%
% CV_type='KFold';%'Patient_LOOCV';%  'LOO';%                                   strcat(num2str(K),'-Folds_CV');%   
% 



%% ###########################################################################
beta=0;EN_starplus=0;

if exist('Comp_results_Table','var') == 0 , Comp_results_Table = table;  end                   % Table to save results

for EN_FFT=1
    for Normalization=0
        
        %  get the dataset  for classification
        X=X0;y=y0; y_PatientID=y_PatientID0;
        global y_patient
        y_patient=y_PatientID;     
    
        % Feature generation  & Classification
            Classification_Parameters

    % %% ###  Raw Data-based Classification
    %     tic
    %         Raw_Data_classification;
    %     Time_raw=toc                   

    %% ### PWM-based Classification 
         list_M=2*[3:5];%2*[3];%
         list_k=[0.2:0.2:1.2]; %[0.1:0.05:0.35];%0.33;%

       %% PWM-based features
        tic
            PWM2_Classification;
        Time_PWM2=toc

        %% PWM8-based features


        tic
            PWM8_Classification;
        Time_PWM8=toc

    % ###  SCSA-based Classification
    %     tic
    %         SCSA_classification;
    %     Time_SCSA=toc                   
    

    end
end
 
fprintf('\n################  Data classification Round is done  ################\n\n')
