_**Note:** This Binding will be available in the upcoming 1.7 Release. For preliminary builds please see the [CI server at Cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/)._

## Introduction

[Nest Labs](https://nest.com/) developed the Wi-Fi enabled Nest Learning Thermostat and the Nest Protect Smoke+CO detector.  These devices are supported by this binding, which communicates with the Nest API over a secure, RESTful API to Nest's servers. Monitoring ambient temperature and humidity, changing HVAC mode, changing heat or cool setpoints, monitoring and changing your "home/away" status, and monitoring your Nest Protects can be accomplished through this binding.

In order to use this binding, you will have to register as a [Nest Developer](https://nest.com/developer/) and [Register a new client](https://developer.nest.com/clients/new).  Make sure to grant all the permissions you intend to use.  At this point, you will have your `client_id` and `client_secret`.

Once you've created your [client](https://developer.nest.com/clients), paste the Authorization URL into a new tab in your browser.  This will have you login to your normal Nest account, and will then present the `pin_code`.

For installation of the binding, please see the Wiki page [Bindings](Bindings).

## Binding Configuration

In order to use the Nest API, you must specify the `nest:client_id`, `nest:client_secret` and `nest:pin_code` parameters to be used in interactions with Nest's cloud service.

These values must be set in the `openhab.cfg` file in `${openhab_home}/configurations/`.

An optional _refresh interval_ setting may also be specified, via the `nest:refresh` parameter, and defaults to a polling rate of one call per every 60000ms (one minute).

:warning: Setting the _refresh interval_ aggressively may cause you to hit [data rate limits](https://developer.nest.com/documentation/cloud/data-rate-limits).  Nest Documentation recommends the `nest:refresh` not be set lower than 60000.

```
nest:refresh=60000
```

## Nest Authorization

You will have to register as a [Nest Developer](https://nest.com/developer/) and [Register a new client](https://developer.nest.com/clients/new).  Make sure to grant all the permissions you intend to use.

Once you've created your [client](https://developer.nest.com/clients), paste the Authorization URL into a new tab in your browser.  This will have you login to your normal Nest account, and will present the Nest generated PIN code.

Paste all three of these values into your `openhab.cfg` file like so (using _your_ values):

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

In order to bind an Item to a Nest Learning Thermostat's or Nest Protect's properties, you need to provide configuration settings. The easiest way to do so is to add some binding information in your Item file (in  `configurations/items/`). The syntax for the Nest binding configuration string is explained below.

Nest bindings start with a `<`, `>` or `=`, to indicate if the Item receives values from the API (in binding), sends values to the API (out binding), or both (bidirectional binding), respectively.

The first character is then followed by a section between square brackets (\[and \] characters):

```
<[<property>]
```

where `<property>` is one of a long list of properties than you can read and optionally change. See the list below, and peruse the [Nest API Reference](https://developer.nest.com/documentation/api-reference) for all specifics as to their meanings.

Since device and structure identifiers are very long, cryptic strings that are hard to learn, binding configurations allow you to use the device's textual name as a reference.  Whatever name you see in the web or mobile client is the name you would supply in an Item's binding configuration.  So, for example, in order to determine the current humidity detected at the thermostat named 'Living Room', your binding configuration would look like this:

```
Number NestTStatUpstairs_humidity "Humidity [%d %%]" {nest="<[thermostats(Living Room).humidity]"}
```

### Handling special characters

With the convenience of using simple names for structures, thermostats and smoke+CO detectors, comes the price of having to handle special characters in the names.  Any characters in a name that could interfere with the parsing of the binding configuration string need to be either 1) removed from the device name in your account at nest.com, or 2) replaced with "URL-encoded" versions.  The characters that have to be replaced are `[`, `]`, `(`, `)`, `,`, `.` and `+`.  Here are some examples:

What you see at nest.com | The escaped version to use in the Nest binding
-------------------------------------|-----------------------------------------------
Dining Room (Ground Floor) | Dining Room %28Ground Floor%29
Den Smoke+CO | Den Smoke%2BCO
123 Main St. | 123 Main St%2E
Bogota, Colombia | Bogota%2C Colombia
[Basement] | %5BBasement%5D

To reiterate, you could change the display names of your devices at nest.com, and thereby avoid having to put escaped versions in your binding configuration strings.

In order to change the current HVAC mode of the Living room thermostat between `off`, `heat`, `cool` and `heat-cool`, your Item would look like:

```
String NestTStatUpstairs_hvac_mode "HVAC Mode [%s]" {nest="=[thermostats(Living Room).hvac_mode]"}
```

When you update the device with one of the four possible valid strings, you will change the HVAC mode.

Below are some examples of valid binding configuration strings, as you would define in the your .items file.  The examples represent the current set of available properties, and for each property, the example shows if it is an in-binding only (read-only), an out-binding only (write-only), or a bidirectional (read/write) binding only.  Note, however, that if a read/write property is only authorized for read-only access in the client you authorized, an attempt to change its value will fail.

In this example, there is a Nest Account called `Home`, a Thermostat called `Upstairs` and a Smoke/CO Sensor called `Master Bedroom`

```
/* Nest binding Items */

/* Structures - change Home to your structure's name */

String   Nest_name "Name [%s]"                 {nest="<[structures(Home).name]"}
String   Nest_country_code "Country Code [%s]" {nest="<[structures(Home).country_code]"}
String   Nest_postal_code "Postal Code [%s]"   {nest="<[structures(Home).postal_code]"}
String   Nest_time_zone "Time Zone [%s]"       {nest="<[structures(Home).time_zone]"}
String   Nest_away "Away [%s]"                 {nest="=[structures(Home).away]"}
String   Nest_structure_id "Structure Id [%s]" {nest="<[structures(Home).structure_id]"}

/* Thermostats - change Upstairs to your thermostat's name */

Number   NestTStatUpstairs_humidity "Humidity [%d %%]"                                   {nest="<[thermostats(Upstairs).humidity]"}
String   NestTStatUpstairs_locale "Locale [%s]"                                          {nest="<[thermostats(Upstairs).locale]"}
String   NestTStatUpstairs_temperature_scale "Temperature Scale [%s]"                    {nest="<[thermostats(Upstairs).temperature_scale]"}
Switch   NestTStatUpstairs_is_using_emergency_heat "Is using emergency heat [%s]"        {nest="<[thermostats(Upstairs).is_using_emergency_heat]"}
Switch   NestTStatUpstairs_has_fan "Has Fan [%s]"                                        {nest="<[thermostats(Upstairs).has_fan]"}
String   NestTStatUpstairs_software_version "Software Version [%s]"                      {nest="<[thermostats(Upstairs).software_version]"}
Switch   NestTStatUpstairs_has_leaf "Has Leaf [%s]"                                      {nest="<[thermostats(Upstairs).has_leaf]"}
String   NestTStatUpstairs_device_id "Device Id [%s]"                                    {nest="<[thermostats(Upstairs).device_id]"}
String   NestTStatUpstairs_name "Name [%s]"                                              {nest="<[thermostats(Upstairs).name]"}
Switch   NestTStatUpstairs_can_heat "Can Heat [%s]"                                      {nest="<[thermostats(Upstairs).can_heat]"}
Switch   NestTStatUpstairs_can_cool "Can Cool [%s]"                                      {nest="<[thermostats(Upstairs).can_cool]"}
String   NestTStatUpstairs_hvac_mode "HVAC Mode [%s]"                                    {nest="=[thermostats(Upstairs).hvac_mode]"}
Number   NestTStatUpstairs_target_temperature_c "Target Temperature [%.1f °C]"           {nest="=[thermostats(Upstairs).target_temperature_c]"}
Number   NestTStatUpstairs_target_temperature_f "Target Temperature [%.1f °F]"           {nest="=[thermostats(Upstairs).target_temperature_f]"}
Number   NestTStatUpstairs_target_temperature_high_c "Target Temperature High [%.1f °C]" {nest="=[thermostats(Upstairs).target_temperature_high_c]"}
Number   NestTStatUpstairs_target_temperature_high_f "Target Temperature High [%.1f °F]" {nest="=[thermostats(Upstairs).target_temperature_high_f]"}
Number   NestTStatUpstairs_target_temperature_low_c "Target Temperature Low [%.1f °C]"   {nest="=[thermostats(Upstairs).target_temperature_low_c]"}
Number   NestTStatUpstairs_target_temperature_low_f "Target Temperature Low [%.1f °F]"   {nest="=[thermostats(Upstairs).target_temperature_low_f]"}
Number   NestTStatUpstairs_ambient_temperature_c "Ambient Temperature [%.1f °C]"         {nest="<[thermostats(Upstairs).ambient_temperature_c]"}
Number   NestTStatUpstairs_ambient_temperature_f "Ambient Temperature [%.1f °F]"         {nest="<[thermostats(Upstairs).ambient_temperature_f]"}
Number   NestTStatUpstairs_away_temperature_high_c "Away Temperature High [%.1f °C]"     {nest="<[thermostats(Upstairs).away_temperature_high_c]"}
Number   NestTStatUpstairs_away_temperature_high_f "Away Temperature High [%.1f °F]"     {nest="<[thermostats(Upstairs).away_temperature_high_f]"}
Number   NestTStatUpstairs_away_temperature_low_c "Away Temperature Low [%.1f °C]"       {nest="<[thermostats(Upstairs).away_temperature_low_c]"}
Number   NestTStatUpstairs_away_temperature_low_f "Away Temperature Low [%.1f °F]"       {nest="<[thermostats(Upstairs).away_temperature_low_f]"}
String   NestTStatUpstairs_structure_id "Structure Id [%s]"                              {nest="<[thermostats(Upstairs).structure_id]"}
Switch   NestTStatUpstairs_fan_timer_active "Fan Timer Active [%s]"                      {nest="=[thermostats(Upstairs).fan_timer_active]"}
DateTime NestTStatUpstairs_fan_timer_timeout "Fan Timer Timeout [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" <calendar> {nest="<[thermostats(Upstairs).fan_timer_timeout]"}
String   NestTStatUpstairs_name_long "Name Long [%s]"                                    {nest="<[thermostats(Upstairs).name_long]"}
Switch   NestTStatUpstairs_is_online "Is Online [%s]"                                    {nest="<[thermostats(Upstairs).is_online]"}
DateTime NestTStatUpstairs_last_connection "Last Connection [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" <calendar> {nest="<[thermostats(Upstairs).last_connection]"}

/* Smoke+CO detectors - change Master Bedroom to your Smoke+CO detector's name */

String   NestSmokeMaster_name "Name [%s]"                                   {nest="<[smoke_co_alarms(Master Bedroom).name]"}
String   NestSmokeMaster_locale "Locale [%s]"                               {nest="<[smoke_co_alarms(Master Bedroom).locale]"}
String   NestSmokeMaster_structure_id "Structure Id [%s]"                   {nest="<[smoke_co_alarms(Master Bedroom).structure_id]"}
String   NestSmokeMaster_software_version "Software Version [%s]"           {nest="<[smoke_co_alarms(Master Bedroom).software_version]"}
String   NestSmokeMaster_device_id "Device Id [%s]"                         {nest="<[smoke_co_alarms(Master Bedroom).device_id]"}
String   NestSmokeMaster_name_long "Name Long [%s]"                         {nest="<[smoke_co_alarms(Master Bedroom).name_long]"}
Switch   NestSmokeMaster_is_online "Is Online [%s]"                         {nest="<[smoke_co_alarms(Master Bedroom).is_online]"}
DateTime NestSmokeMaster_last_connection "Last Connection [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" <calendar> {nest="<[smoke_co_alarms(Master Bedroom).last_connection]"}
String   NestSmokeMaster_battery_health "Battery Health [%s]"               {nest="<[smoke_co_alarms(Master Bedroom).battery_health]"}
String   NestSmokeMaster_smoke_alarm_state "Smoke Alarm State [%s]"         {nest="<[smoke_co_alarms(Master Bedroom).smoke_alarm_state]"}
String   NestSmokeMaster_co_alarm_state "CO Alarm State [%s]"               {nest="<[smoke_co_alarms(Master Bedroom).co_alarm_state]"}
String   NestSmokeMaster_ui_color_state "UI Color State [%s]"               {nest="<[smoke_co_alarms(Master Bedroom).ui_color_state]"}
Switch   NestSmokeMaster_is_manual_test_active "Is Manual Test Active [%s]" {nest="<[smoke_co_alarms(Master Bedroom).is_manual_test_active]"}
DateTime NestSmokeMaster_last_manual_test_time "Last Manual Test Time [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" <calendar> {nest="<[smoke_co_alarms(Master Bedroom).last_manual_test_time]"}


/* You can reference a device in a specific structure in the case that there are duplicate names 
 * in multiple structures. If you have duplicate-named thermostats or smoke+CO detectors in the
 * same structure, or duplicate-named structures, you will have to rename them at nest.com.
 */

Number NestHome_temp "Home temperature [%.1f °F]"   {nest="<[structures(Home).thermostats(Dining Room).ambient_temperature_f]"}
Number NestCondo_temp "Condo temperature [%.1f °F]" {nest="<[structures(Condo).thermostats(Dining Room).ambient_temperature_f]"}
```

## Binding Examples

* [[Nest Binding Example (new)|Nest-Binding-Example]]

  ![sample](https://lh4.googleusercontent.com/-3xl5cUr2wqs/VPo41XcUkAI/AAAAAAAAAvc/s8xY5gHuC0I/s1600/sample.jpg)


## Known Issues

1. Multiple instance support (allowing the binding to access multiple Nest accounts at once) conflicts with Prohibition 3 of the [Nest Developer Terms of Service](https://developer.nest.com/documentation/cloud/tos), and so is not implemented.
2. The Nest API rounds humidity to 5%, degrees Fahrenheit to whole degrees, and degrees Celsius to 0.5 degrees, so your Nest app will likely show slightly different values from what is available from the API.
3. There is currently a bug where attempting to update an Item with a binding configuration of this form will not work:
```
Number NestCondo_temp "Condo Temperature [%.1f °F]" {nest="=[structures(Condo).thermostats(Dining Room).target_temperature_f]"}
```
While this form should work:
```
Number NestCondo_temp "Condo Temperature [%.1f °F]" {nest="=[thermostats(Dining Room).target_temperature_f]"}
```

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
    
<!-- Choose level ERROR, WARN, INFO, DEBUG or TRACE for detailedlogging -->
<logger name="org.openhab.binding.nest" level="TRACE" additivity="false">
   <appender-ref ref="NESTFILE" />
</logger>
```