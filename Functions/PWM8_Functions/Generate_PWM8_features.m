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

 
