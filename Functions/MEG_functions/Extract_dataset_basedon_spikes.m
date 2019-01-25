

%% #################      Extract datset baased on Spikes and frame    #########################
% This script converted the electrodes measure into classifcation dataset based on 
% the pre-knowldge of the spikes location {Spike_stops,Spike_startes,Time_spike}
% and the frame lenght <L_max>,  step<Frame_Step> and
% the number of electrodes to be used  <CHs>

%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@kasut.edu.sa)
% Done: Jan,  2019
%  
%% ###########################################################################
function [DataX,CHs,ID_patient,ID_SE,L_max]=Extract_dataset_basedon_spikes(MEG_patient,L_max, Frame_Step,t, X, y_SE, Spikes_table,fs)

% Shortest_spike=floor(min(Spikes_table.SpikeStop-Spikes_table.SpikeStart)*fs)
% if L_max>Shortest_spike
%     L_max=Shortest_spike;
% end

% Spike_stops,Spike_startes,Time_spike

% for Spik2study=1:size(Spike_stops,1)
% 
%     Spike_stops_i=Spike_stops(Spik2study);
%     Spike_startes_i=Spike_startes(Spik2study); 
%     Time_spike_i=Time_spike(Spik2study);
%     spiky_area = find((t <=Spike_stops_i) & (t >=Spike_startes_i)); 
% 
% end


% Get the spikes for the specific session SE

List_of_Sessions=unique(y_SE);%(Spikes_table.SE);
    
cnt=1;

for Session=List_of_Sessions'
    
    
    %% Get the data and spikes for each session
    % Spikes
    Idx_spk=find(Spikes_table.SE==Session);
        
    Time_spike=Spikes_table.TIME(Idx_spk);
    Spike_startes=Spikes_table.SpikeStart(Idx_spk);
    Spike_stops=Spikes_table.SpikeStop(Idx_spk);

    
    % Electrodes
    Idx_Measure=find(y_SE==Session);
    X_SE=X(Idx_Measure,:);
    

    for Spik2study=1:size(Spike_stops,1)


        Spike_startes_i=Spike_startes(Spik2study); 
        Spike_stops_i=Spike_stops(Spik2study);

        Sp0 = max(find(t <=Spike_startes_i)); % initial index of the spike
        Sp1 = max(find(t <Spike_stops_i));   % final index of the spike

        sz_spike=Sp1-Sp0

        if sz_spike>0
            
            %% Sliding frame of size <Frame_Step>
            for Sp=[Sp0 Sp0+Frame_Step:Frame_Step:Sp1-L_max+1]

                spiky_area=Sp:Sp+L_max-1;

                X_New=[];

                CHs=1:size(X_SE,1) ;
                for Electrode=CHs
                    Xn=X_SE(Electrode,spiky_area);
                    X_New=[X_New Xn]; 

                    d=1;
                end   

                DataX(cnt,:)=X_New;

                %% Other details
                ID_patient(cnt)=MEG_patient; 
                ID_SE(cnt)= Session; 

                cnt=cnt+1;           

                clearvars X_New 
            end

        end

    end
    
end
    
d=1;
% CHs=1:size(X_SE,1);
ID_patient=ID_patient';
ID_SE = ID_SE'; 