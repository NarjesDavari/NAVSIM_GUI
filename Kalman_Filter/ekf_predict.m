%EKF_PREDICT  1st order Extended Kalman Filter prediction step
%input:
%Simulation-the data stored in memory
%x - Nx1 mean state estimate of previous step
%P - NxN state covariance of previous step
%Q - <<Process noise>> of discrete model 
%F - The Jacobians of dynamic model of function(f)
%W_Coriolis-coriolis effect
%dt-stepsize
%g1-local gravity model
%output:
%x - Predicted state mean
%P - Predicted state covariance
% Description:
% Perform Extended Kalman Filter prediction step.
%Reference : My thesis page 75-80
function [x,P] = ekf_predict(x,P,Q,F,dt)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters
    R=6378137;
    e=0.0818191908426;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    RN=R*(1-e^2)/(1-e^2*(sin(x(1)))^2)^1.5;
    RE=R/(1-e^2*(sin(x(1)))^2)^0.5;
    %
    k1=sec(x(1)) ;
    k2=sin(x(10));
    k3=cos(x(10));
    k4=tan(x(11));
    k5=sec(x(11));
    %Predicted state mean
    x(1)=x(1)+dt*(x(4)/(RN+x(3)));
    x(2)=x(2)+dt*(x(5)*k1/(RE+x(3)));
    x(3)=x(3)+(dt*x(6));
    %
    x(4:6)=x(4:6)+dt*(x(7:9));

    x(10)=x(10)+dt*((x(14)*k2+x(15)*k3)*k4+x(13));        
    x(11)=x(11)+dt*(x(14)*k3-x(15)*k2);        
    x(12)=x(12)+dt*((x(14)*k2+x(15)*k3)*k5);
    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    %Predicted state covariance
    P = F * P * F' + Q; 
end