function Tab = NAVSIM_GenTab_SystemStateUDPS(Simulation,CalculType)

Dlength=length(Simulation.Output.User_Def_Sim.Noise.DVL.Vx);
N = GetParam(Simulation.Init_Value ,'simulation_number');
Tab{1,1} = 'System State  User-Defined Path Simulation';
    
%K characterizes the number of the variavles in a simulation.
K=0;
for J=1:N
h = waitbar(0,'System State is loading ...'); 
for I=1:Dlength
    Tab{2  ,1+K}  = ['Simulation Num. ' num2str(J)];
     
    Tab{3  ,1+K} = 't (s)';        
    Tab{3+I,1+K} = Simulation.Input.User_Def_Sim.Path.P_ned(I,4);    
    
    Tab{3  ,2+K} = 'x (m)';
    Tab{3  ,3+K} = 'y (m)';
    Tab{3  ,4+K} = 'z (m)';   
    if strcmp(CalculType,'EKF')
        Tab{3+I,2+K} = Simulation.Output.User_Def_Sim.INS_EKF.Pos_m(I,1,J);    
        Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.INS_EKF.Pos_m(I,2,J);
        Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.INS_EKF.Pos_m(I,3,J);  
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,2+K} = Simulation.Output.User_Def_Sim.INS_UKF.Pos_m(I,1,J);    
        Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.INS_UKF.Pos_m(I,2,J);
        Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.INS_UKF.Pos_m(I,3,J);  
    end  
    if strcmp(CalculType,'ESKF')
        Tab{3+I,2+K} = Simulation.Output.User_Def_Sim.ESKF.Pos_m(I,1,J);    
        Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.ESKF.Pos_m(I,2,J);
        Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.ESKF.Pos_m(I,3,J);  
    end    
    
    Tab{3  ,5+K} = 'Lat (rad)';
    Tab{3  ,6+K} = 'lon (rad)';
    Tab{3  ,7+K} = 'alt (m)';   
    if strcmp(CalculType,'EKF')
        Tab{3+I,5+K} = Simulation.Output.User_Def_Sim.INS_EKF.X_i(I,1,J);    
        Tab{3+I,6+K} = Simulation.Output.User_Def_Sim.INS_EKF.X_i(I,2,J);
        Tab{3+I,7+K} = Simulation.Output.User_Def_Sim.INS_EKF.X_i(I,3,J);
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,5+K} = Simulation.Output.User_Def_Sim.INS_UKF.X_i(I,1,J);    
        Tab{3+I,6+K} = Simulation.Output.User_Def_Sim.INS_UKF.X_i(I,2,J);
        Tab{3+I,7+K} = Simulation.Output.User_Def_Sim.INS_UKF.X_i(I,3,J);
    end 
    if strcmp(CalculType,'ESKF')
        Tab{3+I,5+K} = Simulation.Output.User_Def_Sim.ESKF.P_rad(I,1,J);    
        Tab{3+I,6+K} = Simulation.Output.User_Def_Sim.ESKF.P_rad(I,2,J);
        Tab{3+I,7+K} = Simulation.Output.User_Def_Sim.ESKF.P_rad(I,3,J);
    end      
    if rem(I,10000)
        waitbar(I/Dlength,h);
    end        
end
    delete(h)
    K=K+8;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Tab{2  ,1+K}  = ['Averaging the result'];  
for I=1:length(Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
    Tab{3  ,1+K} = 'x_ave (m)';
    Tab{3  ,2+K} = 'y_ave (m)';
    Tab{3  ,3+K} = 'z_ave (m)';    
    if strcmp(CalculType,'EKF')
        Tab{3+I,1+K} = Simulation.Output.User_Def_Sim.INS_EKF.ave_Pos_m(I,1);    
        Tab{3+I,2+K} = Simulation.Output.User_Def_Sim.INS_EKF.ave_Pos_m(I,2);
        Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.INS_EKF.ave_Pos_m(I,3);          
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,1+K} = Simulation.Output.User_Def_Sim.INS_UKF.ave_Pos_m(I,1);    
        Tab{3+I,2+K} = Simulation.Output.User_Def_Sim.INS_UKF.ave_Pos_m(I,2);
        Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.INS_UKF.ave_Pos_m(I,3);          
    end    
    if strcmp(CalculType,'ESKF')
        Tab{3+I,1+K} = Simulation.Output.User_Def_Sim.ESKF.ave_Pos_m(I,1);    
        Tab{3+I,2+K} = Simulation.Output.User_Def_Sim.ESKF.ave_Pos_m(I,2);
        Tab{3+I,3+K} = Simulation.Output.User_Def_Sim.ESKF.ave_Pos_m(I,3);          
    end    
    Tab{3  ,4+K} = 'Lat_ave (deg)';
    Tab{3  ,5+K} = 'lon_ave (deg)';
    Tab{3  ,6+K} = 'alt_ave (deg)';    
    if strcmp(CalculType,'EKF')
        Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.INS_EKF.ave_Pos_deg(I,1);    
        Tab{3+I,5+K} = Simulation.Output.User_Def_Sim.INS_EKF.ave_Pos_deg(I,2);
        Tab{3+I,6+K} = Simulation.Output.User_Def_Sim.INS_EKF.ave_Pos_deg(I,3);     
    end
    if strcmp(CalculType,'UKF')
        Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.INS_UKF.ave_Pos_deg(I,1);    
        Tab{3+I,5+K} = Simulation.Output.User_Def_Sim.INS_UKF.ave_Pos_deg(I,2);
        Tab{3+I,6+K} = Simulation.Output.User_Def_Sim.INS_UKF.ave_Pos_deg(I,3);     
    end   
    if strcmp(CalculType,'ESKF')
        Tab{3+I,4+K} = Simulation.Output.User_Def_Sim.ESKF.ave_Pos_deg(I,1);    
        Tab{3+I,5+K} = Simulation.Output.User_Def_Sim.ESKF.ave_Pos_deg(I,2);
        Tab{3+I,6+K} = Simulation.Output.User_Def_Sim.ESKF.ave_Pos_deg(I,3);     
    end    
end