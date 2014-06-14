Here is a _**preliminary**_ list of what this release most likely brings on top of the previous openHAB 1.4.

## New & Noteworthy

See the Github issue tracker for a [full change log](https://github.com/openhab/openhab/issues?milestone=4&page=1&state=closed).

### openHAB Runtime

**Major features:**
* [[MongoDB persistence service|MongoDB-Persistence]] (#989)
* [[Daikin binding (for KKRP01A online controller)|Daikin-Binding]] (#955)
* [[Astro time calculation binding|Astro-binding]] (#947)
* Oceanic water softener binding (#946)
* [[Insteon PLM binding|Insteon-PLM-Binding]] (#943)
* [[XBMC binding|XBMC-Binding]] (#941, #217)
* [[Pushover action|Actions]] (#922)
* RME Rainmanager binding (#919)
* [[xPL binding and action|xPL-Binding]] (#918)
* [[Heatmiser Neohub binding|NeoHub-Binding]] (#893, #931)
* [[Freeswitch binding|Freeswitch-Binding]] (#847)
* [[HAI Omnilink binding|OmniLink-Binding]] (#846)
* [[Tellstick binding|Tellstick-Binding]] (#811)
* [[eKey HOME and MULTI fingerprint authentication|ekey-Binding]] (#778)
* [[IRTrans binding|Ir-Trans-Binding]] (#716)
* [[Vellemann K8055 binding|Velleman-K8055-Binding]] (#705, #330)
* [[GPIO binding|GPIO-Binding]] (#54)
* WAGO bus coupler binding (#25)

**Enhancements:**
* Various Enhancements for Tinkerforge Binding (#720, #740, #848, #915)
* Various Enhancements for Z-Wave Binding (#839, #842, #859, #861, #862, #863, #879, #880, #883, #899 #907, #910, #912, #916, #923, #928, #942, #945, #949)
* Various Enhancements for RFXCom Binding (#858, )
* Various Enhancements for MPD Binding (#888, )
* Move the Apple TTS Engine (Macintalk) to a seperate add-on bundle (#872, #869 )
* Improvements to FritzBox exception logging (#891)
* Improvements to MQTT connection exception logging (#892)
* begin and end parameter for chart servlet added (#896)
* NikobusBinding : added calculation of second CRC & improved support for dimmer/rollershutter (#917)
* Add mySQL timeout parameter and update cfg defaults (#930)
* Update 'Joda - Time' to version 2.3 (#938)
* DateTimeType with timezone detection (#960)

**Bugfixes:**
* Bundle loading order issue (#457, #517, #637, #707)
* Prevent multiple events for touch devices (#799, #807)
* Various Plugwise Bugfixes (#850)
* HDanywhere: Fix issue with .cfg parsing (#856)
* Inconsistent paths in classic UI (#853)
* Fix NPE if no persistence services enabled (#895)
* Maxcube: Support On/Off commands (#897)
* Network Health binding - Refresh Interval default can not be changed (#900)
* Fritzbox reconnect issue (#937)
* Fix to allow the SqueezeServer class to reconnect if connection is lost (#940)
* Added Insteon PLM binding. Fixed urtsi binding (#953)
* TCP/UDP binding: fixed character encoding and make encoding configurable... (#961)

**Removals:**

**major API changes**

## Updating the openHAB runtime 1.4 to 1.5

If you have a running openHAB runtime 1.4 installation, you can easily update it to version 1.5 by following these steps:
 1. Unzip the runtime 1.5 and all required addons to a new installation folder
 1. Replace the folder "configurations" by the version from your 1.4 installation
 1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)