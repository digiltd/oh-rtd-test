## Introduction

[Tinkerforge](http://www.tinkerforge.com) is a system of open source hardware building blocks that allows you to combine sensor and actor blocks by plug and play. You can create your individual hardware system by choosing the necessary building blocks for your project and combine it with other home automation products. There are many blocks available e.g for temperature, humidity or air pressure measurement as well as for I/O, LCDs and motor control. You will find a complete List of available blocks [here](http://www.tinkerforge.com/en/doc/Product_Overview.html).

This binding connects the [TinkerForge](http://tinkerforge.com) devices to the openHAB event bus. Sensor values from devices are made available to openHAB and actions on  devices can be triggered by openHAB.

For now only a subset of the !TinkerForge devices and features are supported, but more devices and features will be added in the near future.

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

The !TinkerForge binding bundle is available as a separate (optional) download. For installation of the binding, please see Wiki page [[Bindings]].

## Generic Item Binding Configuration

### Basic Configuration

In order to connect openHAB to !TinkerForge devices you need to define all the brickd hosts and ports in the openhab.cfg file.
The following properties can be configured to define a brickd connection:

    tinkerforge:hosts="<IP address>[:port] ..."

The properties indicated by '<...>' need to be replaced with an actual value. Properties surrounded by square brackets are optional.

<table>
  <tr><td>**Property**</td><td>**Description**</td></tr>
  <tr><td>IP address</td><td>IP address of the brickd</td></tr>
  <tr><td>port</td><td>The listening port of of the brickd (optional, default 4223)</td></tr>
</table>

For connecting several brickds, use multiple <IP address>[statements delimited by a space.

### Example Configurations

Example for a connection to a single brickd:

    tinkerforge:hosts=127.0.0.1

Example for several brickd connections using different ports:

    tinkerforge:hosts=127.0.0.1:4224 192.168.1.50 192.168.1.104

## Advanced Configuration

There are several configuration parameters to control the behavior of the devices. The available parameters depend on the device type.

### Overview

A configuration line in openhab.cfg looks like this:

    tinkerforge:<symbolic name>.<property>=<value>

The *symbolic name* string can be used in the items configuration as an alternative for the uid and subid values.

The following table lists the available properties, a description of the property and the devices which will accept a value for this property.

<table>
  <tr><td>*Property*</td><td>*Description*</td><td>*Device*</td></tr>
  <tr><td>uid</td><td>!TinkerForge uid of the device (use the Brick Viewer to get this value)</td><td>mandatory for all devices</td></tr>
  <tr><td>subid</td><td>optional subid of the device, subid's are used if a bricklet houses more then one device (e.g. the Dual Relay Bricklet)</td><td>mandatory for sub devices</td></tr>
  <tr><td>type</td><td>The device type.</td><td>mandatory for all devices</td></tr>
  <tr><td>callbackPeriod</td><td>callback period of the !CallbackListener in milliseconds (default: 1000)</td><td>bricklet_distance_ir, bricklet_humidity, bricklet_temperature, bricklet_barometer, bricklet_ambient_light</td></tr>
  <tr><td>threshold</td><td>threshold value (default: 0)</td><td>bricklet_distance_ir, bricklet_humidity, bricklet_temperature, bricklet_barometer, bricklet_ambient_light</td></tr>
</table>
|| switchOnVelocity || The velocity. || brick_dc, servo[0-6](:port]) || 
|| pwmFrequency || The pwm frequency || brick_dc ||
|| driveMode || The drive mode: break=0, coast=1. || brick_dc ||
|| acceleration || The acceleration || brick_dc, servo[||

The following table lists !TinkerForge devices, their device type name recognized by the binding, the subid name, if the device is a sub device and if it is an actor. The value is "out" for outbound actors and "in" for inbound actors).

<table>
  <tr><td>*device*</td><td>*type name*</td><td>*subid*</td><td>*actor*</td></tr>
  <tr><td>Servo housed on a Servo Brick</td><td>servo</td><td>servo[0-6](0-6])</td><td>out</td></tr>
  <tr><td>DC Brick</td><td>brick_dc</td><td></td><td>out</td></tr>
  <tr><td>Relay housed on a Dual Relay Bricklet</td><td>dual_relay</td><td>relay[<tr><td>Humidity Bricklet</td><td>bricklet_humidity</td><td></td><td></td></tr>
  <tr><td>Distance IR Bricklet</td><td>bricklet_distance_ir</td><td></td><td></td></tr>
  <tr><td>Temperature Bricklet</td><td>bricklet_temperature</td><td></td><td></td></tr>
  <tr><td>Temperature sensor housed on a Barometer Bricklet</td><td>barometer_temperature</td><td>temperature</td><td></td></tr>
  <tr><td>Ambient Light Bricklet</td><td>bricklet_ambient_light</td><td></td><td></td></tr>
  <tr><td>LCD20x4 Bricklet</td><td>bricklet_LCD20x4</td><td></td><td>out</td></tr>
  <tr><td>Button housed on a LCD20x4 Bricklet</td><td>lcd_button</td><td>button[0-3](1-2]</td><td>out</td></tr>)</td><td>in</td></tr>
</table>

### Bricklet DistanceIR, Temperature, Barometer and AmbientLight

The binding uses the TF !CallbackListeners to get the sensor values from the bricklets DistanceIR, Temperature, Barometer (pressure value only) and !AmbientLight. These listeners are configured to only return updated sensor values at a given time period (callbackPeriod). The default configuration sets the **callbackPeriod** to 1 second. This value can be changed in openhab.cfg. For now this value must be changed for every single device. The values must be given in milliseconds.

The callbackPeriod controls the amount of traffic from the TF hardware to the binding.

The **threshold** means that even if the listener reports a changed value, this value is only send to the openhab eventbus, if the value of the difference between the last measured value and the current measured value is bigger than the threshold value. You can think of this as a kind of hysteresis, it dampens the oscillation of openhab item values.

The threshold controls the amount of  traffic from the binding to the openhab eventbus.

### DC Brick

For the DC Brick you can configure the acceleration, the pwm frequency, the drive mode (break=0, coast=1) and the switchOnVelocity. The device type is brick_dc. Valid values for driveMode are Break and Coast.

### Servo Brick

For the Servo Brick you can configure the velocity, acceleration, servo voltage, pulse width min, pulse width max, period and the output voltage (must be equal for all servos). The device type is”servo“. Available subids are servo0 to servo6.

The current implementation is more or less for demo purposes. The servo can only be used in a switch item to move the servo to the most left or most right position.

### LCD20x4 Bricklet

A short explanation of how to use the LCD20x4

What’s the meaning of this magic string?

    sendCommand(TF_LCD, String::format("TFNUM<213>%4s"TF_Barometer.state.format("%d")
                      ))

TFNUM is just a flag to signal the binding that some position information is passed. The first number is the line number, starting from 0. The second and third number are interpreted as the position in the line, starting from 0. The above example would write the current value of the barometer bricklet to line 3 starting from position 14, with a fixed width of 4 (this is because of %4s).

### Example Configuration

    tinkerforge:distance_door.uid=6GN
    tinkerforge:distance_door.type=bricklet_distance_ir
    tinkerforge:distance_door.threshold=1
    tinkerforge:distance_door.callbackPeriod=10
    
    tinkerforge:relay_coffee_machine.uid=c21
    tinkerforge:relay_coffee_machine.type=dual_relay
    tinkerforge:relay_coffee_machine.subid=relay1


# Item Binding Configuration

In order to bind an item to a device, you need to provide configuration settings. The easiest way to do so is to add binding information in your item file (in the folder '${openhab_home}/configurations/items'). 

The configuration of the !TinkerForge binding item looks like this:

    tinkerforge="(uid=<id> [, subid=<id>] | name=<name>)"

The configuration is quite simple. You either have to set a value for the uid and optionally for the subid of the device, or - if the device is configured in openhab.cfg - the "symbolic name" of the device.

|| **Property** || **Description** || 
|| uid || !TinkerForge uid of the device (Use the Brick Viewer to get this value) ||
|| subid || optional subid of the device||
|| name || **symbolic name** of the device. The name is only available if there is some configuration for the device in openhab.cfg. ||


    tinkerforge="uid=6GN"
    tinkerforge="uid=c21, subid=relay2"
    tinkerforge="name=relay_coffee_machine"

## Switch Items

For now, the actor devices only support Switch Items. This means that openHAB can send !OnOffType commands to the outbound switch actors and can receive !OnOffType commands from inbound switch actors.

## String Items

The LCD20x4 is a bit special as it acts as outbound actor which can receive text messages. To achieve this, you have to configure the device as String item.

## Example Configuration

    Number Tinkerforge_DistanceIR              "Tinkerforge5 DistanceIR [%.1f ]" { tinkerforge="uid=6GN" }
    Switch TinkerforgeServo0              "TinkerforgeServo0" { tinkerforge="uid=6Crt5W, subid=servo0" }
    Switch TinkerforgeServo6              "TinkerforgeServo6" { tinkerforge="uid=6Crt5W, subid=servo6" }
    Switch TinkerforgeDualRelay1          "TinkerforgeDualRelay1" { tinkerforge="name=relay_coffee_machine" }
    Switch TinkerforgeDualRelay2          "TinkerforgeDualRelay2" { tinkerforge="uid=c21, subid=relay2" }
    
    String TF_LCD         "LCD" { tinkerforge="uid=d4j"}
    Switch TF_Button0         "Button0" { tinkerforge="uid=d4j, subid=button0"}