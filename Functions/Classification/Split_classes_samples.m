function [Xp,Xn]=Split_classes_samples(X,y)
idxp=find(y==1);   Xp=X(idxp,:);

idxn=find(y==0);   Xn=X(idxn,:);
