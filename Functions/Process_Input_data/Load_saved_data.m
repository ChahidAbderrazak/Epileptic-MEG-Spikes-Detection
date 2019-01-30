%% #########################   Display   ################################
fprintf('########################################################################\n');
fprintf('|          Epileptic Spikes Detection for MEG signal Project 2018            \n');
fprintf('########################################################################\n\n');

fprintf('\n --> Loading Input MEG Data ');

%% #########################    Load data   ################################
ext = './Input_data/*.mat';  
[filename rep]= uigetfile({ext}, 'File selector')  ;
chemin = fullfile(rep, ext);   list = dir(chemin);  
cname=strcat(rep, filename);   load(cname); 
