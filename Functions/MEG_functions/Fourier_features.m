function [X_FT,Max_X_FT,I,DC_FT,ESD_FT] = Fourier_features(X)

X_FT= zeros(size(X,1), size(X,2));
Max_X_FT= zeros(size(X,1),1);
I= zeros(size(X,1),1);

for k=1:size(X,1)
    X_FT(k,:)= angle(fft(X(k,:)));
end
DC_FT= X_FT(:,1);
X_FT(:,1)=[];
for k=1:size(X,1)
    [Max_X_FT(k,1), I(k,1)]= max(X_FT(k,:));
end

%% ESD

ESD= X_FT.*conj(X_FT);
ESD_FT= sum(ESD,2);

