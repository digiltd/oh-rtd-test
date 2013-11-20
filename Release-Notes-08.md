# Release Notes of openHAB version 0.8

# openHAB Release 0.8

Version 0.8 comes with many new features and bug fixes.

Here is what has been implemented in this release:

## New & Noteworthy

### Version 0.8.0

- added new MAP transformation service to allow easy customization of item status texts (see [issue 26](https://github.com/openhab/openhab/issues#issue/26))
- added {{{DateTimeItem/Type}}} to support date and time values in items
- added [[Ntp Binding|NTP binding]] to retrieve current time from external servers
- [bug fix](http://code.google.com/p/openhab/source/detail?r=caf6fc5518d8ed382511ba90bea1d5e25a5dbbc2) for crashing background services
- added connection type [ROUTER](http://code.google.com/p/openhab/source/detail?r=4999dcd9ceaf3e891364dc7d4a80d80ed7efc8dc) to KNXConnection
- added action to call transformation services from within rules
- added text-to-speech functionality with a 100% pure Java implementation (based on FreeTTS) and a native Mac OSX implementation.
- Speaker volume control is now possible on Mac OSX as well.
- Upgraded to Eclipse Indigo release
- Fixed bug in bluetooth binding startup
- Images/icons can now be customized as they are available in a folder
- added a REST API to interact with items and sitemaps
- added [[Mpd Binding|MPD binding]] to connect to Music Player Deamon instances
- added a Mac OS X version of the openHAB Designer
- bugfix for GCalEventDownloader - end of multiline commands is now detected correctly