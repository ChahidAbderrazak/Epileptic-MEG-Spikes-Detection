
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

data_Source='./Input_data/Extracted_separate_subj/';
Path_classification='/Classification_result/';
project_folder=pwd;project_folder = strsplit(project_folder,'\'); 
Path_classification=char(strcat('R:/chahida/Projects-Results/',char(project_folder(end)),Path_classification));

%% ###########################################################################
if exist(Path_classification)~=7, mkdir(Path_classification); end

List_Data_files = dir(strcat(data_Source,'**/*L100*.mat'));

Comp_results_aLL = table;                     % Table to save results

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
save(strcat(Path_classification,'Comp_',noisy_file,CV_type,'_',type_clf,'_On',string(datetime('now','Format','yyyy-MM-dd''T''HHmmss')),'.mat'),...
                                       'Comp_results_Table','noisy_file','data_Source','cname')                                                                                                                    
                                                                     
end


%% Save Obtained results on all the dataset

save(strcat(Path_classification,num2str(size(List_Data_files,1)),'_Dataset_',CV_type,'_',type_clf,'_On',string(datetime('now','Format','yyyy-MM-dd''T''HHmmss')),'.mat'),...
                                       'Comp_results_aLL','List_Data_files','data_Source')                                                                                                                    

fprintf('\n################  The End ################\n\n')
                                   
                                   
