t=Simulation.Input.Measurements.IMU(:,1);
figure
plot(t,Simulation.Output.ESKF.O_corrected(1:end,10))

figure
plot(t,Simulation.Output.ESKF.O_corrected(1:end,11))

figure
plot(t,Simulation.Output.ESKF.O_corrected(1:end,12))

figure
plot(t,Simulation.Output.ESKF.O_corrected(1:end,13))

figure
plot(t,Simulation.Output.ESKF.O_corrected(1:end,14))

figure
plot(t,Simulation.Output.ESKF.O_corrected(1:end,15))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% plot(Simulationw.Output.ESKF.O_corrected(1:end,10),'r')
% hold on
% plot(SimulationL.Output.ESKF.O_corrected(1:end,10),'g')
% 
% figure
% plot(Simulationw.Output.ESKF.O_corrected(1:end,11),'r')
% hold on
% plot(SimulationL.Output.ESKF.O_corrected(1:end,11),'g')
% 
% figure
% plot(Simulationw.Output.ESKF.O_corrected(1:end,12),'r')
% hold on
% plot(SimulationL.Output.ESKF.O_corrected(1:end,12),'g')
% 
% figure
% plot(Simulationw.Output.ESKF.O_corrected(1:end,13),'r')
% hold on
% plot(SimulationL.Output.ESKF.O_corrected(1:end,13),'g')
% 
% figure
% plot(Simulationw.Output.ESKF.O_corrected(1:end,14),'r')
% hold on
% plot(SimulationL.Output.ESKF.O_corrected(1:end,14),'g')
% 
% figure
% plot(Simulationw.Output.ESKF.O_corrected(1:end,15),'r')
% hold on
% plot(SimulationL.Output.ESKF.O_corrected(1:end,15),'g')
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% plot(Simulation.Output.Kalman_mtx.P_diag(:,10))
% figure
% plot(Simulation.Output.Kalman_mtx.P_diag(:,11))
% figure
% plot(Simulation.Output.Kalman_mtx.P_diag(:,12))
% figure
% plot(Simulation.Output.Kalman_mtx.P_diag(:,13))
% figure
% plot(Simulation.Output.Kalman_mtx.P_diag(:,14))
% figure
% plot(Simulation.Output.Kalman_mtx.P_diag(:,15))
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% plot(nonzeros(Simulation.Output.Kalman_mtx.V(:,1)))%%GPS_x
% figure
% plot(nonzeros(Simulation.Output.Kalman_mtx.V(:,2)))%%GPS_y
% figure
% plot(nonzeros(Simulation.Output.Kalman_mtx.V(:,3)))%%GPS_z
% figure
% plot(nonzeros(Simulation.Output.Kalman_mtx.V(:,7)))%%Roll
% figure
% plot(nonzeros(Simulation.Output.Kalman_mtx.V(:,8)))%%Pitch


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c=10;
figure
plot((Simulation.Output.Kalman_mtx.dz_gps(:,1)).^2)
hold on
plot(c*Simulation.Output.Kalman_mtx.S_gps(:,1),'r')

figure
plot((Simulation.Output.Kalman_mtx.dz_gps(:,2)).^2)
hold on
plot(c*Simulation.Output.Kalman_mtx.S_gps(:,2),'r')

figure
plot((Simulation.Output.Kalman_mtx.dz_depth).^2)
hold on
plot(c*Simulation.Output.Kalman_mtx.S_depth,'r')