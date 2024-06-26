%plot of different figures
function  plot_figure( Simulation,select_figure,CalculType )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    select_navsim_mode = Simulation.Input.NAVSIM_Mode;
%     N                  = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    Time    = Simulation.Input.Measurements.IMU(:,1,1);
    Tlength = length(Simulation.Input.Measurements.IMU(:,1,1));
        
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    if strcmp(CalculType,'EKF')
    end
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    if strcmp(CalculType,'UKF')
    end 
   %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     
    if strcmp(CalculType,'DR')
        
        if select_figure.meter_3D
            figure
            plot3(Simulation.Input.Measurements.Ref_Pos(:,3),Simulation.Input.Measurements.Ref_Pos(:,2),Simulation.Input.Measurements.Ref_Pos(:,4),'m')
            hold on
            plot3(Simulation.Output.DR.ave_Pos_m(:,2),Simulation.Output.DR.ave_Pos_m(:,1),Simulation.Output.DR.ave_Pos_m(:,3))
            legend('Designed path in meter','Estimated path in meter');
            xlabel('Xe position(m)');
            ylabel('Xn position(m)');
            zlabel('z position(m)');
            grid on 
        end  
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if select_figure.deg_3D
            figure
            plot3(Simulation.Input.User_Def_Sim.Path.P_deg(:,2),Simulation.Input.User_Def_Sim.Path.P_deg(:,1),Simulation.Input.User_Def_Sim.Path.P_deg(:,3),'m')
            hold on
            plot3(Simulation.Output.DR.ave_Pos_rad(:,2)*180/pi,Simulation.Output.DR.ave_Pos_rad(:,1)*180/pi,Simulation.Output.DR.ave_Pos_rad(:,3));
            legend('Designed path in deg','Estimated path in deg');
            xlabel('lon position(radian)');
            ylabel('lat position(radian)');
            zlabel('alt position(m)');
            grid on
        end      
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if select_figure.relative_error 
            figure
            plot(Time(1:Tlength-2),Simulation.Output.DR.Pos_Error.ave_relative_error_i,'m')
            title('Relative Error');
            xlabel('Time(s)');
            ylabel('Relative Error');
            grid on            
        end
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if select_figure.absolute_error
            figure
            plot(Time(1:Tlength-1),Simulation.Output.DR.Pos_Error.ave_absolute_error_i,'m')            
            title(' The distance between designed and estimated path ');
            xlabel('Time(s)');
            ylabel('absolute error(m)');   
            grid on            
        end
    end    
   %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     
    if strcmp(CalculType,'ESKF')
        
        if select_figure.meter_3D
            figure
            plot3(Simulation.Input.Measurements.Ref_Pos(:,3),Simulation.Input.Measurements.Ref_Pos(:,2),Simulation.Input.Measurements.Ref_Pos(:,4),'m')
            hold on
            plot3(Simulation.Output.ESKF.ave_Pos_m(:,2),Simulation.Output.ESKF.ave_Pos_m(:,1),Simulation.Output.ESKF.ave_Pos_m(:,3))
            legend('Designed path in meter','Estimated path in meter');
            xlabel('Xe position(m)');
            ylabel('Xn position(m)');
            zlabel('z position(m)');
            grid on 
        end  
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if select_figure.deg_3D
            figure
            plot3(Simulation.Input.User_Def_Sim.Path.P_deg(:,2),Simulation.Input.User_Def_Sim.Path.P_deg(:,1),Simulation.Input.User_Def_Sim.Path.P_deg(:,3),'m')
            hold on
            plot3(Simulation.Output.ESKF.ave_Pos_rad(:,2)*180/pi,Simulation.Output.ESKF.ave_Pos_rad(:,1)*180/pi,Simulation.Output.ESKF.ave_Pos_rad(:,3));
            legend('Designed path in deg','Estimated path in deg');
            xlabel('lon position(radian)');
            ylabel('lat position(radian)');
            zlabel('alt position(m)');
            grid on
        end      
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if select_figure.relative_error 
            figure
            plot(Time(1:Tlength-1),Simulation.Output.ESKF.Pos_Error.ave_relative_error_i,'m')
            title('Relative Error');
            xlabel('Time(s)');
            ylabel('Relative Error');
            grid on            
        end
        %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if select_figure.absolute_error
            figure
            plot(Time(1:Tlength),Simulation.Output.ESKF.Pos_Error.ave_absolute_error_i,'m')            
            title(' The distance between designed and estimated path ');
            xlabel('Time(s)');
            ylabel('absolute error(m)');   
            grid on            
        end
    end

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


end