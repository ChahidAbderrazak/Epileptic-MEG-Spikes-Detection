 %% Apply Leave One Out CV with PWM features using diffferent classifers
% X: The data  sample
% y  The Class
% clf: The calssifier:{'nbayes','logisticRegression','SVM','','',''}
% function [accuracy1,sz_fPWM]= Classify_LeaveOut_PWM(X,y,clf)
function [sz_fPWM, Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC]=PWM8_Data_CrossValidation_LOPO(max_TR_samples_per_class, X, y,CV_type, K,type_clf)

global Levels Level_intervals 
if strcmp(CV_type,'Patient_LOOCV')==1
    global y_patient Negative_sample_ratio_TS Negative_sample_ratio_TR  L y_PatientID

    LOOCV=1;                        %Leave One Patient Out Cross Validation
    Patients=unique(y_patient); NB_patient=max(size(Patients));
    fprintf('------------------------------------------------------------------\n')
    fprintf('            Leave One/ Patient Out Cross Validation ( %s)           \n',type_clf )
    fprintf('------------------------------------------------------------------\n')
    Nb_folds=NB_patient-1;
    k=1;

else
    fprintf('\n --> Error: undefined Cross-Validation : %s',CV_type);
    error=dom

end
Bi_classes=  unique(y);

for num_fold = 1:Nb_folds
    clearvars  PWM_* XP Xn 
        %% get One patient un/balanced testing set fold 
        teIdx = find(y_patient==Patients(num_fold));
        
        %% get a un/balanced training set from the other patients
        trIdx = find(y_patient~=Patients(num_fold));
        
        if Negative_sample_ratio_TR~=-1
            trIdx_n = find(y_patient~=Patients(num_fold)& y==Bi_classes(1));    Nn=max(size(trIdx_n));
            trIdx_p = find(y_patient~=Patients(num_fold)& y==Bi_classes(2));    Np=max(size(trIdx_p));
            s = RandStream('mlfg6331_64'); Rndm_idxn=randsample(s,Nn,Nn,false);
            s = RandStream('mlfg6331_64'); Rndm_idxp=randsample(s,Np,Np,false);
            
            N=min(Np,Nn);
            if min(Np,Nn)> max_TR_samples_per_class
                N=max_TR_samples_per_class;
            end
            
            trIdx_n_random=trIdx_n(Rndm_idxn(1:Negative_sample_ratio_TR*N));
            trIdx_p_random=trIdx_p(Rndm_idxp(1:N));
            trIdx= [ trIdx_p_random ; trIdx_n_random];   %y(trIdx)            
        end
        
    Idx= find(teIdx);

    %% Get the fold training and tesing samples

    X_train= X(trIdx,:);                                                     X_test= X(teIdx,:); 
    y_train= y(trIdx);                                                       y_test= y(teIdx);
    
    
    %% Get the positive and negative training samples to build PWM matrices
    Xp=X_train(y_train==1,:);   Np=size(Xp, 1);
    Xn=X_train(y_train==0,:);   Nn=size(Xn, 1);
%     if abs(Np-Nn)>2
%         fprintf('Non balanced testing data\n\n')
%         CV_Status=No_blanced; 
% 
%     end
   %% Get the  QuPWM features
    script_get_QuPWM_features_for_train_test_split

    [Mdl,Accuracy(num_fold),sensitivity(num_fold),specificity(num_fold),precision(num_fold),gmean(num_fold),f1score(num_fold),AUC(num_fold),ytrue,yfit,score]...
    =Classify_Data(type_clf, fPWM_train, y_train, fPWM_test, y_test);

     Mdl_SVM_mPWM=Mdl;
     
%     Accuracy(num_fold)
%         CV_results_op=[Accuracy(num_fold),sensitivity(num_fold),specificity(num_fold),precision(num_fold),gmean(num_fold),f1score(num_fold),AUC(num_fold)];
%         Fold_results= array2table(CV_results_op, 'VariableNames',{'Accuracy','Sensitivity','Specificity','Precision','Gmean','F1score','AUC'})

%     break;
subjects_names=join(unique(y_PatientID));
 save(strcat('./python/LOPO_dataset_MEG',subjects_names,'L',num2str(L),'_fold',num2str(num_fold),'.mat'),'fPWM_train', 'y_train', 'fPWM_test', 'y_test','Accuracy')
end

%% Average Accuracy 
Avg_Accuracy = mean(Accuracy);%/C.NumTestSets;
Avg_sensitivity = mean(sensitivity);%/C.NumTestSets;
Avg_specificity = mean(specificity);%/C.NumTestSets;
Avg_precision = mean(precision);%/C.NumTestSets;
Avg_f1score = mean(f1score);%/C.NumTestSets;
Avg_gmean = mean(gmean);%/C.NumTestSets;
Avg_AUC = mean(AUC);%/C.NumTestSets;

Accuracy;
Avg_Accuracy;
sz_fPWM=size(fPWM_train,2);



end

%% Funtions
