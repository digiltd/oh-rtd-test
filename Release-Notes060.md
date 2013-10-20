# Release Notes of openHAB version 0.6.0

# openHAB Release 0.6.0

Version 0.6.0 comes with many new features and bug fixes. Please read the 'New & Noteworthy' section for details.

## New & Noteworthy

- replaced 'server/dropins' folder by 'addons' folder. Its content is automatically added to the openHAB runtime through Felix !FileInstall and all bundles get automatically started.
- added AJAX-support to the !WebAppUI, so that this now automatically updates the current page, if some item status changes.
- the WebAppUI now also supports Firefox
- the WebAppUI can now be put nicely on the iPhone home screen
- added increase/decrease command type for dimmers or volume control
- added Prowl support in rules
- added volume control support in rules for the hosts sound system
- added the [[One Wire Binding|1-Wire binding]]
- added the [[Network Health Binding|Network health binding]]
- added the [Wake-on-LAN binding](WoLBinding)
- added the [[Exec Binding|Execution binding]]
- added the [[Http Binding|HTTP binding]]
- finalized the [[Bluetooth Binding|Bluetooth binding]]
- added a new "button" mode for switch widgets
- added the new widget type "selection" for the WebAppUI