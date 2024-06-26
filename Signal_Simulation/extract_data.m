%Derivation of the noiseless measurements of the sensors (Gyro,Accel
%,orientation,Depthmeter,DVL)
function [Simulation]=extract_data(Simulation , handles_listbox_log)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Sampling frequency
	fs         = GetParam(Simulation.Init_Value ,'Sampling_Frequency');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfield(Simulation.Input.User_Def_Sim,'Path')
        %Designed path in NED frame in meters
        P = Simulation.Input.User_Def_Sim.Path.P_ned;
        Dlength=length(P);
        xx=P(:,1);
        yy=P(:,2);
        zz=P(:,3);
        dt=1/fs;
        dx=diff(xx);
        dy=diff(yy);
        dz=diff(zz);
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        %Depth or altitudde signals
        Simulation.Input.User_Def_Sim.Depthmeter.Z=zeros(size(P,1),1);
        Simulation.Input.User_Def_Sim.Depthmeter.Z=zz;
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Computation of the euler angles
        dd=sqrt(dx.^2+dy.^2+dz.^2);
        if dd==0
          phi=zeros(Dlength-1,1); 
          theta=zeros(Dlength-1,1);
          psi=zeros(Dlength-1,1);
        else
        a=find(dd);
        xx1=P(1:a(1),1);
        yy1=P(1:a(1),2);
        zz1=P(1:a(1),3);
        dx1=diff(xx1);
        dy1=diff(yy1);
        dz1=diff(zz1);
        %xdir:tangential vector(tangent to the direction of travel)
         psi1=zeros(length(dx1),1);
         theta1=zeros(length(dx1),1);
         phi1=zeros(length(dx1),1);  
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if a<Dlength
        xx2=P(a:end,1);
        yy2=P(a:end,2);
        zz2=P(a:end,3);
        dx2=diff(xx2);
        dy2=diff(yy2);
        dz2=diff(zz2);
        dd2=sqrt(dx2.^2+dy2.^2+dz2.^2);
        xdir=[dx2./dd2,dy2./dd2,dz2./dd2];
        zer=zeros(length(dx2),1);
        one=ones(length(dx2),1);
        %fixed frame For computing of the euler angles
        XX=[one,zer,zer];
        YY=[zer,one,zer];
        ZZ=[zer,zer,one];
    
        ydd=cross(ZZ,xdir,2);% then phi=0    
        ydlength=sqrt(ydd(:,1).^2+ydd(:,2).^2+ydd(:,3).^2);
        ydir=[ydd(:,1)./ydlength, ydd(:,2)./ydlength,ydd(:,3)./ydlength];
    
        zdd=cross(xdir,ydir,2);
        zdlength=sqrt(zdd(:,1).^2+zdd(:,2).^2+zdd(:,3).^2);
        zdir=[zdd(:,1)./zdlength, zdd(:,2)./zdlength,zdd(:,3)./zdlength];
        
        Ndd=cross(ZZ,xdir,2);%line of nodes
        Ndlength=sqrt(Ndd(:,1).^2+Ndd(:,2).^2+Ndd(:,3).^2);
        Ndir=[Ndd(:,1)./Ndlength, Ndd(:,2)./Ndlength,Ndd(:,3)./Ndlength];
        %Computation of Euler angles
        cross_YY_Ndir=cross(YY,Ndir,2);
        sin_psi=sign(cross_YY_Ndir(:,3)).*sqrt(cross_YY_Ndir(:,1).^2+cross_YY_Ndir(:,2).^2+cross_YY_Ndir(:,3).^2);%|YY × Ndir|
        cos_psi=dot(Ndir,YY,2);% Ndir . YY
        psi2=angle(cos_psi+1i*sin_psi);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        xprime=cross(Ndir,ZZ,2);
        cross_xdir_xprime=cross(xprime,xdir,2);        
        sin_theta=sqrt(cross_xdir_xprime(:,1).^2+cross_xdir_xprime(:,2).^2+cross_xdir_xprime(:,3).^2);
        theta2=sign(dot(cross_xdir_xprime,Ndir,2)).*asin(sin_theta);
%         cos_theta=dot(xdir,xprime,2);
%         theta=angle(cos_theta+1i*sin_theta);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         cross_Ndir_ydir=cross(ydir,Ndir,2);
%         sin_phi=sqrt(cross_Ndir_ydir(:,1).^2+cross_Ndir_ydir(:,2).^2+cross_Ndir_ydir(:,3).^2);
%         cos_phi=dot(ydir,Ndir,2);
%         phi=angle(cos_phi+1i*sin_phi);
        phi2=Simulation.Input.User_Def_Sim.Path.User_Roll(a(1):end-1,1);%%%???????
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        phi=zeros(length(phi1)+length(phi2),1);
        phi(1:length(phi1))=phi1;
        phi(length(phi1)+1:end)=phi2;
        
        theta=zeros(length(theta1)+length(theta2),1);
        theta(1:length(theta1))=theta1;
        theta(length(theta1)+1:end)=theta2;
        
        psi=zeros(length(psi1)+length(psi2),1);
        psi(1:length(psi1))=psi1;
        psi(length(psi1)+1:end)=psi2;
        else 
          phi=phi1; 
          theta=theta1;
          psi=psi1;
        end
        end
        
        Euler=[phi,theta,psi];
        Simulation.Input.User_Def_Sim.Path.Euler=zeros(Dlength,3);
        Simulation.Input.User_Def_Sim.Path.Euler(1:Dlength-1,:)=Euler;
        Simulation.Input.User_Def_Sim.Path.Euler(Dlength,:)=Simulation.Input.User_Def_Sim.Path.Euler(Dlength-1,:);
        
        %Inserting of the initial euler angles in memory
        Simulation.Input.InitialParam.InitialEuler = [phi(1),theta(1),psi(1)] * 180/pi;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Signals of the orientation sensor
        Simulation.Input.User_Def_Sim.Gyro_Compass.R=zeros(Dlength,1);
        Simulation.Input.User_Def_Sim.Gyro_Compass.P=zeros(Dlength,1);
        Simulation.Input.User_Def_Sim.Gyro_Compass.Y=zeros(Dlength,1);
        
        Simulation.Input.User_Def_Sim.Gyro_Compass.R=phi;
        Simulation.Input.User_Def_Sim.Gyro_Compass.P=theta;
        Simulation.Input.User_Def_Sim.Gyro_Compass.Y=psi;
        Simulation.Input.User_Def_Sim.Gyro_Compass.R(Dlength)=phi(Dlength-1);
        Simulation.Input.User_Def_Sim.Gyro_Compass.P(Dlength)=theta(Dlength-1);
        Simulation.Input.User_Def_Sim.Gyro_Compass.Y(Dlength)=psi(Dlength-1);     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        diff_psi=diff(psi);
        for i=1:Dlength-2
            if diff_psi(i) > 3*pi/2
                diff_psi(i)=diff_psi(i)-2*pi;
            end
            if diff_psi(i) < -3*pi/2
                diff_psi(i)=diff_psi(i)+2*pi;
            end            
        end
        %Computation of the angular rate of body with respect to inertial frame(Wib_b)
        psi_dot=diff_psi./dt;
        theta_dot=diff(theta)./dt;
        phi_dot=diff(phi)./dt;
%     
        Gyro(:,1) = phi_dot - sin(theta(1:Dlength-2)).* psi_dot;
        Gyro(:,2) = cos(phi(1:Dlength-2)).* theta_dot + sin(phi(1:Dlength-2)).* cos(theta(1:Dlength-2)).* psi_dot;
        Gyro(:,3) = -sin(phi(1:Dlength-2)).* theta_dot + cos(phi(1:Dlength-2)).* cos(theta(1:Dlength-2)).* psi_dot;
%         for i=1:Dlength-2
%             [ C_psi,C_theta,C_phi ] = C_Euler( psi(i),theta(i),phi(i) );  
%             Gyro(i,:)=([phi_dot(i);0;0]+...
%                        C_phi*[0;theta_dot(i);0]+...
%                        C_phi*C_theta*[0;0;psi_dot(i)])';
%         end
        %Gyro signals
        Simulation.Input.User_Def_Sim.IMU.Gyro.wx=zeros(Dlength,1);
        Simulation.Input.User_Def_Sim.IMU.Gyro.wy=zeros(Dlength,1);
        Simulation.Input.User_Def_Sim.IMU.Gyro.wz=zeros(Dlength,1);    
        Simulation.Input.User_Def_Sim.IMU.Gyro.wx=Gyro(:,1);
        Simulation.Input.User_Def_Sim.IMU.Gyro.wy=Gyro(:,2);
        Simulation.Input.User_Def_Sim.IMU.Gyro.wz=Gyro(:,3);
    
        Simulation.Input.User_Def_Sim.IMU.Gyro.wx(Dlength-1)=Gyro(Dlength-2,1);
        Simulation.Input.User_Def_Sim.IMU.Gyro.wy(Dlength-1)=Gyro(Dlength-2,2);
        Simulation.Input.User_Def_Sim.IMU.Gyro.wz(Dlength-1)=Gyro(Dlength-2,3);  
        Simulation.Input.User_Def_Sim.IMU.Gyro.wx(Dlength)=Gyro(Dlength-2,1);
        Simulation.Input.User_Def_Sim.IMU.Gyro.wy(Dlength)=Gyro(Dlength-2,2);
        Simulation.Input.User_Def_Sim.IMU.Gyro.wz(Dlength)=Gyro(Dlength-2,3);    
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %DVL signals in navigation frame
        velocity=[dx,dy,dz]./dt;
        Simulation.Input.User_Def_Sim.Path.velocity=0;
        Simulation.Input.User_Def_Sim.Path.velocity=velocity;
        %Accel signals in navigation frame
        Acceleration=diff(velocity,1,1)./dt;
    
        Simulation.Input.User_Def_Sim.Path.accelerometer=zeros(size(P,1)-1,3);
    
        Simulation.Input.User_Def_Sim.Path.accelerometer(1:size(P,1)-2,:)=[Acceleration(:,1),Acceleration(:,2),Acceleration(:,3)];
    else
        WriteInLogWindow('User-Defined Path have not been loaded',handles_listbox_log); 
        warndlg('User-Defined Path have not been loaded','Warning','modal')          
    end
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    