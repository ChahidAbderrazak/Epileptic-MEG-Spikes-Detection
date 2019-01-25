function A_N=normalize_PWD_matrix(Mp,row, A)

[K,R]=size(A);

if row==1
    s_norm=sum(A');
    
    for i=1:K
        
        if sum(A(i,:))>0
            A_N(i,:)=A(i,:)./s_norm(i);
        else
            A_N(i,:)=A(i,:);
        end
    end
    
else
    
    for i=1:K
         A_N(i,:)=A(i,:)./Mp;
    end
end

end