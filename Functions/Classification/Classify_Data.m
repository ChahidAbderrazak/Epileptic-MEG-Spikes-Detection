function [Mdl,accuracy,sensitivity,specificity,precision,gmean,f1score,AUC,ytrue,yfit,score]= Classify_Data(type_clf, X_train, y_train, X_test, y_test)


switch type_clf
    case 'LR' 
        [Mdl,accuracy,sensitivity,specificity,precision,gmean,f1score,AUC,ytrue,yfit,score]= LR_classifier(X_train, y_train, X_test, y_test);

    case 'SVM'
        [Mdl,accuracy,sensitivity,specificity,precision,gmean,f1score,AUC,ytrue,yfit,score]= SVM_classifier(X_train, y_train, X_test, y_test);

      otherwise
        
        warning(strcat('The chosen classifier:',type_clf,' is not available.'));
       
end
  


   



function [Mdl,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,AUC,ytrue,yfit,score]=LR_classifier(X_train, y_train, X_test, y_test)
global feature_type
    

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
yfit0 = Mdl.predict(testing_set);score=yfit0;
yfit0=yfit0-min(yfit0);yfit0=yfit0/max(yfit0);
yfit=double(yfit0>0.5);

%% Compute the accuracy
[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(testing_set.class, yfit);

ytrue=Combine_TS(:,end);


%% Compute the ROC curve
[X,Y,T,AUC] = perfcurve(y_test ,score,1);
% Plot the ROC curve.
figure;
plot(X,Y)
xlabel('False positive rate') 
ylabel('True positive rate')
title('ROC for Classification by Logistic Regression')
legend(strcat(feature_type(1:end-1), ', AUC=',num2str(AUC),' - LR'))
set(gca,'fontsize',16)
grid on


function [CompactSVMModel,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,AUC,y_test,yfit,score]= SVM_classifier(X_train, y_train, X_test, y_test)
global feature_type
CVSVMModel = fitcsvm(X_train,y_train,'Holdout',0.1);
CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
[yfit,scores] = predict(CompactSVMModel,X_test);
[accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0]=prediction_performance(y_test , yfit);

%% Compute the ROC curve
score=scores(:,2);
[X,Y,T,AUC] = perfcurve(y_test ,score,1);
% Plot the ROC curve.
figure;
plot(X,Y)
xlabel('False positive rate') 
ylabel('True positive rate')
title('ROC for Classification by SVM')
legend(strcat(feature_type(1:end-1), ', AUC=',num2str(AUC),' - SVM'))
set(gca,'fontsize',16)
grid on

function A=NO_T(B)
[M,N]=size(B);
Mh=M/2;
A=B(:,1:end-1); 
