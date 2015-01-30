## New & Noteworthy

Please find below the release notes of the 1.6 Release.

### Version 1.6.2

This is the second bugfix release of the 1.6 release. See the Github issue tracker for a [full change log](https://github.com/openhab/openhab/issues?q=milestone%3A1.6.2).

### Updating the openHAB runtime 1.6.1 to 1.6.2

Many of the fixes does not require to update the Runtime itself so it would suffice to simply replace the Binding jars in your Add-Ons folder. However, if you would like have one of these [issues in the core](https://github.com/openhab/openhab/issues?q=milestone%3A1.6.2+label%3Acore) fixed you will have to update the Runtime as well.

**Bugfixes**
- [#2055](https://github.com/openhab/openhab/pull/2055) - Catch null message bodies caused by status updates
- [#2054](https://github.com/openhab/openhab/pull/2054) - Adding guest wlan to fritzbox binding
- [#2053](https://github.com/openhab/openhab/pull/2053) - Zwave database updates
- [#2051](https://github.com/openhab/openhab/pull/2051) - Onkyo binding: Fixed data length calculation.
- [#2042](https://github.com/openhab/openhab/pull/2042) - Add Aeon ZW089 Door sensor
- [#2040](https://github.com/openhab/openhab/pull/2040) - Issue1351
- [#2033](https://github.com/openhab/openhab/pull/2033) - Add everspring HSP02
- [#2032](https://github.com/openhab/openhab/pull/2032) - Fix RRD4J error at midnight
- [#2028](https://github.com/openhab/openhab/pull/2028) - changed the archetype default binding project according to #2720
- [#2026](https://github.com/openhab/openhab/pull/2026) - fix for #1294 - Firefox display for numbers (kudos goes to @slaney)
- [#2022](https://github.com/openhab/openhab/pull/2022) - Bugfix on handling limits of segments in SCALE transform
- [#2017](https://github.com/openhab/openhab/pull/2017) - bugfix: Changes in color should not result in changing brightness
- [#2013](https://github.com/openhab/openhab/pull/2013) - Add workaround for SMACK-635 to XMPP action
- [#2010](https://github.com/openhab/openhab/pull/2010) - Add Popp 123665
- [#2009](https://github.com/openhab/openhab/pull/2009) - [RFXCOM] Add Blind types: DC106, FOREST and Chamberlain CS4330
- [#2007](https://github.com/openhab/openhab/pull/2007) - Add additional blinds types
- [#2006](https://github.com/openhab/openhab/pull/2006) - Update CT30/CT100 association groups
- [#2004](https://github.com/openhab/openhab/pull/2004) - Add support for Aeotec 5th generation keyfob
- [#2003](https://github.com/openhab/openhab/pull/2003) - Zwave database updates
- [#2002](https://github.com/openhab/openhab/pull/2002) - Initial contribution of Astro-Action.
- [#2000](https://github.com/openhab/openhab/pull/2000) - Initial version of the ConditionalAction action plugin (3nd attempt)
- [#1996](https://github.com/openhab/openhab/pull/1996) - influxdb persistence bugfix for issue #1225
- [#1994](https://github.com/openhab/openhab/pull/1994) - Influxdb persistence Bugfix for #1879
- [#1992](https://github.com/openhab/openhab/pull/1992) - Initial version of the ConditionalAction action plugin (2nd attempt)
- [#1990](https://github.com/openhab/openhab/pull/1990) - Fix for http binding not responding to wildcard outgoing commands
- [#1988](https://github.com/openhab/openhab/pull/1988) - Update to allow launch from Eclipse IDE
- [#1986](https://github.com/openhab/openhab/pull/1986) - Bugfix #1980: anel-binding caused 100% cpu usage
- [#1985](https://github.com/openhab/openhab/pull/1985) - updated assembly (and as dependency) the jdeb maven plugins to reliably ...
- [#1984](https://github.com/openhab/openhab/pull/1984) - Nibe heat pump: Fixed wrong compressor total operation time divider.
- [#1982](https://github.com/openhab/openhab/pull/1982) - Initial version of the ConditionalAction action plugin

### Version 1.6.1

This is the first bugfix release of the 1.6 release. See the Github issue tracker for a [full change log](https://github.com/openhab/openhab/issues?q=milestone%3A1.6.1).

**Bugfixes**

- [#1717](https://github.com/openhab/openhab/pull/1717) Fix invalid character in XML (@cdjackson)
- [#1741](https://github.com/openhab/openhab/pull/1741) Onkyo binding: Fixed bug, which prevented to use multiple receivers (@paulianttila)
- [#1748](https://github.com/openhab/openhab/pull/1748) Fixed samsungac project name (@gerrieg)
- [#1749](https://github.com/openhab/openhab/pull/1749) Fixed loading configuration folder (@gerrieg)
- [#1765](https://github.com/openhab/openhab/pull/1765) Atmos duplicate sitemap message fix (@digitaldan)
- [#1758](https://github.com/openhab/openhab/pull/1758) fixed configuration file loading (@teichsta)

### Version 1.6.0

See the Github issue tracker for a [full change log](https://github.com/openhab/openhab/issues?milestone=5&page=1&state=closed).

####Major features:
- [#925](https://github.com/openhab/openhab/pull/925) LgTV Binding (@martinfluchgmxnet)
- [#1130](https://github.com/openhab/openhab/pull/1130) [[Waterkotte Ecotouch Binding|Waterkotte-EcoTouch-Heat-Pump-Binding]] (@sibbi77)
- [#1159](https://github.com/openhab/openhab/pull/1159) [[Gembird Energenie PMS-LAN Binding|Energenie-Binding]] (@hmerk)
- [#1210](https://github.com/openhab/openhab/pull/1210) JPA Persistence Binding (@mdbergmann)
- [#1292](https://github.com/openhab/openhab/pull/1292) [[Wemo Binding|Wemo-Binding]] (@hmerk)
- [#1334](https://github.com/openhab/openhab/pull/1334) [[DSC Alarm Binding|DSC-Alarm-Binding]] (@RSStephens)
- [#1357](https://github.com/openhab/openhab/pull/1357) [[BenQ Projector Binding|BenQ-Projector-Binding]] (@cyclingengineer)
- [#1370](https://github.com/openhab/openhab/pull/1370) eHealth Binding (@teichsta)
- [#1372](https://github.com/openhab/openhab/pull/1372) [RFXCOM] Initial Support for Somfy (RFY) protocol in Rfxcom binding (@juri8)
- [#1395](https://github.com/openhab/openhab/pull/1395) [[JSONPath Transformation Service|Transformations]] (@clinique)
- [#1422](https://github.com/openhab/openhab/pull/1422) [[AlarmDecoder Binding|AlarmDecoder-binding]] (@berndpfrommer)
- [#1423](https://github.com/openhab/openhab/pull/1423) [[Weather Binding|Weather-Binding]] (@gerrieg)
- [#1469](https://github.com/openhab/openhab/pull/1469) MiOS (Vera) Automation Controller (@mrguessed)
- [#1496](https://github.com/openhab/openhab/pull/1496) [[Anel NET-PwrCtrl Binding|Anel-Binding]] (@paphko)
- [#1514](https://github.com/openhab/openhab/pull/1514) [[Davis Binding|Davis-Binding]] (@tomtrath)
- [#1595](https://github.com/openhab/openhab/pull/1595) TTS interface to Speech Dispatcher (@clinique)
- [#1645](https://github.com/openhab/openhab/pull/1645) [[Samsung AirConditioner Binding|Samsung-AC-binding]] (@steintore)
- [#1649](https://github.com/openhab/openhab/pull/1649) Enigma2 Binding (@sebastiankutschbach)
- [#1668](https://github.com/openhab/openhab/pull/1668) [[pilight Binding|pilight-Binding]] (@idserda)

####Enhancements:

- [#1371](https://github.com/openhab/openhab/pull/1371) add optional headers functionality to http binding cache items in the main configuration file. (@spali)
- [#1393](https://github.com/openhab/openhab/pull/1393) Introducing lastUpdate in Persistence Extensions (@clinique)
- [#1394](https://github.com/openhab/openhab/pull/1394) Introducing Scale Transformation service (@clinique)
- [#1397](https://github.com/openhab/openhab/pull/1397) [XBMC] Add extra 'System' actions and notifications. (@avdleeuw)
- [#1408](https://github.com/openhab/openhab/pull/1408) Adds support for enabling / disabling MPD outputs (@mgbowman)
- [#1409](https://github.com/openhab/openhab/pull/1409) Allow OWServer binding to accept e.g. DS2423 dual counter, where counter... (@wuellueb)
- [#1427](https://github.com/openhab/openhab/pull/1427) Support binding Service Discovery to specific IP or hostname (@wnagele)
- [#1433](https://github.com/openhab/openhab/pull/1433) New DateTimeType Test (@spali)
- [#1436](https://github.com/openhab/openhab/pull/1436) added new action: createTimerWithArgument(expiryTime, argument, closure) (@berndpfrommer)
- [#1441](https://github.com/openhab/openhab/pull/1441) Homematic: removed XML-RPC and some updates (@gerrieg)
- [#1443](https://github.com/openhab/openhab/pull/1443) Support for multiple netmasks and IPv6 (@wnagele)
- [#1444](https://github.com/openhab/openhab/pull/1444) Added Possibility to filter incoming messages for MQTT subscriber (@Lenzebo)
- [#1460](https://github.com/openhab/openhab/pull/1460) This allows group items who are not exactly the same base item to be inc... (@digitaldan)
- [#1471](https://github.com/openhab/openhab/pull/1471) Adding deltaSince method to PersistenceExtensions (@clinique)
- [#1476](https://github.com/openhab/openhab/pull/1476) [My-SQL] Add debug for aborted queries (@cdjackson)
- [#1487](https://github.com/openhab/openhab/pull/1487) [Hue Binding] Issue #413 Adding logic in Hue binding to poll status hue lamp. (@JosSchering1)
- [#1492](https://github.com/openhab/openhab/pull/1492) Max!CUL Binding - Handle TX credit via hardware (@cyclingengineer)
- [#1494](https://github.com/openhab/openhab/pull/1494) [Squeezebox binding] Improve player event listener handling (@sumnerboy12)
- [#1498](https://github.com/openhab/openhab/pull/1498) [Yamaha binding] Add netradio support (@sumnerboy12)
- [#1499](https://github.com/openhab/openhab/pull/1499) [CUL] Implemented parameters for flexible configuration of CUL Handlers. (@joek)
- [#1502](https://github.com/openhab/openhab/pull/1502) [Insteon] Added SwitchLinc Relay and In-LineLinc Relay (@Kepesk)
- [#1505](https://github.com/openhab/openhab/pull/1505) Manage multiple Netatmo User accounts (and OAuth credentials) (@openhab-migration)
- [#1509](https://github.com/openhab/openhab/pull/1509) [Squeezebox] Add Player State to Speech Commands. Fixes #1474 #1481 (@wezhunter)
- [#1510](https://github.com/openhab/openhab/pull/1510) [Pushover] Method Enhancements (@CrackerStealth)
- [#1518](https://github.com/openhab/openhab/pull/1518) Integrated baudrate and parity settings in FS20 binding (@joek)
- [#1533](https://github.com/openhab/openhab/pull/1533) New icons for next openHAB release (@mepi0011)
- [#1534](https://github.com/openhab/openhab/pull/1534) OpenSprinkler Enhancements (@CrackerStealth)
- [#1542](https://github.com/openhab/openhab/pull/1542) Substantial refactoring of the InsteonPLM binding (@berndpfrommer)
- [#1551](https://github.com/openhab/openhab/pull/1551) [Netatmo] Adding some measurement extensions : RF Status, Wifi Status, Battery Lev... (@clinique)
- [#1588](https://github.com/openhab/openhab/pull/1588) Added support for relative urls for Webview widgets in sitemaps. (@gerrieg)
- [#1589](https://github.com/openhab/openhab/pull/1589) [Homematic] Changed alive validation check, Homegear variable bugfix and state invert for HM-SCI-3-FM (@gerrieg)
- [#1592](https://github.com/openhab/openhab/pull/1592) [Modbus Binding] Add more serial configurable parameters: datasize, parity and stop bit. (@xiboy)
- [#1601](https://github.com/openhab/openhab/pull/1601) [RFXCom] Lighting4 Message (@AlexF12004Roma)
- [#1621](https://github.com/openhab/openhab/pull/1621) [XMPP] Update Smack to 4.0.5 (@Flowdalic)
- [#1625](https://github.com/openhab/openhab/pull/1625) Uniform and easier to read logging pattern (@gerrieg)
- [#1639](https://github.com/openhab/openhab/pull/1639) [Z-Wave] Added the Mimolite sensor and relay (@digitaldan)
- [#1646](https://github.com/openhab/openhab/pull/1646) added new devices 2476D and 2634-222 to insteonplm (@berndpfrommer)
- [#1653](https://github.com/openhab/openhab/pull/1653) Epson binding improvements (@paulianttila)
- [#1657](https://github.com/openhab/openhab/pull/1657) GreenT now handling the refresh property on Image type (@darkrift)
- [#1658](https://github.com/openhab/openhab/pull/1658) [Max!Cube binding] new exclusive mode, send only events if values really changed (@bhelm)
- [#1660](https://github.com/openhab/openhab/pull/1660) [Persistence] Added previousState to PersistenceExtensions (@gerrieg)
- [#1670](https://github.com/openhab/openhab/pull/1670) [FritzAHA] getdevicelistinfos support (@robbyb67)
- [#1696](https://github.com/openhab/openhab/pull/1696) [Tellstick] Added support for Mac (@jarlebh)
- Various Zwave Fixes and Enhancements ([#1405](https://github.com/openhab/openhab/pull/1405), [#1418](https://github.com/openhab/openhab/pull/1418), [#1440](https://github.com/openhab/openhab/pull/1440), [#1446](https://github.com/openhab/openhab/pull/1446), [#1448](https://github.com/openhab/openhab/pull/1448), [#1449](https://github.com/openhab/openhab/pull/1449), [#1450](https://github.com/openhab/openhab/pull/1450), [#1451](https://github.com/openhab/openhab/pull/1451), [#1454](https://github.com/openhab/openhab/pull/1454), [#1459](https://github.com/openhab/openhab/pull/1459), [#1463](https://github.com/openhab/openhab/pull/1463), [#1464](https://github.com/openhab/openhab/pull/1464), [#1465](https://github.com/openhab/openhab/pull/1465), [#1466](https://github.com/openhab/openhab/pull/1466), [#1468](https://github.com/openhab/openhab/pull/1468), [#1477](https://github.com/openhab/openhab/pull/1477), [#1478](https://github.com/openhab/openhab/pull/1478), [#1479](https://github.com/openhab/openhab/pull/1479), [#1491](https://github.com/openhab/openhab/pull/1491), [#1507](https://github.com/openhab/openhab/pull/1507), [#1508](https://github.com/openhab/openhab/pull/1508), [#1512](https://github.com/openhab/openhab/pull/1512), [#1516](https://github.com/openhab/openhab/pull/1516), [#1521](https://github.com/openhab/openhab/pull/1521), [#1523](https://github.com/openhab/openhab/pull/1523), [#1528](https://github.com/openhab/openhab/pull/1528), [#1529](https://github.com/openhab/openhab/pull/1529), [#1532](https://github.com/openhab/openhab/pull/1532), [#1536](https://github.com/openhab/openhab/pull/1536), [#1537](https://github.com/openhab/openhab/pull/1537), [#1539](https://github.com/openhab/openhab/pull/1539), [#1544](https://github.com/openhab/openhab/pull/1544), [#1552](https://github.com/openhab/openhab/pull/1552), [#1553](https://github.com/openhab/openhab/pull/1553), [#1555](https://github.com/openhab/openhab/pull/1555), [#1556](https://github.com/openhab/openhab/pull/1556), [#1557](https://github.com/openhab/openhab/pull/1557), [#1559](https://github.com/openhab/openhab/pull/1559), [#1565](https://github.com/openhab/openhab/pull/1565), [#1568](https://github.com/openhab/openhab/pull/1568), [#1570](https://github.com/openhab/openhab/pull/1570), [#1577](https://github.com/openhab/openhab/pull/1577), [#1578](https://github.com/openhab/openhab/pull/1578), [#1587](https://github.com/openhab/openhab/pull/1587), [#1590](https://github.com/openhab/openhab/pull/1590), [#1591](https://github.com/openhab/openhab/pull/1591), [#1597](https://github.com/openhab/openhab/pull/1597), [#1598](https://github.com/openhab/openhab/pull/1598), [#1605](https://github.com/openhab/openhab/pull/1605), [#1614](https://github.com/openhab/openhab/pull/1614), [#1615](https://github.com/openhab/openhab/pull/1615), [#1619](https://github.com/openhab/openhab/pull/1619), [#1620](https://github.com/openhab/openhab/pull/1620), [#1622](https://github.com/openhab/openhab/pull/1622), [#1666](https://github.com/openhab/openhab/pull/1666), [#1669](https://github.com/openhab/openhab/pull/1669), [#1674](https://github.com/openhab/openhab/pull/1674), [#1675](https://github.com/openhab/openhab/pull/1675), [#1676](https://github.com/openhab/openhab/pull/1676), [#1677](https://github.com/openhab/openhab/pull/1677), [#1687](https://github.com/openhab/openhab/pull/1687), [#1679](https://github.com/openhab/openhab/pull/1679), [#1708](https://github.com/openhab/openhab/pull/1708), [#1709](https://github.com/openhab/openhab/pull/1709), [#1710](https://github.com/openhab/openhab/pull/1710))

####Bugfixes:

- [#1407](https://github.com/openhab/openhab/pull/1407) [KNX] Attempting bugfix for #1344 (@Snickermicker)
- [#1412](https://github.com/openhab/openhab/pull/1412) Fix for case insensitive player ids and mac addresses (@sumnerboy12)
- [#1462](https://github.com/openhab/openhab/pull/1462) Squeezebox Binding: Sync "remove" players incorrect (@wezhunter)
- [#1475](https://github.com/openhab/openhab/pull/1475) [SONOS] fix for not recognized speakers. (@ehmke)
- [#1482](https://github.com/openhab/openhab/pull/1482) Fritzbox Binding log message #881 (@mod42)
- [#1517](https://github.com/openhab/openhab/pull/1517) [KNX] Fix for #851
- [#1530](https://github.com/openhab/openhab/pull/1530) Pom fixes for all bindings using org.openhab.io.transport.serial (@tomtrath)
- [#1540](https://github.com/openhab/openhab/pull/1540) [iec6205621] Values of different meters gets mixed (@msteigenberger)
- [#1543](https://github.com/openhab/openhab/pull/1543) Zwave config NPE checks (@cdjackson)
- [#1549](https://github.com/openhab/openhab/pull/1549) [REST] Export the org.codehaus.jackson.map.annotate package (@watou)
- [#1563](https://github.com/openhab/openhab/pull/1563) [RFXCOM] LIGHTING protocols - Fix support for Contact Items (@engineergreen)
- [#1571](https://github.com/openhab/openhab/pull/1571) Fixed error message on parsing a step size (@mstolt)
- [#1573](https://github.com/openhab/openhab/pull/1573) Fix openhab_default.cfg MySQL JDBC template text (@mattgwatson)
- [#1575](https://github.com/openhab/openhab/pull/1575) CULNetworkHandler: fixed #1772,#1774: refactored CULNetworkHandlerImpl,CULSerialHandlerImpl... (@gernoteger)
- [#1581](https://github.com/openhab/openhab/pull/1581) Astro: fix error in DateTimeUtil::getRange (@stefanroellin)
- [#1583](https://github.com/openhab/openhab/pull/1583) OpenSprinkler: Null Pointer on Startup Fix (@CrackerStealth)
- [#1585](https://github.com/openhab/openhab/pull/1585) Pushover API Requires Retry and Expire Values For Priority = 2 (@CrackerStealth)
- [#1608](https://github.com/openhab/openhab/pull/1608) [Z-Wave] Fix bug with pathalogical looping with FAILED nodes. (@cdjackson)
- [#1617](https://github.com/openhab/openhab/pull/1617) Fix for issue #1267: Allow leading whitespaces in openhab.cfg (@dominicdesu)
- [#1630](https://github.com/openhab/openhab/pull/1630) [Homematic] updateDevice rpc method, add missing ccu rssi datapoints and fixed BinRpc bug (@gerrieg)
- [#1632](https://github.com/openhab/openhab/pull/1632) prevent poodle attack (@openhab-migration)
- [#1633](https://github.com/openhab/openhab/pull/1633) org.openhab.io.console: fix build error with recent eclipse (@maggu2810)
- [#1634](https://github.com/openhab/openhab/pull/1634) Treat a SendDataMessage ACK as a received message. (@cdjackson)
- [#1636](https://github.com/openhab/openhab/pull/1636) bump java environment to fix annotation compliance (@maggu2810)
- [#1637](https://github.com/openhab/openhab/pull/1637) sonos: differ between manifest and .classpath (@maggu2810)
- [#1647](https://github.com/openhab/openhab/pull/1647) [Homematic] Finally fixed BinRpc bug with negative values (@gerrieg)
- [#1652](https://github.com/openhab/openhab/pull/1652) [Netatmo] Some corrections following addition of complementary measurements (@clinique)
- [#1655](https://github.com/openhab/openhab/pull/1655) Ihc binding bug fixes (@paulianttila)
- [#1672](https://github.com/openhab/openhab/pull/1672) Add EcoTouch binding to addons.zip. Fixes #1667 (@sibbi77)
- [#1692](https://github.com/openhab/openhab/pull/1692) [Tellstick] Fix for WIND sensor and fix for duplicate IDs. Closes #1656 (@jarlebh)
- [#1693](https://github.com/openhab/openhab/pull/1693) [KNX] Update openhab_default.cfg (@cniweb)
- [#1694](https://github.com/openhab/openhab/pull/1694) Atmosphere leak fix (hopefully fixes #765) (@digitaldan)
- [#1704](https://github.com/openhab/openhab/pull/1704) [InsteonPLM binding] ability to easily add device features, fixed race conditions (@berndpfrommer)
- [#1707](https://github.com/openhab/openhab/pull/1707) [Astro] Fixed copy/paste bug (@gerrieg)

####Removals:
* none

####major API changes
* none

The complete list of issues can be obtained from the [Github Issue Tracker](https://github.com/openhab/openhab/issues?direction=asc&labels=&milestone=4&page=1&sort=created&state=closed).

## Updating the openHAB runtime 1.5 to 1.6

If you have a running openHAB runtime 1.5 installation, you can easily update it to version 1.6 by following these steps:
 1. Unzip the runtime 1.6 and all required addons to a new installation folder
 1. Replace the folder "configurations" by the version from your 1.5 installation
 1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)