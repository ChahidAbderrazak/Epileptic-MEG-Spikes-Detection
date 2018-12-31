function [X,X0,L_max,L_min]=Extract_the_spikes_dataset_Threshold(EN_L, L_max, Frame_Step, EN_b,bmin,bmax,t,Y,Y0,Spike_stops,Spike_startes,Time_spike)
global  Electrode_list

if EN_L==1; L_max=0;end
L_min=size(Y,2);


for Spik2study=1:size(Spike_stops,1)

    Spike_stops_i=Spike_stops(Spik2study);
    Spike_startes_i=Spike_startes(Spik2study); 
    Time_spike_i=Time_spike(Spik2study);
    spiky_area = find((t <=Spike_stops_i) & (t >=Spike_startes_i)); 
    if EN_L==1

            if L_max < max(size(spiky_area))
                L_max = max(size(spiky_area));
            end

    end        
    if L_min > max(size(spiky_area))
        L_min = max(size(spiky_area));
    end


end



cnt=1;

    
for Spik2study=1:size(Spike_stops,1)

    Spike_stops_i=Spike_stops(Spik2study);
    Spike_startes_i=Spike_startes(Spik2study); 

    Sp0 = max(find(t <=Spike_startes_i)); % initial index of the spike
    Sp1 = max(find(t <=Spike_stops_i));   % final index of the spike


    %% Sliding frame of size <Frame_Step>
    for Sp=Sp0-L_max+2:Frame_Step:Sp1+L_max-2

        spiky_area=Sp:Sp+L_max-1;
 
        X_New=[];
        X0_New=[];   
            
        for Electrode=Electrode_list 
            Xn=Y(Electrode,spiky_area);
            Xn0=Y0(Electrode,spiky_area);
            
            X_New=[X_New Xn];
            X0_New=[X0_New Xn0];   
                     
            d=1;
        end   

%             %% Thresholding
%             if  EN_b==1
% 
%             if  (max(bmax<=Xn)  | max(Xn<=bmin))   % (max(bmax<=Xn0)  | max(Xn0<=bmin))
%             X(cnt,:)=Y(Electrode,spiky_area);
%             X0(cnt,:)=Y0(Electrode,spiky_area);    
%             end
% 
%             else
%             X(cnt,:)=Y(Electrode,spiky_area);
%             X0(cnt,:)=Y0(Electrode,spiky_area);    
%             end

            

        
        X(cnt,:)=X_New;
        X0(cnt,:)=X0_New;
        
        cnt=cnt+1;           
        
        clearvars X_New X0_New

end


    
end
d=1;