%% the Input_sequence,neg_pattern should be binary patterns

function [features_GPWM]=Apply_General_PWM_feature_generator(Input_sequence, PWRp, PWRn)
%% PWM Matrix normalization option 
[Mp, Np,Nb_Layers]=size(Input_sequence);  
 
norm_rows=1;
PWRp=normalize_PWD_matrix(Mp,norm_rows, PWRp);
PWRn=normalize_PWD_matrix(Mp,norm_rows, PWRn);

%% Start feature generation 


for k=1:Nb_Layers

    s=(k-1)*2 +1: k*2;
    patternK_pos=Input_sequence(:,:,k);
    PWVp=PWRp(k,:);
    PWVn=PWRn(k,:);
    [features_PWK(:,s)]=GPWM_feature_generator(patternK_pos,PWVp,PWVn);  

end

%% Add the target 
features_GPWM=features_PWK;


function [features_PWK]=GPWM_feature_generator(patternK_pos,PWRp,PWRn)
PWM=[PWRp;PWRn];
features_PWK=patternK_pos*PWM';


