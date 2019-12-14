



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
    PWMp_Mer2=[];PWMn_Mer2=[];
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

    