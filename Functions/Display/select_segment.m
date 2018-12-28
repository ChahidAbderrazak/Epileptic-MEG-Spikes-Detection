
figure();
plot(y,'b', 'LineWidth',3);hold on
plot(yr,'g','LineWidth',2);hold on
A=legend('Input signal','Reference signal','Reconstructed signal');
A.FontSize=14;
title('Select the segments');
xlabel('ppm')
