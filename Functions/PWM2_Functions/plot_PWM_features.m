function plot_PWM_features(fPWM_train,fPWM_test,Np)
Np=124;
% close all
figure(125);
scatter(fPWM_train(1:Np,1), fPWM_train(1:Np,2),'r');  hold on
scatter(fPWM_train(Np+1:end,1) , fPWM_train(Np+1:end,2),'k');  hold on
scatter(fPWM_test(1), fPWM_test(2),'b', 'LineWidth',12 );  hold off
legend('Negative Class Training ', 'Positive Class Training ', 'Negative sample tested ')

title('LOO features using PWM projection of the samples')
xlabel('fPWM_1')
ylabel('fPWM_2')

set(gca,'fontsize',16)

end