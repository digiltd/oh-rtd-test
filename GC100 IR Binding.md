Documentation for GC100 IR binding

## Introduction
This page describes the GC100 IR binding, which allows openhab items to send commands to the corresponding IR devices from one or more instances of GC-100.

For installation of the binding, please see Wiki page [Bindings](https://github.com/openhab/openhab/wiki/Bindings).

## Global Binding Configuration
The GC100 IR binding allows you to define named instances of GC100 in your openhab.cfg. When defining your item binding configuration you can use the name to refer to your instances. In doing so, you can easily change the address by which you GC100 instance can be reached without having to reconfigure all of your bindings.

The syntax of the binding configuration is like this:
```
gc100serial : {instanceName}.host = <IP address of the GC100 device>
```
Where
* instanceName is name by which you can refer to this instance in your item binding configuration.

### Example
```
########################### GC100 IR Binding ###########################
	
# Hostname / IP address of your GC100 host
gc100ir:living.host=192.168.2.70
```

## Item Binding Configuration

**Configuration format**
```
gc100ir = "{[instanceName|module|connector|code]}"
```
Where
* instanceName is prefixed by a ‘#’ a named instance configured in the openhab.cfg.
* module is the numeric value which specifies the module number of GC100.
* connector is the numeric value which specifies the connector number of GC100.
* code is the value which is to be sent over IR devices as a command through GC100.

### Example
```
String	GC100_IR_DENON_DVD_LIVING_POWER_MODE_ON	{ gc100ir="[#living|4|1|38028,1,1,10,31,10,31,10,31,10,71,10,31,10,70,10,31,10,31,10,31,10,70,10,70,10,31,10,71,10,31,10,31,10,1765,10,31,10,31,10,31,10,71,10,31,10,31,10,71,10,70,10,71,10,31,10,31,10,70,10,31,10,71,10,71,10,1685,10,31,10,31,10,31,10,71,10,31,10,71,10,31,10,31,10,31,10,70,10,70,10,31,10,71,10,31,10,31,10,1764]" }
```

## Sitemap
```
Switch 	item=GC100_IR_DENON_DVD_LIVING_POWER_MODE_ON  label="Power ON"  mappings=[POWERON="POWER ON"]
Switch 	item=GC100_IR_DENON_DVD_LIVING_POWER_MODE_STANDBY  label="Stand by"  mappings=[STANDBY="STAND BY"]
Switch 	item=GC100_IR_DENON_DVD_LIVING_PLAY_STATE  label="Play"  mappings=[PLAY="PLAY"]
Switch 	item=GC100_IR_DENON_DVD_LIVING_PAUSE_STATE  label="Pause"  mappings=[PAUSE="PAUSE"]
```