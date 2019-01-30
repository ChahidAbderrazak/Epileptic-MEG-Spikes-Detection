 function fPWM_features= Generate_PWM_features(X_train, PWM_P, PWM_N)
    
fPWM_1= zeros(size(X_train,1), size(X_train,2)); %f1 is the first feature of PWM
fPWM_2= zeros(size(X_train,1), size(X_train,2)); %f1 is the second feature of PWM

% replace the integer values by its probability from VPM
for i=1:size(X_train,1)
    for j=1:size(X_train,2)
        PWM_idx=X_train(i,j);
        fPWM_1(i,j)= PWM_P(PWM_idx,j);
        fPWM_2(i,j)= PWM_N(PWM_idx,j);
    end
end
% sum all the probabilities to get the PWM
f1=sum(fPWM_1,2);
f2=sum(fPWM_2,2);
fPWM_features=[f1 f2];

end