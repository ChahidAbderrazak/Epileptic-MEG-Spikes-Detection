%% ###############   Epileptic Spikes Detection 2019  ############################
% This script applies classification using extacted raw data

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Dec,  2018
%
%% ###########################################################################

feature_type='Raw_Data_';

%% #########################   Display   ################################
fprintf('\n --> Run CV  classification using : ');
d_data0=string(strcat(feature_type(1:end-1),'-based Features'));
fprintf(' %s\n ',d_data0);

%% ###################################################################

%  [Accuracy,Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC]=Data_CrossValidation(X, y,CV_type, K,type_clf);
% X2=
 [Accuracy,Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC]=Data_CrossValidation(X, y,CV_type, K,type_clf);

 %% save the optimal combinaision
Acc_op=Avg_Accuracy
save(strcat('./Classification_results/',feature_type,noisy_file,suff,'_norm',num2str(Normalization),'_',CV_type,'_',type_clf,'_Acc',num2str(Acc_op),'.mat'),'CV_type','type_clf',...
                                     'Accuracy','Avg_Accuracy','Avg_sensitivity','Avg_specificity','Avg_precision','Avg_gmean','Avg_f1score','Avg_AUC',...
                                     'X','y','L_max','suff','filename','noisy_file')
                                 

                                 
%% {'Vector_Size','Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score'};
CV_results_op=[size(X,2), Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC];
 
%% {'Dataset','Configuration','size','L','step','Method','parameters','CV','K','Classifier'}
 CV_config_op={noisy_file,num2str(Conf_Elctr), num2str(size(X,1)),num2str(L_max),num2str(Frame_Step),feature_type(1:end-1), '--',CV_type,num2str(K),type_clf };
 

                                 
%% Get the best results of PWM8
   colnames_results={'Vector_Size','Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score','AUC'};
   Comp_performance_Table= array2table(CV_results_op, 'VariableNames',colnames_results);
    
  
   colnames_results={'Dataset','Configuration','size','L','step','Method','parameters','CV','K','Classifier'};
   Comp_config_Table= array2table(CV_config_op, 'VariableNames',colnames_results);
    
   % Add the optimal parameters
   Comp_results_Table=[Comp_results_Table; [Comp_config_Table ,Comp_performance_Table]];
   
% % {'Vector_Size','Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score'};
% CV_results_op=[sz_fPWM, Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score];
% 
% %{'Dataset','Configuration','size','L','step','Method','parameters','CV','K','Classifier'}
% CV_config_op={noisy_file,num2str(Conf_Elctr), num2str(size(X,1)),num2str(L_max),num2str(Frame_Step),feature_type(1:end-1), strcat('M=',num2str(M),', k=',num2str(k)),CV_type,num2str(K),type_clf };
 