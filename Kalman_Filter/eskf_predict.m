%KF_PREDICT  Perform Kalman Filter prediction step
%Reference: Strapdown inertial navigation system, chapter 13 page 406 
function [Simulation,dX,P,alpha,beta] = eskf_predict(Simulation,I,CalculType,landa_P,ave_sample)

    P=Simulation.Output.Kalman_mtx.P;
    A=Simulation.Output.Kalman_mtx.A;
    Q=Simulation.Output.Kalman_mtx.Q;
    G=Simulation.Output.Kalman_mtx.G;
    alpha=Simulation.Output.Kalman_mtx.alpha_VB;
    beta=Simulation.Output.Kalman_mtx.beta_VB;
    rho=1;%%%%????(1-exp(-4));
    
    if strcmp(CalculType,'FeedBack')
        dX = zeros(15,1);
        P  =landa_P*( A * P * A' + Q); %Predicted state covariance  
        Simulation.Output.Kalman_mtx.P_diag(I-ave_sample+1,:)=[P(1,1) P(2,2) P(3,3) P(4,4) P(5,5) P(6,6) P(7,7) P(8,8) P(9,9) P(10,10) P(11,11) P(12,12) P(13,13) P(14,14) P(15,15)];
       alpha = rho*alpha;
       beta = rho*beta;
    end    
    if strcmp(CalculType,'FeedForward')
        dX = A*Simulation.Output.User_Def_Sim.ESKF.dX(I-1,:)';%Predicted state mean
        P  =landa_P*( A * P * A' + Q); %Predicted state covariance    
    end
end
