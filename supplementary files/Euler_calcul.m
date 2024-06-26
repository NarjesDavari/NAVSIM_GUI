%Computation of the Euler angles using the angular rates measured by
%gyroscopes
%Reference : My thesis page 49
function [ Simulation ] = Euler_calcul( Simulation,Wnb_b,I,select_navsim_mode,fs )

        dt=1/fs;
        if strcmp(select_navsim_mode,'User Defined Path Simulation')
            Simulation.Output.User_Def_Sim.INS.Euler.phi(I)=Simulation.Output.User_Def_Sim.INS.Euler.phi(I-1)+dt*...
            ((Wnb_b(2)*sin(Simulation.Output.User_Def_Sim.INS.Euler.phi(I-1))+Wnb_b(3)*cos(Simulation.Output.User_Def_Sim.INS.Euler.phi(I-1)))*...
            tan(Simulation.Output.User_Def_Sim.INS.Euler.theta(I-1))+Wnb_b(1));
       
            Simulation.Output.User_Def_Sim.INS.Euler.theta(I)=Simulation.Output.User_Def_Sim.INS.Euler.theta(I-1)+dt*...
            (Wnb_b(2)*cos(Simulation.Output.User_Def_Sim.INS.Euler.phi(I-1))-Wnb_b(3)*sin(Simulation.Output.User_Def_Sim.INS.Euler.phi(I-1)));
      
            Simulation.Output.User_Def_Sim.INS.Euler.psi(I)=Simulation.Output.User_Def_Sim.INS.Euler.psi(I-1)+dt*...
                ((Wnb_b(2)*sin(Simulation.Output.User_Def_Sim.INS.Euler.phi(I-1))+Wnb_b(3)*cos(Simulation.Output.User_Def_Sim.INS.Euler.phi(I-1)))*...
                sec(Simulation.Output.User_Def_Sim.INS.Euler.theta(I-1)));
            
%             if Simulation.Output.User_Def_Sim.INS.Euler.psi(I)>= pi
%                 Simulation.Output.User_Def_Sim.INS.Euler.psi(I) = Simulation.Output.User_Def_Sim.INS.Euler.psi(I) - 2*pi;
%             end
%             if Simulation.Output.User_Def_Sim.INS.Euler.psi(I)<= -pi
%                 Simulation.Output.User_Def_Sim.INS.Euler.psi(I) = Simulation.Output.User_Def_Sim.INS.Euler.psi(I) + 2*pi;
%             end             
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if strcmp(select_navsim_mode,'Processing of Real Measurments')
            Simulation.Output.PostProc_Real.INS.Euler.phi(I)=Simulation.Output.PostProc_Real.INS.Euler.phi(I-1)+dt*...
            ((Wnb_b(2)*sin(Simulation.Output.PostProc_Real.INS.Euler.phi(I-1))+Wnb_b(3)*cos(Simulation.Output.PostProc_Real.INS.Euler.phi(I-1)))*...
            tan(Simulation.Output.PostProc_Real.INS.Euler.theta(I-1))+Wnb_b(1));
       
            Simulation.Output.PostProc_Real.INS.Euler.theta(I)=Simulation.Output.PostProc_Real.INS.Euler.theta(I-1)+dt*...
            (Wnb_b(2)*cos(Simulation.Output.PostProc_Real.INS.Euler.phi(I-1))-Wnb_b(3)*sin(Simulation.Output.PostProc_Real.INS.Euler.phi(I-1)));
      
            Simulation.Output.PostProc_Real.INS.Euler.psi(I)=Simulation.Output.PostProc_Real.INS.Euler.psi(I-1)+dt*...
                ((Wnb_b(2)*sin(Simulation.Output.PostProc_Real.INS.Euler.phi(I-1))+Wnb_b(3)*cos(Simulation.Output.PostProc_Real.INS.Euler.phi(I-1)))*...
                sec(Simulation.Output.PostProc_Real.INS.Euler.theta(I-1)));
            
            if Simulation.Output.PostProc_Real.INS.Euler.psi(I)> pi
                Simulation.Output.PostProc_Real.INS.Euler.psi(I) = Simulation.Output.PostProc_Real.INS.Euler.psi(I) - 2*pi;
            end
            if Simulation.Output.PostProc_Real.INS.Euler.psi(I)< -pi
                Simulation.Output.PostProc_Real.INS.Euler.psi(I) = Simulation.Output.PostProc_Real.INS.Euler.psi(I) + 2*pi;
            end            
        end
end

