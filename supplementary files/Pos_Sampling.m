function [ Position ] = Pos_Sampling( Real_Measurement )
fs  = 100;
fs_Position = 1;
Pos1_length = length(Real_Measurement.Ref_Pos);
    %Position with 100 Hz frequency
    Pos1(:,1) = Real_Measurement.Ref_Pos(:,2);
    Pos1(:,2) = Real_Measurement.Ref_Pos(:,3);
    Pos1(:,3) = Real_Measurement.Ref_Pos(:,4);

    Time1 = Real_Measurement.Ref_Pos(:,1);
    
    smpl_Pos = fix(fs/fs_Position);
    
        Pos2 = zeros(fix(Pos1_length/smpl_Pos),4);
        J=0;
        for I=1:Pos1_length
            if I*smpl_Pos<=Pos1_length
                if I==1
                    J=J+1;
                    Pos2(J,1)   = Time1(1,1);
                    Pos2(J,2:4) = Pos1(1,:);
                else
                    J=J+1;
                    Pos2(J,1)   = Time1((I-1)*smpl_Pos+1,1);
                    Pos2(J,2:4) = Pos1((I-1)*smpl_Pos+1,:);                    
                end            
            end    
        end
%         Path = zeros(length(Pos2),4);
        Position.Path = Pos2;
end

