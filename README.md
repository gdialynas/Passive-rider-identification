# Instrumented bicycle mock up

In bicycles the rider’s mass is much larger than the vehicle’s mass. Hence, the rider influences the dynamic behaviour of the bicycle not only by means of voluntary control actions, but also by means of passive response of his/her body to bicycle oscillations. As a mater of fact, the rider’s body has inertial, stiffness and damping properties that are combined with the bicycle characteristics and affect the dynamic response of the whole system. More specific, the stabilization of dangerous oscillatory two-wheeler modes such as weave and wobble can be significantly influenced by the rider’s properties. For these reason, it is prerequisite to identify the passive response of the rider’s body to study the dynamic behaviour of the combined bicycle-rider system.

To measure the rider response an instrumented bicycle mock up fitted with strain gauges at all interfaces has been developed. The frame is designed to recreate the geometry of a hybrid bicycle and has a reach to handlebars equal to 32 cm and a stack height to handlebars equal to 75cm. The bicycle mock up is mounted on a top of a hexapod and is excited using multisinus perturbations. In addition to the force response of the rider body two IMU's are also used to track the motion of the upper torso of the rider. One IMU is placed under the seat and one at the rider's sternum. 

The repository contains the following folders:

CAD folder contains the solidworks drawings of the bicycle mock up. Test bike.vi is the NI LabVIEW software used to analyze the analog signals of the strain gauges. Calibration.xlsx sheet contains the equations to transform  the analog voltage of the strain gauges to forces.  Voltage sign and locations.xlsx contains the voltage direction based on the bicycle reference frame. The combination of the aforementioned xlsx folders can be used to calculate the magnitude and sign of the applied handlebar forces. Test bike.vi is the NI LabVIEW software used to analyze the analog signals of the strain gauges.

Data folder contains two type of files xlsx and mtb. Mtb files are logged from Xsens software and contain data coming from the IMU's. The mtb files are also saved as xlsx. The bike IMU xlsx files contain data from under the seat and sternum of the rider's torso. offset.xlsx folder contain the static forces applied to the bicycle before the perturbation starts. The percentage name in the xlsx sheet indicates the power reduction from the initial perturbation signal. The goal of the data collection was to test the fuctionality of the strain gauges and also to evaluate the rider response for the given multisinus perturbation signal. The signal design script is in the matlab folder. The same signals design approach adopted from Van Drunen https://link.springer.com/article/10.1007/s00221-014-4151-2 are also used herein.

The ethnical folder contains the ethics application and approval report and techical device description and inspection approval which is prerequisite from TU Delft in order to proceed with Human-in-the-loop experiments. 






 
