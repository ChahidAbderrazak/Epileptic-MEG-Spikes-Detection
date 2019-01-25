function [X,shuffle_p]=Shuffle_data(X)

%% Shuffle the data
[M,N]=size(X);



for i=1:7
 shuffle_p=randi(M,[1 M]);X=X(shuffle_p,:);
end
X=X(shuffle_p,:);
  
d=1;







