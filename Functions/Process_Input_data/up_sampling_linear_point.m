%this function upsample the y signal in linear form but keep the same
%original point
% Example:
%         factor=3
%         y=1:5
%         y_up=up_sampling_linear_point(y,factor)
%         N=max(size(y_up))

function y_up=up_sampling_linear_point(y,factor)
N=max(size(y));
y_up(1)=y(1);
for i=1:N-1
yi=y(i:i+1);

X =  linspace(0,1,numel(yi));
Xi = linspace(0,1,factor+1);
y_upi = interp1(X, yi, Xi, 'linear');
y_up=[y_up y_upi(2:end)];
end



end