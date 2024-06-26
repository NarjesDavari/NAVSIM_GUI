function g1=calcul_g(Simulation)
fx=Simulation.Input.Measurements.IMU(:,2);
fy=Simulation.Input.Measurements.IMU(:,3);
fz=Simulation.Input.Measurements.IMU(:,4);

g1=mean(sqrt(fx.^2+fy.^2+fz.^2));

m_fx=mean(Simulation.Input.Measurements.IMU(:,2));
m_fy=mean(Simulation.Input.Measurements.IMU(:,3));
m_fz=mean(Simulation.Input.Measurements.IMU(:,4));
g2=sqrt(m_fx^2+m_fy^2+m_fz^2);