function Folder_out=GetSubfolder_with_data(Root_folder)

List_files = dir(strcat(Root_folder ,'\*\*.mat'));

cnt=1;Idx=[];
for k=1:size(List_files,1)
    
    C=strfind(List_files(k).name,'1.mat');
    if min(size(C))==1
        Folder_out(cnt)=string(List_files(k).folder);
        cnt=cnt+1;
    end

end

d=1;