
%% ###############   Epileptic Spikes Detection 2019 All DATA  ############################
% This script detects epileptic spikes bases on signal processing methods

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Dec,  2018
%
%% ###########################################################################

clc;clear all;  close all ;warning('off');format shortG;  addpath ./Functions ;Include_function ;%log_html_file
global y h filename  root_folder  L  y_PatientID

%data_Source='R:\chahida\Projects-Dataset\KFMC\Extracted_data\Healthy-Patient';
data_Source0='./Input_data/MEG_Epy_KSU/';%Old_Patients';%Patients';%

Path_classification='./Result-JBHI2-2019/';
project_folder=pwd;project_folder = strsplit(project_folder,'\'); 
Path_classification=char(strcat('./Results/',char(project_folder(end)),Path_classification));

%% ###########################################################################
if exist(Path_classification)~=7, mkdir(Path_classification); end


Comp_results_aLL = table;                     % Table to save results

%% Start the Loop
for L= 90%[80 90  100 110]
    
    data_Source=data_Source0;
    List_Data_files = dir(strcat(data_Source,'/*L',num2str(L),'*Step2.mat'));
    if size(List_Data_files,1)==0 , continue;end
    %% Cross Validation parameters
    global Normalization  type_clf feature_type 
    K=5;
    CV_type_list=string({'Patient_LOOCV'});%string({'KFold'});%string({'KFold','Patient_LOOCV'});% })%
%     max_TR_samples_per_class=1000;
    type_clf_list=string({'LR'});%, 'SVM'});%
    
    for file_k=1:size(List_Data_files,1)%-1%:-1:2
         
        file_k
        filename=List_Data_files(file_k).name
        file_Source=List_Data_files(file_k).folder;
        cname=strcat(file_Source,'\', filename);   
        load(cname); y_PatientID=Patient_Spk;

        for patient_k=-1%[-1  1:max(size(unique(y_PatientID))) ]% 
%             
            if patient_k==-1, patient_k=[1:max(size(unique(y_PatientID)))];end
            % load dataset
            load(cname); 

            %% For classification purpose as the data is higly unblanced, we tried to ballance the data randomly per subject
             if  strcmp(CV_type,'KFold')==1
                 Balance_sample_per_subject_randomely
             end
            
            X0=X_blcd;y0=y_blcd; y_PatientID0=y_patient_blcd;
            
            for CV_type=CV_type_list
                for type_clf= type_clf_list
                    global Negative_sample_ratio_TS Negative_sample_ratio_TR

                    for Negative_sample_ratio_TS=-1%[1  -1];
                        for Negative_sample_ratio_TR=-1%[1  3];

                            %% Apply this script on the current data file
                             Main_Epilepsy_classification2019

                            %% Save partially Obtained results 
                            Comp_results_Table
            %                 Comp_results_aLL=[Comp_results_aLL;Comp_results_Table];
                %             save(strcat(Path_classification,'Comp_',noisy_file,CV_type,'_',type_clf,'_On',string(datetime('now','Format','yyyy-MM-dd''T''HHmmss')),'.mat'),...
            %                                                'Comp_results_Table','noisy_file','data_Source','cname')     
                        end
                    end
                end
            end

        end
    end


    %% Save Obtained results on all the dataset
    filename_results=strcat(Path_classification,num2str(size(List_Data_files,1)),'_Dataset_',FFT_specter,join(CV_type_list),'_',join(type_clf_list),'_On',string(datetime('now','Format','yyyy-MM-dd''T''HHmmss')))
    save(strcat(filename_results,'.mat'),'Comp_results_aLL','List_Data_files','data_Source','Comp_results_Table')                                                                                                                    
    % Excel sheet
    writetable(Comp_results_Table,strcat(filename_results,'.xlsx'))
end

winopen(Path_classification)
fprintf('\n################  The End ################\n\n')
                                   
                                   
