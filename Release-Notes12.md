# Release Notes of openHAB version 1.2

# openHAB Release 1.2

Version 1.2 includes many new features, improvements and bug fixes.

Here is a detailed list of what this release brings on top of the previous openHAB 1.1:

## New & Noteworthy

### Version 1.2.0

### = openHAB Runtime =

Major features:
- added new [[Homematic Binding|Homematic binding]] - thanks to Thomas (L.) for this contribution!
- added new [[Hue Binding|Philips Hue binding]] - thanks to Roman for this contribution!
- Issue 91: added new color item and colorpicker widget with support in Classic UI and HABDroid
- Issue 234: added new [[Pulseaudio Binding|Pulseaudio Binding]] - thanks to Tobias for this contribution!
- Issue 152: added new [Samsung TV binding](SamsungTVBinding) - thanks to Pauli for this contribution!
- Issue 19: added new [DMX512 binding](DMXBinding) - thanks to Davy for this contribution!
- Issue 158: added new [[Koubachi Binding|Koubachi binding]]

Enhancements:
- Issue 165: Make RRD4J persistence service queryable
- simplified interfaces for implementing new bindings
- created Maven Archetype to simply implementation of new bindings (see [Binding HowTo](HowToImplementABinding))
- Issue 186: Enhancement of start.sh and start_debug.sh
- Issue 194: Support for Date Java Formatter on the URL itself in the HTTP Binding
- support "in" direction for the Exec Binding
- Issue 155: HABDroid changed pictures aren't reloaded
- Issue 190: HABDroid is now available through CI build (see https://openhab.ci.cloudbees.com/job/HABDroid/)
- upgraded calimero lib 3.2.1 which now supports DPTs of type `13.**` and `14.**` (Issue 181, Issue 200)
- created [calimero fork](https://github.com/openhab/calimero) and integrated it into our [daily build](https://openhab.ci.cloudbees.com/job/calimero-core/)
- added some new images
- Issue 218: Filename swapped for sockets status
- dynamically created slider widgets now have "switchSupport" enabled by default

Bugfixes:
- Issue 226: XMPP: Not connected to server
- Fixed IHC binding startup problem
- Fixed bug when calculating historicState in persistence action
- Issue 193: HABDroid: Page jump when values are changed
- Issue 132: KNX Status group address does not work as expected
- Issue 126: Footer of web UI disappears after switch update
- Group item state is now derived from all members, not only direct ones
- Issue 205: REST API fails to return sitemap when name inside file is different from filename
- Issue 206: Synchronization problem in !ItemProvider
- Issue 208: Harden up Bindings Framework Code
- added workaround for !FritzBox binding when receiving subsequent events
- fixed bug with refreshing home page through early returning long-polling REST requests
- Issue 171: Loading model resources sometimes throws exceptions
- Issue 185: db4o Persistence: Warning if restoreOnStartup is activated
- Issue 228: db4o & restoreOnStartup doesn't work

### = openHAB !AddOns 1.2.1 =

Bugfixes:
- fixed invalid !KoubachiActivator in [[Koubachi Binding|Koubachi binding]]

### = HABDroid =

- HABDroid will be published to Google Play Store along with openHAB 1.2.0 release!
- Improved startup sequence - much faster and more convenient
- Improved Settings menu - shows current settings values
- Demo mode is now a separate setting - no more need to type in demo url manually, switched on by default
- Added support for Color item/widget with colour picker to select colour
- Added support for NFC tags - you can write any of sitemap pages to a tag and have fast access to it by just reading the NFC tag or write an item command and automatically send it to the item with an NFC tag touch
- Support for selecting HABDroid theme - a regular Holo.Dark and new Holo.Light
- Sitemap navigation now remembers position in previous sitemap pages
- Many stability improvements and bug fixes
- Automatic anonymous crash reporting to developers - much faster bug fixing!


## Updating the openHAB runtime 1.1 to 1.2

If you have a running openHAB runtime 1.1 installation, you can easily update it to version 1.2 by following these steps:
1. Unzip the runtime 1.2 and all required addons to a new installation folder
1. Replace the folder "configurations" by the version from your 1.1 installation, but please keep "logback.xml" from the 1.2 release (or merge your changes, if you have modified it).
1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)