%% #########################   Display   ################################
fprintf('########################################################################\n');
fprintf('|          Spikes Detection for Epyliptic sigal Project 2018            \n');
fprintf('########################################################################\n\n');

fprintf('\n --> Loading Input MEG Data ');

%% #########################    Load data   ################################
ext = './Input_data/Extracted_spikes_data/*.mat';  
[filename rep]= uigetfile({ext}, 'File selector')  ;
chemin = fullfile(rep, ext);   list = dir(chemin);  
cname=strcat(rep, filename);   load(cname); 
