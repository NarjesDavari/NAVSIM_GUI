function PlotPath( handles )

        figure
        plot3(handles.Simulation.Input.User_Def_Sim.Path.Points(:,2),handles.Simulation.Input.User_Def_Sim.Path.Points(:,1),handles.Simulation.Input.User_Def_Sim.Path.Points(:,3),'r.','MarkerSize',20)
        title('Designed path in meter');
        xlabel('xn position');
        ylabel('xe position');
        zlabel('h position');
        grid on 