%Estimation of Latitude and longitude in radian and altitude or depth using estimated velocities.
%Reference: My thesis page 92-93
function [Simulation]=Pos_calcul(Simulation,I,select_navsim_mode,fs,CalculType)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters
    R=6378137;%the radius of the earth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    dt=1/fs;
    if strcmp(select_navsim_mode,'User Defined Path Simulation')
        if strcmp(CalculType,'FeedBack')
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Simulation.Output.User_Def_Sim.ESKF.P_rad(I,1)=Simulation.Output.User_Def_Sim.ESKF.P_rad(I-1,1)+...
                                            dt*(Simulation.Output.User_Def_Sim.INS.X_INS(I,4)/(R+Simulation.Output.User_Def_Sim.INS.X_INS(I,3)));
            Simulation.Output.User_Def_Sim.ESKF.P_rad(I,2)=Simulation.Output.User_Def_Sim.ESKF.P_rad(I-1,2)+...
                                            dt*(Simulation.Output.User_Def_Sim.INS.X_INS(I,5)*sec(Simulation.Output.User_Def_Sim.ESKF.P_rad(I,1))/(R+Simulation.Output.User_Def_Sim.INS.X_INS(I,3)));
        end
        if strcmp(CalculType,'FeedForward')
            Simulation.Output.User_Def_Sim.ESKF.P_rad(I,1)=Simulation.Output.User_Def_Sim.ESKF.P_rad(I-1,1)+...
                                            dt*(Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,2)/(R+Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,1)));
            Simulation.Output.User_Def_Sim.ESKF.P_rad(I,2)=Simulation.Output.User_Def_Sim.ESKF.P_rad(I-1,2)+...
                                            dt*(Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,3)*sec(Simulation.Output.User_Def_Sim.ESKF.P_rad(I,1))/(R+Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,1)));
            Simulation.Output.User_Def_Sim.ESKF.P_rad(I,3)=Simulation.Output.User_Def_Sim.ESKF.P_rad(I-1,3)+dt*Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,4);
        end
    end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    if strcmp(select_navsim_mode,'Processing of Real Measurments')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if strcmp(CalculType,'FeedBack')
            Simulation.Output.PostProc_Real.ESKF.P_rad(I,1)=Simulation.Output.PostProc_Real.ESKF.P_rad(I-1,1)+...
                                            dt*(Simulation.Output.PostProc_Real.INS.X_INS(I,4)/(R+Simulation.Output.PostProc_Real.INS.X_INS(I,3)));
            Simulation.Output.PostProc_Real.ESKF.P_rad(I,2)=Simulation.Output.PostProc_Real.ESKF.P_rad(I-1,2)+...
                                            dt*(Simulation.Output.PostProc_Real.INS.X_INS(I,5)*sec(Simulation.Output.PostProc_Real.ESKF.P_rad(I,1))/(R+Simulation.Output.PostProc_Real.INS.X_INS(I,3)));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if strcmp(CalculType,'FeedForward')
            Simulation.Output.PostProc_Real.ESKF.P_rad(I,1)=Simulation.Output.PostProc_Real.ESKF.P_rad(I-1,1)+...
                dt*(Simulation.Output.PostProc_Real.ESKF.O_corrected(I,2)/(R+Simulation.Output.PostProc_Real.ESKF.O_corrected(I,1)));
            Simulation.Output.PostProc_Real.ESKF.P_rad(I,2)=Simulation.Output.PostProc_Real.ESKF.P_rad(I-1,2)+...
                dt*(Simulation.Output.PostProc_Real.ESKF.O_corrected(I,3)*sec(Simulation.Output.PostProc_Real.ESKF.P_rad(I,1))/(R+Simulation.Output.PostProc_Real.ESKF.O_corrected(I,1)));
            Simulation.Output.PostProc_Real.ESKF.P_rad(I,3)=Simulation.Output.PostProc_Real.ESKF.P_rad(I-1,3)+dt*Simulation.Output.PostProc_Real.ESKF.O_corrected(I,4);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                
    end
