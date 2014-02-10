Here is a detailed list of what this release brings on top of the previous openHAB 1.3.

## New & Noteworthy

### openHAB Runtime

**Major features:**
* [[INSTEON Hub binding|Insteon-Hub-Binding]] (#49, #401)
* [[MAX!Cube binding|MAX!Cube-Binding]] (#22)
* [[Netatmo binding|Netatmo-Binding]] (#30, #262)
* [[Pioneer AV receiver binding|Pioneer-AVR-Binding]] (#101)
* [[Heatmiser binding|Heatmiser-Binding]] (#97)
* Tivo binding (#59)
* [[HDAnywhere binding|HDanywhere-Binding]] (#806)
* [[Swegon ventilation binding|Swegon-Ventilation-Binding]] (#28)
* [[Open energy monitor binding|Open-Energy-Monitor-Binding]] (#599)
* [[MQTTitude binding for presence detection|Mqttitude-Binding]] (#19)
* [[CUL based bindings for FHT, FS20, Intertechno, EM and S300TH|CUL-Binding]] (#227, #735)
* [[OpenPaths presence detection binding|OpenPaths-Binding]] (#7, #14)
* [[Backend for CometVisu-UI|Comet-Visu]] (#6, #66)
* Provide deb files and APT Repository from maven build (#780)

**Enhancements:**
* Google calendar: Added support for "Private Address" URL without authentication (#833)
* Various Z-Wave Binding Enhancements (#98, #99, #607, #615, #661, #679, #690, #697, #700, #718, #724, #788, #798, #805, #825, #828)
* Various Koubach Binding Enhancements (#791, #793, #794)
* HTTP binding: Added DateTime item support (#790)
* Chart servlet updates (#785)
* Sitemap/UI enhancements (dynamic sitemaps / chart servlet) (#57)
* GreenT: Added chart servlet support and possibility to select used chart engine (chart or rrdchart) (#783)
* Reduced polling intervals to easy problems with ClassicUI on iOS (#746)
* Handle new encoding attribute of video widget in Classic UI (#744)
* Various Sonos binding fixes and improvements (#727)
* Various RFXCOM Binding Improvements (#9, #17, #617, #630, #660, #703, #741)
* Added item name to the executed command as the third string format argument for exec persistence binding (#605)
* [Habdroid] Improved URL handling (#512)
* Add support for new RGB-W bulbs to MiLight binding (#472)
* [Designer] Add "New File" button (#416)
* Support Contact and Switch in One Wire (#355, #824)
* TinkerforgeBinding enhancements (#103)
* Fritzbox Binding Enhancements (#95)
* Various Nibe heatpump binding improvements (#68, #102, #704)
* Improved performance of Hue Binding (#58, #377)
* Enhancements and bug fixes for Squeezebox binding/action (#56)
* Add mysql persistence service (#47)
* Modified "historicState" to return HistoricItem as per other extensions (#44)
* Added new action 'saySqueezebox' to allow announcements via Squeezebox devices (#42)
* NikobusBinding: added support for reading dim module values (#41)
* MQTT Binding: updated log levels and fixed bug in topic name matching (#32)
* Added retry logic to PiFace binding (#20)
* SNMP Binding improvement - include transformation on IN-binding (#16)
* XBMC Action improvement (#12)
* Rewritten TCP-UDP/IP bundle and configuration file (#1, #31)

**Bugfixes:**
* Rules are not deleted after Rulesfile is deleted (#610)
* Various Plugwise Binding fixes (#11, #456, #496, #497, #649, #810, #823)
* NPE in KNXBinding for unsupported datapoints (#774, #784)
* Tinkerforge Binding Bugfix reconnect and configuration (#764)
* Fix NPE if no zwave stick in the machine (#761)
* Various Twitter Binding fixes (#751, #769)
* Homematic: A short button press now updated the button state to OFF again (#743)
* Various Sonos binding fixes and improvements (#722)
* Translation problem for DTP 5.004 (#712)
* WebApp UI renders wrong (obsolete) label for active Groups (#706, #818)
* Binding nikobus - button config in documentation not working (#698)
* Problem with google calendar binding feed URL with query filter (#675, #745)
* Group items not updated (#673, #818)
* NPE with security=external (#669, #817)
* Homematic CCU2 Fix and other Updates (#616)
* Fix XMPP binding with google talk (#570)
* NullpointerException in org.io.transport.mqtt (#509)
* Homematic Binding crashes CCU2 BidCoS-RF (#504)
* Classic-UI: Only one Webview-Widget per page (#503)
* Habdroid discovery does not work with OH server on debian wheezy with IPV (#499)
* CUPS binding could not connect (#491)
* Various TCP/UDP binding fixes (#478, #482, #486)
* Invalid character in images filenames (#471)
* HTTP proxy incorrectly handles http/https port in image URL (#458)
* Modified Configuration Files do not get reloaded (#452)
* Systeminfo Binding not running on ARM architecture (#450)
* digitalSTROM binding doesn't start correctly (#446)
* openHAB Designer crashing while startup (#439, #444)
* NikobusBinding item configurations not unregistered on .items file change (#443)
* Sonos players not recognized depending on startup sequence (#442)
* Order of Items displayed in the openhab.app and greent changed (#436)
* Fix to include artwork parsing (#50)
* Fixed multiple call of processBindingConfiguration (#46)
* Fix for HTTP binding startup sequence bug (#36)
* Fix sequence of Quartz startup in configureBinding() (#27)

**Removals:**
* Removed version check (#747)
* Removed api analysis builder (#742)

**API changes**
* PersistenceExtensions.historicState() now returns an HistoricItem rather than a State object. Therefore any rules using this interface need to add .state to the end to replicate how it used to work. See ttps://groups.google.com/forum/#!topic/openhab/ZTwbhbwVqKM for more information.


## Updating the openHAB runtime 1.3 to 1.4

If you have a running openHAB runtime 1.3 installation, you can easily update it to version 1.4 by following these steps:
 1. Unzip the runtime 1.4 and all required addons to a new installation folder
 1. Replace the folder "configurations" by the version from your 1.3 installation
 1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)