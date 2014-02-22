openHAB is used in many different ways and areas of interest. In the remainder of this page you'll a list of projects (at least this known to use). This list will grow over time and should a good overview of what has been realised with openHAB.

Please help to complete this overview!

## Science / University

All students are facing the same problem while writing their Bachelor- or Masterthesis: they are lacking of time. openHAB helps them to focus on the really relevant parts of their work rather than "wasting" their time on implementing foundation/framework services.

### Intelligentes Energiemonitoring im SmartHome Kontext

University of Applied Sciences Cologne

#### Abstract / Description / Dates

#### Screenshots

#### How doid openHAB help

#### External links

#### Press links

http://www.verwaltung.fh-koeln.de/aktuelles/2013/08/verw_msg_06233.html


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


### SML House project

Universidad CEU Cardenal Herrera

#### Abstract / Description / Dates

#### Screenshots

#### How did openHAB help

#### External, Press, Video links

http://sdeurope.uch.ceu.es/2010/cms/sde/pages/en/intro/welcome.php?lang=EN


## Individuals

Collects projects being realised by individuals. We'd love to see little videos of your achievements with openHAB.

### <project name>
#### Abstract / Description / Dates
#### Screenshots
#### How did openHAB help
#### External, Press, Video links


## Companies

Collects projects being realised by companies. We'd love to see little videos of your achievements with openHAB.

### WESTAFLEX HVAC devices

#### Abstract / Description / Dates
Smaller and smarter, that’s OpenHAB. Not only will we be offering the best condo living into the future available, but our Smart House Technology Package will also include a custom mobile app that will remotely control your lighting, interior temperature and ventilation, blinds, in-suite alarm and music system, as well as a whole host of time-saving and utterly convenient lifestyle options. At the end you will have a smarted house each passing day by applying OpenHAB applications. It is compatible with almost any “legacy” remote device, turning traditional remote-control into smart control. Now there is the choice for older and disabled people to remain at home... And be happy!

All of the technology is present; we have seen homes with voice control, automated doors and window shades, presence and occupant detection, and smart objects linked to contextual controls. A major motivating factor has been the internet-connected smartphone which everyone sees as the central control point of their lives and have taken the HVAC industry by storm.

#### Screenshots
![HVAC devices](http://www.pinterest.com/pin/160229699214618095/)
![Maker Tools](http://www.pinterest.com/pin/160229699215541418/)
![Homeowner with WAC](http://www.pinterest.com/pin/160229699214349483/)
![Craftmen view](http://www.pinterest.com/pin/160229699214349477/)

#### How did openHAB help
A Modbus command contains the Modbus address of the device it is intended for. Only the intended device will act on the command. All Modbus commands contain checksum information, to ensure a command arrives undamaged. Since Modbus is a master/slave protocol, only Modbus TCP connects over port 502, as the Modbus ASCII protocol defines a message structure that controllers will recognize and use, regardless of the type of networks over which they communicate. Our WAC systems use default modbus data provided by Arduino barebones e.g. a Debian Rasberry server kit all year long. Binding is compatible with latest models since 2013 for Real-World Embedded Applications (M2M communication).

#### External, Press, Video links



### <project name>
#### Abstract / Description / Dates
#### Screenshots
#### How did openHAB help
#### External, Press, Video links
