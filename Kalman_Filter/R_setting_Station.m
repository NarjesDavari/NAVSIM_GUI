%Tunning of R(the measurement error variance) elements
%TC: Tunning Coefficient
function [ Simulation ] = R_setting_Station( Simulation, gg )
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters of the Earth
    R=6378137;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    select_navsim_mode = Simulation.Input.NAVSIM_Mode;
    
    var_Lat             = 0.001;
    TC_rLat             = 1;
    
    var_lon             = 0.001;
    TC_rlon             = 1;
    
    
    var_vx             = 0.1;
    var_vy             = 0.1;
    var_vz             = 0.1;
    TC_rvx             = 1;
    TC_rvy             = 1;
    TC_rvz             = 1;
    
    var_alt            = 0.001;
    TC_ralt            = 1;
    
    var_roll           = 0.01;
    var_pitch          = 0.01;
    var_yaw            = 0.01;
    TC_rphi            = 1;
    TC_rtheta          = 1;
    TC_rpsi            = 1;
    
    
   var_apitch =(std(Simulation.Input.Measurements.IMU(1:1e5,2))/10)^2;
    var_aroll=(std(Simulation.Input.Measurements.IMU(1:1e5,3))/10)^2;
%     var_aroll          = 1e-8;
%     var_apitch         = 1e-8;
    TC_arphi            = 10;
    TC_artheta          = 10;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    r_Lat=var_Lat*TC_rLat;    
    r_lon=var_lon*TC_rlon;   
    
    r_alt=var_alt*TC_ralt;
    
    r_vx=var_vx*TC_rvx;
    r_vy=var_vy*TC_rvy;
    r_vz=var_vz*TC_rvz; 
    
    r_roll=var_roll*TC_rphi;
    r_pitch=var_pitch*TC_rtheta;
    r_yaw=var_yaw*TC_rpsi;    
    
    r_aroll=var_aroll*TC_arphi;
    r_apitch=var_apitch*TC_artheta;    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    Simulation.Output.Kalman_mtx.R.r_Lat=r_Lat/(R^2);  
    Simulation.Output.Kalman_mtx.R.r_lon=r_lon/(R^2); 
                        
    Simulation.Output.Kalman_mtx.R.r_alt=r_alt;
    
    Simulation.Output.Kalman_mtx.R.r_vx=r_vx;
    Simulation.Output.Kalman_mtx.R.r_vy=r_vy;
    Simulation.Output.Kalman_mtx.R.r_vz=r_vz;
    
    Simulation.Output.Kalman_mtx.R.r_roll=r_roll;
    Simulation.Output.Kalman_mtx.R.r_pitch=r_pitch;
    Simulation.Output.Kalman_mtx.R.r_yaw=r_yaw;

    Simulation.Output.Kalman_mtx.R.r_aroll=r_aroll;
    Simulation.Output.Kalman_mtx.R.r_apitch=r_apitch;
    
    Simulation.Output.Kalman_mtx.R_Station=[r_Lat/(R^2) r_lon/(R^2) r_alt  r_vx  r_vy  r_vz  r_roll  r_pitch  r_yaw  r_aroll r_apitch];
end