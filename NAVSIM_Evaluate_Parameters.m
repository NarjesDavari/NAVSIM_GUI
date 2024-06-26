function [Simulation] = NAVSIM_Evaluate_Parameters(Simulation)


Simulation.Parameters_Accel       = EvaluateParameters(Simulation.Parameters_Accel);
Simulation.Parameters_Gyro        = EvaluateParameters(Simulation.Parameters_Gyro);
Simulation.Parameters_DVL         = EvaluateParameters(Simulation.Parameters_DVL);
Simulation.Parameters_DepthMeter  = EvaluateParameters(Simulation.Parameters_DepthMeter);
Simulation.Parameters_GyroCompass = EvaluateParameters(Simulation.Parameters_GyroCompass);

Simulation.Init_Value             = EvaluateParameters(Simulation.Init_Value);

Simulation.Parameters_IMUNoisePSD     = EvaluateParameters(Simulation.Parameters_IMUNoisePSD);
Simulation.Parameters_AuxSnsrNoiseVar = EvaluateParameters(Simulation.Parameters_AuxSnsrNoiseVar);
Simulation.Parameters_UKF             = EvaluateParameters(Simulation.Parameters_UKF);
