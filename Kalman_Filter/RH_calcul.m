%Computation of The measurement model matrix(H) and the measurement error
%variance(R) in indirect approch (ESKF).
%Reference : My thesis: pages 90-91
function [ Simulation ] = Correction_Param(Simulation,select_navsim_mode,include_depthmeter,include_dvl,include_heading,include_rollpitch ,I )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=[];
Rr=[];
dz=[];
if strcmp(select_navsim_mode,'User Defined Path Simulation')
    if include_depthmeter
        if Simulation.Input.User_Def_Sim.TempSig.Depth_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z)
            if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1))
                H=[H;
                    1,0,0,0,0,0,0];
                Rr=[Rr;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_alt];  
            end
        end
    end

    if include_dvl
        if Simulation.Input.User_Def_Sim.TempSig.DVL_Counter <= length(Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
            if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))
                H=[H;
                    0,1,0,0,0,0,0
                    0,0,1,0,0,0,0        
                    0,0,0,1,0,0,0];
                Rr=[Rr;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_vx ;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_vy ;
                    Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_vz]; 
            end
        end
    end

    if include_rollpitch

        if Simulation.Input.User_Def_Sim.TempSig.incln_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll)
            if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,1))
        H=[H;
            0,0,0,0,1,0,0
            0,0,0,0,0,1,0];
        Rr=[Rr;
            Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_roll ;
            Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_pitch];  
            end
        end
    end
    
    if include_heading
        if Simulation.Input.User_Def_Sim.TempSig.hdng_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw)
            if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,1))
                H=[H;0,0,0,0,0,0,1];
                Rr=[Rr;Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_yaw ];   
            end
        end
    end    
    R=diag(Rr);%measurement noise covariance matrix
    Simulation.Output.User_Def_Sim.Kalman_mtx.H=0;
    Simulation.Output.User_Def_Sim.Kalman_mtx.R.Rmatrx=0;
    Simulation.Output.User_Def_Sim.Kalman_mtx.H=H;%measurement matrix
    Simulation.Output.User_Def_Sim.Kalman_mtx.R.Rmatrx=R;   
end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if strcmp(select_navsim_mode,'Processing of Real Measurments')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    if include_GPS
        if Simulation.Input.PostProc_Real.TempSig.GPS_Counter <= length(Simulation.Input.PostProc_Real.Measurements.GPS)
            if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.GPS(Simulation.Input.PostProc_Real.TempSig.GPS_Counter,1))
                H=[H;
                    1,0,0,0,0,0,0,0,0
                    0,1,0,0,0,0,0,0,0];
                Rr=[Rr;
                       Simulation.Output.PostProc_Real.Kalman_mtx.R.r_Lat ;
                       Simulation.Output.PostProc_Real.Kalman_mtx.R.r_lon];   
            end
        end
    end    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if include_depthmeter
        if Simulation.Input.PostProc_Real.TempSig.Depth_Counter <= length(Simulation.Input.PostProc_Real.Measurements.Depth)
            if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,1))
           
                H=[H;
                    0,0,1,0,0,0,0,0,0];
                Rr=[Rr;
                    Simulation.Output.PostProc_Real.Kalman_mtx.R.r_alt];
                
                d_alt=Simulation.Output.User_Def_Sim.INS.X_INS(I-1,3)-Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,2);
                dz=[dz,d_alt];
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if include_dvl
        if Simulation.Input.PostProc_Real.TempSig.DVL_Counter <= length(Simulation.Input.PostProc_Real.Measurements.DVL)
            if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,1))
                Vn=-Simulation.Output.PostProc_Real.INS.X_INS(I,4:6)';
                Vn_SSM=[0      -Vn(3) Vn(2)
                        Vn(3)  0      -Vn(1)
                        -Vn(2) Vn(1)  0     ];
                H=[H;
                    zeros(3),eye(3),Vn_SSM];
                Rr=[Rr;
                    Simulation.Output.PostProc_Real.Kalman_mtx.R.r_vx ;
                    Simulation.Output.PostProc_Real.Kalman_mtx.R.r_vy ;
                    Simulation.Output.PostProc_Real.Kalman_mtx.R.r_vz];   
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if include_rollpitch
        if Simulation.Input.PostProc_Real.TempSig.incln_Counter <= length(Simulation.Input.PostProc_Real.Measurements.RollPitch)
            if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,1))
                C = Gamma(Simulation.Output.PostProc_Real.INS.X_INS(I,7:9));
                i_phi=[1 0 0
                       0 1 0];
                H=[H;
                    zeros(2,6),-i_phi/C];
                Rr=[Rr;
                       Simulation.Output.PostProc_Real.Kalman_mtx.R.r_roll ;
                       Simulation.Output.PostProc_Real.Kalman_mtx.R.r_pitch];   
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if include_heading
        if Simulation.Input.PostProc_Real.TempSig.hdng_Counter <= length(Simulation.Input.PostProc_Real.Measurements.Heading)
            if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,1))
                C = Gamma(Simulation.Output.PostProc_Real.INS.X_INS(I,7:9));
                i_psi=[0 0 1];                
                H=[H;zeros(1,6),-i_psi/C];
                Rr=[Rr;Simulation.Output.PostProc_Real.Kalman_mtx.R.r_yaw ];
            end
        end
    end    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    R=diag(Rr);%measurement noise covariance matrix
    Simulation.Output.PostProc_Real.Kalman_mtx.H=0;
    Simulation.Output.PostProc_Real.Kalman_mtx.R.Rmatrx=0;
    Simulation.Output.PostProc_Real.Kalman_mtx.H=H;%measurement matrix
    Simulation.Output.PostProc_Real.Kalman_mtx.R.Rmatrx=R;   
end
end