%Error State Kalman Filter function:
%prediction and correction stages of the Kalman filter
function [Simulation,flag_Qadapt] = ESKF( Simulation,I,i,CalculType,Selection_Param,C_DVL_IMU,landa_P,Include_R_adaptive,Include_Q_adaptive,flag_Qadapt,Misalignment_IMU_phins,ave_sample,calib_sample,SF)

    global Updt_Cntr;
    
        [Simulation,dX,P,alpha,beta] = eskf_predict(Simulation,I,CalculType,landa_P,ave_sample);
        [Simulation,V,flag_accelrollpitch]=Correction_Param(Simulation,Selection_Param,SF,I,i,C_DVL_IMU,P,Misalignment_IMU_phins,ave_sample,calib_sample);
        H = Simulation.Output.Kalman_mtx.H;
        R = Simulation.Output.Kalman_mtx.R.Rmatrx;
        dz = Simulation.Output.Kalman_mtx.dz;

        if (~isempty (Simulation.Output.Kalman_mtx.H))
        Updt_Cntr = Updt_Cntr + 1;
        [Simulation,dX,P,flag_Qadapt,alpha,beta]=eskf_update_innovation(Simulation,dX,P,dz,H,R,I,V,Selection_Param,flag_accelrollpitch,Include_R_adaptive,Include_Q_adaptive,alpha,beta);%%innovation          
        Simulation.Output.Kalman_mtx.alpha_VB=alpha;
        Simulation.Output.Kalman_mtx.beta_VB=beta;
        end
        
        Simulation.Output.Kalman_mtx.alpha_VB=alpha;
        Simulation.Output.Kalman_mtx.beta_VB=beta;
        Simulation.Output.Kalman_mtx.P = P;
        Simulation.Output.ESKF.dX(I - ave_sample + 1,:) = dX;
        Q_update=Simulation.Output.Kalman_mtx.Q;
        Simulation.Output.Kalman_mtx.Q_diag(I - ave_sample + 1,:)=[Q_update(1,1) Q_update(2,2) Q_update(3,3) Q_update(4,4) Q_update(5,5) Q_update(6,6) Q_update(7,7) Q_update(8,8) Q_update(9,9) Q_update(10,10) Q_update(11,11) Q_update(12,12) Q_update(13,13) Q_update(14,14) Q_update(15,15)];

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         P1=zeros(15,15);
%         P1(1:9,1:9)=P(1:9,1:9);
%         Simulation.Output.Kalman_mtx.P=P1;
    