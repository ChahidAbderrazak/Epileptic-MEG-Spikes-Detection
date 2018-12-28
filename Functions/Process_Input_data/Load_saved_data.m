%% Step Log
% fprintf(fid_display, colorizestring('red', ' <br/>  <font size="+1.2"> The Epileptic spikes detection Project 2018'));web(filename_display);
% fprintf(fid_display, colorizestring('blue', ' <br/>  <font size="+1"> Loading Input MEG Data'));web(filename_display);

%% #########################    Load data   ################################
ext = './Input_data/Extracted_spikes_data/*.mat';  
[filename rep]= uigetfile({ext}, 'File selector')  ;
chemin = fullfile(rep, ext);   list = dir(chemin);  
cname=strcat(rep, filename);   load(cname); 
