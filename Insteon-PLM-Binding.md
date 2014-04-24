_**Note:** This Binding will be available in the upcoming 1.5 Release. For preliminary builds please see the [CI server at Cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/)._

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

Support for the following devices is in the works, and should be supported in upcoming releases:

6. Insteon KeypadLinc Dimmer 2486DWH8, product key: 0x000051
7. Insteon OutletLinc 2472D, product key: 0x000068

### Adding new device types (only for the desperate, skip this for now)

Currently adding new device types is cumbersome (will be easier in upcoming releases). Here a rough outline of what needs to be done.

First, you need to set up a build environment, following the online instructions. Then find the categories.xml file under the InsteonPLM binding directory, and add your device under the proper category and subcategory (as published by Insteon) with a few lines like these, appropriately modified:

  <subcategory>
    <name>FooLinc Dimmer</name>
    <description>2666D</description>
    <subCat>0xYOURSUBCATHEX</subCat>
    <productKey name="0xYOURPRODUCTKEYHEX">
    	<feature name="dimmer">2666Ddimmer</feature>
    	<feature name="lastheardfrom">2666Dlasttime</feature>
    </productKey>
  </subcategory>

Then in DeviceFeatures.java, find a device that kinda matches yours, and add another term to the conditional like this, to support the "dimmer" feature:
 else	if ( (s.equals("2477Ddimmer") || s.equals("2472Ddimmer") || s.equals("2666Ddimmer") ) )
and another one for the "lasttime" feature:
 else	if ( (s.equals("2477Dlasttime") || s.equals("2472Dlasttime") || s.equals("2666Dlasttime") )

The term added (in this case "2666Ddimmer") must match the string used in the <feature name="dimmer"> line in the categories.xml file, and same for the "lastheardfrom" feature. Just follow the pattern in the code.

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
contact sensor:

    Switch officeLight "office light" (office,lights) {insteonplm="24.02.dc:F00.00.02#switch"}
    Dimmer kitchenChandelier "kitchen chandelier" (kitchen,lights) {insteonplm="20.c4.43:F00.00.01#dimmer"}
    Contact garageMotionSensor "motion sensor [MAP(contact.map):%s]" (garage,contacts) {insteonplm="27.8c.c3:0x00004A#contact"}
    Switch garageDoorOpener "garage door opener" <garagedoor>  (garage,openers) {insteonplm="28.c3.f1:0x00001A#switch,momentary=3000"}
    Contact garageDoorContact "garage door contact [MAP(contact.map):%s]" (garage,contacts)     {insteonplm="28.c3.f1:0x00001A#contact"}


Note the use of a `MAP(contact.map)`, which should go into the
transforms directory and look like this:

    OPEN=open
    CLOSED=closed
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

This will log additional debugging messages to a separate file in the
log directory.

## Known Limitations

1. Devices cannot be linked to the modem while the binding is
running. If new devices are linked, the binding must be restarted.
2. No simple way to selectively eliminate a given Insteon device
address from the modem's link database.

