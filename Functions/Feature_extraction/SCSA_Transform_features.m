% F_features: filtred input 
% S_features: the whole negative eigenvalues spectrum 
% B_features: two first and last eigenvalues 
% P_features: sum of all normalised eigen functions
% AF_features: Area under the filtred input 
% SFP_features: sum of the product of the eigenvalues to the corresponding
%               eigenfucntion (Suggested by M)

function [F_features, S_features, B_features, P_features,AF_features,SFP_features,SK_features, Nh_all]=SCSA_Transform_features(features,y,h0,gm,fs)

%% Run the scsa
[h, yscsaA,Nh,Neg_lamda,ProbaS, Sum_Basis]= SCSA_transform(features,fs,h0,gm);

Nh_all=Nh';
SFP_features=Sum_Basis;
F_features=[yscsaA];
AF_features=[trapz(yscsaA')']/size(features,2);

% Get the non-zero spectrum
Idx=min_spectrum(Neg_lamda);
S_features=[Neg_lamda(:,1:Idx)];% S_features=[Neg_lamda(:,1:max(Nh))];
P_features=[ProbaS ];

B=4;

% B=min(B,Idx-1);
B_features=[Neg_lamda(:,[1:B,Idx-B:Idx]) ];

SK_features=sum(Neg_lamda'.^2)';
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
 N=size(X,1);
 Idx=N;
 
 for k=1:N
     IdxX=find(X(k,:)==0);
     if size(IdxX,2)
         idx0=min(IdxX);
         Idx=min(Idx,idx0);
     end
 end
     
 d=1;  




function plot_feature(S_features,class)
 
    figure; 

    for k=1:size(S_features)
        if class(k)==1
            plot(S_features(k,:),'k'); hold on 
        else
            plot(S_features(k,:),'r'); hold on 
        end

    end

