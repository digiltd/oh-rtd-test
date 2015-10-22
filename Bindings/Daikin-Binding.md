Documentation of the Daikin binding bundle.

## Introduction

This binding allows you to monitor and control a Daikin air conditioner/heat pump via openHAB. In order for this to work a [KKRP01A](http://www.onlinecontroller.eu/) Online Controller must be installed in your Daikin unit and connected to your LAN. 

There is a list of units that are compatible with the KKRP01A [here](http://www.onlinecontroller.eu/media/downloads/List-of-compatible-INDOOR-and-OUTDOOR-units-4.pdf) and instructions on how to install and configure the controller [here](http://www.onlinecontroller.eu/en/download).

The KKRP01A has a built in web server which allows you to poll the devices status (via GET requests) as well as send commands (via POST requests) to turn the unit on/off, change its mode, etc.
 
## Binding Configuration

You need to let openHAB know where to find the KKRP01A web server and set how often you would like the binding to refresh any status items (send a GET request).

The binding supports more than one KKRP01A if required.

### openhab.cfg Config

    ############################# Daikin Binding #############################

    # the refresh interval (in ms)
    daikin:refresh=60000

    # where <name> is used in your item bindings
    daikin:<name>.host=<ipaddress|host>
    #daikin:<name>.username=<not used>
    #daikin:<name>.password=<not used>

### Item bindings

The binding supports both inbound and outbound bindings. 

#### Inbound (readonly) bindings

    // the temperature/humidity at the indoor unit
    Number  DaikinTempIn      "Temp Inside [%.1f °C]"      { daikin="<name>:tempin" }
    Number  DaikinHumidityIn  "Humidity Inside [%.1f %%]"  { daikin="<name>:humidityin" }

    // the temperature at the outdoor unit
    Number  DaikinTempOut     "Temp Outside [%.1f °C]"     { daikin="<name>:tempout" }

#### Outbound (command) bindings

    // power
    Switch  DaikinPower  "Power"           { daikin="<name>:power" }

    // mode of operation - one of Auto/Dry/Cool/Heat/Fan/Night
    String  DaikinMode   "Mode [%s]"       { daikin="<name>:mode" }

    // temperature set point
    Number  DaikinTemp   "Temp [%.0f °C]"  { daikin="<name>:temp" }

    // fan mode - one of Auto/F1/F2/F3/F4/F5
    String  DaikinFan    "Fan [%s]"        { daikin="<name>:fan" }

    // swing mode - one of Off/UpDown
    String  DaikinSwing  "Swing [%s]"      { daikin="<name>:swing" }

    // timer mode - one of Off-Off/Off-On/On-Off/On-On (start/end timers)
    String  DaikinTimer  "Timer [%s]"      { daikin="<name>:timer" }

The KKRP01A supports user authentication however this is not currently supported by the binding. 