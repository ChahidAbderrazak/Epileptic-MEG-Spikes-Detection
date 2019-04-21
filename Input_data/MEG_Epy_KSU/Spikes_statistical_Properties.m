
%% #################  Spikes data preparation KACST    #########################
% This script prepare the data provided by KACST centers for matlab  usage. 
% Please make sure that you  have  have healthy and non-Heatlthy recodrs saved 
% in separate folder

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@kasut.edu.sa)
% Done: Jan,  2019
%  
%% ###########################################################################

% clear all; close all; addpath ./Functions
%% Load the Healthy MEG
fs=1000;                            % the sampling frequency
L_max=100;                              % Spikes frame size. It will change if the it si bigger than the shortest spike duration
Frame_Step=2;                          % sliding  frame step size
Plot_electrods = 1;                 % If you want to plot all the electrods amples seperatelly Plot_electrods=1 else Plot_electrods=0
Results_path='../Extracted_separate_subj';

%% ############################   START HERE    ##############################
global MEGChannels
load('MEG_Channels.mat')
mkdir(Results_path)
%% Select the Root folder
Root_folder = uigetdir; Root_folder=strcat(Root_folder,'\');
% % Get the Patients classes
% Patient_Class=List_subFolders(Root_folder);

%% MEG records whith spikes
List_xlxs_files = dir(strcat(Root_folder ,'\Patients\*\*.xlsx'));
List_xlxs_files=Spikes_remove_analyzed(List_xlxs_files)

List_mat_Hlt=GetSubfolder_with_data(strcat(Root_folder ,'\Healthy\'));
List_mat_Spk=GetSubfolder_with_data(strcat(Root_folder ,'\Patients\'));

Number_subjects=0;
suff=strcat('allCHs','_AutoL','_L',num2str(L_max),'_FrStep',num2str(Frame_Step));


%% ######################## Read file in loop ########################
Xp=[];Xn=[];yp=[];yn=[];X=[];y=[];
Patient_Spk=[];SE_Spk=[];Patient_Hlt=[];SE_Hlt=[];   ID_Patient=[];ID_SE=[];

Spikes_duration=[]

for patient_k=1:9%[1:8 11:15 17]%12:min(size(List_mat_Hlt,2),size(List_mat_Spk,2))
    
    subj= patient_k;  
%     clearvars Xp Xn yp yn X y  Patient_Spk SE_Spk Patient_Hlt SE_Hlt    ID_Patient ID_SE 

    %% Get the spikes from a patient
    Patient_Folder=List_xlxs_files(patient_k).folder;  Patient_Folder=strcat(Patient_Folder,'\')
    filename_xlsx=List_xlxs_files(patient_k).name;
    Spikes_xlsx_file=strcat(Patient_Folder, filename_xlsx)  
    %[filename_xlsx Patient_Folder]= uigetfile('*.xlsx', 'File selector')  ;

    %% Get the spikes time and  location from xlsx file 
    [Spikes_table] = GetSpikes_KAUST_KACST_xlxs(Spikes_xlsx_file);%,Electrode,SE,Time_spike,Spike_startes,Spike_stops

   new_duration=(Spikes_table.SpikeStop-Spikes_table.SpikeStart)*1000;
   Spikes_duration=[Spikes_duration; new_duration];
   clearvars Spikes_table




end                                                                                                 
 


%% Get the statistical properties of the data

    SpD_pd = fitdist(Spikes_duration,'Normal');

%% GEt the noral distibution for each subject
    SpD_pd_Sigma=floor(SpD_pd.sigma*10)/10;     SpD_pd_mu=floor(SpD_pd.mu*10)/10;     
        
 % plot 
 figure;
 histfit(Spikes_duration,100); 
 legend('Fitted Histogram',strcat('Gaussian distribution ( \mu=',num2str(SpD_pd_mu),', \sigma=',num2str(SpD_pd_Sigma),') '))
 xlabel('Spikes duration (#samples)')
 ylabel('Number of spikes')
 xlim([0 450])
 set(gca,'fontsize',16)

 
  