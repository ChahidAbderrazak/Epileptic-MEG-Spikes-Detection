%% this script performs a classification using the scripts and models developped by StarPlus:
% http://www.cs.cmu.edu/afs/cs.cmu.edu/project/theo-81/www/
% Questions or comments: email Tom.Mitchell@cmu.edu or Wei.Wang@cs.cmu.edu
% Readme.txt is avaialbe here: http://www.cs.cmu.edu/afs/cs.cmu.edu/project/theo-81/www/README-software-documentation.txt

function  [Mdl,Accuracy,sensitivity,specificity,precision,gmean,f1score,y_test,y_predicted]=StartPlus_Classify_Data(type_clf, X_train, y_train, X_test, y_test)

%% StarPLus needs non-zero lablels. We need to  change lables     to [10 11]

TrainLabels=y_train +10;
TestLabels=y_test +10;

if strcmp(type_clf,'LR')==1
    
    type_clf='logisticRegression';
end

       %% Train and test the model
    [Mdl] = trainClassifier(X_train,TrainLabels, type_clf);   %train classifier

    %% Test the model
    [scores] = applyClassifier(X_test, Mdl);       %test it
    [result1,predictedLabels,trace1] = summarizePredictions(scores,Mdl,'averageRank',TestLabels);
%     Accuracy= 1-result1{1};  % rank accuracy

    [Accuracy,sensitivity,specificity,precision,gmean,f1score]=prediction_performance(TestLabels, predictedLabels);

    %% restore back labels between [0 1]
    y_predicted=predictedLabels-10;