% It rus a k-folds cross validation using some inpur features and their
% corresponding sequances that will be used to genarate PWM feature using PWM_Ratio
% The output results return the optimal Logestic regressin model that gives the
% maximum accuracy in classifying the combined features [ input features + PWM]
% Important: the Pos_Sequences must be used to generate the  Pos_feature
% with the same order. Respctivelly for Neg_Sequences-->Neg_features

function  [Mdl_optimal,Max_Accuracy, CV_results, Avg_Accuracy]=Run_Cross_Validation_of_features(K,X_train,y_train)

%% Create the partitions
cnt0=0;Acc_Max=0;
% fprintf(' --------------------------------------------------------------------------------\n')
% fprintf('| The Cross Validation training is running using %d Fold   \n',K)
% fprintf(' --------------------------------------------------------------------------------\n')


M=size(X_train,1);

if K>1
    
    CVO = cvpartition(y_train,'KFold',K,'Stratify',true);

    for k = 1:K

%         fprintf('\n----- Fold %d  ----\n',k)
        trIdx = CVO.training(k);
        teIdx = CVO.test(k);
    
        
        X_train_k=X_train(trIdx,:);    y_train_k=y_train(trIdx,:);  
        X_test_k =X_train(teIdx,:);    y_test_k =y_train(teIdx,:);
        
        Sz_0=max(size(find(y_test_k==0))); Sz_1=max(size(find(y_test_k ==1)));
        balanced_TS=Sz_0-Sz_1;
               
        Sz_0=max(size(find(y_train_k==0))); Sz_1=max(size(find(y_train_k==1)));
        balanced_TR=Sz_0-Sz_1; 
        
   
        %% Classification model
        % Train the model
            Mdl=Train_LR(X_train_k,y_train_k);

         % Train the model
            y_predicted=Test_LR(Mdl,X_test_k);

        
        %% Compute the accuracy
            [accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,C1]=prediction_performance(y_test_k, y_predicted);
            
            accuracy_all(k)=accuracy0;


        %% Run the logitic regression 
        cnt0=cnt0+1;  
        size_Train = size(X_train_k,1);
        size_Test = size(X_test_k,1);
        CV_results(cnt0,:)=[K, size_Train,size_Test,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0];  

        if Acc_Max<accuracy0
            Mdl_optimal=Mdl;   Acc_Max=accuracy0;

        end



    end
   
    Avg_Accuracy=mean(accuracy_all);
    Max_Accuracy=max(accuracy_all);
else
    
        % Train the model
            Mdl_optimal=Train_LR(X_train,y_train);

        % Train the model
            y_predicted=Test_LR(Mdl_optimal,X_train);


        %% Compute the accuracy
            [accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0,C1]=prediction_performance(y_train, y_predicted);
            size_Train = size(X_train,1);
            size_Test = size(X_train,1);
        
        CV_results=[K, size_Train,size_Test,accuracy0,sensitivity0,specificity0,precision0,gmean0,f1score0];  
        Avg_Accuracy=mean(accuracy0);
        Max_Accuracy=max(accuracy0);
        
      
    
    
end

d=1;





