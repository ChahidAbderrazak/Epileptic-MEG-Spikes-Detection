 %% Apply Leave One Out CV with PWM features using diffferent classifers
% X: The data  sample
% y  The Class
% clf: The calssifier:{'nbayes','logisticRegression','SVM','','',''}
% function [accuracy1,sz_fPWM]= Classify_LeaveOut_PWM(X,y,clf)
function [sz_fPWM, Avg_Accuracy,Avg_sensitivity,Avg_specificity,Avg_precision,Avg_gmean,Avg_f1score,Avg_AUC]=PWM8_Data_CrossValidation(X, y,CV_type, K,type_clf)

global Levels Level_intervals 


if strcmp(CV_type,'LOO')==1
    C = cvpartition(y, 'LeaveOut');
    
    fprintf('------------------------------------------------------------------\n')
    fprintf('            Leave-One-Out Cross Validation using %s           \n',type_clf )
    fprintf('------------------------------------------------------------------\n')


elseif strcmp(CV_type,'KFold')==1
    C = cvpartition(y, 'KFold',K);
    
    fprintf('------------------------------------------------------------------\n')
    fprintf('            The %d-Folds Cross Validation using %s           \n',K,type_clf )
    fprintf('------------------------------------------------------------------\n')



else
    fprintf('\n --> Error: undefined Cross-Validation : %s',CV_type);

end
Bi_classes=  unique(y);

for num_fold = 1:C.NumTestSets
    clearvars  PWM_* XP Xn
    
    
    trIdx = C.training(num_fold);                                            teIdx = C.test(num_fold);
    Idx= find(teIdx);
    
    X_train= X(trIdx,:);                                                     X_test= X(teIdx,:); 
    y_train= y(trIdx);                                                       y_test= y(teIdx);
    
    
    %% Get the positive and negative training samples to build PWM matrices
    Xp=X_train(y_train==1,:);   Np=size(Xp, 1);
    Xn=X_train(y_train==0,:);   Nn=size(Xn, 1);
    if abs(Np-Nn)>1
        fprintf('Non balanced testing data\n\n')
        CV_Status=No_blanced; 

    end
    %% Quantization
    Seq_train= mapping_levels(X_train,Level_intervals, Levels);
    Seq_test= mapping_levels(X_test,Level_intervals, Levels);


    %% Build the PWM matrices   Mers1
%      [PWMp_Mer1,PWMn_Mer1]= Generate_PWM8_matrix(Seq_train,y_train);
%     fPWM_train= Generate_PWM8_features(Seq_train, PWMp_Mer1, PWMn_Mer1);       
%     fPWM_test = Generate_PWM8_features(Seq_test,  PWMp_Mer1, PWMn_Mer1);
      
    %% Build the PWM matrices   Mers1 Mer2
  
   [PWMp_Mer1,PWMn_Mer1, PWMp_Mer2,PWMn_Mer2]= Generate_PWM8_matrix(Seq_train,y_train);
    fPWM_train= Generate_PWM8_features(Seq_train, PWMp_Mer1, PWMn_Mer1,PWMp_Mer2,PWMn_Mer2);       
    fPWM_test = Generate_PWM8_features(Seq_test,  PWMp_Mer1, PWMn_Mer1,PWMp_Mer2,PWMn_Mer2);

    
%    [PWMp_Mer1,PWMn_Mer1, PWMp_Mer2,PWMn_Mer2, PWMp_Mer3,PWMn_Mer3]= Generate_PWM8_matrix(Seq_train,y_train)



% %% Concatenate all  PWM  Features 
%     
% % Training
% Mp= size(TR_Seq_pos,1);  Mn= size(TR_Seq_neg,1); 
% y_train = [ones([Mp,1]);zeros([Mn,1])];
% X_train =  [ Mer1_PWM_features_TR, Mer2_PWM_features_TR, Mer3_PWM_features_TR];
% 
% % Testing
% Mp= size(TS_Seq_pos,1);  Mn= size(TS_Seq_neg,1); 
% y_test = [ones([Mp,1]);zeros([Mn,1])];
% X_test =  [ Mer1_PWM_features_TS, Mer2_PWM_features_TS,  Mer3_PWM_features_TS];

%     
    %% plot PWM features
%     plot_PWM_features(fPWM_train,fPWM_test,Np)

        [Mdl,Accuracy(num_fold),sensitivity(num_fold),specificity(num_fold),precision(num_fold),gmean(num_fold),f1score(num_fold),AUC(num_fold),ytrue,yfit,score]...
        =Classify_Data(type_clf, fPWM_train, y_train, fPWM_test, y_test);
    
end

%% Average Accuracy 
Avg_Accuracy = sum(Accuracy)/C.NumTestSets;
Avg_sensitivity = sum(sensitivity)/C.NumTestSets;
Avg_specificity = sum(specificity)/C.NumTestSets;
Avg_precision = sum(precision)/C.NumTestSets;
Avg_f1score = sum(f1score)/C.NumTestSets;
Avg_gmean = sum(gmean)/C.NumTestSets;
Avg_AUC = sum(AUC)/C.NumTestSets;

Accuracy;
Avg_Accuracy;
sz_fPWM=size(fPWM_train,2);



end

%% Funtions



% Quantization
function X=mapping_levels(X,Level_intervals, Levels)
    for i=1:size(X,1)
        for j=1:size(X,2)
             X(i,j)=Get_level(X(i,j),Level_intervals,Levels);    
        end
        
    end
d=1;
end


function L=Get_level(Vx,Level_intervals,Levels)  

    idx=find(Vx<=Level_intervals);

    if size(idx,2)==0
        L=Levels(end);
    else
       l=idx(1);
       L=Levels(l);

    end


    d=1;
end






% function [PWMp_Mer1,PWMn_Mer1]=Generate_PWM8_matrix(X_train,y_train)
function [PWMp_Mer1,PWMn_Mer1, PWMp_Mer2,PWMn_Mer2]=Generate_PWM8_matrix(X_train,y_train)
% function [PWMp_Mer1,PWMn_Mer1, PWMp_Mer2,PWMn_Mer2, PWMp_Mer3,PWMn_Mer3]=Generate_PWM8_matrix(X_train,y_train)

global Levels

    [TR_Seq_pos,TR_Seq_neg,yptr,yntr]=Split_Features_Pos_Neg(X_train,y_train);
    [Mp,Np]=size(TR_Seq_pos);      [Mn,Nn]=size(TR_Seq_neg);  
    
    M=min(Mp,Mn);
    TR_Seq_pos=TR_Seq_pos(1:M,:);     TR_Seq_neg=TR_Seq_neg(1:M,:); 

   
%% Mono-Mers  Position Weight Matrix-BASED FEATURES
     
     % Build the PWMs from the Training   
    [ Mer1_Seq_pos_TR,name_Mer1] = Extract_Miers1(TR_Seq_pos,Levels); 
    [Mer1_Seq_neg_TR, name_Mer1] = Extract_Miers1(TR_Seq_neg,Levels);
          
    [PWMp_Mer1,PWMn_Mer1] = General_PWM_matrices_generatures3D(Mer1_Seq_pos_TR,Mer1_Seq_neg_TR);


    %% Di-Mers  Position Weight Matrix-BASED FEATURES
     % Build the PWMs from the Training   
    [Mer2_Seq_pos_TR, name_Mer2] = Extract_Miers2(TR_Seq_pos,Levels);
    [Mer2_Seq_neg_TR, name_Mer2] = Extract_Miers2(TR_Seq_neg,Levels);
    [PWMp_Mer2,PWMn_Mer2] = General_PWM_matrices_generatures3D(Mer2_Seq_pos_TR,Mer2_Seq_neg_TR);

%     %% 3-Mers Position Weight Matrix-BASED FEATURES
%      % Build the PWMs from the Training   
%     [Mer3_Seq_pos_TR, name_Mer3] = Extract_Miers3(TR_Seq_pos,Levels);
%     [Mer3_Seq_neg_TR, name_Mer3] = Extract_Miers3(TR_Seq_neg,Levels);
%     [PWMp_Mer3,PWMn_Mer3] = General_PWM_matrices_generatures3D(Mer3_Seq_pos_TR,Mer3_Seq_neg_TR);

    
end

function fPWM= Generate_PWM8_features(Input_Sequence, PWM_P, PWM_N,PWMp_Mer2,PWMn_Mer2)
global Levels

    [Mer1_Seq,name_Mer1] = Extract_Miers1(Input_Sequence,Levels);
    fPWM1 = Apply_General_PWM_feature_generator(Mer1_Seq, PWM_P, PWM_N); 
    fPWM=fPWM1;
    [Mer2_Seq, name_Mer2] = Extract_Miers2(Input_Sequence,Levels);
    fPWM2 = Apply_General_PWM_feature_generator(Mer2_Seq, PWMp_Mer2,PWMn_Mer2);
    
%     fPWM2 = Apply_General_PWM_feature_generator3D(Mer2_Seq, PWMp_Mer2,PWMn_Mer2);

    fPWM=[fPWM1 fPWM2];
    
    
%     [Mer3_Seq, name_Mer2] = Extract_Miers3(Input_Sequence,Levels);
%     fPWM3 = Apply_General_PWM_feature_generator(Mer3_Seq, PWMp_Mer3,PWMn_Mer3);


    d=1;
    
end