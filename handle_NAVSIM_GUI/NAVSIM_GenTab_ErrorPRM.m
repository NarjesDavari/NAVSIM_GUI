function Tab = NAVSIM_GenTab_ErrorPRM(Simulation,CalculType)

h = waitbar(0,'Error Reports is loading ...'); 
Tab{1,1} = 'Error Reports';
Dlength=length(Simulation.Input.PostProc_Real.Measurements.IMU);

for I=1:Dlength/10-1
    
    Tab{3  ,1}  = 't (s)'; 
    Tab{3+I,1} = Simulation.Input.PostProc_Real.Measurements.IMU(I,1); 
     
    Tab{3  ,3}  = 'Absolute error (m)';
    if strcmp(CalculType,'EKF')
        Tab{3+I,3} = Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.absolute_error(I);
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,3} = Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.absolute_error(I);
    end
    if strcmp(CalculType,'ESKF')
        Tab{3+I,3} = Simulation.Output.PostProc_Real.ESKF.Pos_Error.absolute_error(I);
    end    
    
    Tab{3  ,4}  = 'Relative error (%)';
    if strcmp(CalculType,'EKF')
        Tab{3+I,4} = Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.relative_error(I);      
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,4} = Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.relative_error(I);      
    end
    if strcmp(CalculType,'ESKF')
        Tab{3+I,4} = Simulation.Output.PostProc_Real.ESKF.Pos_Error.relative_error(I);      
    end
    
    if rem(I,10000)
        waitbar(I/(Dlength/10),h);
    end    
end
delete(h)
Tab{3  ,6}  = 'Process Noise Covariance Matrix';

Tab{4  ,6}  = 'q_ax';
Tab{4  ,7}  = Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_ax;
Tab{5  ,6}  = 'q_ay';
Tab{5  ,7}  = Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_ay;
Tab{6  ,6}  = 'q_az';
Tab{6  ,7}  = Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_az;
Tab{7  ,6}  = 'q_wx';
Tab{7  ,7}  = Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_wx;
Tab{8  ,6}  = 'q_wy';
Tab{8  ,7}  = Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_wy;
Tab{9  ,6}  = 'q_wz';
Tab{9  ,7}  = Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_wz;

Tab{3  ,9}  = 'Measurement Noise Covariance Matrix';

Tab{4  ,9}  = 'r_z';
Tab{4  ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_alt;
Tab{5  ,9}  = 'r_vx';
Tab{5  ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_vx;
Tab{6  ,9}  = 'r_vy';
Tab{6  ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_vy;
Tab{7 ,9}  = 'r_vz';
Tab{7 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_vz;
Tab{8 ,9}  = 'r_roll';
Tab{8 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_roll;
Tab{9 ,9}  = 'r_pitch';
Tab{9 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_pitch;
Tab{10 ,9}  = 'r_yaw';
Tab{10 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_yaw;
Tab{11 ,9}  = 'r_ax';
Tab{11 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_ax;
Tab{12 ,9}  = 'r_ay';
Tab{12 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_ay;
Tab{13 ,9}  = 'r_az';
Tab{13 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_az;
Tab{14 ,9}  = 'r_wx';
Tab{14 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_wx;
Tab{15 ,9}  = 'r_wy';
Tab{15 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_wy;
Tab{16 ,9}  = 'r_wz';
Tab{16 ,10} = Simulation.Output.PostProc_Real.Kalman_mtx.R.r_wz;