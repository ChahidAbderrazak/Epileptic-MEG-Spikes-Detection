function f_scal=scaling_function(Amin, Amax, i_0, i_end)



i_size= i_end-i_0;
if mod(i_size,2)==0
i_0=i_0-1;
i_size= i_end-i_0;
end
i_center=floor(i_size/2)+1;
f_scal(1:i_0)=Amin*ones([1 i_0]);
f_scal(i_0+1:i_center+i_0)=scal_sampling([Amin Amax],i_center,'linear'); 
f_scl=scal_sampling([Amax Amin],i_center,'linear');
f_scal(i_center+i_0+1:i_end)=f_scl(2:end);


%this function upsample the y signal in linear form but changes  the 
%original point
function y_up=scal_sampling(y,factor,type_upsample)
newNum=factor;%
X =  linspace(0,1,numel(y));
Xi = linspace(0,1,newNum);
y_up = interp1(X, y, Xi, type_upsample);
