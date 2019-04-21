
% clearvars  -except X
% load('G:\My Drive\MyCodes\GitHub\InProcess_Projects\Epileptic-MEG-Spikes-Detection\Classification_results\SCSA\SCSA_features0.0001.mat')
% Xh0=Xh;Nh0=Nh_all;
% load('G:\My Drive\MyCodes\GitHub\InProcess_Projects\Epileptic-MEG-Spikes-Detection\Classification_results\SCSA\SCSA_features0.1.mat')
% Xh1=Xh;Nh1=Nh_all;
% load('G:\My Drive\MyCodes\GitHub\InProcess_Projects\Epileptic-MEG-Spikes-Detection\Classification_results\SCSA\SCSA_features500.mat')
% Xh500=Xh;Nh500=Nh_all;
% save('X_Reconstruction_h0.0001_500.mat','X','Xh0','Xh1','Xh500','Nh0','Nh1','Nh500','y')

load('X_Reconstruction_h0.0001_500.mat')
Err=X-Xh0; 

RMSE=[vecnorm((X-Xh0)')' , vecnorm((X-Xh1)')' ,vecnorm((X-Xh500)')' ];
Nh_star=[Nh0 Nh1 Nh500];

h_list=[0.0001 0.1 500];
Acc_list=[90.88 90.88 88.46];

close all

cnt=0;cnt0=0;

figr=10;

figure(figr);
for k=1:3
    subplot(2,1,1);
    plot(RMSE(1:1551,k),'LineWidth',2); hold on
    cnt=cnt+1;lgnd{cnt}= strcat('Positive Class with h=', num2str(h_list(k)))
    plot(RMSE(1552:end,k),'LineWidth',2); hold on
    cnt=cnt+1;lgnd{cnt}= strcat('Negative Class with h=', num2str(h_list(k)));
    legend(lgnd);
    title('The reconstruction error for positive/negative classes')
    xlabel('Frames [signals]')
    ylabel('RMSE')
    set(gca,'fontsize',16)

    
    subplot(2,1,2);
    plot(Nh_star(:,k),'LineWidth',2); hold on
    cnt0=cnt0+1;lgnd0{cnt0}= strcat('Mean(N_h)=', num2str(mean(Nh_star(:,k))), ' at h=', num2str(h_list(k)));
    legend(lgnd0);
    title('The Number of eigenfunction used for reconstruction')
    xlabel('Frames [signals]')
    ylabel('N_h')
    set(gca,'fontsize',16)
end
savefig(figure(figr),'RMSE_h_VS_NH.fig' ) 

Nh_list=mean(Nh_star);
cntf=0;
kh=0;
for h=[0 1 500]
    eval(['Xh_k=Xh',num2str(h),';']);
    kh=kh+1; 
    figure(kh);sbplt=0;
    for k=[124  960   1470 1125]
        cnt=0;
        cntf=cntf+1 ;sbplt=sbplt+1; 
        subplot(2,2,sbplt);
        
        plot(normalize(X(k,:)),'LineWidth',2); hold on
        cnt=cnt+1;lgnd{cnt}= strcat('Xp');
        plot(normalize(Xh_k(k,:)),'LineWidth',2); hold on
        cnt=cnt+1;lgnd{cnt}= strcat('Xp_{h}');
               
        plot(normalize(X(k+1551,:)),'LineWidth',2); hold on
        cnt=cnt+1;lgnd{cnt}= strcat('Xn');
        plot(normalize(Xh_k(k+1551,:)),'LineWidth',2); hold on
        cnt=cnt+1;lgnd{cnt}= strcat('Xn_{h}');
        legend(lgnd);
        title(strcat('X_{',num2str(k),'}:  h=', num2str(h_list(kh)) ,', Nh=', num2str(Nh_list(kh)) ,' , Acc=', num2str(Acc_list(kh))))
        xlabel('samples')
        ylabel('Intensity')
        set(gca,'fontsize',16)
        

    end
    % Save figure
     savefig(figure(kh),strcat('Rec_h',num2str(h_list(kh)),'_Acc_',num2str(Acc_list(kh)),'.fig') )

end
