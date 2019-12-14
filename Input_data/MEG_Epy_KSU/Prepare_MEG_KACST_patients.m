
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

clear all; close all; addpath ./Functions
%% Load the Healthy MEG
fs=1000;                            % the sampling frequency
L_max=70;                              % Spikes frame size. It will change if the it si bigger than the shortest spike duration
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

for patient_k=9:11%1:7%[1:8 11:15 17]%12:min(size(List_mat_Hlt,2),size(List_mat_Spk,2))
    
    subj= patient_k;  
%     clearvars Xp Xn yp yn X y  Patient_Spk SE_Spk Patient_Hlt SE_Hlt    ID_Patient ID_SE 

    %% Get the spikes from a patient
    Patient_Folder=List_xlxs_files(patient_k).folder;  Patient_Folder=strcat(Patient_Folder,'\')
    filename_xlsx=List_xlxs_files(patient_k).name;
    Spikes_xlsx_file=strcat(Patient_Folder, filename_xlsx)  
    %[filename_xlsx Patient_Folder]= uigetfile('*.xlsx', 'File selector')  ;

    %% Get the spikes time and  location from xlsx file 
    [Spikes_table] = GetSpikes_KAUST_KACST_xlxs(Spikes_xlsx_file);%,Electrode,SE,Time_spike,Spike_startes,Spike_stops


   for Class=1:-1:0
       
       if Class==1
            Patient_Folder=List_mat_Spk(patient_k);  
        
       else
            Patient_Folder=List_mat_Hlt(patient_k);  
       end
        
        Patient_Folder=strcat(Patient_Folder,'\')
        
       %% Get if this folder is for a healthy or patient
        Slice_folders=regexp(Patient_Folder,'\','split')
        MEG_patient=string(Slice_folders(end-1))
        MEG_Cathegory=string(Slice_folders(end-2))
        
    %% Extract the Classification Dataset
        [X_records,y_SE,y_CH,Time]=Extract_This_dataset_spikes_in_xlsx(Patient_Folder,Spikes_table);
        
        

        N0=size(X_records,2);
        t=0:1/fs:(N0-1)/fs;
        
        
        if Class==1
            [X_new,CHs,ID_patient_new,ID_SE_new,L_max]=Extract_dataset_basedon_spikes(MEG_patient,L_max, Frame_Step,Time,X_records,y_SE,Spikes_table,fs);
            
        else
        
            [X_new,CHs,ID_patient_new,ID_SE_new]=Extract_positive_dataset(MEG_patient,L_max,X_records,y_SE,Nsamples);
        end
        
        %% Update the right cathegory 
        if strcmp(MEG_Cathegory,'Patients')
            Xp=[Xp; X_new];
            yp=[yp; ones(size(X_new,1),1)];
            
            Patient_Spk=[Patient_Spk; ID_patient_new];
            SE_Spk=[SE_Spk; ID_SE_new];
            
            Nsamples=size(X_new,1);
      
            
        elseif strcmp(MEG_Cathegory,'Healthy')
                Xn=[Xn; X_new];
                yn=[yn; zeros(size(X_new,1),1)];
                
                Patient_Hlt=[Patient_Hlt; ID_patient_new];
                SE_Hlt=[SE_Hlt; ID_SE_new];
               

        else

                fprintf('\n\n Error: Please make sure that the  recoreds=%s is whether  in the  Patients or the Healthy folder. \n These folder=%s is not recognized  !!!\n\n',MEG_patient, MEG_Cathegory)
                d=erro;
        end

        Number_subjects=Number_subjects+1;
        clearvars X_records y_SE X_new ID_patient_new ID_SE_new
   end
   
   
   clearvars Spikes_table



%% Save Extract spikes        
X=[Xp;Xn];
y=[yp; yn];                                                                                              
ID_Patient=[Patient_Spk; Patient_Hlt];
ID_SE=[SE_Spk; SE_Hlt];

noisy_file=Fuse_strings(unique(Patient_Spk));
original_file=Fuse_strings(unique(Patient_Hlt));

suff=strcat('_CHs',num2str(max(size(CHs))),'_AutoL','_L',num2str(L_max),'_FrStep',num2str(Frame_Step));
name_record=strcat(num2str(Number_subjects),'NmSubjct_',num2str(size(X,1)),'_',num2str(size(X,2)),'_',noisy_file,suff);
path_record=strcat(Results_path,'/',noisy_file);




close all
figr=43;figure(figr);
    plot(Xp','r', 'LineWidth',2 ); hold on;% ylim([-1.5e-10 2E-10])
    plot(Xn','g', 'LineWidth',1 );  hold off
    legend('Positive  Class  ')%, 'Negative Class  ')
    title(strcat('Subject:',noisy_file, {' '},', L=', num2str(L_max), ', Step=', num2str(Frame_Step) , {' '}, ', Number of Electrods: ',num2str(max(size(CHs)))))
    xlabel('samples')
    ylabel('Intensity')
    % ylim([-1.5e-10 2E-10])
    set(gca,'fontsize',16)
    
    %% save the figure of te used data
%     save_figure(path_record,figr,name_record) 
% close all

%% Save the classification data
save(strcat(path_record,'/',name_record,'.mat'),'CHs','Frame_Step','Xp','yp','Xn','yn','X','y',...
    'ID_Patient','Patient_Spk','Patient_Hlt', 'SE_Spk', 'SE_Hlt', 'ID_SE','L_max','Frame_Step','suff','fs','t','Root_folder','noisy_file','original_file')



end                                                                                                 
 


% 
% Bi_Elctr(CHs)=1; Conf_CHs=bi2de(Bi_Elctr);
% % suff=strcat('_CHs',num2str(Conf_CHs),'_L',num2str(L_max),'_FrStep',num2str(Frame_Step));
% suff=strcat('_CHs',num2str(max(size(CHs))),'_L',num2str(L_max),'_FrStep',num2str(Frame_Step));
% 
% 
% %% Save data
% save(strcat(Results_path,'/electrode_all.mat'),'fs','Y','Y0','nb_slice','t','noisy_file','original_file','SNR_dB','Electrode','SE','Time_spike', 'Spike_startes','Spike_stops')
% clearvars t_all y y0;
% 
% 
% 




% 
% 
% 
% 
% % Read the healthy signal
% fprintf('\nChoose the healthy MEG signal.\n')
% ext='./MEG_Data_Set/*.mat';[filename0 rep]= uigetfile({ext}, 'File selector')  ;
% cname0=strcat(rep, filename0); 
% original_file=filename0(1:end-4);
% load(cname0)
% eval(['Y0=',original_file,';'])     
% 
% %% 
% N0=max(size(Y0));
% t0=0:1/fs:(N0-1)/fs;
% figr=1;
% % Plot the Two signals
% figure(figr);
% for i=1:26
% 
% plot(t0,Y0(i,:)), hold on;
% lgnd_healty{i}=strcat('Electrode n ',num2str(i));
% end
% hold off;
% A=legend(lgnd_healty);
% A.FontSize=14;
% title('The input MEG  electrodes for the healthy patient 1');
% 
% 
% %% Save The figures
% name=strcat(original_file,'Electrode_all');
% save_figure(Results_path,figr,name) 
% 
% 
% 
% %% Load the Affected  MEG with Spikes
% fprintf('\nChoose the Affected  MEG with Spikes.')
% SE_case=original_file(end);
% ext=strcat(ext(1:end-4),SE_case,'.mat');
% [filename rep]= uigetfile({ext}, 'File selector')  ;
% cname=strcat(rep, filename); 
% noisy_file=filename(1:end-4);
% load(cname);
% eval(['y=',noisy_file,';'])     
% fprintf('\nPlease wait few seconds :)')
% 
% 
% N1=max(size(y));
% t1=0:1/fs:(N1-1)/fs;
% 
% %% Plot the Two signals
% figr=figr+1;figure(figr);
% for i=1:26
% plot(t1,y(i,:)), hold on;
% lgnd_spikes{i}=strcat('Electrode n ',num2str(i));
% end
% hold off;
% A=legend(lgnd_spikes);
% A.FontSize=14;
% title('The input MEG  electrodes for the patient 1');
% 
% 
% %% Save The figures
% name=strcat(noisy_file,'Electrode_all');
% save_figure(Results_path,figr,name) 
% 
% %% Load Spikes 
% cname1=strcat(rep, '\Spikes_locations',SE_case,'.xlsx');
% fprintf('\nloading the spikes locations.')
% [Electrode,SE,Time_spike,Spike_startes,Spike_stops] = importfile(cname1);
% 
% 
% %% Take the 1st elctrodes in both cases
% N=min(N0,N1);
% if N1>N0
%     t_all=t0;
% else
%     t_all=t1;
% end
% 
% [N M]=size(y);  [N0 M0]=size(Y0);  N=min(N,N0);M=min(M,M0);
% Y=y(1:N,1:M);   Y0=Y0(1:N,1:M);   t=t_all(:,1:M);
% 
% %% Save data
% save(strcat(Results_path,'/Spikes',SE_case,'_electrode_all.mat'),'fs','Y','Y0','nb_slice','t','noisy_file','original_file','SNR_dB','Electrode','SE','Time_spike', 'Spike_startes','Spike_stops')
% clearvars t_all y y0;
% 
% Results_path_Sep=strcat(Results_path,'/Separated_Electrodes')
% %% Plot all the electrodes MEG signals (Healthy + unhealthy with spikes)
% Time_spike0=Time_spike;    Spike_startes0=Spike_startes;         Spike_stops0=Spike_stops;  
% if Plot_electrods==1
% fprintf('\n loading Each electrod seperatelly.')
% 
%     for j=1:max(size(Electrode))
%     fprintf('.')
%     Sig2study=Electrode(j);
%     y0=Y0(Sig2study,1:M);
%     y=Y(Sig2study,1:M);
%     Time_spike=Time_spike0(Sig2study);
%     Spike_startes=Spike_startes0(Sig2study);         
%     Spike_stops=Spike_stops0(Sig2study);  
%     
%     %% Plot the Two lectrodes signals
%     figr=figr+1;figure(figr);
%     plot(t,y0), hold on;
%     plot(t,y), hold off;
%     h1 = vline(Time_spike,'k','Spike time ');
%     lgnd_spikes{i}=strcat('Electrode n ',num2str(i));
%     hold off;
%     xlim([t(1) t(end)])
%     A=legend(lgnd_spikes(Sig2study));
%     A.FontSize=14;
%     title(strcat('The  MEG  electrode ',num2str(Sig2study) ,'. For a healthy an non-healthy patient',num2str(SE(Sig2study))));
% 
%     % create a zoom metabolites
%     axes('position',[.25 .65 .56 .2])
%     box on % put box around new pair of axes
%     indexOfInterest = (t <=Spike_stops ) & (t >=Spike_startes); % range of t near perturbation
% 
%     plot(t(indexOfInterest),y0(indexOfInterest), 'LineWidth',3);hold on
%     plot(t(indexOfInterest),y(indexOfInterest), 'LineWidth',1.7);hold on
%     h2 = vline([Spike_startes Time_spike Spike_stops],{'r','k','r'},{'Start','Spike time','Stop'});
%     title(strcat('The Spikes event [Zoom]'))
% 
%     %% Save The figures
%     name=strcat('Spikes',SE_case,'_electrode',num2str(Sig2study));
%     save_figure(Results_path_Sep,figr,name) 
% 
%     %% Save data
%     save(strcat(Results_path_Sep,'/Spikes',SE_case,'_electrode_',num2str(Sig2study),'.mat'),'fs','y','y0','nb_slice','t','noisy_file','original_file','SNR_dB','Sig2study','Electrode','SE','Time_spike', 'Spike_startes','Spike_stops')
%     end
% end
% 
% disp('############## THE END  ##############')