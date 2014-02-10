Documentation of the TinkerForge binding bundle

## Introduction

[TinkerForge](http://www.tinkerforge.com) is a system of open source hardware building blocks that 
allows you to combine sensor and actuator blocks by plug and play. You can create your individual 
hardware system by choosing the necessary building blocks for your project and combine it with other 
home automation products. There are many blocks available e.g for temperature, humidity or air pressure 
measurement as well as for I/O, LCDs and motor control. You will find a complete List of available 
blocks [here](http://www.tinkerforge.com/en/doc/Product_Overview.html).

This binding connects the [TinkerForge](http://tinkerforge.com) devices to the openHAB event bus. 
Sensor values from devices are made available to openHAB and actions on  devices can be triggered by 
openHAB.

For now only a subset of the TinkerForge devices and features are supported, but more devices and 
features will be added in the near future.

The following devices are supported for now:
- Servo Brick
- DC Brick
- Dual Relay Bricklet
- Humidity Bricklet
- Distance IR Bricklet
- Temperature Bricklet
- Barometer Bricklet (barometer and temperature device)
- Ambient Light Bricklet
- LCD 20×4 Bricklet (LCD, backlight and 4 buttons)
- Industrial Quad Relay
- Bricklet Industrial Digital In 4
- Bricklet IO-16

The TinkerForge binding bundle is available as a separate (optional) download. For installation of 
the binding, please see Wiki page [[Bindings]].

## Upgrading from 1.3
- LCDBacklight now is a sub device of LCD20x4 Bricklet (items file has to be changed)
- LCD20x4Button now posts an update not a command anymore (rules has to be changed)
- IndustrialQuadRelay sub id numbering now starts from zero (items file has to be changed) 

## General Remarks
The binding supports the connection to several brickd instances.

The binding supports the TinkerForge auto reconnect feature. Furthermore even if the initial connect 
failed the binding will make retries to get connected to the brickd.

## Generic Item Binding Configuration

### Basic Configuration

In order to connect openHAB to TinkerForge devices you need to define all the brickd hosts and ports 
in the openhab.cfg file.

The following properties must be configured to define a brickd connection:

    tinkerforge:hosts="<IP address>[:port] ..."

The properties indicated by '<...>' need to be replaced with an actual value. Properties surrounded 
by square brackets are optional.

| <b>Property</b> | <b>Description</b> |
| --------------- | ------------------ |
| IP address | IP address of the brickd |
| port | The listening port of of the brickd (optional, default 4223) |

For connecting several brickds, use multiple &lt;IP address&gt; statements delimited by a space.

Devices which do not support callbacks will be polled with a configurable interval, the default
 is 60000 milliseconds. This value can be changed in openhab.cfg:
 
    tinkerforge.refresh=<value in milliseconds>


### Example Configurations

Example for a connection to a single brickd:

    tinkerforge:hosts=127.0.0.1

Example for several brickd connections using different ports:

    tinkerforge:hosts=127.0.0.1:4224 192.168.1.50 192.168.1.104

## Advanced Configuration

There are several configuration parameters to control the behavior of the devices. The available 
parameters depend on the device type.

### Overview
For most of the devices **no configuration** is needed in openhab.cfg, they can be used with reasonable 
defaults. The only exception is the IO16 Bricklet (see below).

If you want to get rid of _uid_ and _subid_ statements in the items or rule file, you can use openhab.cfg 
to get a _symbolic name_.

A configuration line for a TinkerForge Device looks like this in openhab.cfg:

    tinkerforge:<symbolic name>.<property>=<value>

The *symbolic name* string can be used in the items configuration as an alternative for the uid and subid values.

The following table lists the general available properties.

|<b>Property</b>|<b>Description</b>|<b>Device</b>|
|---------------|------------------|-------------|
|uid|TinkerForge uid of the device (use the Brick Viewer to get this value)|mandatory for all devices|
|type|the device type|mandatory for all devices|
|subid|  subid of the device, subid's are used if a brick/bricklet houses more then one device (e.g. the Dual Relay Bricklet)|mandatory for sub devices|

The following table shows the TinkerForge device, its device type, subid and if it is an actuator.

|<b>device</b>|<b>type name</b>|<b>subid(s)</b>|<b>Callback</b>|<b>actuator</b>|
|-------------|----------------|---------------|---------------|---------------|
|servo connector housed on a Servo Brick|servo|servo[0-6]||x|
|DC Brick|brick_dc|||x|
|relays housed on a Dual Relay Bricklet|dual_relay|relay[1-2]||x|
|Humidity Bricklet|bricklet_humidity||x||
|Distance IR Bricklet|bricklet_distance_ir||x||
|Temperature Bricklet|bricklet_temperature||x||
|Barometer Bricklet|bricklet_barometer||x||
|temperature sensor housed on a Barometer Bricklet|barometer_temperature|temperature|||
|Ambient Light Bricklet|bricklet_ambient_light||x||
|LCD20x4 Bricklet|bricklet_LCD20x4|||x|
|LCD20x4 backlight|backlight|backlight||x|
|button housed on a LCD20x4 Bricklet|lcd_button|button[0-3]|interrupt||
|relays housed on a Industrial Quad Relay Bricklet|industrial_quad_relay|relay[0-3]||x|
|input ports housed on a Industrial Digital In 4 Bricklet|bricklet_industrial_digital_4in|in[0-3]|x||
|IO16 Bricklet|bricklet_io16||||
|ports housed on a IO16 Bricklet, which should be used as input ports|iosensor|in[ab][0-7]|x||
|ports housed on a IO16 Bricklet, which should be used as output ports|io_actuator|out[ab][0-7]||x|

### Callback and Threshold

The TinkerForge CallbackListeners - if available - are used to observe the sensor values of the 
devices. These listeners are configured to update sensor values at a given time period 
(callbackPeriod). The default configuration sets the **callbackPeriod** to 1 second. This value can 
be changed in openhab.cfg. For now this value must be changed for every single device. The values 
must be given in milliseconds.

The callbackPeriod controls the amount of traffic from the TF hardware to the binding.

In addition to the Callback a **threshold value** can be configured. This threshold means that even 
if the listener reports a changed value, the value is only send to the openHAB eventbus if: the 
difference between the last value and the current value is bigger than the threshold value. You can 
think of it as a kind of hysteresis, it dampens the oscillation of openHAB item values.

The threshold controls the amount of  traffic from the binding to the openHAB eventbus.

### Devices
#### Dual Relay Bricklet
An entry in openhab.cfg is only needed if you want to use a _symbolic name_ in the items file.

bricklet:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | bricklet_dual_relay |

relay sub devices:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | same as bricklet |
| subid | openHAB subid of the device | relay1, relay2 |
| type | openHAB type name | dual_relay |

openhab.cfg:

    tinkerforge:relay_coffee_machine.uid=c21
    tinkerforge:relay_coffee_machine.type=dual_relay
    tinkerforge:relay_coffee_machine.subid=relay1

    tinkerforge:relay_garage_door.uid=c21
    tinkerforge:relay_garage_door.type=dual_relay
    tinkerforge:relay_garage_door.subid=relay2

items file entry (e.g. tinkerforge.items):

    Switch DualRelay1          "DualRelay1" { tinkerforge="name=relay_coffee_machine" }
    Switch DualRelay2          "DualRelay2" { tinkerforge="uid=c21, subid=relay2" }

sitemap file entry (e.g tinkerforge.sitemap):

    Switch item=DualRelay1
    Switch item=DualRelay2

#### Humidity Bricklet
An entry in openhab.cfg is only needed if you want to adjust threshold and / or callbackPeriod or 
if you want to use a _symbolic name_.

openhab.cfg:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | bricklet_humidity |
| threshold | | see "Callback and Threshold" |
| callbackPeriod | | see "Callback and Threshold" |

    tinkerforge:humidity_balcony.uid=b2j
    tinkerforge:humidity_balcony.type=bricklet_humidity
    tinkerforge:humidity_balcony.threshold=1
    tinkerforge:humidity_balcony.callbackPeriod=10


items file entry (e.g. tinkerforge.items):

    Number Humidity                 "Humidity [%.1f %%]"  { tinkerforge="uid=b2j" }

sitemap file entry (e.g tinkerforge.sitemap):

    Text item=Humidity

#### Distance IR Bricklet
An entry in openhab.cfg is only needed if you want to adjust threshold and / or callbackPeriod or 
if you want to use a _symbolic name_.

openhab.cfg:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | bricklet_distance_ir |
| threshold | | see "Callback and Threshold" |
| callbackPeriod | | see "Callback and Threshold" |

    tinkerforge:distance_door.uid=6GN
    tinkerforge:distance_door.type=bricklet_distance_ir
    tinkerforge:distance_door.threshold=1
    tinkerforge:distance_door.callbackPeriod=10

items file entry (e.g. tinkerforge.items):

    Number Distance                 "Distance [%.1f mm]"  { tinkerforge="uid=6GN" }

sitemap file entry (e.g tinkerforge.sitemap):

    Text item=Distance

#### Temperature Bricklet
An entry in openhab.cfg is only needed if you want to adjust threshold and / or callbackPeriod or 
if you want to use a _symbolic name_.

openhab.cfg:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | bricklet_temperature |
| threshold | | see "Callback and Threshold" |
| callbackPeriod | | see "Callback and Threshold" |

    tinkerforge:barometer_balcony.uid=etd
    tinkerforge:barometer_balcony.type=bricklet_temperature
    tinkerforge:barometer_balcony.callbackPeriod=10000
    tinkerforge:barometer_balcony.threshold=1000

items file entry (e.g. tinkerforge.items):

    Number Temperature                 "Temperature [%.1f Cel]"  { tinkerforge="uid=etd" }

sitemap file entry (e.g tinkerforge.sitemap):

    Text item=Temperature

#### Barometer Bricklet
An entry in openhab.cfg is only needed if you want to adjust threshold and / or callbackPeriod or 
if you want to use a _symbolic name_.

The temperature sub device does not support callbackPeriod, it will be polled. The polling interval 
can be configured using tinkerforge:refresh property).

bricklet:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | bricklet_barometer |
| threshold | | see "Callback and Threshold" |
| callbackPeriod | | see "Callback and Threshold" |

temperature sub device:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| subid | openHAB subid of the device | temperature |
| type | openHAB type name | barometer_temperature |

openhab.cfg:

    tinkerforge:barometer_balcony.uid=d8G
    tinkerforge:barometer_balcony.type=bricklet_barometer
    tinkerforge:barometer_balcony.callbackPeriod=10000
    tinkerforge:barometer_balcony.threshold=1000

items file entry (e.g. tinkerforge.items):

    Number Barometer                 "Air Pressure [%.1f hPa]"  { tinkerforge="uid=d8G" }

sitemap file entry (e.g tinkerforge.sitemap):

    Text item=Barometer

#### Ambient Light Bricklet
An entry in openhab.cfg is only needed if you want to adjust threshold and / or callbackPeriod or 
if you want to use a _symbolic name_.

bricklet:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | bricklet_ambient_light |
| threshold | | see "Callback and Threshold" |
| callbackPeriod | | see "Callback and Threshold" |

openhab.cfg:

    tinkerforge:luminance_balcony.uid=ef5
    tinkerforge:luminance_balcony.type=bricklet_ambient_light
    tinkerforge:luminance_balcony.threshold=1
    tinkerforge:luminance_balcony.callbackPeriod=10

items file entry (e.g. tinkerforge.items):

    Number AmbientLight            "Luminance [%.1f Lux]" { tinkerforge="uid=ef5" }

sitemap file entry (e.g tinkerforge.sitemap):

    Text item=AmbientLight 

#### LCD20x4 Bricklet

The LCD20x4 is a bit special as it acts as actuator which can receive text messages. To 
achieve this, you have to configure the device as String item.


What’s the meaning of this magic string?

    sendCommand(TF_LCD, String::format("TFNUM<213>%4s"Barometer.state.format("%d")
                      ))

TFNUM is just a flag to signal the binding that some position information is passed. The first 
number is the line number, starting from 0. The second and third number are interpreted as the 
position in the line, starting from 0. 

The above example would write the current value of the barometer bricklet to line 3 starting from 
position 14, with a fixed width of 4 (this is because of %4s).

openhab.cfg:

bricklet:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | bricklet_LCD20x4 |

backlight sub device:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | same as bricklet |
| subid | openHAB subid of the device | backlight |
| type | openHAB type name | backlight |

button sub devices:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | same as bricklet |
| subid | openHAB subid of the device | button0, button1, button2, button3 |
| type | openHAB type name | lcd_button |


items file entry (e.g. tinkerforge.items):

    String LCD         "LCD" { tinkerforge="uid=d4j"}
    Switch LCDBacklight        "LCDBacklight" { tinkerforge="uid=d4j, subid=backlight"}
    Switch Button0         "Button0" { tinkerforge="uid=d4j, subid=button0"}
    Switch Button1         "Button1" { tinkerforge="uid=d4j, subid=button1"}
    Switch Button2         "Button2" { tinkerforge="uid=d4j, subid=button2"}
    Switch Button3         "Button3" { tinkerforge="uid=d4j, subid=button3"}

sitemap file entry (e.g tinkerforge.sitemap):

    Switch item=LCDBacklight

rules file (e.g. tinkerforge.rules):

    import org.openhab.core.library.types.*

    rule "Weatherstation LCD init from Backlight"
    when
        Item LCDBacklight changed from UNDEF or
            System started
    then
        sendCommand(LCD, "TFNUM<00>Temperature:       C")
        sendCommand(LCD, "TFNUM<10>Humidity   :       %")
        sendCommand(LCD, "TFNUM<20>Pressure   :     hPa")
        sendCommand(LCD, "TFNUM<30>Luminance  :     Lux")
        sendCommand(LCDBacklight, ON)
        sendCommand(LCD, String::format("TFNUM<013>%4s", 
                                Barometer_Temperature.state.format("%.1f")
                        ))
        sendCommand(LCD, String::format("TFNUM<113>%4s", 
                                Humdity.state.format("%.1f")
                            ))
        sendCommand(LCD, String::format("TFNUM<213>%4s",
                                  Barometer.state.format("%d")
                                  ))
        sendCommand(LCD, String::format("TFNUM<313>%4s", 
                                AmbientLight.state.format("%d")
                                ))
    end

    rule Goodbye
    when 
        System shuts down
    then
        sendCommand(LCDBacklight, OFF)
    end

    rule "Weatherstation LCD Backlight"
        when
                Item Button0 received update
        then
                if (Button0.state == ON)
                sendCommand(LCDBacklight, ON)
            else
                sendCommand(LCDBacklight, OFF)
    end
    rule "Weatherstation LCD update temperature"
        when 
                Item Barometer_Temperature received update 
        then
                sendCommand(LCD, String::format("TFNUM<013>%4s", 
                                Barometer_Temperature.state.format("%.1f")
                        ))
    end

    rule "Weatherstation LCD update humidity"
        when 
                Item Humdity received update
        then
                sendCommand(LCD, String::format("TFNUM<113>%4s", 
                                Humdity.state.format("%.1f")
                            ))
    end
    rule "Weatherstation LCD update airpressure"
        when 
                Item Barometer received update
        then
                sendCommand(LCD, String::format("TFNUM<213>%4s",
                                  Barometer.state.format("%d")
                                  ))
    end
    rule "Weatherstation LCD update ambientLight"
        when 
                Item AmbientLight received update
        then
                sendCommand(LCD, String::format("TFNUM<313>%4s", 
                                AmbientLight.state.format("%d")
                                ))
    end

#### Industrial Quad Relay Bricklet

bricklet:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | bricklet_industrial_quad_relay |

relay sub devices:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | same as bricklet |
| subid | openHAB subid of the device | relay0, relay2, relay3, relay4 |
| type | openHAB type name | industrial_quad_relay |

items file entry (e.g. tinkerforge.items):

    Switch QR1                      "QR1" {tinkerforge="uid=eQj, subid=relay0"}
    Switch QR2                      "QR2" {tinkerforge="uid=eQj, subid=relay1"}
    Switch QR3                      "QR3" {tinkerforge="uid=eQj, subid=relay2"}
    Switch QR4                      "QR4" {tinkerforge="uid=eQj, subid=relay3"}

sitemap file entry (e.g tinkerforge.sitemap):

    Switch item=QR1
    Switch item=QR2
    Switch item=QR3
    Switch item=QR4

#### Industrial Digital In 4 Bricklet

bricklet:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| subid | openHAB subid of the device | in0, in2, in3, in4 |
| type | openHAB type name | bricklet_industrial_digital_4in |
| debouncePeriod | debounce time in ms | default=100 |

input port sub devices:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | same as bricklet |
| subid | openHAB subid of the device | in0, in2, in3, in4 |
| type | openHAB type name |  |

openhab.cfg:

    tinkerforge:inddi4.uid=efY
    tinkerforge:inddi4.type=bricklet_industrial_digital_4in
    tinkerforge:inddi4.debouncePeriod=100

items file entry (e.g. tinkerforge.items):

    Contact ID1                     "ID1 [MAP(en.map):%s]" {tinkerforge="uid=efY, subid=in0"}
    Contact ID2                     "ID2 [MAP(en.map):%s]" {tinkerforge="uid=efY, subid=in1"}
    Contact ID3                     "ID3 [MAP(en.map):%s]" {tinkerforge="uid=efY, subid=in2"}
    Contact ID4                     "ID4 [MAP(en.map):%s]" {tinkerforge="uid=efY, subid=in3"}

sitemap file entry (e.g tinkerforge.sitemap):

    Text item=ID1
    Text item=ID2
    Text item=ID3
    Text item=ID4

#### IO16 Bricklet

openhab.cfg:

bricklet:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | bricklet_io16 |
| debouncePeriod | debounce time in ms | default=100 |

iosensor sub device:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | same as bricklet |
| subid | openHAB subid of the device | ina0, ina1, ina2, ina3, ina4, ina5, ina6, ina7, inb1, inb2, inb3, inb4, inb5, inb6, inb7 |
| type | openHAB type name | iosensor |
| pullUpResistorEnabled | enable the pull-up resistor |  true, false |

io_actor sub device:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | same as bricklet |
| subid | openHAB subid of the device | outa0, outa1, outa2, outa3, outa4, outa5, outa6, outa7, outb1, outb2, outb3, outb4, outb5, outb6, outb7 |
| type | openHAB type name | io_actuator |
| defaultState | default state of the port, true = HIGH, false=LOW | true, false |

    tinkerforge:io16.uid=efY
    tinkerforge:io16.type=bricklet_io16
    tinkerforge:io16.debouncePeriod=100

    tinkerforge:io16ina0.uid=efY
    tinkerforge:io16ina0.subid=ina0
    tinkerforge:io16ina0.type=iosensor
    tinkerforge:io16ina0.pullUpResistorEnabled=true
    
    tinkerforge:io16ina1.uid=efY
    tinkerforge:io16ina1.subid=ina1
    tinkerforge:io16ina1.type=iosensor
    tinkerforge:io16ina1.pullUpResistorEnabled=true
    
    tinkerforge:io16outa2.uid=efY
    tinkerforge:io16outa2.subid=outa2
    tinkerforge:io16outa2.type=io_actuator
    tinkerforge:io16outa2.defaultState=true

items file entry (e.g. tinkerforge.items):

    Contact ina0            "ina0 [MAP(en.map):%s]" {tinkerforge="uid=efY, subid=ina0"}
    Contact ina1            "ina0 [MAP(en.map):%s]" {tinkerforge="uid=efY, subid=ina1"}
    Switch outa2            "outb0" {tinkerforge="uid=efY, subid=outa2"}

sitemap file entry (e.g tinkerforge.sitemap):

    Text item=ina0
    Text item=ina01
    Switch item=outa2

#### DC Brick

For the DC Brick you can configure the acceleration, the pwm frequency, the drive mode (break=0, coast=1) 
and the switchOnVelocity. The device type is brick_dc. Valid values for driveMode are Break and Coast.

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | brick_dc |
| acceleration | | default=10000 |
| pwmFrequency | | default=15000 |
| driveMode | | default=0, values: 0=Break, 1=Coast |
| switchOnVelocity | | default=10000 |


openhab.cfg:

    tinkerforge:dc_garage.uid=62Zduj
    tinkerforge:dc_garage.type=brick_dc
    tinkerforge:dc_garage.switchOnVelocity=10000
    tinkerforge:dc_garage.pwmFrequency=15000
    tinkerforge:dc_garage.driveMode=0
    tinkerforge:dc_garage.acceleration=10000

items file entry (e.g. tinkerforge.items):

    Switch TinkerforgeDC          "TinkerforgeDC" { tinkerforge="uid=62Zduj"}

sitemap file entry (e.g tinkerforge.sitemap):

    Switch item=TinkerforgeDC

#### Servo Brick

For the Servo Brick you can configure the velocity, acceleration, servo voltage, pulse width min, 
pulse width max, period and the output voltage (must be equal for all servos). The device type is 
"servo". Available subid's are servo0 to servo6.

The current implementation is more or less for demo purposes. The servo can only be used as a switch 
item, to move the servo to the most left or most right position.

brick:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | get value from brickv |
| type | openHAB type name | brick_servo |

servo sub devices:

| property | descripition | values |
|----------|--------------|--------|
| uid | tinkerforge uid | same as brick |
| subid | openHAB subid of the device | servo0, servo1, servo2, servo3, servo4, servo5, servo6 |
| type | openHAB type name | servo |
| velocity | | default=30000 |
| acceleration | | default=30000 |
| servoVoltage | | |
| pulseWidthMin | | default=1000 |
| pulseWidthMax | | default=2000 |
| period | | default=19500 |
| outputVoltage | output voltage can only be set once (will be used for all servos) | default=5000 |

openhab.cfg:

    tinkerforge:servo0.uid=6Crt5W
    tinkerforge:servo0.type=servo
    tinkerforge:servo0.subid=servo0
    tinkerforge:servo0.velocity=65530
    tinkerforge:servo0.acceleration=65530

items file entry (e.g. tinkerforge.items):

    Switch Servo0              "Servo0" { tinkerforge="uid=6Crt5W, subid=servo0" }
    Switch Servo1              "Servo1" { tinkerforge="uid=6Crt5W, subid=servo1" }
    Switch Servo2              "Servo2" { tinkerforge="uid=6Crt5W, subid=servo2" }
    Switch Servo3              "Servo3" { tinkerforge="uid=6Crt5W, subid=servo3" }
    Switch Servo4              "Servo4" { tinkerforge="uid=6Crt5W, subid=servo4" }
    Switch Servo5              "Servo5" { tinkerforge="uid=6Crt5W, subid=servo5" }
    Switch Servo6              "Servo6" { tinkerforge="uid=6Crt5W, subid=servo6" }

sitemap file entry (e.g tinkerforge.sitemap):

    Switch item=Servo0
    Switch item=Servo1
    Switch item=Servo2
    Switch item=Servo3
    Switch item=Servo4
    Switch item=Servo5
    Switch item=Servo6

## Item Binding Configuration

In order to bind an item to a device, you need to provide configuration settings. The easiest way 
to do so is to add binding information in your item file (in the folder '${openhab_home}/configurations/items'). 

The configuration of the TinkerForge binding item looks like this:

    tinkerforge="(uid=<id> [, subid=<id>] | name=<name>)"

The configuration is quite simple. You either have to set a value for the uid and optionally for the 
subid of the device, or - if the device is configured in openhab.cfg - the "symbolic name" of the device.

| Property | Description | 
| -------- | ----------- |
| uid      | TinkerForge uid of the device (Use the Brick Viewer to get this value) |
| subid    | optional subid of the device|
| name     | _symbolic name_ of the device. The name is only available if there is some configuration for the device in openhab.cfg. |

## Item Types
Supported item types are "Switch Item", "Number Item", "Contact Item" and "String Item".

