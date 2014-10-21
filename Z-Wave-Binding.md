Documentation of the Z-Wave binding Bundle.

## Introduction

The OpenHAB Z-Wave binding allows you to connect to your Z-Wave wireless mesh network.  A Z-Wave network typically consists of one primary controller “stick”, zero or more additional controllers and zero or more Z-Wave enabled devices, e.g. dimmers, switches, sensors etc.
Connection to the Z-Wave controller is done through the serial port of your host system. USB controllers typically create a virtual COM port to connect to the stick. Please write down the port name before configuring this binding. In case your port name changes dynamically and you want to use a symlink, see [Tricks](Samples-Tricks). A list of supported controllers is listed below.

Initialization of the binding typically takes several seconds to minutes depending on the number of devices in the network. When battery operated devices are used the binding tries to reach the device first. After one minute the node is marked sleeping. On wake up of the device initialization will continue.

Please make sure that you have a functioning Z-Wave network prior to using this binding. The binding currently provides no functionality to add or remove devices. [HABmin](https://github.com/cdjackson/HABmin) can be used to configure devices ([setting configuration parameters and association groups](https://github.com/cdjackson/HABmin/wiki/Z-Wave-Configuration)) directly within openHAB. Alternatively the [open-zwave control panel](https://code.google.com/p/openzwave-control-panel/) is a good choice to set up your network. Commercial software like Homeseer can be used as well.

For installation of the binding, please see Wiki page [Bindings](Bindings).

The snapshot version of the binding can be downloaded, together with the rest of openhab, from the [cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/) page.

**NOTE:** There is an issue with using the RPi with the zwave binding - see the known issues below.

## Supported controllers

The binding supports all controllers that implement the Z-Wave Serial API. A list of confirmed supported controllers is

<table>
  <tr><td>Aeon Labs USB Z-Stick</td><td>No remarks</td></tr>
  <tr><td>The Razberry-Zwave-Daughterboard</td><td>See known issues</td></tr>
  <tr><td>Vision USB stick Z-wave</td><td>No remarks</td></tr>
  <tr><td>Z-Wave.me Z-StickC</td><td>No remarks</td></tr>
  <tr><td>Sigma UZB ZWave-Plus</td><td>No remarks</td></tr>
</table>


## Binding Configuration

First of all you need to introduce the port settings of your Z-Wave controller in the openhab.cfg file (in the folder '${openhab_home}/configurations'). The refresh interval and the refresh delay can be specified optionally.

    ############################## Z-Wave  Binding ###################################
    
    # Z-Wave controller port
    # Valid values are e.g. COM1 for Windows and /dev/ttyS0 or /dev/ttyUSB0 for Linux
    zwave:port=COM1

The zwave:port value indicates the serial port on the host system to which the Z-Wave controller is connected, e.g. "COM1" on Windows, "/dev/ttyS0" or "/dev/ttyUSB0" on Linux or "/dev/tty.PL2303-0000103D" on Mac.

## Item configuration

In order to bind an item to a Z-Wave device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the Z-Wave binding configuration string is explained here:
The format of the binding configuration is simple and looks like this:

    zwave="<nodeId>[:<endpointId>][:command=<command>[,parameter=<value>][,parameter=<value>]...]"

where parts in brackets indicate an optional item. Usually only one item is bound to a device, but more items can be bound to a device as well, either for reporting variables, or in case the device consists of multiple endpoints / instances.

The node ID indicates the number (in decimal notation) of the node, to which this item is bound. To find out your devices nodeIds either look at the startup log of openhab or use other Z-Wave configuration programs like openzwave control panel to detect and configure your setup.

The endpoint ID is required when using the multi_instance command class. In case a node consists of multiple instances or endpoints, the instance number can be specified using this value. The default value is not to use the multi_instance command class (effectively a default value of 0). An example of a multi-endpoint device is the Fibaro FGS 221 double relay.

The command is optional, but recommended if you have multiple items bound to the same device, or the device reports multiple bits of information. Without the command class, the binding can not unambiguously differentiate different data, so it is recommended to provide a command class. Z-Wave nodes support functionality through command classes. A specific command class can be specified to use that specific functionality of the node. A node can contain multiple supported command classes. If the command is omitted, the best suitable command class for the item / node combination is automatically chosen.

Command classes may support parameters. A parameter is a name=value pair that configures some aspect of the command class on the node or in the binding.

A list with command classes and parameter values is provided below:

## Supported Command Classes

Each node in the network provides functionality in the form of Command Classes. The OpenHAB Z-Wave binding implements the same Command Classes to be able to use the nodes in the network. Not all Z-Wave Command classes are currently supported by the binding. The supported command classes are listed in the table below.

<table>
  <tr><td><b>Command Class</b></td><td><b>Remarks</b></td><td><b>Supported parameters</b></td></tr>
  <tr><td>NO_OPERATION</td><td>Used by the binding during initialization</td><td></td></tr>
  <tr><td>BASIC</td><td>Provides basic SET and GET of the default node value</td><td></td></tr>
  <tr><td>HAIL</td><td>Used by nodes to indicate that they want to be polled. The binding handles this automatically</td><td></td></tr>
  <tr><td>METER</td><td>Used to get measurements from a node</td><td>**meter_scale=value** :  optional parameter to select the meter scale in case the meter supports multiple scales (and types). Value is one of the following **textual** values:<br/>E_KWh (0, MeterType.ELECTRIC, "kWh", "Energy") <br/>E_KVAh (1, MeterType.ELECTRIC, "kVAh", "Energy")<br/>E_W(2, MeterType.ELECTRIC, "W", "Power")<br/>E_Pulses (3, MeterType.ELECTRIC, "Pulses", "Count")<br/>E_V (4, MeterType.ELECTRIC, "V", "Voltage")<br/>E_A (5, MeterType.ELECTRIC, "A", "Current")<br/>E_Power_Factor (6, MeterType.ELECTRIC, "Power Factor", "Power Factor")<br/>G_Cubic_Meters (0, MeterType.GAS, "Cubic Meters", "Volume")<br/>G_Cubic_Feet (1, MeterType.GAS, "Cubic Feet", "Volume")<br/> G_Pulses(3, MeterType.GAS, "Pulses", "Count")<br/>W_Cubic_Meters (0, MeterType.WATER, "Cubic Meters", "Volume")<br/>W_Cubic_Feet (1, MeterType.WATER, "Cubic Feet", "Volume")<br/>W_Gallons (2, MeterType.WATER, "US gallons", "Volume")<br/>W_Pulses (3, MeterType.WATER, "Pulses", "Count")</td></tr>
  <tr><td>SWITCH_BINARY</td><td>Used to bind directly to a SWITCH</td><td></td></tr>
  <tr><td>SWITCH_MULTILEVEL</td><td>Used to bind directly to a DIMMER</td><td>restore_last_value=true : restores the dimmer to it's last value if an ON command is sent to the dimmer (as opposed to setting it's value to 100%)</td></tr>
  <tr><td>SENSOR_BINARY</td><td>Used to bind to a sensor.</td><td>**sensor_type=value** : optional parameter to select a sensor in case the node supports multiple sensors. Value is one of the following **numerical** values:<br/>
	1 = General Purpose<br/>
	2 = Smoke<br/>
	3 = Carbon Monoxide<br/>
	4 = Carbon Dioxide<br/>
	5 = Heat<br/>
	6 = Water<br/>
	7 = Freeze<br/>
	8 = Tamper<br/>
	9 = Aux<br/>
	10 = Door/Window<br/>
	11 = Tilt<br/>
	12 = Motion<br/>
	13 = Glass Break<br/>
</td></tr>
  <tr><td>SENSOR_MULTILEVEL</td><td>Used to bind to e.g. a temperature sensor. Currently only single sensors are supported.</td><td>**sensor_type=value** : optional parameter to select a sensor in case the node supports multiple sensors. Value is one of the following **numerical** values:<br/>
1 = Temperature<br/>
2 = General<br/>
3 = Luminance<br/>
4 = Power<br/>
5 = RelativeHumidity<br/>
6 = Velocity<br/>
7 = Direction<br/>
8 = AtmosphericPressure<br/>
9 = BarometricPressure<br/>
10 = SolarRadiation<br/>
11 = DewPoint<br/>
12 = RainRate<br/>
13 = TideLevel<br/>
14 = Weight<br/>
15 = Voltage<br/>
16 = Current<br/>
17 = CO2<br/>
18 = AirFlow<br/>
19 = TankCapacity<br/>
20 = Distance<br/>
21 = AnglePosition<br/>
22 = Rotation<br/>
23 = WaterTemperature<br/>
24 = SoilTemperature<br/>
25 = SeismicIntensity<br/>
26 = SeismicMagnitude<br/>
27 = Ultraviolet<br/>
28 = ElectricalResistivity<br/>
29 = ElectricalConductivity<br/>
30 = Loudness<br/>
31 = Moisture<br/>
32 = MaxType
</td></tr>
  <tr><td>MULTI_INSTANCE</td><td>Used to channel commands to the right endpoint on multi-channel devices. See item configuration.</td><td></td></tr>
  <tr><td>MANUFACTURER_SPECIFIC</td><td>Used to get manufacturer info from the device</td><td></td></tr>
  <tr><td>BATTERY</td><td>Used to get the battery level from battery operated devices. See item configuration.</td><td></td></tr>
  <tr><td>WAKE_UP</td><td>Used to respond to wake-up signals of battery operated devices.</td><td></td></tr>
  <tr><td>VERSION</td><td>Used to get version info from a node.</td><td></td></tr>
  <tr><td>SENSOR_ALARM</td><td>Used to get alarm info from sensors.</td><td>*alarm_type=value* : optional parameter to select an alarm type in case the node supports multiple alarms. Value is one of the following **numerical** values: <br/>GENERAL(0, "General")<br/>SMOKE(1, "Smoke")<br/>CARBON_MONOXIDE(2, "Carbon Monoxide")<br/>CARBON_DIOXIDE(3, "Carbon Dioxide")<br/>HEAT(4, "Heat")<br/>FLOOD(5, "Flood")</td></tr>
  <tr><td>SCENE_ACTIVATION</td><td>Used to respond to Scene events.</td><td>scene=xx to identify the scene to trigger on <br/> state=xx to set the item to the specified state (xx is an integer)</td></tr>
  <tr><td>ALARM</td><td></td></tr>
  <tr><td>MULTI_CMD</td><td>Used to send multiple command classes in a single packet.</td></tr>
</table>

## Parameters that can be added to any item

There are some general parameters that can be added to any command class
in an item string. These are `refresh_interval=value` and `respond_to_basic=true`

`refresh_interval=value` sets the refresh interval to *value* seconds. 0 indicates that no polling is performed and the node should inform the binding itself on value changes. This is the default value.

`respond_to_basic=true` indicates that the item will respond to basic reports. Some Fibaro contacts and universal sensors report their values as BASIC reports instead of a specific command class. You can add this parameter to an item to indicate that this item should respond to those reports.

`meter_zero=xx.x` can be set when using the Meter command class. If set, anything below the value specified will be considered as 0. This allows the user to account for small power consumption readings even when a device is off.

`sensor_scale=X` can be set for the multilevel sensor class to force the sensor to be converted to a specific scale. This uses the scale information provided by the device to decide how, or if, the conversion needs to be applied. Currently this is only available for temperature sensors. eg. `sensor_scale=0` will ensure that a temperature sensor is always shown in celsius, while `sensor_scale=1` will ensure fahrenheit.

`invert_state=true` can be used to invert the state of a multilevel switch command class. eg this can be used to reverse the direction of a rollershutter.

### Basic command class

The basic Command Class is a special command class that almost every node implements. It provides functionality to set a value on the device and/or to read back values. It can be used to address devices that are currently not supported by their native command class like thermostats.

When the basic command class is used, devices support setting values and reporting values when polling. Direct updates from the device on changes will fail however.

You can force a device to work with the basic command set (or any specific command set for that matter using a syntax like:

    Switch    ZwaveDevice        { zwave="3:1:command=BASIC" }


To find out which command classes are supported by your Z-Wave device, you can look in the manual or use the list at http://www.pepper1.net/zwavedb/ or http://products.z-wavealliance.org/. In case your command class is supported by the device and binding, but you have a problem, you can create an issue at: https://github.com/openhab/openhab/issues. In case you want a command class implemented by the binding, please create an issue.

## Known Issues

There seems to be an issue with the binding running on the latest oracle VM Beta, on ARM based architectures (e.g. raspberry PI). It manifests itself as messages being received multiple times and causes considerable problems with the operation of the binding. In large networks, the queue can get extremely long, which can delay initialisation considerably and cause potentially long delays in sending messages. Some time has been spent investigating this issue and a solution has not been found - the issue doesn't appear to be with the binding itself as the problem doesn't manifest itself on an other platform. If anyone with the hardware and programming experience can help with this it would be useful (add information to #1564).

## Examples

Here are some examples of valid binding configuration strings, as defined in the items configuration file:

    /* Some statistics */
    
    Number ZwaveStatsSOF "Number Start of Frames[%s]" (gZwaveStats) {zwave="1:1:command=info,item=sof"}
    Number ZwaveStatsACK "Number of Acknowledgments [%s]" (gZwaveStats) {zwave="1:1:command=info,item=ack"}
    Number ZwaveStatsCAN "Number of CAN [%s]" (gZwaveStats) {zwave="1:1:command=info,item=can"}
    Number ZwaveStatsNAK "Number of NAK [%s]" (gZwaveStats) {zwave="1:1:command=info,item=nak"}
    Number ZwaveStatsOOF "Number of OOF [%s]" (gZwaveStats) {zwave="1:1:command=info,item=oof"}
    Number ZwaveStatsTimeout "Number of Time-outs [%s]" (gZwaveStats) {zwave="1:1:command=info,item=time_out"}
    String ZwaveNode01HomeID	"Home ID [%s]" (gZwaveNode01) {zwave="1:1:command=info,item=home_id"}
    Number ZwaveNode01NetworkID	"Node ID [%s]" (gZwaveNode01) {zwave="1:1:command=info,item=node_id"}
    
    /* A dimmer and a contact */
    
    Dimmer Light_Corridor_Dimmer "Hallway Dimmer [%d %%]" (GF_Corridor) {zwave="6"}
    Contact Door_Corridor_Switch "Front door sensor [MAP(nl.map):%s]" (GF_Corridor) {zwave="21:command=sensor_binary,respond_to_basic=true"} 
    Number Door_Corridor_Battery "Front door sensor battery level [%d %%]" (GF_Corridor) { zwave="21:command=battery" }
    
    /* A node with multiple endpoints */
    
    Switch Mech_Vent			"Mechanical ventilation middle."	(GF_Kitchen) {zwave="11:1"}
    Switch Mech_Vent_High		"Mechanical ventilation high."	(GF_Kitchen) {zwave="11:2"}
    
    /* A Everspring ST814 temperature and humidity sensor as example of sensor_multilevel */
   
    Number T_AZH  "Temperature [%.1f °C]" (AZH) {zwave="32:1:command=sensor_multilevel,sensor_type=1" }
    Number RH_AZH "Humidity    [%.0f %%]" (AZH) { zwave="32:1:command=sensor_multilevel,sensor_type=5" }
    
    /* A fibaro wall plug with energy meter. */
    
    Switch Coffee_Kitchen_Switch "Coffee machine" (GF_Cellar) {zwave="18:command=switch_binary"} 
    Number Coffee_Kitchen_Power "Coffee machine power consumption [%.1f W]" (GF_Cellar,GF_Energy) { zwave="18:command=sensor_multilevel" }
    Number Coffee_Kitchen_Energy "Coffee machine total energy usage  [%.2f KWh]" (GF_Cellar) { zwave="18:command=meter" }
    
    /* A six node power bar with integrated energy and power meter and different intervals. */
    
    Switch Switch_Powerbar_Subwoofer "Subwoofer" (GF_Living) {zwave="26:1:command=switch_binary"} 
    Switch Switch_Powerbar_Reiceiver "Receiver" (GF_Living) {zwave="26:2:command=switch_binary"} 
    Switch Switch_Powerbar_DVD "DVD" (GF_Living) {zwave="26:3:command=switch_binary"} 
    Switch Switch_Powerbar_TV "TV" (GF_Living) {zwave="26:4:command=switch_binary"} 
    Switch Switch_Powerbar_Xbox "XBOX-360" (GF_Living) {zwave="26:5:command=switch_binary"} 
    Switch Switch_Powerbar_PC "Mediacenter" (GF_Living) {zwave="26:6:command=switch_binary"} 
    
    Number Power_Powerbar_Subwoofer "Subwoofer power consumption  [%d W]" (GF_Living,GF_Energy) {zwave="26:1:command=meter,meter_scale=E_W,refresh_interval=60"} 
    Number Power_Powerbar_Reiceiver "Receiver power consumption  [%d W]" (GF_Living,GF_Energy) {zwave="26:2:command=meter,meter_scale=E_W,refresh_interval=70"} 
    Number Power_Powerbar_DVD "DVD power consumption [%d W]" (GF_Living,GF_Energy) {zwave="26:3:command=meter,meter_scale=E_W,refresh_interval=60"} 
    Number Power_Powerbar_TV "TV power consumption [%d W]" (GF_Living,GF_Energy) {zwave="26:4:command=meter,meter_scale=E_W,refresh_interval=70"} 
    Number Power_Powerbar_Xbox "XBOX-360 power consumption [%d W]" (GF_Living,GF_Energy) {zwave="26:5:command=meter,meter_scale=E_W,refresh_interval=80"} 
    Number Power_Powerbar_PC "Mediacenter power consumption [%d W]" (GF_Living,GF_Energy) {zwave="26:6:command=meter,meter_scale=E_W,refresh_interval=80"} 
    
    Number Energy_Powerbar_Subwoofer "Subwoofer total energy usage  [%.4f KWh]" (GF_Living) {zwave="26:1:command=meter,meter_scale=E_KWh,refresh_interval=300"} 
    Number Energy_Powerbar_Reiceiver "Receiver total energy usage  [%.4f KWh]" (GF_Living) {zwave="26:2:command=meter,meter_scale=E_KWh,refresh_interval=310"} 
    Number Energy_Powerbar_DVD "DVD totaal total energy usage  [%.4f KWh]" (GF_Living) {zwave="26:3:command=meter,meter_scale=E_KWh,refresh_interval=320"} 
    Number Energy_Powerbar_TV "TV total energy usage [%.4f KWh]" (GF_Living) {zwave="26:4:command=meter,meter_scale=E_KWh,refresh_interval=330"} 
    Number Energy_Powerbar_Xbox "XBOX-360 total energy usage  [%.4f KWh]" (GF_Living) {zwave="26:5:command=meter,meter_scale=E_KWh,refresh_interval=340"} 
    Number Energy_Powerbar_PC "Mediacenter total energy usage  [%.4f KWh]" (GF_Living) {zwave="26:6:command=meter,meter_scale=E_KWh,refresh_interval=350"} 
    

## Healing
The binding can perform a nightly heal. This will try to update the neighbor node list, associations and routes. The actual routing is performed by the controller.
Two options are possible in the config file to set the healing. ```healtime``` sets the time (in hours) that the automatic heal will occur. ```softReset``` can also be set to true to perform a soft reset on the controller before the heal. Note that it has been observed that this can cause some zwave-plus sticks to lock up, so you should test this first.

## Logging

The ZWave binding can generate a lot of debug/trace logging when enabled so it is advisable to generate a separate log file for this binding. This also makes it easier for analysis since there is nothing from other bindings/openHAB polluting the logs.

In order to configure logging for this binding to be generated in a separate file add the following to your /configuration/logback.xml file;
```xml
<appender name="ZWAVEFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
   <file>logs/zwave.log</file>
   <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <!-- weekly rollover and archiving -->
      <fileNamePattern>logs/zwave-%d{yyyy-ww}.log.zip</fileNamePattern>
      <!-- keep 30 days' worth of history -->
      <maxHistory>30</maxHistory>
   </rollingPolicy>
   <encoder>
     <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} %-5level %logger{30}[:%line]- %msg%n%ex{5}</pattern>
   </encoder>
</appender>
    
<!-- Change DEBUG->TRACE for even more detailed logging -->
<logger name="org.openhab.binding.zwave" level="DEBUG" additivity="false">
   <appender-ref ref="ZWAVEFILE" />
</logger>
```
It is highly recommended to turn on at least DEBUG logging whilst setting up and configuring your ZWave network for the first time. 