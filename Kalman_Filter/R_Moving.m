function [ Simulation ] = R_Moving( Simulation )
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters of the Earth
    R=6378137;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    Simulation.Output.Kalman_mtx.R.r_Lat = 1/(R^2);  
    Simulation.Output.Kalman_mtx.R.r_lon = 1/(R^2); 
                        
    Simulation.Output.Kalman_mtx.R.r_alt=1;
    
    Simulation.Output.Kalman_mtx.R.r_vx=1e-3;
    Simulation.Output.Kalman_mtx.R.r_vy=1e-3;
    Simulation.Output.Kalman_mtx.R.r_vz=1e-3;

    Simulation.Output.Kalman_mtx.R.r_aroll  = 9e-6;
    Simulation.Output.Kalman_mtx.R.r_apitch = 9e-6;
    
    Simulation.Output.Kalman_mtx.R.r_yaw   = 0.1;
end