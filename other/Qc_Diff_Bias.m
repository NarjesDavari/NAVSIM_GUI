function [Simulation,tau]=Qc_Diff_Bias(Simulation,I)
    
tau=[100,100,10000,100,100,100];
Simulation.Output.parameter_Bias_tauMoving=tau;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     q_b_ax=.5e-13;
     q_b_ay=.1e-12;
     q_b_az=1e-11;
            
     q_b_wx=.5e-17;    
     q_b_wy=.5e-17;    
     q_b_wz=.5e-17;  
    
%      q_b_ax=0;
%      q_b_ay=0;
%      q_b_az=0;
%             
%      q_b_wx=0;    
%      q_b_wy=0;    
%      q_b_wz=0; 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    Simulation.Output.Kalman_mtx.Qc.q_Bax=q_b_ax;  
    Simulation.Output.Kalman_mtx.Qc.q_Bay=q_b_ay; 
    Simulation.Output.Kalman_mtx.Qc.q_Baz=q_b_az; 
    
    Simulation.Output.Kalman_mtx.Qc.q_Bwx=q_b_wx;
    Simulation.Output.Kalman_mtx.Qc.q_Bwy=q_b_wy;
    Simulation.Output.Kalman_mtx.Qc.q_Bwz=q_b_wz;
   

Simulation.Output.Kalman_mtx.Qc_Bias_moving=[q_b_ax q_b_ay q_b_az q_b_wx q_b_wy q_b_wz];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if I==5.2e4  
    P1=Simulation.Output.Kalman_mtx.P;
    
    p=[P1(1:9,1:9) zeros(9,6)
        zeros(6,15)];
    Simulation.Output.Kalman_mtx.P=p;
% end    