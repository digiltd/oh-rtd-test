Documentation of the Novelan (Siemens) HeatPump binding Bundle

## Introduction

For installation of the binding, please see Wiki page [[Bindings]].

This Binding was created for Novelan Heatpump. Novelan is identical in construction to Luxtronic (Alpha Innotec) and Buderus Logamatic. So this bundle can be used with Loxtronic, too.

## Disclaimer

The whole functionality was reverse engineered via tcpdump, so use it at your own risk. 

## Precondition

The Heatpump bundle connects to your Heatpump via network. Make sure your Heatpump is connected to your network and the network settings are configured. To excess the network settings go in the Heatpump Service menu -> system control -> IP address.

## Generic Item Binding Configuration

The binding configurations format is simple and looks like this:

    novelanheatpump ="<eventType>"

where eventType is one of the following values:
- temperature_outside – the measured temperature by the outside sensor
- temperature_return – the temperature returned by floor heating
- temperature_reference_return – the reference temperature of the heating water
- temperature_supplay – the temperature sent to the floor heating
- temperature_servicewater_reference – the reference temperature of the servicewater
- temperature_servicewater - the temperature of the servicewater
- state – contains the time of the state and the state; Possible states are error, running, stoped, defrosting
- temperature_solar_collector - the temperature of the sensor in the solar collector
- temperature_solar_storage - the temperature of the solar storage
new since 1.3
- temperature_outside_avg - the average measured temperature by the outside sensor
- temperature_probe_in - temperature flowing to probe head
- temperature_probe_out - temperature coming  from probe head
- hours_compressor1 - operating hours of compressor one
- starts_compressor1 - total starts of compressor one
- hours_compressor2 - operating hours of compressor two
- starts_compressor2 - total starts of compressor two
- hours_heatpump - operating hours of heatpump
- hours_heating - operating hours of heating
- hours_warmwater - operating hours creating warm water
- hours_cooling - operating hours of cooling
- thermalenergy_heating - total energy for heating in KWh
- thermalenergy_warmwater - total energy for creating warm water in KWh
- thermalenergy_pool - total energy for heating pool in KWh
- thermalenergy_total - sum of all total energy in KWh
- extended_state – contains the time of the state and the state; Possible states are error, heating, standby, switch-on delay, switching cycle blocked, provider lock time, service water, screed heat up, defrosting, pump flow, desinfection, cooling, pool water, heating ext., service water ext., flow monitoring, ZWE operation
- heating_operation_mode - operation mode (0="Auto", 1="Zuheizer", 2="Party", 3="Ferien", 4="Aus")
- heating_temperature - heating curve offset
- warmwater_operation_mode (0="Auto", 1="Zuheizer", 2="Party", 3="Ferien", 4="Aus")
- warmwater_temperature - target temperature for warm water
There are some more values listed in the example configuration. But these are only values for "heatpump professionals".

As a result, your lines in the items file might look like the following:

    Number HeatPump_Temperature_1 	"Wärmepumpe Außentemperatur [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_outside" }
    Number HeatPump_Temperature_2	"Rücklauf [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_return" }
    Number HeatPump_Temperature_3 	"Rücklauf Soll [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_reference_return" }
    Number HeatPump_Temperature_4 	"Vorlauf [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_supplay" }
    Number HeatPump_Temperature_5 	"Brauchwasser Soll [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_servicewater_reference" }
    Number HeatPump_Temperature_6 	"Brauchwasser Ist [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_servicewater" }
    Number HeatPump_Temperature_7 	"Solarkollektor [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_solar_collector" }
    Number HeatPump_Temperature_8 	"Solarspeicher [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_solar_storage" }
    String HeatPump_State 	"Status [%s]"	<temperature> (Heatpump) { novelanheatpump="state" }
    
    //new since 1.3
    Number HeatPump_Retrun_External 	"Rücklauf Extern [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_out_external" } // return external
    Number HeatPump_Hot_Gas 	"Temperatur Heissgas [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_hot_gas" } // return hot gas
    Number HeatPump_Outside_Avg 	"mittlere Aussentemperatur [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_outside_avg" } 
    Number HeatPump_Probe_in 	"Sondentemperatur Eingang [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_probe_in" } 
    Number HeatPump_Probe_out 	"Sondentemperatur Ausgang [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_probe_out" } 
    Number HeatPump_Mk1 	"Vorlauftemperatur MK1 IST [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_mk1" } 
    Number HeatPump_Mk1_Reference 	"Vorlauftemperatur MK1 SOLL [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_mk1_reference" } 
    Number HeatPump_Mk2 	"Vorlauftemperatur MK2 IST [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_mk2" } 
    Number HeatPump_Mk2_Reference 	"Vorlauftemperatur MK2 SOLL [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_mk2_reference" } 
    Number HeatPump_External_Source 	"Temperatur externe Energiequelle [%.1f °C]"	<temperature> (Heatpump) { novelanheatpump="temperature_external_source" } 
    String HeatPump_Hours_Compressor1 	"Betriebsstunden Verdichter1 [%s]"	<clock> (Heatpump) { novelanheatpump="hours_compressor1" } 
    Number HeatPump_Starts_Compressor1 	"Verdichter 1 [%.1f]"	<clock> (Heatpump) { novelanheatpump="starts_compressor1" } 
    String HeatPump_Hours_Compressor2 	"Betriebsstunden Verdichter2 [%s]"	<clock> (Heatpump) { novelanheatpump="hours_compressor2" } 
    Number HeatPump_Starts_Compressor2 	"Verdichter 2 [%.1f]"	<clock> (Heatpump) { novelanheatpump="starts_compressor2" } 
    String HeatPump_Hours_Zwe1 	"Betriebsstunden ZWE1 [%s]"	<clock> (Heatpump) { novelanheatpump="hours_zwe1" }
    String HeatPump_Hours_Zwe2 	"Betriebsstunden ZWE2 [%s]"	<clock> (Heatpump) { novelanheatpump="hours_zwe2" }
    String HeatPump_Hours_Zwe3 	"Betriebsstunden ZWE3 [%s]"	<clock> (Heatpump) { novelanheatpump="hours_zwe3" }
    String HeatPump_Hours_Heatpump 	"Betriebsstunden [%s]"	<clock> (Heatpump) { novelanheatpump="hours_heatpump" } 
    String HeatPump_Hours_Heating	"Betriebsstunden Heizung [%s]"	<clock> (Heatpump) { novelanheatpump="hours_heating" }
    String HeatPump_Hours_Warmwater	"Betriebsstunden Brauchwasser [%s]"	<clock> (Heatpump) { novelanheatpump="hours_warmwater" }
    String HeatPump_Hours_Cooling	"Betriebsstunden Kuehlung [%s]"	<clock> (Heatpump) { novelanheatpump="hours_cooling" }
    Number HeatPump_Thermalenergy_Heating 	"Waermemenge Heizung [%.1f KWh]"	<energy> (Heatpump) { novelanheatpump="thermalenergy_heating" }
    Number HeatPump_Thermalenergy_Warmwater 	"Waermemenge Brauchwasser [%.1f KWh]"	<energy> (Heatpump) { novelanheatpump="thermalenergy_warmwater" }
    Number HeatPump_Thermalenergy_Pool 	"Waermemenge Schwimmbad [%.1f KWh]"	<energy> (Heatpump) { novelanheatpump="thermalenergy_pool" }
    Number HeatPump_Thermalenergy_Total 	"Waermemenge gesamt seit Reset [%.1f KWh]"	<energy> (Heatpump) { novelanheatpump="thermalenergy_total" }
    Number HeatPump_Massflow 	"Massentrom [%.1f L/h]"	<energy> (Heatpump) { novelanheatpump="massflow" }
    String HeatPump_State   "Status [%s]"   <temperature> (Heatpump) { novelanheatpump="extended_state" }

    //new since 1.7
    Number heatPump_heating_operation_mode   "Heizung Betriebsart [%.0f]"  (gHeatpump) { novelanheatpump="heating_operation_mode" }
    Number heatPump_heating_temperature   "Heizung Temperatur [%.1f]"  (gHeatpump) { novelanheatpump="heating_temperature" }
    Number heatPump_warmwater_operation_mode   "Warmwasser Betriebsart [%.0f]"  (gHeatpump) { novelanheatpump="warmwater_operation_mode" }
    Number heatPump_warmwater_temperature   "Warmwasser Temperatur [%.1f]"  (gHeatpump) { novelanheatpump="warmwater_temperature" }

## Set parameters
This parameters can be changed:
- Heating operation mode
- Warm wather operation mode
- Offset of the heating curve
- Target temperature for warm wather

Sitemap exmaple:

    Switch item=heatPump_heating_operation_mode  mappings=[0="Auto", 1="Zuheizer", 2="Party", 3="Ferien", 4="Aus"]
    Setpoint item=heatPump_heating_temperature minValue=-10 maxValue=10 step=0.5
    Switch item=heatPump_warmwater_operation_mode  mappings=[0="Auto", 1="Zuheizer", 2="Party", 3="Ferien", 4="Aus"]
    Setpoint item=heatPump_warmwater_temperature minValue=10 maxValue=65 step=1


## Gallery

The following charts are created via the rrd4j chart and heatpump bundle. <br/>

![alt text](http://wiki.openhab.googlecode.com/hg/images/screenshots/noveleanheatpump_rrdchart_d.png "RRD Chart")

![alt text](http://wiki.openhab.googlecode.com/hg/images/screenshots/noveleanheatpump_rrdchart_w.png "RRD Chart")

## Further planned features (not yet implemented)

- accesc the errorlog
 