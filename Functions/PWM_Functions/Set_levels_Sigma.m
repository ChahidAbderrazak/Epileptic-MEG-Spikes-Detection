function [Levels, Level_intervals]=Set_levels_Sigma(k,M,mu,sigma0)

Levels= 1:M;
N=M-1;
VECTOR=[-floor(N/2): floor(N/2)];
Level_intervals= mu+k*sigma0*VECTOR; 


d=1;