    %Adding of the effect of The earth rotation onto inertial signals 
%Reference : Strapdown inertial navigation system (Chapter 3)
function [ Simulation ] =Add_Erotation( Simulation,select_navsim_mode )
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters of the Earth
    R=6378137;%Length of the semi-major axis
    e=0.0818191908426;%e:Major eccentricity of the ellipsoid
    Omega=7.292115e-05;%Earth's rate
    gg   =GetParam(Simulation.Init_Value ,'earth_gravity_constant');%gg:Mass attraction of the Earth
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    %Position in the geograghic frame
    P_geo=Simulation.Input.User_Def_Sim.Path.P_deg;
    
    %Length of time step
    Plength=length(P_geo);
    
    %Velocity in the navigation frame 
    vn=Simulation.Input.User_Def_Sim.Path.velocity;
    
    %Acceleration in the navigation frame
    fn=Simulation.Input.User_Def_Sim.Path.accelerometer;
    
    %Angular velocity of the body with respect to the i-frame(Gyro signals)
    Wib_b(:,1)=Simulation.Input.User_Def_Sim.IMU.Gyro.wx;
    Wib_b(:,2)=Simulation.Input.User_Def_Sim.IMU.Gyro.wy;
    Wib_b(:,3)=Simulation.Input.User_Def_Sim.IMU.Gyro.wz;
    
    %Latitude
    lat=P_geo(1:Plength-1,1) * (pi/180);
    
    %Altitude or height 
    z=P_geo(1:Plength-1,3);
    
    %RN:Meridian radius of curvature
    RN=zeros(Plength-1,1);
    
    %RE:Transverse radius of curvature
    RE=zeros(Plength-1,1);
    
    for i=1:Plength-1
        RN(i)=R*(1-e^2)/(1-e^2*(sin(lat(i)))^2)^1.5;
        RE(i)=R/(1-e^2*(sin(lat(i)))^2)^0.5;
    end
    
    %Mean radius of curvature
    R0=sqrt(RN.*RE);
    
    %Turn rate of the navigation frame with respect to the ECEF
    Wen_n=zeros(Plength-1,3);
    
    %Turn rate of the Earth expressed in the local geographic frame
    Wie_n=zeros(Plength-1,3);
    
    Wen_n(:,1)=vn(:,2)./(RE+z);
    Wen_n(:,2)=-vn(:,1)./(RN+z);
    Wen_n(:,3)=-vn(:,2).*tan(lat)./(RN+z);
    Wie_n(:,1)=Omega*cos(lat);
    Wie_n(:,2)=zeros(Plength-1,1);
    Wie_n(:,3)=-Omega*sin(lat);
    
    %Coriolis effect on the velocity equations
    W_Coriolis=2*Wie_n+Wen_n;
    
    %Angular rate of the navigation frame with respect to the inertial frame
    Win_n=Wie_n+Wen_n;
    
    %Effect of the mass attraction of the Earth
    g=zeros(Plength-1,3);
    g(:,1)=zeros(Plength-1,1);
    g(:,2)=zeros(Plength-1,1);
    g(:,3)=gg*ones(Plength-1,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     g0=9.780318*(1+5.3024e-3*(sin(lat)).^2-5.9e-6*(sin(2*lat)).^2);%%Lat:32.3887749733333
%     x3=Simulation.Input.Measurements.Depth(1,2);
%     g_h=g0./(1+z./R0).^2;%%%
%     g(:,3)=g_h;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Effect of the centripetal acceleration
%     g2=zeros(Plength-1,3);
    g2(:,1)=((Omega^2)*(R0+z)/2).*sin(2*lat);
    g2(:,2)=zeros(Plength-1,1);
    g2(:,3)=((Omega^2)*(R0+z)/2).*(1+cos(2*lat));
   
    %Local gravity vector
    g1n=g;
    
    %Specific force vector as measured by  accelerometers resolved
    %into n-frame with consideration of Coriolis and earth gravity effect
    Simulation.Input.User_Def_Sim.Path.ffn=zeros(Plength-1,3);
    Simulation.Input.User_Def_Sim.Path.ffn=fn+cross(W_Coriolis,vn)-g1n;
    
    %Angular velocity vector as measured by  Gyros with consideration
    %of the effect of the Earth rotation
    Simulation.Input.User_Def_Sim.IMUer.WWib_b=zeros(Plength-1,3);
     for I=1:Plength-1        
        CBN=InCBN(Simulation.Input.User_Def_Sim.Path.Euler(I,:));
        Simulation.Input.User_Def_Sim.IMUer.WWib_b(I,:)=(Wib_b(I,:)'+CBN'*Win_n(I,:)')';
     end 
     Simulation.Input.User_Def_Sim.IMUer.WWib_b(Plength,:)=Simulation.Input.User_Def_Sim.IMUer.WWib_b(Plength-1,:);
end