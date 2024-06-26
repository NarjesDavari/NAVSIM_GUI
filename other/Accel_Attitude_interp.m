function [ Simulation ] = Accel_Attitude_interp( Real_Measurement , Simulation )

    Time2=Simulation.Output.INS.Alignment.time(1:Simulation.Output.INS.Alignment.RP_counter,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    R = Simulation.Output.INS.Alignment.phi(1:Simulation.Output.INS.Alignment.RP_counter,1);
    P = Simulation.Output.INS.Alignment.theta(1:Simulation.Output.INS.Alignment.RP_counter,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    Timei=Real_Measurement.IMU(:,1);
    
    % interpolates the values of the points xn and xe and h at
    % the points Timei
    Ri=interp1(Time2,R,Timei,'linear');
    Pi=interp1(Time2,P,Timei,'linear');
        
    Simulation.Output.INS.Alignment.phi_100=zeros(length(Timei),1);
    Simulation.Output.INS.Alignment.theta_100=zeros(length(Timei),1);
    
    Simulation.Output.INS.Alignment.phi_100   = Ri;
    Simulation.Output.INS.Alignment.theta_100 = Pi;
end