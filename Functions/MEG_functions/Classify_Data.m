function [Mdl,accuracy,sensitivity,specificity,precision,gmean,f1score,ytrue,yfit]= Classify_Data(type_clf, X_train, y_train, X_test, y_test)


switch type_clf
    case 'LR' 
        [Mdl,accuracy,sensitivity,specificity,precision,gmean,f1score,ytrue,yfit]= LR_classifier(X_train, y_train, X_test, y_test);

    case 'SVM'
        [Mdl,accuracy,sensitivity,specificity,precision,gmean,f1score,ytrue,yfit]= SVM_classifier(X_train, y_train, X_test, y_test);

      otherwise
        
        warning(strcat('The chosen classifier:',type_clf,' is not available.'));
       
end
  


   



function [Mdl,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,ytrue,yfit]=LR_classifier(X_train, y_train, X_test, y_test)
    Combine_TR=[X_train, y_train];
    Combine_TS=[X_test, y_test];

% %%% ####################################### 
[M,N]=size(Combine_TR);
training_set= array2table(NO_T(Combine_TR));
training_set.class = Combine_TR(:,end);

 
[M_TS,N_TS]=size(Combine_TS);
testing_set = array2table(NO_T(Combine_TS));
testing_set.class = Combine_TS(:,end);

%% Model training
Mdl= fitglm(training_set,'linear','Distribution','binomial','link', 'logit');


%% Model_testing 

% yfit=trainedClassifier.predictFcn(testing_set);
yfit0 = Mdl.predict(testing_set);
yfit0=yfit0-min(yfit0);yfit0=yfit0/max(yfit0);
yfit=double(yfit0>0.5);

%% Compute the accuracy
[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(testing_set.class, yfit);

ytrue=Combine_TS(:,end);


function [CompactSVMModel,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,y_test,yfit]= SVM_classifier(X_train, y_train, X_test, y_test)
CVSVMModel = fitcsvm(X_train,y_train,'Holdout',0.1);
CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
[yfit,score] = predict(CompactSVMModel,X_test);
[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(y_test , yfit);




function A=NO_T(B)
[M,N]=size(B);
Mh=M/2;
A=B(:,1:end-1); 
