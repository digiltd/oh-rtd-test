Documentation of the MAX!CUL Binding. _Targeting 1.6.0 release_

# Introduction
The aim of this binding is to allow the connection OpenHAB to MAX! devices (wall thermostat/radiator valves) using the [CUL USB dongle](http://busware.de/tiki-index.php?page=CUL) rather than the MAX! Cube. This should allow greater control over the devices than the cube offers as all interaction is handled manually.

A lot of credit must go to the [FHEM project](http://fhem.de/fhem.html)- without their implementation of the MAX interface with CUL this would be taking a lot longer to implement!

# Status
The binding is currently under heavy development and it is recommended that you currently do not rely on it. This page will be updated as things progress.

# Features
The binding currently offers the following features:

* Listen mode - this allows you to listen in on MAX! network activity from a MAX!Cube for example. A trace will be output in debug mode that decodes implemented messages
* Pairing - can pair devices with OpenHAB by triggering Pair Mode using a Switch item
* Wall Thermostat
 * Can send set point temperature
 * Can receive set point temperature
 * Can receive measured temperature 
 * Can receive battery status
 * Can receive operating mode
* Radiator Thermostat Valve
 * Can send set point temperature
 * Can receive set point temperature
 * Can receive measured temperature
 * Can receive valve position
 * Can receive battery status
 * Can receive operating mode
* Push Button
 * Can receive either AUTO or ECO depending on button press (translated to ON/OFF)
* Association
 * It is possible to link devices together so that they communicate directly with each other, for example a wall thermostat and a radiator valve.

# Limitations
Aside from understanding what the binding does do which is documented here there are some key things to be aware of that may limit what you hope to achieve.

1. Radiator valve data is updated quite sporadically. Items such as set point temperature, measured temperature, valve position, battery status and operating mode are only sent when the state of the valve changes - i.e. valve moves or the dial used to manually set a temperature. If you want measured temperature it is much better to use a wall thermostat.
1. The binding has no concept of 'auto' mode. It currently has no ability to retrieve from any source and subsequently send a schedule to devices. This may change in the future, which would allow basic operation should OpenHAB fail for some reason.
1. If a wall thermostat is set to 'OFF' (mapped to 4.5deg) it won't update the measured temperature.

# Binding Configuration
Example configuration:

    ################################ Max!CUL Binding  ###########################################
    
    # set the device of the CUL device
    maxcul:device=serial:/dev/ttyACM1
    # set the refresh interval
    maxcul:refreshInterval=60000
    # set timezone you want the units to be set to - default is Europe/London
    maxcul:timezone=Europe/London


# Item Configuration

Some quick Examples:
* `Number RadTherm1 { maxcul="RadiatorThermostat:JEQ1234565" }` - will return/set the thermostat temperature of radiator thermostat with the serial number JEQ0304492
* `Number RadThermBatt { maxcul="RadiatorThermostat:JEQ1234565:feature=battery" }`- will return the battery level of JEQ0304492
* `Number wallThermTemp { maxcul="WallThermostat:JEQ1234566:feature=temperature" }` - will return the temperature of a wall mounted thermostat with serial number JEQ0304447
* `Number wallThermSet { maxcul="WallThermostat:JEQ1234566:feature=thermostat" }` - will set/return the desired temperature of a wall mounted thermostat with serial number JEQ0304447
* `Switch pushBtn { maxcul="PushButton:JEQ1234567" }` - ON maps to Auto, OFF maps to Eco
* `Switch pair { maxcul="PairMode" }` - Switch only, ON enables pair mode for 60s. Will automatically switch off after this time.
* `Switch listen { maxcul="ListenMode" }` - Switch only, puts binding into mode where it doesn't process messages - just listens to traffic, parses and outputs it.

## Additional options
### feature

The following devices have the following valid features:
* RadiatorThermostat - `thermostat` (default),`temperature`,`battery`,`valvepos`
* WallThermostat - `thermostat` (default),`temperature`,`battery`
* PushButton - `switch`

Example:
`Number wallThermTemp { maxcul="WallThermostat:JEQ1234566:feature=temperature" }`

### configTemp
There is the option of the addition of `configTemp=20.0/15.0/30.5/4.5/4.5/0.0/0.0` at the end of a thermostat device binding (wall or radiator) will allow the setting of comfort/eco/max/min/windowOpenDetectTemp/windowOpenDetectTime/measurementOffset respectively. It's best to set this on only one binding of each device - if you set this on more than one binding for the same device then it will take the first one in the parsing order (whatever that is - hence generating some uncertainty!). These correspond to the following:
* comfort - the defined 'comfort' temperature (default 21.0)
* eco - the defined eco setback temperature (default 17.0)
* max - maximum temperature that can be set on the thermostat (default 30.5)
* min - minimum temperature that can be set on the thermostat (default 4.5)
* windowOpenDetectTemp - set point in the event that a window open event is triggered by a shutter.
* windowOpenDetectTime - Rounded down to the nearest 5 minutes. (default is 0)
* measurement offset - offset applied to measure temperature (range is -3.5 to +3.5) - default is 0.0

Example:

`Number wallThermDesired { maxcul="WallThermostat:KEQ0946847:feature=thermostat:configTemp=20.0/15.0/30.5/4.5/4.5/0.0/0.0" }`

### associate
Association allows you to link two items together. For example you might want to link a Wall Thermostat and a Radiator Thermostat together. This would have the effect that you don't need rules to keep the set point temperature synchronised as it is communicated directly by the devices. It also means that the radiator thermostat will use the measured temperature from the wall thermostat.

The devices must be associated both ways. The binding doesn't do this automatically (though it could in the future).

Example:

    Number heating_radvalve  "Valve Setpoint [%.1f °C]" { maxcul="RadiatorThermostat:KEQ1234561:associate=KEQ1234560" }
    Number heating_wallThermMeasured "Wall Meas [%.1f °C]" { maxcul="WallThermostat:KEQ1234560:feature=temperature:associate=KEQ1234561" }

The binding allows more than one association per device. They just need to be comma separated. Example:

    Number heating_wallThermMeasured "Wall Meas [%.1f °C]" { maxcul="WallThermostat:KEQ1234560:feature=temperature:associate=KEQ1234561,KEQ1234562" }

# Technical Information

## Implemented Messages
The table below shows what messages are implemented and to what extent. Transmit means we can build and transmit a packet of that type with relevant data. Decode means we can extract data into some meaningful form. All message types can be received, identified and the raw payloads displayed. Messages not identified in this table cannot be transmitted by the binding and can only be decoded as a raw payload.

| Message               | Transmit | Decode           |Comments                                    |
|-----------------------|:--------:|:----------------:|--------------------------------------------|
|ACK                    | Y        | Y                |                                            |
|PAIR PING              | N        | Y                |                                            |
|PAIR PONG              | Y        | Y                |                                            |
|SET GROUP ID           | Y        | Y                |                                            |
|SET TEMPERATURE        | Y        | Y                | Allows setting of temperature of (wall)therm |
|TIME INFO              | Y        | Y                |                                            |
|WAKEUP                 | Y        | N                |                                            |
|WALL THERMOSTAT CONTROL| N        | Y                | Provides measured temp and set point       |
|THERMOSTAT STATE       | N        | Y                | Provides battery/valvepos/temperature/thermostat set point |
| WALL THERMOSTAT STATE | N        | Y                | Provides battery/valvepos/temperature/thermostat set point |
| PUSH BUTTON STATE     | N        | Y                | Auto maps to ON, Eco maps to OFF           |
| ADD LINK PARTNER      | Y        | N                | Links a device with another                |

## Message Sequences
For situations such as the pairing where a whole sequences of messages is required the binding has implemented a message sequencing system. This allows the implementation of a state machine for the system to pass through as messages are passed back and forth.

This will be documented in more detail in due course.

## Planned Future Features
These are in no particular priority and are simply ideas. They may not get implemented at all.

1. ~~Implement association of devices with each other so that they won't need rules to keep the Wall Thermostat and the Radiator Thermostat in sync~~ DONE
1. ~~Add the ability to configure night/comfort/etc temperatures~~ DONE
1. ~~Add the ability to interface with the Eco switch~~ DONE
1. Add the ability to interface with the window contact devices
1. Add the ability pretend to be a wall thermostat. This would allow us to associate with a radiator thermostat and send measured temperatures to it. These could be then sent from another binding for example.
1. Add the ability to simulated a window contact. This would allow us to associate with a radiator thermostat and send window events to it.