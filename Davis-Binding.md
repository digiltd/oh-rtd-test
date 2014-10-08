Documentation of the Davisbinding Bundle

## Introduction

Binding is based on the [Serial Communication Reference Manual](http://www.google.at/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0CCQQFjAA&url=http%3A%2F%2Fwww.davisnet.com%2Fsupport%2Fweather%2Fdownload%2FVantageSerialProtocolDocs_v261.pdf&ei=yns1VLO9B9Pe7Ab9hYDgDQ&usg=AFQjCNEUP_O6jjV3tHaxc7_faaLKWAtw2g&sig2=0YuJy45Qmk76RlffOqayuA&bvm=bv.76943099,d.ZGU) from Davis. Most Davis weather stations should be supported, so far the Binding is tested with Vantage Pro 2.

For installation of the binding, please see Wiki page [[Bindings]].

Davis binding will be available since openhab 1.6.0

## Binding Configuration

First you need to define your Davis weather station he openhab.cfg file (in the folder '${openhab_home}/configurations').

    ######################## Davis weather stations ###########################
    
    # serial port of the Weather station connected to
    davis:port=/dev/ttyS0
    
    # refresh inverval in milliseconds (optional, defaults to 10000)
    #davis:refresh=

The `davis:port` value is the path from the serial device of the weather station. For windows systems it is COMx

The `davis:refresh` value is the refresh interval. Refresh value is optional parameter.

Examples, how to configure your Davis device:

    davis:port=/dev/ttyS0
    #davis:refresh=

## Item Binding Configuration

In order to bind an item to the device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax of the binding configuration strings accepted is the following:

    davis="<value-key>"

The **value-key** corresponds a value from the Davis weather station. See complete list below.

The following value-keys are available:

    String StationType    	"StationType: [%s]" 	        { davis="station_type" }
    Number Receivers		"Receivers: [%.0f]"	        { davis="receivers" }
    Number TransmitterBattery	"Transmitter Battery [%.1f]"	{ davis="transmitter_battery_status" } 
    Number ConsoleBattVoltage	"Console Battery [%.2f V]"	{ davis="console_battery_voltage" } 

    DateTime Date		"Date [%1$tA, %1$td.%1$tm.%1$tY]"   { davis="time" }

    Number InsideTemp		"Inside Temp [%.1f °C ]"	{ davis="inside_temp" } 
    Number OutsideTemp		"Outside Temp [%.1f °C ]"	{ davis="outside_temp" } 
    Number DewPoint		"Dew Point [%.1f °C ]"	        { davis="dew_point" } 
    Number HeatIndex		"Heat Index [%.1f °C ]"	        { davis="heat_index" } 
    Number WindChill		"Wind Chill [%.1f °C ]"	        { davis="wind_chill" } 
    Number THSWIndex		"THSW Index[%.1f °C ]"	        { davis="thsw_index" } 

    Number InsideHumidity	"Inside Humidity [%.0f %% ]"	{ davis="inside_humidity" }
    Number OutsideHumidity	"Outside Humidity [%.0f %% ]"	{ davis="outside_humidity" }

    String BarTrend		"Barometer Trend [%s]"	        { davis="bar_trend" }
    Number Barometer		"Barometer [%.0f hPa]"	        { davis="barometer" }

    Number WindSpeed		"Wind Speed [%.1f km/h]"	{ davis="wind_speed" }
    Number WindSpeed10minAvg	"Wind Speed 10min Avg [%.1f km/h]"	{ davis="wind_speed_10min_avg" }
    Number WindDirection	"Wind Direction [%.0f °]"	{ davis="wind_direction" }
    Number WindSpeed10minHiRes		"Wind Speed 10min Avg HiRes [%.1f km/h]"	{ davis="wind_speed_10min_avg_hires" }
    Number WindSpeed2minHiRes		"Wind Speed 10min Avg HiRes [%.1f km/h]"	{ davis="wind_speed_2min_avg_hires" }
    Number WindSpeed10minGustHiRes	"Wind Speed 10min Avg HiRes [%.1f km/h]"	{ davis="wind_speed_10min_gust_hires" }
    Number WindDirectionGust		"Wind Direction Gust [%.0f °]"			{ davis="wind_direction_10min__gust" }

    Number RainRate		"Rain Rate [%.1f mm/h ]"	{ davis="rain_rate" } 
    Number Rain15min		"Rain Rate [%.1f mm/h ]"	{ davis="last_15min_rain" } 
    Number Rainlast1h		"Rain Rate [%.1f mm/h ]"	{ davis="last_hour_rain" } 
    Number Rainlast24h		"Rain Rate [%.1f mm/h ]"	{ davis="last_24h_rain" } 

    Number UVIndex		"UV Index [%.1f ]"		{ davis="uv" } 
    Number Solar		"Solar Radiation [%.0f W/m²]"	{ davis="solar_radiation" } 


    String firmware_date	"Firmware Date: [%s]"		{ davis="firmware_date" }
    String firmware_version	"Firmware Version: [%s]"	{ davis="firmware_version" }

    String rx_total		"RX Packets total: [%s]"	{ davis="rx_count_total" }
    String rx_missed		"RX Packets missed: [%s]"	{ davis="rx_count_missed" }
    String rx_resync		"RX Resyncs: [%s]"		{ davis="rx_count_resync" }
    String rx_consec		"RX Packets received in a row without error: [%s]"  { davis="rx_count_consecutive" }
    String rx_crc		"RX Packets CRC failes: [%s]"	{ davis="rx_count_crc" }


    Number airflowControl "Activated" {comfoair="activate"}
    Number airflowFanLevel "Level [%d]" {comfoair="fan_level"}
    Number airflowTargetTemperature "Target temperature [%.1f °C]" {comfoair="target_temperature"}
    
    Number airflowOutdoorIncomingTemperature "Outdoor incoming [%.1f °C]" {comfoair="outdoor_incomming_temperatur"}
    Number airflowOutdoorOutgoingTemperature "Outdoor outgoing [%.1f °C]" {comfoair="outdoor_outgoing_temperatur"}
    Number airflowIndoorIncommingTemperature "Indoor incomming [%.1f °C]" {comfoair="indoor_incomming_temperatur"}
    Number airflowIndoorOutgoingTemperature "Indoor outgoing [%.1f °C]" {comfoair="indoor_outgoing_temperatur"}
    Number airflowIncommingFan		"Incomming fan [%d %%]" {comfoair="incomming_fan"}
    Number airflowOutgoingFan		"Outgoing fan [%d %%]" {comfoair="outgoing_fan"}
    Number airflowFilterRuntime	        "Filter runtime [%d h]" {comfoair="filter_running"}
    Number airflowFilterErrorI	        "Filter (intern) [%s]" {comfoair="filter_error_intern"}
    Number airflowFilterErrorE	        "Filter (extern) [%s]" {comfoair="filter_error_extern"}
    String airflowError	                "Errorcode [%s]" {comfoair="error_message"}

Only **"activate"**, **"fan_level"** and **"target_temperature"** are writeable. All other device commands are readonly.

**"activate"** can handle 0 and 1 states
- 0 means CCEase Comfocontrol is active and the binding is in sleep state
- 1 means Binding is active and CCEase Comfocontrol is in sleep state

**"fan_level"** can handle 1, 2, 3 and 4 states
- 1 is Level A
- 2 is Level 1
- 3 is Level 2
- 4 is Level 3

**"target_temperature"** is a double value between 15.0 and 25.0 in 0.5 steps

## Limitations

- Either the ComfoAir binding or the CCEase Comfocontrol can be active
- You must implement auto mode by yourself with rules. But it is more powerful
