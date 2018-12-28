function [X,X0,L_max]=Extract_the_spikes_dataset(t,Y,Y0,Spike_stops,Spike_startes,Time_spike)
L_max=0;
for Sig2study=1:size(Spike_stops,1)
        
    Spike_stops_i=Spike_stops(Sig2study);Spike_startes_i=Spike_startes(Sig2study); Time_spike_i=Time_spike(Sig2study);
    spiky_area = find((t <=Spike_stops_i) & (t >=Spike_startes_i)); 
    
    if L_max < max(size(spiky_area))
       L_max = max(size(spiky_area))
    end
end

cnt=1;
for k=1:size(Y,1)
    for Sig2study=1:size(Spike_stops,1)
        Spike_stops_i=Spike_stops(Sig2study);Spike_startes_i=Spike_startes(Sig2study); Time_spike_i=Time_spike(Sig2study);
        Sp0 = max(find(t <=Spike_startes_i)); % initial index of the spike
        spiky_area=Sp0:Sp0+L_max;
        X(cnt,:)=Y(k,spiky_area);
        X0(cnt,:)=Y0(k,spiky_area);    
        cnt=cnt+1;

    end
end