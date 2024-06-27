# NAVSIM_GUI
A Graphical User Interface (GUI) based on Matlab for sensor fusion. In this GUI it is possible to
- select different type of sensors (such as inertial measurement unit (IMU), (doppler velocity log) DVL, depthmeter, GNSS) from list for data fusion task 
- select different values for parameters of sensors (or using default value) such as bias insatability, scale factor, random noise, sampling rate, daynamic/static accuracy of measuremnts, and Bandwidth.
- set initial value for parameters
- Load measurements from real sensors or select/make simulated trajectory (the simulated trajectory has been used to create simulated value for sensors)
- select a data fusion method from list
- Visulazation of outputs (absolute error, estimated trajectory (in meter or degree))

For using this GUI, run NAVSIM on the command window Mathab
