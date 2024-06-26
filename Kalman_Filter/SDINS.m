%Strapdown inertial navigation system function (Related to the indirect approach, ESKF)
function [Simulation]=SDINS(Simulation , i , I , dt , fc_f_RP , mu , fc_f_accel , fc_f_gyro , CalculType , include_dvl , IMU_Time , DVL_Time , C_DVL_IMU ...
                            , gg , filtered_accel , filtered_gyro , Initialbiasg,tau,ave_sample)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %Constant Parameters of the Earth
    R    =6378137;
    Omega=7.292115e-05;%Earth's rate
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %stepsize
%     dt=1/fs;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Recieving of  accel and gyro signals     

            fb(1)=Simulation.Input.Measurements.IMU(I-1,2,i)-Simulation.Output.INS.X_INS(I-ave_sample,10);
            fb(2)=Simulation.Input.Measurements.IMU(I-1,3,i)-Simulation.Output.INS.X_INS(I-ave_sample,11);
            fb(3)=Simulation.Input.Measurements.IMU(I-1,4,i)-Simulation.Output.INS.X_INS(I-ave_sample,12);
            
            Wib_b(1)=Simulation.Input.Measurements.IMU(I-1,5,i)-Simulation.Output.INS.X_INS(I-ave_sample,13);    
            Wib_b(2)=Simulation.Input.Measurements.IMU(I-1,6,i)-Simulation.Output.INS.X_INS(I-ave_sample,14);    
            Wib_b(3)=Simulation.Input.Measurements.IMU(I-1,7,i)-Simulation.Output.INS.X_INS(I-ave_sample,15);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            gl = Gravity(Simulation,Simulation.Output.INS.X_INS(I-ave_sample,1:3) , gg,I );
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            [ Simulation ] = Digital_Filter( Simulation , fb    , dt , fc_f_RP    , I , 'RollPitch', ave_sample );
            [ Simulation ] = Digital_Filter( Simulation , fb    , dt , fc_f_accel , I , 'Accel', ave_sample);
            [ Simulation ] = Digital_Filter( Simulation , Wib_b , dt , fc_f_gyro  , I , 'Gyro', ave_sample);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            filtered_RP    = Simulation.Output.INS.FilteredSignal.filtered_RP(I- ave_sample + 1,1:3);
            filtered_Accel = Simulation.Output.INS.FilteredSignal.filtered_Accel(I- ave_sample + 1,1:3);
            filtered_Gyro  = Simulation.Output.INS.FilteredSignal.filtered_Gyro(I- ave_sample + 1,1:3);
            Simulation.Output.INS.norm.Accel_norm(I- ave_sample + 1) = abs(norm(filtered_RP) - norm(gl));%fb
            Simulation.Output.INS.norm.Gyro_norm (I- ave_sample + 1) = norm(filtered_Gyro);%Wib_b               
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            %computation of the angular rate of the navigation frame with
            %respect to the inertial frame              
            Win_n = Win_n_calcul( [Simulation.Output.INS.X_INS(I - ave_sample,1:3),Simulation.Output.INS.X_INS(I - ave_sample,4:6)] );            
            %computation of the body rate with respect to the navigation frame.
            if filtered_gyro
                Wnb_b=(filtered_Gyro'-Simulation.Output.INS.Cbn(:,:,I - ave_sample)'*Win_n)';%Wib_b
            else
                Wnb_b=(Wib_b'-Simulation.Output.INS.Cbn(:,:,I - ave_sample)'*Win_n)';%Wib_b
            end
            Simulation.Output.INS.Wnb_b(I - ave_sample +1,:)=Wnb_b;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %computation of the euler angles
            phi = Simulation.Output.INS.X_INS(I - ave_sample,7)+dt*...
            ((Wnb_b(2)*sin(Simulation.Output.INS.X_INS(I - ave_sample,7))+Wnb_b(3)*cos(Simulation.Output.INS.X_INS(I - ave_sample,7)))*...
            tan(Simulation.Output.INS.X_INS(I - ave_sample ,8))+Wnb_b(1));
       
            theta = Simulation.Output.INS.X_INS(I - ave_sample,8)+dt*...
            (Wnb_b(2)*cos(Simulation.Output.INS.X_INS(I - ave_sample,7))-Wnb_b(3)*sin(Simulation.Output.INS.X_INS(I - ave_sample,7)));
      
            psi = Simulation.Output.INS.X_INS(I - ave_sample ,9)+dt*...
                ((Wnb_b(2)*sin(Simulation.Output.INS.X_INS(I - ave_sample,7))+Wnb_b(3)*cos(Simulation.Output.INS.X_INS(I - ave_sample,7)))*...
                sec(Simulation.Output.INS.X_INS(I - ave_sample,8))); 
            if psi > pi
                psi = psi - 2*pi;
            end
            if psi < -pi
                psi = psi + 2*pi;
            end            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            INS_Euler_I = [phi,theta,psi] ;
            Simulation.Output.INS.Cbn(:,:,I - ave_sample + 1) = InCBN(INS_Euler_I);%corrected transformation matrix 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.INS.Alignment.mu=mu;
            if Simulation.Output.INS.norm.Accel_norm(I - ave_sample+1) <  mu
                [ Simulation ] = Alignment4(Simulation , filtered_RP , gl(3)  , I , mu , ave_sample );
                Simulation.Output.INS.Alignment.time(Simulation.Output.Alignment.RP_counter,1)  = Simulation.Input.Measurements.IMU(I - ave_sample+1,1,1);
                
                if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                    Simulation.Output.User_Def_Sim.INS.Alignment.true_roll(Simulation.Output.Alignment.RP_counter,:)  = ...
                    Simulation.Input.User_Def_Sim.Gyro_Compass.R(I);
            
                    Simulation.Output.User_Def_Sim.INS.Alignment.true_pitch(Simulation.Output.Alignment.RP_counter,:) = ...
                    Simulation.Input.User_Def_Sim.Gyro_Compass.P(I);
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %convert accel from body frame to navigation frame
            if filtered_accel
                fnn = (Simulation.Output.INS.Cbn(:,:,I - ave_sample)*filtered_Accel')';%fb
            else
                fnn = (Simulation.Output.INS.Cbn(:,:,I - ave_sample)*fb')';%fb
            end
            Simulation.Output.INS.fnn(I - ave_sample+1,:)=fnn;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Vn_   = Simulation.Output.INS.X_INS(I - ave_sample,4:6);
            Posn_ = Simulation.Output.INS.X_INS(I - ave_sample,1:3);
            %Correction of the coriolis and gravity accelerations 
%             fn = fnn-cross(W_Coriolis,Simulation.Output.X_INS(I-1,4:6))+g1;
            fn(1) = fnn(1)-2*Omega*Vn_(2)*sin(Posn_(1))+(Vn_(1)*Vn_(3)-Vn_(2)^2*tan(Posn_(1)))/(R+Posn_(3))+ gl(1);
            fn(2) = fnn(2)+2*Omega*(Vn_(1)*sin(Posn_(1))+Vn_(3)*cos(Posn_(1)))+Vn_(2)*(Vn_(3)+Vn_(1)*tan(Posn_(1)))/(R+Posn_(3))+ gl(2);
            fn(3) = fnn(3)-2*Omega*Vn_(2)*cos(Posn_(1))-(Vn_(2)^2+Vn_(1)^2)/(R+Posn_(3)) + gl(3);
            
             Simulation.Output.INS.fn(I - ave_sample+1,:)=fn;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %computation of velocity in navigation frame
            %computation of velocity in navigation frame
            fn_  = Simulation.Output.INS.fn(I - ave_sample,:);
%           fn_   = Simulation.Output.INS.X_INS(I-1,10:12);
            Vn(1) = Vn_(1)+dt*(fn_(1)+fn(1))/2;
            Vn(2) = Vn_(2)+dt*(fn_(2)+fn(2))/2;
            Vn(3) = Vn_(3)+dt*(fn_(3)+fn(3))/2;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Posn(1)=Simulation.Output.INS.X_INS(I - ave_sample,1)+dt*...
                    (Simulation.Output.INS.X_INS(I - ave_sample,4)/(R+Simulation.Output.INS.X_INS(I - ave_sample,3)));
            Posn(2)=Simulation.Output.INS.X_INS(I - ave_sample,2)+dt*...
                    (Simulation.Output.INS.X_INS(I - ave_sample,5)*sec(Simulation.Output.INS.X_INS(I - ave_sample,1))/(R+Simulation.Output.INS.X_INS(I - ave_sample,3)));
            Posn(3)=Simulation.Output.INS.X_INS(I - ave_sample,3)+dt*Simulation.Output.INS.X_INS(I - ave_sample,6);  
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %% Modeling bias with Random Walk
            bias_ax = Simulation.Output.INS.X_INS(I - ave_sample,10);
            bias_ay = Simulation.Output.INS.X_INS(I - ave_sample,11);
            bias_az = Simulation.Output.INS.X_INS(I - ave_sample,12);
            bias_gx = Simulation.Output.INS.X_INS(I - ave_sample,13);
            bias_gy = Simulation.Output.INS.X_INS(I - ave_sample,14);
            bias_gz = Simulation.Output.INS.X_INS(I - ave_sample,15);
            
% % %             %% Modeling bias with first order Gauss markov
%               bias_ax = (1-dt/tau(1))*Simulation.Output.INS.X_INS(I-1,10);
% %                 bias_ax = exp(-dt/tau(1))*Simulation.Output.INS.X_INS(I-1,10);    
%              bias_ay = (1-dt/tau(2))*Simulation.Output.INS.X_INS(I-1,11);
% %                 bias_ay = exp(-dt/tau(2))*Simulation.Output.INS.X_INS(I-1,11);
%              bias_az = (1-dt/tau(3))*Simulation.Output.INS.X_INS(I-1,12);
% %                bias_az = exp(-dt/tau(3))*Simulation.Output.INS.X_INS(I-1,12);
%               bias_gx = (1-dt/tau(4))*Simulation.Output.INS.X_INS(I-1,13);
% %                bias_gx = exp(-dt/tau(4))*Simulation.Output.INS.X_INS(I-1,13);
%              bias_gy = (1-dt/tau(5))*Simulation.Output.INS.X_INS(I-1,14);
% %                 bias_gy = exp(-dt/tau(5))*Simulation.Output.INS.X_INS(I-1,14);
%              bias_gz = (1-dt/tau(6))*Simulation.Output.INS.X_INS(I-1,15);
% %                 bias_gz = exp(-dt/tau(6))*Simulation.Output.INS.X_INS(I-1,15);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %State vector of SDINS (Position, Velocity, Orientation, Acceleration)
            X_INS=[Posn,Vn,phi,theta,psi]';%n_frame
            Simulation.Output.INS.X_INS(I - ave_sample+1,:) = [X_INS' ,bias_ax,bias_ay,bias_az,bias_gx,bias_gy,bias_gz];
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
end