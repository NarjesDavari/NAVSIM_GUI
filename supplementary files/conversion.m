%Transforation of the estimated position from radian(latitude,
%longitude and altitude) to meters and degree
%Pos_m: Estimated position in meters
%X_i  : Estimated position in radian
function [ Simulation ] = conversion( Simulation , CalculType, ave_sample )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters
    %Equatorial radius
    a                  = 6378137;
    %eccentricity 
    e                  = 0.0818191908426;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    N                  = GetParam(Simulation.Init_Value ,'simulation_number');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if  strcmp(CalculType,'EKF')          
            
        end
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if  strcmp(CalculType,'UKF')      
        end 
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if  strcmp(CalculType,'DR')
        %Dlength:The length of the data(time step)
        Dlength=length(Simulation.Input.Measurements.IMU)-1; 
        %P0_geo:Initial position in navigation frame in all timesteps
        P0_geo=zeros(Dlength,2,N); 
        
        %Meridian radius of curvature
        RN=zeros(Dlength,1);
        %Transverse radius of curvature
        RE=zeros(Dlength,1);        
            
            Simulation.Output.DR.Pos_m=zeros(Dlength,3,N);
            for i=1:N
                lat=Simulation.Output.DR.X_i(:,1,i);
                for k=1:Dlength
                    RN(k)=a*(1-e^2)/(1-e^2*(sin(lat(k)))^2)^1.5;
                    RE(k)=a/(1-e^2*(sin(lat(k)))^2)^0.5;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                P0_geo(:,1,i)=Simulation.Output.DR.X_i(1,1,i)*ones(Dlength,1);
                P0_geo(:,2,i)=Simulation.Output.DR.X_i(1,2,i)*ones(Dlength,1);
        
                Simulation.Output.DR.Pos_m(:,1,i)=(Simulation.Output.DR.X_i(:,1,i)-P0_geo(:,1)).*RN;
                Simulation.Output.DR.Pos_m(:,2,i)=(Simulation.Output.DR.X_i(:,2,i)-P0_geo(:,2)).*cos(Simulation.Output.DR.X_i(:,1,i)).*RE;
    
                Simulation.Output.DR.Pos_m(:,3,i)=Simulation.Output.DR.X_i(:,3,i);%h=z        
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
            end
            %Average of the Estimated position in meter with respect to earth
            %surface in meter        
            Simulation.Output.DR.ave_Pos_m=sum(Simulation.Output.DR.Pos_m,3)/N;            
            
            %Average of the estimated position expressed in the geographic frame in radian 
            ave_Pos_rad=sum(Simulation.Output.DR.X_i,3)/N;
            %Average of the estimated position expressed in the geographic
            %frame in degree
            Simulation.Output.DR.ave_Pos_rad=zeros(Dlength,3);
            Simulation.Output.DR.ave_Pos_rad(:,1) = ave_Pos_rad(:,1);
            Simulation.Output.DR.ave_Pos_rad(:,2) = ave_Pos_rad(:,2);
            Simulation.Output.DR.ave_Pos_rad(:,3) = ave_Pos_rad(:,3);%h=z
        end
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if  strcmp(CalculType,'FeedBack')
        %Dlength:The length of the data(time step)
        Dlength=length(Simulation.Input.Measurements.IMU); 
        %P0_geo:Initial position in navigation frame in all timesteps
        P0_geo=zeros(Dlength- ave_sample + 1,2,N); 
        
        %Meridian radius of curvature
        RN=zeros(Dlength - ave_sample + 1,1);
        %Transverse radius of curvature
        RE=zeros(Dlength - ave_sample + 1,1);        
            Simulation.Output.ESKF.Pos_m=zeros(Dlength - ave_sample + 1,3,N);
            for i=1:N
                lat=Simulation.Output.ESKF.X_i(:,1,i);
                for k=1:Dlength - ave_sample + 1
                    RN(k)=a*(1-e^2)/(1-e^2*(sin(lat(k)))^2)^1.5;
                    RE(k)=a/(1-e^2*(sin(lat(k)))^2)^0.5;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                P0_geo(:,1,i)=Simulation.Output.ESKF.X_i(1,1,i)*ones(Dlength- ave_sample + 1,1);
                P0_geo(:,2,i)=Simulation.Output.ESKF.X_i(1,2,i)*ones(Dlength- ave_sample + 1,1);
        
                Simulation.Output.ESKF.Pos_m(:,1,i)=(Simulation.Output.ESKF.X_i(:,1,i)-P0_geo(:,1)).*RN;
                Simulation.Output.ESKF.Pos_m(:,2,i)=(Simulation.Output.ESKF.X_i(:,2,i)-P0_geo(:,2)).*cos(Simulation.Output.ESKF.X_i(:,1,i)).*RE;
    
                Simulation.Output.ESKF.Pos_m(:,3,i)=Simulation.Output.ESKF.X_i(:,3,i);%h=z        
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
            end
            %Average of the Estimated position in meter with respect to earth
            %surface in meter        
            Simulation.Output.ESKF.ave_Pos_m=sum(Simulation.Output.ESKF.Pos_m,3)/N;            
            
            %Average of the estimated position expressed in the geographic frame in radian 
            ave_Pos_rad=sum(Simulation.Output.ESKF.X_i,3)/N;
            %Average of the estimated position expressed in the geographic
            %frame in degree
            Simulation.Output.ESKF.ave_Pos_rad=zeros(Dlength- ave_sample + 1,3);
            Simulation.Output.ESKF.ave_Pos_rad(:,1) = ave_Pos_rad(:,1) ;
            Simulation.Output.ESKF.ave_Pos_rad(:,2) = ave_Pos_rad(:,2) ;
            Simulation.Output.ESKF.ave_Pos_rad(:,3) = ave_Pos_rad(:,3);%h=z
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  

end

