openHAB is used in many different ways and areas of interest. In the remainder of this page you'll a list of projects (at least this known to use). This list will grow over time and should a good overview of what has been realised with openHAB.

Please help to complete this overview!

## Science / University

All students are facing the same problem while writing their Bachelor- or Masterthesis: they are lacking of time. openHAB helps them to focus on the really relevant parts of their work rather than "wasting" their time on implementing foundation/framework services.

### Intelligentes Energiemonitoring im SmartHome Kontext

University of Applied Sciences Cologne

#### Abstract / Description / Dates

#### Screenshots

#### How did openHAB help

#### External links

#### Press links

http://www.verwaltung.fh-koeln.de/aktuelles/2013/08/verw_msg_06233.html

***

### Connected Home Lab

TU Dortmund University - Communication Technology Institute

#### Abstract
For presentation and validation the Communication Technology Insitute realized the Connected Home Lab in 2013. Students can validate their project results in a appartement like environment. Futhermore proof-of-concept demonstrators show the results of research projects.

One major problem in the area of home automation and smart home is the number of different technologies, vendors and eco-systems. The usage of a middleware is necessary to provide uniform access to different ressources in a home network. 

OpenHAB offers a elaborated open source framework based on OSGI with commercially comparable UI and performance.

#### Screenshots
![](http://www.kt.e-technik.tu-dortmund.de/cms/Medienpool/forschung/projekte/living_lab/livinglab_foto3.jpg)
![Technologies utilized](http://www.kt.e-technik.tu-dortmund.de/cms/Medienpool/forschung/projekte/living_lab/livinglab_com.jpg)
![](http://www.kt.e-technik.tu-dortmund.de/cms/Medienpool/forschung/projekte/living_lab/livinglab.jpg)

#### How did openHAB help

OpenHAB has commercially comparable UI and performance. This is why, we can focus on the communication technology and use the "higher layers" without modification.
#### Contribution
##### FritzDECT
We implemented the fritzbox-aha binding. By communicating with the daemon running on the fritbox, we can control and monitor the FritzDECT sockets.
##### Homematic with CUL
We implemented the Homematic binding with the CUL-USB-Stick. Instead of relying on the CCU (HM central station), OpenHAB can communicate directly over a USB 868 MHz transceiver with HM devices.
##### wMBus binding
Smart Home system will be integrated with Smart Grid applications in the future. Currently, smart meters with wMBus interface are rolled out in Germany. We implemented a wMBus binding, which communicates over a serial interface with a 868 MHz transceiver. With the correct serial number of the smart meter, the encrypted packets sent periodically (1 min - 10 min) can be received. This way, the energy consumption of the houshold can be monitored with OpenHAB.
#### External, Press, Video links
http://www.kt.e-technik.tu-dortmund.de/cms/de/forschung/Laufende_Projekte/Connected_Home_Lab/index.html

***

### SML House project

Universidad CEU Cardenal Herrera

#### Abstract / Description / Dates

#### Screenshots

#### How did openHAB help

#### External, Press, Video links

http://sdeurope.uch.ceu.es/2010/cms/sde/pages/en/intro/welcome.php?lang=EN

***

## Individuals

Collects projects being realised by individuals. We'd love to see little videos of your achievements with openHAB.

### <project name>
#### Abstract / Description / Dates
#### Screenshots
#### How did openHAB help
#### External, Press, Video links

***

## Companies

Collects projects being realised by companies. We'd love to see little videos of your achievements with openHAB.

### New HVAC devices (@Westaflex)

#### Abstract / Description / Dates
We have spent over a year on the project and have accomplished a lot. We've already captured many openHAB features and concepts like the configuration of dynamics of the process (lag time, dead time, etc), as well as trend, monitor and update register values in a Modbus PLC or other device supporting the Modbus/TCP protocol. It currently supports profiles for different devices so you can configure multiple devices or multiple views of the same device. These ranges from core application elements like the tuning contants which can be automatically derived for self-regulating 1st order processes to added noise (uniformly distributed or Gaussian) to the process. At first our Binding only worked with the words from %MW0 to %MW65535 !!! and Dword %DW0 to %DW32767 data type signed and unsigned 16/32 bit integer and 32 bit float. 

#### Screenshots
![](http://media-cache-ec0.pinimg.com/originals/d8/ad/e5/d8ade547f4349a6d1f13e65503ed368c.jpg)
![](http://media-cache-ec0.pinimg.com/originals/5b/aa/2b/5baa2b67f1882964562b6024ef133846.jpg)

#### How did openHAB help
We could soon establish a Demo of intelligent house functionality at first able to work with any device supporting Modbus IP/RTU, Modbus RTU with bluetooth. This HVAC environment takes measurements of a number of temperature values within the house, controls lighting, door mechanisms and received a live video feed from an in-house video camera. The system was created with the purpose of demonstrating the experience of our development team to convert low-level operating and control protocols (CAN bus, ModBus) into the user-friendly higher-level openHAB Binding. Westaflex offers the full range of system, Linux and embedded software development services. Our WAC systems use default modbus data provided by Arduino barebones e.g. a Debian Rasberry server kit all year long.

Thanks to openHAB our WAC Binding already had a solid backend for communication b/n devices that simulates a MODBUS/TCP client, saves and retrieves connection settings (profiles), as well as the creation of custom data lists (hmi-like) and how they interact. This let us READ and WRITE data from field instrument thro' MODBUS interface. Because of its open transparent RESTful web service Interface the Binding was easily implemented into our existing automation solutions.
#### Credits
We believe we have successfully delivered this openHAB project with our expertise in software engineering, agile methods, quality assurance and most importantly, our passion of making the world a better place. 

#### External, Press, Video links
http://data.fir.de/projektseiten/win-d/openHAB

***

### <project name>
#### Abstract / Description / Dates
#### Screenshots
#### How did openHAB help
#### External, Press, Video links

***