## Introduction

Nest Labs developed the Wi-Fi enabled Nest Learning Thermostat and the Protect Smoke+CO detector.  These devices are supported by this binding, which communicates with the Nest API over a secure, RESTful API to Nest's servers. Monitoring ambient temperature and humidity, changing HVAC mode, changing heat or cool setpoints, monitoring and changing your "home/away" status, and monitoring your Nest Protects can be accomplished through this binding.

In order to use this binding, you will have to register as a [Nest Developer](https://nest.com/developer/) and [Register a new client](https://developer.nest.com/clients/new).  Make sure to grant all the permissions you intend to use.  At this point, you will have your `client_id` and `client_secret`.

Once you've created your [client](https://developer.nest.com/clients), paste the Authorization URL into a new tab in your browser.  This will have you login to your normal Nest account, and will then present the `pin_code`.

For installation of the binding, please see the Wiki page [Bindings](Bindings).

## Binding Configuration

In order to use the Nest API, you must specify the `client_id`, `client_secret` and `pincode` that will be used.  These values must be set in the `openhab.cfg` file (in the folder '${openhab_home}/configurations'). The refresh interval can also be specified, and defaults to 60000ms (one minute).

### nest:refresh

How often, in milliseconds, to update states.  Don't do it too frequently or you will hit API limits.

```
nest:refresh=60000
```

## Authentication

You will have to register as a [Nest Developer](https://nest.com/developer/) and [Register a new client](https://developer.nest.com/clients/new).  Make sure to grant all the permissions you intend to use.

Once you've created your [client](https://developer.nest.com/clients), paste the Authorization URL into a new tab in your browser.  This will have you login to your normal Nest account, and will then present the PIN code.

Paste all three of these values into your openhab.cfg file like so (using your actual values):

    ############################## Nest binding ########################################
    #
    # Data refresh interval in ms (optional, defaults to 60000)
    # nest:refresh=60000

    # the Client ID for the client you created (replace with your own)
    nest:client_id=e5cc5558-ec55-4c55-8555-4b95555f4979

    # the Client Secret for the client you created (replace with your own)
    nest:client_secret=ZZo28toiuoiurok4WjUya1Bnc

    # the PIN code that was generated when you authorized your account to allow
    # this client
    nest:pin_code=2JTXXXJL

## Item configuration

In order to bind an item to a Nest Learning Thermostat's or Nest Protect's properties, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder `configurations/items`). The syntax for the Nest binding configuration string is explained below.

Nest bindings start with a `<`, `>` or `=`, to indicate if the item receives values from the API (in binding), sends values to the API (out binding), or both (bidirectional binding), respectively.

The first character is then followed by a section between square brackets (\[and \] characters):

```
<[<property>]
```

where `<property>` is one of a long list of properties than you can read and optionally change. See the list below, and peruse the [Nest API Reference](https://developer.nest.com/documentation/api-reference) for all specifics as to their meanings.

Since device and structure identifiers are so unwieldy, binding configurations allow you to use the device's textual name as a reference.  Whatever name you see in the web or mobile client is the name you would supply in an item's binding configuration.  So, for example, in order to determine the current humidity detected at the thermostat named 'Living Room', your binding configuration would look like this:

```
Number humidity "humidity [%d %%]" { nest="<[thermostats(Living Room).humidity]" }
```

### Handling special characters

With the convenience of using simple names for structures, thermostats and smoke+CO detectors comes the price of having to handle special characters in the names.  Any characters in a name that could interfere with the parsing of the binding configuration string need to be either 1) removed from the device name in your account at nest.com, or 2) replaced with "URL-encoded" versions.  The characters that have to be replaced are `[`,`]`,`(`, `)`, `,`, `.` and `+`.  Here are some examples:

The display name you see at nest.com | The escaped version to use in the Nest binding
-------------------------------------|-----------------------------------------------
Dining Room (Ground Floor) | Dining Room %28Ground Floor%29
Den Smoke+CO | Den Smoke%2BCO
123 Main St. | 123 Main St%2E
Bogota, Colombia | Bogota%2C Colombia
[Basement] | %5BBasement%5D

To reiterate, you could change the display names of your devices at nest.com, and thereby avoid having to put escaped versions in your binding configuration strings.

In order to change the current HVAC mode of the Living room thermostat between `off`, `heat`, `cool` and `heat-cool`, your item would look like this:

```
String hvac_mode "HVAC Mode [%s]" { nest="=[thermostats(Living Room).hvac_mode]" }
```

When you update the device with one of the four possible valid strings, you will change the HVAC mode.

Below are some examples of valid binding configuration strings, as you would define in the your .items file.  The examples represent the current set of available properties, and for each property, the example shows if it is an in-binding only (read-only), an out-binding only (write-only), or a bidirectional (read/write) binding only.

```
/* Nest binding items */

/* Structures */

String struct_name "name [%s]"                 { nest="<[structures(Name).name]" }
String struct_country_code "country_code [%s]" { nest="<[structures(Name).country_code]" }
String struct_postal_code "postal_code [%s]"   { nest="<[structures(Name).postal_code]" }
String struct_time_zone "time_zone [%s]"       { nest="<[structures(Name).time_zone]" }
String struct_away "away [%s]"                 { nest="=[structures(Name).away]" }
String struct_structure_id "structure_id [%s]" { nest="<[structures(Name).structure_id]" }
String struct_eta_trip_id "eta_trip_id [%s]"   { nest=">[structures(Name).eta.trip_id]" }
DateTime struct_eta_estimated_arrival_window_begin "estimated_arrival_window_begin [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" { nest=">[structures(Name).eta.estimated_arrival_window_begin]" }
DateTime struct_eta_estimated_arrival_window_end "estimated_arrival_window_end [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" { nest=">[structures(Name).eta.estimated_arrival_window_end]" }

/* Thermostats */

Number therm_humidity "humidity [%d %%]"                { nest="<[thermostats(Name).humidity]" }
String therm_locale "locale [%s]"                       { nest="<[thermostats(Name).locale]" }
String therm_temperature_scale "temperature_scale [%s]" { nest="<[thermostats(Name).temperature_scale]" }
Switch therm_is_using_emergency_heat "is_using_emergency_heat [%s]" { nest="<[thermostats(Name).is_using_emergency_heat]" }
Switch therm_has_fan "has_fan [%s]"                     { nest="<[thermostats(Name).has_fan]" }
Switch therm_software_version "software_version [%s]"   { nest="<[thermostats(Name).software_version]" }
Switch therm_has_leaf "has_leaf [%s]"                   { nest="<[thermostats(Name).has_leaf]" }
String therm_device_id "device_id [%s]"                 { nest="<[thermostats(Name).device_id]" }
String therm_name "name [%s]"                           { nest="<[thermostats(Name).name]" }
Switch therm_can_heat "can_heat [%s]"                   { nest="<[thermostats(Name).can_heat]" }
Switch therm_can_cool "can_cool [%s]"                   { nest="<[thermostats(Name).can_cool]" }
String therm_hvac_mode "hvac_mode [%s]"                 { nest="=[thermostats(Name).hvac_mode]" }
Number therm_target_temperature_c "target_temperature_c [%.1f °C]"           { nest="=[thermostats(Name).target_temperature_c]" }
Number therm_target_temperature_f "target_temperature_f [%.1f °F]"           { nest="=[thermostats(Name).target_temperature_f]" }
Number therm_target_temperature_high_c "target_temperature_high_c [%.1f °C]" { nest="=[thermostats(Name).target_temperature_high_c]" }
Number therm_target_temperature_high_f "target_temperature_high_f [%.1f °F]" { nest="=[thermostats(Name).target_temperature_high_f]" }
Number therm_target_temperature_low_c "target_temperature_low_c [%.1f °C]"   { nest="=[thermostats(Name).target_temperature_low_c]" }
Number therm_target_temperature_low_f "target_temperature_low_f [%.1f °F]"   { nest="=[thermostats(Name).target_temperature_low_f]" }
Number therm_ambient_temperature_c "ambient_temperature_c [%.1f °C]"         { nest="<[thermostats(Name).ambient_temperature_c]" }
Number therm_ambient_temperature_f "ambient_temperature_f [%.1f °F]"         { nest="<[thermostats(Name).ambient_temperature_f]" }
Number therm_away_temperature_high_c "away_temperature_high_c [%.1f °C]"     { nest="<[thermostats(Name).away_temperature_high_c]" }
Number therm_away_temperature_high_f "away_temperature_high_f [%.1f °F]"     { nest="<[thermostats(Name).away_temperature_high_f]" }
Number therm_away_temperature_low_c "away_temperature_low_c [%.1f °C]"       { nest="<[thermostats(Name).away_temperature_low_c]" }
Number therm_away_temperature_low_f "away_temperature_low_f [%.1f °F]"       { nest="<[thermostats(Name).away_temperature_low_f]" }
String therm_structure_id "structure_id [%s]"           { nest="<[thermostats(Name).structure_id]" }
Switch therm_fan_timer_active "fan_timer_active [%s]"   { nest="=[thermostats(Name).fan_timer_active]" }
String therm_name_long "name_long [%s]"                 { nest="<[thermostats(Name).name_long]" }
Switch therm_is_online "is_online [%s]"                 { nest="<[thermostats(Name).is_online]" }
DateTime therm_last_connection "last_connection [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" { nest="<[thermostats(Name).last_connection]" }

/* Smoke+CO detectors */

String smoke_name "name [%s]"                           { nest="<[smoke_co_alarms(Name).name]" }
String smoke_locale "locale [%s]"                       { nest="<[smoke_co_alarms(Name).locale]" }
String smoke_structure_id "structure_id [%s]"           { nest="<[smoke_co_alarms(Name).structure_id]" }
String smoke_software_version "software_version [%s]"   { nest="<[smoke_co_alarms(Name).software_version]" }
String smoke_device_id "device_id [%s]"                 { nest="<[smoke_co_alarms(Name).device_id]" }
String smoke_name_long "name_long [%s]"                 { nest="<[smoke_co_alarms(Name).name_long]" }
Switch smoke_is_online "is_online [%s]"                 { nest="<[smoke_co_alarms(Name).is_online]" }
DateTime smoke_last_connection "last_connection [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" { nest="<[smoke_co_alarms(Name).last_connection]" }
String smoke_battery_health "battery_health [%s]"       { nest="<[smoke_co_alarms(Name).battery_health]" }
String smoke_smoke_alarm_state "smoke_alarm_state [%s]" { nest="<[smoke_co_alarms(Name).co_alarm_state]" }
String smoke_co_alarm_state "co_alarm_state [%s]"       { nest="<[smoke_co_alarms(Name).smoke_co_alarm_state]" }
String smoke_ui_color_state "ui_color_state [%s]"       { nest="<[smoke_co_alarms(Name).ui_color_state]" }
Switch smoke_is_manual_test_active "is_manual_test_active [%s]" { nest="<[smoke_co_alarms(Name).is_manual_test_active]" }
DateTime smoke_last_manual_test_time "last_manual_test_time [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" { nest="<[smoke_co_alarms(Name).last_manual_test_time]" }

/* You can reference a device in a specific structure in the case that there are duplicate names 
 * in multiple structures. 
 */

NOT A REAL ITEM { nest="<[structures(Name).smoke_co_alarms(Name).SEE_ABOVE]" }
NOT A REAL ITEM { nest="<[structures(Name).thermostats(Name).SEE_ABOVE]" }
```

## Known Issues

1. Multiple instance support (allowing the binding to access multiple Nest accounts at once) conflicts with Prohibition 3 of the [Nest Developer Terms of Service](https://developer.nest.com/documentation/cloud/tos), and so is not implemented.
2. The Nest API rounds humidity to 5%, degrees Fahrenheit to whole degrees, and degrees Celsius to 0.5 degrees.  So your Nest app will likely show slightly different values from what is available from the API.

## Logging

In order to configure logging for this binding to be generated in a separate file add the following to your /configuration/logback.xml file;
```xml
<appender name="NESTFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
   <file>logs/nest.log</file>
   <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <!-- weekly rollover and archiving -->
      <fileNamePattern>logs/nest-%d{yyyy-ww}.log.zip</fileNamePattern>
      <!-- keep 30 days' worth of history -->
      <maxHistory>30</maxHistory>
   </rollingPolicy>
   <encoder>
     <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} %-5level %logger{30}[:%line]- %msg%n%ex{5}</pattern>
   </encoder>
</appender>
    
<!-- Change DEBUG->TRACE for even more detailed logging -->
<logger name="org.openhab.binding.nest" level="DEBUG" additivity="false">
   <appender-ref ref="NESTFILE" />
</logger>
```
