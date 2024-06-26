function [ DVL ] = dvlinterp( DVL,DVL1,Real_Measurement )

    Time1=DVL1(:,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
   
    Vx=DVL1(:,2);
    Vy=DVL1(:,3);
    Vz=DVL1(:,4);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    Timei=Real_Measurement.IMU(:,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Vxi =interp1(Time1,Vx,Timei,'linear');
    Vyi =interp1(Time1,Vy,Timei,'linear');
    Vzi =interp1(Time1,Vz,Timei,'linear');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    DVL.DVL_100     =[];
    DVL.DVL_100(:,1)=Timei;
    DVL.DVL_100(:,2)=Vxi;
    DVL.DVL_100(:,3)=Vyi;
    DVL.DVL_100(:,4)=Vzi;

end