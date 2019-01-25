function path_foldr=Paths_to_subFolders(Root_folder)
path_foldr = dir(strcat(Root_folder));
% Get a logical vector that tells which is a directory.
path_foldr=path_foldr(~ismember({path_foldr.name},{'.','..'}));
List_fold=path_foldr.folder;

for k=1:size(path_foldr,1)
    find(path_foldr.folder)
    
    Patient_Class(k)=string(path_foldr(k).name);
end
