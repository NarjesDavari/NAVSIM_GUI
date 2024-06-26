function xdot = sub_ss(x,ui,DATA,TransTrimVolume,TransCompensVolume)


vx    = x(1);  vy    = x(2);  vz    = x(3);
wx    = x(4);  wy    = x(5);  wz    = x(6);  
theta = x(10); phi   = x(11); psi   = x(12);


alpha  = asin(-vy/(vx^2+vy^2)^0.5);
beta   = asin(vz/(vx^2+vy^2+vz^2)^0.5);
v      = (vx^2+vy^2+vz^2)^0.5;
if alpha<0,
    cx_b  = DATA.CrossDrevative{1,1}(1);
    cx_bb = DATA.CrossDrevative{1,1}(2);
    
    cy_b  = DATA.CrossDrevative{1,2}(1);
    cy_bb = DATA.CrossDrevative{1,2}(2);
    
    mz_b  = DATA.CrossDrevative{1,3}(1);
    mz_bb = DATA.CrossDrevative{1,3}(2);
    
    cz_b  = DATA.CrossDrevative{1,4}(1);
    cz_bb = DATA.CrossDrevative{1,4}(2);
    cz_ab = DATA.CrossDrevative{1,4}(3);
    cz_wy = DATA.CrossDrevative{1,4}(4);
    cz_wx = DATA.CrossDrevative{1,4}(5);
    
    mx_bb = DATA.CrossDrevative{1,6}(1);
    mx_wy = DATA.CrossDrevative{1,6}(2);
    mx_wx = DATA.CrossDrevative{1,6}(3);
    
    my_b  = DATA.CrossDrevative{1,7}(1);
    my_bb = DATA.CrossDrevative{1,7}(2);
    my_ab = DATA.CrossDrevative{1,7}(3);
    my_wy = DATA.CrossDrevative{1,7}(4);
    my_wx = DATA.CrossDrevative{1,7}(5);
end
if alpha>=0,
    cx_b  = DATA.CrossDrevative{1,1}(3);
    cx_bb = DATA.CrossDrevative{1,1}(4);
    
    cy_b  = DATA.CrossDrevative{1,2}(3);
    cy_bb = DATA.CrossDrevative{1,2}(4);
    
    mz_b  = DATA.CrossDrevative{1,3}(3);
    mz_bb = DATA.CrossDrevative{1,3}(4);
    
    cz_b  = DATA.CrossDrevative{1,5}(1);
    cz_bb = DATA.CrossDrevative{1,5}(2);
    cz_ab = DATA.CrossDrevative{1,5}(3);
    cz_wy = DATA.CrossDrevative{1,5}(4);
    cz_wx = DATA.CrossDrevative{1,5}(5);
    
    mx_bb = DATA.CrossDrevative{1,6}(4);
    mx_wy = DATA.CrossDrevative{1,6}(5);
    mx_wx = DATA.CrossDrevative{1,6}(6);
    
    my_b  = DATA.CrossDrevative{1,8}(1);
    my_bb = DATA.CrossDrevative{1,8}(2);
    my_ab = DATA.CrossDrevative{1,8}(3);
    my_wy = DATA.CrossDrevative{1,8}(4);
    my_wx = DATA.CrossDrevative{1,8}(5);
end
cx_bwy = DATA.CrossDrevative{1,1}(5);

alfa      = DATA.HydrodynamicCharacterist{1,1}(:,1)*pi/180;

cx_alfa   = DATA.HydrodynamicCharacterist{1,1}(:,2);
cx_pa     = interp1(alfa,cx_alfa,alpha,'spline');

cy_alfa   = DATA.HydrodynamicCharacterist{1,1}(:,3);
cy_pa     = interp1(alfa,cy_alfa,alpha,'spline');

mz_alfa   = DATA.HydrodynamicCharacterist{1,1}(:,4);
mz_pa     = interp1(alfa,mz_alfa,alpha,'spline');

mx_balfa  = DATA.HydrodynamicCharacterist{1,1}(:,5);
mx_bpa    = interp1(alfa,mx_balfa,alpha,'spline');

cy_wzalfa = DATA.HydrodynamicCharacterist{1,1}(:,6);
cy_wzpa   = interp1(alfa,cy_wzalfa,alpha,'spline');

mz_wzalfa = DATA.HydrodynamicCharacterist{1,1}(:,7);
mz_wzpa   = interp1(alfa,mz_wzalfa,alpha,'spline');

cy_pds  = DATA.SteeringControls{1,1}(1);
mz_pds  = DATA.SteeringControls{1,1}(3);

cy_pde  = DATA.SteeringControls{1,2}(1);
mz_pde  = DATA.SteeringControls{1,2}(3);

cz_pdr  = DATA.SteeringControls{1,3}(1);
my_pdr  = DATA.SteeringControls{1,3}(3);
       

V   = DATA.MainCharacterist{1,1}(1);
h   = DATA.MainCharacterist{1,1}(2);
e   = DATA.MainCharacterist{1,1}(3);
g   = 9.81;   
xG  = 0;      yG  = -h;     zG = 0;       
xB  = 0;      yB  = 0;      zB = 0;    
rho = 0.104;  m   = V*rho;
W   = m*g;    B   = W;

Ix  = DATA.MainCharacterist{1,2}(1)*rho;
Iy  = DATA.MainCharacterist{1,2}(2)*rho;
Iz  = DATA.MainCharacterist{1,2}(3)*rho;

k11 = DATA.MainCharacterist{1,3}(1);
k22 = DATA.MainCharacterist{1,3}(2);
k33 = DATA.MainCharacterist{1,3}(3);
k44 = DATA.MainCharacterist{1,3}(4);
k55 = DATA.MainCharacterist{1,3}(5);
k66 = DATA.MainCharacterist{1,3}(6);

landa11 = k11*m;   landa22 = k22*m;  landa33 = k33*m;
landa44 = k44*Ix;  landa55 = k55*Iy; landa66 = k66*Iz;

delta_e  = ui(1);
delta_s  = ui(2);
delta_r  = ui(3);
n        = ui(4);

cx = cx_pa + cx_b*beta + cx_bb*beta^2;
cy = cy_pa + cy_b*beta + cy_bb*beta^2 + ...
    cy_wzpa*wz*V^(1/3)/v + cy_pde*delta_e + cy_pds*delta_s;
cz = cz_b*beta + cz_bb*beta^2 + cz_wy*wy*V^(1/3)/v + ...
    cz_ab*alpha*beta + cz_wx*wx*V^(1/3)/v + cz_pdr*delta_r;
mx = mx_bpa*beta + mx_bb*beta^2 + ...
    mx_wx*wx*V^(1/3)/v + mx_wy*wy*V^(1/3)/v;
my = my_b*beta + my_bb*beta^2 + my_ab*alpha*beta + ...
    my_wy*wy*V^(1/3)/v + my_wx*wx*V^(1/3)/v + my_pdr*delta_r;
mz = mz_pa + mz_b*beta + mz_bb*beta^2 + ...
    mz_wzpa*wz*V^(1/3)/v + mz_pde*delta_e + mz_pds*delta_s;
n_m= DATA.PowerPlant{1,1}(:,1)/60*2*pi;
Pp = DATA.PowerPlant{1,1}(:,2); 
T  = interp1(n_m,Pp,n,'spline');

P  = TransCompensVolume;
mP = (TransTrimVolume*DATA.MainCharacterist{1,4}(7))+...
     (TransCompensVolume*DATA.MainCharacterist{1,4}(2));
Dh = h*rho*g*V;
Mtb= 0;

Fx = cx*rho*v^2/2*V^(2/3) + cx_bwy*beta*wy*rho*v^2/2*V^(2/3) + T + P*sin(psi);
Fy = cy*rho*v^2/2*V^(2/3) + P*cos(psi)*cos(theta);
Fz = cz*rho*v^2/2*V^(2/3) - P*cos(psi)*sin(theta);

Mx = mx*rho*v^2/2*V - Dh*sin(theta)*cos(psi) + Mtb;
My = my*rho*v^2/2*V + mP*sin(psi)*sin(theta);
Mz = mz*rho*v^2/2*V - Dh*sin(psi) + mP*cos(psi)*cos(theta) - T*e;

F_ex = [Fx Fy Fz Mx My Mz]';
v_sp = [vx vy vz wx wy wz]';

invM = [1/(m+landa11)    0           0          0          0          0
             0     1/(m+landa22)     0          0          0          0
             0           0     1/(m+landa33)    0          0          0
             0           0           0     1/(Ix+landa44)  0          0
             0           0           0          0     1/(Iy+landa55)  0
             0           0           0          0          0     1/(Iz+landa66)  ];

v_spdot = invM*F_ex;

xdot = [                                                     v_spdot(1)
                                                             v_spdot(2)
                                                             v_spdot(3)
                                                             v_spdot(4)
                                                             v_spdot(5)
                                                             v_spdot(6)
 cos(phi)*cos(psi)*vx+(sin(theta)*sin(phi)-cos(theta)*cos(phi)*sin(psi))*vy+(cos(theta)*sin(phi)+sin(theta)*cos(phi)*sin(psi))*vz
                                       sin(psi)*vx+cos(theta)*cos(psi)*vy-sin(theta)*cos(psi)*vz
-cos(psi)*sin(phi)*vx+(sin(theta)*cos(phi)+cos(theta)*sin(phi)*sin(psi))*vy+(cos(phi)*cos(theta)-sin(phi)*sin(theta)*sin(psi))*vz
                                  wx-(sin(psi)*cos(theta)/cos(psi))*wy+(sin(psi)*sin(theta)/cos(psi))*wz
                                            (cos(theta)/cos(psi))*wy-(sin(theta)/cos(psi))*wz
                                                     sin(theta)*wy+cos(theta)*wz                                ];

