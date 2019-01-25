%% K-Folds Cross validation using different classifiers
% type_clf: the classifier { 'LR', 'SVM' }
function [Accuracy,Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC]=Data_CrossValidation(X, y,CV_type, K,type_clf)

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


for num_fold = 1:C.NumTestSets
    trIdx = C.training(num_fold);
    teIdx = C.test(num_fold);
    
    
    X_train= X(trIdx,:);              y_train= y(trIdx);
    X_test = X(teIdx,:);              y_test = y(teIdx);
    
   
    %% Get the positive and negative training samples to build PWM matrices
    Xp=X_train(y_train==1,:);   Np=size(Xp, 1);
    Xn=X_train(y_train==0,:);   Nn=size(Xn, 1); 
    
        if abs(Np-Nn)>1
            fprintf('Non balanced testing data\n\n')
            CV_Status=No_blanced; 

        end

        [Mdl,Accuracy(num_fold),sensitivity(num_fold),specificity(num_fold),precision(num_fold),gmean(num_fold),f1score(num_fold),AUC(num_fold),ytrue,yfit]=Classify_Data(type_clf, X_train, y_train, X_test, y_test);
 
end
 
Avg_Accuracy = sum(Accuracy)/C.NumTestSets;
Avg_sensitivity = sum(sensitivity)/C.NumTestSets;
Avg_specificity = sum(specificity)/C.NumTestSets;
Avg_precision = sum(precision)/C.NumTestSets;
Avg_f1score = sum(f1score)/C.NumTestSets;
Avg_gmean = sum(gmean)/C.NumTestSets;
Avg_AUC= sum(AUC)/C.NumTestSets;

Accuracy;
Avg_Accuracy;




