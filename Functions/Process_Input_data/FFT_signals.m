function [Y, f]=FFT_signals(X,fs)
X=X';    %Transform feature to columns
L=size(X,1);
f = fs*(0:(L/2))/L;

X_fft = fft(X);
P2 = abs(X_fft/L);
P1 = P2(1:L/2+1,:);
P1(2:end-1,:) = 2.*P1(2:end-1,:);
Y=P1'; %Transform back  feature to rows

d=1;