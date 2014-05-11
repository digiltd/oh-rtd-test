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
* [[XBMC binding|XBMC-Binding]] (#941)
* [[Pushover action|Actions]] (#922)
* RME Rainmanager binding (#919)
* [[xPL binding and action|xPL-Binding]] (#918)
* [[Heatmiser Neohub binding|NeoHub-Binding]] (#893, #931)
* [[Freeswitch binding|Freeswitch-Binding]] (#847)
* [[HAI Omnilink binding|OmniLink-Binding]] (#846)
* [[Tellstick binding|Tellstick-Binding]] (#811)
* eKey HOME and MULTI fingerprint authentication (#778)
* [[IRTrans binding|Ir-Trans-Binding]] (#716)
* [[Vellemann K8055 binding|Velleman-K8055-Binding]] (#705)
* [[GPIO binding|GPIO-Binding]] (#54)
* WAGO bus coupler binding (#25)

**Enhancements:**

**Bugfixes:**

**Removals:**

**major API changes**

## Updating the openHAB runtime 1.4 to 1.5

If you have a running openHAB runtime 1.4 installation, you can easily update it to version 1.5 by following these steps:
 1. Unzip the runtime 1.5 and all required addons to a new installation folder
 1. Replace the folder "configurations" by the version from your 1.4 installation
 1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)