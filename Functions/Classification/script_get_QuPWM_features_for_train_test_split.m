
    %% Quantization
    fprintf('\n ---> Quantization')

    Seq_train= mapping_levels(X_train,Level_intervals, Levels);
    Seq_test= mapping_levels(X_test,Level_intervals, Levels);


    %% Build the PWM matrices   Mers1
%     fprintf('\n ---> Build the PWM matrices   Mers1')
%      [PWMp_Mer1,PWMn_Mer1]= Generate_PWM8_matrix(Seq_train,y_train);
%     fPWM_train= Generate_PWM8_features(Seq_train, PWMp_Mer1, PWMn_Mer1);       
%     fPWM_test = Generate_PWM8_features(Seq_test,  PWMp_Mer1, PWMn_Mer1);
      
    %% Build the PWM matrices   Mers1 Mer2
   fprintf('\n ---> Build the PWM matrices   Mers1, Mers2')
   [PWMp_Mer1,PWMn_Mer1, PWMp_Mer2,PWMn_Mer2]= Generate_PWM8_matrix(Seq_train,y_train);

    %% Generate PWM features using   Mers1 Mer2
   
    fprintf('\n ---> Generate PWM features using PWMs: Mers1, Mers2')
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