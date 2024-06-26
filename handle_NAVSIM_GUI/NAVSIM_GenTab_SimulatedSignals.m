function Tab = NAVSIM_GenTab_SimulatedSignals(Simulation)

Dlength=length(Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax);
N = GetParam(Simulation.Init_Value ,'simulation_number');
Tab{1,1} = 'Simulated signals';
    
%K characterizes the number of the variavles in a simulation.
K=0;
for J=1:N
h = waitbar(0,'Inertial signals is loading ...'); 
for I=1:Dlength
    Tab{2  ,1+K}  = ['Simulation Num. ' num2str(J)];
    
    Tab{3  ,1+K} = 't (s)';        
    Tab{3+I,1+K} = Simulation.Input.User_Def_Sim.Path.P_ned(I,4);    
    
    Tab{3  ,2+K}  = 'ax (m/s^2)';
    Tab{3  ,3+K}  = 'ay (m/s^2)';
    Tab{3  ,4+K}  = 'az (m/s^2)';    
    Tab{3+I,2+K} = Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax(I,J);    
    Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ay(I,J);
    Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.az(I,J);  
    
    Tab{3  ,5+K}  = 'Wx (rad/s)';
    Tab{3  ,6+K}  = 'Wy (rad/s)';
    Tab{3  ,7+K}  = 'Wz (rad/s)';
    Tab{3+I,5+K} = Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wx(I,J);    
    Tab{3+I,6+K} = Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wy(I,J);
    Tab{3+I,7+K} = Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wz(I,J);   
      
    if rem(I,10000)
        waitbar(I/Dlength,h);
    end        
end
    delete(h)
    K=K+15;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dlength=length(Simulation.Output.User_Def_Sim.Noise.DVL.Vx);
K=0;
for J=1:N
h = waitbar(0,'DVL signals is loading ...'); 
for I=1:Dlength
    Tab{2  ,8+K}  = ['Simulation Num. ' num2str(J)];
    Tab{3  ,8+K} = 't (s)';        
    Tab{3+I,8+K} = Simulation.Output.User_Def_Sim.Noise.DVL.Time(I);
    
    Tab{3  ,9+K}  = 'Vx (m/s)';
    Tab{3  ,10+K} = 'Vy (m/s)';
    Tab{3  ,11+K} = 'Vz (m/s)';
    Tab{3+I,9+K}  = Simulation.Output.User_Def_Sim.Noise.DVL.Vx(I,J);    
    Tab{3+I,10+K} = Simulation.Output.User_Def_Sim.Noise.DVL.Vy(I,J);
    Tab{3+I,11+K} = Simulation.Output.User_Def_Sim.Noise.DVL.Vz(I,J);    
    
%     if rem(I,10000)
        waitbar(I/Dlength,h);
%     end    
end
    delete(h)
    K=K+15;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dlength=length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll);
K=0;
for J=1:N
h = waitbar(0,'Attitude signals is loading ...'); 
for I=1:Dlength
    Tab{2  ,12+K}  = ['Simulation Num. ' num2str(J)];
    Tab{3  ,12+K} = 't (s)';        
    Tab{3+I,12+K} = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_Time(I);
    
    Tab{3  ,13+K} = 'Roll (rad)';
    Tab{3  ,14+K} = 'Pitch (rad)';   
    Tab{3+I,13+K} = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll(I,J);    
    Tab{3+I,14+K} = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NPitch(I,J);    
    
    if rem(I,10000)
        waitbar(I/Dlength,h);
    end    
end
    delete(h)
    K=K+15;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dlength=length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw);
K=0;
for J=1:N
h = waitbar(0,'Heading signal is loading ...'); 
for I=1:Dlength
    Tab{2  ,15+K}  = ['Simulation Num. ' num2str(J)];
    Tab{3  ,15+K} = 't (s)';        
    Tab{3+I,15+K} = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_Time(I);
    
    Tab{3  ,16+K} = 'Yaw(Heading) (rad)';    
    Tab{3+I,16+K} = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw(I,J);     
    
    if rem(I,10000)
        waitbar(I/Dlength,h);
    end    
end
    delete(h)
    K=K+15;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dlength=length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z);
K=0;
for J=1:N
h = waitbar(0,'Depth (altitude) signal is loading ...'); 
for I=1:Dlength
    Tab{2  ,17+K}  = ['Simulation Num. ' num2str(J)];
    Tab{3  ,17+K} = 't (s)';        
    Tab{3+I,17+K} = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Time(I);
    
    Tab{3  ,18+K} = 'D (m)';    
    Tab{3+I,18+K} = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z(I,J);    
    
%     if rem(I,10000)
        waitbar(I/Dlength,h);
%     end    
end
    delete(h)
    K=K+15;
end