% function [ Ref_Pos ] = GPS_interp( kalman_filter , Real_Measurement )
function [ Ref_Pos ] = GPS_interp( xn,xe,h, Real_Measurement )

    Time2=xn(:,1);
    xn = xn(:,2);
    xe = xe(:,2);
    h  = h(:,2);     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     Time2=kalman_filter.h_f(:,2);
%     xn = kalman_filter.xn_s;
%     xe = kalman_filter.xe_s;
%     h  = kalman_filter.h_s;    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    Timei=Real_Measurement.IMU(:,1);
    
    % interpolates the values of the points xn and xe and h at
    % the points Timei
    xni=interp1(Time2,xn,Timei,'linear');
    xei=interp1(Time2,xe,Timei,'linear');
    hi =interp1(Time2,h,Timei,'linear');
        
    Ref_Pos=zeros(length(Timei),4);
    
    Ref_Pos(:,1)=Timei;
    Ref_Pos(:,2)=xni;
    Ref_Pos(:,3)=xei;
    Ref_Pos(:,4)=hi;

end