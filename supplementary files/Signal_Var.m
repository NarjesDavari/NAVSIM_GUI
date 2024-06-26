function [ Var ] = Signal_Var( Simulation )
Var.var_ax             = str2double(Simulation.Parameters_KF.Var_Accx_Value);
Var.var_ay             = str2double(Simulation.Parameters_KF.Var_Accy_Value);
Var.var_az             = str2double(Simulation.Parameters_KF.Var_Accz_Value);

Var.var_wx             = str2double(Simulation.Parameters_KF.Var_Gyrox_Value);
Var.var_wy             = str2double(Simulation.Parameters_KF.Var_Gyroy_Value);
Var.var_wz             = str2double(Simulation.Parameters_KF.Var_Gyroz_Value);

Var.var_vx             = str2double(Simulation.Parameters_KF.Var_Vx_Value);
Var.var_vy             = str2double(Simulation.Parameters_KF.Var_Vy_Value);
Var.var_vz             = str2double(Simulation.Parameters_KF.Var_Vz_Value);

Var.var_roll           = str2double(Simulation.Parameters_KF.Var_Roll_Value);
Var.var_pitch          = str2double(Simulation.Parameters_KF.Var_Pitch_Value);
Var.var_yaw            = str2double(Simulation.Parameters_KF.Var_Yaw_Value);

Var.var_alt            = str2double(Simulation.Parameters_KF.Var_D_Value);
end

