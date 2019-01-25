

%% #################      Extract dataset positive samples based  on frame    #########################
% This script converted the electrodes measure into positive dataset for healthy patient  based on 
% the number of sample needed <Nsamples> and the frame length <L_max> and
% the number of electrodes to be used  <CHs>

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@kasut.edu.sa)
% Done: Jan,  2019
%  
%% ###########################################################################
function [DataX,CHs,ID_patient,ID_SE]=Extract_positive_dataset(MEG_patient,L_max, X, y_SE,Nsamples)

% Get the spikes for the specific session SE

List_of_Sessions=unique(y_SE);%(Spikes_table.SE);
    
cnt=1;
N_SE=max(size(List_of_Sessions));
  
%% Sliding frame of size <L_max>
NN=(size(X,2));

for Sp=floor(linspace(1,NN-2*L_max,floor(Nsamples/N_SE)))
    
    Sample_indexes=Sp:Sp+L_max-1;

    for Session=List_of_Sessions' 
        %% Get the data for each session from eelctodes Electrodes
        Idx_Measure=find(y_SE==Session);
        X_SE=X(Idx_Measure,:);
        X_New=[];

        CHs=1:size(X_SE,1) ;
        
        for Electrode=CHs
            Xn=X_SE(Electrode,Sample_indexes);
            X_New=[X_New Xn]; 
            d=1;
        end   

        DataX(cnt,:)=X_New;

        %% Other details
        ID_patient(cnt)=MEG_patient; 
        ID_SE(cnt)= Session; 

        cnt=cnt+1;          
        
        if cnt>Nsamples, break; end

        clearvars X_New 
    end

    if cnt>Nsamples, break; end

end

    
d=1;
% CHs=1:size(X,1);
ID_patient=ID_patient';
ID_SE = ID_SE'; 