%Navigation equations that describe the behaviour of the system (related to UKF)
%x=[Lat,lon,h,Vn,Ve,Vd,fn,fe,fd,phi,theta,psi,Wx,Wy,Wz]:15x1(N=15)
%R:the length of the semi-major axis
%e:the major eccentricity of the ellipsoid
%RN:the meridian radius of curvature
%RE:the transverse radius of curvature
%R0:The mean radius of curvature
%Reference: My thesis page 75-80
function [x] = nav_eqn(x,dt)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters of the Earth
    R=6378137;
    e=0.0818191908426;
%     Omega=7.292115e-05;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    RN=R*(1-e^2)/(1-e^2*(sin(x(1)))^2)^1.5;
    RE=R/(1-e^2*(sin(x(1)))^2)^0.5;
    %
    k1=sec(x(1));
    k2=sin(x(10));
    k3=cos(x(10));
    k4=tan(x(11));
    k5=sec(x(11));
    %
    x(1)=x(1)+dt*(x(4)/(RN+x(3)));
    x(2)=x(2)+dt*(x(5)*k1/(RE+x(3)));
    x(3)=x(3)+(dt*x(6));
    %
    x(4)=x(4)+dt*x(7);
    x(5)=x(5)+dt*x(8);
    x(6)=x(6)+dt*x(9);
    %
    x(10)=x(10)+dt*((x(14)*k2+x(15)*k3)*k4+x(13));        
    x(11)=x(11)+dt*(x(14)*k3-x(15)*k2);        
    x(12)=x(12)+dt*((x(14)*k2+x(15)*k3)*k5);