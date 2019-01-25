function Pure_xlsx=Spikes_remove_analyzed(List_files)

cnt=1;Idx=[];
for k=1:size(List_files,1)
    
    C=strfind(List_files(k).name,'a.xlsx');
    C2=strfind(List_files(k).name,'~');


    if min(size(C))==0 && min(size(C2))==0
        Idx(cnt)=k; cnt=cnt+1;
    end

end

Pure_xlsx=List_files(Idx);
d=1;