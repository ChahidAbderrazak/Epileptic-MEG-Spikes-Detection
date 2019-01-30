 %% Apply Leave One Out CV with PWM features using diffferent classifers
% X: The data  sample
% y  The Class
% clf: The calssifier:{'nbayes','logisticRegression','SVM','','',''}
% function [accuracy1,sz_fPWM]= Classify_LeaveOut_PWM(X,y,clf)
function [sz_fPWM, Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC]=PWM_Data_CrossValidation(X, y,CV_type, K,type_clf)

global Levels Level_intervals 


if strcmp(CV_type,'LOO')==1
    C = cvpartition(y, 'LeaveOut');
    
    fprintf('------------------------------------------------------------------\n')
    fprintf('            Leave-One-Out Cross Validation using %s           \n',type_clf )
    fprintf('------------------------------------------------------------------\n')


elseif strcmp(CV_type,'KFold')==1
    C = cvpartition(y, 'KFold',K);
    
    fprintf('------------------------------------------------------------------\n')
    fprintf('            The %d-Folds Cross Validation using %s           \n',K,type_clf )
    fprintf('------------------------------------------------------------------\n')



else
    fprintf('\n --> Error: undefined Cross-Validation : %s',CV_type);

end
Bi_classes=  unique(y);

for num_fold = 1:C.NumTestSets
    clearvars  PWM_* XP Xn
    
    trIdx = C.training(num_fold);                                            teIdx = C.test(num_fold);
    Idx= find(teIdx);
    
    X_train= X(trIdx,:);                                                     X_test= X(teIdx,:); 
    y_train= y(trIdx);                                                       y_test= y(teIdx);
    
    
    %% Get the positive and negative training samples to build PWM matrices
    Xp=X_train(y_train==1,:);   Np=size(Xp, 1);
    Xn=X_train(y_train==0,:);   Nn=size(Xn, 1);
    if abs(Np-Nn)>2
        fprintf('Non balanced testing data\n\n')
        CV_Status=No_blanced; 

    end
    %% Quantization
    Xp= mapping_levels(Xp,Level_intervals, Levels);
    Xn= mapping_levels(Xn,Level_intervals, Levels);

    %% Build the PWM matrices
    PWM_P = Generate_PWM_matrix(Xp, Levels);
    PWM_N = Generate_PWM_matrix(Xn, Levels);    
    
    %% PWM features generation 
    X_train_levels=[Xp;Xn];                                                 X_test_levels= mapping_levels(X_test, Level_intervals, Levels);
    fPWM_train= Generate_PWM_features(X_train_levels, PWM_P, PWM_N);        fPWM_test= Generate_PWM_features(X_test_levels, PWM_P, PWM_N);

   
    %% plot PWM features
%     plot_PWM_features(fPWM_train,fPWM_test,Np)

        [Mdl,Accuracy(num_fold),sensitivity(num_fold),specificity(num_fold),precision(num_fold),gmean(num_fold),f1score(num_fold),AUC(num_fold),ytrue,yfit]=Classify_Data(type_clf, fPWM_train, y_train, fPWM_test, y_test);
      
    
end

%% Average Accuracy 
Avg_Accuracy = sum(Accuracy)/C.NumTestSets;
Avg_sensitivity = sum(sensitivity)/C.NumTestSets;
Avg_specificity = sum(specificity)/C.NumTestSets;
Avg_precision = sum(precision)/C.NumTestSets;
Avg_f1score = sum(f1score)/C.NumTestSets;
Avg_gmean = sum(gmean)/C.NumTestSets;
Avg_AUC=sum(AUC)/C.NumTestSets;
Accuracy;
Avg_Accuracy;
sz_fPWM=size(fPWM_train,2);



end



function PWM_letters()
    N_levels=size(Levels,2);
    % Assign to each level a letter
    Seq_letter=char([65:90 97:122  char(194:194+N_levels-52) ]); N_letters=size(Seq_letter,2); %   or Seq_letter='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'    
    
    for lv=1:N_levels
    Levels_ABC(lv)=Seq_letter(lv)
    
    end
    
    
    %% Convert seignal to levels
    Xp= mapping_levels(Xp,Level_intervals, Levels_ABC);
    Xn= mapping_levels(Xn,Level_intervals, Levels_ABC);
    %% Build the PWM matrices
    PWM_P = Generate_PWM_matrix(Xp, Levels_ABC);
    PWM_N = Generate_PWM_matrix(Xn, Levels_ABC);   
    
    
end


