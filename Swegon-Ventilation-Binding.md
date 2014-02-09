Documentation of the Swegon ventilation binding Bundle

## Introduction

Swegon ventilation is used to get live data from from Swegon ventilation systems. Binding should be compatible at least Swegon CASA models.

## Swegon gateway

**swegongw** is application read telegram from serial port (need RS-485 adapter) and relay untouched telegrams to openhab via UDP packet. Swegon ventilation binding listening UDP port and parse register data from UDP telegrams.

C code is available on [here](https://github.com/openhab/openhab/blob/master/bundles/binding/org.openhab.binding.swegonventilation/SwegonGW/swegongw.c)  

build command: 

    gcc -std=gnu99 -o swegongw swegongw.c

execution:

    swegongw -v -d /dev/ttyUSB0 -a 192.168.1.10

Swegongw help is avail be by command
execution:

    swegongw -h 

For installation of the binding, please see Wiki page [[Bindings]].

## Binding Configuration

openhab.cfg file (in the folder '${openhab_home}/configurations').

    ######################## Swegon ventilation Binding ###################################
    #
    # UDP port (optional, defaults to 9998)
    # swegonventilation:udpPort =9998

The `swegonventilation:udpPort ` value specify UDP port which binding will listening. Configuration is optional, by default binding listening UDP port 9998.

## Item Binding Configuration

In order to bind an item to the device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax of the binding configuration strings accepted is the following:

    swegonventilation ="<data>"

Where 

`<data>` corresponds the data item. See complite list below.

## List of supported data items

| Data | Item Type | Purpose                     | Note |
| ------- | --------- | --------------------------- | ---- |
| T1      | Number    | Temperature sensor 1  || 
| T2      | Number    | Temperature sensor 2  || 
| T3      | Number    | Temperature sensor 3  ||  
| T4      | Number    | Temperature sensor 4  || 
| T5      | Number    | Temperature sensor 5  || 
| T6      | Number    | Temperature sensor 6  || 
| T7      | Number    | Temperature sensor 7  || 
| T8      | Number    | Temperature sensor 8  ||  
| OutdoorTemperature | Number    | Temperature sensor  | T1 |
| SupplyAirTemperature | Number    | Temperature sensor  | T2 |
| ExtractAirTemperature | Number    | Temperature sensor  | T3 |
| SupplyAirTemperatureReheated | Number    | Temperature sensor  | T4 |
| ExhaustAirTemperature | Number    | Temperature sensor  | T8 |
| SupplyAirFanSpeed | Number    | Fan speed  rpm | |
| ExtractAirFanSpeed | Number    | Fan speed  rpm | |
| Efficiency | Number    | Efficiency  | Calculated by system |
| EfficiencySupply | Number    | Efficiency  | Calculated by binding |
| EfficiencyExtract | Number    | Efficiency  | Calculated by binding |
| FanSpeed | Number    | Fan speed | Fan speed 1…5 |
| PreheatState | Switch    | Heating  | Preheat state |
| ReheatState | Switch    | Heating | Reheat state |

## Examples

    Number	OutdoorTemperature	{ swegonventilation="OutdoorTemperature" }
    Number	SupplyAirFanSpeed	{ swegonventilation="SupplyAirFanSpeed" }
    Switch	Preheat	                { swegonventilation ="PreheatState" }