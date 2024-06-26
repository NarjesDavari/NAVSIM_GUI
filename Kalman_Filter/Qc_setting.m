%Tunning of Qc(power spectral density) elements

function [ Simulation ] = Qc_setting( Simulation )

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    PSD_ax             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_AxV');
    PSD_ay             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_AyV');
    PSD_az             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_AzV');
    TC_qax             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_AxT');%TC:Tuning Coefficient
    TC_qay             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_AyT');
    TC_qaz             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_AzT');
    
    PSD_wx             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_GxV');
    PSD_wy             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_GyV');
    PSD_wz             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_GzV');
    TC_qwx             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_GxT');
    TC_qwy             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_GyT');
    TC_qwz             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_GzT');
    
    PSD_Bax             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BAxV');
    PSD_Bay             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BAyV');
    PSD_Baz             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BAzV');
    TC_qBax             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BAxT');%TC:Tuning Coefficient
    TC_qBay             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BAyT');
    TC_qBaz             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BAzT');

    PSD_Bwx             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BGxV');
    PSD_Bwy             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BGyV');
    PSD_Bwz             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BGzV');
    TC_qBwx             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BGxT');
    TC_qBwy             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BGyT');
    TC_qBwz             = GetParam(Simulation.Parameters_IMUNoisePSD ,'edit_PSD_BGzT');   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    q_ax=(PSD_ax)*TC_qax;
    q_ay=(PSD_ay)*TC_qay;
    q_az=(PSD_az)*TC_qaz;
            
    q_wx=(PSD_wx)*TC_qwx;    
    q_wy=(PSD_wy)*TC_qwy;    
    q_wz=(PSD_wz)*TC_qwz;
    
    
     q_b_ax=(PSD_Bax)*TC_qBax;
     q_b_ay=(PSD_Bay)*TC_qBay;
     q_b_az=(PSD_Baz)*TC_qBaz;
            
     q_b_wx=(PSD_Bwx)*TC_qBwx;    
     q_b_wy=(PSD_Bwy)*TC_qBwy;    
     q_b_wz=(PSD_Bwz)*TC_qBwz;    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Simulation.Output.Kalman_mtx.Qc.q_ax=q_ax;  
    Simulation.Output.Kalman_mtx.Qc.q_ay=q_ay; 
    Simulation.Output.Kalman_mtx.Qc.q_az=q_az; 
    
    Simulation.Output.Kalman_mtx.Qc.q_wx=q_wx;
    Simulation.Output.Kalman_mtx.Qc.q_wy=q_wy;
    Simulation.Output.Kalman_mtx.Qc.q_wz=q_wz;
    
    Simulation.Output.Kalman_mtx.Qc.q_Bax=q_b_ax;  
    Simulation.Output.Kalman_mtx.Qc.q_Bay=q_b_ay; 
    Simulation.Output.Kalman_mtx.Qc.q_Baz=q_b_az; 
    
    Simulation.Output.Kalman_mtx.Qc.q_Bwx=q_b_wx;
    Simulation.Output.Kalman_mtx.Qc.q_Bwy=q_b_wy;
    Simulation.Output.Kalman_mtx.Qc.q_Bwz=q_b_wz;
    
    Simulation.Output.Kalman_mtx.Qc.Bias_Station=[q_b_ax   q_b_ay   q_b_az  q_b_wx   q_b_wy   q_b_wz];  

    
end

