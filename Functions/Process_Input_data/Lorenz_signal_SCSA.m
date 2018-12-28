% this code is for processing 2 peaks signals which max is modified to 100
clear all;
close all ;
addpath ./Functions
global y fe feh M D psinnor
hh = 3000; %6:1:25;   

% Generate signals

Load_data


%Mohamed:we use these variables to solve the numerical problem of
%eigenvalues
M = length(y);
fe = 1;
feh = 2*pi/M;
D = delta(M,fe,feh);

yscsa=scsa(h);%Mohamed:we compute the reconstructed signal for hopt

% plot the optimal results
plot_MRS_Water_sig

%Calculate the different errors
   peak1=1:750;
   peak2=750:1024;
   
   PSNR1=psnr(y,yr)  %% the error between the input signal(the signal with two peaks) and the reference signal
   PSNR2=psnr(yws,y) %% the error between the input signal(the signal with two peaks) and the watter suppressed signal
   PSNR3=psnr(yr,yws) %% the error between the reference signal and the watter suppressed signal(most interesting)
   PSNR4_peak2_=psnr(yr(peak2),y(peak2))
   PSNR4_peak2_found=psnr(yr(peak2),yws(peak2))
   PSNR5_peak1_=psnr(yr(peak1),yws(peak1))
   
figure();
plot(psinnor)
title('The L^2 normalized eigenfunctions of the Schrodinger operator','FontSize',16);
  xlabel('temps')
  ylabel('Amplitude')
m1 = 1;
m2 = 150;

a1= 1;
b1= 750;
a2= 750;
b2= 1024;
  % integral of the peaks for the water supressed signal

p1_yws = simp(yws(a1:b1),fe)
p2_yws = simp(yws(a2:b2),fe)


% integral of the peaks for the priginal signal
p1_y = simp(y(a1:b1),fe)
p2_y  = simp(y(a2:b2),fe)
   %}
%  [yws,kappa,psinnor,Nh] = ws_scsa(h);
 %{
 supress=1;
 % plot the optimal results
plot(t,y,'b', 'LineWidth',2);hold on
  if supress==0
  plot(t,yscsa,'r', 'LineWidth',1);hold on
   A=legend('Input signal','Reconstructed signal')

  else
  plot(t,yr,'g','LineWidth',3);hold on
  plot(t,yws,'k','LineWidth',2);hold on
   A=legend('Input signal','Reference signal','Water suppressed signal')

  end
  A.FontSize=14;
 title('Estimated and reconstructed Lorentz signals with h=14.7 ','FontSize',16);
 xlabel('Time')
 ylabel('Amplitude')

  %Calculate the different errors
   PSNR1=psnr(y,yr)  %% the error between the input signal(the signal with two peaks) and the reference signal
   PSNR2=psnr(yws,y) %% the error between the input signal(the signal with two peaks) and the watter suppressed signal
   PSNR3=psnr(yr,yws) %% the error between the reference signal and the watter suppressed signal(most interesting)

supress=1;   
%}

    %{
   count=0;
   gm=0.5;
   optimal_peak1=-inf;
   optimal_peak2=-inf;
   optimal_PSNR3=-inf;
   
for i=2
   vect0=pick(1:4,i,'o');

  
     for j=1:max(size(vect0)) 
     
    count=count+1;
    
    vect_kn=zeros([Nh 1])%Mohamed:Nh lines and 1
    %vect=vect0(j,:);
    %vect_kn(vect)=1;
    [ yws] = ws_sub_scsa(h,gm,kn,psinnor, vect_kn);
     
   %}
 %{   
    PSNR0_vect(count)= PSNR3 ;  
    PSNR_peak1_vect(count)= PSNR_peak1 ;
    PSNR_peak2_vect(count)= PSNR_peak2; 

    if optimal_peak1 <PSNR_peak1
        comb_optimal0=vect_kappa;
        optimal_PSNR=PSNR3;
    end
    if optimal_PSNR3 <PSNR3
        comb_optimal1=vect_kn;
        optimal_peak1=PSNR_peak1;

    end

    if optimal_peak2 <PSNR_peak2
        comb_optimal2=vect_kn;
        optimal_peak2=PSNR_peak2;
    end

     end
   count 
     
end
 
ind= find(comb_optimal0>0)
optimal_PSNR

ind= find(comb_optimal1>0)

optimal_peak1

ind= find(comb_optimal2>0)

optimal_peak1
        

[ yws] = ws_sub_scsa(h,gm,  kappa, psinnor, comb_optimal0);
%}