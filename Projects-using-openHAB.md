openHAB is used in many different ways and areas of interest. In the remainder of this page you'll a list of projects (at least this known to use). This list will grow over time and should a good overview of what has been realised with openHAB.

Please help to complete this overview!

* [[Universities using openHAB|Projects-using-openHAB:-Science-and-University]]
* [[Individuals using openHAB|Projects-using-openHAB:-Individuals]]

## Companies

Collects projects being realised by companies. We'd love to see little videos of your achievements with openHAB.

### New HVAC devices (@Westaflex)

#### Abstract / Description / Dates
We have spent over a year on the project and have accomplished a lot. We've already captured many OpenHAB features and concepts like the configuration of dynamics of the process (lag time, dead time, etc), as well as trend, monitor and update register values in a Modbus PLC or other device supporting the Modbus/TCP protocol. It currently supports profiles for different devices so you can configure multiple devices or multiple views of the same device. These ranges from core application elements like the tuning contants which can be automatically derived for self-regulating 1st order processes to added noise (uniformly distributed or Gaussian) to the process. At first our Binding only worked with the words from %MW0 to %MW65535 !!! and Dword %DW0 to %DW32767 data type signed and unsigned 16/32 bit integer and 32 bit float. 

#### Screenshots
![HVAC devices](http://www.pinterest.com/pin/160229699216460430/)
![Maker Tools](http://www.pinterest.com/pin/160229699215541418/)
![Homeowner with WAC](http://www.pinterest.com/pin/160229699214349483/)
![Craftmen view](http://www.pinterest.com/pin/160229699214349477/)

#### How did openHAB help
We could soon establish a Demo of intelligent house functionality at first able to work with any device supporting Modbus IP/RTU, Modbus RTU with bluetooth. This HVAC environment takes measurements of a number of temperature values within the house, controls lighting, door mechanisms and received a live video feed from an in-house video camera. The system was created with the purpose of demonstrating the experience of our development team to convert low-level operating and control protocols (CAN bus, ModBus) into the user-friendly higher-level OpenHAB Binding. Westaflex offers the full range of system, Linux and embedded software development services. Our WAC systems use default modbus data provided by Arduino barebones e.g. a Debian Rasberry server kit all year long.

Thanks to OpenHAB our WAC Binding already had a solid backend for communication b/n devices that simulates a MODBUS/TCP client, saves and retrieves connection settings (profiles), as well as the creation of custom data lists (hmi-like) and how they interact. This let us READ and WRITE data from field instrument thro' MODBUS interface. Because of its open transparent RESTful web service Interface the Binding was easily implemented into our existing automation solutions.
#### Credits
We believe we have successfully delivered this OpenHAB project with our expertise in software engineering, agile methods, quality assurance and most importantly, our passion of making the world a better place. 

#### External, Press, Video links
http://data.fir.de/projektseiten/win-d/

***

### <project name>
#### Abstract / Description / Dates
#### Screenshots
#### How did openHAB help
#### External, Press, Video links

***