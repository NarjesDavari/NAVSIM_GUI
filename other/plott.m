function [ output_args ] = plott( input_args )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(SimulationAided.Output.User_Def_Sim.Noise.GPS1.Lat*pi/180)
hold on
plot(SimulationAided.Input.User_Def_Sim.Path.P_geo(:,1)*pi/180,'r')
figure
plot(SimulationAided.Output.User_Def_Sim.Noise.GPS1.lon*pi/180)
hold on
plot(SimulationAided.Input.User_Def_Sim.Path.P_geo(:,2)*pi/180,'r')
figure
plot(SimulationAided.Output.User_Def_Sim.Noise.Depthmeter1.Z)
hold on
plot(SimulationAided.Input.User_Def_Sim.Path.P_geo(:,3),'r')
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
plot(SimulationAided.Output.User_Def_Sim.Noise.DVL1.Vx)
hold on
plot(SimulationINS.Input.User_Def_Sim.DVL.Velocity(:,1),'r')
figure
plot(SimulationAided.Output.User_Def_Sim.Noise.DVL1.Vy)
hold on
plot(SimulationINS.Input.User_Def_Sim.DVL.Velocity(:,2),'r')
figure
plot(SimulationAided.Output.User_Def_Sim.Noise.DVL1.Vz)
hold on
plot(SimulationINS.Input.User_Def_Sim.DVL.Velocity(:,3),'r')
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
figure
plot(SimulationINS.Output.User_Def_Sim.Noise.Gyro_Compass1.NRoll*180/pi)
hold on
plot(SimulationINS.Input.User_Def_Sim.Gyro_Compass.R*180/pi,'r')
figure
plot(SimulationINS.Output.User_Def_Sim.Noise.Gyro_Compass1.NPitch*180/pi)
hold on
plot(SimulationINS.Input.User_Def_Sim.Gyro_Compass.P*180/pi,'r')
figure
plot(SimulationINS.Output.User_Def_Sim.Noise.Gyro_Compass1.NYaw*180/pi)
hold on
plot(SimulationINS.Input.User_Def_Sim.Gyro_Compass.Y*180/pi,'r')
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(sqrt(SimulationINS.Output.User_Def_Sim.Kalman_mtx.P_diag(:,1))*6378137)
hold on
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_XN*6378137,'k')
plot(sqrt(SimulationAided.Output.User_Def_Sim.Kalman_mtx.P_diag(:,1))*6378137,'g')
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_XN*6378137,'r')

figure

plot(sqrt(SimulationINS.Output.User_Def_Sim.Kalman_mtx.P_diag(:,2))*6378137)
hold on
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_XE*6378137,'k')
plot(sqrt(SimulationAided.Output.User_Def_Sim.Kalman_mtx.P_diag(:,2))*6378137,'g')
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_XE*6378137,'r')

figure

plot(sqrt(SimulationINS.Output.User_Def_Sim.Kalman_mtx.P_diag(:,3)))
hold on
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_XD,'k')
plot(sqrt(SimulationAided.Output.User_Def_Sim.Kalman_mtx.P_diag(:,3)),'g')
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_XD,'r')
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
figure
plot(sqrt(SimulationINS.Output.User_Def_Sim.Kalman_mtx.P_diag(:,4)))
hold on
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_VN,'k')
plot(sqrt(SimulationAided.Output.User_Def_Sim.Kalman_mtx.P_diag(:,4)),'g')
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_VN,'r')
figure
plot(sqrt(SimulationINS.Output.User_Def_Sim.Kalman_mtx.P_diag(:,5)))
hold on
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_VE,'k')
plot(sqrt(SimulationAided.Output.User_Def_Sim.Kalman_mtx.P_diag(:,5)),'g')
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_VE,'r')
figure
plot(sqrt(SimulationINS.Output.User_Def_Sim.Kalman_mtx.P_diag(:,6)))
hold on
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_VD,'k')
plot(sqrt(SimulationAided.Output.User_Def_Sim.Kalman_mtx.P_diag(:,6)),'g')
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_VD,'r')
%""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
figure
plot(sqrt(SimulationINS.Output.User_Def_Sim.Kalman_mtx.P_diag(:,7))*180/pi)
hold on
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_R*180/pi,'k')
plot(sqrt(SimulationAided.Output.User_Def_Sim.Kalman_mtx.P_diag(:,7))*180/pi,'g')
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_R*180/pi,'r')
figure
plot(sqrt(SimulationINS.Output.User_Def_Sim.Kalman_mtx.P_diag(:,8))*180/pi)
hold on
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_P*180/pi,'k')
plot(sqrt(SimulationAided.Output.User_Def_Sim.Kalman_mtx.P_diag(:,8))*180/pi,'g')
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_P*180/pi,'r')
figure
plot(sqrt(SimulationINS.Output.User_Def_Sim.Kalman_mtx.P_diag(:,9))*180/pi)
hold on
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_Y*180/pi,'k')
plot(sqrt(SimulationAided.Output.User_Def_Sim.Kalman_mtx.P_diag(:,9))*180/pi,'g')
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_Y*180/pi,'r')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(SimulationINS.Output.User_Def_Sim.ESKF.Pos_Error.diff_Y*180/pi,'k')
hold on
plot(SimulationAided.Output.User_Def_Sim.ESKF.Pos_Error.diff_Y*180/pi,'r')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(Simulation.Output.User_Def_Sim.ESKF.dX(:,1)*6378137)
plot(Simulation.Output.User_Def_Sim.ESKF.dX(:,2)*6378137)
plot(Simulation.Output.User_Def_Sim.ESKF.dX(:,3))
plot(SimulationAided.Output.User_Def_Sim.ESKF.dX(:,4))
plot(SimulationAided.Output.User_Def_Sim.ESKF.dX(:,5))
plot(SimulationAided.Output.User_Def_Sim.ESKF.dX(:,6))
plot(SimulationAided.Output.User_Def_Sim.ESKF.dX(:,7)*180/pi)
plot(SimulationAided.Output.User_Def_Sim.ESKF.dX(:,8)*180/pi)
plot(SimulationAided.Output.User_Def_Sim.ESKF.dX(:,9)*180/pi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(SimulationINS.Output.User_Def_Sim.INS.X_INS(:,1),'r')
hold on
plot(SimulationINS.Input.User_Def_Sim.Path.P_geo(:,1)*(pi/180))
plot(SimulationAided.Output.User_Def_Sim.INS.X_INS(:,1),'g')
figure
plot(SimulationINS.Output.User_Def_Sim.INS.X_INS(:,2),'r')
hold on
plot(SimulationINS.Input.User_Def_Sim.Path.P_geo(:,2)*(pi/180))
plot(SimulationAided.Output.User_Def_Sim.INS.X_INS(:,2),'g')
figure
plot(SimulationINS.Output.User_Def_Sim.INS.X_INS(:,3),'r')
hold on
plot(SimulationINS.Input.User_Def_Sim.Path.P_geo(:,3))
plot(SimulationAided.Output.User_Def_Sim.INS.X_INS(:,3),'g')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
plot(SimulationINS.Output.User_Def_Sim.INS.X_INS(:,4),'r')
hold on
plot(SimulationINS.Input.User_Def_Sim.Path.velocity(:,1))
plot(SimulationAided.Output.User_Def_Sim.INS.X_INS(:,4),'g')
figure
plot(SimulationINS.Output.User_Def_Sim.INS.X_INS(:,5),'r')
hold on
plot(SimulationINS.Input.User_Def_Sim.Path.velocity(:,2))
plot(SimulationAided.Output.User_Def_Sim.INS.X_INS(:,5),'g')
figure
plot(SimulationINS.Output.User_Def_Sim.INS.X_INS(:,6),'r')
hold on
plot(SimulationINS.Input.User_Def_Sim.Path.velocity(:,3))
plot(SimulationAided.Output.User_Def_Sim.INS.X_INS(:,6),'g')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
plot(SimulationINS.Output.User_Def_Sim.INS.X_INS(:,7)*(180/pi),'r')
hold on
plot(SimulationINS.Input.User_Def_Sim.Gyro_Compass.R*(180/pi))
plot(SimulationAided.Output.User_Def_Sim.INS.X_INS(:,7)*(180/pi),'g')
figure
plot(SimulationINS.Output.User_Def_Sim.INS.X_INS(:,8)*(180/pi),'r')
hold on
plot(SimulationINS.Input.User_Def_Sim.Gyro_Compass.P*(180/pi))
plot(SimulationAided.Output.User_Def_Sim.INS.X_INS(:,8)*(180/pi),'g')
figure
plot(SimulationINS.Output.User_Def_Sim.INS.X_INS(:,9)*(180/pi),'r')
hold on
plot(SimulationINS.Input.User_Def_Sim.Gyro_Compass.Y*(180/pi))
plot(SimulationAided.Output.User_Def_Sim.INS.X_INS(:,9)*(180/pi),'g')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(sqrt(Simulation.Output.User_Def_Sim.Kalman_mtx.P_diag(:,1))*6378137)
hold on
plot(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_XN*6378137,'k')
figure
plot(sqrt(Simulation.Output.User_Def_Sim.Kalman_mtx.P_diag(:,2))*6378137)
hold on
plot(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_XE*6378137,'k')
figure
plot(sqrt(Simulation.Output.User_Def_Sim.Kalman_mtx.P_diag(:,3)))
hold on
plot(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_XD,'k')

figure
plot(sqrt(Simulation.Output.User_Def_Sim.Kalman_mtx.P_diag(:,4)))
hold on
plot(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_VN,'k')
figure
plot(sqrt(Simulation.Output.User_Def_Sim.Kalman_mtx.P_diag(:,5)))
hold on
plot(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_VE,'k')
figure
plot(sqrt(Simulation.Output.User_Def_Sim.Kalman_mtx.P_diag(:,6)))
hold on
plot(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_VD,'k')

figure
plot(sqrt(Simulation.Output.User_Def_Sim.Kalman_mtx.P_diag(:,7))*180/pi)
hold on
plot(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_R*180/pi,'k')
figure
plot(sqrt(Simulation.Output.User_Def_Sim.Kalman_mtx.P_diag(:,8))*180/pi)
hold on
plot(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_P*180/pi,'k')
figure
plot(sqrt(Simulation.Output.User_Def_Sim.Kalman_mtx.P_diag(:,9))*180/pi)
hold on
plot(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_Y*180/pi,'k')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(SimulationAided.Output.User_Def_Sim.INS.norm.Gyro_norm)
hold on
plot(SimulationAided.Output.User_Def_Sim.Noise.IMUer.Gyro.wx,'r')
plot(SimulationAided.Output.User_Def_Sim.Noise.IMUer.Gyro.wy,'g')
plot(SimulationAided.Output.User_Def_Sim.Noise.IMUer.Gyro.wz,'k')

plot(SimulationAided.Output.User_Def_Sim.INS.norm.Accel_norm)
hold on
plot(SimulationAided.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax,'r')
plot(SimulationAided.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ay,'g')
plot(SimulationAided.Output.User_Def_Sim.Noise.IMUer.Accelerometer.az,'k')

plot(SimulationAided.Output.User_Def_Sim.INS.norm.Gyro_norm)
hold on
plot(SimulationAided.Output.User_Def_Sim.INS.norm.Accel_norm,'g')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(Simulation.Output.User_Def_Sim.INS.Alignment.theta(1:Simulation.Output.User_Def_Sim.INS.Alignment.RP_counter,:)*180/pi)
hold on
plot(Simulation.Output.User_Def_Sim.INS.Alignment.true_pitch(1:Simulation.Output.User_Def_Sim.INS.Alignment.RP_counter,:)*180/pi,'r')
plot(Simulation.Output.User_Def_Sim.INS.Alignment.phi(1:Simulation.Output.User_Def_Sim.INS.Alignment.RP_counter,:)*180/pi)
hold on
plot(Simulation.Output.User_Def_Sim.INS.Alignment.true_roll(1:Simulation.Output.User_Def_Sim.INS.Alignment.RP_counter,:)*180/pi,'r')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot(Simulation.Input.Measurements.IMU(:,2),'r')
    hold on
    plot(Simulation.Output.INS.FilteredSignal.a_f(:,1))

    plot(Simulation.Input.Measurements.IMU(:,3),'r')
    hold on
    plot(Simulation.Output.INS.FilteredSignal.a_f(:,2))

    plot(Simulation.Input.Measurements.IMU(:,4),'r')
    hold on
    plot(Simulation.Output.INS.FilteredSignal.a_f(:,3))
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
plot(Simulation.Output.INS.Alignment.phi*180/pi)
hold on
plot(Simulation.Input.User_Def_Sim.Gyro_Compass.R*180/pi,'r')

plot(Simulation.Output.INS.Alignment.theta*180/pi)
hold on
plot(Simulation.Input.User_Def_Sim.Gyro_Compass.P*180/pi,'r')    
end

