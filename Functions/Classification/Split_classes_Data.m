function [Xp,Xn]=Split_classes_Data(X,y) 
p=1;n=1
for k=1:size(X)
        if y(k)==1
             Xp(p,:)=X(k,:);
             p=p+1;
        else
             Xn(n,:)=X(k,:);
             n=n+1; 
        end

    end