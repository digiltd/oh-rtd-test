Note: this documentation is for OpenHAB v1.8. Documentation for OpenHAB 1.7 [can be found here](https://github.com/berndpfrommer/openhab/blob/insteonplm/bundles/binding/org.openhab.binding.insteonplm/src/main/docs/insteoplm_v1.7.md).

## Introduction

Insteon is a home area networking technology developed primarily for
connecting light switches and loads. Insteon devices send messages
either via the power line, or by means of radio frequency (RF) waves,
or both (dual-band). A considerable number of Insteon compatible
devices such as switchable relays, thermostats, sensors etc are
available. More about Insteon can be found on [Wikipedia](http://en.wikipedia.org/wiki/Insteon).

This binding provides access to the Insteon network by means of either an
Insteon PowerLinc Modem (PLM), a legacy Insteon Hub (pre-2014) or the new 2245-222 ("2014") Insteon Hub.
The modem can be connected to the openHAB server either via a serial port (Model 2413S) or a USB port
(Model 2413U). The binding translates openHAB commands into Insteon
messages and sends them on the Insteon network. Relevant messages from
the Insteon network (like notifications about switches being toggled)
are picked up by the modem and converted to openHAB status updates by
the binding. The binding also supports sending and receiving of legacy X10 messages.

OpenHAB is not a configuration tool! To configure and set up your devices, link the devices manually via the set buttons, or use the free [Insteon Terminal](https://github.com/pfrommerd/insteon-terminal) software. The free HouseLinc software from Insteon can also be used for configuration, but it wipes the modem link database clean on its initial use, requiring to re-link the modem to all devices.

## Insteon devices

Every Insteon device *type* is uniquely identified by its Insteon
*product key*, a six digit hex number. For some of the older device
types (in particular the SwitchLinc switches and dimmers), Insteon
does not give a product key, so an arbitrary fake one of the format
Fxx.xx.xx (or Xxx.xx.xx for X10 devices) is assigned by the binding.

Finally, each Insteon device comes with a hard-coded Insteon *address*
of the format 'xx.xx.xx' that can be found on a label on the device. This address should be
recorded for every device in the network, as it is a mandatory part of
the binding configuration string. X10 devices are addressed with `houseCode.unitCode`, e.g. `A.2`.

The following devices have been tested and should work out of the box:
<table>
<tr>
<td>Model</td><td>Description</td><td>Product Key</td><td>Comments</td><td>tested by</td>
</tr>
<tr>
<td>2477D</td><td>SwitchLinc Dimmer</td><td>F00.00.01</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2477S</td><td>SwitchLinc Switch</td><td>F00.00.02</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2845-222</td><td>Hidden Door Sensor</td><td>F00.00.03</td><td>battery level available as #data,field=battery_level</td><td>Josenivaldo Benito</td>
</tr>
<tr>
<td>2876S</td><td>ICON Switch</td><td>F00.00.04</td><td></td><td>Patrick Giasson</td>
</tr>
<tr>
<td>2456D3</td><td>LampLinc V2</td><td>F00.00.05</td><td></td><td>Patrick Giasson</td>
</tr>
<tr>
<td>2442-222</td><td>Micro Dimmer</td><td>F00.00.06</td><td></td><td>Josenivaldo Benito</td>
</tr>
<tr>
<td>2453-222</td><td>DIN Rail On/Off</td><td>F00.00.07</td><td></td><td>Josenivaldo Benito</td>
</tr>
<tr>
<td>2452-222</td><td>DIN Rail Dimmer</td><td>F00.00.08</td><td></td><td>Josenivaldo Benito</td>
</tr>
<tr>
<td>2458-A1</td><td>MorningLinc RF Lock Controller</td><td>F00.00.09</td><td>
Read the instructions very carefully: Sync with lock within 5 feet to avoid bad connection, link twice for both ON and OFF functionality.
</td><td>cdeadlock</td>
</tr>
<tr>
<td>2852-222</td><td>Leak Sensor</td><td>F00.00.0A</td><td></td><td>Kirk McCann</td>
</tr>
<tr>
<td>2672-422</td><td>LED Dimmer</td><td>F00.00.0B</td><td></td><td></td>
</tr>
<tr>
<td>2476D</td><td>SwitchLinc Dimmer</td><td>F00.00.0C</td><td></td><td>LiberatorUSA</td>
</tr>
<tr>
<td>2634-222</td><td>On/Off Dual-Band Outdoor Module</td><td>F00.00.0D</td><td></td><td>LiberatorUSA</td>
</tr>
<tr>
<td>2342-2</td><td>Mini Remote</td><td>F00.00.10</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2466D</td><td>ToggleLinc Dimmer</td><td>F00.00.11</td><td></td><td>Rob Nielsen</td>
</tr>
<tr>
<td>2466S</td><td>ToggleLinc Switch</td><td>F00.00.12</td><td></td><td>Rob Nielsen</td>
</tr>
<tr>
<td>2672-222</td><td>LED Bulb</td><td>F00.00.13</td><td></td><td>Rob Nielsen</td>
</tr>
<tr>
<td>2487S</td><td>KeypadLinc On/Off 6-Button</td><td>F00.00.14</td><td>link scene buttons via modem groups</td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2334-232</td><td>KeypadLink Dimmer 6-Button</td><td>F00.00.15</td><td>link scene buttons via modem groups</td><td>Rob Nielsen</td>
</tr>
<tr>
<td>2334-232</td><td>KeypadLink Dimmer 8-Button</td><td>F00.00.16</td><td>link scene button via modem groups</td><td>Rob Nielsen</td>
</tr>
<tr>
<td>2423A1</td><td>iMeter Solo Power Meter</td><td>F00.00.17</td><td></td><td>Rob Nielsen</td>
</tr>
<tr>
<td>2423A1</td><td>Thermostat 2441TH</td><td>F00.00.18</td><td></td><td>Daniel Campbell, Bernd Pfrommer</td>
</tr>
<tr>
<td>2457D2</td><td>LampLinc Dimmer</td><td>F00.00.19</td><td></td><td>Jonathan Huizingh</td>
</tr>
<tr>
<td>2475SDB</td><td>In-LineLinc Relay</td><td>F00.00.1A</td><td></td><td>Jim Howard</td>
</tr>
<tr>
<td>2635-222</td><td>On/Off Module</td><td>F00.00.1B</td><td></td><td>Jonathan Huizingh</td>
</tr>
<tr>
<td>2450</td><td>IO Link</td><td>0x00001A</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2486D</td><td>KeypadLinc Dimmer</td><td>0x000037</td><td></td><td>Patrick Giasson, Joe Barnum</td>
</tr>
<tr>
<td>2484DWH8</td><td>KeypadLinc Countdown Timer</td><td>0x000041</td><td></td><td>Rob Nielsen</td>
</tr>
<tr>
<td>2413U</td><td>PowerLinc 2413U USB modem</td><td>0x000045</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2843-222</td><td>Wireless Open/Close Sensor</td><td>0x000049</td><td></td><td>Josenivaldo Benito</td>
</tr>
<tr>
<td>2842-222</td><td>Motion Sensor</td><td>0x00004A</td><td>battery level available as #data,field=battery_level<br>light level available as #data,field=light_level</td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2486DWH8</td><td>KeypadLinc Dimmer</td><td>0x000051</td><td></td><td>Chris Graham</td>
</tr>
<tr>
<td>2472D</td><td>OutletLincDimmer</td><td>0x000068</td><td></td><td>Chris Graham</td>
</tr>
<tr>
<td>X10 switch</td><td>generic X10 switch</td><td>X00.00.01</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>X10 dimmer</td><td>generic X10 dimmer</td><td>X00.00.02</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>X10 motion</td><td>generic X10 motion sensor</td><td>X00.00.03</td><td></td><td>Bernd Pfrommer</td>
</tr>
</table>

## Insteon Groups and Scenes
How do Insteon devices tell other devices on the network that their state has changed? They send out a broadcast message, labeled with a specific *group* number. All devices (called *responders*) that are configured to listen to this message will then go into a pre-defined state. For instance when light switch A is switched to "ON", it will send out a message to group #1, and all responders will react to it, e.g they may go into the "ON" position as well. Since more than one device can participate, the sending out of the broadcast message and the subsequent state change of the responders is referred to as "triggering a scene". At the device and PLM level, the concept of a "scene" does not exist, so you will find it notably absent in the binding code and this document. A scene is strictly a higher level concept, introduced to shield the user from the details of how the communication is implemented.

Many Insteon devices send out messages on different group numbers, depending on what happens to them. A leak sensor may send out a message on group #1 when dry, and on group #2 when wet. The default group used for e.g. linking two light switches is usually group #1.

## Insteon binding process

Before Insteon devices communicate with one another, they must be
linked. During the linking process, one of the devices
will be the "Controller", the other the "Responder" (see e.g. the
[SwitchLinc Instructions](https://www.insteon.com/pdf/2477S.pdf)).

The responder listens to messages from the controller, and reacts to them. Note that except for
the case of a motion detector (which is just a controller to the
modem), the modem controls the device (e.g. send on/off messages to
it), and the device controls the modem (so the modem learns about the
switch being toggled). For this reason, most devices and in particular
switches/dimmers should be linked twice, with one taking the role of
controller during the first linking, and the other acting as
controller during the second linking process. To do so, first press
and hold the "Set" button on the modem until the light starts
blinking. Then press and hold the "Set" button on the remote device,
e.g. the light switch, until it double beeps (the light on the modem
should go off as well). Now do exactly the reverse: press and hold the
"Set" button on the remote device until its light starts blinking,
then press and hold the "Set" button on the modem until it double
beeps, and the light of the remote device (switch) goes off. Done.

For some of the more sophisticated devices the complete linking process can no longer be done with the set buttons, but requires software like e.g. [Insteon Terminal](https://github.com/pfrommerd/insteon-terminal).

## Installation and Configuration

The binding does not support linking new devices on the fly, i.e. all
devices must be linked with the modem *before* starting the InsteonPLM
binding.

1. Copy the binding (e.g. `openhab.binding.insteonplm-<version>.jar` into the `openhab/addons` folder
2. Edit the relevant section in the openhab configuration file
   (`openhab/configurations/openhab.cfg`). Note that while multiple
   modems and/or hubs can be configured, the binding has never been tested for more
   than *one* port!
3. Add configuration information to the `.items` file (see below)
4. Optional: configure for debug logging into a separate file (see
trouble shooting section)

## Item Binding Configuration

Since Insteon devices can have multiple features (for instance a
switchable relay and a contact sensor) under a single Insteon address,
an openHAB item is not bound to a device, but to a given feature of a
device:

    insteonplm="<insteon_address>:<product_key>#feature[,<parameter>=value, ...]>"

For instance, the following lines would create two Number items referring to the same thermostat device, but to different features of it:

    Number  thermostatCoolPoint "cool point [%.1f °F]" { insteonplm="32.f4.22:F00.00.18#coolsetpoint" }
    Number  thermostatHeatPoint "heat point [%.1f °F]" { insteonplm="32.f4.22:F00.00.18#heatsetpoint" }


The following lines in your insteonplm.items file would configure a
light switch, a dimmer, a motion sensor, and a garage door opener with
contact sensor, a front door lock, a button of a mini remote, a KeypadLinc 2487, and a 6-button keypad dimmer 2334-232:

    Switch officeLight "office light" {insteonplm="24.02.dc:F00.00.02#switch"}
    Dimmer kitchenChandelier "kitchen chandelier" {insteonplm="20.c4.43:F00.00.01#dimmer"}

    Contact garageMotionSensor "motion sensor [MAP(contact.map):%s]" {insteonplm="27.8c.c3:0x00004A#contact"}
    Number garageMotionSensorBatteryLevel "motion sensor battery level [%.1f]" {insteonplm="27.8c.c3:0x00004A#data,field=battery_level"}
    Number garageMotionSensorLightLevel "motion sensor light level [%.1f]" {insteonplm="27.8c.c3:0x00004A#data,field=light_level"}

    Switch garageDoorOpener "garage door opener" <garagedoor> {insteonplm="28.c3.f1:0x00001A#switch"}
    Contact garageDoorContact "garage door contact [MAP(contact.map):%s]"    {insteonplm="28.c3.f1:0x00001A#contact"}

    Switch frontDoorLock "Front Door [MAP(lock.map):%s]" {insteonplm="xx.xx.xx:F00.00.09#switch"}
    Switch miniRemoteContactButton1	    "mini remote button 1" {insteonplm="2e.7c.9a:F00.00.02#buttonA"}

    Switch keypadSwitch    "main load" {insteonplm="xx.xx.xx:F00.00.14#loadswitch"}
    Switch keypadSwitchButtonA   "keypad switch button A"	{insteonplm="xx.xx.xx:F00.00.14#keypadbuttonA,group=2"}

    Dimmer keypadDimmer "dimmer" {insteonplm="xx.xx.xx:F00.00.15#loaddimmer"}
    Switch keypadDimmerButtonA    "keypad dimmer button A"	{insteonplm="xx.xx.xx:F00.00.15#keypadbuttonA,group=2"}
    Dimmer dimmerWithMax "dimmer 2"   {insteonplm="xx.xx.xx:F00.00.11#dimmer,dimmermax=70"}

For the meaning of the ``group`` parameter, please see notes on groups and keypad buttons below.
Note the use of a `MAP(contact.map)`, which should go into the
transforms directory and look like this:

    OPEN=open
    CLOSED=closed
    -=unknown

'MAP(lock.map)`, which should go into the transforms directory and look like this:

    ON=Lock
    OFF=Unlock
    -=unknown

If you have a garage door opener, see the I/O Linc documentation for
the meaning of the `momentary` keyword (not supported/needed for other devices).

Dimmers can be configured with a maximum level when turning a device on or setting a percentage level. If a maximum level is configured, openHAB will never set the level of the dimmer above the level specified. The below example sets a maximum level of 70% for dim 1 and 60% for dim 2:

    Dimmer d1 "dim 1" {insteonplm="xx.xx.xx:F00.00.11#dimmer,dimmermax=70"}
    Dimmer d2 "dim 2" {insteonplm="xx.xx.xx:F00.00.15#loaddimmer,dimmermax=60"}

Setting a maximum level does not affect manual turning on or dimming a switch.

When an Insteon device changes its state because it is directly operated (for example by flipping a switch manually), it sends out a broadcast message to announce the state change, and the binding (if the PLM modem is properly linked as a responder) should update the corresponding openHAB items. Other linked devices however may also change their state in response, but those devices will *not* send out a broadcast message, and so openHAB will not learn about their state change until the next poll. One common scenario is e.g. a switch in a 3-way configuration, with one switch controlling the load, and the other switch being linked as a controller. In this scenario, the "related" keyword can be used to cause the binding to poll a related device whenever a state change occurs for another device. A typical example would be two dimmers (A and B) in a 3-way configuration:

    Dimmer A "dimmer 1" {insteonplm="aa.bb.cc:F00.00.01#dimmer,related=dd.ee.ff"}
    Dimmer B "dimmer 2" {insteonplm="dd.ee.ff:F00.00.01#dimmer,related=aa.bb.cc"}

More than one device can be polled by separating them with "+" sign, e.g. "related=aa.bb.cc+xx.yy.zz" would poll both of these devices.

The iMeter Solo reports both wattage and kilowatt hours, and is updated during the normal polling process of the devices. You can also manually update the current values from the device and reset the device. See the example below:
 
    Number iMeterWatts   "iMeter [%d watts]"  {insteonplm="xx.xx.xx:F00.00.17#meter,field=watts"}
    Number iMeterKwh     "iMeter [%.04f kwh]" {insteonplm="xx.xx.xx:F00.00.17#meter,field=kwh"}
    Switch iMeterUpdate  "iMeter Update"      {insteonplm="xx.xx.xx:F00.00.17#meter,cmd=update"}
    Switch iMeterReset   "iMeter Reset"       {insteonplm="xx.xx.xx:F00.00.17#meter,cmd=reset"}

Here are some examples for configuring X10 devices. Note that X10 switches/dimmers send no status updates, i.e. openHAB will not learn about switches that are toggled manually.

    Switch x10Switch	"X10 switch" {insteonplm="A.1:X00.00.01#switch"}
    Dimmer x10Dimmer	"X10 dimmer" {insteonplm="A.5:X00.00.02#dimmer"}
    Contact x10Motion	"X10 motion" {insteonplm="A.3:X00.00.03#contact"}

### Keypads

The Insteon keypad devices typically control one main load and have a number of buttons that will send out group broadcast messages to trigger a scene. Each button will send out a message for a different group. Complicating matters further, the button numbering used internally by the device must be mapped to whatever labels are printed on the physical buttons of the device. Here is an example correspondence table:

| Group | Button Number | 2487S Label |
|-------|---------------|-------------|
|  0x01 |        1      |   (Load)    |
|  0x03 |        3      |     A       |
|  0x04 |        4      |     B       |
|  0x05 |        5      |     C       |
|  0x06 |        6      |     D       |


### Thermostats

The thermostat (2441TH) is one of the most complex Insteon devices available. It must first be properly linked to the modem using configuration software like [Insteon Terminal](https://github.com/pfrommerd/insteon-terminal). The Insteon Terminal wiki describes in detail how to link the thermostat, and how to make it publish status update reports.

When all is set and done the modem must be configured as a controller to group 0 (not sure why), and a responder to groups 1-5 such that it picks up when the thermostat switches on/off heating and cooling etc, and it must be a responder to special group 0xEF to get status update reports when measured values (temperature) change. Symmetrically, the thermostat must be a responder to group 0, and a controller for groups 1-5 and 0xEF. The linking process is not difficult but needs some persistence. Again, refer to the [Insteon Terminal](https://github.com/pfrommerd/insteon-terminal) documentation.

**Items**

This is an example of what to put into your .items file:

    Number  thermostatCoolPoint "cool point [%.1f °F]" { insteonplm="32.f4.22:F00.00.18#coolsetpoint" }
    Number  thermostatHeatPoint "heat point [%.1f °F]" { insteonplm="32.f4.22:F00.00.18#heatsetpoint" }
    Number  thermostatSystemMode "system mode [%d]" { insteonplm="32.f4.22:F00.00.18#systemmode" }
    Number  thermostatFanMode "fan mode [%d]" { insteonplm="32.f4.22:F00.00.18#fanmode" }
    Number  thermostatIsHeating "is heating [%d]" { insteonplm="32.f4.22:F00.00.18#isheating"}
    Number  thermostatIsCooling "is cooling [%d]" { insteonplm="32.f4.22:F00.00.18#iscooling"}
    Number  thermostatTempFahren  "temperature [%.1f °F]" { insteonplm="32.f4.22:F00.00.18#tempfahrenheit" }
    Number  thermostatTempCelsius  "temperature [%.1f °C]" { insteonplm="32.f4.22:F00.00.18#tempcelsius" }
    Number  thermostatHumidity "humidity [%.0f %%]" { insteonplm="32.f4.22:F00.00.18#humidity" }

Add this as well for some more exotic features:

    Number  thermostatACDelay "A/C delay [%d min]"  { insteonplm="32.f4.22:F00.00.18#acdelay" }
    Number  thermostatBacklight "backlight [%d sec]" { insteonplm="32.f4.22:F00.00.18#backlightduration" }
    Number  thermostatStage1 "A/C stage 1 time [%d min]" { insteonplm="32.f4.22:F00.00.18#stage1duration" }
    Number  thermostatHumidityHigh "humidity high [%d %%]" { insteonplm="32.f4.22:F00.00.18#humidityhigh" }
    Number  thermostatHumidityLow "humidity low [%d %%]"  { insteonplm="32.f4.22:F00.00.18#humiditylow" }


**Sitemap**

For the thermostat to display in the GUI, add this to the sitemap file:

    Text   item=thermostatTempCelsius icon="temperature"
    Text   item=thermostatTempFahren icon="temperature"
    Text   item=thermostatHumidity
    Setpoint item=thermostatCoolPoint icon="temperature" minValue=63 maxValue=90 step=1
    Setpoint item=thermostatHeatPoint icon="temperature" minValue=50 maxValue=80 step=1
    Switch item=thermostatSystemMode  label="system mode" mappings=[ 0="OFF",  1="HEAT", 2="COOL", 3="AUTO", 4="PROGRAM"]
    Switch item=thermostatFanMode  label="fan mode" mappings=[ 0="AUTO",  1="ALWAYS ON"]
    Switch item=thermostatIsHeating  label="is heating" mappings=[ 0="OFF",  1="HEATING"]
    Switch item=thermostatIsCooling  label="is cooling" mappings=[ 0="OFF",  1="COOLING"]
    Setpoint item=thermostatACDelay  minValue=2 maxValue=20 step=1
    Setpoint item=thermostatBacklight  minValue=0 maxValue=100 step=1
    Setpoint item=thermostatHumidityHigh  minValue=0 maxValue=100 step=1
    Setpoint item=thermostatHumidityLow   minValue=0 maxValue=100 step=1
    Setpoint item=thermostatStage1  minValue=1 maxValue=60 step=1

## Insteon groups and how to enable buttons on the keypads
When a button is pressed on a keypad button, a broadcast message is sent out on the Insteon network to all members of a pre-configured group. Let's say you press the keypad button A on a 2487S, it will send out a message to group 3. You first need to configure your modem to be a responder to that group. That can be simply done by pressing the keypad button and then holding the set button (for details see instructions), just as for any Insteon device. After this step, the binding will be notified whenever you press a keypad button, and you can configure a Switch item that will reflect its state. However, if the switch is flipped from within openHAB, the keypad button will not update its state. For that you need to configure the keypad button to be a responder to broadcast messages on a given Insteon group. Use the  [Insteon Terminal](https://github.com/pfrommerd/insteon-terminal) to get the button configured, such that the keypad button responds to modem broadcast messages on e.g modem group 2. Then add the parameter ``group=2`` to the binding config string (see example above). Now toggling the switch item will send out a broadcast message to group 2, which should toggle the keypad button. You need to configure each button into a different modem group to switch them separately.

## Trouble shooting

To get additional debugging information, insert the following into
your `logback.xml` file:

    <appender name="INSTEONPLMFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/insteonplm.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>logs/insteonplm-%d{yyyy-ww}.log.zip</fileNamePattern>
        <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
                <pattern>%d{yyyy-MM-dd HH:mm:ss} %-5level %logger{30}[:%line]- %msg%n%ex{5}</pattern>
        </encoder>
    </appender>
    <!-- Change DEBUG->TRACE for even more detailed logging -->
    <logger name="org.openhab.binding.insteonplm" level="DEBUG" additivity="false">
    <appender-ref ref="INSTEONPLMFILE" />
    </logger>

This will log additional debugging messages to a separate file in the
log directory.

### Adding new device types (using existing device features)

Device types are defined in the file `device_types.xml`, which is inside the InsteonPLM bundle and thus not visible to the user. You can however load your own device_types.xml by referencing it in the openhab.cfg file like so:

    insteonplm:more_devices=/usr/local/openhab/rt/my_own_devices.xml

Where the `my_own_devices.xml` file defines a new device like this:

    <xml>
     <device productKey="F00.00.XX">
      <model>2456-D3</model>
      <description>LampLinc V2</description>
      <feature name="dimmer">GenericDimmer</feature>
      <feature name="lastheardfrom">GenericLastTime</feature>
     </device>
    </xml>

Finding the Insteon product key can be tricky since Insteon has not updated the product key table (http://www.insteon.com/pdf/insteon_devcats_and_product_keys_20081008.pdf) since 2008. If a web search does not turn up the product key, make one up, starting with "F", like: F00.00.99. Avoid duplicate keys by finding the highest fake product key in the `device_types.xml` file, and incrementing by one.

### Adding new device features

If you can't can't build a new device out of the existing device features (for a complete list see `device_features.xml`) you can add new features by specifying a file (let's call it `my_own_features.xml`) with the "more_devices" option in the `openhab.cfg` file:

    insteonplm:more_features=/usr/local/openhab/rt/my_own_features.xml

  In this file you can define your own features (or even overwrite an existing feature). In the example below a new feature "MyFeature" is defined, which can then be referenced from the `device_types.xml` file (or from `my_own_devices.xml`):

    <xml>
     <feature name="MyFeature">
	 <message-dispatcher>DefaultDispatcher</message-dispatcher>
	 <message-handler cmd="0x03">NoOpMsgHandler</message-handler>
	 <message-handler cmd="0x06">NoOpMsgHandler</message-handler>
	 <message-handler cmd="0x11">NoOpMsgHandler</message-handler>
	 <message-handler cmd="0x13">NoOpMsgHandler</message-handler>
	 <message-handler cmd="0x19">LightStateSwitchHandler</message-handler>
	 <command-handler command="OnOffType">IOLincOnOffCommandHandler</command-handler>
	 <poll-handler>DefaultPollHandler</poll-handler>
     </feature>
    </xml>

If you cannot cobble together a suitable device feature out of existing handlers you will have to define new ones by editing the corresponding Java classes in the source tree (see below).

### Adding new handlers (for developers experienced with Eclipse IDE)

If all else fails there are the Java sources, in particular the classes MessageHandler.java (what to do with messages coming in from the Insteon network), PollHandler.java (how to form outbound messages for device polling), and CommandHandler.java (how to translate openhab commands to Insteon network messages). To that end you'll need to become a bonafide openHAB developer, and set up an openHAB Eclipse build environment, following the online instructions. Before you write new handlers have a good look at the existing ones, they are quite flexible and configurable via parameters in `device_features.xml`.

## Known Limitations and Issues

1. Devices cannot be linked to the modem while the binding is
running. If new devices are linked, the binding must be restarted.
2. Setting up Insteon groups and linking devices cannot be done from within openHAB. Use the [Insteon Terminal](https://github.com/pfrommerd/insteon-terminal) for that.
3. Very rarely during binding startup, a message arrives at the modem while the initial read of the modem
database happens. Somehow the modem then stops sending the remaining link records and the binding no longer is able to address the missing devices. The fix is to simply restart the binding.