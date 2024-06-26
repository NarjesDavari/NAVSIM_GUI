%Computation of The measurement model matrix(H) and the measurement error
%variance(R) in direct approch (EKF and UKF).
%Reference : My thesis: pages 84-85
function [Simulation]=KlmnIniMatx(Simulation,I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
select_navsim_mode  = Simulation.Input.NAVSIM_Mode;
include_depthmeter  = GetParam(Simulation.Parameters_DepthMeter ,'include_depthmeter');
include_dvl         = GetParam(Simulation.Parameters_DVL ,'include_dvl');
include_heading     = GetParam(Simulation.Parameters_GyroCompass ,'include_heading');
include_rollpitch  = GetParam(Simulation.Parameters_GyroCompass ,'include_roll&pitch');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H=[];
Rr=[];
if strcmp(select_navsim_mode,'User Defined Path Simulation')
    if include_depthmeter
        if Simulation.Input.User_Def_Sim.TempSig.Depth_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z)
            if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1))        
                H=[H;
                    0,0,1,0,0,0,0,0,0,0,0,0,0,0,0];
                Rr=[Rr;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_alt];  
            end
        end
    end
    if include_dvl
        if Simulation.Input.User_Def_Sim.TempSig.DVL_Counter <= length(Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
            if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))                        
                H=[H;
                    0,0,0,1,0,0,0,0,0,0,0,0,0,0,0;
                    0,0,0,0,1,0,0,0,0,0,0,0,0,0,0;
                    0,0,0,0,0,1,0,0,0,0,0,0,0,0,0];
                Rr=[Rr;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_vx ;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_vy ;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_vz];   
            end
        end
    end
    %Accel
        H=[H;
            0,0,0,0,0,0,1,0,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0,1,0,0,0,0,0,0];
        Rr=[Rr;
            Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_ax ;
            Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_ay ;
            Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_az];
    %
    if include_rollpitch  
        if Simulation.Input.User_Def_Sim.TempSig.incln_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll)
            if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,1))   
                H=[H;
                    0,0,0,0,0,0,0,0,0,1,0,0,0,0,0;
                    0,0,0,0,0,0,0,0,0,0,1,0,0,0,0];
                Rr=[Rr;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_roll ;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_pitch]; 
            end
        end
    end
    %
    if include_heading 
        if Simulation.Input.User_Def_Sim.TempSig.hdng_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw)
            if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,1))    
                H=[H;0,0,0,0,0,0,0,0,0,0,0,1,0,0,0];
                Rr=[Rr;Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_yaw ];    
            end
        end
    end
    %Gyro
        H=[H;
            0,0,0,0,0,0,0,0,0,0,0,0,1,0,0;
            0,0,0,0,0,0,0,0,0,0,0,0,0,1,0;
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
        Rr=[Rr;
            Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_wx ;
            Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_wy ;
            Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_wz];
   
    R=diag(Rr);%measurement noise covariance matrix
    Simulation.Output.User_Def_Sim.Kalman_mtx.H=0;
    Simulation.Output.User_Def_Sim.Kalman_mtx.R.Rmatrx=0;
    Simulation.Output.User_Def_Sim.Kalman_mtx.H=H;%measurement matrix
    Simulation.Output.User_Def_Sim.Kalman_mtx.R.Rmatrx=R;    
end     
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if strcmp(select_navsim_mode,'Processing of Real Measurments')
    if include_depthmeter
        if Simulation.Input.PostProc_Real.TempSig.Depth_Counter <= length(Simulation.Input.PostProc_Real.Measurements.Depth)
            if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,1))
        H=[H;
            0,0,1,0,0,0,0,0,0,0,0,0,0,0,0];
        Rr=[Rr;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_alt];  
            end
        end
    end
    if include_dvl

        if Simulation.Input.PostProc_Real.TempSig.DVL_Counter <= length(Simulation.Input.PostProc_Real.Measurements.DVL)
            if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,1))        
        H=[H;
            0,0,0,1,0,0,0,0,0,0,0,0,0,0,0;
            0,0,0,0,1,0,0,0,0,0,0,0,0,0,0;
            0,0,0,0,0,1,0,0,0,0,0,0,0,0,0];
        Rr=[Rr;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_vx ;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_vy ;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_vz];   
            end
        end
    end
    %Accel
        H=[H;
            0,0,0,0,0,0,1,0,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0,1,0,0,0,0,0,0];
        Rr=[Rr;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_ax ;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_ay ;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_az];  
    %
    if include_rollpitch
        if Simulation.Input.PostProc_Real.TempSig.incln_Counter <= length(Simulation.Input.PostProc_Real.Measurements.RollPitch)
            if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,1))    
                H=[H;
                    0,0,0,0,0,0,0,0,0,1,0,0,0,0,0;
                    0,0,0,0,0,0,0,0,0,0,1,0,0,0,0];
                Rr=[Rr;
                    Simulation.Output.PostProc_Real.Kalman_mtx.R.r_roll ;
                    Simulation.Output.PostProc_Real.Kalman_mtx.R.r_pitch];   
            end
        end
    end
    %
    if include_heading
        if Simulation.Input.PostProc_Real.TempSig.hdng_Counter <= length(Simulation.Input.PostProc_Real.Measurements.Heading)
            if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,1))    
                H=[H;0,0,0,0,0,0,0,0,0,0,0,1,0,0,0];
                Rr=[Rr;Simulation.Output.PostProc_Real.Kalman_mtx.R.r_yaw ];
            end
        end
    end    
    %Gyro
        H=[H;
            0,0,0,0,0,0,0,0,0,0,0,0,1,0,0;
            0,0,0,0,0,0,0,0,0,0,0,0,0,1,0;
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
        Rr=[Rr;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_wx ;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_wy ;
            Simulation.Output.PostProc_Real.Kalman_mtx.R.r_wz];
   
    R=diag(Rr);%measurement noise covariance matrix
    Simulation.Output.PostProc_Real.Kalman_mtx.H=0;
    Simulation.Output.PostProc_Real.Kalman_mtx.R.Rmatrx=0;
    Simulation.Output.PostProc_Real.Kalman_mtx.H=H;%measurement matrix
    Simulation.Output.PostProc_Real.Kalman_mtx.R.Rmatrx=R;    
end