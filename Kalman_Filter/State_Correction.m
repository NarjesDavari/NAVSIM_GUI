function [ Simulation ] = State_Correction( Simulation , I, ave_sample  )                                                                      
   
           global Updt_Cntr;
           global Cbn_det;             
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.ESKF.O_corrected(I - ave_sample + 1,1:6) = Simulation.Output.INS.X_INS(I - ave_sample + 1,1:6)- ...
                                                                     Simulation.Output.ESKF.dX(I - ave_sample + 1,1:6);  
    
            Simulation.Output.INS.X_INS(I - ave_sample + 1,1:6)   = Simulation.Output.ESKF.O_corrected(I - ave_sample + 1,1:6);  
            
            Simulation.Output.ESKF.O_corrected(I - ave_sample + 1,10:15) = Simulation.Output.INS.X_INS(I - ave_sample + 1,10:15)+ ...
                                                                 Simulation.Output.ESKF.dX(I - ave_sample + 1,10:15);
            Simulation.Output.INS.X_INS(I - ave_sample + 1,10:15)   = Simulation.Output.ESKF.O_corrected(I - ave_sample + 1,10:15); 
            
         %Limitation
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,3) > 300 
                Simulation.Output.INS.X_INS(I - ave_sample + 1,3) = 300;
            end
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,3) < -5
                Simulation.Output.INS.X_INS(I - ave_sample + 1,3) = -5;
            end
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,4) > 20
                Simulation.Output.INS.X_INS(I - ave_sample + 1,4) = 20;
            end
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,4) < -20
                Simulation.Output.INS.X_INS(I - ave_sample + 1,4) = -20;
            end    
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,5) > 20
                Simulation.Output.INS.X_INS(I - ave_sample + 1,5) = 20;
            end
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,5) < -20
                Simulation.Output.INS.X_INS(I - ave_sample + 1,5) = -20;
            end    
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,6) > 20
                Simulation.Output.INS.X_INS(I - ave_sample + 1,6) = 20;
            end
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,6) < -20
                Simulation.Output.INS.X_INS(I - ave_sample + 1,6) = -20;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            dPsi=Simulation.Output.ESKF.dX(I - ave_sample + 1,7:9);
            dPsi_SSM=[0        -dPsi(3) dPsi(2)
                      dPsi(3)  0        -dPsi(1)
                      -dPsi(2) dPsi(1)  0       ];
            Simulation.Output.ESKF.Cbn_corrected(:,:,I - ave_sample + 1) = (eye(3) + dPsi_SSM) * Simulation.Output.INS.Cbn(:,:,I - ave_sample + 1);
            if Updt_Cntr > 0
                Cbn_det(Updt_Cntr,1)= det(Simulation.Output.ESKF.Cbn_corrected(:,:,I - ave_sample + 1));
            end
            Simulation.Output.ESKF.Cbn_corrected(:,:,I - ave_sample + 1) = ...
            Simulation.Output.ESKF.Cbn_corrected(:,:,I - ave_sample + 1) / det (Simulation.Output.ESKF.Cbn_corrected(:,:,I - ave_sample + 1));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Limitation
            if Simulation.Output.ESKF.Cbn_corrected(3,1,I - ave_sample + 1) > 0.5
               Simulation.Output.ESKF.Cbn_corrected(3,1,I - ave_sample + 1) = 0.5; 
            end
            if Simulation.Output.ESKF.Cbn_corrected(3,1,I - ave_sample + 1) < -0.5
               Simulation.Output.ESKF.Cbn_corrected(3,1,I - ave_sample + 1) = -0.5; 
            end            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            phi   = atan2(Simulation.Output.ESKF.Cbn_corrected(3,2,I - ave_sample + 1),Simulation.Output.ESKF.Cbn_corrected(3,3,I - ave_sample + 1));    
            theta = -atan(Simulation.Output.ESKF.Cbn_corrected(3,1,I - ave_sample + 1)/sqrt(1-Simulation.Output.ESKF.Cbn_corrected(3,1,I - ave_sample + 1)^2));
            psi   = atan2(Simulation.Output.ESKF.Cbn_corrected(2,1,I - ave_sample + 1),Simulation.Output.ESKF.Cbn_corrected(1,1,I - ave_sample + 1));         
            Simulation.Output.ESKF.O_corrected(I - ave_sample + 1,7:8)=[phi theta];
            Simulation.Output.INS.X_INS(I - ave_sample + 1,7:8)      = [phi theta];
            Simulation.Output.ESKF.O_corrected(I - ave_sample + 1,9) = psi;
            Simulation.Output.INS.X_INS(I - ave_sample + 1,9)        = psi;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Roll Limitation
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,7) > 30 * pi/180 
                Simulation.Output.INS.X_INS(I - ave_sample + 1,7) = 30 * pi/180;
            end
            if Simulation.Output.INS.X_INS(I - ave_sample + 1,7) < -30 * pi/180 
                Simulation.Output.INS.X_INS(I - ave_sample + 1,7) = - 30 * pi/180;
            end             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
      
end

