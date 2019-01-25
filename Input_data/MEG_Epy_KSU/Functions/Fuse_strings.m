function s_cat=Fuse_strings(noisy_file)


s_cat=[];

for k=1:size(noisy_file,1)
    
    s_cat=strcat(s_cat,noisy_file(k));
end
d=1;