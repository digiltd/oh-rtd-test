Documentation of the Waterkotte EcoTouch heat pump binding bundle.

## Introduction

For installation of the binding, please see Wiki page [[Bindings]].

## Precondition

This bundle connects to your heat pump via network. Make sure the display unit of your heat pump is connected to your network and that the network settings are configured. By default, the heat pump uses DHCP.

## Generic Item Binding Configuration

The binding configurations format is simple and looks like this:

    ecotouch="<eventType>"

where eventType is one of the following values:
- temperature_outside
- temperature_outside_1h
- temperature_outside_24h
- temperature_source_in
- temperature_source_out
- temperature_return_set
- temperature_return
- temperature_flow
- temperature_room
- temperature_room_1h
- temperature_water
- temperature_pool
- temperature_solar
- temperature_solar_flow
- power_compressor
- power_heating
- power_cooling
- cop_heating
- cop_cooling
- temperature_heating_return
- temperature_heating_set
- temperature_cooling_return
- temperature_cooling_set
- temperature_water_set
- temperature_pool_set
- compressor_power
- state_sourcepump
- state_heatingpump
- state_evd
- state_compressor1
- state_compressor2
- state_extheater
- state_alarm
- state_cooling
- state_water
- state_pool
- state_solar
- state_cooling4way

Not so common ones:
- temperature_heating_set2
- temperature_cooling_set2
- temperature_pool_set2
- temperature_water_set2
- state
- temperature_evaporation
- temperature_suction
- pressure_evaporation
- temperature_condensation
- pressure_condensation
- temperature_storage
- position_expansion_valve

As a result, your lines in the items file might look like the following:

    /* Waterkotte EcoTouch heat pump DEMO */
    Group Heatpump
    Group Heatpump_outside
    Group Heatpump_source
    Group Heatpump_control
    Group Heatpump_water
    Group Heatpump_heating
    Group Heatpump_power
    Group Heatpump_state
    Number Chart_Period "Chart Period"
    Number HeatPump_Temperature_3   "Wärmepumpe Außentemperatur [%.1f °C]"   <temperature> (Heatpump,Heatpump_outside) { ecotouch="temperature_outside" }
    Number HeatPump_Temperature_4   "Wärmepumpe Außentemperatur 1h [%.1f °C]"   <temperature> (Heatpump,Heatpump_outside) { ecotouch="temperature_outside_1h" }
    Number HeatPump_Temperature_5   "Wärmepumpe Außentemperatur 24h [%.1f °C]"   <temperature> (Heatpump,Heatpump_outside) { ecotouch="temperature_outside_24h" }
    Number HeatPump_Temperature_6   "Wärmepumpe Quelleneintrittstemperatur [%.1f °C]"   <temperature> (Heatpump,Heatpump_source) { ecotouch="temperature_source_in" }
    Number HeatPump_Temperature_7   "Wärmepumpe Quellenaustrittstemperatur [%.1f °C]"   <temperature> (Heatpump,Heatpump_source) { ecotouch="temperature_source_out" }
    Number HeatPump_Temperature_8   "Wärmepumpe Vorlauf [%.1f °C]"   <temperature> (Heatpump,Heatpump_control) { ecotouch="temperature_flow" }
    Number HeatPump_Temperature_9   "Wärmepumpe Rücklauf [%.1f °C]"   <temperature> (Heatpump,Heatpump_control) { ecotouch="temperature_return" }
    Number HeatPump_Temperature_10   "Wärmepumpe Rücklauf Soll [%.1f °C]"   <temperature> (Heatpump,Heatpump_control) { ecotouch="temperature_return_set" }
    Number HeatPump_Temperature_11   "Wärmepumpe Warmwasser Ist [%.1f °C]"   <temperature> (Heatpump,Heatpump_water) { ecotouch="temperature_water" }
    Number HeatPump_Temperature_12   "Wärmepumpe Warmwasser Soll [%.1f °C]"   <temperature> (Heatpump,Heatpump_water) { ecotouch="temperature_water_set" }
    Number HeatPump_Temperature_13   "Wärmepumpe Warmwasser Soll2 [%.1f °C]"   <temperature> (Heatpump,Heatpump_water) { ecotouch="temperature_water_set2" }
    Number HeatPump_Temperature_14   "Wärmepumpe Heizung Ist [%.1f °C]"   <temperature> (Heatpump,Heatpump_heating) { ecotouch="temperature_heating_return" }
    Number HeatPump_Temperature_15   "Wärmepumpe Heizung Soll [%.1f °C]"   <temperature> (Heatpump,Heatpump_heating) { ecotouch="temperature_heating_set" }
    Number HeatPump_Temperature_16   "Wärmepumpe Heizung Soll2 [%.1f °C]"   <temperature> (Heatpump,Heatpump_heating) { ecotouch="temperature_heating_set2" }
    Number HeatPump_power_1   "Wärmepumpe elektrische Leistung [%.1f kW]"   <energy> (Heatpump,Heatpump_power) { ecotouch="power_compressor" }
    Number HeatPump_power_2   "Wärmepumpe thermische Leistung [%.1f kW]"   <energy> (Heatpump,Heatpump_power) { ecotouch="power_heating" }
    Number HeatPump_state            "Wärmepumpe Status [%i]"   <settings> (Heatpump) { ecotouch="state" }
    Number HeatPump_state_sourcepump "Wärmepumpe Status Quellenpumpe [%i]"   <settings> (Heatpump,Heatpump_state) { ecotouch="state_sourcepump" }
    Number HeatPump_state_heatingpump "Wärmepumpe Status Heizungsumwälzpumpe [%i]"   <settings> (Heatpump,Heatpump_state) { ecotouch="state_heatingpump" }
    Number HeatPump_state_compressor1 "Wärmepumpe Status Kompressor [%i]"   <settings> (Heatpump,Heatpump_state) { ecotouch="state_compressor1" }
    Number HeatPump_state_water      "Wärmepumpe Status Motorventil Warmwasser[%i]"   <settings> (Heatpump,Heatpump_state) { ecotouch="state_water" }

## Sitemap Example

        Frame label="Waterkotte" {
                Text item=HeatPump_Temperature_3 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_outside period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_outside period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_outside period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_6 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_source period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_source period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_source period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_7 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_source period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_source period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_source period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_8 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_control period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_control period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_control period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_9 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_control period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_control period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_control period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_10 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_control period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_control period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_control period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_11 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_water period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_water period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_water period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_12 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_water period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_water period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_water period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_13 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_water period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_water period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_water period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_14 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_heating period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_heating period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_heating period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_15 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_heating period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_heating period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_heating period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_Temperature_16 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_heating period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_heating period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_heating period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_power_1 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_power period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_power period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_power period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
                Text item=HeatPump_power_2 {
                        Frame {
                                Switch item=Chart_Period label="Chart Period" mappings=[0="Hour", 1="Day", 2="Week"]
                                Chart item=Heatpump_power period=h refresh=60000 visibility=[Chart_Period==0, Chart_Period=="Uninitialized"]
                                Chart item=Heatpump_power period=D refresh=60000 visibility=[Chart_Period==1]
                                Chart item=Heatpump_power period=W refresh=60000 visibility=[Chart_Period==2]
                        }
                }
        }


## Gallery

The following charts are created via the rrd4j chart and heatpump bundle. <br/>

![outside temperature](https://github.com/sibbi77/openhab/wiki/images/binding-ecotouch_chart1.png)

![power consumption](https://github.com/sibbi77/openhab/wiki/images/binding-ecotouch_chart2.png)

## Further planned features (not yet implemented)

- change set points of heat pump (currently all values are read only)
 