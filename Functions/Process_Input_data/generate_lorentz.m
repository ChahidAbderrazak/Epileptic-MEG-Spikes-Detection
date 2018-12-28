function  [lorentz, f ]=generate_lorentz(N,T2,amp,tau,freq)


for j=1:length(T2)
% Temporel signal 
for l=1: N 
    lorentz(l) = amp*(tau)/(1-i*((2*pi/N)*(freq-5*l))*(tau)); 
end
end

f= 0:0.01:(N-1)*0.01;

lorentz=real(lorentz);


% function  [y, f ]=generate_lorentz(N,T2,amp,tau,freq,amp2,freq2)
% 
% 
% for j=1:length(T2)
% % Temporel signal 
% for l=1: N 
% %     lorentz(l) = amp*(tau)/(1-i*((2*pi/N)*(freq-5*l))*(tau)); 
%  lorentz(l) = amp*(tau)/(1-i*((2*pi/N)*(freq-4*l))*(tau)) + amp2*(tau)/(1-i*((2*pi/N)*(freq2-4*l))*(tau)); 
% end
% end
% 
% f= 0:0.01:(N-1)*0.01;
% 
% y=real(lorentz);
