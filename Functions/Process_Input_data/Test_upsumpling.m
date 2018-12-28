figure;
subplot(211)
plot(y,'r');
xlim([1 max(size(y))])
legend(' Original signal')
subplot(212)
plot(y_up,'k');
xlim([1 max(size(y_up))])
legend(' 4X Upsumpled  signal')
