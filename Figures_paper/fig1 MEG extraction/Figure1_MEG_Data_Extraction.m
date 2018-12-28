
Spike_stops_i=Spike_stops(Sig2study);Spike_startes_i=Spike_startes(Sig2study); Time_spike_i=Time_spike(Sig2study);
 
%% Plot the Two lectrodes signals Spike_startes
figr=figr+1;figure(figr);
plot(t,y0), hold on;
plot(t,y), hold off;
ylim([0.2 1.3])
h1 = vline(Time_spike_i,'k','Spike time '); hold off;

lgnd_spikes{counter}=strcat('The electrode ',num2str(Sig2study));
xlabel('Time(s)')
ylabel('Normalizaed Intensity')
xlim([t(1) t(end)])
% A=legend(lgnd_spikes(Sig2study));
A=legend(' Signal without Spikes [Negative]',' Signal with Spikes [Positive]' );
A.FontSize=14;
title(strcat('The  MEG signal:  Electrode=   ',num2str(Sig2study) ,', Healthy= ',original_file,' ,  Non-Healthy= ',noisy_file ));
set(gca,'fontsize',16)



Sig2study
% create a zoom metabolites
axes('position',[.25 .60 .56 .2])
box on % put box around new pair of axes
indexOfInterest = (t <=Spike_stops_i) & (t >=Spike_startes_i); % range of t near perturbation

plot(t(indexOfInterest),y0(indexOfInterest), 'LineWidth',2);hold on
plot(t(indexOfInterest),y(indexOfInterest), 'LineWidth',2);hold on
h2 = vline([Spike_startes_i Time_spike_i Spike_stops_i],{'r','k','r'},{'Detection Start','Spike time','Detection  Stop'});
title(strcat('The Spikes event [Zoom]'))

set(gca,'fontsize',16)

% 
% %% Plot the small slot to study 
% figr=figr+1;figure(figr);
% plot(t,y0, 'LineWidth',1.2);hold on
% plot(t,y, 'LineWidth',1.2);hold on
% h2 = vline([Spike_startes_i Time_spike_i Spike_stops_i],{'r','k','r'},{'Start','Spike time','Stop'});
% title(strcat('The Spikes event [Zoom]'))
% 

%% Save The figures
% name=strcat('Spikes',SE_case,'_electrode',num2str(Sig2study),'_Slot');
% save_figure(Results_path,figr,name) 
