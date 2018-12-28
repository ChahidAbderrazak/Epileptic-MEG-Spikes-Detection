ind_pos=ind_pos+1;
nb_plot=max(size(factor_list));
y_plot=floor(sqrt(nb_plot));
x_plot=1;
while (x_plot*y_plot<nb_plot)
    x_plot=x_plot+1;
end

[PSNR ]= Evaluate_sig_result(yscsa,y_ref,0,0);
[PSNR0 ]= Evaluate_sig_result(y_input,y_ref,0,0);

%% Plotes 
figure(999);
subplot(x_plot,y_plot,ind_pos)
plot(t,y_input,'b', 'LineWidth',3);hold on
plot(t,yscsa,'r', 'LineWidth',2);hold on
A=legend('Input signal','Reconstructed signal');
A.FontSize=14;
title(strcat('h^*=',num2str(h),' , PSNR0=',num2str(PSNR0),' , PSNR=',num2str(PSNR)));
xlabel('ppm')

[PSNR_up , PSNR_peak1_up, PSNR_peak2_up]= Evaluate_sig_result(yscsa_up,yref_up,peak1,peak2);

figure(998);
subplot(x_plot,y_plot,ind_pos)
plot(t_up,y_up,'b', 'LineWidth',3);hold on
plot(t_up,yref_up,'g','LineWidth',2);hold on
plot(t_up,yscsa_up,'r', 'LineWidth',2);hold on
A=legend('Input signal','Reference signal','Reconstructed signal');
A.FontSize=14;
title(strcat('h^*=',num2str(h),' , PSNR=',num2str(PSNR_up),' , PSNR1=',num2str(PSNR_peak1_up),' , PSNR2=',num2str(PSNR_peak2_up),' , Nh=',num2str(Nh),' , N=',num2str(N0)));
xlabel('ppm')
ylabel(strcat(num2str(factor),'  Upsampled [ ',type_upsample ,'  ] '))


