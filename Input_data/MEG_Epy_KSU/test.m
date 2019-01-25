close all;
Idx_SE=find(Spikes_table.SE==SE_Num)
Start_spikes_time=Spikes_table.SpikeStart(Idx_SE)
Stop_spikes_time=Spikes_table.SpikeStop(Idx_SE)

figure;
    plot(Time,Xsp(1:5,:), 'LineWidth',2 ); hold on;% ylim([-1.5e-10 2E-10])
    vline(Start_spikes_time,'g') ; hold on   
    vline(Stop_spikes_time,'r') ; hold on   


     legend('Positive  Class  ')%, 'Negative Class  ')
     
    title(strcat(noisy_file, {' '}, 'Electrods: ',num2str(Electrode_list),', L=', num2str(L_max), ',Step=', num2str(Frame_Step) ))
    xlabel('samples')
    ylabel('Intensity')
    % ylim([-1.5e-10 2E-10])
    set(gca,'fontsize',16)