function Tab = NAVSIM_GenTab_ParamSensors(Simulation)

Tab{1,1} = Simulation.Parameters_Accel.text;

for I=1:length(Simulation.Parameters_Accel.Param)
    Tab{2+I,1} = Simulation.Parameters_Accel.Param(I).title;
    Tab{2+I,2} = GetParamStr(Simulation.Parameters_Accel,Simulation.Parameters_Accel.Param(I).tag);
    %Tab{2+I,2} = Simulation.Parameters_Accel.Param(I).val;
    Tab{2+I,3} = Simulation.Parameters_Accel.Param(I).tooltipstring;
end

J=2+2+I;
Tab{J,1} = Simulation.Parameters_Gyro.text;

for I=1:length(Simulation.Parameters_Gyro.Param)
    Tab{1+J+I,1} = Simulation.Parameters_Gyro.Param(I).title;
    Tab{1+J+I,2} = GetParamStr(Simulation.Parameters_Gyro,Simulation.Parameters_Gyro.Param(I).tag);
    %Tab{1+J+I,2} = Simulation.Parameters_Gyro.Param(I).val;
    Tab{1+J+I,3} = Simulation.Parameters_Gyro.Param(I).tooltipstring;
end

J=3+I+J;
Tab{J,1} = Simulation.Parameters_DVL.text;

for I=1:length(Simulation.Parameters_DVL.Param)
    Tab{1+J+I,1} = Simulation.Parameters_DVL.Param(I).title;
    Tab{1+J+I,2} = GetParamStr(Simulation.Parameters_DVL,Simulation.Parameters_DVL.Param(I).tag);
    %Tab{1+J+I,2} = Simulation.Parameters_DVL.Param(I).val;
    Tab{1+J+I,3} = Simulation.Parameters_DVL.Param(I).tooltipstring;
end

J=3+I+J;
Tab{J,1} = Simulation.Parameters_GyroCompass.text;

for I=1:length(Simulation.Parameters_GyroCompass.Param)
    Tab{1+J+I,1} = Simulation.Parameters_GyroCompass.Param(I).title;
    Tab{1+J+I,2} = GetParamStr(Simulation.Parameters_GyroCompass,Simulation.Parameters_GyroCompass.Param(I).tag);
    %Tab{1+J+I,2} = Simulation.Parameters_GyroCompass.Param(I).val;
    Tab{1+J+I,3} = Simulation.Parameters_GyroCompass.Param(I).tooltipstring;
end

J=3+I+J;
Tab{J,1} = Simulation.Parameters_DepthMeter.text;

for I=1:length(Simulation.Parameters_DepthMeter.Param)
    Tab{1+J+I,1} = Simulation.Parameters_DepthMeter.Param(I).title;
    Tab{1+J+I,2} = GetParamStr(Simulation.Parameters_DepthMeter,Simulation.Parameters_DepthMeter.Param(I).tag);
    %Tab{1+J+I,2} = Simulation.Parameters_DepthMeter.Param(I).val;
    Tab{1+J+I,3} = Simulation.Parameters_DepthMeter.Param(I).tooltipstring;
end
