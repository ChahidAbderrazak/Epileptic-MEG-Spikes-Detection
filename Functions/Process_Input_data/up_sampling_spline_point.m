%this function upsample the y signal in spline form but keep the same
%original point
% Example:
%         factor=3
%         y=1:5
%         y_up=up_sampling_spline_point(y,factor)
%         N=max(size(y_up))

function y_up=up_sampling_spline_point(y,factor)
N=max(size(y));
y_up(1)=y(1);
for i=1:N-1
yi=y(i:i+1);

X =  linspace(0,1,numel(yi));
Xi = linspace(0,1,factor+1);
y_upi = interp1(X, yi, Xi, 'spline');
y_up=[y_up y_upi(2:end)];
end
y_up(1:factor:end)=y;
end