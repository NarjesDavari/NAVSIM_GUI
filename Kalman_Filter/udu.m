% function [U,D]=udu(R)
% n = size(R,1);
% U = eye(n); 
% 
% for j=n:-1:2
%     d(j)=R(j,j);
%     for k=1:j-1
%         U(1:j-1,j)=R(1:j-1,j)/d(j);
%         R(1:k,k)=R(1:k,k)-R(k,j)*U(1:k,j);
%     end
% end
% d(1)=R(1,1);
% D=diag(d);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u,d]=udu(P)

% UDU Decomposition
% Usage : [u,d]=udu(P)
%         u : output, unit upper triangular matrix
%         d : output, diagonal matrix
%         P : input, real symmetric matrix
%         P=u*d*u'  
% Reference : Mathematics in science and engineering, v.128,
%             Factorization methods for discrete sequential estimation, Gerald J. Bierman. 

[n,n]=size(P);
for j=n:-1:2
    D(j,j)=P(j,j);
    alpha=1/D(j,j);
    for k=1:1:j-1
        beta=P(k,j);
        U(k,j)=alpha*beta;
        for i=1:1:k
            P(i,k)=P(i,k)-beta*U(i,j);
        end
    end
end
D(1,1)=P(1,1);
for i=1:1:n
    U(i,i)=1;
end
u=U;
d=D;