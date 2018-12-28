%% ###########################################################################
type_clf='SVM';% 'LR';%   
K=5;                     % K-folds CV 
Normalization=0

if Normalization==0
    X=X*10^12;
else
%         X=normalize_0_1(X);
    X=Scale_down_to_unit(X);
end