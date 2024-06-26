%Computation of the error variance matrix(Q)
%dx/dt=Fx+Lw
%x: state vector
%x=[Lat,lon,h,Vn,Ve,Vh,fn,fe,fd,phi,theta,psi,Wx,Wy,Wz]:15x1(N=15)
%F:System matrix
%R:the length of the semi-major axis
%e:the major eccentricity of the ellipsoid
%Omega:Earth's rate
%RN:the meridian radius of curvature
%RE:the transverse radius of curvature
%Reference: pages 78-80
function [Q]=KlmnMatx(x,dt,Simulation,select_navsim_mode)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters of the Earth
    R=6378137;
    e=0.0818191908426;
    Omega=7.292115e-05;  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    RN=R*(1-e^2)/(1-e^2*(sin(x(1)))^2)^1.5;
    RE=R/(1-e^2*(sin(x(1)))^2)^0.5;
    Wie=Omega;
    %
    k1=sin(x(10))*tan(x(11));k2=cos(x(10))*tan(x(11));k3=cos(x(10));
    k4=sin(x(10));k5=sin(x(10))*sec(x(11));k6=cos(x(10))*sec(x(11));
    k7=1/(RN+x(3));k8=sec(x(1))/(RE+x(3));k9=-2*Wie*sin(x(1));
    k10=2*Wie*cos(x(1));
    % Dynamic state transition matrix in continous-time domain.
    F=[0,0,0,k7,0,0,0,0,0,0,0,0,0,0,0;
       0,0,0,0,k8,0,0,0,0,0,0,0,0,0,0;
       0,0,0,0,0,-1,0,0,0,0,0,0,0,0,0;%
       0,0,0,0,k9,0,1,0,0,0,0,0,0,0,0;
       0,0,0,-k9,0,k10,0,1,0,0,0,0,0,0,0;
       0,0,0,0,-k10,0,0,0,1,0,0,0,0,0,0;%
       0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
       0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
       0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;%
       0,0,0,0,0,0,0,0,0,0,0,0,1,k1,k2;
       0,0,0,0,0,0,0,0,0,0,0,0,0,k3,-k4;
       0,0,0,0,0,0,0,0,0,0,0,0,0,k5,k6;%
       0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
       0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
       0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];%
    % Noise effect matrix in continous-time domain(L=15x6(NxL))
    L=[0,0,0,0,0,0;
       0,0,0,0,0,0;
       0,0,0,0,0,0;%
       0,0,0,0,0,0;
       0,0,0,0,0,0;
       0,0,0,0,0,0;%
       1,0,0,0,0,0;
       0,1,0,0,0,0;
       0,0,1,0,0,0;%
       0,0,0,0,0,0;
       0,0,0,0,0,0;
       0,0,0,0,0,0;%
       0,0,0,1,0,0;
       0,0,0,0,1,0;
       0,0,0,0,0,1];% 
    if strcmp(select_navsim_mode,'User Defined Path Simulation')
        q_ax=Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_ax;  
        q_ay=Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_ay; 
        q_az=Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_az; 
    
        q_wx=Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_wx;
        q_wy=Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_wy;
        q_wz=Simulation.Output.User_Def_Sim.Kalman_mtx.Qc.q_wz;
    end
    if strcmp(select_navsim_mode,'Processing of Real Measurments')
        q_ax=Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_ax;  
        q_ay=Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_ay; 
        q_az=Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_az; 
    
        q_wx=Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_wx;
        q_wy=Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_wy;
        q_wz=Simulation.Output.PostProc_Real.Kalman_mtx.Qc.q_wz;
    end
    %power spectral density of white noise process(W(t))(diagnal spectral density)
        Qc=[q_ax  ,0     ,0     ,0     ,0     ,0      ;%LxL(6X6)
            0     ,q_ay  ,0     ,0     ,0     ,0      ;
            0     ,0     ,q_az  ,0     ,0     ,0      ;
            0     ,0     ,0     ,q_wx  ,0     ,0      ;
            0     ,0     ,0     ,0     ,q_wy  ,0      ;
            0     ,0     ,0     ,0     ,0     ,q_wz  ];

    %Q:The covariance of the discrete process
    [Q] = ekf_lti_disc(F,L,Qc,dt);
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@