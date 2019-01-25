
%% #################      ALL patient Spikes data preparation    #########################
% This script prepare the data for .mat usage.  Plese make sure that you
% have  healthyX.mat  amd spikesX.mat files that containes all te electrods
% measurments.  

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
% Done: Nov,  2017
%  
%% ###########################################################################

clear all; close all; addpath ./Functions
%% Load the Healthy MEG
Nhealthy=2;                             % number of healthy patients
Nspiky=2;                               % number of spiky patients
Electrode_list=1:26;% 2:4;%             % the list of electrods to be used
Bi_Elctr(Electrode_list)=1; Conf_Elctr_desired=bi2de(Bi_Elctr);
Results_path='./Combined_Patients';
%% ############################   START HERE    ##############################
% Read the healthy signal
 noisy_file0='';original_file0='';
for healthty_record=1:Nhealthy
    ext=strcat('./Input_data/Extracted_spikes_data/*',num2str(Conf_Elctr_desired),'*.mat');[filename0 rep]= uigetfile({ext}, 'File selector')  ;
    cname0=strcat(rep, filename0); 
    load(cname0)

 
    if healthty_record==1
        Xsp0_cmb=Xsp0;
        Xsp_cmb=Xsp;
    
    else
        
        Xsp0_cmb=[Xsp0_cmb;Xsp0];
        Xsp_cmb=[Xsp_cmb;Xsp];
        

    end
    
    %% Get the data information 
    
    original_file_list{healthty_record}= original_file;
    original_file0=strcat(original_file,'_',original_file0) 

        
    noisy_file_list{healthty_record}= noisy_file;
    noisy_file0=strcat(noisy_file,'_',noisy_file0) 

    suff_list{healthty_record}= suff;
    
    
end
clearvars noisy_file original_file X Xsp Xsp0 

noisy_file=noisy_file0(1:end-1);    original_file=original_file0(1:end-1);
Xsp0=Xsp0_cmb;    Xsp=Xsp_cmb;

%% Build the data 
X=[Xsp;Xsp0];
y=[ones(size(Xsp,1),1); zeros(size(Xsp,1),1) ];
      
 %% Save the combined samples       
data_path=strcat('./Input_data/Extracted_spikes_data/',noisy_file,'/');
if exist(data_path)~=7; mkdir(data_path);end 

name_data=strcat(data_path,num2str(size(X,1)),'_',num2str(size(X,2)),'_',noisy_file,suff,'.mat');
save(name_data,'Conf_Elctr','Electrode_list','Frame_Step','Xsp','Xsp0','X','y','L_max','EN_L','EN_b','bmin','bmax','suff',...
              'noisy_file_list','suff_list','original_file_list','fs','Y','Y0','nb_slice','t','noisy_file','original_file','SNR_dB','Electrode')
                                                                                        

          
          
close all
figr=43;figure(figr);
    plot(Xsp','r', 'LineWidth',2 ); hold on;% ylim([-1.5e-10 2E-10])
    plot(Xsp0','g', 'LineWidth',1 );  hold off
    legend('Positive  Class  ')%, 'Negative Class  ')
    title(strcat(noisy_file, {' '}, 'Electrods: ',num2str(Electrode_list),', L=', num2str(L_max), ',Step=', num2str(Frame_Step) ))
    xlabel('samples')
    ylabel('Intensity')
    % ylim([-1.5e-10 2E-10])
    set(gca,'fontsize',16)
    
    %% save the figure of te used data
    name=strcat(num2str(size(X,1)),'_','_',num2str(size(X,2)),'_',noisy_file,suff);
    save_figure(data_path,figr,name) 
close all



disp('############## THE END  ##############')

