%
function [z, num_flowers] = ftn_overlab(M, overlab_th)

        L=length(M);
    for k =1:L  
    a = (M(k,:)> overlab_th*M(k,k));
    [a1 a_idx] = find(a ==1);
%     a_idx(k) =[];
    p = length(find(a==1));

     if p>1 
         M(k,k)=0;
     end 
    end 
    
    z=diag(M);
    num_flowers = length(find(z>0));