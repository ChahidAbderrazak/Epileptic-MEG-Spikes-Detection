function [Miers_Seq,name_Miers]=Extract_Miers2(Input_sequence,levels)

Input_sequence = double(Input_sequence); [M, N]=size(Input_sequence);

 N_levels=size(levels,2);
% Assign to each level a letter
Seq_letter=char([65:90 97:122  char(194:194+N_levels-52) ]); N_letters=size(Seq_letter,2); %   or Seq_letter='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'    

% start the scanning
k=0;
for N1=1:N_levels
    for N2=1:N_levels
        k=k+1; J_Miers=[N1,N2];
        name_Miers{k}=strcat(Seq_letter(N1),Seq_letter(N2));
        
        for i=1:M
            for j=1:N-1

                Mier=[Input_sequence(i,j), Input_sequence(i,j+1)];

                if norm(Mier-J_Miers)==0

                    Miers_Seq(i,j,k)=1;

                else
                    Miers_Seq(i,j,k)=0;
                end
                
            end 

        end
    end
end
