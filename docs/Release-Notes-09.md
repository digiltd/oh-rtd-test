# Release Notes of openHAB version 0.9

# openHAB Release 0.9

Version 0.9 has many new features, improvements and bug fixes.

Here is what is included in this release:

## New & Noteworthy

### Version 0.9.1

- improved icon and label of [uninitialized items](http://code.google.com/p/openhab/issues/detail?id=63)
- improved type comparison possibilities in rules and scripts
- improved logged error messages of script and rule execution problems
- fixed bug with sensor-id in !OneWire binding
- added automatic archiving of log files
- added timeout handling to Prowl action
- fixed problem of  [accessing the changed property](http://code.google.com/p/openhab/issues/detail?id=73) in Drools
- added configurable "autoupdate" binding as a replacement of the ItemUpdater mechanism
- added http post request action
- fixed [problem with suspended REST requests](http://code.google.com/p/openhab/issues/detail?id=66)
- Sencha Touch UI: updated to the latest Sencha Touch 2.0 nighty build (increased stability and many major bug fixes)
- Sencha Touch UI: fixed a CSS style for phone mode group items
- Sencha Touch UI: smaller widget heights in phone mode
- Sencha Touch UI: added an option to disable transition animations (good for low-end devices)
- Sencha Touch UI: Made the app splash screens work
- Sencha Touch UI: Many tweaks for bettering the user experience

### Version 0.9.0

- added possibility to create [[Scripts|user-defined scripts]], which can be used within rules and consoles (OSGi, Google-Calendar, XMPP).
- added a [[Rules|new highly-integrated rule engine]] with a very easy to use editor
- added a native iOS client, [available on the AppStore](http://itunes.apple.com/us/app/openhab/id492054521?mt=8) (thanks to Pablo Romeu for the contribution!)
- added a preview version of an !SenchaTouch-based UI (thanks to Mihail Panayotov for the contribution!)
- added a [VDR binding](http://code.google.com/p/openhab/wiki/VDRBinding) (thanks to Wolfgang Willinghöfer for the contribution!)
- added an [Asterisk binding](http://code.google.com/p/openhab/wiki/AsteriskBinding)
- added a [SNMP binding](http://code.google.com/p/openhab/wiki/SnmpBinding)
- added security features: [SSL and user authentication](http://code.google.com/p/openhab/wiki/Security)
- REST-API: [Server-push support](http://code.google.com/p/openhab/issues/detail?id=46) through Atmosphere framework (thanks to Oliver Mazur for the contribution!)
- REST-API: [jsonp support for all URIs](http://code.google.com/p/openhab/issues/detail?id=52)
- REST-API: media type can be requested [through query parameters](http://code.google.com/p/openhab/issues/detail?id=55)
- REST-API: single pages are now served without the [details of the sub-pages](http://code.google.com/p/openhab/issues/detail?id=54)
- added support for KNX scenes
- added support for sub-pages on image widgets
- made Drools an [[Drools|optional add-on]]
- made FreeTTS an optional add-on
- shrinked the runtime zip from 55MB to 35MB
- renamed command "speak" to "say"
- updated quartz library to version 2.1.1
- fixed bugs in 1Wire binding
- fixed bugs in MPD binding
- speeded up sitemap loading at startup
- GCal downloader now handles quoted strings correctly
- improved logging levels
- simplified [IDE setup for contributors](http://code.google.com/p/openhab/wiki/IDESetup) by using Yoxos
- made a new demo server available at http://demo.openhab.org