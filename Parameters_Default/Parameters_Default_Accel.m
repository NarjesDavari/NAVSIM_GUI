function Parameters = Parameters_Default_Accel()

I                      = 1;
Parametres(I).title    = 'VRW Unit';
Parametres(I).val      = 2;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'The unit of the Velocity Random Walk';
Parametres(I).style    = 'popupmenu';
Parametres(I).choix    = {'ug/rt Hz' 'm/s^2/rt Hz' 'm/s/rt hr' 'mg'};
Parametres(I).tag      = 'vrw_unit';

I                      = I+1;
Parametres(I).title    = 'VRW(x-channel)';
Parametres(I).val      = 0;%0.002
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Velocity Random Walk of the x-channel';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'vrw_x';

I                      = I+1;
Parametres(I).title    = 'VRW(y-channel)';
Parametres(I).val      = 0;%0.002
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Velocity Random Walk of the y-channel';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'vrw_y';

I                      = I+1;
Parametres(I).title    = 'VRW(z-channel)';
Parametres(I).val      = 0;%0.002
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Velocity Random Walk of the z-channel';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'vrw_z';

I                      = I+1;
Parametres(I).title    = 'BS Unit';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'The unit of the Bias Stability';
Parametres(I).style    = 'popupmenu';
Parametres(I).choix    = {'m/s^2' 'mg'};
Parametres(I).tag      = 'bs_unit';

I                      = I + 1;
Parametres(I).title    = 'BS(x-channel)';
Parametres(I).val      = 0;%0.02
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Bias Stability of the x-channel';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'bs_x';

I                      = I + 1;
Parametres(I).title    = 'BS(y-channel)';
Parametres(I).val      = 0;%0.02
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Bias Stability of the y-channel';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'bs_y';

I                      = I + 1;
Parametres(I).title    = 'BS(z-channel)';
Parametres(I).val      = 0;%0.02
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Bias Stability of the z-channel';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'bs_z';

I                      = I + 1;
Parametres(I).title    = 'Correlation Time';
Parametres(I).val      = [100,100,100];
Parametres(I).units    = 'Sec';
Parametres(I).tooltipstring = 'Correlation Time of Acceleration in the directions of [X Y Z]';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'accel_correlation_time';

I                      = I + 1;
Parametres(I).title    = 'Averaging Time';
Parametres(I).val      = 100;
Parametres(I).units    = 'sec';
Parametres(I).tooltipstring = 'The averaging time at which the Bias Stability measurement is made';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'averaging_time';

I                      = I+1;
Parametres(I).title    = 'Bias Offset Unit';
Parametres(I).val      = 2;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'The unit of the Bias Offset';
Parametres(I).style    = 'popupmenu';
Parametres(I).choix    = {'m/s^2' 'mg'};
Parametres(I).tag      = 'b_unit';

I                      = I + 1;
Parametres(I).title    = 'Bias Offset (x-channel)';
Parametres(I).val      = 0;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Bias Offset of the x-channel';
Parametres(I).style    = 'edit';
Parametres(I).tag      = 'Bias_x';

I                      = I + 1;
Parametres(I).title    = 'Bias Offset (y-channel)';
Parametres(I).val      = 0;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Bias Offset of the y-channel';
Parametres(I).style    = 'edit';
Parametres(I).tag      = 'Bias_y';

I                      = I + 1;
Parametres(I).title    = 'Bias Offset (z-channel)';
Parametres(I).val      = 0;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Bias Offset of the z-channel';
Parametres(I).style    = 'edit';
Parametres(I).tag      = 'Bias_z';

I                      = I + 1;
Parametres(I).title    = 'SFe Unit';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'The unit of the Scale Factor Error';
Parametres(I).style    = 'popupmenu';
Parametres(I).choix    = {'PPM' '%'};
Parametres(I).tag      = 'sfe_unit';

I                      = I + 1;
Parametres(I).title    = 'SFe x';
Parametres(I).val      = 0;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Scale Factor Error (X-Accel)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'sfe_x';

I                      = I + 1;
Parametres(I).title    = 'SFe y';
Parametres(I).val      = 0;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Scale Factor Error (Y-Accel)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'sfe_y';

I                      = I + 1;
Parametres(I).title    = 'SFe z';
Parametres(I).val      = 0;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Scale Factor Error (Z-Accel)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'sfe_z';

I                      = I + 1;
Parametres(I).title    = 'Bandwidth';
Parametres(I).val      = 30;
Parametres(I).units    = 'Hz';
Parametres(I).tooltipstring = 'The bandwidth of the accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).tag      = 'bandwidth';

I                      = I + 1;
Parametres(I).title    = 'CutOff Frequency';
Parametres(I).val      = 5;
Parametres(I).units    = 'Hz';
Parametres(I).tooltipstring = 'The cut-off frequency of the lowpass filter';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'cutoff_frequency';

I                      =I+1;
Parametres(I).title    = 'Filter';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'Using filtered signals';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'filter';


Parameters.Param = Parametres;
Parameters.name  = 'Accelerometers Parameters';
Parameters.text  = 'Parameters required for Accelerometers';
end

