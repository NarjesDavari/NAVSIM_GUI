function [ Simulation ] = Alignment( Simulation , i , I , fb , g , Wib_b , include_dvl , IMU_Time , DVL_Time , C_DVL_IMU )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%             dt = 0.01;
%             V1 = Simulation.Output.INS.Cbn(:,:,I-1)'*Simulation.Output.INS.X_INS(I-1,4:6)';
%             V2 = Simulation.Output.INS.Cbn(:,:,I)'*Simulation.Output.INS.X_INS(I,4:6)';

%             V1 = Simulation.Input.Measurements.DVL_100(I-1,2:4)';
%             V2 = Simulation.Input.Measurements.DVL_100(I,2:4)';

%             ax=(V2(1)-V1(1))/dt;
%             ay=(V2(2)-V1(2))/dt;
%             az=(V2(3)-V1(3))/dt;
%              
%             fr=Wib_b(3)*V2(1);

    ax=0;
    ay=0;
    az=0;
    fr=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Simulation.Output.INS.Alignment.RP_counter = Simulation.Output.INS.Alignment.RP_counter + 1;
    
%         Simulation.Output.INS.Alignment.phi(Simulation.Output.INS.Alignment.RP_counter) = atan(fb(2)/fb(3));
%     
%         Simulation.Output.INS.Alignment.theta(Simulation.Output.INS.Alignment.RP_counter)   = atan(fb(1)/sqrt(fb(2)^2+fb(3)^2));

%         Simulation.Output.INS.Alignment.phi(Simulation.Output.INS.Alignment.RP_counter) = atan((fb(2)-ay-fr)/(fb(3)-az));
%     
%         Simulation.Output.INS.Alignment.theta(Simulation.Output.INS.Alignment.RP_counter)   = atan((fb(1)-ax)/sqrt((fb(2)-ay-fr)^2+(fb(3)-az)^2));

        Simulation.Output.INS.Alignment.theta(Simulation.Output.INS.Alignment.RP_counter) = asin((fb(1)-ax)/g(3));  
%         
        Simulation.Output.INS.Alignment.phi(Simulation.Output.INS.Alignment.RP_counter)   = -asin((fb(2)-ay-fr)/...  
                                                                (g(3)*cos(Simulation.Output.INS.Alignment.theta(Simulation.Output.INS.Alignment.RP_counter))));

end


