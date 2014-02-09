Here is a detailed list of what this release brings on top of the previous openHAB 1.3.

## New & Noteworthy

### openHAB Runtime

**Major features:**
* #806 - HDAnywhere binding
* #780 - Provide deb files and APT Repository from maven build
* #599 - [[Open energy monitor binding|Open-Energy-Monitor-Binding]]
* #227, #735 - [[CUL based bindings for FHT, FS20, Intertechno, EM and S300TH|CUL-Binding]]
* #101 - [[Pioneer AV receiver binding|Pioneer-AVR-Binding]]
* #97 - [[Heatmiser binding|Heatmiser-Binding]]
* #59 - Tivo binding
* #49, #401 - [[INSTEON Hub binding|Insteon-Hub-Binding]]
* #30, #262 - [[Netatmo binding|Netatmo-Binding]]
* #28 - [[Swegon ventilation binding|Swegon-Ventilation-Binding]]
* #22 - [[MAX!Cube binding|MAX!Cube-Binding]]
* #19 - [[MQTTitude binding for presence detection|Mqttitude-Binding]]
* #7, #14 - OpenPaths presence detection binding
* #6, #66 - [[Backend for CometVisu-UI|Comet-Visu]]

**Enhancements:**
* #833 - Google calendar: Added support for "Private Address" URL without authentication
* #828 - Add controller type/id/manufacturer to node
* #827 - Standardise logging to allow identification of entries relating to a specific node
* #825 - Added Fibaro FG-RGBW controller (thanks Surendra)
* #805 - Add initial Aeon MES to product database (no configuration parameters as data not available)
* #798 - Updated Aeon labs door/window sensor config file
* #794 - Koubachi binding: implement care actions enhancement
* #793 - Koubachi binding: add missing properties from "plants"
* #791 - Koubachi binding: prevent exception when response contains null value
* #790 - HTTP binding: Added DateTime item support
* #788 - Changed multilevel switch stop command
* #785 - Chart servlet updates
* #783 - GreenT: Added chart servlet support and possibility to select used chart engine (chart or rrdchart)
* #746 - reduced polling intervals to easy problems with ClassicUI on iOS
* #744 - handle new encoding attribute of video widget in Classic UI
* #727 - Sonos binding fixes and improvements
* #724 - Zwave scene controller
* #718 - Zwave wakeup
* #700 - Zwave network functions
* #697 - Implement SWITCH_MULTILEVEL_STOP_LEVEL_CHANGE handling for multilevel switches
* #690 - ZWave wakeup - set wakeup parameters
* #679 - Added support to ZWave binding for RollershutterItems
* #661 - ZWAVE Update serialisation folder to only use the major/minor part of the version
* #655 - Maxcube Binding updates to allow sending of updates to Cube
* #617, #630, #660, #703, #741 - RFXCOM binding improvements
* #615 - Z-Wave THERMOSTAT_SETPOINT command class implementation
* #607 - Zwave configuration GUI
* #605 - added item name to the executed command as the third string format argument for exec persistence binding
* #512 - [Habdroid] URL handling 
* #474 - Update Atmosphere Framework
* #472 - Add support for new RGB-W bulbs to MiLight binding
* #448 - Make OpenHAB userfriendly to program (GUI) + device discovery
* #416 - [Designer] Add "New File" button
* #374, #738 - added optional encoding attribute to video widget
* #355, #824 Support Contact and Switch in One Wire
* #103 - TinkerforgeBinding enhancements
* #98 - Improved logging when unsupported command class encountered.
* #95 - Enhanced Fritzbox Binding
* #68, #102, #704 - Nibe heatpump binding improvements
* #58, #377 - Improved performance of hue binding
* #57 - Sitemap/UI enhancements (dynamic sitemaps / chart servlet)
* #56 - Enhancements and bug fixes for Squeezebox binding/action
* #47 - Add mysql persistence service
* #44 - Modified "historicState" to return HistoricItem as per other extensions
* #42 - Added new action 'saySqueezebox' to allow announcements via Squeezebox devices
* #41 - NikobusBinding: added support for reading dim module values
* #32 - MQTT Binding: updated log levels and fixed bug in topic name matching
* #31 - TCP/UDP binding - Make good "citizen" + Fix Issue #478 (High CPU Load)
* #20 - Added retry logic to PiFace binding
* #17 - Rfxcom lighting5 and humidity update
* #16 - SNMP Binding Update - include transformation on IN-binding
* #12 - XBMC action enhanced
* #9 - Addition of Rfxcom lighting5 message and other minor updates
* #1 - Rewritten TCP-UDP/IP bundle and configuration file

**Bugfixes:**
* #835 - Fix error in log causing formatting exception
* #823 - Various Plugwise fixes
* #774, #784 - NPE in KNXBinding for unsupported datapoints
* #764 - Tinkerforge Binding Bugfix reconnect and configuration
* #761 - Fix NPE if no zwave stick in the machine.
* #756 - MySQL persistence: use correct prefix in openhab_default.cfg
* #751, #769 Twitter Binding Problem
* #743 - Homematic: A short button press now updated the button state to OFF again
* #722 - Various Sonos binding fixes and improvements
* #712 - Translation problem for DTP 5.004
* #710, #814 - Fix problem with mysql string length (See #710)
* #706, #818 - WebApp UI renders wrong (obsolete) label for active Groups (withFIX) 
* #698 - binding nikobus - button config in documentation not working
* #675, #745 - Problem with google calendar binding feed URL with query filter 
* #673, #818 - Group items not updated in 1.4
* #669, #817 - NPE with security=external
* #649, #810 - Plugwise - Pace ZigBeen network load
* #616 - Homematic CCU2 Fix and other Updates
* #614 - Mysql error handling in event of failure to create table
* #610 - Rules are not deleted after Rulesfile is deleted 
* #570 - XMPP binding with google talk
* #509 - NullpointerException in org.io.transport.mqtt 
* #504 - Homematic Binding crashes CCU2 BidCoS-RF 
* #503 - Classic-UI: Only one Webview-Widget per page
* #499 - Habdroid discovery does not work with OH server on debian wheezy with IPV
* #497, #810 - Plugwise binding sometimes returning wrong values for currernt power usage
* #496, #810 - Plugwise initiatlisation fails at first run 
* #491 - CUPS binding could not connect 
* #486 - TCP/UDP binding is not started
* #478, #482 - TCP Binding high CPU utilisation
* #471 - Invalid character in images filenames 
* #458 - HTTP proxy incorrectly handles http/https port in image URL
* #452 - Modified Configuration Files do not get reloaded
* #450 - systeminfo binding not running on ARM architecture
* #446 - digitalSTROM binding doesn't work in 1.3.0 b
* #444 - openhab designer crashing while startup 
* #443 - NikobusBinding item configurations not unregistered on .items file change
* #442 - Sonos players not recognized depending on startup sequence
* #439 - Designer doesn't launch on Mac
* #436- Order of Items displayed in the openhab.app and greent changed. Possibly a bug?
* #99 - Bugfix: Z-Wave binding: access to the output stream without synchronisation
* #50 - Fix to include artwork parsing.
* #46 - Fixed multiple call of processBindingConfiguration
* #36 - Fix for HTTP binding startup sequence bug
* #27 - Fix sequence of Quartz startup in configureBinding()
* #11, #456 - Plugwise Binding not working in openHAB 1.3

**Removals:**
* #747 - removed version check
* #742 - removed api analysis builder

## Updating the openHAB runtime 1.3 to 1.4

If you have a running openHAB runtime 1.3 installation, you can easily update it to version 1.4 by following these steps:
 1. Unzip the runtime 1.4 and all required addons to a new installation folder
 1. Replace the folder "configurations" by the version from your 1.3 installation
 1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)