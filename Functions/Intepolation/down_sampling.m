function y_down=down_sampling(y,factor)
N=max(size(y));
y_down=y(1:factor:N);
end