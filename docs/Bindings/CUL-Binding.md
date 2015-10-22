**CUL is now more a communication layer for the [[FS20 Binding|FS20-Binding]] and other bindings. This page seems to be outdated.**

Documentation of the CUL binding bundle

# CUL Binding for openHAB

This binding allows you use a CUL device from busware.de in SlowRF mode to connect to FS20/FHT/Intertechno devices.
It is probably possible to use this binding with other devices running culfw (culfw.de) as as they appear as a serial device on the linux system.

A separate binding is implented for those wishing to interface with MAX! devices using the CUL dongle. Please see [MAX! CUL binding](https://github.com/openhab/openhab/wiki/MAX!-CUL-Binding)

## Installation

Besides simply dropping this binding into the addon folder it is possible that some more steps are needed to get everything running. Most importantly on Linux the user openHAB is running as has to be in the group 'dialout' to have the necessary permissions to access serial ports. Additional it is possible that you need to add/alter some VM parameters. I had to edit the following to parameters to get the CUL binding running on a Raspberry Pi.
- -Dgnu.io.rxtx.SerialPorts=/dev/ttyACM0
- -Djava.library.path=/usr/lib/jni (folder where native library for rxtx is located)

## Configuration

### openhab.cfg

At the very least you have to specify the device the binding should use:
- cul:device=/dev/ttyACM0

If you want to control FHT devices you have to also specify a valid housecode:
- cul:housecode=6261

There is also the possibility that this binding keeps the time of your FHTs up to date. This can be configured with the following parameters:
- cul:fht.time.update=true (activates the update process)
- cul:fht.time.update.cron=0 15 04 ** ** ? (specifies a cron expression for the quartz scheduler when the update should be started)

Please note that updating multiple FHTs can take quite some time and currently there is the possibility that the send buffer of your CUL could be filled up and block other commands. In case you want to control Intertechno remote switches it is possible that the sending parameters need some finetuning. There are two parameters which can be set to adjust the sending behaviour of the CUL in Intertechno mode.
- cul:itrepetitions=6
- cul:itwavelength=420

The first one specifies how often a command is repeated and the second one defines length of one wave puls. Please refer to the documentation of culfw for more details.

### Item bindings

An item binding to CUL can look like this {cul="TR3D4900"}.
The coniguration string consists of several parts. The first letter specifies the type of device you will be receiving or sending
commands to/from.
- 'T' stands for FHT devices like a FHT80b, valves or window contacts
- 'F' stands for standard FS20 devices like switches and dimmers
- 'i' stands for Intertechno remote switches
The second letter is the direction of the binding. It can be either 'R' for read only or 'W' for write only. The last letters are
specific to the device type. In case of 'F' and 'T' it is always the device address So your example from above can be split in the 
following parts
- 'T' the device type in this case a FHT device
- 'R' the direction of the binding. In this case we wish only to receive messages
- '3D4900' the address of the FHT device. In this case this is the address of the first valve under the control of a FHT80b with the
	address 3D49. 
So the address of the FHT80b itself would 3D49. A read binding on the FHT80b would give the measured temperature in regular intervals 
of about 15 minutes.

### FHT bindings

- {cul="TR3D4900"} is binding to receive the valve position in percent. It can be bound to a number item
- {cul="TR952E90"} is a binding to receive the window state of a FHT window contact.
Note that these two bindings can only be read only. None of these devices does receive commands
- {cul="TR3D49"} This would be a binding to receive reports of a FHT80b. Currently only the measured temperature is received
- {cul="TW3D49"} This binding enables you to send commands to a FHT80b. Currently this will be mostly the desired temperature. But
	you need also a writeable binding to update the time on your FHT80b.

### FS20 bindings

FS20 devices have always an address constisting of the house code (2 bytes) a group address (upper nibble of third byte) and a device
address (lower nibble of third byte). So in a binding to receive data from a wall switch could look like this
- {cul="FRC04B00"} Where we are addressing the first device in the first group in the house code C04B.
- {cul="FWC03B00"} This would enable openHAB to send commands to switch or dimmer. Currently only simple commands are possible.
	For example it is not possible to control the internal timer.

### Intertechno bindings

Intertechno is a somehow hackish thing to use. It works quite reliable most of the time, but many vendors have their own subset
of Intertechno. Therefore it is necessary to specify the exact type of Intertechno device you will be addressing so the binding
can calcualte the correct device address. You must specify the type as the third letter in the binding config (after the 'i' for
Intertechno and the 'W' for writeable). Currentyl only two types are supported (and only one is tested)
- 'C' for the Classic Intertechno devices
- 'F' for the FLS100 like devices
For more information on Intertechno device types and how to identify them have look at http://www.fhemwiki.de/wiki/Intertechno_Code_Berechnung#Mit_CUL_im_Debug-Modus_Rohsignale_empfangen_und_analysieren
In configs for this binding you don't specify the calculated address, but the switch setting on the device. This binding then calculates
the correct address for you. So an example binding for the third FLS100 device in group IV would look like this
- {cul="iWFIV3"}
Currently it is not possible to receive data from Intertechno remotes, but to keep my options open and because I'm lazy you have to
specify the direction anyway.


## Examples

### openhab.cfg
    fht:device=serial:/dev/ttyACM0
    fs20:device=serial:/dev/ttyACM0
    s300th:device=serial:/dev/ttyACM0

### items:
    Switch fs20Light "Light1" { fs20="DC6900" } 
    Switch fs20KSE "Doorbell [%s]" { fs20="536200" } (FS20 KSE Funk-Klingelsignal-Erkennung)
    Switch fs20Pira "Motion [%s]"  { fs20="A7A300" } (FS20 PIRA)

    Number fhtRoom1Desired "Desired-Temp. [%.1f °C]" { fht="housecode=552D;datapoint=DESIRED_TEMP" }
    Number fhtRoom1Measured "Measured Temp. [%.1f °C]" { fht="housecode=552D;datapoint=MEASURED_TEMP" }
    Number fhtRoom1Valve "Valve [%.1f %%]" { fht="housecode=552D;address=00;datapoint=VALVE" }
    Switch fhtRoom1Battery "Battery [%s]" { fht="housecode=552D;datapoint=BATTERY" }
    Contact fhtRoom1Window "Window [MAP(en.map):%s]" { fht="housecode=52FB;address=7B;datapoint=WINDOW" }

    Number S300Temp "Temperature [%.1f C]" {s300th="address=1;datapoint=TEMPERATURE"} 
    Number S300Humi "Humidity [%.1f %%]" {s300th="address=1;datapoint=HUMIDITY"}


### sitemap:
    Frame {
        Setpoint item=fhtRoom1Desired minValue=6 maxValue=30 step=0.5 
        Text item=fhtRoom1Measured
        Text item=fhtRoom1Valve	
        Text item=fhtRoom1Battery
        Text item=fhtRoom1Window
    }


### rules:

#### timed light switch rule
    
    rule "timed_light_switch"
    when 
        Item fs20Light received update ON
    then
        createTimer(now.plusMinutes(5)) [|
            sendCommand(fs20Light, OFF)
        ]
    end

#### switch light on motion rule

    rule fs20Pira_motion
    when 
        Item fs20Pira received update
    then
        sendCommand(fs20Light, ON)
        createTimer(now.plusMinutes(10)) [|
            sendCommand(fs20Light, OFF)
        ]
    end

#### window open/close rule    

    var Timer tenMinTimer = null
    var boolean tenMinTimerState = false

    rule "window_closed_switch_light_on_for_10_min"
    when
        Item fhtRoom1Window changed from CLOSE to OPEN
    then
    var DateTime daystart = new DateTime((dawnStart.state as DateTimeType).calendar.timeInMillis)
    var DateTime dayend = new DateTime((duskEnd.state as DateTimeType).calendar.timeInMillis)
    val boolean isdark = now.isBefore(daystart) || now.isAfter(dayend)
    if ( isdark )
    {
        sendCommand(fs20Light, ON)
        tenMinTimerState = true
        tenMinTimer = createTimer(now.plusMinutes(10))[|
            tenMinTimerState = false
            sendCommand(fs20Light, OFF)
        ]       
    }
    end