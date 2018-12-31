A=magic(4);
A=A(:,1:2)
SK_features=sum(A'.^2)'


Levels=10

%% Run the K-Cross Validation
[accuracy,Avg_accuracy, sensitivity, specificity, precision, gmean, f1score0]=K_Fold_CrossValidation_for_PWM(X, y, K, type_clf);


% % type_clf='SVM';% 'LR';% 
% % K=5;                     % K-folds CV 
% % 
% % X=SFP_SCSA_h1;
% % 
% % %% Cross valiadtion of the row data 
% % [accuracy,Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score]=K_Fold_CrossValidation(X, y, K, type_clf);
% % Load_saved_data
% % X=Scale_down_to_unit(X);
% % 
% % N=size(X,1);
% % [Xp,Xn]=Split_classes_Data(X,y) ;
% % filename2 = strrep(filename,'_','__');
% % figure;  
% % histogram(Xp); hold on
% % histogram(Xn); hold on
% % title(strcat('Samples values distribution for N=',num2str(N),' , data:',filename2))
% %  
% % 
% % % % Run the K-Cross Validation
% % % % Raw data
% % % [accuracy,Avg_accuracy, sensitivity, specificity, precision, gmean, f1score0]=K_Fold_CrossValidation(X, y, K, type_clf);
% % % 
% % % % PWM features
% % % [accuracy,Avg_accuracy, sensitivity, specificity, precision, gmean, f1score0]=K_Fold_CrossValidation_for_PWM(X, y, K, type_clf);
% % % 

