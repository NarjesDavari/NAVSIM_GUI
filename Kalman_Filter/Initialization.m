%Initialization of the orientation, transformation matrix, vvelocity,
%position, acceleration, and so on.
function [ Simulation,flag_Qadapt ] = Initialization( Simulation , InitPosdeg , fs , CalculType,tau,dt,Include_Q_adaptive,ave_sample,Misalignment_IMU_phins)
            global Updt_Cntr;
            global Cbn_det;
            Updt_Cntr = 0;     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters
    R = 6378137;
    gg = GetParam(Simulation.Init_Value ,'earth_gravity_constant');
    if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
        Simulation.Input.InitialParam.InitialEuler    = GetParam(Simulation.Init_Value ,'Initial_Orientation');
        Simulation.Input.InitialParam.InitialVelocity = GetParam(Simulation.Init_Value ,'Initial_Velocity');
    %%%
     Simulation.Input.InitialParam.Initialbiasg    = GetParam(Simulation.Init_Value ,'initial_bias_gyro');
     Simulation.Input.InitialParam.Initialbiasa    = GetParam(Simulation.Init_Value ,'initial_bias_accel');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
        if strcmp(CalculType,'DR')
            Dlength=length(Simulation.Input.Measurements.IMU)-1;           
            
            Euler1=Simulation.Input.InitialParam.InitialEuler*(pi/180);
            
            Cbn_INS = InCBN(Euler1); 
            Simulation.Output.DR.Cbn                   = zeros(3,3,Dlength);
            Simulation.Output.DR.Cbn(:,:,1)            = Cbn_INS;            
            
            %%convert initial velocity frome  body to navigation
%             V1b=Simulation.Input.User_Def_Sim.InitialVelocity;
            V1b=Simulation.Input.InitialParam.InitialVelocity;
            V1n=(Cbn_INS*V1b')';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Initial Position in radian
            Pos1rad(1)=InitPosdeg(1)*(pi/180);
            Pos1rad(2)=InitPosdeg(2)*(pi/180);        
            Pos1rad(3)=InitPosdeg(3);                       
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %position,velocity,euler angles and accel computed by SDINS in navigation
            %frame
            X1_INS=[Pos1rad,V1n,Euler1(1),Euler1(2),Euler1(3),0 0 0]';%n_frame
            Simulation.Output.DR.X=zeros(Dlength,size(X1_INS,1));
            Simulation.Output.DR.X(1,:) = X1_INS';   
        end
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        if strcmp(CalculType,'FeedBack')
            Dlength = length(Simulation.Input.Measurements.IMU);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Input.Measurements.GPS_Counter   = 1; %GPS Counter
            Simulation.Input.Measurements.DVL_Counter   = 1; %DVL Counter%Path4:1658
            Simulation.Input.Measurements.Depth_Counter = 1; %Depth Counter
            Simulation.Input.Measurements.hdng_Counter  = 1; %Heading Counter
            Simulation.Input.Measurements.incln_Counter = 1; %Inclinometer Counter
            Simulation.Input.Measurements.accelrollpitch_Counter=1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Dlength = length(Simulation.Input.Measurements.IMU);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Cbn_det   = zeros(Dlength,1);  
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
            %Initial acceleration and angular velocity
            Bias1g =Simulation.Input.InitialParam.Initialbiasg;
            W1ib_b(1)=Simulation.Input.Measurements.IMU(1,5,1)+Bias1g(1);    
            W1ib_b(2)=Simulation.Input.Measurements.IMU(1,6,1)+Bias1g(2);    
            W1ib_b(3)=Simulation.Input.Measurements.IMU(1,7,1)+Bias1g(3);
                   
            Bias1a =Simulation.Input.InitialParam.Initialbiasa; 
            f1b(1)=Simulation.Input.Measurements.IMU(1,2,1)+Bias1a(1);
            f1b(2)=Simulation.Input.Measurements.IMU(1,3,1)+Bias1a(2);
            f1b(3)=Simulation.Input.Measurements.IMU(1,4,1)+Bias1a(3);                        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%Alignment:computation of initial transformation matrix
            [ Simulation , gl , ave_fb , ave_W ] = Coarse_Alignment( Simulation,gg,ave_sample,Misalignment_IMU_phins  );
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Euler1                                      = Simulation.Output.INS.X_INS(1,7:9);
            Simulation.Input.InitialParam.InitialEuler  = Euler1;
            Cbn_INS                                     = InCBN(Euler1);
            Simulation.Output.INS.Cbn                   = zeros(3,3,Dlength-ave_sample +1 );
            Simulation.Output.INS.Cbn(:,:,1)            = Cbn_INS;
            Simulation.Output.ESKF.Cbn_corrected        = zeros(3,3,Dlength-ave_sample +1 );
            Simulation.Output.ESKF.Cbn_corrected(:,:,1) = Cbn_INS;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Input.InitialParam.InitialVelocity            = Simulation.Output.INS.X_INS(1,4:6);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.INS.FilteredSignal.filtered_RP         = zeros(Dlength-ave_sample +1 ,3);
            Simulation.Output.INS.FilteredSignal.filtered_RP(1,:)    = ave_fb;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.INS.FilteredSignal.filtered_Accel      = zeros(Dlength-ave_sample +1 ,3);
            Simulation.Output.INS.FilteredSignal.filtered_Accel(1,:) = ave_fb;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.INS.FilteredSignal.filtered_Gyro       = zeros(Dlength-ave_sample +1 ,3);
            Simulation.Output.INS.FilteredSignal.filtered_Gyro(1,:)  = ave_W;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.Alignment.norm.Accel_norm    = zeros(Dlength-ave_sample +1 ,1);
            Simulation.Output.Alignment.norm.Gyro_norm     = zeros(Dlength-ave_sample +1 ,1);
            Simulation.Output.Alignment.norm.Accel_norm(1) = abs(norm(ave_fb) -  norm(gl));
            Simulation.Output.Alignment.norm.Gyro_norm (1) = norm(ave_W);      
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.Alignment.phi              = zeros(Dlength-ave_sample +1 ,1);
            Simulation.Output.Alignment.theta            = zeros(Dlength-ave_sample +1 ,1);
            Simulation.Output.Alignment.ave_phi          = zeros(fix(Dlength-ave_sample +1 /1),1);
            Simulation.Output.Alignment.ave_theta        = zeros(fix(Dlength-ave_sample +1 /1),1);            
%             Simulation.Output.Alignment.time         = zeros(Dlength-ave_sample +1 ,1);
            Simulation.Output.Alignment.RP_counter       = 1;
            Simulation.Output.Alignment.RP_counter2      = 0;
            Simulation.Output.Alignment.ave_RP_counter   = 1;
            Simulation.Output.Alignment.RP_active        = 0;
            
            Simulation.Output.Alignment.theta(1,1)       = Simulation.Output.INS.X_INS(1,8);
            Simulation.Output.Alignment.phi(1,1)         = Simulation.Output.INS.X_INS(1,7);
            Simulation.Output.Alignment.ave_theta(1,1)   = Simulation.Output.INS.X_INS(1,8);
            Simulation.Output.Alignment.ave_phi(1,1)     = Simulation.Output.INS.X_INS(1,7);           
%             Simulation.Output.Alignment.time         = Simulation.Input.Measurements.IMU(1,1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.INS.Alignment.true_roll  = zeros(Dlength,1);
                Simulation.Output.User_Def_Sim.INS.Alignment.true_pitch = zeros(Dlength,1);
                Simulation.Output.User_Def_Sim.INS.Alignment.true_roll(1)  = Euler1(1);
                Simulation.Output.User_Def_Sim.INS.Alignment.true_pitch(1) = Euler1(2);
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            W_Coriolis = Coriolis_correction( Simulation.Output.INS.X_INS(1,1:6)  );
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.INS.fnn      = zeros(Dlength-ave_sample ,3);
            f1nn                           = (Cbn_INS*ave_fb')';%%convert initial Accelerometer frome  body to navigation
            %Simulation.Output.INS.fnn(1,:) = f1nn;
            f1n                            = f1nn - cross(W_Coriolis,Simulation.Output.INS.X_INS(1,4:6)) + gl;
            Simulation.Output.INS.fn       = zeros(Dlength-ave_sample +1 ,3);
            Simulation.Output.INS.fn(1,:)  = f1n;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %error states                
            dX1                            = (zeros(1,15))';%column vector
            Simulation.Output.ESKF.dX      = zeros(Dlength-ave_sample +1 ,size(dX1,1));
            Simulation.Output.ESKF.dX(1,:) = dX1';        
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %O_corrected:corrected ouyput(position,veloccity and euler angles)
            Simulation.Output.ESKF.O_corrected      = zeros(Dlength-ave_sample +1 ,size(dX1,1));
            Simulation.Output.ESKF.O_corrected(1,:)=Simulation.Output.INS.X_INS(1,1:15);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.Kalman_mtx.Q_diag = zeros(Dlength-ave_sample ,size(dX1,1));
            Simulation.Output.Kalman_mtx.F_diag = zeros(Dlength-ave_sample ,size(dX1,1));
            Simulation.Output.Kalman_mtx.G_diag = zeros(Dlength-ave_sample ,24);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
            Simulation.Output.Kalman_mtx.dz_gps              = zeros(Dlength-ave_sample +1 ,2);
            Simulation.Output.Kalman_mtx.dz_depth            = zeros(Dlength-ave_sample +1 ,1);
            Simulation.Output.Kalman_mtx.dz_Vn               = zeros(Dlength-ave_sample +1 ,3);
            Simulation.Output.Kalman_mtx.dz_rollpitch        = zeros(Dlength-ave_sample +1 ,2);
            Simulation.Output.Kalman_mtx.dz_accelrollpitch   = zeros(Dlength-ave_sample +1 ,2);
            Simulation.Output.Kalman_mtx.dz_heading          = zeros(Dlength-ave_sample +1 ,1);
            
            Simulation.Output.Kalman_mtx.S_gps               = zeros(Dlength-ave_sample +1 ,2);
            Simulation.Output.Kalman_mtx.S_depth             = zeros(Dlength-ave_sample +1 ,1);
            Simulation.Output.Kalman_mtx.S_Vn                = zeros(Dlength-ave_sample +1 ,3);
            Simulation.Output.Kalman_mtx.S_rollpitch         = zeros(Dlength-ave_sample +1 ,2);
            Simulation.Output.Kalman_mtx.S_accelrollpitch    = zeros(Dlength-ave_sample +1 ,2);
            Simulation.Output.Kalman_mtx.S_heading           = zeros(Dlength-ave_sample +1 ,1); 
            
            Simulation.Input.Measurements.GPS_Miss_Counter   = 0;
            Simulation.Input.Measurements.Depth_Miss_Counter = 0;
            Simulation.Input.Measurements.DVL_Miss_Counter   = 0;
            Simulation.Input.Measurements.Hdng_Miss_Counter  = 0;
            
            Simulation.Input.Measurements.GPS_Miss_Counter2   = 0;
            Simulation.Input.Measurements.Depth_Miss_Counter2 = 0;
            Simulation.Input.Measurements.DVL_Miss_Counter2   = 0;
            Simulation.Input.Measurements.Hdng_Miss_Counter2  = 0;            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.Kalman_mtx.adaptive_innovation=0;
            Simulation.Output.Kalman_mtx.adaptive_residual=0;
            Simulation.Output.Kalman_mtx.update_counter =0;
            Simulation.Output.Kalman_mtx.Number_adaptive=0;                                                
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.Kalman_mtx.Q_diag=zeros(Dlength-ave_sample,size(dX1,1));
            Simulation.Output.Kalman_mtx.norm_Q=zeros(Dlength-ave_sample,1);
            Simulation.Output.Kalman_mtx.tun=zeros(Dlength-ave_sample,1);
            %corrected position,velocity and accel(in navigation frame)
            x1=[Simulation.Output.INS.X_INS(1,1:6),Simulation.Output.INS.fnn(1,:)];
            C1=Simulation.Output.INS.Cbn(:,:,1);
            [Simulation,flag_Qadapt]=AQ_calcul(x1,C1,Simulation,fs,1,gg,tau,dt,Include_Q_adaptive,0,0);
                                              
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Simulation.Output.User_Def_Sim.Kalman_mtx.P = diag([1,0.01,0.01,0.01,0.018773,0.018773,0.018773]);
            Simulation.Output.Kalman_mtx.P = zeros(15,15);
            Simulation.Output.Kalman_mtx.P(1,1) = 0; %1e-6;
            Simulation.Output.Kalman_mtx.P(2,2) = 0; % 1e-6;
            Simulation.Output.Kalman_mtx.P(3,3) = 0; % 1e-6;
            Simulation.Output.Kalman_mtx.P(4,4) = 0; % 1e-6;
            Simulation.Output.Kalman_mtx.P(5,5) = 0; % 1e-6;
            Simulation.Output.Kalman_mtx.P(6,6) = 0; % 1e-6;
            Simulation.Output.Kalman_mtx.P(7,7) = 0; % 1e-6;
            Simulation.Output.Kalman_mtx.P(8,8) = 0; % 1e-6;
            Simulation.Output.Kalman_mtx.P(9,9) =  0; %1e-6;
            Simulation.Output.Kalman_mtx.P(10,10) = 1e-4;
            Simulation.Output.Kalman_mtx.P(11,11) = 1e-4;
            Simulation.Output.Kalman_mtx.P(12,12) =  1e-4;
            Simulation.Output.Kalman_mtx.P(13,13) =  1e-4;
            Simulation.Output.Kalman_mtx.P(14,14) =  1e-4;
            Simulation.Output.Kalman_mtx.P(15,15) =  1e-4;
            Simulation.Output.Kalman_mtx.P0_Bias=[Simulation.Output.Kalman_mtx.P(10,10) Simulation.Output.Kalman_mtx.P(11,11) Simulation.Output.Kalman_mtx.P(12,12)...
               Simulation.Output.Kalman_mtx.P(13,13) Simulation.Output.Kalman_mtx.P(14,14)  Simulation.Output.Kalman_mtx.P(15,15)];
            
            Simulation.Output.Kalman_mtx.P_diag=zeros(Dlength,size(dX1,1));
            Simulation.Output.Kalman_mtx.P_diag(1,:)=[Simulation.Output.Kalman_mtx.P(1,1) Simulation.Output.Kalman_mtx.P(2,2) Simulation.Output.Kalman_mtx.P(3,3)...
                                                      Simulation.Output.Kalman_mtx.P(4,4) Simulation.Output.Kalman_mtx.P(5,5) Simulation.Output.Kalman_mtx.P(6,6)...
                                                      Simulation.Output.Kalman_mtx.P(7,7) Simulation.Output.Kalman_mtx.P(8,8) Simulation.Output.Kalman_mtx.P(9,9)...
                                                      Simulation.Output.Kalman_mtx.P(10,10) Simulation.Output.Kalman_mtx.P(11,11) Simulation.Output.Kalman_mtx.P(12,12)...
                                                      Simulation.Output.Kalman_mtx.P(13,13) Simulation.Output.Kalman_mtx.P(14,14)  Simulation.Output.Kalman_mtx.P(15,15)];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%             Simulation.Output.Kalman_mtx.Q_adaptive=Simulation.Output.Kalman_mtx.Q;
            Simulation.Output.Kalman_mtx.V=zeros(Dlength-ave_sample +1,15);
            Simulation.Output.INS.Wnb_b=zeros(Dlength,3);

            Simulation.Output.Kalman_mtx.update_adaptive_counter=0;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             Simulation.Output.Kalman_mtx.R_adaptive.R_GPS=zeros(length(Simulation.Input.Measurements.GPS),2);
            Simulation.Input.Measurements.GPS_Counter_R=1;
            Simulation.Output.Kalman_mtx.R_adaptive.R_GPS(1:Simulation.Input.Measurements.GPS_Counter,1)=Simulation.Output.Kalman_mtx.R.r_Lat;
            Simulation.Output.Kalman_mtx.R_adaptive.R_GPS(1:Simulation.Input.Measurements.GPS_Counter,2)=Simulation.Output.Kalman_mtx.R.r_lon;
            
            Simulation.Output.Kalman_mtx.R_adaptive.R_accelrollpitch=zeros(length(Simulation.Input.Measurements.IMU)-ave_sample +1,2);
            Simulation.Input.Measurements.accelrollpitch_Counter_R=1;
            Simulation.Output.Kalman_mtx.R_adaptive.R_accelrollpitch(1:Simulation.Input.Measurements.accelrollpitch_Counter,1)=Simulation.Output.Kalman_mtx.R.r_aroll;
            Simulation.Output.Kalman_mtx.R_adaptive.R_accelrollpitch(1:Simulation.Input.Measurements.accelrollpitch_Counter,2)=Simulation.Output.Kalman_mtx.R.r_apitch;
             
            Simulation.Output.Kalman_mtx.R_adaptive.R_Depth = zeros(length(Simulation.Input.Measurements.Depth),1);
            Simulation.Input.Measurements.Depth_Counter_R=1;
            Simulation.Output.Kalman_mtx.R_adaptive.R_Depth(1:Simulation.Input.Measurements.Depth_Counter,1) =Simulation.Output.Kalman_mtx.R.r_alt;
             
            Simulation.Output.Kalman_mtx.R_adaptive.R_DVL = zeros(length(Simulation.Input.Measurements.DVL),3);
            Simulation.Input.Measurements.DVL_Counter_R=1;
            Simulation.Output.Kalman_mtx.R_adaptive.R_DVL(1:Simulation.Input.Measurements.DVL_Counter,1) =Simulation.Output.Kalman_mtx.R.r_vx;
            Simulation.Output.Kalman_mtx.R_adaptive.R_DVL(1:Simulation.Input.Measurements.DVL_Counter,2) =Simulation.Output.Kalman_mtx.R.r_vy;
            Simulation.Output.Kalman_mtx.R_adaptive.R_DVL(1:Simulation.Input.Measurements.DVL_Counter,3) =Simulation.Output.Kalman_mtx.R.r_vz;
            
            Simulation.Output.Kalman_mtx.R_adaptive.R_rollpitch = zeros(length(Simulation.Input.Measurements.RollPitch),2);
            Simulation.Output.Kalman_mtx.R_adaptive.R_Heading = zeros(length(Simulation.Input.Measurements.Heading),1);
            Simulation.Input.Measurements.hdng_Counter_R=1;
            Simulation.Output.Kalman_mtx.R_adaptive.R_Heading(1:Simulation.Input.Measurements.hdng_Counter,1) =Simulation.Output.Kalman_mtx.R.r_yaw;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.Kalman_mtx.K_gps            = zeros(Dlength-ave_sample +1 ,2);
            Simulation.Output.Kalman_mtx.K_depth          = zeros(Dlength-ave_sample +1 ,1);
            Simulation.Output.Kalman_mtx.K_Vn             = zeros(Dlength-ave_sample +1 ,3);
            Simulation.Output.Kalman_mtx.K_arp            = zeros(Dlength-ave_sample +1 ,2);
            Simulation.Output.Kalman_mtx.K_hdng           = zeros(Dlength-ave_sample +1 ,1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.ESKF.Correction_Counter = 0;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Variational Bayesian
            alpha_VB=[1,1,1,1,1,1,1,1,1];
            beta_VB=[Simulation.Output.Kalman_mtx.R.r_Lat,Simulation.Output.Kalman_mtx.R.r_lon,Simulation.Output.Kalman_mtx.R.r_alt,...
                Simulation.Output.Kalman_mtx.R.r_vx,Simulation.Output.Kalman_mtx.R.r_vy,Simulation.Output.Kalman_mtx.R.r_vz,...
                Simulation.Output.Kalman_mtx.R.r_aroll,Simulation.Output.Kalman_mtx.R.r_apitch,Simulation.Output.Kalman_mtx.R.r_yaw];
             
             Simulation.Output.Kalman_mtx.alpha_VB=(alpha_VB)';
             Simulation.Output.Kalman_mtx.alpha_VB_init=(alpha_VB)';
             Simulation.Output.Kalman_mtx.beta_VB_init=(beta_VB)';
             Simulation.Output.Kalman_mtx.beta_VB=(beta_VB)';
            
            
        end
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
        if strcmp(CalculType,'FeedForward')
        end
end