
%% ####################   Classification paramter ############################
% This script sets the classification paramter to classify X,y data

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Jan,  2019
%
%% ###########################################################################

% K=5;
% CV_type='KFold';%'LOO';%                                     strcat(num2str(K),'-Folds_CV');%   
% type_clf='SVM';%'LR';%                        
% Normalization=0;
% EN_starplus=1;

%% ###########################################################################

%% For test purpose, use small data set by rndom sampling
FFT_specter='TimeSerie_';

if strcmp(CV_type,'KFold')==1
    if exist('Xn')==0
        indp=find(y0==1); Xp=X0(indp,:); 
        indn=find(y0==0); Xn=X0(indn,:); 
    end

    %% get balanced data for training
    Nn=size(Xn,1);  Np=size(Xp,1);  yp=ones(Np,1); yn=0*ones(Nn,1);
    Ndata=min(Nn,Np);
    
    X=[Xp(1:Ndata,:);Xn(1:Ndata,:)];
    y=[yp(1:Ndata,:);yn(1:Ndata,:) ];
    
    
    downSample=1;
    s = RandStream('mlfg6331_64'); Rndm_idx=randsample(s,Nn,Nn,false);
    Idx=1:Nn;
    Idx_random=Idx(Rndm_idx(1:Ndata));
            
%     X=[Xp(1:Ndata,:);Xn(Idx_random,:)];
%     y=[yp(1:Ndata,:);yn(Idx_random,:) ];

end


%% Applay FFT to the Data
if EN_FFT==1
    [X, f]=FFT_signals(X,fs);FFT_specter='FFT_';
    fprintf(' --> Apply FFT transform to the time series datset \n ')
end
% X0=X;

% %% get balanced data for training/Testing for Subject_LOOCV
% Number_patient=unique(y_PatientID)


% 
% X=X*10^12;
X=X/max(max(X));
%% Normalization 
if Normalization==1
%     X=Scale_down_to_unit(X);
    X=normalize(X,2);   
end

 %% Random sampling the input  data
%     [X,shuffle_index]=Shuffle_data(X);y=y(shuffle_index);

%% Display
Bi_Elctr(CHs)=1; Conf_Elctr=bi2de(Bi_Elctr);
Electrode_list=CHs;

d_clf='--> Epeliptic seizure Classification  :' ;
d_data1=string(strcat('- CV type:',{''},CV_type,{''},', K=',num2str(K),',  Dataset: ',noisy_file ,', Electrodes configuration: ',num2str(Conf_Elctr),', Used Electrodes=',num2str(Electrode_list) ));
d_data2=string(strcat('- Sampling:  L=',num2str(L_max),', Frame Step=',num2str(Frame_Step),', Norm=',num2str(Normalization)));
d_data20=string(strcat('- Dataset: :  ',num2str(size(X,1)),' Samples. Each has   ',{' '},num2str(size(X,2)),' points;'));
fprintf('%s \n %s \n %s \n\n',d_clf,d_data1,d_data2,d_data20);


%   %% Splitting the data 80/20 (training/testing)  data
%       [Seq_pos,Seq_neg,yp,yn]=Split_Features_Pos_Neg(X,y);
% 
%     [Mp, Np] = size(Seq_pos); [Mn, Nn] = size(Seq_neg); Mmin = min(Mp,Mn); 
%     TR = floor(0.8*Mmin); % TR represents the size of the trainign data
%     TR_X_pos = Seq_pos(1:TR,:);  TR_y_pos = yp(1:TR);     
%     TR_X_neg = Seq_neg(1:TR,:);  TR_y_neg = yn(1:TR);   
%     
%     TS_X_pos = Seq_pos(TR+1:Mmin,:);   TS_y_pos = yp(TR+1:Mmin);  
%     TS_X_neg = Seq_neg(TR+1:Mmin,:);   TS_y_neg = yn(TR+1:Mmin); 
%     
%     
%     %% Get the training and testing data
%     Xtrain= [TR_X_pos; TR_X_neg];        ytrain=[TR_y_pos;TR_y_neg];
%     Xtest= [TS_X_pos; TS_X_neg];        ytest=[TS_y_pos;TS_y_neg];

    
    
    
    