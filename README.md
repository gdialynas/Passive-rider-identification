# Passive rider identification

In bicycles the rider’s mass is much larger than the vehicle’s mass. Hence, the rider influences the dynamic behaviour of the bicycle not only by means of voluntary control actions, but also by means of passive response of his/her body to bicycle oscillations. As a mater of fact, the rider’s body has inertial, stiffness and damping properties that are combined with the bicycle characteristics and affect the dynamic response of the whole system. More specific, the stabilization of dangerous oscillatory two-wheeler modes such as weave and wobble can be significantly influenced by the rider’s properties. For these reason, it is prerequisite to identify the passive response of the rider’s body to study the dynamic behaviour of the combined bicycle-rider system.

To measure the rider response an instrumented bicycle mock up fitted with strain gauges at all interfaces has been developed. The frame was designed to recreate the geometry of a hybrid bicycle and has a reach to handlebars equal to 32 cm and a stack height to handlebars equal to 75cm. The bicycle mock up was mounted on a top of a hexapod and was excited using colored noise perturbations in all 6 degrees of freedom (DoF). The force response of the rider body was measured at all bicycle interfaces. Two IMU's were also used to measure the transmissibility of the upper rider trunk. One IMU was placed on the base of the platform and one at the rider's sternum. 

The repository contains the following folders and files:

PVA_signal contains mat.script to generate the applied perturbation signals. Force_data folder contains the rider's force responses at all bicycle interfaces. IMU_data and IMU_data_Upper trunk includes the measured translational accelerations and angular velocities of the platform and rider's upper trunk. Data_analysis apparent mass (APMS) and seat-to-sternum transmissibility (STST) folders includes the mat.scripts to obtain the tranfer functions (TRFs). The data analysis method is described at passive rider identification.docx. To plot the APMS transfer functions first run "interface_forces_24subs.m" (located in Force_Data folder) to obtain the required "force_signals_SI_t1_t2", afterwards copy paste the force_signals inside the analysis folder and run "TF_5_interfaces_24_subs.m" for the selected motion. Subjective data folder contains the NASA TLX data and mat.script. CAD folder contains the solidworks drawings of the bicycle mock up designed by Toni Prats for his Bsc thesis (read Passive Rider Impedance - Toni Prats.pdf). Test bike.vi is the NI LabVIEW software that was used for data logging the analog strain gauges signals. Calibration.xlsx and Voltage sign and locations.xlsx sheets contain the voltage/force equations and force sign conventions for all bicycle interfaces respectively. The ethnical folder contains the ethics and techical device inspection approval which is prerequisite from TU Delft for human factor research. 
