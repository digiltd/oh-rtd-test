# Release Notes of openHAB version 0.7

# openHAB Release 0.7

Version 0.7 comes with many new features and bug fixes.

Here is what has been implemented:

## New & Noteworthy

### Version 0.7.0

- Some bug fixes for HTTP- and !NetworkHealth binding
- General purpose transformation services (!RegExp, XPATH), currently used by the HTTP-In binding to do web scraping
- Issue 27: Rollershutter icon reflects current state of the item (i.e. shows shutter being up or down or somewhere inbetween (icon changes for each 10%)
- The switch widget for rollershutters now supports "long press", which sends an UP/DOWN command on press and a "STOP" command on button release. A "short press" just sends UP/DOWN as before.
- Issue 13: A new slider widget has been introduced, which can be used to operate dimmer items. As the current UI framework does not support sliders, this widget is rendered as buttons, which also support long/short press to either send INCREASE/DECREASE commands or directly ON/OFF.
- Issue 18: Multiple frames are now supported on sub-pages
- KNX binding now correctly closes the KNX connection on shutdown
- Issue 28: A Linux 64-bit designer version is now available
- Issue 29: openHAB now also runs on a JVM 1.5 (not only 1.6)
- Port and localIP are now configurable for KNX/IP connection
- "Active" groups are now supported: Commands can be sent to groups, which are then passed on to all group members (e.g. for "all off"). Furthermore groups can calculate a group status based on the states of its group members (e.g. doing logical "and" or "or" operations or calculating min, max or average values for decimal values).
- Added serial FT1.2 support for KNX binding
- Issue 16: openHAB can now connect to a Fritz!Box to get information about incoming, outgoing or currenly active calls.
- Issue 9: openHAB can now connect to a google calender to download and execute events

### Version 0.7.1

- Fixed missing credentials on HTTP binding
- Fixed small rendering issue on slider widget
- Corrected bundle startup for scheduler (required for Google Calendar integration)
- Improved logging of Google Calendar integration