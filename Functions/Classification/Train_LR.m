function [Mdl]=Train_LR(X_train,y_train) 

% %%% ####################################### 
training_set= array2table(X_train);
training_set.class = y_train;

%% Model training
Mdl= fitglm(training_set,'linear','Distribution','binomial','link', 'logit');
