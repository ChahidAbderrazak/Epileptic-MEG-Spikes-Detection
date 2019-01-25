function [Seq_pos,Seq_neg,yp,yn]=Split_Features_Pos_Neg(X,y)

Idxp=find(y==1);Idxn=find(y==0);

Seq_pos=X(Idxp,:);yp=0*Idxp+1;
Seq_neg=X(Idxn,:);yn=0*Idxn;
