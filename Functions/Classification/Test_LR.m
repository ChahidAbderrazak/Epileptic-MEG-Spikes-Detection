function yfit=Test_LR(Mdl,X_test)

% yfit=trainedClassifier.predictFcn(testing_set);
yfit0 = Mdl.predict(X_test);
yfit0=yfit0-min(yfit0);yfit0=yfit0/max(yfit0);
yfit=double(yfit0>0.5);





