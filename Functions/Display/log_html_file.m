%% Open an HTML file to write the output into
filename_display = './Functions/LogTasks_Abdo.html';
if exist(filename_display, 'file') == 2
delete(filename_display)
end
fid_display = fopen(filename_display, 'wt');
fprintf(fid_display, colorizestring('red', ' <br/>  <font size="+1.2"> Spikes Detection for Epyliptic sigal Project 2018'));web(filename_display);
