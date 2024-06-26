%algorithm of computation of attitude(transformation matrix)
%gyro:the angular velocity signal
%Reference : My thesis page 45-47
function New_cbn = New_C_BtoN(dt,cbn,gyro)
vec_mag = sqrt((gyro(1)*dt)^2 + (gyro(2)*dt)^2 + (gyro(3)*dt)^2);
if vec_mag == 0
    New_cbn=cbn;
else    
    alpha = sin(vec_mag)/vec_mag;
    beta  = (1 - cos(vec_mag))/(vec_mag^2);
    OMEGA = [ 0 	     -gyro(3)	gyro(2)
              gyro(3)	 0	        -gyro(1)
              -gyro(2)	 gyro(1)	0      ]*dt;
    New_cbn = cbn*(eye(3) + alpha*OMEGA + beta*(OMEGA^2));
end