rng default

Fs = N;
% t = linspace(0,1,Fs);

Hd = designfilt('lowpassfir','FilterOrder',20,'CutoffFrequency',150, ...
       'DesignMethod','window','Window',{@kaiser,3},'SampleRate',Fs);
   
img0 = filter(Hd,img0);
img = filter(Hd,img);
noisy_img = filter(Hd,noisy_img);



% 
% plot(t,y,t,y1)
% xlim([0 0.1])
% 
% xlabel('Time (s)')
% ylabel('Amplitude')
% legend('Original Signal','Filtered Data')
