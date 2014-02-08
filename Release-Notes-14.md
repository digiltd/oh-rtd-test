_**please note these release notes are subject to change**_

Here is a detailed list of what this release brings on top of the previous openHAB 1.3.

## New & Noteworthy

### Version 1.4

### openHAB Runtime

**Major features:**
* #806 - Initial commit of the HDanywhere binding
* #599 - Open energy monitor binding
* #227, #735 - CUL based bindings for FHT, FS20, Intertechno, EM and S300TH 
* #101 - initial revision of the binding for pioneer AV receivers
* #97 - Heatmiser binding added
* #59 - Initial commit of a Tivo binding for openHAB
* #49, #401 - INSTEON Hub binding
* #30, #262 - Initial commit of Netatmo binding
* #28 - Swegon ventilation system binding
* #22 - added MAX!Cube binding
* #19 - Implemented new Mqttitude binding for presence detection
* #7, #14 - Added OpenPaths presence detection binding
* #6, #66 - Backend for CometVisu-UI

**Enhancements:**
* #833 - Google calendar: Added support for "Private Address" URL without authentication
* #828 - Add controller type/id/manufacturer to node
* #827 - Standardise logging to allow identification of entries relating to a specific node
* #825 - Added Fibaro FG-RGBW controller (thanks Surendra)
* #813 - used name variable instead of fixed name for deb.desc and used formatter
* #805 - Add initial Aeon MES to product database (no configuration parameters as data not available)
* #800 - CometVisu-Binding: improved implementation of the BroadcasterCache
* #798 - Updated Aeon labs door/window sensor config file
* #794 - Koubachi binding: implement care actions enhancement
* #793 - Koubachi binding: add missing properties from "plants"
* #792 - Fix typos and javadoc errors
* #791 - Koubachi binding: prevent exception when response contains null value
* #790 - HTTP binding: Added DateTime item support
* #788 - Changed multilevel switch stop command
* #785 - Chart servlet updates
* #783 - GreenT: Added chart servlet support and possibility to select used chart engine (chart or rrdchart)
* #780 - deb files and apt repository from maven build
* #748 - MAX!Cube gateway discovery
* #746 - reduced polling intervals to easy problems with ClassicUI on iOS
* #744 - handle new encoding attribute of video widget in Classic UI
* #741 - many RFXCOM binding improvements
* #727 - Many many Sonos binding fixes and improvements
* #724 - Zwave scene controller
* #721 - Mqttitude update - added support for upcoming 'region' feature in apps
* #718 - Zwave wakeup
* #704 - Nibe heatpump binding gw fixes
* #703 - RFXCOM binding changes
* #700 - Zwave network functions
* #699 - MAX!Cube binding improvements
* #697 - Implement SWITCH_MULTILEVEL_STOP_LEVEL_CHANGE handling for multilevel switches
* #690 - ZWave wakeup - set wakeup parameters
* #679 - Added support to ZWave binding for RollershutterItems
* #661 - ZWAVE Update serialisation folder to only use the major/minor part of the version
* #660 - RFXCOM binding: refactoring
* #655 - Maxcube Binding updates to allow sending of updates to Cube
* #650 - MAX!Cube binding improvements
* #630 - Rfxcom binding improvements
* #617 - Additions to RFXcom Binding
* #615 - Z-Wave THERMOSTAT_SETPOINT command class implementation
* #607 - Zwave configuration GUI
* #605 - added item name to the executed command as the third string format argument for exec persistence binding
* #512 - [Habdroid] URL handling 
* #474 - Update Atmosphere Framework
* #472 - Add support for new RGB-W bulbs to MiLight binding
* #448 - Make OpenHAB userfriendly to program (GUI) + device discovery
* #374, #738 - added optional encoding attribute to video widget
* #355, #824 Support Contact and Switch in One Wire
* #103 - TinkerforgeBinding enhancements
* #102 - Nibe heat pump binding: Fixed and improved data parsing
* #98 - Improved logging when unsupported command class encountered.
* #95 - Enhanced Fritzbox Binding
* #68 - Nibe heatpump binding improvements
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
* #823 - Plugwise fixes (see email on mailing list)
* #822 - fix class path files of knx, netatmo and openenergymonitor projects
* #774, #784 - NPE in KNXBinding for unsupported datapoints
* #764 - TinkerforgeBinding Bugfix reconnect and configuration
* #761 - Fix NPE if no zwave stick in the machine.
* #760 - Fix String Encoding for Intertechno Addresses
* #756 - MySQL persistence: use correct prefix in openhab_default.cfg
* #751, #769 Twitter Binding Problem
* #745 - Additional gcal query parameter (fix for #675)
* #743 - Homematic: A short button press now updated the button state to OFF again
* #722 - Various Sonos binding fixes and improvements
* #712 - Translation problem for DTP 5.004
* #710, #814 - Fix problem with mysql string length (See #710)
* #706, #818 - WebApp UI renders wrong (obsolete) label for active Groups (withFIX) 
* #698 - binding nikobus - button config in documentation not working
* #675 - Problem with google calendar binding feed URL with query filter 
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
* #482 - TCP binding causes 100&#37; cpu load 
* #478 - TCP Binding high CPU utilisation
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
* #416 - [Designer] Add "New File" button
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