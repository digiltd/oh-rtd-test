## Introduction

Insteon is a home area networking technology developed primarily for
connecting light switches and loads. Insteon devices send messages
either via the power line, or by means of radio frequency (RF) waves,
or both (dual-band). A considerable number of Insteon compatible
devices such as switchable relays, thermostats, sensors etc are
available. More about Insteon can be found on [Wikipedia](http://en.wikipedia.org/wiki/Insteon).

This binding provides access to the Insteon network by means of an
Insteon PowerLinc Modem (PLM). The modem can be connected to the
openHAB server either via a serial port (Model 2413S) or a USB port
(Model 2413U). The binding translates openHAB commands into Insteon
messages and sends them on the Insteon network. Relevant messages from
the Insteon network (like notifications about switches being toggled)
are picked up by the modem and converted to openHAB status updates by
the binding.

## Insteon devices

Every Insteon device *type* is uniquely identified by its Insteon
*product key*, a six digit hex number. For some of the older device
types (in particular the SwitchLinc switches and dimmers), Insteon
does not give a product key, so an arbitrary fake one of the format
Fxx.xx.xx is assigned by the binding.

Finally, each Insteon device comes with a hard-coded Insteon *address*
that can be found on a label on the device. This address should be
recorded for every device in the network, as it is a mandatory part of
the binding configuration string.

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
<td>2845-222</td><td>Hidden Door Sensor</td><td>F00.00.03</td><td></td><td>Benido Josenivaldo</td>
</tr>
<tr>
<td>2876S</td><td>ICON Switch</td><td>F00.00.04</td><td></td><td>Patrick Giasson</td>
</tr>
<tr>
<td>2456D3</td><td>LampLinc V2</td><td>F00.00.05</td><td></td><td>Patrick Giasson</td>
</tr>
<tr>
<td>2442-222</td><td>Micro Dimmer</td><td>F00.00.06</td><td></td><td>Benido Josenivaldo</td>
</tr>
<tr>
<td>2453-222</td><td>DIN Rail On/Off</td><td>F00.00.07</td><td></td><td>Benido Josenivaldo</td>
</tr>
<tr>
<td>2452-222</td><td>DIN Rail Dimmer</td><td>F00.00.08</td><td></td><td>Benido Josenivaldo</td>
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
<td>2342-2</td><td>Mini Remote</td><td>F00.00.10</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2450</td><td>IO Link</td><td>0x00001A</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2486D</td><td>KeypadLinc Dimmer</td><td>0x000037</td><td></td><td>Patrick Giasson</td>
</tr>
<tr>
<td>2413U</td><td>PowerLinc 2413U USB modem</td><td>0x000045</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2843-222</td><td>Wireless Open/Close Sensor</td><td>0x000049</td><td></td><td>Benido Josenivaldo</td>
</tr>
<tr>
<td>2842-222</td><td>Motion Sensor</td><td>0x00004A</td><td></td><td>Bernd Pfrommer</td>
</tr>
<tr>
<td>2486DWH8</td><td>KeypadLinc Dimmer</td><td>0x000051</td><td></td><td>Chris Graham</td>
</tr>
<tr>
<td>2472D</td><td>OutletLincDimmer</td><td>0x000068</td><td></td><td>Chris Graham</td>
</tr>
</table>

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

## Installation and Configuration

The binding does not support linking new devices on the fly, i.e. all
devices must be linked with the modem *before* starting the InsteonPLM
binding. Each device has an Insteon address of the format 'xx.xx.xx'
which can usually be found on a label on the device.

1. Copy the binding (e.g. `openhab.binding.insteonplm-<version>.jar` into the `openhab/addons` folder
2. Edit the relevant section in the openhab configuration file
   (`openhab/configurations/openhab.cfg`). Note that while multiple
   modems are possible, the binding has never been tested for more
   than *one* modem!
3. Add configuration information to the `.items` file (see below)
4. Optional: configure for debug logging into a separate file (see
trouble shooting section)

## Item Binding Configuration

Since Insteon devices can have multiple features (for instance a
switchable relay and a contact sensor) under a single Insteon address,
an openHAB item is not bound to a device, but to a given feature of a
device:

    insteonplm="<insteon_address>:<product_key>#feature[,<parameter>=value, ...]>"

The following lines in your insteonplm.items file would configure a
light switch, a dimmer, a motion sensor, and a garage door opener with
contact sensor, a front door lock, and a button of a mini remote:

    Switch officeLight "office light" (office,lights) {insteonplm="24.02.dc:F00.00.02#switch"}
    Dimmer kitchenChandelier "kitchen chandelier" (kitchen,lights) {insteonplm="20.c4.43:F00.00.01#dimmer"}
    Contact garageMotionSensor "motion sensor [MAP(contact.map):%s]" (garage,contacts) {insteonplm="27.8c.c3:0x00004A#contact"}
    Switch garageDoorOpener "garage door opener" <garagedoor>  (garage,openers) {insteonplm="28.c3.f1:0x00001A#switch"}
    Contact garageDoorContact "garage door contact [MAP(contact.map):%s]" (garage,contacts)     {insteonplm="28.c3.f1:0x00001A#contact"}
    Switch frontDoorLock "Front Door [MAP(lock.map):%s]" {insteonplm="xx.xx.xx:F00.00.09#switch"}
    Switch miniRemoteContactButton1	    "mini remote button 1" (garage,lights){insteonplm="2e.7c.9a:F00.00.02#switch,button=1"}

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

## Removing devices from the Modem's link database

When an Insteon device breaks or is no longer needed, it should be
removed from them modem's link database. Since this is particularly tricky
if the device is no longer operable, the binding has
a rudimentary feature to eliminate entries: Instantiate a `Switch` item in the `.items` file,
referencing the modem with its proper Insteon address:

    Switch removeAddress		    "switch to remove address"	  	(gControllers)			{insteonplm="1E.DB.41:0x000045#control,remove_address=2e.7c.9a"}

In the binding config, a `control` feature is referenced, and the address of the device
to be removed from the modem is passed as parameter `remove_address`. Toggling the switch
to `ON` will send a command to the modem, erasing the db entry.

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

### Adding new device features (for developers experienced with Eclipse IDE)

If you can't can't build a new device out of the existing device features (for a complete list see `device_features.xml`), you need to set up an openHAB Eclipse build environment, following the online instructions. Then find the `device_features.xml` file under the InsteonPLM binding directory, and define  a new feature (in this case "MyFeature") which can then be referenced from the `device_types.xml` file:

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

If you cannot cobble together a suitable device feature out of existing handlers you will have to define new ones by editing the corresponding Java classes in the source tree.

## Known Limitations and Issues

1. Devices cannot be linked to the modem while the binding is
running. If new devices are linked, the binding must be restarted.
2. Very rarely during binding startup, a message arrives at the modem while the initial read of the modem
database happens. Somehow the modem then stops sending the remaining link records and the binding no longer is able to address the missing devices. The fix is to simply restart the binding.