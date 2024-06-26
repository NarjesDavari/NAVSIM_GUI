%Tunning of R(the measurement error variance) elements
%TC: Tunning Coefficient
function [ Simulation ] = R_setting( Simulation, gg)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters of the Earth
    R=6378137;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    select_navsim_mode = Simulation.Input.NAVSIM_Mode;
    mu                  = GetParam(Simulation.Parameters_Inclenometer ,'detection_signal');
    
    var_Lat             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_LatV');
    TC_rLat             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_LatT');
    
    var_lon             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_lonV');
    TC_rlon             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_lonT');
    
    
    var_vx             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_VxV');
    var_vy             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_VyV');
    var_vz             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_VzV');
    TC_rvx             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_VxT');
    TC_rvy             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_VyT');
    TC_rvz             = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_VzT');
    
    var_alt            = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_DV');
    TC_ralt            = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_DT');
    
    var_roll           = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_RollV');
    var_pitch          = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_PitchV');
    var_yaw            = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_YawV');
    TC_rphi            = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_RollT');
    TC_rtheta          = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_PitchT');
    TC_rpsi            = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_YawT');
    
    var_aroll          = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_ARollV');
    var_apitch         = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_APitchV');
    TC_arphi           = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_ARollT');
    TC_artheta         = GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'edit_Var_APitchT');
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
    
    r_aroll=var_aroll*TC_arphi; %(mu/g)^2;
    r_apitch=var_apitch*TC_artheta; 

%     r_apitch=(std(Simulation.Input.Measurements.IMU(1e5:end,2))/10)^2/100;
%     r_aroll=(std(Simulation.Input.Measurements.IMU(1e5:end,3))/10)^2/100;
%     r_aroll=(mu/gg)^2;
%     r_apitch=(mu/gg)^2;
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
    
    Simulation.Output.Kalman_mtx.R_moving=[r_Lat/(R^2) r_lon/(R^2) r_alt  r_vx  r_vy r_vz  r_roll r_pitch r_yaw r_aroll r_apitch];
    
end