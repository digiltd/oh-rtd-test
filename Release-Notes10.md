# Release Notes of openHAB version 1.0

# openHAB Release 1.0

Version 1.0 includes many new features, improvements and bug fixes.

Here is a detailed list of what this release brings on top of the previous openHAB 0.9.1:

## New & Noteworthy

### Version 1.0.0

Major features:
- native Andoid client available - [HABDroid](http://code.google.com/p/openhab/wiki/HABDroid)!
- new [Persistence support](http://code.google.com/p/openhab/wiki/Persistence) is available with implementations of db4o, rrd4j, Open.Sen.se and Logback logging
- Server-side [chart support through rrd4j](http://code.google.com/p/openhab/wiki/Charts) including a new Chart widget for the UIs
- Image widget now supports automatic refreshs
- new Video widget for video streams
- new Setpoint widget to easily allow numeric item adjustments
- new Webview widget for integration of external content
- Issue 70: Bonjour/MDNS discovery support
- Support for timers, i.e. the possibility to schedule the execution of a block of code for a later point in time from within scripts or rules
- Issue 37: Presence Simulation
- new [ConfigAdmin binding](http://code.google.com/p/openhab/wiki/ConfigAdminBinding)
- new [Dropbox bundle](http://code.google.com/p/openhab/wiki/DropboxIOBundle)
- new [Novelan Heatpump Binding](http://code.google.com/p/openhab/wiki/NovelanHeatPumpBinding) (thanks to Philipp Bolle for this contribution)

Enhancements:
- Fritzbox binding now refreshes its connection every night, so that it recovers from blocked sockets
- KNX response timeout is now configurable
- upgraded target platform to Juno (4.2)
- upgraded build to Tycho 0.15.0
- Group items can now contain items from different sources (e.g. different items files)
- added new rule action to store and restore item states in a rule context
- added NAND and NOR group functions to calculate group item states
- added HTTP PUT and DELETE rule actions and enhanced API to support sending content and contentType
- KNX read requests are now resent (a configurable number of times) after timeout
- added Jodatime to script/rule language to allow powerful data/time calculations
- Mail action now supports popBeforeSmtp
- Issue 81: openHAB instance generates a unique ID during first launch
- Issue 82: Access to openHAB version for client APPs
- Issue 86: Extend HttpBinding to support numeric commands (eg. !PercentType for !RollerShutter)
- Issue 88: SNMP: implementing handling for numbers
- Issue 62: Support streaming mode in the REST API for item/widget status changes
- KNX data types for electric current and brightness are now supported
- added new !LogAction to log to the "normal" log files in rules/scripts
- added new Ping Action which allows to check the vitality of given hosts in rules/scripts
- removed demo files from runtime zip and provided an additional demo zip
- XMPPConnection now provides a proxy configuration to support GTalk properly (thanks to Phillip Bolle for this contribution)