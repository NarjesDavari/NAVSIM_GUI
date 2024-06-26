function [ Simulation ] = DeadReckoning( Simulation , I , i ,fs )

    R=6378137;
    dt=1/fs;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    euler = [(Simulation.Input.Measurements.RollPitch(I,2,i))*pi/180,...
             (Simulation.Input.Measurements.RollPitch(I,3,i)+1)*pi/180,...
             (Simulation.Input.Measurements.Heading(I,2,i)+5)*pi/180];
    %algorithm1
    NC_BtoN=InCBN(euler);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Vb=[Simulation.Input.Measurements.DVL(I,2,i),...
        Simulation.Input.Measurements.DVL(I,3,i),...
        Simulation.Input.Measurements.DVL(I,4,i)];
    Vn = (NC_BtoN*Vb')' ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Vn_   = Simulation.Output.DR.X(I-1,4:6);
    Posn_ = Simulation.Output.DR.X(I-1,1:3);
    
            Posn(1)=Posn_(1)+dt*...
                    (Vn_(1)/(R+Posn_(3)));
            Posn(2)=Posn_(2)+dt*...
                    (Vn_(2)*sec(Posn_(1))/(R+Posn_(3)));
            Posn(3)=Posn_(3)+dt*...
                     Vn_(3);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Simulation.Output.DR.X(I,:)=[Posn,Vn,euler(1),euler(2),euler(3),0 0 0];
    
end

