% F_features: filtred input 
% S_features: the whole negative eigenvalues spectrum 
% B_features: two first and last eigenvalues 
% P_features: sum of all normalised eigen functions
% AF_features: Area under the filtred input 
% SFP_features: sum of the product of the eigenvalues to the corresponding
%               eigenfucntion (Suggested by M)

function [F_features, S_features, B_features, P_features,AF_features,SFP_features,SK_features,INVK_features, Nh_all, Eigen_Spectrum]=SCSA_Transform_features(features,y,h0,gm,fs)

fprintf('\n --> Generate SCSA based features\n ');

%% Run the scsa
[h, yscsaA,Nh,Nh00,Neg_lamda,ProbaS, Sum_Basis,Eigen_Spectrum]= SCSA_transform(features,h0,fs,gm);

Nh_all=Nh00';
SFP_features=Sum_Basis;
F_features=[yscsaA];
AF_features=[trapz(yscsaA')']/size(features,2);

% Get the non-zero spectrum
Idx=min_spectrum(Neg_lamda);

Idx=8;
Idx=size(Neg_lamda,2);

S_features=[Neg_lamda(:,1:Idx)];% S_features=[Neg_lamda(:,1:max(Nh))];
P_features=[ProbaS ];

B=10;
if 2*B<Idx
    
% B=min(B,Idx-1);
B_features=[Neg_lamda(:,[1:B,Idx-B:Idx]) ]; 
else
    B_features=0*y; 
end


if size(Neg_lamda,2)==1
    SK_features=Neg_lamda.^2;

elseif size(Neg_lamda,2)>1
    SK_features=sum(Neg_lamda'.^2)';

end


step=4;

if size(Neg_lamda,2)<=step
    INVK_features=Neg_lamda.^2;

else
    
    cnt=1;
    for k=1:step:size(Neg_lamda,2)-step
        INVK_features(:,cnt)=sum(Neg_lamda(:,k:k+step-1)'.^2)';
        cnt=cnt+1;
    end

end
%% Plot feaures 
% plot_feature(SFP_features,y)
        

 %% plots:
% plot_feature(B_features,y)
% plot_feature(AF_features,y)
% plot_feature(SFP_features,y)
% plot_feature(S_features,y)
% plot_feature(SK_features,y)

 d=1;

 
 
 function  Idx=min_spectrum(X)
 N=size(X,2);
 
 Idx=N;
 
 for k=1:size(X,1)
     IdxX=find(X(k,:)==0);
     if size(IdxX,2)
         idx0=min(IdxX);
         Idx=min(Idx,idx0);
     end
 end
     
 d=1; 
 
 
%  function  Idx=min_spectrum(X)
%  N=size(X,2);
%  
%  Idx=N;
%  
%  for k=1:N
%      IdxX=find(X(k,:)==0);
%      if size(IdxX,2)
%          idx0=min(IdxX);
%          Idx=min(Idx,idx0);
%      end
%  end
%      
%  d=1;  




function plot_feature(S_features,class)
 
    figure; 

    for k=1:size(S_features)
        if class(k)==1
            plot(S_features(k,:),'k'); hold on 
        else
            plot(S_features(k,:),'r'); hold on 
        end

    end

