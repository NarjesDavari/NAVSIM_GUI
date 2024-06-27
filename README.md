# NAVSIM_GUI
This MATLAB-based Graphical User Interface (GUI) is designed for sensor fusion tasks. It provides an intuitive interface to:

- Select Sensors: Choose from various sensor types such as Inertial Measurement Units (IMU), Doppler Velocity Logs (DVL), depth meters, and GNSS from a predefined list.
- Configure Sensor Parameters: Set or modify sensor parameters including bias instability, scale factor, random noise, sampling rate, dynamic/static measurement accuracy, and bandwidth. Default values are also available.
- Initialize Parameters: Define initial values for sensor parameters to tailor the fusion process.
- Load or Simulate Data: Import measurements from real sensors or generate simulated trajectories. Simulated trajectories can be used to create corresponding sensor data.
- Choose Data Fusion Methods: Select from a list of data fusion algorithms to process the sensor data.
- Visualize Outputs: Display results such as absolute error and the estimated trajectory. The trajectory can be visualized in meters or degrees.
- 
Instructions for Use
To use this GUI, first add the directory to the MATLAB path. Then, simply run NAVSIM in the MATLAB command window.
