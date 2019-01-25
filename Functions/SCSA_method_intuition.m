   cnt=1; 
   lgnd{1}='Input signal';
   
for Idx=[1 5 10 15]
    h=op_combinaison.h(Idx);
    
[F_SCSA_h1(cnt,:), S_SCSA_h1, B_SCSA_h1, P_SCSA_h1,AF_SCSA_h1,SFP_SCSA_h1,SK_features_h1,Nh_all(cnt)]=SCSA_Transform_features(X,y,h,gm,fs);
 cnt=cnt+1;lgnd{cnt}=strcat('Reconstructed signal h=',num2str(h), ' h=',num2str(Nh_all(cnt-1)), ' Acc=',num2str(op_combinaison.Accuracy(Idx )));
end


close all
figr=44;figure(figr);
    plot(X,'k', 'LineWidth',3 ); hold on;% ylim([-1.5e-10 2E-10])
    plot(F_SCSA_h1', 'LineWidth',3 ); hold on;% ylim([-1.5e-10 2E-10])

    legend(lgnd)%, 'Negative Class  ')
    title('SCSA Method ')
    xlabel('samples')
    ylabel('Intensity')
    % ylim([-1.5e-10 2E-10])
    set(gca,'fontsize',16)
    
%     %% save the figure of te used data
%     name=strcat(num2str(size(X,1)),'_','_',num2str(size(X,2)),'_',noisy_file,suff);
%     save_figure(data_path,figr,name) 
close all