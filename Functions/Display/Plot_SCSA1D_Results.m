

    
if factor==1      
     [h,yscsa,Nh] = SCSA_1D(y,fs,h,gm);
     N0=max(size(y));
else
    y_up=up_sampling(y,factor, type_upsample);
    [h,yscsa_up,Nh] = SCSA_1D(y_up,fs,h,gm);
    yscsa=down_sampling(yscsa_up,factor);
    N0=max(size(y_up));
end

[PSNR0  PSNR_peak10 PSNR_peak20]= Evaluate_sig_result(y,yr,peak1,peak2);
[PSNR  PSNR_peak1 PSNR_peak2]= Evaluate_sig_result(yscsa,yr,peak1,peak2); 

figure(figr);
plot(t,y,'b', 'LineWidth',3);hold on
plot(t,yr,'g','LineWidth',2);hold on
plot(t,yscsa,'r', 'LineWidth',2);hold on
A=legend('Input signal','Reference signal','Reconstructed signal');
A.FontSize=14;
title(strcat('The optimal reconstructed signal:  h=',num2str(h),' , PSNR=',num2str(PSNR),' , PSNR1=',num2str(PSNR_peak1),' , PSNR2=',num2str(PSNR_peak2),' , Nh=',num2str(Nh),' , N=',num2str(N0)));
xlabel('ppm')
ylabel(strcat(num2str(factor),'  Upsampled [ ',type_upsample ,'  ] '))


% %% Save results  
% Results_path='./Results_Upsampling';
% name=strcat('Upsumbling_MRS_',num2str(factor));
% save_figure(Results_path,figr,name);
% 
% 
% xlim([0.8 2.3])
% name=strcat('Upsumbling_MRS_',num2str(factor),'_Zoom');
% save_figure(Results_path,figr,name);
