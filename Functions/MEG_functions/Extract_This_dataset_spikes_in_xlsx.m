

%% #################      Extract datset baased on Spikes and frame    #########################
% This script converted the electrodes measure into classifcation dataset <X> based on 
% the pre-knowldge of the spikes location {Spike_stops,Spike_startes,Time_spike}
% and the frame lenght <L_max>,  step<Frame_Step> from all  the number of electrodes  <CHs>

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@kasut.edu.sa)
% Done: Jan,  2019
%  
%% ###########################################################################
function [Xsp,y_SE, y_CH]=Extract_This_dataset_spikes_in_xlsx(Patient_Folder,Spikes_table)
global MEGChannels

%% Get if this folder is for a healthy or patient
Slice_folders=regexp(Patient_Folder,'\','split');
MEG_patient=string(Slice_folders(end-1))
MEG_Cathegory=string(Slice_folders(end-2))


%% MEG records important details
List_of_Sessions=unique(Spikes_table.SE);
List_mat_files = dir(strcat(Patient_Folder ,'/*.mat'));


for file_k=1:size(List_mat_files,1)
    
    SE_filename=List_mat_files(file_k).name
    %% Get tghe file sessions SE
    C=strfind(SE_filename,'S');
    SE_Num=str2num(SE_filename(C+1));
    FoundSE = any(List_of_Sessions == SE_Num);
    
    if FoundSE==0
        fprintf('\n\n Error: Please check the session SE=%s of the patient=%s. \n These recordes have not been  mentionned in spikes Excel sheet!!!\n\n',SE_Num,SE_filename)
        break;
    else
    
        Session_folder=List_mat_files(file_k).folder;
        cname=strcat(Session_folder,'\', SE_filename);   
        load(cname); 
        matObj = matfile(cname);info = whos(matObj);
        eval(strcat('MEG=',info.name,';'))
    %% Get the recordes saved  in MEG.F
    
        Data_SE=MEG.F;
        
     % get Only the data from specific channls mentionned in Xlsx file
%         Data_SE=Data_SE(any(Data_SE,2),:);  % remove zero masearments

        CH=unique(Spikes_table.SENSOR); Nb_CHs=max(size(CH));

        if Nb_CHs==1 
            eval(strcat('Selected_CHs=MEGChannels.',string(CH),';'))

        else
            
            fprintf('\n\n Error: The Spikes are detected on diffeent Channels%s  in spikes Excel sheet of the patient =%s  !!!\n\n',string(CH),SE_filename)
        end
        
        
        Data_SE=Data_SE(Selected_CHs(1:24),:);
        
        M=size(Data_SE,1);

        if exist('Xsp','var') == 0 

            Xsp=Data_SE;N0=size(Data_SE,2);
            y_SE=SE_Num*ones(M,1);
           
            y_CH=genrate_word_vector(M,string(CH));
           

        else
         %% get the session with the same size
            N0=min(size(Data_SE,2),size(Xsp,2));
            Xsp=Xsp(:,1:N0);
            Xsp=[ Xsp; Data_SE(:,1:N0)];
            y_SE=[y_SE;SE_Num*ones(M,1)];
            y_CH=[y_CH; genrate_word_vector(M,string(CH))];


        end   
        
        

       
    end
    
    
end


function y_CH=genrate_word_vector(N,word)


for k=1:N
    
    y_CH(k)=word;
   

end

y_CH=categorical(y_CH)';
d=1;



