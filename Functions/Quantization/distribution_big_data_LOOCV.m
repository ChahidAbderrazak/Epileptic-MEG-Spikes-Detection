    
idxn=find(y==0);idxp=find(y==1);

N_p=max(size(idxp));  N_n=max(size(idxn));
s = RandStream('mlfg6331_64'); Rndm_idx=randsample(s,max(N_p,N_n),min(N_p,N_n),false);

if N_n> min(N_p,N_n)

    idxn=idxn(Rndm_idx);
else

    idxp=idxp(Rndm_idx);
end

Idx_blcd=[idxp;idxn];


%update the datset
[Xsp,Xsp0]=Split_classes_samples(X(Idx_blcd,:),y(Idx_blcd));