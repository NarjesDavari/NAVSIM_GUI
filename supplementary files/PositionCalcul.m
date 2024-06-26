%Main program for estimation of the states of the system 
function [Simulation]=PositionCalcul(Simulation,CalculType,i,handles_listbox_log)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Constant Parameters of the Earth
Re=6378137;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
select_navsim_mode  = Simulation.Input.NAVSIM_Mode;
fs                  = GetParam(Simulation.Init_Value ,'Sampling_Frequency');
InitPosdeg          = GetParam(Simulation.Init_Value ,'initial_geo_position');
InitPosm            = GetParam(Simulation.Init_Value ,'Initial_m_Position');
include_heading     = GetParam(Simulation.Parameters_GyroCompass ,'include_heading');
include_rollpitch   = GetParam(Simulation.Parameters_GyroCompass ,'include_roll&pitch');
include_dvl         = GetParam(Simulation.Parameters_DVL ,'include_dvl');
include_depthmeter  = GetParam(Simulation.Parameters_DepthMeter ,'include_depthmeter');

alpha               = GetParam(Simulation.Parameters_UKF ,'edit_alpha');
beta                = GetParam(Simulation.Parameters_UKF ,'edit_beta');
kappa               = GetParam(Simulation.Parameters_UKF ,'edit_kappa');

% [ GyroError,AccelError,DVLError,DepthError,GCmps ] = WNSigma_Calcul( Simulation );
% [ Var ] = Signal_Var( Simulation );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(select_navsim_mode,'User Defined Path Simulation')
    %stepsize
    dt=1/fs;
    %length of data
    Dlength=length(Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax);    
    Simulation.Output.User_Def_Sim.Noise.DVL.DVL_length            = length(Simulation.Output.User_Def_Sim.Noise.DVL.Vx);
    Simulation.Output.User_Def_Sim.Noise.Depthmeter.Depth_length   = length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z);
    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_length = length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll);
    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_length  = length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw);
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    if strcmp(CalculType,'EKF')
        WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
        h = waitbar(0,[CalculType ' computations is runing ... ,Simulation No. ' num2str(i)]);  
        %Alignment:computation of initial transformation matrix
        Euler1=Simulation.Input.User_Def_Sim.InitialEuler;     
        %Initial transformation matrix (direction cosine matrix)
        C_BtoN = InCBN(Euler1,select_navsim_mode); 

        %%Initial velocity in body frame
        V1b=Simulation.Input.User_Def_Sim.InitialVelocity;
        %%convert initial velocity frome body to navigation(NED) frame   
        V1n=(C_BtoN*V1b')'; 
        
        %Pos1rad:Initial position in navigation frame in radian(latitude,longitde
        %and altitude)
        %P_ned:Designed (Reference) path with respect to the surface of the
        %earth in meters
        Pos1rad(1)=(Simulation.Input.User_Def_Sim.Path.P_ned(1,1)/Re)+InitPosdeg(1)*(pi/180);
        Pos1rad(2)=(Simulation.Input.User_Def_Sim.Path.P_ned(1,2)/(cos(Pos1rad(1))*Re))+InitPosdeg(2)*(pi/180);        
        Pos1rad(3)= Simulation.Input.User_Def_Sim.Path.P_ned(1,3);  
        
        %Comutation of local gravity vector
        g1 = Gravity( Pos1rad );
        Simulation.Output.User_Def_Sim.INS_EKF.gl=zeros(Dlength,3); 
        Simulation.Output.User_Def_Sim.INS_EKF.gl(1,:)=g1;
        %Initial acceleration in body frame
        f1b(1)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax(1,i);
        f1b(2)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ay(1,i);
        f1b(3)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.az(1,i);
        %Initial angular velocity in body frame    
        Wib_b1(1)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wx(1,i);    
        Wib_b1(2)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wy(1,i);    
        Wib_b1(3)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wz(1,i);         
        
        %Computation of coriolis effect
        W_Coriolis = Coriolis_correction( [Pos1rad V1n] );
        
        %computation of the angular rate of the navigation (NED) frame with
        %respect to the inertial frame        
        Win_n1 = Win_n_calcul( [Pos1rad V1n] );
        
        %computation of the body rate with respect to the
        %navigation frame.
        Wnb_b1=(Wib_b1'-C_BtoN'*Win_n1)';
        
        %%convert initial Accelerometer frome  body to navigation
        f1n=(C_BtoN*f1b')';  
        %Correction of the coriolis and gravity accelerations 
        f1n=f1n-cross(W_Coriolis,V1n)-g1;
        
        %Initial state of the system in navigation frame
        X1=[Pos1rad,V1n,f1n,Euler1,Wnb_b1]';%n_frame
        
        %Creation of a space in memory for estimated mean and covariance of
        %the state( Reserve space for estimates)        
        Simulation.Output.User_Def_Sim.INS_EKF.X=zeros(Dlength,size(X1,1));        
        Simulation.Output.User_Def_Sim.INS_EKF.X(1,:) = X1';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Simulation.Input.User_Def_Sim.TempSig.DVL_Counter  = 2;%DVL Counter          
        Simulation.Input.User_Def_Sim.TempSig.Depth_Counter= 2;%Depth Counter   
        Simulation.Input.User_Def_Sim.TempSig.incln_Counter= 2;%Inclinometer Counter
        Simulation.Input.User_Def_Sim.TempSig.hdng_Counter = 2;%Heading Counter        
        % A temporary register for recieving the auxiliary signals    
        Simulation.Input.User_Def_Sim.TempSig.DVL   = zeros(Simulation.Output.User_Def_Sim.Noise.DVL.DVL_length,4);
        Simulation.Input.User_Def_Sim.TempSig.Depth = zeros(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Depth_length,2);
        Simulation.Input.User_Def_Sim.TempSig.Incln = zeros(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_length,3);
        Simulation.Input.User_Def_Sim.TempSig.Hdng  = zeros(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_length,2);        
        
        Simulation.Input.User_Def_Sim.TempSig.DVL(2,1)   = Simulation.Output.User_Def_Sim.Noise.DVL.Time(2);
        Simulation.Input.User_Def_Sim.TempSig.DVL(2,2:4) = [Simulation.Output.User_Def_Sim.Noise.DVL.Vx(2),...
                                                            Simulation.Output.User_Def_Sim.Noise.DVL.Vy(2),...
                                                            Simulation.Output.User_Def_Sim.Noise.DVL.Vz(2)];
        Simulation.Input.User_Def_Sim.TempSig.Depth(2,1) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Time(2);
        Simulation.Input.User_Def_Sim.TempSig.Depth(2,2) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z(2);
        
        Simulation.Input.User_Def_Sim.TempSig.Incln(2,1) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_Time(2);
        Simulation.Input.User_Def_Sim.TempSig.Incln(2,2:3) = [Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll(2),...
                                                              Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NPitch(2)  ];   
        Simulation.Input.User_Def_Sim.TempSig.Hdng(2,1) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_Time(2);
        Simulation.Input.User_Def_Sim.TempSig.Hdng(2,2) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw(2);        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
        %computation of Process noise matrix              
        [Q]=KlmnMatx(X1,dt,Simulation,select_navsim_mode);
        %Initial process noise matrix
        Simulation.Output.User_Def_Sim.Kalman_mtx.Q1=Q;
        
        %The measurement model matrix(H) and the measurement error
        %variance(R). 
%         H=Simulation.Output.User_Def_Sim.Kalman_mtx.H;
%         R=Simulation.Output.User_Def_Sim.Kalman_mtx.R.Rmatrx;
        
        %the initial estimate of the state covariance matrix
        P1=zeros(15);
%         P1=Q;
%          P1=diag([0           ,0            ,Var.var_alt,...
%                   Var.var_vx  ,Var.var_vy   ,Var.var_vz ,...
%                   Var.var_ax  ,Var.var_ay   ,Var.var_az ,...
%                   Var.var_roll,Var.var_pitch,Var.var_yaw,...
%                   Var.var_wx  ,Var.var_wy   ,Var.var_wz  ]);
%         Simulation.Output.INS_Kalm.P(1,:) = diag(P1);
        
        %Main loop of computation
        for I=2:Dlength
            %Recieving of  accel and gyro signals     
            Wib_b(1)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wx(I,i);    
            Wib_b(2)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wy(I,i);    
            Wib_b(3)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wz(I,i);
            
            fb(1)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax(I,i);
            fb(2)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ay(I,i);
            fb(3)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.az(I,i);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Win_n = Win_n_calcul( X1 );
            Wnb_b=Wib_b'-C_BtoN'*Win_n;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Computation of transformation matrix...
            if include_heading && include_rollpitch
                %... using estimated euler angles
                NC_BtoN = InCBN([X1(12) X1(11) X1(10)],select_navsim_mode);
            else
                %...using algorithm of computation of attitude
                NC_BtoN = New_C_BtoN(dt,C_BtoN,Wnb_b);
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
            gl = Gravity( X1 );
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.User_Def_Sim.INS_EKF.gl(I,:)=gl;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [Simulation]=KlmnIniMatx(Simulation,I);            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Y=[];%measurement vector
            if include_depthmeter
                if Simulation.Input.User_Def_Sim.TempSig.Depth_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z)
                    if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1))
                        %Recieving of depth(altitude) signals
                        Y=[Y,Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,2)];
                    end
                end                    
            end               
            if include_dvl
                if Simulation.Input.User_Def_Sim.TempSig.DVL_Counter <= length(Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
                    if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))
                        %Recieving of velocity signals in body frame
                        vb=[Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,2),...
                            Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,3),....
                            Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,4)];
                        %Transformation of velocity from body to navigation
                        %frame
                        vn = (NC_BtoN*vb')' ;
                        Y=[Y,vn];
                    end
                end
            end
            %%Transformation of acceleration from body to navigation
            %frame
            fn = (NC_BtoN*fb')' ;
            %Correction of the coriolis and gravity accelerations
            if include_dvl
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))
                    fn=fn-cross(W_Coriolis,vn)-g1;
                else
                    fn=fn-cross(W_Coriolis,X1(4:6)')-g1;
                end
            else
                fn=fn-cross(W_Coriolis,X1(4:6)')-g1;
            end
            Y=[Y,fn];
            %
           if include_rollpitch
                if Simulation.Input.User_Def_Sim.TempSig.incln_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll)
                    if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,1))               
                        %%Recieving of euler angles from orientation sensor
                        Y=[Y,Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,2),...
                             Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,3)];
                    end
                end
           end
           %
           if include_heading
                if Simulation.Input.User_Def_Sim.TempSig.hdng_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw)
                    if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,1))        
                        %%Recieving of euler angles from orientation sensor
                        Y=[Y,Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,2) ];
                    end
                end
           end           
            
           Y=[Y,Wnb_b'];
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           Y1=Y' ;  
           W_Coriolis = Coriolis_correction( X1 );
           Q = KlmnMatx(X1,dt,Simulation,select_navsim_mode);
           Simulation.Output.User_Def_Sim.Kalman_mtx.Q=Q;
           F = jacob_f(X1,dt);
           Simulation.Output.User_Def_Sim.Kalman_mtx.F=0;        
           Simulation.Output.User_Def_Sim.Kalman_mtx.F=F;
           %Estimate with EKF
           [X1,P1] = ekf_predict(X1,P1,Q,F,dt);
           if (~isempty (Simulation.Output.User_Def_Sim.Kalman_mtx.H))
                [X1,P1] = kf_update(X1,P1,Y1,Simulation.Output.User_Def_Sim.Kalman_mtx.H,Simulation.Output.User_Def_Sim.Kalman_mtx.R.Rmatrx);
           end
           %Storing of estimates in memory
           Simulation.Output.User_Def_Sim.INS_EKF.X(I,:) = X1';
           %Transformation matrix of body frame to navigation frame
           C_BtoN=NC_BtoN;
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %Recieving of auxiliary signals and inserting in the temporary
           %register
           if Simulation.Input.User_Def_Sim.TempSig.Depth_Counter < length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z)
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1))
                        
                    Simulation.Input.User_Def_Sim.TempSig.Depth_Counter = Simulation.Input.User_Def_Sim.TempSig.Depth_Counter + 1;                    
                    Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Time(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter);
                    Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,2) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,i);
                        
                end
           end
           if Simulation.Input.User_Def_Sim.TempSig.DVL_Counter < length (Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))
                        
                    Simulation.Input.User_Def_Sim.TempSig.DVL_Counter = Simulation.Input.User_Def_Sim.TempSig.DVL_Counter + 1;
                    Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1) = Simulation.Output.User_Def_Sim.Noise.DVL.Time(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter);
                    Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,2:4) = [Simulation.Output.User_Def_Sim.Noise.DVL.Vx(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,i),...
                                                                                                                            Simulation.Output.User_Def_Sim.Noise.DVL.Vy(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,i),...
                                                                                                                            Simulation.Output.User_Def_Sim.Noise.DVL.Vz(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,i)];
                end
           end
           if Simulation.Input.User_Def_Sim.TempSig.incln_Counter < length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll)
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,1))
                    Simulation.Input.User_Def_Sim.TempSig.incln_Counter = Simulation.Input.User_Def_Sim.TempSig.incln_Counter + 1;
                    Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,1)   = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_Time(Simulation.Input.User_Def_Sim.TempSig.incln_Counter);
                    Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,2:3) = [Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,i),...
                                                                                                                            Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NPitch(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,i)];                                
                end
           end
           if Simulation.Input.User_Def_Sim.TempSig.hdng_Counter < length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw)
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,1))
                    Simulation.Input.User_Def_Sim.TempSig.hdng_Counter = Simulation.Input.User_Def_Sim.TempSig.hdng_Counter + 1;
                    Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,1) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_Time(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter);
                    Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,2) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,i);
                                
                end
           end           
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
           if rem(I,10000)
                waitbar(I/Dlength,h);
           end
        end
        delete(h)
    end
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    if  strcmp(CalculType,'UKF')
        WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
        h = waitbar(0,[CalculType ' computations is runing ... ,Simulation No. ' num2str(i)]);
        %Alignment:computation of initial transformation matrix
        Euler1=Simulation.Input.User_Def_Sim.InitialEuler;
        %%Initial velocity in body frame
        V1b=Simulation.Input.User_Def_Sim.DVL.Velocity(1,:);
        %Initial transformation matrix (direction cosine matrix)
        C_BtoN = InCBN(Euler1,select_navsim_mode);        
        V1n=(C_BtoN*V1b')';%%convert initial velocity frome  body to navigation     
        
        %Pos1rad:Initial position in navigation frame in radian(latitude,longitde
        %and altitude) 
        %P_ned:Designed (Reference) path with respect to the surface of the
        %earth in meters        
        Pos1rad(1)=(Simulation.Input.User_Def_Sim.Path.P_ned(1,1)/Re)+InitPosdeg(1)*(pi/180);
        Pos1rad(2)=(Simulation.Input.User_Def_Sim.Path.P_ned(1,2)/(cos(Pos1rad(1))*Re))+InitPosdeg(2)*(pi/180);        
        Pos1rad(3)=Simulation.Input.User_Def_Sim.Path.P_ned(1,3);
        
        %Initial acceleration and angular velocity
        f1b(1)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax(1,i);
        f1b(2)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ay(1,i);
        f1b(3)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.az(1,i);
            
        Wib_b1(1)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wx(1,i);    
        Wib_b1(2)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wy(1,i);    
        Wib_b1(3)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wz(1,i);   
        %Comutation of local gravity vector
        g1 = Gravity( Pos1rad );
        %Computation of coriolis effect
        W_Coriolis = Coriolis_correction( [Pos1rad V1n] );
        %computation of the angular rate of the navigation (NED) frame with
        %respect to the inertial frame         
        Win_n1 = Win_n_calcul( [Pos1rad V1n] );
        %computation of the body rate with respect to the
        %navigation frame.        
        Wnb_b1=(Wib_b1'-C_BtoN'*Win_n1)';
        
        f1n=(C_BtoN*f1b')';%%convert initial Accelerometer frome  body to navigation
        %Correction of the coriolis and gravity accelerations 
        f1n=f1n-cross(W_Coriolis,V1n)-g1;
        %the initial state of the system in navigation frame
        X1=[Pos1rad,V1n,f1n,Euler1,Wnb_b1]';%n_frame
        Simulation.Output.User_Def_Sim.INS_UKF.X=zeros(Dlength,size(X1,1));        
        Simulation.Output.User_Def_Sim.INS_UKF.X(1,:) = X1';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Simulation.Input.User_Def_Sim.TempSig.DVL_Counter  = 2;%DVL Counter          
        Simulation.Input.User_Def_Sim.TempSig.Depth_Counter= 2;%Depth Counter   
        Simulation.Input.User_Def_Sim.TempSig.incln_Counter= 2;%Inclinometer Counter
        Simulation.Input.User_Def_Sim.TempSig.hdng_Counter = 2;%Heading Counter          
        % A temporary register for recieving the auxiliary signals     
        Simulation.Input.User_Def_Sim.TempSig.DVL        = zeros(Simulation.Output.User_Def_Sim.Noise.DVL.DVL_length,4);
        Simulation.Input.User_Def_Sim.TempSig.Depth      = zeros(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Depth_length,2);
        Simulation.Input.User_Def_Sim.TempSig.Incln      = zeros(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_length,3);
        Simulation.Input.User_Def_Sim.TempSig.Hdng       = zeros(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_length,2);        
        
        Simulation.Input.User_Def_Sim.TempSig.DVL(2,1)   = Simulation.Output.User_Def_Sim.Noise.DVL.Time(2);
        Simulation.Input.User_Def_Sim.TempSig.DVL(2,2:4) = [Simulation.Output.User_Def_Sim.Noise.DVL.Vx(2),...
                                                            Simulation.Output.User_Def_Sim.Noise.DVL.Vy(2),...
                                                            Simulation.Output.User_Def_Sim.Noise.DVL.Vz(2)];
        Simulation.Input.User_Def_Sim.TempSig.Depth(2,1) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Time(2);
        Simulation.Input.User_Def_Sim.TempSig.Depth(2,2) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z(2);
        
        Simulation.Input.User_Def_Sim.TempSig.Incln(2,1) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_Time(2);
        Simulation.Input.User_Def_Sim.TempSig.Incln(2,2:3) = [Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll(2),...
                                                              Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NPitch(2)  ];   
        Simulation.Input.User_Def_Sim.TempSig.Hdng(2,1) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_Time(2);
        Simulation.Input.User_Def_Sim.TempSig.Hdng(2,2) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw(2);           
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        
%         [Q]=KlmnMatx(X1,dt,Simulation,select_navsim_mode);
%         H=Simulation.Output.User_Def_Sim.Kalman_mtx.H;
%         R=Simulation.Output.User_Def_Sim.Kalman_mtx.R.Rmatrx;
        %the initial estimate of the state covariance matrix
        P1=zeros(15);
%         P1=Q;
%             P1=diag([0       ,0        ,var_alt,...
%                      var_vx  ,var_vy   ,var_vz ,...
%                      var_ax  ,var_ay   ,var_az ,...
%                      var_roll,var_pitch,var_yaw,...
%                      var_wx  ,var_wy   ,var_wz  ]);
%         Simulation.Output.INS_Kalm.P(1,:) = diag(P1);
        for I=2:Dlength
            %Recieving of  accel and gyro signals  
            Wib_b(1)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wx(I,i);    
            Wib_b(2)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wy(I,i);    
            Wib_b(3)=Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wz(I,i);
             
            fb(1)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax(I,i);
            fb(2)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ay(I,i);
            fb(3)=Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.az(I,i);            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Win_n = Win_n_calcul( X1 );
            Wnb_b=Wib_b'-C_BtoN'*Win_n;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Computation of transformation matrix...
            if include_heading && include_rollpitch
                %... using estimated euler angles
                NC_BtoN = InCBN([X1(12) X1(11) X1(10)],select_navsim_mode);
            else
                %...using algorithm of computation of attitude
                NC_BtoN = New_C_BtoN(dt,C_BtoN,Wnb_b);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            g1 = Gravity( X1 );
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [Simulation]=KlmnIniMatx(Simulation,I);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            %Mesurement vector
            Y=[];
            %
            if include_depthmeter
                if Simulation.Input.User_Def_Sim.TempSig.Depth_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z)
                    if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1))
                        %Recieving of depth(altitude) signals
                        Y=[Y,Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,2)];
                    end
                end
            end
            %
            if include_dvl
                if Simulation.Input.User_Def_Sim.TempSig.DVL_Counter <= length(Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
                    if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))                
                        %Recieving of velocity signals in body frame
                        vb=[Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,2),...
                            Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,3),....
                            Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,4)];
                        %Transformation of velocity from body to navigation
                        %frame
                        vn = (NC_BtoN*vb')' ;
                        Y=[Y,vn];
                    end
                end
            end
            %%Transformation of acceleration from body to navigation
            %frame            
            fn = (NC_BtoN*fb')' ;
            %Correction of the coriolis and gravity accelerations
            if include_dvl
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))
                    fn=fn-cross(W_Coriolis,vn)-g1;
                else
                    fn=fn-cross(W_Coriolis,X1(4:6)')-g1;
                end
            else
                fn=fn-cross(W_Coriolis,X1(4:6)')-g1;
            end
            Y=[Y,fn];
           if include_rollpitch
                if Simulation.Input.User_Def_Sim.TempSig.incln_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll)
                    if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,1))               
                        %%Recieving of euler angles from orientation sensor
                        Y=[Y,Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,2),...
                             Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,3)];
                    end
                end
           end
           %
           if include_heading
                if Simulation.Input.User_Def_Sim.TempSig.hdng_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw)
                    if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,1))        
                        %%Recieving of euler angles from orientation sensor
                        Y=[Y,Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,2) ];
                    end
                end
           end          
           % 
           Y=[Y,Wnb_b'];
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           Y1=Y' ;  
           W_Coriolis = Coriolis_correction( X1 );
           Q = KlmnMatx(X1,dt,Simulation,select_navsim_mode);
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %Estimate with UKF
           [X1,P1] = ukf_predict1(X1,P1,Q,dt,alpha,beta,kappa);
           [X1,P1] = ukf_update1(X1,P1,Y1,Simulation.Output.User_Def_Sim.Kalman_mtx.H,Simulation.Output.User_Def_Sim.Kalman_mtx.R.Rmatrx,alpha,beta,kappa);
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %Storing of estimates in memory
           Simulation.Output.User_Def_Sim.INS_UKF.X(I,:) = X1';
           %Transformation matrix of body frame to navigation frame
           C_BtoN=NC_BtoN;
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %Recieving of auxiliary signals and inserting in the temporary
           %register
           if Simulation.Input.User_Def_Sim.TempSig.Depth_Counter < length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z)
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1))
                        
                    Simulation.Input.User_Def_Sim.TempSig.Depth_Counter = Simulation.Input.User_Def_Sim.TempSig.Depth_Counter + 1;                    
                    Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Time(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter);
                    Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,2) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,i);
                        
                end
           end
           if Simulation.Input.User_Def_Sim.TempSig.DVL_Counter < length (Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))
                        
                    Simulation.Input.User_Def_Sim.TempSig.DVL_Counter = Simulation.Input.User_Def_Sim.TempSig.DVL_Counter + 1;
                    Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1) = Simulation.Output.User_Def_Sim.Noise.DVL.Time(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter);
                    Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,2:4) = [Simulation.Output.User_Def_Sim.Noise.DVL.Vx(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,i),...
                                                                                                                            Simulation.Output.User_Def_Sim.Noise.DVL.Vy(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,i),...
                                                                                                                            Simulation.Output.User_Def_Sim.Noise.DVL.Vz(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,i)];
                end
           end
           if Simulation.Input.User_Def_Sim.TempSig.incln_Counter < length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll)
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,1))
                    Simulation.Input.User_Def_Sim.TempSig.incln_Counter = Simulation.Input.User_Def_Sim.TempSig.incln_Counter + 1;
                    Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,1)   = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_Time(Simulation.Input.User_Def_Sim.TempSig.incln_Counter);
                    Simulation.Input.User_Def_Sim.TempSig.Incln(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,2:3) = [Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,i),...
                                                                                                                            Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NPitch(Simulation.Input.User_Def_Sim.TempSig.incln_Counter,i)];                                
                end
           end
           if Simulation.Input.User_Def_Sim.TempSig.hdng_Counter < length(Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw)
                if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I,4),Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,1))
                    Simulation.Input.User_Def_Sim.TempSig.hdng_Counter = Simulation.Input.User_Def_Sim.TempSig.hdng_Counter + 1;
                    Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,1) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_Time(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter);
                    Simulation.Input.User_Def_Sim.TempSig.Hdng(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,2) = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw(Simulation.Input.User_Def_Sim.TempSig.hdng_Counter,i);
                                
                end
           end                
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
           if rem(I,10000)==0
                waitbar(I/Dlength,h);
           end
        end
        delete(h)
    end    
end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if strcmp(select_navsim_mode,'Processing of Real Measurments')

        %stepsize
        dt=1/fs; 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if strcmp(CalculType,'EKF')
            WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
            h = waitbar(0,[CalculType ' computations is running ... ']);     
            %Dlength:length of data(time step)          
            Dlength=length(Simulation.Input.PostProc_Real.Measurements.IMU);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.PostProc_Real.INS_EKF.Scan_Result.Tab = zeros(1,4);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Input.PostProc_Real.Measurements.DVL_length  =length(Simulation.Input.PostProc_Real.Measurements.DVL);
            Simulation.Input.PostProc_Real.Measurements.Depth_length=length(Simulation.Input.PostProc_Real.Measurements.Depth);
            Simulation.Input.PostProc_Real.Measurements.incln_length=length(Simulation.Input.PostProc_Real.Measurements.RollPitch);
            Simulation.Input.PostProc_Real.Measurements.hdng_length =length(Simulation.Input.PostProc_Real.Measurements.Heading);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%Alignment:computation of initial transformation matrix
            %1567
            %3088
            roll1  = mean(Simulation.Input.PostProc_Real.Measurements.RollPitch(1:3088,2));
            pitch1 = mean(Simulation.Input.PostProc_Real.Measurements.RollPitch(1:3088,3));
            yaw11  = mean(Simulation.Input.PostProc_Real.Measurements.Heading(1:3088,2));  
                    
            Euler1=[roll1 pitch1 yaw11]*(pi/180);
            %Initial transformation matrix (direction cosine matrix)
            C_BtoN = InCBN(Euler1,select_navsim_mode);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Initial velocity in body frame
            V1b=Simulation.Input.PostProc_Real.Measurements.DVL(1,2:4);
            
            %%convert initial velocity frome body frame to navigation frame
            V1n=(C_BtoN*V1b')';  
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Initial position in navigation frame in degree(latitude,longitde
            %and altitude)   
            %InitPosm:Initial position in meter
            Pos1rad(1)=(InitPosm(1)/Re)+InitPosdeg(1)*(pi/180);
            Pos1rad(2)=(InitPosm(2)/(cos(Pos1rad(1))*Re))+InitPosdeg(2)*(pi/180);        
            Pos1rad(3)=InitPosm(3);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Initial acceleration and angular velocity
            f1b(1)=Simulation.Input.PostProc_Real.Measurements.IMU(1,2);
            f1b(2)=Simulation.Input.PostProc_Real.Measurements.IMU(1,3);
            f1b(3)=Simulation.Input.PostProc_Real.Measurements.IMU(1,4);
            
            Wib_b1(1)=Simulation.Input.PostProc_Real.Measurements.IMU(1,5)*(pi/180);  
            Wib_b1(2)=Simulation.Input.PostProc_Real.Measurements.IMU(1,6)*(pi/180); 
            Wib_b1(3)=Simulation.Input.PostProc_Real.Measurements.IMU(1,7)*(pi/180);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Comutation of local gravity vector
            g1 = Gravity( Pos1rad );
            %Computation of coriolis effect
            W_Coriolis = Coriolis_correction( [Pos1rad V1n] );
            %computation of the angular rate of the navigation frame with
            %respect to the inertial frame            
            Win_n1 = Win_n_calcul( [Pos1rad V1n] );
            %computation of the body rate with respect to the
            %navigation frame.            
            Wnb_b1=(Wib_b1'-C_BtoN'*Win_n1)';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%convert initial Accelerometer frome  body to navigation
            f1n=(C_BtoN*f1b')';
            %Correction of the coriolis and gravity accelerations 
            f1n=f1n-cross(W_Coriolis,V1n)-g1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
            %Initial state of the system in navigation frame
            X1=[Pos1rad,V1n,f1n,Euler1,Wnb_b1]';
            %Creation of a space in memory for estimated mean and covariance of
            %the state( Reserve space for estimates)            
            Simulation.Output.PostProc_Real.INS_EKF.X=zeros(Dlength,size(X1,1));        
            Simulation.Output.PostProc_Real.INS_EKF.X(1,:) = X1';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Input.PostProc_Real.TempSig.DVL_Counter  = 2;%DVL Counter          
            Simulation.Input.PostProc_Real.TempSig.Depth_Counter= 2;%Depth Counter    
            Simulation.Input.PostProc_Real.TempSig.incln_Counter= 2;%Inclinometer Counter
            Simulation.Input.PostProc_Real.TempSig.hdng_Counter = 2;%Heading Counter              
            % A temporary register for recieving the auxiliary signals     
            Simulation.Input.PostProc_Real.TempSig.DVL   = zeros(Simulation.Input.PostProc_Real.Measurements.DVL_length,4);
            Simulation.Input.PostProc_Real.TempSig.Depth = zeros(Simulation.Input.PostProc_Real.Measurements.Depth_length,2);
            Simulation.Input.PostProc_Real.TempSig.Incln = zeros(Simulation.Input.PostProc_Real.Measurements.incln_length,3);
            Simulation.Input.PostProc_Real.TempSig.Hdng  = zeros(Simulation.Input.PostProc_Real.Measurements.hdng_length,2);             
            
            Simulation.Input.PostProc_Real.TempSig.DVL  (2,:) = Simulation.Input.PostProc_Real.Measurements.DVL(2,:);
            Simulation.Input.PostProc_Real.TempSig.Depth(2,:) = Simulation.Input.PostProc_Real.Measurements.Depth(2,:);
            Simulation.Input.PostProc_Real.TempSig.Incln(2,:) = Simulation.Input.PostProc_Real.Measurements.RollPitch(2,:);
            Simulation.Input.PostProc_Real.TempSig.Hdng (2,:) = Simulation.Input.PostProc_Real.Measurements.Heading(2,:);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            %computation of Process noise matrix
            [Q]=KlmnMatx(X1,dt,Simulation,select_navsim_mode);
            %Initial process noise matrix
            Simulation.Output.PostProc_Real.Kalman_mtx.Q1=Q;
            %The measurement model matrix(H) and the measurement error
            %variance(R).            
%             H=Simulation.Output.PostProc_Real.Kalman_mtx.H;
%             R=Simulation.Output.PostProc_Real.Kalman_mtx.R.Rmatrx;
            %the initial estimate of the state covariance matrix
            P1=zeros(15);
%             P1=Q;
%             P1=diag([0       ,0        ,var_alt,...
%                      var_vx  ,var_vy   ,var_vz ,...
%                      var_ax  ,var_ay   ,var_az ,...
%                      var_roll,var_pitch,var_yaw,...
%                      var_wx  ,var_wy   ,var_wz  ]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Main loop of computation
            for I=2:Dlength
                %Recieving of  accel and gyro signals 
                Wib_b(1)=Simulation.Input.PostProc_Real.Measurements.IMU(I-1,5)*(pi/180);    
                Wib_b(2)=Simulation.Input.PostProc_Real.Measurements.IMU(I-1,6)*(pi/180);    
                Wib_b(3)=Simulation.Input.PostProc_Real.Measurements.IMU(I-1,7)*(pi/180);
          
                fb(1)=Simulation.Input.PostProc_Real.Measurements.IMU(I,2);
                fb(2)=Simulation.Input.PostProc_Real.Measurements.IMU(I,3);
                fb(3)=Simulation.Input.PostProc_Real.Measurements.IMU(I,4);                       
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                Win_n = Win_n_calcul( X1 );
                Wnb_b = Wib_b'-C_BtoN'*Win_n;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Computation of transformation matrix...
                %... using estimated euler angles
                if include_heading && include_rollpitch
                    NC_BtoN = InCBN([X1(10) X1(11) X1(12)],select_navsim_mode);
                else
                    %...using algorithm of computation of attitude
                    NC_BtoN = New_C_BtoN(dt,C_BtoN,Wnb_b);
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                g1 = Gravity( X1 );
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
                [Simulation]=KlmnIniMatx(Simulation,I);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
                Y=[];
                %Recieving of depth(altitude) signals
                if include_depthmeter 
                    if Simulation.Input.PostProc_Real.TempSig.Depth_Counter <= length(Simulation.Input.PostProc_Real.Measurements.Depth)
                        if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,1))
                            alt=Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,2);
                            Y=[Y,alt];  
                        end
                    end
                end
                %Recieving of velocity signals in body frame
                if include_dvl
                    if Simulation.Input.PostProc_Real.TempSig.DVL_Counter <= length(Simulation.Input.PostProc_Real.Measurements.DVL)
                        if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,1))
                            vbx=Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,2);
                            vby=Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,3);
                            vbz=Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,4);
                            vb=[vbx,vby,vbz];
                            %Transformation of velocity from body to navigation
                            %frame
                            vn = (NC_BtoN*vb')' ;
                            Y=[Y,vn];
                        end
                    end
                end
                %Transformation of acceleration from body to navigation
                %frame
                fn = (NC_BtoN*fb')' ;
                fn=fn-cross(W_Coriolis,X1(4:6)')-g1;
                Y=[Y,fn];
                
                %%Recieving of euler angles from orientation sensor
                if include_rollpitch
                    if Simulation.Input.PostProc_Real.TempSig.incln_Counter <= length(Simulation.Input.PostProc_Real.Measurements.RollPitch)
                        if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,1))
                            Y=[Y,Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,2)*(pi/180),...
                                 Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,3)*(pi/180)];
                        end
                    end
                end   
                if include_heading
                    if Simulation.Input.PostProc_Real.TempSig.hdng_Counter <= length(Simulation.Input.PostProc_Real.Measurements.Heading)
                        if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,1))                    
                            Y=[Y,Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,2)*(pi/180) ];
                        end
                    end
                end                
                Y=[Y,Wnb_b'];                
                Y1=Y' ; 
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                W_Coriolis = Coriolis_correction( X1 );
                Q = KlmnMatx(X1,dt,Simulation,select_navsim_mode);
                Simulation.Output.PostProc_Real.Kalman_mtx.Q=Q;
                F = jacob_f(X1,dt);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Estimate with UKF
                [X1,P1] = ekf_predict(X1,P1,Q,F,dt);
                if (~isempty (Simulation.Output.PostProc_Real.Kalman_mtx.H))
                    [X1,P1] = kf_update(X1,P1,Y1,Simulation.Output.PostProc_Real.Kalman_mtx.H,Simulation.Output.PostProc_Real.Kalman_mtx.R.Rmatrx);
                end
                
                %Storing of estimates in memory  
                Simulation.Output.PostProc_Real.INS_EKF.X(I,:) = X1';
                
                %Transformation matrix of body frame to navigation frame
                C_BtoN=NC_BtoN;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Recieving of auxiliary signals and inserting in the temporary
                %register                
                if Simulation.Input.PostProc_Real.TempSig.Depth_Counter < length(Simulation.Input.PostProc_Real.Measurements.Depth)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,1))  
                        
                        Simulation.Input.PostProc_Real.TempSig.Depth_Counter = Simulation.Input.PostProc_Real.TempSig.Depth_Counter + 1;                    
                        Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,:) = Simulation.Input.PostProc_Real.Measurements.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,:);
                        
                    end
                end
                if Simulation.Input.PostProc_Real.TempSig.DVL_Counter < length (Simulation.Input.PostProc_Real.Measurements.DVL)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,1)) 
                        
                        Simulation.Input.PostProc_Real.TempSig.DVL_Counter = Simulation.Input.PostProc_Real.TempSig.DVL_Counter + 1;
                        Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,:) = Simulation.Input.PostProc_Real.Measurements.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,:);
                        
                    end
                end    
                if Simulation.Input.PostProc_Real.TempSig.incln_Counter < length(Simulation.Input.PostProc_Real.Measurements.RollPitch)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,1))  
                        
                        Simulation.Input.PostProc_Real.TempSig.incln_Counter = Simulation.Input.PostProc_Real.TempSig.incln_Counter + 1;                    
                        Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,:) = Simulation.Input.PostProc_Real.Measurements.RollPitch(Simulation.Input.PostProc_Real.TempSig.incln_Counter,:);
                        
                    end
                end 
                if Simulation.Input.PostProc_Real.TempSig.hdng_Counter < length(Simulation.Input.PostProc_Real.Measurements.Heading)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,1))  
                        
                        Simulation.Input.PostProc_Real.TempSig.hdng_Counter = Simulation.Input.PostProc_Real.TempSig.hdng_Counter + 1;                    
                        Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,:) = Simulation.Input.PostProc_Real.Measurements.Heading(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,:);
                        
                    end
                end                  
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if rem(I,1000)==0
                    waitbar(I/Dlength,h);
                end                
            end
            delete(h)            
        end
        
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        if strcmp(CalculType,'UKF')
            WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
            h = waitbar(0,[CalculType ' computations is running ... ']);             
            %dynamic model function
%             func_f  = @nav_eqn;
            %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
            %Dlength:length of data(time step)
            Dlength=length(Simulation.Input.PostProc_Real.Measurements.IMU);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.PostProc_Real.INS_UKF.Scan_Result.Tab = zeros(1,4);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            Simulation.Input.PostProc_Real.Measurements.DVL_length  =length(Simulation.Input.PostProc_Real.Measurements.DVL);
            Simulation.Input.PostProc_Real.Measurements.Depth_length=length(Simulation.Input.PostProc_Real.Measurements.Depth);   
            Simulation.Input.PostProc_Real.Measurements.incln_length=length(Simulation.Input.PostProc_Real.Measurements.RollPitch);
            Simulation.Input.PostProc_Real.Measurements.hdng_length =length(Simulation.Input.PostProc_Real.Measurements.Heading);            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Alignment:computation of initial transformation matrix
            roll1=mean(Simulation.Input.PostProc_Real.Measurements.RollPitch(1:1567,2));
            pitch1=mean(Simulation.Input.PostProc_Real.Measurements.RollPitch(1:1567,3));
            yaw11=mean(Simulation.Input.PostProc_Real.Measurements.Heading(1:1567,2));  
            Euler1=[roll1 pitch1 yaw11]*(pi/180);
            %Initial transformation matrix (direction cosine matrix)
            C_BtoN = InCBN(Euler1,select_navsim_mode);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Initial velocity in body frame
            V1b=Simulation.Input.PostProc_Real.Measurements.DVL(1,2:4);           
            %%convert initial velocity frome  body to navigation 
            V1n=(C_BtoN*V1b')'; 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Initial position in navigation frame in degree(latitude,longitde
            %and altitude)
            %InitPosm:Initial position in meter
            Pos1rad(1)=(InitPosm(1)/Re)+InitPosdeg(1)*(pi/180);
            Pos1rad(2)=(InitPosm(2)/(cos(Pos1rad(1))*Re))+InitPosdeg(2)*(pi/180);        
            Pos1rad(3)=InitPosm(3);            
            %Initial acceleration and ngular velocity
            f1b(1)=Simulation.Input.PostProc_Real.Measurements.IMU(1,2);
            f1b(2)=Simulation.Input.PostProc_Real.Measurements.IMU(1,3);
            f1b(3)=Simulation.Input.PostProc_Real.Measurements.IMU(1,4);
            
            Wib_b1(1)=Simulation.Input.PostProc_Real.Measurements.IMU(1,5)*(pi/180);  
            Wib_b1(2)=Simulation.Input.PostProc_Real.Measurements.IMU(1,6)*(pi/180); 
            Wib_b1(3)=Simulation.Input.PostProc_Real.Measurements.IMU(1,7)*(pi/180);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Comutation of local gravity vector
            g1 = Gravity( Pos1rad );
            %computation of coriolis effect
            W_Coriolis = Coriolis_correction( [Pos1rad V1n] );
            %computation of the angular rate of the navigation frame with
            %respect to the inertial frame
            Win_n1 = Win_n_calcul( [Pos1rad V1n] );
            %computation of the body rate with respect to the
            %navigation frame.
            Wnb_b1=(Wib_b1'-C_BtoN'*Win_n1)';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%convert initial Accelerometer frome  body to navigation
            f1n=(C_BtoN*f1b')';
            f1n=f1n-cross(W_Coriolis,V1n)-g1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
            %Initial state of the system in navigation frame
            m1=[Pos1rad,V1n,f1n,Euler1,Wnb_b1]';
            %computation of Process noise matrix
            [Q]=KlmnMatx(m1,dt,Simulation,select_navsim_mode);
            %Creation of a space in memory for estimated mean and covariance of
            %the state( Reserve space for estimates)
            Simulation.Output.PostProc_Real.INS_UKF.m=zeros(Dlength,size(m1,1)); 
            Simulation.Output.PostProc_Real.INS_UKF.m(1,:) = m1';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Input.PostProc_Real.TempSig.DVL_Counter  = 2;%DVL Counter          
            Simulation.Input.PostProc_Real.TempSig.Depth_Counter= 2;%Depth Counter
            Simulation.Input.PostProc_Real.TempSig.incln_Counter= 2;%Inclinometer Counter
            Simulation.Input.PostProc_Real.TempSig.hdng_Counter = 2;%Heading Counter             
            %Recieving of auxiliary signals and inserting in the temporary
            %register            
            Simulation.Input.PostProc_Real.TempSig.DVL   = zeros(Simulation.Input.PostProc_Real.Measurements.DVL_length,4);
            Simulation.Input.PostProc_Real.TempSig.Depth = zeros(Simulation.Input.PostProc_Real.Measurements.Depth_length,2);
            Simulation.Input.PostProc_Real.TempSig.Incln = zeros(Simulation.Input.PostProc_Real.Measurements.incln_length,3);
            Simulation.Input.PostProc_Real.TempSig.Hdng  = zeros(Simulation.Input.PostProc_Real.Measurements.hdng_length,2);             
            
            Simulation.Input.PostProc_Real.TempSig.DVL  (2,:) = Simulation.Input.PostProc_Real.Measurements.DVL(2,:);
            Simulation.Input.PostProc_Real.TempSig.Depth(2,:) = Simulation.Input.PostProc_Real.Measurements.Depth(2,:);
            Simulation.Input.PostProc_Real.TempSig.Incln(2,:) = Simulation.Input.PostProc_Real.Measurements.RollPitch(2,:);
            Simulation.Input.PostProc_Real.TempSig.Hdng (2,:) = Simulation.Input.PostProc_Real.Measurements.Heading(2,:);            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
            %The measurement model matrix(H) and the measurement error
            %variance(R).
%             H=Simulation.Output.PostProc_Real.Kalman_mtx.H;
%             R=Simulation.Output.PostProc_Real.Kalman_mtx.R.Rmatrx;
            %Initial estimate of the state covariance matrix
%             P1=zeros(15);
            P1=Q;
%             P1=diag([0       ,0        ,var_alt,...
%                      var_vx  ,var_vy   ,var_vz ,...
%                      var_ax  ,var_ay   ,var_az ,...
%                      var_roll,var_pitch,var_yaw,...
%                      var_wx  ,var_wy   ,var_wz  ]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Main loop of computations
            for I=2:Dlength
            
                %Recieving of accel and gyro signals 
                Wib_b(1)=Simulation.Input.PostProc_Real.Measurements.IMU(I-1,5)*(pi/180);    
                Wib_b(2)=Simulation.Input.PostProc_Real.Measurements.IMU(I-1,6)*(pi/180);    
                Wib_b(3)=Simulation.Input.PostProc_Real.Measurements.IMU(I-1,7)*(pi/180);
            
                fb(1)=Simulation.Input.PostProc_Real.Measurements.IMU(I,2);
                fb(2)=Simulation.Input.PostProc_Real.Measurements.IMU(I,3);
                fb(3)=Simulation.Input.PostProc_Real.Measurements.IMU(I,4);                  
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                Win_n = Win_n_calcul(m1);
                Wnb_b=Wib_b'-C_BtoN'*Win_n;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Computation of transformation matrix...
                if include_heading && include_rollpitch   
                      %... using estimated euler angles
                      NC_BtoN = InCBN([m1(10) m1(11) m1(12)],select_navsim_mode);
                else
                      %...using algorithm of computation of attitude
                      NC_BtoN = New_C_BtoN(dt,C_BtoN,Wnb_b);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
                g1 = Gravity( m1 );
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                [Simulation]=KlmnIniMatx(Simulation,I);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
                y_measure=[];
                %Recieving of depth(altitude) signals
                if include_depthmeter

                    if Simulation.Input.PostProc_Real.TempSig.Depth_Counter <= length(Simulation.Input.PostProc_Real.Measurements.Depth)
                        if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,1))                    
                            alt=Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,2);
                            y_measure=[y_measure,alt];   
                        end
                    end
                end        
                %Recieving of velocity signals in body frame
                if include_dvl

                if Simulation.Input.PostProc_Real.TempSig.DVL_Counter <= length (Simulation.Input.PostProc_Real.Measurements.DVL)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,1))                     
                        vbx=Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,2);
                        vby=Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,3);
                        vbz=Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,4);                     
                        vb=[vbx,vby,vbz];
                        %Transformation of velocity from body to navigation frame
                        vn = (NC_BtoN*vb')' ;
                        y_measure=[y_measure,vn];
                    end
                end
                end
            
                %Transformation of acceleration from body to navigation frame
                fn = (NC_BtoN*fb')' ;
                fn=fn-cross(W_Coriolis,m1(4:6)')-g1;
                y_measure=[y_measure,fn];
            
                %Recieving of euler angles from orientation sensor
                if include_rollpitch
                    if Simulation.Input.PostProc_Real.TempSig.incln_Counter <= length(Simulation.Input.PostProc_Real.Measurements.RollPitch)
                        if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,1))
                            y_measure=[y_measure,Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,2)*(pi/180),...
                                 Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,3)*(pi/180)];
                        end
                    end
                end   
                if include_heading
                    if Simulation.Input.PostProc_Real.TempSig.hdng_Counter <= length(Simulation.Input.PostProc_Real.Measurements.Heading)
                        if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,1))                    
                            y_measure=[y_measure,Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,2)*(pi/180) ];
                        end
                    end
                end                
            
                y_measure=[y_measure,Wnb_b'];
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                y_measure1=y_measure' ;  
                W_Coriolis = Coriolis_correction( m1 );
                Q = KlmnMatx(m1,dt,Simulation,select_navsim_mode);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Estimate with UKF
                [m1,P1] = ukf_predict1(m1,P1,Q,dt,alpha,beta,kappa);
                if (~isempty (Simulation.Output.PostProc_Real.Kalman_mtx.H))
                    [m1,P1] = ukf_update1(m1,P1,y_measure1,Simulation.Output.PostProc_Real.Kalman_mtx.H,Simulation.Output.PostProc_Real.Kalman_mtx.R.Rmatrx,alpha,beta,kappa);
                end
                %Storing of estimates in memory          
                Simulation.Output.PostProc_Real.INS_UKF.m(I,:) = m1';         
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Transformation matrix of body frame to navigation frame
                C_BtoN=NC_BtoN;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Recieving of auxiliary signals and inserting in the temporary
                %register                 
                if Simulation.Input.PostProc_Real.TempSig.Depth_Counter < length(Simulation.Input.PostProc_Real.Measurements.Depth)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,1))  
                        
                        Simulation.Input.PostProc_Real.TempSig.Depth_Counter = Simulation.Input.PostProc_Real.TempSig.Depth_Counter + 1;                    
                        Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,:) = Simulation.Input.PostProc_Real.Measurements.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,:);
                        
                    end
                end
                if Simulation.Input.PostProc_Real.TempSig.DVL_Counter < length (Simulation.Input.PostProc_Real.Measurements.DVL)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,1)) 
                        
                        Simulation.Input.PostProc_Real.TempSig.DVL_Counter = Simulation.Input.PostProc_Real.TempSig.DVL_Counter + 1;
                        Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,:) = Simulation.Input.PostProc_Real.Measurements.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,:);
                        
                    end
                end  
                if Simulation.Input.PostProc_Real.TempSig.incln_Counter < length(Simulation.Input.PostProc_Real.Measurements.RollPitch)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,1))  
                        
                        Simulation.Input.PostProc_Real.TempSig.incln_Counter = Simulation.Input.PostProc_Real.TempSig.incln_Counter + 1;                    
                        Simulation.Input.PostProc_Real.TempSig.Incln(Simulation.Input.PostProc_Real.TempSig.incln_Counter,:) = Simulation.Input.PostProc_Real.Measurements.RollPitch(Simulation.Input.PostProc_Real.TempSig.incln_Counter,:);
                        
                    end
                end 
                if Simulation.Input.PostProc_Real.TempSig.hdng_Counter < length(Simulation.Input.PostProc_Real.Measurements.Heading)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I,1),Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,1))  
                        
                        Simulation.Input.PostProc_Real.TempSig.hdng_Counter = Simulation.Input.PostProc_Real.TempSig.hdng_Counter + 1;                    
                        Simulation.Input.PostProc_Real.TempSig.Hdng(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,:) = Simulation.Input.PostProc_Real.Measurements.Heading(Simulation.Input.PostProc_Real.TempSig.hdng_Counter,:);
                        
                    end
                end                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
                if rem(I,1000)==0
                    waitbar(I/Dlength,h);
                end                
            end
            delete(h)                            
        end
end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
end