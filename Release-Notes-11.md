# Release Notes of openHAB version 1.1

# openHAB Release 1.1

Version 1.1 includes many new features, improvements and bug fixes.

Here is a detailed list of what this release brings on top of the previous openHAB 1.0:

## New & Noteworthy

### Version 1.1.0

Major features:
- new [TCP & UDP binding](http://code.google.com/p/openhab/wiki/TCPBinding)
- new [CUPS binding](http://code.google.com/p/openhab/wiki/CUPSBinding)
- new [IHC / ELKO binding](http://code.google.com/p/openhab/wiki/IHCBinding)
- new [Modbus binding](http://code.google.com/p/openhab/wiki/ModbusTcpBinding)
- new [Sonos binding](http://code.google.com/p/openhab/wiki/SonosBinding)
- new [Plugwise binding](http://code.google.com/p/openhab/wiki/PlugwiseBinding)
- new [PLCBus binding](http://code.google.com/p/openhab/wiki/PLCBusBinding)
- new [mySQL persistence service](http://code.google.com/p/openhab/wiki/SqlPersistence)
- new [Exec persistence service](http://code.google.com/p/openhab/wiki/ExecPersistence) which executes commands according to item changes (extremely useful when incorporating external visualisation tools)
- new [Cosm persistence service](http://code.google.com/p/openhab/wiki/CosmPersistence)
- new [Mary Text-to-Speech](http://code.google.com/p/openhab/issues/detail?id=50) engine

Enhancements:
- Issue 62: Support streaming mode in the REST API for item/widget status changes
- Issue 116: Modify minimumSince, maximumSince, historicValue to return full state with timestamp, not just the value
- Issue 150: URLs auf the !HttpOutBinding can now be enhanced using the String.format() Syntax. See the [Binding documentation](http://code.google.com/p/openhab/wiki/HttpBinding) for detailed information
- added retry capability to onewire binding
- added rrd charting possibilities for Dimmers, Rollershutters, Switches and Contacts
- added support for KNX DPT 5.004
- added SUM !GroupFunction
- enhanced onewire binding ([issue 98](https://github.com/openhab/openhab/issues#issue/98) comment 3) to make the temperature scale configurable
- upgraded REST API to use Atmosphere 1.0.4
- audio action now also supports Shoutcast streams and pls files
- changed demo setup from Google Weather API to Yahoo Weather as support for former is discontinued
- upgraded build to Tycho 0.16.0

Bugfixes:

- Issue 40: TTS doesn't work on Linux
- Issue 101: Blocked !WorkThread on !RasPi: Timeout occurred
- Issue 102: historicState always returns the most recent value for DB4O persistence
- Issue 110: asterisk binding call item seems to provide wrong values
- Issue 113: too many open files
- Issue 121: Only the Time-bases rules from the last modified rule-file are executed
- Issue 127: contradictory message: You are running a potentially unstable version...
- Issue 139: NTP Binding allows only one entry
- Issue 143: XMPP:answer may not be longer than 2000 chars
- fixed a bug when executing a commandline on macros - sometimes the String[] signature of exec is to be used - Use '@@' as delimiter in those cases
- fixed the count() methods of AND and OR !GroupFunctions so that getStateAs() instead of getState() is incorporated - so dimmers which are in a Group of type Switch are counted correctly as well
- type hierarchy of accepted data types is now being considered
- fixed NPE in Mail-Action when mail:tls parameter is not set properly
- fix which allows square-brackets in HttpBindingConfigs again (e.g. for XPATH transformations)
- fixed potential race condition in KNX binding
- fixed bug with KNX read flag on other GAs than the first one


## Updating the openHAB runtime 1.0 to 1.1

If you have a running openHAB runtime 1.0 installation, you can easily update it to version 1.1 by following these steps:
1. Unzip the runtime 1.1 and all required addons to a new installation folder
1. Replace the folders "configurations" and "etc" by the version from your 1.0 installation
1. Copy all other customizations you might have done to the new installation (e.g. additional images, sounds, etc.)