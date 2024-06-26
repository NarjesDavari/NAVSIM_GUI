function Tab = NAVSIM_GenTab_ErrorUDPS(Simulation,CalculType)


Dlength=length(Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.relative_error_i);
N = GetParam(Simulation.Init_Value ,'simulation_number');
Tab{1,1} = 'Error Reports';
for I=1:Dlength
    Tab{3  ,1}  = 't (s)'; 
    Tab{3+I,1} = Simulation.Input.User_Def_Sim.Path.P_ned(I,4);
end
K=0;
for J=1:N
    h = waitbar(0,'Error Reports is loading ...'); 
    for I=1:Dlength
        Tab{2  ,3+K}  = ['Simulation Num. ' num2str(J)];
          
        Tab{3  ,3+K}  = 'Absolute_error (m)';
        if strcmp(CalculType,'EKF')
            Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.absolute_error_i(I,J);
        end
        if strcmp(CalculType,'UKF')
            Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.absolute_error_i(I,J);
        end  
        if strcmp(CalculType,'ESKF')
            Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.absolute_error_i(I,J);
        end        
    
        Tab{3  ,4+K}  = 'Relative_error (%)';
        if strcmp(CalculType,'EKF')
            Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.relative_error_i(I,J);        
        end
        if strcmp(CalculType,'UKF')
            Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.relative_error_i(I,J);        
        end
        if strcmp(CalculType,'ESKF')
            Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.relative_error_i(I,J);        
        end        
        if rem(I,10000)
            waitbar(I/(Dlength/10),h);
        end        
    end
    delete(h)
    K=K+3;
end

for I=1:Dlength
     
    Tab{3  ,3+K}  = 'Average absolute error (m)';
    if strcmp(CalculType,'EKF')
        Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.ave_absolute_error_i(I,1);
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.ave_absolute_error_i(I,1);
    end
    if strcmp(CalculType,'ESKF')
        Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_absolute_error_i(I,1);
    end    
    
    Tab{3  ,4+K}  = 'Average relative error (%)';
    if strcmp(CalculType,'EKF')
        Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.ave_relative_error_i(I,1);    
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.ave_relative_error_i(I,1);    
    end
    if strcmp(CalculType,'ESKF')
        Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_relative_error_i(I,1);    
    end    
end

Tab{3  ,6+K}  = 'Process Noise Covariance Matrix';

Tab{4  ,6+K}  = 'q_ax';
Tab{4  ,7+K}  = Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_ax;
Tab{5  ,6+K}  = 'q_ay';
Tab{5  ,7+K}  = Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_ay;
Tab{6  ,6+K}  = 'q_az';
Tab{6  ,7+K}  = Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_az;
Tab{7  ,6+K}  = 'q_wx';
Tab{7  ,7+K}  = Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_wx;
Tab{8  ,6+K}  = 'q_wy';
Tab{8  ,7+K}  = Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_wy;
Tab{9  ,6+K}  = 'q_wz';
Tab{9  ,7+K}  = Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_wz;

Tab{3  ,9+K}  = 'Measurement Noise Covariance Matrix';

Tab{4  ,9+K}  = 'r_z';
Tab{4  ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_alt;
Tab{5  ,9+K}  = 'r_vx';
Tab{5  ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_vx;
Tab{6  ,9+K}  = 'r_vy';
Tab{6  ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_vy;
Tab{7 ,9+K}  = 'r_vz';
Tab{7 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_vz;
Tab{8 ,9+K}  = 'r_roll';
Tab{8 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_roll;
Tab{9 ,9+K}  = 'r_pitch';
Tab{9 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_pitch;
Tab{10 ,9+K}  = 'r_yaw';
Tab{10 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_yaw;
Tab{11 ,9+K}  = 'r_ax';
Tab{11 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_ax;
Tab{12 ,9+K}  = 'r_ay';
Tab{12 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_ay;
Tab{13 ,9+K}  = 'r_az';
Tab{13 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_az;
Tab{14 ,9+K}  = 'r_wx';
Tab{14 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_wx;
Tab{15 ,9+K}  = 'r_wy';
Tab{15 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_wy;
Tab{16 ,9+K}  = 'r_wz';
Tab{16 ,10+K} = Simulation.Output.User_Def_Sim.Kalman_mtx.R.r_wz;