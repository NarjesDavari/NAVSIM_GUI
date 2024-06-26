
function kalman_filter=kalman_filter2(Real_Measurement)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y=[Real_Measurement.IMU(:,2) Real_Measurement.IMU(:,3) Real_Measurement.IMU(:,4)];
Time=Real_Measurement.IMU(:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transition matrix for the continous-time system.
F = [0 0 0 1 0 0 0 0 0;
     0 0 0 0 1 0 0 0 0;
     0 0 0 0 0 1 0 0 0;
     0 0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 0 1 0;
     0 0 0 0 0 0 0 0 1;
     0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0];

% Noise effect matrix for the continous-time system.
L = [0 0 0;
     0 0 0;
     0 0 0;
     0 0 0;
     0 0 0;
     0 0 0;
     1 0 0;
     0 1 0;
     0 0 1];

% Stepsize
dt = 0.2;

% Process noise variance
% q1 = 10000;
% q2 = 10000;
% q3 = 40;
q1 = 1;
q2 = 1;
q3 = 1;
Qc = diag([q1 q2 q3]);

% Discretization of the continous-time system.
[A,Q] = lti_disc(F,L,Qc,dt);

% Measurement model.
H = [0 0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 0 1 0;
     0 0 0 0 0 0 0 0 1];

% Variance in the measurements.
% r1 = 100;
% r2 = 100;
% r3 = 10500;
r1 = 1e8;
r2 = 1e8;
r3 = 1e21;
R  = diag([r1 r2 r3]);

% Generate the data.
Dlength = length(Y);

% Initial guesses for the state mean and covariance.
m = [ 0 0 0 0 0 0 Y(1,1) Y(1,2) Y(1,3)]';
P = Q;

%% Space for the estimates.
MM = zeros(Dlength,size(m,1));
PP = zeros(size(m,1), size(m,1), Dlength);


% Filtering steps.
for i = 1:size(Y,1)
   [m,P] = kf_predict(m,P,A,Q);
   [m,P] = kf_update(m,P,Y(i,:)',H,R);
   MM(i,:) = m;
   PP(:,:,i) = P;
end
% Smoothing step(Backward Filter).
 [SM,SP] = rts_smooth(MM,PP,A,Q);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kalman_filter.fx=MM(:,1);
kalman_filter.fy=MM(:,2);
kalman_filter.fz=MM(:,3);
kalman_filter.f_t(:,2)=Time;

kalman_filter.fx_s=SM(:,1);
kalman_filter.fy_s=SM(:,2);
kalman_filter.fz_s=SM(:,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(kalman_filter.fx,'r')
hold on
plot(Real_Measurement.IMU(:,2))
figure
plot(kalman_filter.fy,'r')
hold on
plot(Real_Measurement.IMU(:,3))
figure
plot(kalman_filter.fz,'r')
hold on
plot(Real_Measurement.IMU(:,4))

