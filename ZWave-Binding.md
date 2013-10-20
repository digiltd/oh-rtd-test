# Documentation of the Z-Wave binding Bundle

# Introduction

The OpenHAB Z-Wave binding allows you to connect to your Z-Wave wireless mesh network.  A Z-Wave network typically consists of one primary controller “stick”, zero or more additional controllers and zero or more Z-Wave enabled devices, e.g. dimmers, switches, sensors et cetera.
Connection to the Z-Wave controller is done through the serial port of your host system. USB controllers typically create a virtual COM port to connect to the stick. Please write down the port name before configuring this binding. In case your port name changes dynamically and you want to use a symlink, see [Tricks](https://code.google.com/p/openhab-samples/wiki/Tricks). A list of supported controllers is listed below.

Initialization of the binding typically takes several seconds to minutes depending on the number of devices in the network. When battery operated devices are used the binding tries to reach the device first. After one minute the node is marked sleeping. On wake up of the device initialization will continue.

Please make sure that you have a functioning Z-Wave network prior to using this binding. The binding currently provides no functionality to add or remove devices etc. The [open-zwave control panel](https://code.google.com/p/openzwave-control-panel/) is a good choice to set up your network. Commercial software like Homeseer can be used as well.

For installation of the binding, please see Wiki page [Bindings](https://code.google.com/p/openhab/wiki/Bindings).

## Supported controllers

The binding supports all controllers that implement the Z-Wave Serial API. A list of confirmed supported controllers is

<table>
  <tr><td>Aeon Labs USB Z-Stick</td><td>No remarks</td></tr>
  <tr><td>The Razberry-Zwave-Daughterboard</td><td>No remarks</td></tr>
  <tr><td>Vision USB stick Z-wave</td><td>No remarks</td></tr>
</table>


## Binding Configuration

First of all you need to introduce the port settings of your Z-Wave controller in the openhab.cfg file (in the folder '${openhab_home}/configurations'). The refresh interval and the refresh delay can be specified optionally.

    ############################## Z-Wave  Binding ###################################
    
    # Z-Wave controller port
    # Valid values are e.g. COM1 for Windows and /dev/ttyS0 or /dev/ttyUSB0 for Linux
    zwave:port=COM1
    
    # Z-Wave binding refresh value (optional, defaults to 10000)
    # zwave:refresh=10000
    # Z-Wave binding refresh interval threshold (optional, defaults to every 6 times)
    # zwave:refreshThreshold=6

The zwave:port value indicates the serial port on the host system to which the Z-Wave controller is connected, e.g. "COM1" on Windows, "/dev/ttyS0" on Linux or "/dev/tty.PL2303-0000103D" on Mac.

The zwave:refresh value is optional. It specifies the interval at which the binding refreshes the items in milliseconds. This is the interval for reporting items like the number of frames or the device type of a node. The default value is every 10 seconds.

The zwave:refreshThreshold value is optional. It specifies the interval threshold in number of refreshes that have to occur before the node values are polled. The nodes are polled at a lower frequency because it generates traffic on the Z-Wave network. Most devices report their values on change anyway, so usually your item values will be updated instantly when one of their values change.

## Item configuration

In order to bind an item to a Z-Wave device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the Z-Wave binding configuration string is explained here:
The format of the binding configuration is simple and looks like this:

    zwave="<nodeId>[:<endpointId>[:action]]"

where parts in brackets indicate an optional item. Usually only one item is bound to a device, but more items can be bound to a device as well, either for reporting variables, or in case the device consists of multiple endpoints / instances.

The node ID indicates the number (in decimal notation) of the node, to which this item is bound.

The endpoint ID is optional. In case a node consists of multiple instances or endpoints, the instance number can be specified using this value. The default value is 1. An example of a multi-endpoint device is the Fibaro FGS 221 double relay.

The action is optional. Besides the normal action of reporting the value of a node and/or sending a value to the device, other actions / options can be specified using the action value. The list of possible action values is indicated below.

## Actions

<table>
  <tr><td>NOP</td><td>Default action. Binds to the value of the node / endpoint and if possible sends commands to the node / endpoint.</td></tr>
  <tr><td>HOMEID</td><td>Reports the home ID of the network.</td></tr>
  <tr><td>NODEID</td><td>Reports the nodeID of the node.</td></tr>
  <tr><td>LISTENING</td><td>Reports whether the device is a listening (battery operated) device.</td></tr>
  <tr><td>SLEEPING_DEAD</td><td>Reports whether the node is sleeping / dead.</td></tr>
  <tr><td>ROUTING</td><td>Reports whether the node is routing messages to other nodes.</td></tr>
  <tr><td>VERSION</td><td>Reports the node version.</td></tr>
  <tr><td>BASIC</td><td>Reports the basic device class number of the node.</td></tr>
  <tr><td>BASIC_LABEL</td><td>Reports the basic device class name of the node.</td></tr>
  <tr><td>GENERIC</td><td>Reports the generic device class number of the node.</td></tr>
  <tr><td>GENERIC_LABEL</td><td>Reports the generic device class name of the node.</td></tr>
  <tr><td>SPECIFIC</td><td>Reports the specific device class number of the node.</td></tr>
  <tr><td>SPECIFIC_LABEL</td><td>Reports the specific device class name of the node.</td></tr>
  <tr><td>MANUFACTURER</td><td>Reports the manufacturer ID of the node.</td></tr>
  <tr><td>DEVICE_TYPE_ID</td><td>Reports the device ID of the node.</td></tr>
  <tr><td>DEVICE_TYPE</td><td>Reports the device type of the node.</td></tr>
  <tr><td>LASTUPDATE</td><td>Reports the last updated time of the node.</td></tr>
  <tr><td>SOF</td><td>Reports the number of SOF frames. Only valid for the controller node.</td></tr>
  <tr><td>CAN</td><td>Reports the number of CAN frames. Only valid for the controller node.</td></tr>
  <tr><td>NAK</td><td>Reports the number of NAK frames. Only valid for the controller node.</td></tr>
  <tr><td>OOF</td><td>Reports the number of OOF frames. Only valid for the controller node.</td></tr>
  <tr><td>ACK</td><td>Reports the number of ACK frames. Only valid for the controller node.</td></tr>
  <tr><td>WAKE_UP_INTERVAL</td><td>Reports the wake up interval for the battery  operated node.</td></tr>
  <tr><td>BATTERY_LEVEL</td><td>Reports the battery level for a device.</td></tr>
  <tr><td>RESTORE_LAST_VALUE</td><td>Indicates that the dimmer should restore to it’s last known value on an ON command, instead of setting the value to 100%.</td></tr>
</table>

## Supported Command Classes

Each node in the network provides functionality in the form of Command Classes. The OpenHAB Z-Wave binding implements the same Command Classes to be able to use the nodes in the network. Not all Z-Wave Command classes are currently supported by the binding. The supported command classes are listed in the table below.

<table>
  <tr><td>**Command Class**</td><td>** Remarks **</td></tr>
  <tr><td>NO_OPERATION</td><td>Used by the binding during initialization</td></tr>
  <tr><td>BASIC</td><td>Provides basic SET and GET of the default node value</td></tr>
  <tr><td>SWITCH_BINARY</td><td>Used to bind directly to a SWITCH</td></tr>
  <tr><td>SWITCH_MULTILEVEL</td><td>Used to bind directly to a DIMMER</td></tr>
  <tr><td>SENSOR_BINARY</td><td>Used to bind to a sensor. Use a CONTACT item in OpenHAB</td></tr>
  <tr><td>SENSOR_MULTILEVEL</td><td>Used to bind to e.g. a temperature sensor. Currently only single sensors are supported.</td></tr>
  <tr><td>MULTI_INSTANCE</td><td>Used to channel commands to the right endpoint on multi-channel devices. See item configuration.</td></tr>
  <tr><td>MANUFACTURER_SPECIFIC</td><td>Used to get manufacturer info from the device</td></tr>
  <tr><td>BATTERY</td><td>Used to get the battery level from battery operated devices. See item configuration.</td></tr>
  <tr><td>WAKE_UP</td><td>Used to respond to wake-up signals of battery operated devices.</td></tr>
  <tr><td>VERSION</td><td>Used to get version info from a node.</td></tr>
  <tr><td>SENSOR_ALARM</td><td>Used to get alarm info from sensors. Use a CONTACT item in OpenHAB</td></tr>
</table>

The basic Command Class is a special command class that almost every node implements. It provides functionality to set a value on the device and/or to read back values. It can be used to address devices that are currently not supported by their native command class like thermostats.

When the basic command class is used, devices support setting values and reporting values when polling. Direct updates from the device on changes will fail however.

To find out which command classes are supported by your Z-Wave device, you can look in the manual or use the list at http://www.pepper1.net/zwavedb/ or http://products.z-wavealliance.org/. In case your command class is supported by the device and binding, but you have a problem, you can create an issue at: https://code.google.com/p/openhab/issues/list. In case you want a command class implemented by the binding, please add it to issue [431](https://code.google.com/p/openhab/issues/detail?id=431).

## Examples

Here are some examples of valid binding configuration strings, as defined in the items configuration file:

    /* Some dimmers */
    Dimmer Light_LivingRoom_Dimmer "Living room Dimmer [%d %%]" (GF_Living) {zwave="3"} 
    Dimmer Light_Corridor_Dimmer "Corridor Dimmer [%d %%]" (GF_Corridor) {zwave="6"}
    
    /* Some multi-endpoint switches */
    Switch Mech_Vent			"Ventilation middle."	(GF_Kitchen) {zwave="11:1"}
    Switch Mech_Vent_High		"Ventilation high."	(GF_Kitchen) {zwave="11:2"}
    
    /* A dimmer that restores to it's last value */
    Dimmer Light_Toilet_Dimmer "Toilet Dimmer [%d %%]" (GF_Toilet) {zwave="10:1:restore_last_value"} 
    
    /* Controller stick statistics */
    String ZwaveStatsSOF "Number Start of Frames[%s]" (gZwaveStats) {zwave="1:1:sof"}
    String ZwaveStatsACK "Number of Acknowledgments [%s]" (gZwaveStats) {zwave="1:1:ack"}
    String ZwaveStatsCAN "Number of CAN [%s]" (gZwaveStats) {zwave="1:1:can"}
    String ZwaveStatsNAK "Number of NAK [%s]" (gZwaveStats) {zwave="1:1:nak"}
    String ZwaveStatsOOF "Number of OOF [%s]" (gZwaveStats) {zwave="1:1:oof"}
    
    /* Controller information */
    String ZwaveNode01HomeID	"Home ID [%s]" (gZwaveNode01) {zwave="1:1:homeid"}
    String ZwaveNode01NetworkID	"Network ID [%s]" (gZwaveNode01) {zwave="1:1:nodeid"}
    String ZwaveNode01LastUpdated	"Last Updated [%s]" (gZwaveNode01) {zwave="1:1:lastupdate"}
    String ZwaveNode01Listening	"Listening? [%s]" (gZwaveNode01) {zwave="1:1:listening"}
    String ZwaveNode01Routing	"Routing [%s]" (gZwaveNode01) {zwave="1:1:routing"}
    String ZwaveNode01Version	"Version [%s]" (gZwaveNode01) {zwave="1:1:version"}
    String ZwaveNode01BasicCommandClass	"Basic Command Class Label [%s]" (gZwaveNode01) {zwave="1:1:basic_label"}
    String ZwaveNode01GenericCommandClass	"Generic Command Class Label [%s]" (gZwaveNode01) {zwave="1:1:generic_label"}
    String ZwaveNode01SpcificCommandClass	"Specific Command Class [%s]" (gZwaveNode01) {zwave="1:1:specific"}
    String ZwaveNode01SpcificCommandClassLabel	"Specific Command Class Label [%s]" (gZwaveNode01) {zwave="1:1:specific_label"}
    
    /* A binary sensor */
    Contact Flood_Sensor "Flood sensor [MAP(en.map):%s]" (GF_Cellar) {zwave="12"}
    
    Number Flood_Sensor_Battery "Flood sensor battery level [%s]" (gZwaveStats) { zwave="12:1:battery_level" }

## Logging

The ZWave binding can generate a lot of debug/trace logging when enabled so it is advisable to generate a separate log file for this binding. This also makes it easier for analysis since there is nothing from other bindings/openHAB polluting the logs.

In order to configure logging for this binding to be generated in a separate file add the following to your /configuration/logback.xml file;

            <appender name="ZWAVEFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
                    <file>logs/zwave.log</file>
                    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                            <!-- weekly rollover and archiving -->
                            <fileNamePattern>logs/zwave-%d{yyyy-ww}.log.zip</fileNamePattern>
                            <!-- keep 30 days' worth of history -->
                            <maxHistory>30</maxHistory>
                    </rollingPolicy>
                    <encoder>
                            <pattern>%d{yyyy-MM-dd HH:mm:ss} %-5level %logger{30}[:%line]- %msg%n%ex{5}</pattern>
                    </encoder>
            </appender>
    
            <!-- Change DEBUG->TRACE for even more detailed logging -->
            <logger name="org.openhab.binding.zwave" level="DEBUG" additivity="false">
                    <appender-ref ref="ZWAVEFILE" />
            </logger>

It is highly recommended to turn on at least DEBUG logging whilst setting up and configuring your ZWave network for the first time. 