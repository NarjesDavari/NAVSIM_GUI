%conversion of meter to degree
function [ Simulation ] = m2deg_input( Simulation )

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constant Parameters of The Earth
        R=6378137;%Radius of the earth
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        InitPosdeg         = GetParam(Simulation.Init_Value ,'initial_geo_position');%Initial position in degree
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Dlength=length(Simulation.Input.User_Def_Sim.Path.P_ned);
        
        %P0_geo:initial position in geographic frame (rad)
        P0_rad=zeros(Dlength,2);
        P0_rad(:,1)=InitPosdeg(1)*pi/180*ones(Dlength,1);
        P0_rad(:,2)=InitPosdeg(2)*pi/180*ones(Dlength,1);
        
        %P_geo:Real path in geographic frame in rad
        P_rad=zeros(Dlength,4);
        P_rad(:,1)=(Simulation.Input.User_Def_Sim.Path.P_ned(:,1)/R)+P0_rad(:,1);
        P_rad(:,2)=(Simulation.Input.User_Def_Sim.Path.P_ned(:,2)./(cos(P_rad(:,1))*R))+P0_rad(:,2) ; 
        
        %P_geo:Real path in geographic frame in deg
        Simulation.Input.User_Def_Sim.Path.P_deg=zeros(Dlength,3);
        Simulation.Input.User_Def_Sim.Path.P_deg(:,1)= P_rad(:,1) * 180/pi;
        Simulation.Input.User_Def_Sim.Path.P_deg(:,2)= P_rad(:,2) * 180/pi;
        Simulation.Input.User_Def_Sim.Path.P_deg(:,3)=Simulation.Input.User_Def_Sim.Path.P_ned(:,3);%h=z          

end