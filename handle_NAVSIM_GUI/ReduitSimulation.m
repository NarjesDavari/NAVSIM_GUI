function SimRed = ReduitSimulation(Simulation)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        choix_signal_value = Simulation.SaveOptions.choix_signal_value;
        if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
            switch choix_signal_value
                case 1 %'Save All Signal'
                    % do nothing
                case 2 %'Don''t save any signal'
                    Simulation.Input.User_Def_Sim.IMU=[];                
                    Simulation.Input.User_Def_Sim.Depthmeter=[];
                    Simulation.Input.User_Def_Sim.Gyro_Compass=[];
                    Simulation.Input.User_Def_Sim.DVL=[];
                    Simulation.Input.User_Def_Sim.IMUer=[];
                    Simulation.Input.User_Def_Sim.Path.Euler=[];
                    Simulation.Input.User_Def_Sim.Path.velocity=[];
                    Simulation.Input.User_Def_Sim.Path.accelerometer=[];
                    Simulation.Input.User_Def_Sim.Path.Lat_rad_in=[];
                    Simulation.Input.User_Def_Sim.Path.ffn=[];
                    Simulation.Input.User_Def_Sim.Path.s_i=[];
                    Simulation.Input.User_Def_Sim.TempSig=[];
                    
                
                    Simulation.Output.User_Def_Sim.Noise=[];  
                    Simulation.Output.User_Def_Sim.INS=[];
                    Simulation.Output.User_Def_Sim.ESKF.X_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.dX=[];
                    Simulation.Output.User_Def_Sim.ESKF.O_corrected=[];
                    Simulation.Output.User_Def_Sim.ESKF.MM=[];
                    Simulation.Output.User_Def_Sim.ESKF.PP=[];
                    Simulation.Output.User_Def_Sim.ESKF.z_KF_Ave=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_m=[];
                    Simulation.Output.User_Def_Sim.ESKF.P_rad=[];
                    Simulation.Output.User_Def_Sim.ESKF.ave_Pos_deg=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.relative_error_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_relative_error_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_absolute_error_i=[];
                case 3 %'Save IMU Signals Only'   
                    Simulation.Input.User_Def_Sim.IMU=[];                
                    Simulation.Input.User_Def_Sim.Depthmeter=[];
                    Simulation.Input.User_Def_Sim.Gyro_Compass=[];
                    Simulation.Input.User_Def_Sim.DVL=[];
                    Simulation.Input.User_Def_Sim.IMUer=[];
                    Simulation.Input.User_Def_Sim.Path.Euler=[];
                    Simulation.Input.User_Def_Sim.Path.velocity=[];
                    Simulation.Input.User_Def_Sim.Path.accelerometer=[];
                    Simulation.Input.User_Def_Sim.Path.Lat_rad_in=[];
                    Simulation.Input.User_Def_Sim.Path.ffn=[];
                    Simulation.Input.User_Def_Sim.Path.s_i=[];
                    Simulation.Input.User_Def_Sim.TempSig=[];                
    
                    Simulation.Output.User_Def_Sim.Noise.DVL=[];
                    Simulation.Output.User_Def_Sim.Noise.DVL1=[];
                    Simulation.Output.User_Def_Sim.Noise.Depthmeter1=[];
                    Simulation.Output.User_Def_Sim.Noise.Depthmeter=[];
                    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass=[]; 
                    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1=[];
    
                    Simulation.Output.User_Def_Sim.INS=[];
                    Simulation.Output.User_Def_Sim.ESKF.X_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.dX=[];
                    Simulation.Output.User_Def_Sim.ESKF.O_corrected=[];
                    Simulation.Output.User_Def_Sim.ESKF.MM=[];
                    Simulation.Output.User_Def_Sim.ESKF.PP=[];
                    Simulation.Output.User_Def_Sim.ESKF.z_KF_Ave=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_m=[];
                    Simulation.Output.User_Def_Sim.ESKF.P_rad=[];
                    Simulation.Output.User_Def_Sim.ESKF.ave_Pos_deg=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.relative_error_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_relative_error_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_absolute_error_i=[];                
                case 4 %'Save Auxiliary Signals Only'
                    Simulation.Input.User_Def_Sim.IMU=[];   
                    Simulation.Input.User_Def_Sim.Depthmeter=[];
                    Simulation.Input.User_Def_Sim.Gyro_Compass=[];
                    Simulation.Input.User_Def_Sim.DVL=[];            
                    Simulation.Input.User_Def_Sim.IMUer=[];
                    Simulation.Input.User_Def_Sim.Path.Euler=[];
                    Simulation.Input.User_Def_Sim.Path.velocity=[];
                    Simulation.Input.User_Def_Sim.Path.accelerometer=[];
                    Simulation.Input.User_Def_Sim.Path.Lat_rad_in=[];
                    Simulation.Input.User_Def_Sim.Path.ffn=[];
                    Simulation.Input.User_Def_Sim.Path.s_i=[];
                    Simulation.Input.User_Def_Sim.TempSig=[];                
    
                    Simulation.Output.User_Def_Sim.INS=[];
                    Simulation.Output.User_Def_Sim.ESKF.X_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.dX=[];
                    Simulation.Output.User_Def_Sim.ESKF.O_corrected=[];
                    Simulation.Output.User_Def_Sim.ESKF.MM=[];
                    Simulation.Output.User_Def_Sim.ESKF.PP=[];
                    Simulation.Output.User_Def_Sim.ESKF.z_KF_Ave=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_m=[];
                    Simulation.Output.User_Def_Sim.ESKF.P_rad=[];
                    Simulation.Output.User_Def_Sim.ESKF.ave_Pos_deg=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.relative_error_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_relative_error_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_absolute_error_i=[];                  
                    Simulation.Output.User_Def_Sim.Noise.IMU=[];
                    Simulation.Output.User_Def_Sim.Noise.IMUer=[]; 
                    Simulation.Output.User_Def_Sim.Noise.DVL1=[];
                    Simulation.Output.User_Def_Sim.Noise.Depthmeter1=[];
                    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1=[];
                case 5 %'Save IMU and Auxiliary Signals '
                    Simulation.Input.User_Def_Sim.IMU=[];
                    Simulation.Input.User_Def_Sim.Depthmeter=[];
                    Simulation.Input.User_Def_Sim.Gyro_Compass=[];
                    Simulation.Input.User_Def_Sim.DVL=[];
                    Simulation.Input.User_Def_Sim.IMUer=[];
    
                    Simulation.Output.User_Def_Sim.Noise.DVL1=[];
                    Simulation.Output.User_Def_Sim.Noise.Depthmeter1=[];
                    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1=[];
        
                    Simulation.Output.User_Def_Sim.INS=[];
                    Simulation.Output.User_Def_Sim.ESKF.X_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.dX=[];
                    Simulation.Output.User_Def_Sim.ESKF.O_corrected=[];
                    Simulation.Output.User_Def_Sim.ESKF.MM=[];
                    Simulation.Output.User_Def_Sim.ESKF.PP=[];
                    Simulation.Output.User_Def_Sim.ESKF.z_KF_Ave=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_m=[];
                    Simulation.Output.User_Def_Sim.ESKF.P_rad=[];
                    Simulation.Output.User_Def_Sim.ESKF.ave_Pos_deg=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.relative_error_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_relative_error_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_absolute_error_i=[];                
                case 6 %'Save Results only '
                    Simulation.Input.User_Def_Sim.IMU=[];                
                    Simulation.Input.User_Def_Sim.Depthmeter=[];
                    Simulation.Input.User_Def_Sim.Gyro_Compass=[];
                    Simulation.Input.User_Def_Sim.DVL=[];
                    Simulation.Input.User_Def_Sim.IMUer=[];
                    Simulation.Input.User_Def_Sim.Path.Euler=[];
                    Simulation.Input.User_Def_Sim.Path.velocity=[];
                    Simulation.Input.User_Def_Sim.Path.accelerometer=[];
                    Simulation.Input.User_Def_Sim.Path.Lat_rad_in=[];
                    Simulation.Input.User_Def_Sim.Path.ffn=[];
                    Simulation.Input.User_Def_Sim.Path.s_i=[];
                    Simulation.Input.User_Def_Sim.TempSig=[];
    
        
                    Simulation.Output.User_Def_Sim.Noise=[];   
                case 7 %'Save Signals and Results only '
                    Simulation.Input.User_Def_Sim.Path.Euler=[];
                    Simulation.Input.User_Def_Sim.Path.accelerometer=[];
                    Simulation.Input.User_Def_Sim.Path.ffn=[];
                    Simulation.Input.User_Def_Sim.Path.sx_i =[];                   
                    Simulation.Input.User_Def_Sim.Path.sy_i =[];
                    Simulation.Input.User_Def_Sim.Path.sz_i =[];
                    Simulation.Input.User_Def_Sim.Path.s_i=[];
                    
                    Simulation.Input.User_Def_Sim.Depthmeter=[];                    
                    Simulation.Input.User_Def_Sim.IMU=[];   
                    Simulation.Input.User_Def_Sim.IMUer=[];                    
                    Simulation.Input.User_Def_Sim.TempSig=[];  
                    
                    Simulation.Output.User_Def_Sim.INS.Cbn =[];
                    Simulation.Output.User_Def_Sim.INS.fnn=[];
                    
                    Simulation.Output.User_Def_Sim.ESKF.X_i=[];
                    Simulation.Output.User_Def_Sim.ESKF.Cbn_corrected=[];
                    Simulation.Output.User_Def_Sim.ESKF.O_corrected=[];
                    Simulation.Output.User_Def_Sim.ESKF.Pos_m=[];
                    Simulation.Output.User_Def_Sim.ESKF.ave_Pos_m=[];
                    Simulation.Output.User_Def_Sim.ESKF.ave_Pos_deg=[];
            end
                 
        end
        if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
            switch choix_signal_value
                
                case 1 %'Save All Signal'
                    % do nothing
                    
                case 2 %'Don''t save any signal'
                    Simulation.Input.PostProc_Real.TempSig=[];
                    Simulation.Input.PostProc_Real.InitKF=[];
                    Simulation.Input.PostProc_Real.Path.ds_i=[];
                    Simulation.Input.PostProc_Real.Path.s_i=[];
                    Simulation.Input.PostProc_Real.Path.Lat_rad_in=[];
                    Simulation.Input.PostProc_Real.Measurements.IMU=[];
                    Simulation.Input.PostProc_Real.Measurements.RollPitch=[];
                    Simulation.Input.PostProc_Real.Measurements.Heading=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL=[];
                    Simulation.Input.PostProc_Real.Measurements.Depth=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL_RollPitch=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL_Heading=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL_length=[];
                    Simulation.Input.PostProc_Real.Measurements.Depth_length=[];                    
                    
                    Simulation.Output.PostProc_Real.INS=[];
                    Simulation.Output.PostProc_Real.ESKF=[];
                    
                case 3 %'Save IMU Signals Only' 
                    Simulation.Input.PostProc_Real.TempSig=[];
                    Simulation.Input.PostProc_Real.InitKF=[];
                    Simulation.Input.PostProc_Real.Path.ds_i=[];
                    Simulation.Input.PostProc_Real.Path.s_i=[];
                    Simulation.Input.PostProc_Real.Path.Lat_rad_in=[];
                    Simulation.Input.PostProc_Real.Measurements.RollPitch=[];
                    Simulation.Input.PostProc_Real.Measurements.Heading=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL=[];
                    Simulation.Input.PostProc_Real.Measurements.Depth=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL_RollPitch=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL_Heading=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL_length=[];
                    Simulation.Input.PostProc_Real.Measurements.Depth_length=[];
                    
                    Simulation.Output.PostProc_Real.INS=[];
                    Simulation.Output.PostProc_Real.ESKF=[];
                    
                case 4 %'Save Auxiliary Signals Only'   
                    Simulation.Input.PostProc_Real.TempSig=[];
                    Simulation.Input.PostProc_Real.InitKF=[];
                    Simulation.Input.PostProc_Real.Path.ds_i=[];
                    Simulation.Input.PostProc_Real.Path.s_i=[];
                    Simulation.Input.PostProc_Real.Path.Lat_rad_in=[];
                    Simulation.Input.PostProc_Real.Measurements.IMU=[];
                    
                    Simulation.Output.PostProc_Real.INS=[];
                    Simulation.Output.PostProc_Real.ESKF=[];                    
                    
                case 5 %'Save IMU and Auxiliary Signals '
                    Simulation.Input.PostProc_Real.TempSig=[];
                    Simulation.Input.PostProc_Real.InitKF=[];
                    Simulation.Input.PostProc_Real.Path.ds_i=[];
                    Simulation.Input.PostProc_Real.Path.s_i=[];
                    Simulation.Input.PostProc_Real.Path.Lat_rad_in=[];
                    
                    Simulation.Output.PostProc_Real.INS=[];
                    Simulation.Output.PostProc_Real.ESKF=[];                    
                    
                case 6 %'Save Results only '
                    Simulation.Input.PostProc_Real.TempSig=[];
                    Simulation.Input.PostProc_Real.InitKF=[];
                    Simulation.Input.PostProc_Real.Path.ds_i=[];
                    Simulation.Input.PostProc_Real.Path.s_i=[];
                    Simulation.Input.PostProc_Real.Path.Lat_rad_in=[];
                    Simulation.Input.PostProc_Real.Measurements.IMU=[];
                    Simulation.Input.PostProc_Real.Measurements.RollPitch=[];
                    Simulation.Input.PostProc_Real.Measurements.Heading=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL=[];
                    Simulation.Input.PostProc_Real.Measurements.Depth=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL_RollPitch=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL_Heading=[];
                    Simulation.Input.PostProc_Real.Measurements.DVL_length=[];
                    Simulation.Input.PostProc_Real.Measurements.Depth_length=[];                     
                     
            end
        end
    
SimRed = Simulation;
