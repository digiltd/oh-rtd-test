Documentation of the MAX!CUL Binding.

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
 * Can send set point temperature to a wall thermostat
 * Can receive set point temperature from wall thermostat
 * Can receive measured temperature from wall thermostat
* Radiator Thermostat Valve
 * Can send set point temperature

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

The following devices have the following valid types:
* RadiatorThermostat - `thermostat`,`temperature`,`battery`,`valvepos`
* WallThermostat - `thermostat`,`temperature`,`battery`

Examples:
* `Number RadTherm1 { maxcul="RadiatorThermostat:JEQ1234565" }` - will return/set the thermostat temperature of radiator thermostat with the serial number JEQ0304492
* `Number RadThermBatt { maxcul="RadiatorThermostat:JEQ1234565:battery" }`- will return the battery level of JEQ0304492 _(NOT IMPLEMENTED YET)_
* `Number wallThermTemp { maxcul="WallThermostat:JEQ1234566:temperature" }` - will return the temperature of a wall mounted thermostat with serial number JEQ0304447
* `Number wallThermSet { maxcul="WallThermostat:JEQ1234566:thermostat" }` - will set/return the desired temperature of a wall mounted thermostat with serial number JEQ0304447
* `Switch pushBtn { maxcul="PushButton:JEQ1234567" }` - will default to 'switch' mode _(NOT IMPLEMENTED YET)_
* `Switch pair { maxcul="PairMode" }` - Switch only, ON enables pair mode for 60s. Will automatically switch off after this time.
* `Switch listen { maxcul="ListenMode" }` - Switch only, puts binding into mode where it doesn't process messages - just listens to traffic, parses and outputs it.

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

## Message Sequences
For situations such as the pairing where a whole sequences of messages is required the binding has implemented a message sequencing system. This allows the implementation of a state machine for the system to pass through as messages are passed back and forth.

This will be documented in more detail in due course.

## Planned Future Features
1. Implement association of devices with each other so that they won't need rules to keep the Wall Thermostat and the Radiator Thermostat in sync
1. Add the ability to configure night/comfort/etc temperatures
1. Add the ability to interface with the Eco switch
1. Add the ability to interface with the window contact devices