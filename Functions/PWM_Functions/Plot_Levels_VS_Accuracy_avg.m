function  Plot_Levels_VS_Accuracy_avg(list_k,list_M,Accuracy_list,figr)

%% plot the levels VS average accuracy  
% close all
% plots
figure(figr);  
for m=1:size(Accuracy_list,1)
 plot(list_k,Accuracy_list(m,:) ,'LineWidth',2); hold on
 lgnd{m}=strcat('Number of levels M=',num2str(list_M(m)));
end
 
A=legend(lgnd);
A.FontSize=14;

title('Levels of Quantification  VS Average accuracy ');
xlabel({'Levels resolution $\mathbf{r}$'},'Interpreter','latex')
ylabel('Average accuracy ')
set(gca,'fontsize',16)
% ylim([ 0.5 1.3])
pause(0.3)


