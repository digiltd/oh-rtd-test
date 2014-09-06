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

1. Insteon PowerLinc Modem 2413U V1.5, USB modem, product key: 0x000045
2. Insteon SwitchLinc 2477S, switch, (fake) product key: F00.00.02
3. Insteon SwitchLinc 2477D, dimmer, (fake) product key: F00.00.01
4. Insteon I/O Linc 2450, garage door opener kit (relay + contact
   closure), product key:0x00001A
5. Insteon Wireless Motion Sensor 2842, motion sensor, product key: 0x00004A
6. Insteon Hidden Door Sensor 2845-222, (fake) product key: F00.00.03
7. Insteon MorningLinc RF Lock Controller 2458-A1, (fake) product key: F00.00.09
** Read the instructions very carefully: Sync with lock within 5 feet to avoid bad connection, link twice for both ON and OFF functionality.
7. Insteon KeypadLinc Dimmer 2486DWH8, product key: 0x000051
8. Insteon OutletLinc 2472D, product key: 0x000068
9. Insteon Mini Remote Model 2342-2, scene switch, (fake) product key: F00.00.0A

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
removed from them modem's link database. This is particularly tricky
if the device is no longer operable. For this purpose the binding has
a rudimentary feature to eliminate entries from the link database.

This requires a `Number` item in the insteonplm.items file,
referencing the modem:

    Number modem "modem" {insteonplm="1E.DF.41:0x000045#control"}

and an entry in the `sitemap` file like this:

    Selection item=modem label="modem action" mappings=[0=nothing, 1=erase]

Upon startup, the binding creates a list of Insteon devices that are
in the modem's link database, but *not* referenced anywhere in the
items file. Now every time the `erase` selection is made from the user
interface, *one* of the unreferenced devices will be eliminated from the
link database (erasing *all* unreferenced devices was deemed risky as it
could accidentally wipe out the entire database of the modem).

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

### Adding new device types (for developers experienced with Eclipse IDE)

First, set up an Eclipse build environment following the online instructions. Then find the categories.xml file under the InsteonPLM binding directory, and add your device under the proper category and subcategory (as published by Insteon) with a few lines like these, appropriately modified:

   <subcategory>
    <name>KepadLinc Dimmer</name>
    <description>2486D</description>
    <subCat>0x09</subCat>
    <productKey name="0x000037">
    	<feature name="dimmer">GenericDimmer</feature>
    	<feature name="lastheardfrom">GenericLastTime</feature>
    </productKey>
  </subcategory>

Finding the Insteon product key can be tricky since Insteon has not updated the product key table (http://www.insteon.com/pdf/insteon_devcats_and_product_keys_20081008.pdf) since 2008. Sometimes a web search will turn up the category/subcategory/product key. If you absolutely cannot find the product key, make one up, starting with "F", like: F00.00.99. To avoid duplicate keys, find the highest fake product key in the categories.xml file, and increment by one.

The features referenced in the categories.xml file (e.g. GenericDimmer) are defined in the file device_features.xml, which defines the message handlers that run when Insteon messages with different "cmd" codes arrive. The feature definition also specifies the command handlers which translate openHAB commands into insteon messages.

    <feature name="GenericDimmer">
insteonplm="<insteon_address>:<product_key>#feature[,<parameter>=value, ...]>"
    <feature name="GenericDimmer">
        <message-dispatcher>DefaultDispatcher</message-dispatcher>
        <message-handler cmd="0x03">NoOpMsgHandler</message-handler>
        <message-handler cmd="0x06">NoOpMsgHandler</message-handler>
        <message-handler cmd="0x11">LightOnDimmerHandler</message-handler>
        <message-handler cmd="0x13">LightOffHandler</message-handler>
        <message-handler cmd="0x17">NoOpMsgHandler</message-handler>
        <message-handler cmd="0x18">StopManualChangeHandler</message-handler>
        <message-handler cmd="0x19">LightStateDimmerHandler</message-handler>
        <command-handler command="PercentType">PercentHandler</command-handler>
        <command-handler command="OnOffType">LightOnOffCommandHandler</command-handler>
        <poll-handler>DefaultPollHandler</poll-handler>
    </feature>



   <feature name="GenericDimmer">
	<message-dispatcher>DefaultDispatcher</message-dispatcher>
	<message-handler cmd="0x03">NoOpMsgHandler</message-handler>
	<message-handler cmd="0x06">NoOpMsgHandler</message-handler>
	<message-handler cmd="0x11">LightOnDimmerHandler</message-handler>
	<message-handler cmd="0x13">LightOffHandler</message-handler>
	<message-handler cmd="0x17">NoOpMsgHandler</message-handler>
	<message-handler cmd="0x18">StopManualChangeHandler</message-handler>
	<message-handler cmd="0x19">LightStateDimmerHandler</message-handler>
	<command-handler command="PercentType">PercentHandler</command-handler>
	<command-handler command="OnOffType">LightOnOffCommandHandler</command-handler>
	<poll-handler>DefaultPollHandler</poll-handler>
   </feature>

If you cannot achieve the desired outcome by cobbling together a set of suitable message and command handlers, you will have to write your own, hopefully just having to touch the DeviceFeatures.java file.

## Known Limitations and Issues

1. Devices cannot be linked to the modem while the binding is
running. If new devices are linked, the binding must be restarted.
2. No simple way to selectively eliminate a given Insteon device
address from the modem's link database.
3. Very rarely during binding startup, a message arrives at the modem while the initial read of the modem
database happens. Somehow the modem then stops sending the remaining link records and the binding no longer is able to address the missing devices. The fix is to simply restart the binding.
4. Users of HouseLinc have reported that it deletes important device information from the modem link database. The latest version of the InsteonPLM binding tries to recover from such situations by querying the devices.