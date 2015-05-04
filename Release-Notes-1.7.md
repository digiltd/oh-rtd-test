## New & Noteworthy

Please find below the _intermediary_ release notes of the 1.7 Release.

### Version 1.7.0

See the Github issue tracker for a [full change log](https://github.com/openhab/openhab/issues?q=milestone%3A1.7.0).

####Major Features:
* [#2329](https://github.com/openhab/openhab/pull/2329) - Logitech Harmony Hub Binding (@digitaldan)
* [#2264](https://github.com/openhab/openhab/pull/2264) - MapDb persistence service (@JSurf)
* [#2224](https://github.com/openhab/openhab/pull/2224) - Nest Binding. (@watou)
* [#2190](https://github.com/openhab/openhab/pull/2190) - Satel Integra security system Binding (@druciak)
* [#2076](https://github.com/openhab/openhab/pull/2076) - Ecobee Binding (@watou)
* [#2046](https://github.com/openhab/openhab/pull/2046) - Mochad X10 Binding (@Jakey69)
* [#2025](https://github.com/openhab/openhab/pull/2025) - Action/Rule support for the MiOS Bridge Binding. (@mrguessed)
* [#2002](https://github.com/openhab/openhab/pull/2002) - Astro-Action (@gerrieg)
* [#1950](https://github.com/openhab/openhab/pull/1950) - Google TTS bundle (@dominicdesu)
* [#1929](https://github.com/openhab/openhab/pull/1929) - eBus (heating system communication protocol) Binding (@csowada)
* [#1862](https://github.com/openhab/openhab/pull/1862) - Plex Binding (@idserda)
* [#1813](https://github.com/openhab/openhab/pull/1813) - Network UPS Tools (NUT) Binding (@jaroslawmazgaj)
* [#1698](https://github.com/openhab/openhab/pull/1698) - Bticino/Legrand OpenWebIf Binding (@TomDeVlaminck)
* [#1684](https://github.com/openhab/openhab/pull/1684) - Zibase Binding (@jit06)
* [#984](https://github.com/openhab/openhab/pull/984) - Wago Binding (@BinaryCraX)

####Enhancements:
* [#2540](https://github.com/openhab/openhab/pull/2540) - Fix issue #1845 2 (@J-N-K)
* [#2538](https://github.com/openhab/openhab/pull/2538) - Refactor HUE int deviceNumber to String deviceId (@mstolt)
* [#2534](https://github.com/openhab/openhab/pull/2534) - Improve log messages when attempting a meter reset (@sumnerboy12)
* [#2532](https://github.com/openhab/openhab/pull/2532) - Add extended configuration to rrd4j persistence (@J-N-K)
* [#2529](https://github.com/openhab/openhab/pull/2529) - update MongoDB driver to the latest version to support MongoDB 3.0 (@hoegertn)
* [#2527](https://github.com/openhab/openhab/pull/2527) - Epson binding improvements (@paulianttila)
* [#2521](https://github.com/openhab/openhab/pull/2521) - Fix so Squeezebox actions automatically reconnects (@sumnerboy12)
* [#2520](https://github.com/openhab/openhab/pull/2520) - Added Insteon Device Type model 2457D2  - LampLinc Dimmer (@jhuizingh)
* [#2514](https://github.com/openhab/openhab/pull/2514) - Update the HUE binding to work with non continuous device numbers on the... (@mstolt)
* [#2513](https://github.com/openhab/openhab/pull/2513) - Various fixes and improvements to InsteonPLM (@berndpfrommer)
* [#2506](https://github.com/openhab/openhab/pull/2506) - Support for Contact items in pilight binding (@idserda)
* [#2499](https://github.com/openhab/openhab/pull/2499) - Remove httpclient lib and use import in Daikin binding (@sumnerboy12)
* [#2496](https://github.com/openhab/openhab/pull/2496) - Weather: Added chancetstorms to Wunderground common-id mapping (@gerrieg)
* [#2495](https://github.com/openhab/openhab/pull/2495) - Support for sending PRESS_* events to the Homematic server. (@gerrieg)
* [#2487](https://github.com/openhab/openhab/pull/2487) - Updated OpenSprinkler plugin to support new API versions (@CrackerStealth)
* [#2479](https://github.com/openhab/openhab/pull/2479) - Improved GenericItemProvider (@paulianttila)
* [#2475](https://github.com/openhab/openhab/pull/2475) - Updates to Mqttitude binding in preparation for new iOS/Android apps (@sumnerboy12)
* [#2473](https://github.com/openhab/openhab/pull/2473) - Make changing of state asynchronous to fix continous sending of dimmer commands (@dominicdesu)
* [#2469](https://github.com/openhab/openhab/pull/2469) - New features for Freebox binding: (@lolodomo)
* [#2464](https://github.com/openhab/openhab/pull/2464) - WeatherBinding: Use of API v2 and support of uvIndex and dewpoint (@robbyb67)
* [#2457](https://github.com/openhab/openhab/pull/2457) - screensaver state support (@nmfaraujo)
* [#2452](https://github.com/openhab/openhab/pull/2452) - For MongoDB config, added example url and sensible defaults (@jhuizingh)
* [#2450](https://github.com/openhab/openhab/pull/2450) - DSCAlarm Binding: OpenHAB2 Compatibility Issue and Partition Arm Mode Message Change (@RSStephens)
* [#2446](https://github.com/openhab/openhab/pull/2446) - Support for pilight 6.0 (@idserda)
* [#2439](https://github.com/openhab/openhab/pull/2439) - System binding: added support to query file system statistics (@paulianttila)
* [#2432](https://github.com/openhab/openhab/pull/2432) - InsteonPLM binding: introduce "related" devices, feature groups, and bug fixes (@berndpfrommer)
* [#2427](https://github.com/openhab/openhab/pull/2427) - Enhance SNMP binding (Issue #2426) (@J-N-K)
* [#2424](https://github.com/openhab/openhab/pull/2424) - [satel] Basic support for rollershutter items added (@druciak)
* [#2412](https://github.com/openhab/openhab/pull/2412) - [CometVisu] Support for PersistenceService (for Charts) and GroupFunctions added (@peuter)
* [#2409](https://github.com/openhab/openhab/pull/2409) - Make mysql persistent documentation more clear (@schinken)
* [#2136](https://github.com/openhab/openhab/pull/2136) - Refactor zwave initialisation to improve stability (@cdjackson)
* [#2603](https://github.com/openhab/openhab/pull/2603) - zwave crc 16 encapsulation command class implemented (@pluimpje)
* [#2327](https://github.com/openhab/openhab/pull/2327) - Reduced zwave wakeup time to improve battery life (@cdjackson)

####Bugfixes:
* [#2518](https://github.com/openhab/openhab/pull/2518) - TF binding: Fix for configuration handling of device aliases (@theoweiss)
* [#2512](https://github.com/openhab/openhab/pull/2512) - Use name of sitemap file when creating sitemap page bean, as it may be d... (@llamahunter)
* [#2507](https://github.com/openhab/openhab/pull/2507) - - fixes broken refresh/update (@peuter)
* [#2503](https://github.com/openhab/openhab/pull/2503) - MySQL-Persistence: Add errCnt++ to getTable and check connection (@Dennis650)
* [#2485](https://github.com/openhab/openhab/pull/2485) - Milight bugfix (@idserda)
* [#2482](https://github.com/openhab/openhab/pull/2482) - Small fix to avoid NullPointerException (@marcelrv)
* [#2481](https://github.com/openhab/openhab/pull/2481) - Fix issue #2467 (@J-N-K)
* [#2480](https://github.com/openhab/openhab/pull/2480) - Fixed encoding problem of room and device names. (@habnefrage)
* [#2476](https://github.com/openhab/openhab/pull/2476) - fix for Issue #2460: removed references to non-existent tests from generators (@gernoteger)
* [#2471](https://github.com/openhab/openhab/pull/2471) - Bugfix für wrong json time format in rrd-data (@peuter)
* [#2468](https://github.com/openhab/openhab/pull/2468) - fix-logging-for-failed-to-create-db-table (@LukeOwncloud)
* [#2467](https://github.com/openhab/openhab/issues/2467) - KNX variable never get data (@nurgaleevarman)
* [#2465](https://github.com/openhab/openhab/pull/2465) - fix for Issue #2460: remove references to non-existent tests from Generators (@gernoteger)
* [#2462](https://github.com/openhab/openhab/pull/2462) - fixed bug #2428 for serial w/o new baudrate/parity settings (@gernoteger)
* [#2448](https://github.com/openhab/openhab/pull/2448) - Bugfix: Handle multiline messages from MAX!Cube (@habnefrage)
* [#2445](https://github.com/openhab/openhab/pull/2445) - Fix issue #1845 (@J-N-K)
* [#2428](https://github.com/openhab/openhab/issues/2428) - CUL broken under Mac OS X Yosemite (1.7.0 Snapshot) (@bytedealer)
* [#2425](https://github.com/openhab/openhab/issues/2425) - Milight Binding - percentage change (@jdr0berts)
* [#2393](https://github.com/openhab/openhab/pull/2393) - Fix for issue #2392 (catch 22 if statement) (@9037568)
* [#2390](https://github.com/openhab/openhab/pull/2390) - allow negative values for setpoint widget ranges (@kaikreuzer)
* [#2373](https://github.com/openhab/openhab/pull/2373) - fix wiki links (@SubOptimal)
* [#2371](https://github.com/openhab/openhab/pull/2371) - Bug fix for KNX binding, Time update from ntp in March #2330 (@Snickermicker)
* [#2368](https://github.com/openhab/openhab/pull/2368) - Add support for ecobee3 remote sensors + bug fixes (@watou)
* [#2345](https://github.com/openhab/openhab/pull/2345) - Fix: Error on creating tables for DateTimeItems (@Dennis650)
* [#2336](https://github.com/openhab/openhab/pull/2336) - Update setpoint.html (@sja)
* [#2334](https://github.com/openhab/openhab/pull/2334) - Rfxcom itemstates (@juri8)
* [#2331](https://github.com/openhab/openhab/pull/2331) - Attempt to fix for bug #1344 (again) (@Snickermicker)
* [#2325](https://github.com/openhab/openhab/pull/2325) - MiOS Tools - For Percentages, the %% should be inside the String/Format of the Item (@mrguessed)
* [#2320](https://github.com/openhab/openhab/pull/2320) - DSCAlarm Binding Features and Fixes (@RSStephens)
* [#2315](https://github.com/openhab/openhab/pull/2315) - Correcting Netatmo bug #2314 (@clinique)

####Removals:
* none

####major API changes
* none

## Updating the openHAB runtime 1.6 to 1.7

If you have a running openHAB runtime 1.6 installation, you can easily update it to version 1.7 by following these steps:
 1. Unzip the runtime 1.7 and all required addons to a new installation folder
 1. Replace the folder "configurations" by the version from your 1.6 installation
 1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)