function PWM_matrix= Generate_PWM_matrix(X_train, Levels)
Nl=size(Levels,2);
PWM_matrix= zeros(5, size(X_train,2));

for k=1:Nl
    for i=1:size(X_train, 2)
        PWM_matrix(k,i)= sum(X_train(:, i) == Levels(k))/size(X_train,1);
    end
end


end