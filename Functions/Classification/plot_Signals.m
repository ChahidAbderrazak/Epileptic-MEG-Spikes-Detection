function plot_Signals()
global t y y0
%% Plot Signals
figure;
plot(t,y,'b', 'LineWidth',1.7);hold on
plot(t,y0,'r', 'LineWidth',1.7);hold on
A=legend('Non-Healthy MEG',' Healthy MEG');
A.FontSize=16;
xlabel('Time (s)')

