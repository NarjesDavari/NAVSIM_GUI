function [ GPS ] = GPS_Sampling( Pos_deg,Pos_Ref )

    fs       = 100;
    fs_GPS   = 5;
    
    GPS1        = Pos_deg(:,1:3);
    
    Time1      = Pos_Ref(:,4);
    IMU_length = length(Pos_Ref);
    Dlength    = length(Pos_Ref(:,4)); 
    
    Smpl_GPS = fix(fs/fs_GPS);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~(Smpl_GPS==1)
        GPS2 = zeros(fix(IMU_length/Smpl_GPS),4);
        J=0;
        for I=1:Dlength
            if I*Smpl_GPS+1<=Dlength
                if I==1
                    J=J+1;
                    GPS2(J,1)   = Time1(1);
                    GPS2(J,2:4) = GPS1(1,:);
                else
                    J=J+1;
                    GPS2(J,1) = Time1((I-1)*Smpl_GPS+1,1);
                    GPS2(J,2:4) = GPS1((I-1)*Smpl_GPS+1,:);                    
                end                        
            end    
        end        
    else
        GPS2 = zeros(fix(IMU_length/Smpl_GPS),2);
        J=0;
        for I=1:Dlength
            if I*Smpl_GPS<=Dlength
                if I==1
                    J=J+1;
                    GPS2(J,1)   = Time1(1);
                    GPS2(J,2:4) = GPS1(1,:);
                else
                    J=J+1;
                    GPS2(J,1) = Time1(I*Smpl_GPS,1);
                    GPS2(J,2:4) = GPS1(I*Smpl_GPS,:);                     
                end           
            end    
        end         
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        GPS.Time = zeros(length(GPS2),1);
        GPS.Data = zeros(length(GPS2),3);
        
    GPS.Time = GPS2(:,1);
    GPS.Data = GPS2(:,2:4);        
end

