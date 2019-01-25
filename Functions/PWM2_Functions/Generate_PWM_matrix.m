function PWM_matrix= Generate_PWM_matrix(X_train, Levels)
Levels=size(Levels,2);
PWM_matrix= zeros(5, size(X_train,2));

for k=1:Levels
    for i=1:size(X_train, 2)
        PWM_matrix(k,i)= sum(X_train(:, i) == k)/size(X_train,1);
    end
end


end