Documentation of the Heatmiser binding Bundle

## Introduction

The Heatmiser binding allows you to control Heatmiser RS-422 network thermostats (also sold under other names). The binding communicates via TCP/IP to an RS-422 adaptor that links to the thermostats. 

For installation of the binding, please see Wiki page [[Bindings]].

## Binding Configuration
The binding polls each thermostat that is configured in your items, at the _refresh_ rate (as set in the cfg file - see below). It automatically detects the type of thermostats - this is not set in the items.

Refer to the example below to see what you need to include in your openhab.cfg file:

    ################################ Heatmiser Binding #####################################
    #
    # refresh interval in milliseconds (optional, defaults to 2000ms)
    heatmiser:refresh
    
    # Set the IP address for the Heatmiser interface
    heatmiser:address=192.168.2.45
    
    # Set the port number for the Heatmiser interface
    heatmiser:port=1024
    

## Item Binding Configuration
Item strings simply consist of two components - the thermostat address (as set in the thermostat), and the parameter within the thermostat. Some examples are below.

    Switch	HallThermostat_Enable	"Hall Heating Enable  [%s]"	{ heatmiser="1:ONOFF" }
    Number	HallThermostat_RoomTemp	"Hall Heating Temperature [%.1f °C]"	{ heatmiser="1:ROOMTEMP" }
    Number	HallThermostat_SetTemp	"Hall Heating Setpoint    [%.1f °C]"	{ heatmiser="1:SETTEMP" }
    String	HallThermostat_HeatState	"Hall Heating State [%s]"	{ heatmiser="1:HEATSTATE" }
    Switch	HallThermostat_HWEnable	"Hot Water Heating Enable  [%s]"	{ heatmiser="1:WATERSTATE" }

The following parameters, and their associated item types are shown below. The R and RW in the description column indicate which parameters are read only (RO) or read/write (RW).

| Parameter     | Type Supported   | Description     |
| ------------- | ---------------- | --------------- |
| SETTEMP       | Number, String   | RW Temperature control setting |
| RUNMODE       | Number, String   | RW  - |
| FROSTTEMP     | Number, String   | RW Frost temperature |
| ROOMTEMP      | Number, String   | RO Current room temperature |
| FLOORTEMP     | Number, String   | RO Floor temperature |
| HOLDTIME      | Switch, DateTime | RO Current hold time (in minutes) |
| HOLIDAYTIME   | Switch, DateTime | RO Holiday time remaining (in days) |
| HOLIDAYSET    | Number, Switch   | RW Sets the holiday time (in days) |
| HOLDMODE      | Switch           | RO Returns ON or OFF if the thermostat is in hold mode |
| HOLIDAYMODE   | Switch           | RO Returns ON or OFF if the thermostat is currently in holiday mode |
| WATERSTATE    | Switch, String   | RW Returns ON or OFF if the hot water is currently heating | 
| HEATSTATE     | Switch, String   | RO Returns ON or OFF if the thermostat is currently heating |
| STATE         | Switch, String   | RO This is a consolidated thermostat state and maybe one of the following - OFF, ON, HOLD, HOLIDAY |
| ONOFF         | Switch, String   | RW Returns ON or OFF if the thermostat is enabled or not |


## Example Sitemap
Below is an example sitemap for a Heatmiser thermostat. This includes conditional visibility of items dependant on the thermostat state.

    Frame label="Lounge Thermostat" {
        Switch item=LoungeThermostat_Enable label="Lounge Thermostat Enable" 			
        Text item=LoungeThermostat_HeatState visibility=[LoungeThermostat_State==ON,LoungeThermostat_State==HOLD]
        Text item=LoungeThermostat_HolidayTime visibility=[LoungeThermostat_State==HOLIDAY]
        Setpoint item=LoungeThermostat_FrostTemp label="Lounge Frost Temperature [%d °C]" minValue=10 maxValue=18 step=1 visibility=[LoungeThermostat_State==HOLIDAY]
        Setpoint item=LoungeThermostat_SetTemp label="Lounge Setpoint [%d °C]" minValue=14 maxValue=25 step=1 visibility=[LoungeThermostat_State==ON,LoungeThermostat_State==HOLD]
        Text item=LoungeThermostat_FloorTemp valuecolor=[>28="red",>26.5="orange",>18="green", >16="orange", <=16="red"] 
        Text item=LoungeThermostat_RoomTemp  valuecolor=[>28="red",>26.5="orange",>18="green", >16="orange", <=16="red"]
        Setpoint item=LoungeThermostat_HolidaySet label="Lounge heating holiday days [%d]" minValue=0 maxValue=30 step=1
    }