
%% 
% h=4146.058; factor=4;
y_input=y_obj;
%%  Run the SCSA with the optimal h
y_up=up_sampling(y,factor, type_upsample);
yref_up=up_sampling(y_ref,factor, type_upsample);
t_up=up_sampling(t,factor, type_upsample);
store_decomposition=1;      % store the decomposition for eigenfunctio selection

[h,yscsa_up,Nh] =SCSA_1D_scal(y_up,fs,h,gm,f_scal,param);
store_decomposition=0;      % store the decomposition for eigenfunctio selection
yscsa=down_sampling(yscsa_up,factor);
N0=max(size(y_up));

[PSNR,  PSNR_peak1, PSNR_peak2]= Evaluate_sig_result(yscsa_up,yref_up,peak1,peak2);
[PSNR0]= Evaluate_sig_result(y_up,yref_up,0,0);
N0_n=max(size(yscsa_up));
figr=figr+1;
figure(figr);
plot(t_up,y_up,'b', 'LineWidth',3);hold on
plot(t_up,yref_up,'g','LineWidth',2);hold on
plot(t_up,yscsa_up,'r', 'LineWidth',2);hold on
A=legend('Input signal','Reference signal','Reconstructed signal');
A.FontSize=14;
title(strcat('h^*=',num2str(h),' , PSNR0=',num2str(PSNR0),' , PSNR=',num2str(PSNR),' , PSNR1=',num2str(PSNR_peak1),' , PSNR2=',num2str(PSNR_peak2),' , Nh=',num2str(Nh),' , N=',num2str(N0_n)));
xlabel('ppm')
ylabel(strcat(num2str(factor),'  Upsampled [ ',type_upsample ,'  ] '))


%% Save results  
name=strcat('Upsampling_MEG_',post_save_tag);
save_figure(Results_path,figr,name);

close(figure(figr))
% 
% if factor > 1
% 
% %% ######## The Upscalaed version #############
% 
% peak10=(peak_1(1):peak_1(2));peak20=(peak_2(1):peak_2(2));
% [PSNR0,  PSNR_peak10, PSNR_peak20]= Evaluate_sig_result(yscsa,y_ref,peak10,peak20);
% [PSNR00]= Evaluate_sig_result(y_input,y_ref,0,0);
% N0_n=max(size(yscsa));
% 
% %%plots 
% figr=figr+1;
% figure(figr);
% plot(t,y_input,'b', 'LineWidth',3);hold on
% plot(t,y_ref,'g','LineWidth',2);hold on
% plot(t,yscsa,'r', 'LineWidth',2);hold on
% A=legend('Input signal','Reference signal','Reconstructed signal');
% A.FontSize=14;
% title(strcat('h^*=',num2str(h),' , PSNR0=',num2str(PSNR00),' , PSNR=',num2str(PSNR0),' , PSNR1=',num2str(PSNR_peak10),' , PSNR2=',num2str(PSNR_peak20),' , Nh=',num2str(Nh),' , N=',num2str(N0_n)));
% xlabel('ppm')
% ylabel(strcat(num2str(factor),'  Upsampled [ ',type_upsample ,'  ] '))
% 
% 
% %% Save results  
% name=strcat('Downsampling_MRS_',post_save_tag);
% save_figure(Results_path,figr,name);
% 
% xlim([0.8 2.3])     %% Zomming Metabolates  peaks
% 
% name=strcat('Downsampling_MRS_',post_save_tag,'_zoom');
% save_figure(Results_path,figr,name);
% close(figure(figr))
% 
% end


% %% Scaling down by the  the scaling function 
% figr=figr+1
% yscsa_s=yscsa./f_scal;
% % y_s=y./f_scal;
% 
% 
% [PSNR  PSNR_peak1 PSNR_peak2]= Evaluate_sig_result(yscsa_s,y_input,peak1,peak2);
% [PSNR0  ]= Evaluate_sig_result(y_ref,y_input,peak1,peak2);
% 
% figure(figr);
% plot(t,y,'b', 'LineWidth',3);hold on
% plot(t,yr,'g','LineWidth',2);hold on
% plot(t,yscsa_s,'r', 'LineWidth',2);hold on
% 
% A=legend('Input signal','Reference signal','Reconstructed signal');
% A.FontSize=14;
% title(strcat('Scaled Down results with :  h=',num2str(h),' , PSNR=',num2str(PSNR),' , PSNR1=',num2str(PSNR_peak1),' , PSNR2=',num2str(PSNR_peak2),' , Nh=',num2str(Nh),' , N=',num2str(N0)));
% xlabel('ppm')
% ylabel(strcat(num2str(factor),'  Upsampled [ ',type_upsample ,'], Scaling Function[', type_scaling, '  ] '))
% % 
% 
% 
% %% Save results  
% name=strcat('Scaling_',type_scaling,'_Upsumbling_MRS_',num2str(factor));
% save_figure(Results_path,figr,name);
% 
% %% Zoomed area Scaling down by the  the scaling function 
% figr=figr+1
% figure(figr);
% plot(t,y,'b', 'LineWidth',3);hold on
% plot(t,yr,'g','LineWidth',2);hold on
% plot(t,yscsa_s,'r', 'LineWidth',2);hold on
% 
% A=legend('Input signal','Reference signal','Reconstructed signal');
% A.FontSize=14;
% title(strcat('Scaled Down results with :  h=',num2str(h),' , PSNR=',num2str(PSNR),' , PSNR1=',num2str(PSNR_peak1),' , PSNR2=',num2str(PSNR_peak2),' , Nh=',num2str(Nh),' , N=',num2str(N0)));
% xlabel('ppm')
% ylabel(strcat(num2str(factor),'  Upsampled [ ',type_upsample ,'], Scaling Function[', type_scaling, '  ] '))
% % 
% xlim([0.8 2.3])
% name=strcat('Scaling_',type_scaling,'_Upsumbling_MRS_',num2str(factor),'_Zoom');
% save_figure(Results_path,figr,name);
% 
% close(figure(figr))