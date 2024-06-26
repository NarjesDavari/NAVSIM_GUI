function Tab = NAVSIM_GenTab_SystemStatePRM(Simulation,CalculType)

h = waitbar(0,'System State is loading ...'); 
Tab{1,1} = 'System State in Processing of Real Measurments';

Dlength=length(Simulation.Input.PostProc_Real.Measurements.IMU);
for I=1:Dlength
    
    Tab{3  ,1} = 't (s)';        
    Tab{3+I,1} = Simulation.Input.PostProc_Real.Measurements.IMU(I,1);    
    
    Tab{3  ,2} = 'x (m)';
    Tab{3  ,3} = 'y (m)';
    Tab{3  ,4} = 'z (m)';   
    if strcmp(CalculType,'EKF')
        Tab{3+I,2} = Simulation.Output.PostProc_Real.INS_EKF.Pos_m(I,1);    
        Tab{3+I,3} = Simulation.Output.PostProc_Real.INS_EKF.Pos_m(I,2);
        Tab{3+I,4} = Simulation.Output.PostProc_Real.INS_EKF.Pos_m(I,3);   
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,2} = Simulation.Output.PostProc_Real.INS_UKF.Pos_m(I,1);    
        Tab{3+I,3} = Simulation.Output.PostProc_Real.INS_UKF.Pos_m(I,2);
        Tab{3+I,4} = Simulation.Output.PostProc_Real.INS_UKF.Pos_m(I,3);   
    end
    if strcmp(CalculType,'ESKF')
        Tab{3+I,2} = Simulation.Output.PostProc_Real.ESKF.Pos_m(I,1);    
        Tab{3+I,3} = Simulation.Output.PostProc_Real.ESKF.Pos_m(I,2);
        Tab{3+I,4} = Simulation.Output.PostProc_Real.ESKF.Pos_m(I,3);   
    end    
    
    Tab{3  ,5} = 'Lat (rad)';
    Tab{3  ,6} = 'lon (rad)';
    Tab{3  ,7} = 'alt (m)';  
    if strcmp(CalculType,'EKF')
        Tab{3+I,5} = Simulation.Output.PostProc_Real.INS_EKF.X(I,1);    
        Tab{3+I,6} = Simulation.Output.PostProc_Real.INS_EKF.X(I,2);
        Tab{3+I,7} = Simulation.Output.PostProc_Real.INS_EKF.X(I,3);  
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,5} = Simulation.Output.PostProc_Real.INS_UKF.m(I,1);    
        Tab{3+I,6} = Simulation.Output.PostProc_Real.INS_UKF.m(I,2);
        Tab{3+I,7} = Simulation.Output.PostProc_Real.INS_UKF.m(I,3);  
    end
    if strcmp(CalculType,'ESKF')
        Tab{3+I,5} = Simulation.Output.PostProc_Real.ESKF.P_rad(I,1);    
        Tab{3+I,6} = Simulation.Output.PostProc_Real.ESKF.P_rad(I,2);
        Tab{3+I,7} = Simulation.Output.PostProc_Real.ESKF.P_rad(I,3);  
    end    

    Tab{3  ,8} = 'Lat (deg)';
    Tab{3  ,9} = 'lon (deg)';
    Tab{3  ,10} = 'alt (m)';   
    if strcmp(CalculType,'EKF')
        Tab{3+I,8} = Simulation.Output.PostProc_Real.INS_EKF.P_geo(I,1);    
        Tab{3+I,9} = Simulation.Output.PostProc_Real.INS_EKF.P_geo(I,2);
        Tab{3+I,10} = Simulation.Output.PostProc_Real.INS_EKF.P_geo(I,3); 
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,8} = Simulation.Output.PostProc_Real.INS_UKF.P_geo(I,1);    
        Tab{3+I,9} = Simulation.Output.PostProc_Real.INS_UKF.P_geo(I,2);
        Tab{3+I,10} = Simulation.Output.PostProc_Real.INS_UKF.P_geo(I,3); 
    end
    if strcmp(CalculType,'ESKF')
        Tab{3+I,8} = Simulation.Output.PostProc_Real.ESKF.P_geo(I,1);    
        Tab{3+I,9} = Simulation.Output.PostProc_Real.ESKF.P_geo(I,2);
        Tab{3+I,10} = Simulation.Output.PostProc_Real.ESKF.P_geo(I,3); 
    end    
    if rem(I,10000)
        waitbar(I/(Dlength),h);
    end
end
delete(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
