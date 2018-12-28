 close all

%% normalization

% Y0=Y0-min(min(Y0));
% Y=Y-min(min(Y));

%% Take one Slot for study
Spikes=find(t>Spike_startes & t<=Spike_stops);
N_spike=max(size(Spikes));

% for Spik2study=1:size(Spike_stops,1)
% 
%     Spike_stops_i=Spike_stops(Spik2study);
%     Spike_startes_i=Spike_startes(Spik2study); 
%     Time_spike_i=Time_spike(Spik2study);
%     spiky_area = find((t <=Spike_stops_i) & (t >=Spike_startes_i)); 
% 
%     slot=spiky_area(1):spiky_area(1)+10;
% %     slot=spiky_area;
%     t1=t(slot);
% 
% 
%     for elctrode=1
% 
%         y=sort(Y(elctrode,slot));
%         y0=sort(Y0(elctrode,slot));
% 
%         %% plot the spikes region in all electrodes
% %         figure(2*(Spik2study-1)+1);
%         figure(1);
%         plot(t1,y,'r');hold on  % Spikes
% %         figure(2*(Spik2study-1)+2);
%         plot(t1,y0,'k');hold on % non_Spikes
% %         legend('y','y0')
% 
%     end
%     
%     pause(0.3)
%  
% end

y=0
y0=0
 for elctrode=1
        for n=1:max(size(Spike_startes))%1:99:Spike_startes(end)% size(Y0,2)
             
            spiky_area = find((t <=Spike_startes(n)) ); 
            SP0=spiky_area(end)
            slot=SP0-50:SP0+50;   
            y=[y mean(Y(elctrode,slot))];
            y0=[y0 mean(Y0(elctrode,slot))];

%             y=(Y(elctrode,slot));
%             y0=(Y0(elctrode,slot));
            

    end
 end
               

%% plot the spikes region in all electrodes
figure(2);
    plot(y,'r');hold on  % Spikes
%         figure(2*(Spik2study-1)+2);
    plot(y0,'k');hold on % non_Spikes
%         legend('y','y0')
        
 
% %% plot the spikes region in all electrodes
% 
%     close all; figure(3);
%         plot(t,Y(:,:));hold on  % Spikes
% %         plot(t,Y0(:,:),'k');hold on % non_Spikes
%         vline(Spike_startes,'g')
%         vline(Spike_stops,'b')
% 
% 
% %         legend('y','y0')
% 

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        


