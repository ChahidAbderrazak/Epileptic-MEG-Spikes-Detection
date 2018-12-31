%% Save figr figure in pdf and fig format 
%Results_path : path to save results
% figr  :  figrure number
% name  : file name to be saved

function save_figure(Results_path,figr,name)  
                 if exist(Results_path)~=7
                    mkdir(Results_path);
                end

set(figure(figr),'units','normalized','outerposition',[0 0 1 1])

          %% save . fig files           
                   set(figure(figr),'PaperOrientation','landscape');
                   set(figure(figr),'PaperUnits','normalized');
                   set(figure(figr),'PaperPosition', [0 0 1 1]);


%% pdf
print(figure(figr), '-dpdf',strcat(Results_path,name,'.pdf'))
%% .fig
saveas(figure(figr),strcat(Results_path,name,'.fig'))
            
end

