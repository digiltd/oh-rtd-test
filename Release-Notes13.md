# Release Notes of openHAB version 1.3

# openHAB Release 1.3

Version 1.3 includes many new features, improvements and bug fixes.

Here is a detailed list of what this release brings on top of the previous openHAB 1.2.

## New & Noteworthy

### Version 1.3.1

Shortly after the 1.3 release we decided to deliver the 1.3.1 bugfix release solving the following issues:

- Issue 395: Dropbox bundle failing to start/authenticate in v1.3
- Issue 426: modbus serial binding doesn't work in 1.3.0
- Issue 436: Order of Items displayed in the openhab.app and greent changed. Possibly a bug?
- Issue 439: Designer doesn't launch on Mac
- Issue 443: NikobusBinding item configurations not unregistered on .items file change
- Issue 444: openhab designer crashing while startup
- Issue 445: !EnOcean binding throws exceptions on Windows
- Issue 446: digitalSTROM binding doesn't work in 1.3.0
- Issue 452: Modified Configuration Files do not get reloaded
- Issue 458: HTTP proxy incorrectly handles http/https port in image URL

### Version 1.3.0

### = openHAB Runtime =

Major features:
- Issue 20: [[Systeminfo Binding|System Info Binding (for cpu/memory/system stats)]]
- Issue 78: [digitalSTROM Binding](digitalSTROMBinding)
- Issue 168: [[Piface Binding|Raspberry PI Binding (with PiFace)]]
- Issue 187: [[Squeezebox Binding|Squeezebox Binding]]
- Issue 207: [[Tinker Forge Binding|TinkerForge Binding]]
- Issue 210: Proxy for image and video widgets
- Issue 216: [[Onkyo Binding|Onkyo Binding]] for AV-Receivers
- Issue 258: [[Epson Projector Binding|Epson projector binding]]
- Issue 259: [[Nibe Heat Pump Binding|Nibe Heatpump Binding]]
- Issue 265: [ZWave Binding](ZWaveBinding)
- Issue 276: [Somfy URTSI II Binding](URTSIBinding)
- Issue 277: [MiLight Binding](milightBinding)
- Issue 281: [MQTT-Binding](MQTTBinding)
- Issue 287: [[Twitter Action|Twitter Action]]
- Issue 290: [[En Ocean Binding|EnOcean Binding]]
- Issue 296: [AVM Home Automation (AHA) Binding](FritzAHABinding)
- Issue 351: Make actions modular
- Issue 352: [[Comfo Air Binding|Zehnder ComfoAir Binding]]
- Issue 385: [[Nikobus Binding|Nikobus Binding]]
- Issue 392: [[Open Sprinkler|OpenSprinkler Binding]]

Enhancements:
- Issue 42: Allow caching of urls of in the HTTP binding
- Issue 107: Enhance SNMP-Binding (Out-Binding)
- Issue 177: Lower logging level of Plugwise Stick to DEBUG
- added further icons for the UIs
- Issue 230: Add item id to sql parameters
- Issue 291: Added possibility to specify a TTS device on Mac
- Issue 316: Change Dropbox' default Upload interval
- Issue 319: MPD Binding cannot connect to MPD server requiring a password
- Issue 326: A flag indicating if a sitemap widget with linked page have any children with linked pages
- Issue 327: Autoreconnect for KNX
- Issue 331: add favicon to openHAB Classic-UI
- Issue 336: TOGGLE command in REST API for switch and rollershutter items
- Several improvements in the [[Sonos Binding|Sonos Binding]]
- Homematic Binding: Implemented Sabotage, Unreach and Lowbat datapoints
- Added support of all item types for arithmetic group functions
- Added XBMC notification action
- sendHttp methods now have return type 'String' rather than 'void'
- Issue 240: mpd-Binding sends wrong Command.

Bugfixes:
- Issue 141: !ItemProvider and binding bundle startup synchronization
- Issue 188: Commands are sent twice in GreenT UI
- Issue 213: Hue binding should not send status updates for dimmer items on color temperature change
- Issue 243: Upgraded Smack XMPP library, fixing connection problems and a memory leak
- Issue 255: gTalk XMPP messages are bounced back as error and cause infinite loop
- Issue 263: No inital state reading for homematic devices after server restart
- Issue 278: rrd4j chart servlet throws exception on non-number items
- Issue 274: https (jetty) certificat seems to be old
- Issue 275: ClassCastException for window contacts in Homematic Binding
- Issue 297: Persistence: changedSince() gives false results
- Issue 301: nh-binding can not be used for String-Items
- Issue 311: Icons with a space in the name not displayed
- Issue 337: Dropbox filtering not working as expected
- Issue 365: Change default fritzbox.ip-value
- Issue 343: HABDroid/GreenT not displaying '$' in item strings properly
- Issue 347: RFXCOM binding dropping straight out of the read loop (on Windows) - i.e. not blocking
- Issue 346: Novelanheatpump item "state" shows NLS error message
- Issue 382: Ampersand causes problems in classic UI
- Issue 384: Logging persistence writing rows to the wrong log file
- Issue 397: Homematic Binding logs error when used with CCU2
- Issue 430: modbus serial binding crashes JVM if modbus master is disconnected
- Issue 433: Sonos binding polling thread is not started on startup
- Made color picker widget work offline

Removals:
- Please note that the Drools addon is not available in the 1.3 release. There is a good chance that it will come back in 1.4, for details please see [this thread](https://groups.google.com/d/msg/openhab/DB1AlyC9ooo/6Qhynv7syj4J).
- Please note, the Dropbox addon is not available in the 1.3 release because it is currently blocked by Issue 395. Please subscribe to this issue to be informed about the progress.

## Updating the openHAB runtime 1.2 to 1.3

If you have a running openHAB runtime 1.2 installation, you can easily update it to version 1.3 by following these steps:
1. Unzip the runtime 1.3 and all required addons to a new installation folder
1. Replace the folder "configurations" by the version from your 1.2 installation
1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)