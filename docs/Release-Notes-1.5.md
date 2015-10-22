## New & Noteworthy

### Version 1.5.1

This is the first Bugfix Release of the 1.5 Release. See the Github issue tracker for a [full change log](https://github.com/openhab/openhab/issues?q=milestone%3A1.5.1+is%3Aclosed).

**Bugfixes**

* Start broadcaster lifecycle management manually (#1392)
* Add the UUIDBroadcaster class in code and start the lifecyle management (#1376)
* Rest memory issues to address #765 (#1374)
* IRtrans : fix double processing of IR commands received (#1364)
* Changed atmosphere broadcasterLifeCyclePolicy from NEVER to IDLE_DESTROY (#1353)
* Sonos : Fix issue with BindingProvider for cases where there are >100 (#1352)
* Fix openhab.cfg documentation for Sonos binding (#1350)
* Fix for MaxCube invalid settemperature when the actual temperature >25C (#1336)
* Various fixes in Sonos Binding (#1314)
* MQTTBinding - Fixed bug causing repeated unsubscribes (#1309)
* Fix for ZWave meter nodes to support RESET commands (#1286)
* Fix typo error (missing </Product> at line 864) (#1265)
* Add invert_percent option for roller shutters (#1260)
* Fixed ColorItem persistence (#1258)
* Added test cases for KNXCoreTypeMapper (#1254)
* Change default ID to MAX_INTEGER to avoid problem deserialising (#1253)
* Support more devices via http binding (#1231)
* Change Java back to 1.5 (#1229)
* TinkerforgeBinding: Bugfix and upgrade of TinkerForge api (#1219)
* Default node identity to -1/-1/-1 since 0 is a valid manufacturer ID (Sigma Designs) (#1213)
* Removed soft reset on send thread start (#1208)
* Netatmo Binding: add details to exception when JSON parser fails (#1202)
* Zwave rollershutter (#1201)
* Added OpenPaths binding to the distribution build (#1186)
* Cul/FHT/EM fixes (#1184)
* Added state invert for HMW-IO-12-Sw14-DR device (#1180)
* Various Sonos fixes - see individual commits (#1176)
* XBMC Binding: implement system shutdown, bugfixes (#1174)
* Added state invert for HM-Sec-TiS and ZEL STG RM FFK devices (#1173)
* KNX : fixed bug regarding double usage of datapoints in Item definition + DPT 7.001 (#1167)
* Issue #1129, edge detection should be set only on input pins (#1155)
* Bugfix which solves a conflict between CV and REST binding (#1154)
* Inchoate deflate and gzip support for org.openhab.io.net.http.HTTPUtils (#1146)
* Losing events on REST API (atmosphere) - OH 1.4 (#765)

### Updating the openHAB runtime 1.5 to 1.5.1

For instructions how to update to the new release please refer to the "Updating" section below.

### Version 1.5.0

See the Github issue tracker for a [full change log](https://github.com/openhab/openhab/issues?milestone=4&page=1&state=closed).

**Major features:**
* [[GPIO Binding|GPIO-Binding]] (#54)
* [[Vellemann K8055 Binding|Velleman-K8055-Binding]] (#705, #330)
* [[IRTrans Binding|Ir-Trans-Binding]] (#716)
* [[eKey HOME and MULTI fingerprint authentication Binding|ekey-Binding]] (#778)
* [[Tellstick Binding|Tellstick-Binding]] (#811)
* [[HAI Omnilink Binding|OmniLink-Binding]] (#846)
* [[Freeswitch Binding|Freeswitch-Binding]] (#847)
* [[Heatmiser Neohub Binding|NeoHub-Binding]] (#893, #931)
* [[xPL Binding and Action|xPL-Binding]] (#918)
* RME Rainmanager Binding (#919)
* [[Pushover Action|Actions]] (#922)
* [[XBMC Binding|XBMC-Binding]] (#941, #217)
* [[Insteon PLM Binding|Insteon-PLM-Binding]] (#943)
* Oceanic water softener Binding (#946)
* [[Astro time calculation Binding|Astro-binding]] (#947)
* [[Daikin Binding (for KKRP01A online controller)|Daikin-Binding]] (#955)
* [[Withings Binding|Withings-Binding]] (#979)
* [[MongoDB persistence service|MongoDB-Persistence]] (#989)
* [[Binding for Philips TVs with jointspace API|jointSPACE-Binding]] (#1004)
* [[Freebox Binding|Freebox-Binding]] (#1012)
* [[Iec 62056-21 meter Binding|IEC-62056---21-Meter-Binding]] (#1040)
* [[Persistence Service using InfluxDB|InfluxDB-Persistence]] (#1072, #1086)
* [[Waterkotte EcoTouch Heatpump Binding|Waterkotte-EcoTouch-Heat-Pump-Binding]] (#1130)
* [[Complete refactoring of the Homematic Binding|Homematic-Binding]] (#999)

**Enhancements:**
* Various Enhancements for Tinkerforge Binding (#720, #740, #848, #915, #988, #1004, #1066, #1108, #1123 )
* Various Enhancements for Z-Wave Binding (#839, #842, #859, #861, #862, #863, #879, #880, #883, #899 #907, #910, #912, #916, #923, #928, #942, #945, #949, #973, #974, #975, #977, #990, #998, #1006, #1016, #1017, #1018, #1019, #1020, #1043, #1049, #1050, #1051, #1058, #1062, #1065, #1067, #1070, #1075, #1078, #1084, #1091, #1101, #1134, #1143)
* Various Enhancements for RFXCom Binding (#858)
* Various Enhancements for MPD Binding (#888)
* Move the Apple TTS Engine (Macintalk) to a seperate add-on bundle (#872, #869)
* Improvements to FritzBox exception logging (#891)
* Improvements to MQTT connection exception logging (#892)
* Begin and end parameter for chart servlet added (#896)
* NikobusBinding : added calculation of second CRC & improved support for dimmer/rollershutter (#917)
* Add mySQL timeout parameter and update cfg defaults (#930)
* Update 'Joda - Time' to version 2.3 (#938)
* DateTimeType with timezone detection (#960)
* Refactoring of IHC binding (#963)
* Sonos - Implement "playline" command + various improvements (#969, #1032, #1061, #1069)
* Added outlier filtering feature to the 1-wire binding (#1008)
* More flexible formatting of numeric values (#1012, #1022)
* Added MQTT last will and testament feature (#1023)
* added feature to urtsi binding to address multiple daisy-chained devices (#1027)
* FritzboxAHA-Binding improvement: Added energy reading for web interface queries (#1102)
* squeezebox : added language parameter for action squeezeboxSpeak() (#1107)

**Bugfixes:**
* Bundle loading order issue (#457, #517, #637, #707)
* Prevent multiple events for touch devices (#799, #807)
* Various Plugwise Bugfixes (#850)
* HDanywhere: Fix issue with .cfg parsing (#856)
* Inconsistent paths in classic UI (#853)
* Fix NPE if no persistence services enabled (#895)
* Maxcube: Support On/Off commands (#897)
* Network Health binding - Refresh Interval default can not be changed (#900, #986)
* Fritzbox reconnect issue (#937)
* Fix to allow the SqueezeServer class to reconnect if connection is lost (#940)
* Added Insteon PLM binding. Fixed urtsi binding (#953)
* TCP/UDP binding: fixed character encoding and make encoding configurable... (#961)
* Fix a crash in squeezeserver when parsing volume. Update title/volume when state changes to play (#965)
* A chart doesn't work for Switch item in v1.4.1 (#970)
* Column name in ORDER BY clause has to be defined without quotes (#987)
* OpenSprinkler Binding Silent Fail with Java JDK 1.7 Fix (#983)
* Chart onoff fix (#995)
* Wrong parameters for RPC function init (#1000)
* Reconnection bug fixes for the Squeezebox Server IO bundle (#1026)
* Bugfix for integer value and float conversion pattern (#1013, #1030)
* TCP/UDP binding: Answer of command could not be transformed (#1033)
* o.o.c.t.i.s.RegExTransformationService returning null instead of source value (#1054)
* Fixed item publishing and reloading (#1055)
* Improved concurrency handling and mqtt startup behaviour (#1064)
* improves Classic UI compatibility of Firefox 15 and higher (#1071)
* Squeezebox binding http command - dest port not used (#1077)
* Squeezebox binding - parseBindingConfig : wrong execption thrown if illegal argument (#1082)
* Openhab Designer Mac (#636) doesn't know pushover (#1096, #1111)
* EnOcean binding: Fix illumunation value conversion (#1136)
* MySQL: fix GroupItem handling (#1140)
* EnOcean binding: Support PercentType for NumberItems (#1141)
* Atmosphere Update to 2.0.7 (#1126)

**Removals:**
* none

**major API changes**
* none

The complete list of issues can be obtained from the [Github Issue Tracker](https://github.com/openhab/openhab/issues?direction=asc&labels=&milestone=4&page=1&sort=created&state=closed).

## Updating the openHAB runtime 1.4 to 1.5

If you have a running openHAB runtime 1.4 installation, you can easily update it to version 1.5 by following these steps:
 1. Unzip the runtime 1.5 and all required addons to a new installation folder
 1. Replace the folder "configurations" by the version from your 1.4 installation
 1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)