function [Simulation]=gauss_Markov(Simulation,i,tau)

    %The number of simulations
    N                 = GetParam(Simulation.Init_Value ,'simulation_number');
    fs                = GetParam(Simulation.Init_Value ,'Sampling_Frequency');
    dt                = 1/fs;
    [ Simulation,GyroError,AccelError ] = Sigma_Calcul( Simulation , i );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    timestep=length(Simulation.Input.User_Def_Sim.DVL.Velocity);
    t=Simulation.Input.User_Def_Sim.Path.P_ned(:,4);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   tau_ax = tau(1); 
   tau_ay = tau(2);
   tau_az = tau(3);
   tau_gx = tau(4);
   tau_gy = tau(5);
   tau_gz = tau(6); 
        %%Modelling of ARW with a Gaussian white noise sequence
        G_Nx=GyroError.ARW_sigmax*randn(timestep,1);
        G_Ny=GyroError.ARW_sigmay*randn(timestep,1);
        G_Nz=GyroError.ARW_sigmaz*randn(timestep,1);

        G_UWN_sequencex=sqrt(2*GyroError.gyro_BS_sigmax^2/tau_gx)*randn(timestep,1);
        G_UWN_sequencey=sqrt(2*GyroError.gyro_BS_sigmay^2/tau_gy)*randn(timestep,1); 
        G_UWN_sequencez=sqrt(2*GyroError.gyro_BS_sigmaz^2/tau_gz)*randn(timestep,1);
    
        %Modelling of bias instability with a guass markov process
        G_GM_sequencex=zeros(timestep,1);
        G_GM_sequencey=zeros(timestep,1);
        G_GM_sequencez=zeros(timestep,1);
        for k=1:timestep-1
            G_GM_sequencex(k+1) =  (1-dt/tau_gx)*G_GM_sequencex(k) + G_UWN_sequencex(k)*dt;
            G_GM_sequencey(k+1) =  (1-dt/tau_gy)*G_GM_sequencey(k) + G_UWN_sequencey(k)*dt;
            G_GM_sequencez(k+1) =  (1-dt/tau_gz)*G_GM_sequencez(k) + G_UWN_sequencez(k)*dt;
        end
        
        if i==1                  
%             Simulation.Input.Measurements.IMU=zeros(timestep,7,N);
%             Simulation.Input.Measurements.IMU(:,1,i) = t;
%             
            Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.noise_gx=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.noise_gy=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.noise_gz=zeros(timestep,N); 
            Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.noise_ax=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.noise_ay=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.noise_az=zeros(timestep,N);
        end  
        %Computation of total additive noise
        Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.noise_gx(:,i)=G_Nx+G_GM_sequencex;
        Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.noise_gy(:,i)=G_Ny+G_GM_sequencey;
        Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.noise_gz(:,i)=G_Nz+G_GM_sequencez;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Accelerometer
        %Modelling of VRW with a Gaussian white noise sequence
        A_Nx=AccelError.VRW_sigmax * randn(timestep,1);
        A_Ny=AccelError.VRW_sigmay * randn(timestep,1);
        A_Nz=AccelError.VRW_sigmaz * randn(timestep,1);
        %modelling of bias instability with a guass markov process
        %Underlying white noise(UWN) sequence        
        A_UWN_sequencex=sqrt(2*AccelError.accel_BS_sigmax^2/tau_ax)*randn(timestep,1);
        A_UWN_sequencey=sqrt(2*AccelError.accel_BS_sigmay^2/tau_ay)*randn(timestep,1);
        A_UWN_sequencez=sqrt(2*AccelError.accel_BS_sigmaz^2/tau_az)*randn(timestep,1);
        A_GM_sequencex=zeros(timestep,1);
        A_GM_sequencey=zeros(timestep,1);
        A_GM_sequencez=zeros(timestep,1);
        for k=1:timestep-1
            A_GM_sequencex(k+1) = (1-dt/tau_ax)* A_GM_sequencex(k) + A_UWN_sequencex(k)*dt;
            A_GM_sequencey(k+1) = (1-dt/tau_ay)* A_GM_sequencey(k) + A_UWN_sequencey(k)*dt;
            A_GM_sequencez(k+1) = (1-dt/tau_az)* A_GM_sequencez(k) + A_UWN_sequencez(k)*dt;
        end 
        Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.noise_ax(:,i)=A_GM_sequencex+A_Nx;
        Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.noise_ay(:,i)=A_GM_sequencey+A_Ny;
        Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.noise_az(:,i)=A_GM_sequencez+A_Nz;
        