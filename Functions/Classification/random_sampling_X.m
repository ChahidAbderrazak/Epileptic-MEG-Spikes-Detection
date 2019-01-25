n = size(Xsp,1);
Nsamples=80;
Idx_samples = randsample(n,Nsamples);

X=[Xsp(Idx_samples,:);Xsp0(Idx_samples,:)];
y=[ones(Nsamples,1); zeros(Nsamples,1) ];