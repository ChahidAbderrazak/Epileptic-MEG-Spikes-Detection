%% Step Log
global t y y0
fprintf(fid_display, colorizestring('blue', ' <br/>  <font size="+0.5">  \t Studying the electrode number %d'),Sig2study);web(filename_display);
%% Frame the signal in unity windows
unit_fun=[0 1];
y=frame2fun(Y(Sig2study,:),unit_fun);
y0=frame2fun(Y0(Sig2study,:),unit_fun);

