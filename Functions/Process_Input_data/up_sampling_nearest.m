function y_up=up_sampling_nearest(y,factor)
N=max(size(y));
newNum=factor*N;
X =  linspace(0,1,numel(y));
Xi = linspace(0,1,newNum);
y_up = interp1(X, y, Xi, 'nearest');
end