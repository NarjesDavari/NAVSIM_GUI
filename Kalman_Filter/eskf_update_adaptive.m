%KF_UPDATE  Kalman Filter update step
%Reference: Strapdown inertial navigation system, chapter 13 page 406 
function [Simulation,dX,P] = eskf_update_adaptive(Simulation,dX,P,I,N)

        
        H=Simulation.Output.Kalman_mtx.H;
        R_conventional=Simulation.Output.Kalman_mtx.R.Rmatrx;
        dz=Simulation.Output.Kalman_mtx.dz;
        update_counter=Simulation.Output.Kalman_mtx.update_counter;
        
        V(update_counter,:)=Simulation.Output.Kalman_mtx.V(I,:);       
        C=0;
        if I<N
            a=0;
        else
            a=I-N;
        end
           for j=a+1:1:I
               C = C+Simulation.Output.Kalman_mtx.V(j,:)'*Simulation.Output.Kalman_mtx.V(j,:);
           end
         
          R=diag(diag(H*C/N*H'),0)-H*P*H';
%         Simulation.Output.Kalman_mtx.R_adaptivex(update_counter)=R(1,1);
%         Simulation.Output.Kalman_mtx.R_adaptivey(update_counter)=R(2,2);
%         Simulation.Output.Kalman_mtx.R_adaptivez(update_counter)=R(3,3);
          Simulation.Output.Kalman_mtx.Covariance_innovation(:,:,update_counter) = C;
          for k=1:1:9
              for i=1:1:9
          Simulation.Output.Kalman_mtx.Covariance_innovation_normalized(:,:,update_counter)=C(i,k)/sqrt(C(i,i)*C(k,k));
              end 
          end
          
%           [T,C] = white(C);
%          [U,D] = udu(R);
%          H_adaptive =(U)^-1*H;
%          dz_adaptive =(U)^-1*dz;
%          S = R + H_adaptive*P*H_adaptive';
%          K = P*H_adaptive'/S;                 %Computed Kalman gain

         R1 = H*C/N*H'-H*P*H';
         S = R + H*P*H';
         K = P*H'/S;                 %Computed Kalman gain
        
%         Q = K*H*C/N*H'*K';
%         Simulation.Output.Kalman_mtx.Q_adaptive=Q;        
        P = P - K*H*P;              %Updated state covariance
        P = (P+P')/2;
        dX = dX + K * (dz-H*dX);   %Updated state mean        
        Simulation.Output.Kalman_mtx.update_counter = Simulation.Output.Kalman_mtx.update_counter +1;
end