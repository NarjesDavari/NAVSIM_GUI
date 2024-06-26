%Computation of the system matrix (F) and the system noise distribution
%matrix (G)
%dx_dot=Fdx+Gw
%dx=[dL dl dh dVn dVe dVd droll dpitch dyaw]T
%w=[dfx dfy dfz dwx dwy dwz]T
%Reference : My thesis page 88-89
%            Titterton page 344            
function [ F,G,Simulation ] = FG_calcul(Simulation,I,x,C,gg,tau,sigma_bias,dt,ave_sample)
    %x=[Lat;lon;d;Vn;Ve;Vd;fn;fe;fd]
    %C=body to navigation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters of the Earth
    R=6378137;%meter
    e=0.0818191908426;
    Omega=7.292115e-05;%Earth's rate, rad/s
    [gl,Simulation] = Gravity(Simulation,Simulation.Output.INS.X_INS(I-ave_sample,1:3) , gg ,I);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    M =R*(1-e^2)/(1-e^2*(sin(x(1)))^2)^1.5;%meridian radius of curvature
    N =R/(1-e^2*(sin(x(1)))^2)^0.5;%transverse radius of curvature
    R0=sqrt(M*N);%mean radius of the earth
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F_pp=[0                                    ,0 ,-x(4)/(R0+x(3))^2
          x(5)*tan(x(1))/((R0+x(3))*cos(x(1))) ,0 ,-x(5)/((R0+x(3))^2*cos(x(1)))
          0                                    ,0 ,0                            ];    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F_pv=[1/(R0+x(3)) ,0                       ,0
          0           ,1/((R0+x(3))*cos(x(1))) ,0  
          0           ,0                       ,+1];
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    F_p_psi=[0 ,0 ,0
             0 ,0 ,0  
             0 ,0 ,0];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    F_vp= [-x(5)*(2*Omega*cos(x(1))+x(5)/((R0+x(3))*cos(x(1))^2))                    ,0 ,(x(5)^2*tan(x(1))-x(4)*x(6))/(R0+x(3))^2
           2*Omega*(x(4)*cos(x(1))-x(6)*sin(x(1)))+x(4)*x(5)/((R0+x(3))*cos(x(1))^2) ,0 ,-x(5)*(x(4)*tan(x(1))+x(6))/(R0+x(3))^2
           2*Omega*x(5)*sin(x(1))                                                    ,0 ,(x(4)^2+x(5)^2)/(R0+x(3))^2- 2*gl(3)/R0 ];   %%        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F_vv = [x(6)/(R0+x(3))                            ,-2*Omega*sin(x(1))-2*x(5)*tan(x(1))/(R0+x(3)),x(4)/(R0+x(3))
            2*Omega*sin(x(1))+x(5)*tan(x(1))/(R0+x(3)),(x(6)+x(4)*tan(x(1)))/(R0+x(3))              ,2*Omega*cos(x(1))+x(5)/(R0+x(3))
            -2*x(4)/(R0+x(3))                         ,-2*Omega*cos(x(1))-2*x(5)/(R0+x(3))          ,0                               ];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    F_v_psi =[0    ,-x(9),x(8)
              x(9) ,0    ,-x(7)
              -x(8),x(7) ,0    ];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F_psi_p=[-Omega*sin(x(1))                             ,0 , -x(5)/((R0+x(3))^2)
             0                                            ,0 , x(4)/((R0+x(3))^2)
             -Omega*cos(x(1))-x(5)/((R0+x(3))*cos(x(1))^2),0 , tan(x(1))*x(5)/((R0+x(3))^2)];          
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F_psi_v=[0             ,1/(R0+x(3))          ,0
             -1/(R0+x(3))  ,0                    ,0
             0             ,-tan(x(1))/(R0+x(3)) ,0];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F_psi_psi=[0                                       ,-x(5)*tan(x(1))/(R0+x(3))-Omega*sin(x(1)) ,x(4)/(R0+x(3))
               x(5)*tan(x(1))/(R0+x(3))+Omega*sin(x(1)),0                                         ,x(5)/(R0+x(3))+Omega*cos(x(1))
               -x(4)/(R0+x(3))                         ,-x(5)/(R0+x(3))-Omega*cos(x(1))           ,0                             ];

    %
%     F=[F_pp   , F_pv   , F_p_psi
%        F_vp   , F_vv   , F_v_psi     
%        F_psi_p, F_psi_v, F_psi_psi ];%9x9
% 
%    G=[zeros(3,6)
%       C          ,zeros(3)
%       zeros(3)   ,-C      ];%9x6
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%    %******** with bias (Random walk)
   F_v_ba = C;
   F_psi_bg =-C;
     F=[F_pp   , F_pv   ,   F_p_psi ,   zeros(3)       , zeros(3)
          F_vp   , F_vv   ,   F_v_psi ,   F_v_ba  , zeros(3)   
          F_psi_p, F_psi_v,   F_psi_psi   zeros(3)      , F_psi_bg
          zeros(6,15)];%15x15
      
    G=[zeros(3,12)
       C          , zeros(3,9)
       zeros(3)   , -C         , zeros(3,6)   
       zeros(3,6) , -eye(3)    , zeros(3)
       zeros(3,9) , -eye(3)];%15x12
   

    %******** with bias (first order Gauss markov)%%********
%    F_v_ba = C;
%    F_psi_bg = -C;
%    tau_ax = tau(1); 
%    tau_ay = tau(2);
%    tau_az = tau(3);
%    tau_gx = tau(4);
%    tau_gy = tau(5);
%    tau_gz = tau(6); 
%    
%        F=[F_pp   , F_pv   ,   F_p_psi   ,zeros(3)      , zeros(3)
%           F_vp   , F_vv   ,   F_v_psi   ,F_v_ba        , zeros(3)   
%           F_psi_p, F_psi_v,   F_psi_psi ,zeros(3)      , F_psi_bg
%           zeros(1,9)                    ,-1/tau_ax       , zeros(1,5)
%           zeros(1,10)                   ,-1/tau_ay       , zeros(1,4)
%           zeros(1,11)                   ,-1/tau_az       , zeros(1,3)     
%           zeros(1,12)                   ,-1/tau_gx       ,0     ,0
%           zeros(1,13)                   ,-1/tau_gy       ,0 
%           zeros(1,14)                   ,-1/tau_gz];%15x15
%       
%        G=[zeros(3,12)
%           C          , zeros(3,9)
%           zeros(3)   , -C         , zeros(3,6)   
%           zeros(3,6) , eye(3)     , zeros(3)
%           zeros(3,9) , eye(3)];%15x12
       
%    sigma_ax = sigma_bias(1);
%    sigma_ay = sigma_bias(2);
%    sigma_az = sigma_bias(3);
%    sigma_gx = sigma_bias(4); 
%    sigma_gy = sigma_bias(5);
%    sigma_gz = sigma_bias(6);
%     G=[zeros(3,12)
%        C          , zeros(3,9)
%        zeros(3)   , -C         , zeros(3,6)   
%        zeros(1,6) , sqrt(2* 1/tau_ax*sigma_ax)    , zeros(1,5)
%        zeros(1,7) , sqrt(2* 1/tau_ay*sigma_ay)    , zeros(1,4)
%        zeros(1,8) , sqrt(2* 1/tau_az*sigma_az)    , zeros(1,3)
%        zeros(1,9) , sqrt(2* 1/tau_gx*sigma_gx)    , 0   0    
%        zeros(1,10) , sqrt(2* 1/tau_gy*sigma_gy)   , 0   
%        zeros(1,11) , sqrt(2* 1/tau_gz*sigma_gz)];%15x12  
   %******** 
end
