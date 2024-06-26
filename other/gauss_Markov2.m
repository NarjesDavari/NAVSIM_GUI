function [Gyro_noise_gx,Gyro_noise_gy,Gyro_noise_gz,Accelerometer_noise_ax,Accelerometer_noise_ay,Accelerometer_noise_az]=gauss_Markov2

    %The number of simulations
    fs                =100;
    dt                = 1/fs;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    timestep=1e6;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   tau_ax = 3.6e5; 
   tau_ay = 2.84e5;
   tau_az = 5e5;
   tau_gx = 1.5e6;
   tau_gy = 3e5;
   tau_gz = 8.5e5; 
   
   GyroError_ARW_sigmax=1.0967e-5;
   GyroError_ARW_sigmay=1.0647e-5;
   GyroError_ARW_sigmaz=9.8895e-6;
   GyroError_gyro_BS_sigmax=3.4928e-6;
   GyroError_gyro_BS_sigmay=5.9161e-6;
   GyroError_gyro_BS_sigmaz=2e-6;
   
        %%Modelling of ARW with a Gaussian white noise sequence
%         G_Nx=GyroError_ARW_sigmax*randn(timestep,1);
%         G_Ny=GyroError_ARW_sigmay*randn(timestep,1);
%         G_Nz=GyroError_ARW_sigmaz*randn(timestep,1);

        G_UWN_sequencex=GyroError_gyro_BS_sigmax*randn(timestep,1);
        G_UWN_sequencey=GyroError_gyro_BS_sigmay*randn(timestep,1); 
        G_UWN_sequencez=GyroError_gyro_BS_sigmaz*randn(timestep,1);
    
        %Modelling of bias instability with a guass markov process
        G_GM_sequencex=zeros(timestep,1);
        G_GM_sequencey=zeros(timestep,1);
        G_GM_sequencez=zeros(timestep,1);
        for k=1:timestep-1
            G_GM_sequencex(k+1) =  (1-dt/tau_gx)*G_GM_sequencex(k) + G_UWN_sequencex(k)*dt;
            G_GM_sequencey(k+1) =  (1-dt/tau_gy)*G_GM_sequencey(k) + G_UWN_sequencey(k)*dt;
            G_GM_sequencez(k+1) =  (1-dt/tau_gz)*G_GM_sequencez(k) + G_UWN_sequencez(k)*dt;
        end
        
%             Gyro_noise_gx=zeros(timestep,1);
%             Gyro_noise_gy=zeros(timestep,1);
%             Gyro_noise_gz=zeros(timestep,1); 
        %Computation of total additive noise
        Gyro_noise_gx=G_GM_sequencex;
        Gyro_noise_gy=G_GM_sequencey;
        Gyro_noise_gz=G_GM_sequencez;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Accelerometer
        AccelError_VRW_sigmax =9.8e-4;
        AccelError_VRW_sigmay=.0011;
        AccelError_VRW_sigmaz=.0011;
        AccelError_accel_BS_sigmax=.0024;
        AccelError_accel_BS_sigmay=.0026;
        AccelError_accel_BS_sigmaz=.0021;
        
        %Modelling of VRW with a Gaussian white noise sequence
%         A_Nx=AccelError_VRW_sigmax * randn(timestep,1);
%         A_Ny=AccelError_VRW_sigmay * randn(timestep,1);
%         A_Nz=AccelError_VRW_sigmaz * randn(timestep,1);
        %modelling of bias instability with a guass markov process
        %Underlying white noise(UWN) sequence        
        A_UWN_sequencex=AccelError_accel_BS_sigmax*randn(timestep,1);
        A_UWN_sequencey=AccelError_accel_BS_sigmay*randn(timestep,1);
        A_UWN_sequencez=AccelError_accel_BS_sigmaz*randn(timestep,1);
        A_GM_sequencex=zeros(timestep,1);
        A_GM_sequencey=zeros(timestep,1);
        A_GM_sequencez=zeros(timestep,1);
        for k=1:timestep-1
            A_GM_sequencex(k+1) = (1-dt/tau_ax)* A_GM_sequencex(k) + A_UWN_sequencex(k)*dt;
            A_GM_sequencey(k+1) = (1-dt/tau_ay)* A_GM_sequencey(k) + A_UWN_sequencey(k)*dt;
            A_GM_sequencez(k+1) = (1-dt/tau_az)* A_GM_sequencez(k) + A_UWN_sequencez(k)*dt;
        end 
%         Accelerometer_noise_ax=zeros(timestep,1);
%         Accelerometer_noise_ay=zeros(timestep,1);
%         Accelerometer_noise_az=zeros(timestep,1);
        Accelerometer_noise_ax=A_GM_sequencex;
        Accelerometer_noise_ay=A_GM_sequencey;
        Accelerometer_noise_az=A_GM_sequencez;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         
%         G_UWN_sequencex=GyroError_gyro_BS_sigmax*sqrt(1-exp(-2*dt/tau_gx))*randn(timestep,1);
%         G_UWN_sequencey=GyroError_gyro_BS_sigmay*sqrt(1-exp(-2*dt/tau_gy))*randn(timestep,1); 
%         G_UWN_sequencez=GyroError_gyro_BS_sigmaz*sqrt(1-exp(-2*dt/tau_gz))*randn(timestep,1);
%     
%         %Modelling of bias instability with a guass markov process
%         G_GM_sequencex=zeros(timestep,1);
%         G_GM_sequencey=zeros(timestep,1);
%         G_GM_sequencez=zeros(timestep,1);
%         for k=1:timestep-1
%             G_GM_sequencex(k+1) =  exp(-dt/tau_gx)*G_GM_sequencex(k) + G_UWN_sequencex(k)*dt;
%             G_GM_sequencey(k+1) =  exp(-dt/tau_gy)*G_GM_sequencey(k) + G_UWN_sequencey(k)*dt;
%             G_GM_sequencez(k+1) =  exp(-dt/tau_gz)*G_GM_sequencez(k) + G_UWN_sequencez(k)*dt;
%         end
%         
% %             Gyro_noise_gx=zeros(timestep,1);
% %             Gyro_noise_gy=zeros(timestep,1);
% %             Gyro_noise_gz=zeros(timestep,1); 
%         %Computation of total additive noise
%         Gyro_noise_gx=G_GM_sequencex;
%         Gyro_noise_gy=G_GM_sequencey;
%         Gyro_noise_gz=G_GM_sequencez;
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Accelerometer
%         AccelError_VRW_sigmax =9.8e-4;
%         AccelError_VRW_sigmay=.0011;
%         AccelError_VRW_sigmaz=.0011;
%         AccelError_accel_BS_sigmax=.0024;
%         AccelError_accel_BS_sigmay=.0026;
%         AccelError_accel_BS_sigmaz=.0021;
%         
%         %Modelling of VRW with a Gaussian white noise sequence
% %         A_Nx=AccelError_VRW_sigmax * randn(timestep,1);
% %         A_Ny=AccelError_VRW_sigmay * randn(timestep,1);
% %         A_Nz=AccelError_VRW_sigmaz * randn(timestep,1);
%         %modelling of bias instability with a guass markov process
%         %Underlying white noise(UWN) sequence        
%         A_UWN_sequencex=AccelError_accel_BS_sigmax*sqrt(1-exp(-2*dt/tau_ax))*randn(timestep,1);
%         A_UWN_sequencey=AccelError_accel_BS_sigmay*sqrt(1-exp(-2*dt/tau_ay))*randn(timestep,1);
%         A_UWN_sequencez=AccelError_accel_BS_sigmaz*sqrt(1-exp(-2*dt/tau_az))*randn(timestep,1);
%         A_GM_sequencex=zeros(timestep,1);
%         A_GM_sequencey=zeros(timestep,1);
%         A_GM_sequencez=zeros(timestep,1);
%         for k=1:timestep-1
%             A_GM_sequencex(k+1) = exp(-dt/tau_ax)* A_GM_sequencex(k) + A_UWN_sequencex(k)*dt;
%             A_GM_sequencey(k+1) = exp(-dt/tau_ay)* A_GM_sequencey(k) + A_UWN_sequencey(k)*dt;
%             A_GM_sequencez(k+1) = exp(-dt/tau_az)* A_GM_sequencez(k) + A_UWN_sequencez(k)*dt;
%         end 
% %         Accelerometer_noise_ax=zeros(timestep,1);
% %         Accelerometer_noise_ay=zeros(timestep,1);
% %         Accelerometer_noise_az=zeros(timestep,1);
%         Accelerometer_noise_ax=A_GM_sequencex;
%         Accelerometer_noise_ay=A_GM_sequencey;
%         Accelerometer_noise_az=A_GM_sequencez;
%         