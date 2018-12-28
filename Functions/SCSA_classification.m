warning('off','all'); clearvars op_combinaison
%% ###############   Feature selection using combinaision  ############################
% This script finds the best combinaison  bases on  SCSA features

% Important: the input data are stored in "./Input_data/DSP_features/*.mat' files  containning:
% [X: MEG electrodes with/without Spikes ] 
% [y : MEG electrodesl class ]     
 
%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Nov,  2018
%  
% clear all;  close all ;format shortG;  addpath ./Functions ;Include_function ;%log_html_file
global h ;clearvars op_combinaison op_comb_name OP_Acc  OP_Acc

% SCSA based features
gm=0.5; fs=1;

%% Find the optimal combination of the features  
feature_TAG={'h1'};        % features TAG to be combined
feature_type='SCSA_';

if exist(root_folder)~=7; mkdir(root_folder);end 

cnt=1;

for h=max(max(X))*0.01*[0.05 0.1:0.1:0.5]%[0.1 0.5 1:3]%[0.5:0.5:5] % [2:0.2:5]%1%2.13%

    %% Find the optimal combination of the features  SCSA  
    [F_SCSA_h1, S_SCSA_h1, B_SCSA_h1, P_SCSA_h1,AF_SCSA_h1,SFP_SCSA_h1]=SCSA_Transform_features(X,h,gm,fs);

    % Save the SCSA features
    data_file=strcat('./Input_data/DSP_features/SCSA_features',num2str(h),'.mat');
%     save(data_file,'F_SCSA_h1', 'S_SCSA_h1', 'B_SCSA_h1', 'P_SCSA_h1', 'AF_SCSA_h1','SFP_SCSA_h1','y');
    save(data_file,'S_SCSA_h1', 'B_SCSA_h1', 'AF_SCSA_h1','y');

    [SCSA_X_op, op_comb, op_comb_name, perform_output,Acc]=Find_the_optimal_feature_combination(data_file,feature_TAG,K, feature_type,type_clf);
    OP_Acc(1,cnt)=h;
    OP_Acc(2,cnt)=Acc(1);
    OP_Acc(3,cnt)=Acc(2);
    op_combinaison(cnt,:)=op_comb
    op_comb_name{cnt}=op_comb_name;
    cnt=cnt+1;
    
    
%     %% Save the resuts mat 
%          results_path= strcat(root_folder, feature_type, '_h' , num2str(h) ,'.mat');
%          save(results_path,'op_comb', 'perform_output','data_file','K','op_comb_name','OP_Acc','filename');

     clearvars op_comb perform_output data_file 

end


 %% save the optimal combinaision
save(strcat('./Classification_results/',feature_type,suff,'_norm',num2str(Normalization),'.mat'),'op_combinaison', 'op_comb_name','K','OP_Acc','accuracy','accuracy_avg','sensitivity_avg','specificity_avg','precision_avg','gmean_avg','f1score_avg',...
                                                             'X','y','L_max','EN_L','EN_b','bmin','bmax','suff',filename)
                                                         
name= strcat(root_folder, feature_type, '_optimal_Comb',filename);
save(name,'op_combinaison', 'op_comb_name','K','OP_Acc');



 fprintf('The End \n\n')
