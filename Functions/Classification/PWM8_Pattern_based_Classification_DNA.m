%% ######################### Features Generation ##########################
 % Authors:  
    % Abderrazak Chahid : abderrazak.chahid@kaust.edu.sa 
    % Fahad Albalawi:     fahad.albalawi@kaust.edu.sa 

    % Xingang Guo:        xingang.guo@kaust.edu.sa  
 % Advicor : 
   % Professor Taous_Meriem Laleg . EMANGroup KAUST  Email: taousmeriem.laleg@kaust.edu.sa 
   
% Done: Jan, 2019

 
 %% Description
% This script generates SPWM based features  and 
%% ###############################################################################

% clear all;close all;warning('off','all');addpath ./Functions; Include_function;

% fprintf('______________________________________________________________________________\n');
% fprintf('    CLassification using Pattern-based PWM Feature Generation  (KAUST 2019)    \n');
% fprintf('______________________________________________________________________________\n\n');


    
%% ##################  Features Generation   ##################
 
    [TR_Seq_pos,TR_Seq_neg,yptr,yntr]=Split_Features_Pos_Neg(X_train,y_train);
    [TS_Seq_pos,TS_Seq_neg,ypts,ynts]=Split_Features_Pos_Neg(X_test,y_test);

  

%      random_sampling_X
    


    %% Mono-Mers  Position Weight Matrix-BASED FEATURES
     % Build the PWMs from the Training   
    [Mer1_Seq_TR, name_Mer1, Mer1_Seq_pos_TR, Mer1_Seq_neg_TR] = Extract_Miers1(TR_Seq_pos, TR_Seq_neg); 
    [PWMp_Mer1,PWMn_Mer1] = General_PWM_matrices_generatures3D(Mer1_Seq_pos_TR,Mer1_Seq_neg_TR);

     % Generate the features based n the Built   PWMs  
    Mer1_PWM_features_TR = Apply_General_PWM_feature_generator(Mer1_Seq_TR, PWMp_Mer1, PWMn_Mer1);

    [Mer1_Seq_TS,name_Mer1, Mer1_Seq_pos_TS, Mer1_Seq_neg_TS] = Extract_Miers1(TS_Seq_pos, TS_Seq_neg);
    Mer1_PWM_features_TS = Apply_General_PWM_feature_generator(Mer1_Seq_TS, PWMp_Mer1, PWMn_Mer1); 


    %% Di-Mers  Position Weight Matrix-BASED FEATURES
     % Build the PWMs from the Training   
    [Mer2_Seq_TR, name_Mer2, Mer2_Seq_pos_TR, Mer2_Seq_neg_TR] = Extract_Miers2(TR_Seq_pos, TR_Seq_neg);
    [PWMp_Mer2,PWMn_Mer2] = General_PWM_matrices_generatures3D(Mer2_Seq_pos_TR,Mer2_Seq_neg_TR);

     % Generate the features based n the Built   PWMs  
    Mer2_PWM_features_TR = Apply_General_PWM_feature_generator(Mer2_Seq_TR, PWMp_Mer2, PWMn_Mer2);

    [Mer2_Seq_TS,name_Mer2, Mer2_Seq_pos_TS, Mer2_Seq_neg_TS] = Extract_Miers2(TS_Seq_pos, TS_Seq_neg);
    Mer2_PWM_features_TS = Apply_General_PWM_feature_generator(Mer2_Seq_TS, PWMp_Mer2, PWMn_Mer2); 

    %% 3-Mers Position Weight Matrix-BASED FEATURES
     % Build the PWMs from the Training   
    [Mer3_Seq_TR, name_Mer3, Mer3_Seq_pos_TR, Mer3_Seq_neg_TR] = Extract_Miers3(TR_Seq_pos, TR_Seq_neg);
    [PWMp_Mer3,PWMn_Mer3] = General_PWM_matrices_generatures3D(Mer3_Seq_pos_TR,Mer3_Seq_neg_TR);

     % Generate the features based n the Built   PWMs  
    Mer3_PWM_features_TR = Apply_General_PWM_feature_generator(Mer3_Seq_TR, PWMp_Mer3, PWMn_Mer3);

    [Mer3_Seq_TS, name_Mer3, Mer3_Seq_pos_TS, Mer3_Seq_neg_TS] = Extract_Miers3(TS_Seq_pos, TS_Seq_neg);
    Mer3_PWM_features_TS = Apply_General_PWM_feature_generator(Mer3_Seq_TS, PWMp_Mer3, PWMn_Mer3); 

%% Features destination
 root_folder='./Features/';
if exist(root_folder) == 0, mkdir(root_folder); end  
                
% saving the features
save(strcat(root_folder,'PWM_based_Features.mat'),'Mer*','PWM*','*_TS','*_TR')
fprintf('--> K-Mers PWM based features are generated\n'); 
  
%% Concatenate all  PWM  Features 
    
% Training
Mp= size(TR_Seq_pos,1);  Mn= size(TR_Seq_neg,1); 
y_train = [ones([Mp,1]);zeros([Mn,1])];
X_train =  [ Mer1_PWM_features_TR, Mer2_PWM_features_TR, Mer3_PWM_features_TR];

% Testing
Mp= size(TS_Seq_pos,1);  Mn= size(TS_Seq_neg,1); 
y_test = [ones([Mp,1]);zeros([Mn,1])];
X_test =  [ Mer1_PWM_features_TS, Mer2_PWM_features_TS,  Mer3_PWM_features_TS];

  
%% #########################  Cross Validation   ##############################################

%% Run the k-fold Cross Validation Stage
[Mdl_optimal,Max_Accuracy, CV_results, Avg_Accuracy] = Run_Cross_Validation_of_features(K,X_train,y_train);
           
%% TESTING The Optimal Model Obtained from 10-fold cross validation 
y_predicted=Test_LR(Mdl_optimal,X_test);

%% Compute the accuracy
[accuracy_TS,sensitivity_TS,specificity_TS,precision_TS,gmean_TS,f1score_TS,C_TS]=prediction_performance(y_test, y_predicted);
    
size_Train = size(X_train,1);size_Test = size(X_test,1); 
Result_TS = [K, size_Train, size_Test,accuracy_TS,sensitivity_TS,specificity_TS,precision_TS,gmean_TS,f1score_TS];
Result_all=[Result_all;Result_TS];
fprintf('\n Performance : \n');
CV_Result=array2table(Result_all,'VariableNames',{'NbFolds','TrainSize','TestSize','Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score'})


