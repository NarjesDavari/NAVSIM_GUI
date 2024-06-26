function Tab = NAVSIM_GenTab_MeasuredSignals(Simulation)

h = waitbar(0,'Inertial signals is loading ...'); 
Tab{1,1} = 'System State in Processing of Real Measurments';

Dlength=length(Simulation.Input.PostProc_Real.Measurements.IMU);
for I=1:Dlength
    
    Tab{3  ,1} = 't (s)';        
    Tab{3+I,1} = Simulation.Input.PostProc_Real.Measurements.IMU(I,1);    
    
    Tab{3  ,2}  = 'ax (m/s^2)';
    Tab{3  ,3}  = 'ay (m/s^2)';
    Tab{3  ,4}  = 'az (m/s^2)';    
    Tab{3+I,2} = Simulation.Input.PostProc_Real.Measurements.IMU(I,2);    
    Tab{3+I,3} = Simulation.Input.PostProc_Real.Measurements.IMU(I,3);
    Tab{3+I,4} = Simulation.Input.PostProc_Real.Measurements.IMU(I,4);  
    
    Tab{3  ,5}  = 'Wx (rad/s)';
    Tab{3  ,6}  = 'Wy (rad/s)';
    Tab{3  ,7}  = 'Wz (rad/s)';
    Tab{3+I,5} = Simulation.Input.PostProc_Real.Measurements.IMU(I,5);    
    Tab{3+I,6} = Simulation.Input.PostProc_Real.Measurements.IMU(I,6);
    Tab{3+I,7} = Simulation.Input.PostProc_Real.Measurements.IMU(I,7);  

    if rem(I,10000)
        waitbar(I/(Dlength),h);
    end
end
delete(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = waitbar(0,'DVL signals is loading ...');
Dlength=length(Simulation.Input.PostProc_Real.Measurements.DVL);
for I=1:Dlength
    Tab{3  ,8} = 't (s)';        
    Tab{3+I,8} = Simulation.Input.PostProc_Real.Measurements.DVL(I,1);     
    

    Tab{3  ,9}  = 'Vx (m/s)';
    Tab{3  ,10} = 'Vy (m/s)';
    Tab{3  ,11} = 'Vz (m/s)';
    Tab{3+I,9}  = Simulation.Input.PostProc_Real.Measurements.DVL(I,2);    
    Tab{3+I,10} = Simulation.Input.PostProc_Real.Measurements.DVL(I,3);
    Tab{3+I,11} = Simulation.Input.PostProc_Real.Measurements.DVL(I,4); 
    
%     if rem(I,10000)
        waitbar(I/(Dlength),h);
%     end    
end
delete(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = waitbar(0,'Attitude signals is loading ...');
Dlength=length(Simulation.Input.PostProc_Real.Measurements.RollPitch);
for I=1:Dlength
    Tab{3  ,12} = 't (s)';        
    Tab{3+I,12} = Simulation.Input.PostProc_Real.Measurements.RollPitch(I,1);  
    
    Tab{3  ,13} = 'Roll (deg)';
    Tab{3  ,14} = 'Pitch (deg)';
    Tab{3+I,13} = Simulation.Input.PostProc_Real.Measurements.RollPitch(I,2);    
    Tab{3+I,14} = Simulation.Input.PostProc_Real.Measurements.RollPitch(I,3);
    
    if rem(I,10000)
        waitbar(I/(Dlength),h);
    end    
end
delete(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = waitbar(0,'Heading signal is loading ...');
Dlength=length(Simulation.Input.PostProc_Real.Measurements.Heading);
for I=1:Dlength
    Tab{3  ,15} = 't (s)';        
    Tab{3+I,15} = Simulation.Input.PostProc_Real.Measurements.Heading(I,1);  

    Tab{3  ,16} = 'Yaw(Heading) (deg)';    
    Tab{3+I,16} = Simulation.Input.PostProc_Real.Measurements.Heading(I,2);
    
    if rem(I,10000)
        waitbar(I/(Dlength),h);
    end    
end
delete(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = waitbar(0,'Depth signal is loading ...');
Dlength=length(Simulation.Input.PostProc_Real.Measurements.Depth);
for I=1:Dlength
    Tab{3  ,17} = 't (s)';        
    Tab{3+I,17} = Simulation.Input.PostProc_Real.Measurements.Depth(I,1);  

    Tab{3  ,18} = 'Depth(altitude) (m)';    
    Tab{3+I,18} = Simulation.Input.PostProc_Real.Measurements.Depth(I,2);
    
%     if rem(I,10000)
        waitbar(I/(Dlength),h);
%     end    
end
delete(h)