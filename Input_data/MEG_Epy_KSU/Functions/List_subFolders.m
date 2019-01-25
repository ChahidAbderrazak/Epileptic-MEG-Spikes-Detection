function Patient_Class=List_subFolders(Root_folder)
folder = dir(strcat(Root_folder));
% Get a logical vector that tells which is a directory.
dirFlags = [folder.isdir];
% Extract only those that are directories.
folder = folder(dirFlags);
folder=folder(~ismember({folder.name},{'.','..'}));

for k=1:size(folder,1)
    Patient_Class(k)=string(folder(k).name);
end
