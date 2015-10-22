## [[MiOS Binding|MiOS-Binding]] and [[MiOS Action|MiOS-Action]] Examples

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
String   AlarmArea1ArmMode "Alarm Area 1 Arm Mode [%s]" (GAlarmArea1) {mios="unit:house,device:228/service/AlarmPartition2/ArmMode"}
String   AlarmArea1LastUser "Alarm Area 1 Last User [%s]" (GAlarmArea1) {mios="unit:house,device:228/service/AlarmPartition2/LastUser"}
```

Rule declaration (`house-alarm.rules`):
```xtend
rule "Alarm Panel Breach"
when
	Item AlarmArea1Alarm changed to Active
then
	pushNotification("House-Alarm", "House in ALARM!! Notification")
	say("Alert: House in Alarm Notification")
end

rule "Alarm Panel Armed (Any)"
when
	Item AlarmArea1ArmMode changed from Disarmed to Armed
then
	say("Warning! House Armed Notification")

	// Perform deferred notifications, as the User.state may not have been processed yet.
	createTimer(now.plusSeconds(1)) [
		logDebug("house-alarm", "Alarm-Panel-Armed-Any Deferred notification")
		var user = AlarmArea1LastUser.state as StringType

		if (user == null) user = "user unknown"
		pushNotification("House-Armed", "House Armed Notification (" + user + ")")
	]
end

rule "Alarm Panel Disarmed (Fully)"
when
	Item AlarmArea1ArmMode changed from Armed to Disarmed
then
	say("Warning! House Disarmed Notification")

	// Perform deferred notifications, as the User.state may not have been processed yet. 
	createTimer(now.plusSeconds(1)) [
		logDebug("house-alarm", "Alarm-Panel-Disarmed-Fully Deferred notification")
		var user = AlarmArea1LastUser.state as StringType

		if (user == null) user = "user unknown"
		pushNotification("House-Disarmed", "House Disarmed Notification (" + user + ")")
	]
end
```

#### Adding Notifications when Battery Powered devices are running low.
MiOS Systems standardize Battery Level indications (0-100%) for all battery-power devices (Alarm sensors, Z-Wave Door Locks, etc) and Nest uses a simple "ok" String to represent the Battery Status.

Item declaration (`house.items`):
```xtend
Number   GarageDeadboltBatteryLevel "Garage Deadbolt Battery Level [%d %%]" <energy> (GBattery,GPersist) {mios="unit:house,device:189/service/HaDevice1/BatteryLevel"}
Number   HallCupboardZoneBatteryLevel "Hall Cupboard Battery Level [%d %%]" <energy> (GBattery,GPersist) {mios="unit:house,device:301/service/HaDevice1/BatteryLevel"}
Number   EXTFrontMotionZoneBatteryLevel "EXT Front Motion Zone Battery Level [%d %%]" <energy> (GBattery,GPersist) {mios="unit:house,device:302/service/HaDevice1/BatteryLevel"}
Number   EXTRearMotionZoneBatteryLevel "EXT Rear Motion Battery Level [%d %%]" <energy> (GBattery,GPersist) {mios="unit:house,device:396/service/HaDevice1/BatteryLevel"}
String   NestSmokeGuestBedroom_battery_health "Guest Bedroom Smoke Battery Health [%s]" <energy>       (GSmoke,GBattery,GPersist) {nest="<[smoke_co_alarms(Guest Bedroom).battery_health]"}
```

Rule declaration (`house-battery.rules`):
```xtend
import org.openhab.core.library.types.*

val Number LOW_BATTERY_THRESHOLD = 60 // for Z-Wave Battery devices
val String OK_BATTERY_STATE = 'ok'    // for Nest Thermostat and Protect devices

rule "Low Battery Alert"
when
        Time cron "0 0 8,12,20 * * ?"
then
        GBattery?.members.filter(s|s.state instanceof DecimalType).forEach[item |
                var Number level = item.state as Number
                var String name = item.name

                if (level < LOW_BATTERY_THRESHOLD) {
                        logInfo('Low-Battery-Alert', 'Bad: ' + name)
                        pushNotification("Low-Battery-Alert", "House Low Battery Notification (" + name + ")")
                } else {
                        logDebug('Low-Battery-Alert', 'Good: ' + name)
                }
        ]

        GBattery?.members.filter(s|s.state instanceof StringType).forEach[item |
                var String level = (item.state as StringType).toString
                var String name = item.name

                if (level != OK_BATTERY_STATE) {
                        logInfo('Low-Battery-Alert', 'Bad: ' + name)
                        pushNotification("Low-Battery-Alert", "House Low Battery Notification (" + name + ")")
                } else {
                        logDebug('Low-Battery-Alert', 'Good: ' + name)
                }
        ] 
end
```

### Examples for Co-existing
#### When Motion detected turn Lights ON (OFF after 5 minutes)
This is typical of a declarative Scene in MiOS.  In this case, the lights are left on for 5 minutes, and if new motion is detected in that time, another 5 minute clock is started.

The logging can be removed as needed.

Item declaration (`house.items`):
```xtend
Group GSwitch All

Switch   MasterClosetLightsStatus "Master Closet Lights" (GSwitch) {mios="unit:house,device:391/service/SwitchPower1/Status"}
Switch   MasterClosetFibaroLightStatus "Master Closet Fibaro Light" (GSwitch) {mios="unit:house,device:431/service/SwitchPower1/Status"}
```

Rule declaration (`house-master.rules`):
```xtend
import org.openhab.model.script.actions.Timer

import org.joda.time.*

import java.util.concurrent.locks.ReentrantLock

val int MCL_DELAY_SECONDS = 300
var Timer mclTimer = null
var ReentrantLock mclLock = new ReentrantLock(false)

rule "Master Closet Motion"
when
	Item MasterClosetZoneTripped changed from CLOSED to OPEN
then
	logInfo("house-master", "Master-Closet-Motion Timer lights ON")
	sendCommand(MasterClosetLightsStatus, ON)
	sendCommand(MasterClosetFibaroLightStatus, ON)

	mclLock.lock
	if (mclTimer != null) {
		mclTimer.cancel
		logInfo("house-master", "Master-Closet-Motion Timer Cancel")
	}

	mclTimer = createTimer(now.plusSeconds(MCL_DELAY_SECONDS)) [
		logInfo("house-master", "Master-Closet-Motion Timer lights OFF")
		sendCommand(MasterClosetLightsStatus, OFF)
		sendCommand(MasterClosetFibaroLightStatus, OFF)
	]
	mclLock.unlock
end
```

#### When Motion detected turn Lights ON (if nighttime) and OFF after 5 minutes.

A variant of the above, this Rule has parts that only run at Nighttime.  Here we use the [[Astro Binding|Astro-Binding]] to compute daylight hours.  See the Astro Binding configuration for details on how to setup that Binding's `configuration/openhab.cfg` entry.

Item declaration (`sunrise.items`):
```xtend
DateTime ClockDaylightStart "Daylight Start [%1$tH:%1$tM]" <calendar> {astro="planet=sun, type=daylight, property=start, offset=-30"}
DateTime ClockDaylightEnd   "Daylight End [%1$tH:%1$tM]" <calendar>   {astro="planet=sun, type=daylight, property=end, offset=+30"}
```

Item declaration (`house.items`):
```xtend
Switch   KitchenSinkLightStatus "Kitchen Sink Light" (GSwitch) {mios="unit:house,device:99/service/SwitchPower1/Status"}
Switch   KitchenPantryLightStatus "Kitchen Pantry Light" (GSwitch) {mios="unit:house,device:425/service/SwitchPower1/Status"}
Switch   PowerHotWaterPumpStatus "Power Hot Water Pump" (GSwitch) {mios="unit:house,device:303/service/SwitchPower1/Status"}
Switch   KitchenPantryZoneArmed "Zone Armed [%s]" {mios="unit:house,device:426/service/SecuritySensor1/Armed"}
```

Rule declaration (`house-kitchen.rules`):
```xtend
import org.openhab.core.library.types.*
import org.openhab.model.script.actions.Timer

import org.joda.time.*

import java.util.concurrent.locks.ReentrantLock

val int K_DELAY_SECONDS = 240
var Timer kTimer = null
var ReentrantLock kLock = new ReentrantLock(false)

rule "Kitchen Motion"
when
	Item KitchenMotionZoneTripped changed from CLOSED to OPEN
then
	logInfo("house-kitchen", "Kitchen-Motion Timer ON")

	// Ignore this Rule if the Motion sensor is bypassed.
	if (KitchenMotionZoneArmed.state != ON) {
		logInfo("house-kitchen", "Kitchen-Motion Not Armed, skipping")
		return void
	}

	val DateTime daylightStart = new DateTime((ClockDaylightStart.state as DateTimeType).getCalendar)
	val DateTime daylightEnd = new DateTime((ClockDaylightEnd.state as DateTimeType).getCalendar)

	var boolean night = daylightStart.isAfterNow || daylightEnd.isBeforeNow

	if (night) {
		logInfo("house-kitchen", "Kitchen-Motion Night Time")
		sendCommand(KitchenSinkLightStatus, ON)
		sendCommand(KitchenPantryLightStatus, ON)
	}

	logInfo("house-kitchen", "Kitchen-Motion Any Time")
	sendCommand(PowerHotWaterPumpStatus, ON)

	kLock.lock
	if (kTimer != null) {
		kTimer.cancel
		logInfo("house-kitchen", "Kitchen-Motion Timer Cancel")
	}

	kTimer = createTimer(now.plusSeconds(K_DELAY_SECONDS)) [
		logInfo("house-kitchen", "Kitchen-Motion Timer OFF")
		sendCommand(KitchenSinkLightStatus, OFF)
		sendCommand(KitchenPantryLightStatus, OFF)
		sendCommand(PowerHotWaterPumpStatus, OFF)
	]
	kLock.unlock
end
```

#### When opening/closing Windows keep Nest _Away_ state in sync to save energy.

This originally ran as a Scene on the MiOS Unit, but was replaced with an openHAB Rule.  The Items are a mix of Items, from an Alarm system running on MiOS, and the [[Nest Binding|Nest-Binding]], running locally.

Explicitly check for the `OPEN` » `CLOSED` state transition, to avoid issues when openHAB restarts (`Uninitialized` » `OPEN`) or when _duplicate_ values come in from the MiOS System (`OPEN` » `OPEN`).

Item declaration (`house.items`):
```xtend
Group GPersist (All)
Group GWindow "All Windows [%d]" <contact> (GContact)

Contact  LivingRoomZoneTripped "Living Room (Zone 2) [MAP(en.map):%s]" <contact>        (GWindow,GPersist) {mios="unit:house,device:117/service/SecuritySensor1/Tripped"}
Contact  KitchenZoneTripped "Kitchen (Zone 3) [MAP(en.map):%s]" <contact>               (GWindow,GPersist) {mios="unit:house,device:118/service/SecuritySensor1/Tripped"}
Contact  FamilyRoomZoneTripped "Family Room (Zone 5) [MAP(en.map):%s]" <contact>        (GWindow,GPersist) {mios="unit:house,device:120/service/SecuritySensor1/Tripped"}
Contact  MasterBedroomZoneTripped "Master Bedroom (Zone 8) [MAP(en.map):%s]" <contact>  (GWindow,GPersist) {mios="unit:house,device:122/service/SecuritySensor1/Tripped"}
Contact  Bedroom3ZoneTripped "Bedroom #3 (Zone 9) [MAP(en.map):%s]" <contact>           (GWindow,GPersist) {mios="unit:house,device:123/service/SecuritySensor1/Tripped"}
Contact  Bedroom2ZoneTripped "Bedroom #2 (Zone 10) [MAP(en.map):%s]" <contact>          (GWindow,GPersist) {mios="unit:house,device:124/service/SecuritySensor1/Tripped"}
Contact  GuestBathZoneTripped "Guest Bathroom (Zone 11) [MAP(en.map):%s]" <contact>     (GWindow,GPersist) {mios="unit:house,device:125/service/SecuritySensor1/Tripped"}
Contact  StairsWindowsZoneTripped "Stairs Windows (Zone 12) [MAP(en.map):%s]" <contact> (GWindow,GPersist) {mios="unit:house,device:126/service/SecuritySensor1/Tripped"}
Contact  MasterBath1ZoneTripped "Master Bath (Zone 19) [MAP(en.map):%s]" <contact>      (GWindow,GPersist) {mios="unit:house,device:133/service/SecuritySensor1/Tripped"}
Contact  MasterBath2ZoneTripped "Master Bath (Zone 20) [MAP(en.map):%s]" <contact>      (GWindow,GPersist) {mios="unit:house,device:134/service/SecuritySensor1/Tripped"}
Contact  MasterBath3ZoneTripped "Master Bath (Zone 21) [MAP(en.map):%s]" <contact>      (GWindow,GPersist) {mios="unit:house,device:135/service/SecuritySensor1/Tripped"}
```

Rule declaration (house.rules): 
```xtend
rule "Windows Closed (all)
when
	Item Bedroom2ZoneTripped changed from OPEN to CLOSED or
	Item Bedroom3ZoneTripped changed from OPEN to CLOSED or
	Item FamilyRoomZoneTripped changed from OPEN to CLOSED or
	Item GuestBathZoneTripped changed from OPEN to CLOSED or
	Item KitchenZoneTripped changed from OPEN to CLOSED or
	Item LivingRoomZoneTripped changed from OPEN to CLOSED or
	Item MasterBath1ZoneTripped changed from OPEN to CLOSED or
	Item MasterBath2ZoneTripped changed from OPEN to CLOSED or
	Item MasterBath3ZoneTripped changed from OPEN to CLOSED or
	Item MasterBedroomZoneTripped changed from OPEN to CLOSED or
	Item StairsWindowsZoneTripped changed from OPEN to CLOSED
then
	if (GWindow.members.filter(s|s.state==OPEN).size == 0) {
		say("Attention: All Windows closed.")
		sendCommand(Nest_away, "home")
	}
end

rule "Windows Opened (any)"
when
	Item Bedroom2ZoneTripped changed from CLOSED to OPEN or
	Item Bedroom3ZoneTripped changed from CLOSED to OPEN or
	Item FamilyRoomZoneTripped changed from CLOSED to OPEN or
	Item GuestBathZoneTripped changed from CLOSED to OPEN or
	Item KitchenZoneTripped changed from CLOSED to OPEN or
	Item LivingRoomZoneTripped changed from CLOSED to OPEN or
	Item MasterBath1ZoneTripped changed from CLOSED to OPEN or
	Item MasterBath2ZoneTripped changed from CLOSED to OPEN or
	Item MasterBath3ZoneTripped changed from CLOSED to OPEN or
	Item MasterBedroomZoneTripped changed from CLOSED to OPEN or
	Item StairsWindowsZoneTripped changed from CLOSED to OPEN
then
	if (GWindow.members.filter(s|s.state==OPEN).size == 1) {
		say("Attention: First Window opened.")
		sendCommand(Nest_away, "away")
	}
end
```

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
Group GMonitorPower (GMonitor)
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

	GMonitorPower?.members.forEach(item |
		segData = segData + String::format(LOCALE, "(p_%s %s)", item.name, (item.state as Number).toString)
	)

	GMonitorEnergy?.members.forEach(item |
		segData = segData + String::format(LOCALE, "(e_%s %s)", item.name, (item.state as Number).toString)
	)

	segData = String::format("(site %s (node %s ? %s))", SEG_SITE, NODE_NAME, segData)
	sendHttpPostRequest(SEG_URL, "application/x-www-form-urlencoded", segData)
end
```