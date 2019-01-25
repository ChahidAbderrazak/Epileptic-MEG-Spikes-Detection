function [accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]= LR_classification(X_train, y_train, X_test, y_test)
training_set= array2table( X_train);
training_set.class = y_train;


testing_set = array2table(X_test);
testing_set.class =y_test;

%% Model training
Mdl= fitglm(training_set,'linear','Distribution','binomial','link', 'logit');

%% Model_testing 

% yfit=trainedClassifier.predictFcn(testing_set);
yfit0 = Mdl.predict(testing_set);
yfit0=yfit0-min(yfit0);yfit0=yfit0/max(yfit0);
yfit=double(yfit0>0.5);

%% Compute the accuracy
[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(testing_set.class, yfit);



CVSVMModel = fitcsvm(X_train,y_train,'Holdout',0.15,'Standardize',true);
CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
[yfit,score] = predict(CompactSVMModel,X_test);
[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(y_test , yfit);



function [accuracy,sensitivity,specificity,precision,gmean,f1score,C]=prediction_performance(ytrue, yfit)

C=confusionmat(ytrue, yfit);

sensitivity = C(2,2)/(C(1,2)+C(2,2))*100;
specificity = C(1,1)/(C(1,1)+C(2,1))*100;
precision = (C(2,2)/(C(2,2)+C(2,1)))*100;
accuracy= (C(1,1)+C(2,2))/(C(1,1)+C(1,2)+C(2,1)+C(2,2))*100
gmean = (sqrt(sensitivity*specificity));
f1score = (2*((precision*sensitivity)/(precision+sensitivity)));
