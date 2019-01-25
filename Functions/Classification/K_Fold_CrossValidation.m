%% K-Folds Cross validation using different classifiers
% type_clf: the classifier { 'LR', 'SVM' }
function [accuracy,Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score]=K_Fold_CrossValidation(X, y, K,type_clf)

% fprintf('------------------------------------------------------------------\n')
% fprintf('            The %d Cross validation using %s           \n',K,type_clf )
% fprintf('------------------------------------------------------------------\n')

C = cvpartition(y, 'KFold',K);

for num_fold = 1:C.NumTestSets
    trIdx = C.training(num_fold);
    teIdx = C.test(num_fold);
    
    X_train= X(trIdx,:);              y_train= y(trIdx);
    X_test = X(teIdx,:);              y_test = y(teIdx);
    
   [Mdl,accuracy(num_fold),sensitivity(num_fold),specificity(num_fold),precision(num_fold),gmean(num_fold),f1score(num_fold),ytrue,yfit]= Classify_Data(type_clf, X_train, y_train, X_test, y_test);


end
 
Avg_Accuracy = sum(accuracy)/C.NumTestSets;
Avg_sensitivity = sum(sensitivity)/C.NumTestSets;
Avg_specificity = sum(specificity)/C.NumTestSets;
Avg_precision = sum(precision)/C.NumTestSets;
Avg_f1score = sum(f1score)/C.NumTestSets;
Avg_gmean = sum(gmean)/C.NumTestSets;

accuracy;
Avg_Accuracy;

function [accuracy,sensitivity,specificity,precision,gmean,f1score,C]=prediction_performance(ytrue, yfit)

C=confusionmat(ytrue, yfit);

sensitivity = C(2,2)/(C(1,2)+C(2,2))*100;
specificity = C(1,1)/(C(1,1)+C(2,1))*100;
precision = (C(2,2)/(C(2,2)+C(2,1)))*100;
accuracy= (C(1,1)+C(2,2))/(C(1,1)+C(1,2)+C(2,1)+C(2,2))*100;
gmean = (sqrt(sensitivity*specificity));
f1score = (2*((precision*sensitivity)/(precision+sensitivity)));


