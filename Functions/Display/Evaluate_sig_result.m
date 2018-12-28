%% Calculate the different errors
function [PSNR  PSNR_peak1 PSNR_peak2]= Evaluate_sig_result(y,yr,peak1,peak2)
[m,n]=size(y);  
[m1,n1]=size(yr);
if m1==n & n1==m
   y=y';
end
PSNR=psnr(y,yr);  

if peak1~=0 | peak2~=0
PSNR_peak1=psnr(y(peak1),yr(peak1));  
PSNR_peak2=psnr(y(peak2),yr(peak2));
else
PSNR_peak1=PSNR;  
PSNR_peak2=PSNR;
end

end