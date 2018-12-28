%% Save figr figure in pdf and fig format 
%Results_path : path to save results
% figr  :  figrure number
% name  : file name to be saved

function save_figure(Results_path,figr,name)  
            Results_path_pdf=strcat(Results_path,'/pdf_format/');
                if exist(Results_path_pdf)~=7
                    mkdir(Results_path_pdf);
                end
                
            Results_path_fig=strcat(Results_path,'/figures_format/');
                if exist(Results_path_fig)~=7
                    mkdir(Results_path_fig);
                end     
%set(figure(figr),'units','normalized','outerposition',[0 0 1 1])

          %% save . fig files           
                   set(figure(figr),'PaperOrientation','landscape');
                   set(figure(figr),'PaperUnits','normalized');
                   set(figure(figr),'PaperPosition', [0 0 1 1]);
                   print(figure(figr), '-dpdf',strcat(Results_path_pdf,name,'.pdf'))
            

            saveas(figure(figr),strcat(Results_path_fig,name,'.fig'))
            
end

