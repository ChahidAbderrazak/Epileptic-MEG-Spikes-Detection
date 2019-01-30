
%% ###############   Epileptic Spikes Detection 2019 All DATA  ############################
% This script detects epileptic spikes bases on signal processing methods

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Dec,  2018
%
%% ###########################################################################

clc;clear all;  close all ;warning('off');format shortG;  addpath ./Functions ;Include_function ;%log_html_file
global y h filename  root_folder 
Comp_results_aLL = table;                     % Table to save results

data_Source='./Input_data/Extracted_separate_subj/';

List_Data_files = dir(strcat(data_Source,'**/*L70*.mat'));

for file_k=size(List_Data_files,1)-1%:-1:2
    file_k
    filename=List_Data_files(file_k).name;
    data_Source=List_Data_files(file_k).folder;
    cname=strcat(data_Source,'\', filename);   
    load(cname); 

    %% Apply this script on the current data file
     Main_Epilepsy_classification2019
     
%% Save partially Obtained results 
Comp_results_aLL=[Comp_results_aLL;Comp_results_Table];
save(strcat('./Classification_results/Comparison/',noisy_file,CV_type,'_',type_clf,'_On',string(datetime('now','Format','yyyy-MM-dd''T''HHmmss')),'.mat'),...
                                       'Comp_results_Table','noisy_file','data_Source','cname')                                                                                                                    
                                                                     
end


%% Save Obtained results on all the dataset

save(strcat('./Classification_results/Comparison/',num2str(size(List_Data_files,1)),'_Dataset_',CV_type,'_',type_clf,'_On',string(datetime('now','Format','yyyy-MM-dd''T''HHmmss')),'.mat'),...
                                       'Comp_results_aLL','List_Data_files','data_Source')                                                                                                                    

fprintf('\n################  The End ################\n\n')
                                   
                                   
