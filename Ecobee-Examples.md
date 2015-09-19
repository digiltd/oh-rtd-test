The page contains a number of examples for use with the [[Ecobee binding|Ecobee-Binding]] and [[action|Ecobee-Action]] bundles.

## Table of Contents

* [Basic configuration](#basic-configuration)
* [Setting hold to defined comfort setting](#setting-hold-to-defined-comfort-setting)
* [Tracking last occupancy](#tracking-last-occupancy)

## Basic configuration

### ecobee.items
```
String hvacMode "hvacMode [%s]" { ecobee="=[123456789012#settings.hvacMode]" }
String currentClimateRef "comf setting [%s]" { ecobee="<[123456789012#program.currentClimateRef]" }
Number desired "desired [%.1f °F]"
Number desiredHeat "desiredHeat [%.1f °F]" { ecobee="<[123456789012#runtime.desiredHeat]" }
Number desiredCool "desiredCool [%.1f °F]" { ecobee="<[123456789012#runtime.desiredCool]" }
DateTime lastModified "last conn [%1$tH:%1$tM:%1$tS]" { ecobee="<[123456789012#lastModified]" }

Number diningRoomTemperature "actualTemperature [%.1f °F]" { ecobee="<[123456789012#runtime.actualTemperature]" }
Number diningRoomHumidity "actualHumidity [%d %%]" { ecobee="<[123456789012#runtime.actualHumidity]" }
Switch diningRoomOccupancy "diningRoomOccupancy [%s]" { ecobee="<[123456789012#remoteSensors(Dining Room).capability(occupancy).value]" }

Number bedroomTemperature "bedroomTemperature [%.1f °F]" { ecobee="<[123456789012#remoteSensors(Bedroom).capability(temperature).value]" }
Switch bedroomOccupancy "bedroomOccupancy [%s]" { ecobee="<[123456789012#remoteSensors(Bedroom).capability(occupancy).value]" }

Number livingRoomTemperature "livingRoomTemperature [%.1f °F]" { ecobee="<[123456789012#remoteSensors(Living Room).capability(temperature).value]" }
Switch livingRoomOccupancy "livingRoomOccupancy [%s]" { ecobee="<[123456789012#remoteSensors(Living Room).capability(occupancy).value]" }
```

### ecobee.sitemap
```
sitemap nest label="Ecobee"
{
  Frame label="Thermostat" {
    Switch item=currentClimateRef label="Comfort Setting" mappings=[sleep=Sleep,wakeup=Wake,home=Home,away=Away,smart6=Gym,resume=Resume]
    Switch item=hvacMode label="HVAC Mode" mappings=[heat=Heat,cool=Cool,auto=Auto,off=Off]
    Setpoint item=desired label="Target [%.1f °F]" minValue="45" maxValue="70" step="1" visibility=[hvacMode==heat,hvacMode==cool]
    Setpoint item=desiredHeat label="Heat [%.1f °F]" minValue="50" maxValue="80" step="1" visibility=[hvac_mode==auto]
    Setpoint item=desiredCool label="Cool [%.1f °F]" minValue="50" maxValue="80" step="1" visibility=[hvacMode==auto]
    Text item=lastModified
  }

  Frame label="Dining Room Sensors" {
    Text item=diningRoomTemperature
    Text item=diningRoomHumidity
    Text item=diningRoomOccupancy
  }

  Frame label="Bedroom Sensors" {
   Text item=bedroomTemperature
   Text item=bedroomOccupancy
  }

  Frame label="Living Room Sensors" {
   Text item=livingRoomTemperature
   Text item=livingRoomOccupancy
  }
}
```

[Table of Contents](#table-of-contents)
## Setting hold to defined comfort setting
Ecobee thermostats normally run based on a weekly schedule, but you can override the current program by setting a hold that controls the cool setpoint, the heat setpoint, and other options.  You can set a hold from a rule by calling the action `ecobeeSetHold`.  One of the parameters is a reference to a "climate" (also known as a comfort setting).  The default references for climates are `sleep`, `home`, and `away` (some models also have `wakeup`).  Below are the minimum elements for presenting a set of buttons that let you set a hold to one of these comfort settings, or resume the normal program.  The item `CurrentClimate` is only used for its reference to the specific thermostat(s) to target the action calls.

Items:
```
String CurrentClimate "Current Climate [%s]" { ecobee="<[1234567890#program.currentClimateRef]" }
String Comfort "Comfort [%s]" <temperature>
```

Sitemap:
```
...
Switch item=Comfort label="Comfort Setting" mappings=[resume="Resume",home="Home",away="Away",sleep="Sleep",wakeup="Wake"]
...
```

Rule:
```
rule EcobeeComfort
when
  Item Comfort received command
then
  logInfo("EcobeeComfort", "received command " + receivedCommand.toString)
  if (receivedCommand.toString.equals("resume")) {
    ecobeeResumeProgram(CurrentClimate, true)
  } else {
    ecobeeSetHold(CurrentClimate, null, null, receivedCommand.toString, null, null, null, null)
  }
end
```
[Table of Contents](#table-of-contents)

## Tracking last occupancy
The ecobee3 thermostat can connect to a number of wireless remote sensors that measure occupancy and temperature.  The thermostat normally uses these to implement its "follow-me comfort" feature, where the thermostat is constantly adjusting its idea of the current ambient temperature based on an average of the temperatures of rooms that are currently occupied.

The binding can individually address each remote sensor's temperature and occupancy state.  The occupancy state is ON when there has been motion within its range in the last 30 minutes.  The rules below could be used to update a `DateTime` item to show the last time movement was sensed around any of the sensors in your home.

Items:
```
Switch EcobeeMBROccu "Ecobee MBR Occu [%s]" { ecobee="<[12345678901#remoteSensors(Bedroom).capability(occupancy).value]" }
Switch EcobeeKitchenOccu "Ecobee Kitchen Occu [%s]" { ecobee="<[12345678901#remoteSensors(Kitchen).capability(occupancy).value]" }
Switch EcobeeDROccu "Ecobee DR Occu [%s]" { ecobee="<[12345678901#remoteSensors(Dining Room).capability(occupancy).value]" }
DateTime LastOccuTime "Last Occu [%1$tm/%1$td %1$tH:%1$tM]"
```
Rules:
```
import org.openhab.core.library.types.*
import org.joda.time.*

rule LastMotionON
when
    Item EcobeeMBROccu changed to ON or
    Item EcobeeKitchenOccu changed to ON or
    Item EcobeeDROccu changed to ON
then
    postUpdate(LastOccuTime, new DateTimeType())
end

rule LastMotionOFF
when
    Item EcobeeMBROccu changed to OFF or
    Item EcobeeKitchenOccu changed to OFF or
    Item EcobeeDROccu changed to OFF
then
    switch LastOccuTime.state {
      DateTimeType: {
        var DateTime halfHourAgo = now.minusMinutes(30)
        var DateTime lastKnownMotion = new DateTime((LastOccuTime.state as DateTimeType).calendar.timeInMillis)
        if (halfHourAgo.isAfter(lastKnownMotion)) {
          LastOccuTime.postUpdate(new DateTimeType(halfHourAgo.toString))
        }
      }
    }
end
```
[Table of Contents](#table-of-contents)
