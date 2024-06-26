function [ Simulation ] = Signal_Simulation( Simulation , select_navsim_mode , handles_listbox_log )

    select_func.Path_Design     = 1;
    select_func.extract_data    = 1;
    select_func.m2deg_input     = 1;
    select_func.Add_Erotation   = 1;
    select_func.CNB_Data        = 1;
    select_func.NoiseGeneration = 1;
    select_func.Sampling        = 1;
    h = waitbar(0,'Signal simulation is running...');
    WriteInLogWindow( 'Signal simulation is running... ',handles_listbox_log);                                
    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    if select_func.Path_Design==1    
        J=1;
        [Simulation]=Path_Design(Simulation , handles_listbox_log);
        waitbar(J/7,h);
    end
    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    if select_func.extract_data==1
        J=2;
        [Simulation]=extract_data(Simulation , handles_listbox_log);
        waitbar(J/7,h);
    end
    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    if select_func.m2deg_input==1
        J=3;
        [ Simulation ] = m2deg_input( Simulation );
        waitbar(J/7,h);
    end    
    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    if select_func.Add_Erotation==1
        J=4;
        [ Simulation ] =Add_Erotation( Simulation,select_navsim_mode );
        waitbar(J/7,h);
    end
    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    if select_func.CNB_Data==1
        J=5;
        [Simulation]=CNB_Data(Simulation,select_navsim_mode);   
        waitbar(J/7,h);
    end                
    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                   
    if select_func.NoiseGeneration==1
        J=6;
        [Simulation]=NoiseGeneration_Scan(Simulation,1);
        waitbar(J/7,h);
    end
    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    if select_func.Sampling==1
        J=6;
        Simulation = Sampling( Simulation , 1 );
        waitbar(J/7,h);
    end
    delete(h)    
                
end