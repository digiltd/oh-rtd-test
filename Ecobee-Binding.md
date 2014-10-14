Documentation of the Ecobee binding Bundle.

## Introduction

Ecobee Inc. of Toronto, Canada, sells a range of Wi-Fi enabled thermostats, principally in the Americas.  The EMS, EMS Si, Smart, Smart Si and ecobee3 models are supported by this binding, which communicates with the Ecobee API over a secure, RESTful API to Ecobee's servers. Monitoring ambient temperature and humidity, changing HVAC mode, changing heat or cool setpoints, changing the backlight intensity, and even sending textual messages to one or a group of thermostats, can be accomplished through this binding.

In order to use this binding, you must have already registered your thermostat(s) with Ecobee, and then login to the web portal at [www.ecobee.com](https://www.ecobee.com/).

For installation of the binding, please see Wiki page [Bindings](Bindings).

The snapshot version of the binding can be downloaded, together with the rest of openhab, from the [cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/) page.

## Binding Configuration

In order to use the Ecobee API, you must specify the `appkey` and `scope` that will be used.  These values must be set in the openhab.cfg file (in the folder '${openhab_home}/configurations'). The refresh interval can also be specified, and defaults to 60000ms (one minute).

    ############################## Ecobee binding ########################################
    #
    # Data refresh interval in ms (optional, defaults to 60000)
    # ecobee:refresh=60000

    # the temperature scale to use when sending or receiving temperatures
    # defaults to Fahrenheit (F)
    ecobee:tempscale=C

    # the private API key issued be Ecobee to use the API
    ecobee:appkey=9T4huoUXlT5vMssqTb5qNpEJMgaNCFoV

    # the application scope used when authorizing the binding
    # choices are smartWrite,smartRead, or ems, or multiple (comma-separated, no spaces)
    ecobee:scope=smartWrite

You can set up multiple, distinct API connections by repeating the `appkey` and `scope` settings with a prepended "user ID" that indicates a separate ecobee.com account will be used to complete authorization.

    ecobee:condo.appkey=T5vMsUXlpEsqT4huoJb5qN9TMgaNCFoV
    ecobee:condo.scope=smartRead

You would then include `condo.` in item references (see below) for those thermostats available from the "condo" account.

## Item configuration

In order to bind an item to a thermostat's properties and functions, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the Ecobee binding configuration string is explained below.

Ecobee bindings start with a `<`, `>` or `=`, to indicate if the item receives values from the API (in binding), sends values to the API (out binding), or both (bidirectional binding), respectively.

The first character is then followed by a section between square brackets (\[and \] characters):

```
[<thermostat>#<property>]
```

Where `<thermostat>` is a decimal thermostat identifier for in (`<`), out (`>`) and bidirectional (`=`) bindings.

For out (`>`) bindings only, `<thermostat>` can instead be selection criteria that specify which thermostats to change. You can use either a comma-separated list of thermostat identifiers (no spaces), or, for non-EMS thermostats only, a wildcard (the `*` character).

In the case of out bindings for EMS or Utility accounts, the `<thermostat>` criteria can be a path to a management set (for example, `/Toronto/Campus/BuildingA`).  Please note that management set path elements that contain the `.` or `#` characters cannot be specified.

The `<thermostat>` specification can be optionally prepended with a specific "user ID" as specified in openhab.cfg, as in `condo.123456789` when you have specified `ecobee:condo.scope` and `ecobee:condo.appkey` properties in openhab.cfg.

`<property>` is one of a long list of thermostat properties than you can read and optionally change. See the list below, and peruse this binding's JavaDoc for all specifics as to their meanings.

<table>
<thead><tr><th>Property</th><th>In</th><th>Out</th><th>Type</th></tr></thead>
<tbody>
<tr><td>name</td><td>X</td><td>X</td><td>StringType</td></tr>
<tr><td>runtime.actualTemperature</td><td>X</td><td></td><td>DecimalType</td></tr>
<tr><td>runtime.actualHumidity</td><td>X</td><td></td><td>DecimalType</td></tr>
<tr><td>settings.hvacMode</td><td>X</td><td>X</td><td>StringType</td></tr>
</tbody>
</table>


## Example Binding Strings

```
{ ecobee="=[123456789#name]" }
```

Return or set the name of the thermostat whose ID is 123456789 using the default
Ecobee app instance (configured in openhab.cfg).

```
{ ecobee="<[condo.987654321#runtime.actualTemperature]" }
```

Return the current temperature read by the thermostat using the condo account
at ecobee.com.

```
{ ecobee="=[543212345#settings.fanMinOnTime]" }
```

Return or set the minimum number of minutes per hour the fan will run on thermostat ID
543212345.

```
{ ecobee=">[*#settings.hvacMode]" }
```

Change the HVAC mode to one of "auto", "auxHeatOnly", "cool", "heat", or
"off" on all thermostats registered in the default app instance.

```
{ ecobee=">[lakehouse.*#settings.backlightSleepIntensity]" }
```

Changes the backlight sleep intensity on all thermostats at the lake house
(meaning, all thermostats registered to the lakehouse Ecobee account).

## Known Issues

## Examples

Here are some examples of valid binding configuration strings, as defined in the items configuration file:

TBD    

## Logging


In order to configure logging for this binding to be generated in a separate file add the following to your /configuration/logback.xml file;
```xml
<appender name="ECOBEEFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
   <file>logs/ecobee.log</file>
   <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <!-- weekly rollover and archiving -->
      <fileNamePattern>logs/ecobee-%d{yyyy-ww}.log.zip</fileNamePattern>
      <!-- keep 30 days' worth of history -->
      <maxHistory>30</maxHistory>
   </rollingPolicy>
   <encoder>
     <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} %-5level %logger{30}[:%line]- %msg%n%ex{5}</pattern>
   </encoder>
</appender>
    
<!-- Change DEBUG->TRACE for even more detailed logging -->
<logger name="org.openhab.binding.ecobee" level="DEBUG" additivity="false">
   <appender-ref ref="ECOBEEFILE" />
</logger>
```

