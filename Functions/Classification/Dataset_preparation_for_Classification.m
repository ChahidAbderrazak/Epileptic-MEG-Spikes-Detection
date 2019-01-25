%% ################### Dataset preparation for Classification ######################
 % Authors:  
    % Abderrazak Chahid : abderrazak.chahid@kaust.edu.sa 
 % Advicor : 
   % Professor Taous_Meriem Laleg . EMANGroup KAUST  Email: taousmeriem.laleg@kaust.edu.sa 
   
% Done: Jan, 2019
 %% Description
% This script splits the data into 80/20 (training/testing)  data to use used in 
% Cross Validation classification
%% ###############################################################################

%% Features destination
 root_folder='./Features/';
if exist(root_folder) == 0, mkdir(root_folder); end  

%% random sampling of the positive and negative samples
    [Seq_pos,shuffle_p] = Shuffle_data(Seq_pos);
    [Seq_neg,shuffle_n] = Shuffle_data(Seq_neg);
                 
%% Splitting the data 80/20 (training/testing)  data
    [Mp, Np] = size(Seq_pos); [Mn, Nn] = size(Seq_neg); Mmin = min(Mp,Mn); 
    TR = floor(0.8*Mmin); % TR represents the size of the trainign data
    TR_Seq_pos = Seq_pos(1:TR,:);     TS_Seq_pos = Seq_pos(TR+1:Mmin,:);  
    TR_Seq_neg = Seq_neg(1:TR,:);     TS_Seq_neg = Seq_neg(TR+1:Mmin,:);
    
    


