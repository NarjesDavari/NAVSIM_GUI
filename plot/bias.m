time=Simulation.Input.Measurements.IMU(:,1);
figure
plot(SimulationN.Output.ESKF.O_corrected(:,1))
 hold on
 plot(Simulationa.Output.ESKF.O_corrected(:,1),'r')
 plot(Simulationg.Output.ESKF.O_corrected(:,1),'g')
  plot(Simulationg_L5.Output.ESKF.O_corrected(:,1),'black')
% plot(-Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.Bax,'r')
figure
plot(SimulationN.Output.ESKF.O_corrected(:,2))
 hold on
 plot(Simulationa.Output.ESKF.O_corrected(:,2),'r')
 plot(Simulationg.Output.ESKF.O_corrected(:,2),'g')
  plot(Simulationg_L5.Output.ESKF.O_corrected(:,2),'black')
% plot(-Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.Bay,'r')
figure
plot(SimulationN.Output.ESKF.O_corrected(:,3))
 hold on
 plot(Simulationa.Output.ESKF.O_corrected(:,3),'r')
 plot(Simulationg.Output.ESKF.O_corrected(:,3),'g')
  plot(Simulationg_L5.Output.ESKF.O_corrected(:,3),'black')
% plot(-Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.Baz,'r')
figure
plot(SimulationN.Output.ESKF.O_corrected(:,7))
 hold on
 plot(Simulationa.Output.ESKF.O_corrected(:,7),'r')
 plot(Simulationg.Output.ESKF.O_corrected(:,7),'g')
  plot(Simulationg_L5.Output.ESKF.O_corrected(:,7),'black')
% plot(- Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.Bgx,'r')
figure
plot(SimulationN.Output.ESKF.O_corrected(:,8))
 hold on
 plot(Simulationa.Output.ESKF.O_corrected(:,8),'r')
 plot(Simulationg.Output.ESKF.O_corrected(:,8),'g')
  plot(Simulationg_L5.Output.ESKF.O_corrected(:,8),'black')
% plot(- Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.Bgy,'r')
figure
plot(SimulationN.Output.ESKF.O_corrected(:,9))
 hold on
 plot(Simulationa.Output.ESKF.O_corrected(:,9),'r')
 plot(Simulationg.Output.ESKF.O_corrected(:,9),'g')
  plot(Simulationg_L5.Output.ESKF.O_corrected(:,9),'black')
% plot(-Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.Bgz,'r')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
plot(time,Simulation.Input.Measurements.Ref_Pos(:,2))
hold on
plot(time,Simulation.Output.ESKF.Pos_m(:,1),'r')
plot(time,Simulation_b.Output.ESKF.Pos_m(:,1),'g')



plot(Simulation.Output.ESKF.O_corrected(:,10))
plot(Simulation.Output.ESKF.O_corrected(:,11))
plot(Simulation.Output.ESKF.O_corrected(:,12))
plot(Simulation.Output.ESKF.O_corrected(:,13))
plot(Simulation.Output.ESKF.O_corrected(:,14))
plot(Simulation.Output.ESKF.O_corrected(:,15))