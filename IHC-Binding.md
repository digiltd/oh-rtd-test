Documentation of the IHC / ELKO binding Bundle

## Introduction

This binding is for the "Intelligent Home Control" building automation system originally made by LK, but now owned by Schneider Electric and sold as "IHC Intelligent Home Control". It is based on a star configured topology with wires to each device. The system is made up of a central controller and up to 8 input modules and 16 output modules. Each input module can have 16 digital inputs and each output module 8 digital outputs, resulting in a total of 128 input and 128 outputs per controller.

For installation of the binding, please see Wiki page [[Bindings]].
 
## Binding Configuration

add to ${openhab_home}/configuration/

Configure binding by adding following lines to your OpenHAB configuration file and fill IP address, user name and password according your controller configuration. Timeout need to be configured in milliseconds (5000 = 5 seconds). 

Binding will download project file from the controller. Binding also listening controller state changes and when controller state is changed from init to ready state (controller is reprogrammed), project file will be download again from the controller.

    ######################## IHC / ELKO LS Binding ########################################
    # Controller IP address 
    ihc:ip=
    
    # Username and password for Controller
    ihc:username=
    ihc:password=
    
    # Timeout for controller communication
    ihc:timeout=5000

IHC / ELKO LS controller communication interface is SOAP (Simple Object Access Protocol) based limited to HTTPS transport protocol. **Controller TLS certificate is self signed, so by default OpenHAB (precisely Java) will not allow TLS connection to controller for security reason.** You need to import controller TLS certificate to trusted list by using java keytool. 

You can download controller TLS certificate e.g. by Firefox browser; just open HTTPS connection to your controller IP address (https://192.168.1.2), click "lock" icon (just before URL box) -> more information -> security tab -> view certificate -> details tab -> export.

Keytool usage:

    $JAVA_HOME/bin/keytool -importcert -alias <some descriptive name> -keystore <path to keystore> -file <certificate file>

See more information about the keytool from [here](http://docs.oracle.com/javase/6/docs/technotes/tools/solaris/keytool.html).

Keytool usage example (OS X):

    sudo keytool -importcert -alias ELKO -keystore /System/Library/Java/Support/CoreDeploy.bundle/Contents/Home/lib/security/cacerts -file ELKOLivingSystemController.pem

## Item Binding Configuration

IHC / ELKO LS binding use resource ID's to control and listening notification to/from the controller. You can find correct resource ID's from your IHC / ELKO LS project file. Binding support both decimal and hexadecimal values for resource ID's values. Hexadecimal value need to be specified with 0x prefix.

The syntax of the binding configuration strings accepted is the following:

    ihc="[>]ResourceId[:refreshintervalinseconds]"

where parts in brackets [] signify an optional information.

The optional '>' sign tells whether resource is out binding only, where internal update from OpenHAB bus is just transmitted to the controller.

Refresh interval could be used for forcefully synchronous resource values from controller.

Binding will automatically enable runtime value notifications from controller for all configured resources.

Currently OpenHAB's Number, Switch, Contact, String and DateTime items are supported.

<table>
  <tr><td>**OpenHAB data type**</td><td>**IHC / ELKO LS data type(s)**</td></tr>
  <tr><td>Number</td><td>WSFloatingPointValue, WSIntegerValue, WSBooleanValue, WSTimerValue, WSWeekdayValue</td></tr>
  <tr><td>Switch</td><td>WSBooleanValue</td></tr>
  <tr><td>Contact</td><td>WSBooleanValue</td></tr>
  <tr><td>String</td><td>WSEnumValue</td></tr>
  <tr><td>DateTime</td><td>WSDateValue, WSTimeValue</td></tr>
</table>

Examples, how to configure your items (e.g. demo.items):

Weather temperature is download from internet and updated to IHC controller object where resource id is 1234567:
    Number Weather_Temperature "Outside Temp. (Yahoo) [%.1f °C]" <temperature> (Weather_Chart) { http="<[http://weather.yahooapis.com/forecastrss?w=638242&u=c:60000:XSLT(demo_yahoo_weather.xsl)]", ihc=">1234567" }

Binding listens all state changes from controller's resource id 9953290 and update state changes to OpenHAB Light_Kitchen item. All state changes from OpenHAB will be also transmitted to the controller (e.g. command from OpenHAB console 'openhab send Light_Kitchen ON').

    Switch Light_Kitchen {ihc="9953290"}

Such as previous example, but resource value will additionally asked from controller ones per every minute.

    Number Temperature_Kitchen "Temperature [%.1f °C]" <temperature> (Temperature, FF_Kitchen) { ihc="0x97E00A:60" }