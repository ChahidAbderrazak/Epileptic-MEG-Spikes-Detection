figure();
plot(t,y,'b', 'LineWidth',3);hold on
%plot(t,yr,'g','LineWidth',2);hold on
plot(t,yscsa,'r', 'LineWidth',2);hold on
plot(t,yws,'k','LineWidth',3);hold on
A=legend('Input signal','Reference signal','Reconstructed signal','Water suppressed signal');
A.FontSize=14;
title('Estimated and reconstructed signals with h=3000 and PSNR=-108.7348');
xlabel('PPM')
ylabel('Amplitude')
