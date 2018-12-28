%% Step Log
fprintf(fid_display, colorizestring('red', ' <br/>  <font size="+1.2"> The Encoding DNA Exons Dekction Project 2018'));web(filename_display);
fprintf(fid_display, colorizestring('blue', ' <br/>  <font size="+1"> Loading Input Genes Data'));web(filename_display);

%% #########################    Load data   ################################
ext = './Input_data/ready/*.mat';  
[filename rep]= uigetfile({ext}, 'File selector')  ;
chemin = fullfile(rep, ext);   list = dir(chemin);  
cname=strcat(rep, filename);   load(cname); 
