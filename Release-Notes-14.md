_**please note these release notes are subject to change**_

Here is a detailed list of what this release brings on top of the previous openHAB 1.3.

## New & Noteworthy

### Version 1.4

### openHAB Runtime

**Major features:**
* #735, #227 - CUL based bindings for FHT, FS20, Intertechno, EM and S300TH 
* #607 - Zwave configuration GUI
* #401 - INSTEON Hub binding
* #66 - Backend for CometVisu-UI
* #57 - Sitemap/UI enhancements (dynamic sitemaps / chart servlet)

**Enhancements:**
* #746 - reduced polling intervals to easy problems with ClassicUI on iOS
* #744 - handle new encoding attribute of video widget in Classic UI
* #741 - many RFXCOM binding improvements
* #738 - Issue #374: added optional encoding attribute to video widget
* #727 - Many many Sonos binding fixes and improvements
* #724 - Zwave scene controller
* #721 - Mqttitude update - added support for upcoming 'region' feature in apps
* #700 - Zwave network functions
* #699 - MAX!Cube binding improvements
* #690 - ZWave wakeup - set wakeup parameters
* #512 - [Habdroid] URL handling 
* #474 - Update Atmosphere Framework
* #472 - Add support for new RGB-W bulbs to MiLight binding
* #448 - Make OpenHAB userfriendly to program (GUI) + device discovery
* #97 - Heatmiser binding added
* #47 - Add mysql persistence service
* #44 - Modified "historicState" to return HistoricItem as per other extensions
* #16 - SNMP Binding Update - include transformation on IN-binding

**Bugfixes:**
* #761 - Fix NPE if no zwave stick in the machine.
* #756 - MySQL persistence: use correct prefix in openhab_default.cfg
* #745 - Additional gcal query parameter (fix for #675)
* #743 - Homematic: A short button press now updated the button state to OFF again
* #675 - Problem with google calendar binding feed URL with query filter 
* #614 - Mysql error handling in event of failure to create table
* #610 - Rules are not deleted after Rulesfile is deleted 
* #570 - XMPP binding with google talk
* #509 - NullpointerException in org.io.transport.mqtt 
* #504 - Homematic Binding crashes CCU2 BidCoS-RF 
* #503 - Classic-UI: Only one Webview-Widget per page
* #499 - Habdroid discovery does not work with OH server on debian wheezy with IPV
* #491 - CUPS binding could not connect 
* #486 - TCP/UDP binding is not started
* #482 - TCP binding causes 100&#37; cpu load 
* #478 - TCP Binding high CPU utilisation
* #471 - Invalid character in images filenames 
* #458 - HTTP proxy incorrectly handles http/https port in image URL
* #456 - Plugwise Binding not working in openHAB 1.3
* #452 - Modified Configuration Files do not get reloaded
* #450 - systeminfo binding not running on ARM architecture
* #446 - digitalSTROM binding doesn't work in 1.3.0 b
* #444 - openhab designer crashing while startup 
* #443 - NikobusBinding item configurations not unregistered on .items file change
* #442 - Sonos players not recognized depending on startup sequence
* #439 - Designer doesn't launch on Mac
* #436- Order of Items displayed in the openhab.app and greent changed. Possibly a bug?
* #416 - [Designer] Add "New File" button

**Removals:**
* #747 - removed version check
* #742 - removed api analysis builder

## Updating the openHAB runtime 1.3 to 1.4

If you have a running openHAB runtime 1.3 installation, you can easily update it to version 1.4 by following these steps:
 1. Unzip the runtime 1.4 and all required addons to a new installation folder
 1. Replace the folder "configurations" by the version from your 1.3 installation
 1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)