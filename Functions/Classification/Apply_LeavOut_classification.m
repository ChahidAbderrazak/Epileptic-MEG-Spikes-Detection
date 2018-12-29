%% Apply Leave One Out CV usinf diffferent classifers
% X: The data  sample
% y  The Class
% clf: The calssifier:{'nbayes','logisticRegression','SVM','','',''}

function [Avg_acc]= Apply_LeavOut_classification(X, y,clf)


C = cvpartition(y, 'LeaveOut');
err = zeros(C.NumTestSets,1);
for i = 1:C.NumTestSets
    trIdx = C.training(i);
    teIdx = C.test(i);
    [classifier] = trainClassifier(X(trIdx,:),y(trIdx), 'nbayes');   %train classifier
    [y_predicted] = applyClassifier(X(teIdx,:), classifier);       %test it
    [result,predictedLabels,trace] = summarizePredictions(y_predicted,classifier,'averageRank',y(teIdx));
    err(i)= 1-result{1};  % rank accuracy
end

Avg_acc= sum(err)/sum(C.TestSize);