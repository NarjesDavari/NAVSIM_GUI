% Transformation of the velocity and the accelerometer values from  navigation to 
% body frame for computing the accelerometer and the DVL signals.
function [Simulation]=CNB_Data(Simulation)

    %Length of time step
    Dlength=length(Simulation.Input.User_Def_Sim.Path.P_ned);    
    
    %Creation of space in memory for the DVL signals
    Simulation.Input.User_Def_Sim.DVL.Velocity=zeros(Dlength-1,3);
    
     %Consideration of the earth rotation and gravity effect
     %Creation of space in memory for the accelerometer signals
     Simulation.Input.User_Def_Sim.IMUer.ffb=zeros(Dlength-1,3);
     for I=1:Dlength-1
         %Computation of transformation matrix
         CBN=InCBN(Simulation.Input.User_Def_Sim.Path.Euler(I,:));
         Simulation.Input.User_Def_Sim.DVL.Velocity(I,:)=(CBN'*Simulation.Input.User_Def_Sim.Path.velocity(I,:)')';
         Simulation.Input.User_Def_Sim.IMUer.ffb(I,:)=(CBN'*Simulation.Input.User_Def_Sim.Path.ffn(I,:)')';
     end
     
     Simulation.Input.InitialParam.InitialVelocity = Simulation.Input.User_Def_Sim.DVL.Velocity(1,:);
     
     Simulation.Input.User_Def_Sim.DVL.Velocity(Dlength,:)=Simulation.Input.User_Def_Sim.DVL.Velocity(Dlength-1,:);
     Simulation.Input.User_Def_Sim.IMUer.ffb(Dlength,:)=Simulation.Input.User_Def_Sim.IMUer.ffb(Dlength-1,:);
end