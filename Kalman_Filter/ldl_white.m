function[L,D] = ldl_white(A) 
n = size(A,1);
L = eye(n); 
for j = 1:n-1 
    d(j) = A(j,j); 
    for k = j+1:n 
        L(j+1:n,j) = A(j+1:n,j)/d(j); 
        A(k:n,k) = A(k:n,k) - A(k,j)*L(k:n,j); 
    end  
end 
d(n) = A(n,n); 
D = diag(d); 
