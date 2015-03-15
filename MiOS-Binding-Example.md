## [[MiOS Binding|MiOS-Binding]] Example

This document is intended to provide [[MiOS Binding|MiOS-Binding]] users with real-world example openHAB configurations.

Users typically have configurations falling into one or more of the following categories, which will be used to outline any subsequent examples:

* Augmenting - openHAB Rules that "add" to existing MiOS Scenes.
* Co-existing - Replacing MiOS Scenes with openHAB Rules, but keeping the Devices.
* Replacing - wholesale replacement of MiOS functionality (Devices|Scenes) with openHAB equivalent functionality.

### Examples for Augmenting
#### Adding Notifications and Text-to-Speech (TTS) when a House Alarm is triggered
MiOS has a standardized definition that most Alarm Panel plugins adhere to (DSC, Ademco, GE Caddx, Paradox, etc).  This exposes a standardized UPnP-style attribute, `AlarmPartition2/Alarm`, for the Alarm System being in active _Alarm_ mode.  It has the value `None` or `Alarm`.

Here we check the specific transition between those two states as we want to avoid being re-notified, when the `Uninitialized` » `Alarm` state transition occurs, should openHAB restart.

Item declaration (`house.items`):
```xtend
String   AlarmArea1Alarm "Alarm Area 1 Alarm [%s]" (GAlarmArea1) {mios="unit:house,device:228/service/AlarmPartition2/Alarm"}
```

Rule declaration (`alarm.rules`):
```xtend
rule "Alarm Panel Breach"
	when
		Item AlarmArea1Alarm changed from None to Active
	then
		pushNotification("House-Alarm", "House in ALARM!! Notification")
		say("Alert: House in Alarm Notification")
end 
```

### Examples for Co-existing

### Examples for Replacing
#### Publishing data to SmartEnergyGroups.com (SEG)

I wrote [[this script|http://forum.micasaverde.com/index.php/topic,31212.0.html]] to publish data from MiOS to [[SmartEnergyGroups (SEG)|http://smartenergygroups.com]] for analysis.

Here's what you do to replace it with openHAB functionality:

Item declaration (`house.items`):
```xtend
Group GPersist (All)

Group GMonitor (All)
Group GMonitorTemperature (GMonitor)
Group GMonitorHumidity (GMonitor)
Group GMonitorEnergy (GMonitor)

Number   WeatherTemperatureCurrentTemperature "Outside [%.1f °F]" <temperature>          (GPersist,GMonitorTemperature) {mios="unit:house,device:318/service/TemperatureSensor1/CurrentTemperature"}
Number   WeatherLowTemperatureCurrentTemperature "Outside Low [%.1f °F]" <temperature>   (GPersist,GMonitorTemperature) {mios="unit:house,device:319/service/TemperatureSensor1/CurrentTemperature"}
Number   WeatherHighTemperatureCurrentTemperature "Outside High [%.1f °F]" <temperature> (GPersist,GMonitorTemperature) {mios="unit:house,device:320/service/TemperatureSensor1/CurrentTemperature"}
Number   WeatherHumidityCurrentLevel "Outside Humidity [%d %%]"                          (GPersist,GMonitorHumidity)    {mios="unit:house,device:321/service/HumiditySensor1/CurrentLevel"}
Number   NestTStatUpstairs_humidity "Humidity [%d %%]"                                   (GPersist,GMonitorHumidity)    {nest="<[thermostats(Upstairs).humidity]"}
Number   NestTStatUpstairs_ambient_temperature_f "Upstairs [%.1f °F]" <temperature>      (GPersist,GMonitorTemperature) {nest="<[thermostats(Upstairs).ambient_temperature_f]"}
Number   NestTStatDownstairs_humidity "Humidity [%d %%]"                                 (GPersist,GMonitorHumidity)    {nest="<[thermostats(Downstairs).humidity]"}
Number   NestTStatDownstairs_ambient_temperature_f "Downstairs [%.1f °F]" <temperature>  (GPersist,GMonitorTemperature) {nest="<[thermostats(Downstairs).ambient_temperature_f]"}
```

Persistence declaration (`rrd4j.persist`):
```xtend
Strategies {
	// for rrd charts, we need a cron strategy
	everyMinute : "0 * * * * ?"
	everyDay : "0 0 23 * * ?"
}

Items {
	SystemDataVersion, SystemUserDataDataVersion, SystemTimeStamp, SystemLocalTime, SystemLoadTime : strategy = everyDay
	GPersist* : strategy = everyChange, everyMinute, restoreOnStartup
	GTemperature* : strategy = everyMinute, restoreOnStartup
}
```

Rule declaration (`seg.rules`):
```xtend
import org.openhab.core.library.types.*
import java.util.Locale

rule "Log Data to SmartEnergyGroups (SEG)"
	when
		Time cron "0 0/2 * * * ?" or
		Item NestTStatUpstairs_ambient_temperature_f changed or
		Item NestTStatDownstairs_ambient_temperature_f changed or
		Item WeatherTemperatureCurrentTemperature changed or
		Item WeatherLowTemperatureCurrentTemperature changed or
		Item WeatherHighTemperatureCurrentTemperature changed or
		Item NestTStatUpstairs_humidity changed or
		Item NestTStatDownstairs_humidity changed or
		Item WeatherHumidityCurrentLevel changed
	then
		val String SEG_SITE = "<yourSiteKeyHere>"
		val String SEG_URL = "http://api.smartenergygroups.com/api_sites/stream"
		val String NODE_NAME = "openHAB"
		val Locale LOCALE = Locale::getDefault

		var String segData = ""

		GMonitorTemperature?.members.forEach(item|
			segData = segData + String::format(LOCALE, "(t_%s %s)", item.name, (item.state as Number).toString)
		)

		GMonitorHumidity?.members.forEach(item |
			segData = segData + String::format(LOCALE, "(h_%s %s)", item.name, (item.state as Number).toString)
		)

		GMonitorEnergy?.members.forEach(item |
			segData = segData + String::format(LOCALE, "(e_%s %s)", item.name, (item.state as Number).toString)
		)

		segData = String::format("(site %s (node %s ? %s))", SEG_SITE, NODE_NAME, segData)
		sendHttpPostRequest(SEG_URL, "application/x-www-form-urlencoded", segData)
end
```
