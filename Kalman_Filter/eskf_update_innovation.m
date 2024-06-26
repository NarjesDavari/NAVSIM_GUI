function [Simulation,dX,P,flag_Qadapt,alpha,beta]=eskf_update_innovation(Simulation,dX,P,dz,H,R,I,V,Selection_Param,flag_accelrollpitch,Include_R_adaptive,Include_Q_adaptive,alpha,beta)

           
           windowSize_adaptive= Simulation.Output.Kalman_mtx.WindowSize_adaptive;
           Simulation.Output.Kalman_mtx.update_counter = Simulation.Output.Kalman_mtx.update_counter+1;
           update_counter=Simulation.Output.Kalman_mtx.update_counter;
            Simulation.Output.Kalman_mtx.X_hat_minus(update_counter,:)=dX;%%%?????????
           
%          if VV(1,1)<3*PP(1,1) && VV(2,2)<3*PP(2,2) && VV(3,3)<3*PP(3,3)  
           Simulation.Output.Kalman_mtx.V(Simulation.Output.Kalman_mtx.update_counter,:) = V';
%            Simulation.Output.Kalman_mtx.P_(:,:,Simulation.Output.Kalman_mtx.update_counter) = P;
%            end
    
           if  Simulation.Output.Kalman_mtx.update_counter >windowSize_adaptive && Include_R_adaptive
               Simulation.Output.Kalman_mtx.adaptive_innovation=1;
               [Simulation,C]= Covariance_innovation(Simulation,windowSize_adaptive);
               [Simulation,dX,P] = eskf_update1_adaptive(Simulation,dX,P,dz,H,R,I,windowSize_adaptive,C,Selection_Param,flag_accelrollpitch);
%              [X,P,landa_P] = ekf_update1_adaptive2(Simulation,X,P,Y,H,I,windowSize_adaptive,C);

             Simulation.Output.Kalman_mtx.X_hat_plus(update_counter,:)=dX;%%%?????????
             Simulation.Output.Kalman_mtx.P_hat_plus(:,:,update_counter)=P;
             Simulation.Output.Kalman_mtx.A_adap(:,:,update_counter)=Simulation.Output.Kalman_mtx.A;
           else
%              [Simulation] = Whitening2(Simulation,windowSize_adaptive,X,P);
             [Simulation,dX ,P,alpha,beta] = eskf_update(Simulation,dX , P , dz , H,R ,I,alpha,beta,Selection_Param,flag_accelrollpitch,windowSize_adaptive);
%             [Simulation]=R_adaptive(Simulation,R,windowSize_adaptive,update_counter,I,Selection_Param,flag_accelrollpitch);            
              Simulation.Output.Kalman_mtx.X_hat_plus(update_counter,:)=dX;%%%?????????
%             Simulation.Output.Kalman_mtx.P_hat_plus(:,:,update_counter)=P;
             Simulation.Output.Kalman_mtx.A_adap(:,:,update_counter)=Simulation.Output.Kalman_mtx.A;
             Simulation.Output.Kalman_mtx.alpha_VB=alpha;
             Simulation.Output.Kalman_mtx.beta_VB=beta;
           end
            
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Q_adaptive
           
           if  Simulation.Output.Kalman_mtx.update_counter >windowSize_adaptive && Include_Q_adaptive
               [Simulation] = Estimate_Q(Simulation);
               flag_Qadapt=1;
           else
               flag_Qadapt=0;
           end
               
           
           
           
           