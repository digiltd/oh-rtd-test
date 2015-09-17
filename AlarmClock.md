Below you'll find two examples on how to realize an alarm clock with openHAB. Example 1 does only use one item to control the alarm time. Example II will control the hours and minutes seperately.

* [Example I] (AlarmClock#alarm-clock---example-i)
 * [Items] (AlarmClock#items)
 * [Rules] (AlarmClock#rules)
 * [Sitemap] (AlarmClock#sitemap)

* [Example II] (AlarmClock#alarm-clock---example-ii)
 * [Items] (AlarmClock#items-1)
 * [Rules] (AlarmClock#rules-1)
 * [Sitemap] (AlarmClock#sitemap-1)

* [References] (AlarmClock#references)

# Alarm Clock - Example I
There is no 'time' widget and using numbers/dimmers/setpoints; if you do not want to have two items, one for hours and one for minutes this example is for you ...

Basically you are specifying the alarm time as a number from 0-600 mins (i.e. 0-10 hours). The base time is midnight, so this corresponds to a time between midnight and 10am. Obviously very easy to change the Setpoint config in your sitemap to extend or restrict this. I have it set to 'step' in 5 min increments, but you could make this 15 mins to make it easier to quickly set coarse alarm times if you wanted.

Whenever you change the alarm time mins item using the Setpoint widget, the alarm time is calculated and a display item is updated, so you can show the nicely formatted alarm time in the sitemap. This item is not used for anything other than display. 

The reason I have two frames for displaying the alarm details is so I can merge both the alarm switch and time items into one sitemap widget. So if the alarm is enabled I hardcode the presence-on icon and display the alarm time, if it is disabled I hard-code the presence-off icon. By doing this I can display the alarm time and have an icon showing the alarm state. Drilling down into that frame gives you the option to disable the alarm and change the time. [[1](https://groups.google.com/d/msg/openhab/F2hqVwjbRC0/b1s44_MWGygJ)]

## Items
    Switch     Alarm_Master          "Master Alarm"       <presence>       (Alarms)
    Number     Alarm_MasterTimeMins  "Master Alarm"       <clock>          (Alarms)
    String     Alarm_MasterTime      "Master Alarm [%s]"  <clock>
    Switch     Alarm_MasterEvent     "Master Alarm Event" <alarm>          (AlarmEvents)      { autoupdate="false" }

## Rules
```Xtend

	import org.joda.time.*
	var Timer masterAlarmTime = null

	rule "Master bedroom alarm time"
	when
		Time cron "0 5 0 * * ?" or
		Item Alarm_MasterTimeMins received update
	then
		var int minutes = (Alarm_MasterTimeMins.state as DecimalType).intValue()

		if (masterAlarmTime != null)
			masterAlarmTime.cancel()

		// work out when the alarm is to fire - start from midnight
		var DateTime alarmTime = parse(now.getYear() + "-" + now.getMonthOfYear() + "-" + now.getDayOfMonth() + "T00:00")

		// add the number of minutes selected
		alarmTime = alarmTime.plusMinutes(minutes)

		// if we have already past the alarm time then set it for the following day
		if (alarmTime.beforeNow)
			alarmTime = alarmTime.plusDays(1)

		// create a timer to execute the alarm at the specified time
		masterAlarmTime = createTimer(alarmTime) [| 
			if (Alarm_Master.state == ON && Holiday.state == OFF && now.getDayOfWeek() < 6) 
				Alarm_MasterEvent.sendCommand(ON)
		]

		// update the alarm display time    
		Alarm_MasterTime.sendCommand(String::format("%02d:%02d", alarmTime.getHourOfDay(), alarmTime.getMinuteOfHour()))
	end

	rule "Master bedroom alarm"
	when
		Item Alarm_MasterEvent received command ON
	then
		// do your alarm stuff - turn on radio, dim up lights, start the coffee machine...
	end
```
# Sitemap
	Frame label="Alarm" {
		Text item=Alarm_MasterTime icon="presence-on" visibility=[Alarm_Master==ON] {
			Frame label="Master Alarm" {
				Switch item=Alarm_Master
				Text item=Alarm_MasterTime
				Setpoint item=Alarm_MasterTimeMins minValue=0 maxValue=600 step=5
			}
		}
		Text item=Alarm_MasterTime icon="presence-off" visibility=[Alarm_Master==OFF] {
			Frame label="Master Alarm" {
				Switch item=Alarm_Master
				Text item=Alarm_MasterTime
				Setpoint item=Alarm_MasterTimeMins minValue=0 maxValue=600 step=5
			}
		}
	}

# Alarm Clock - Example II

![UI (greenT)](https://dl.dropboxusercontent.com/u/1781347/wiki/2014-12-07%2018_30_22-openHAB.png)

## Items
```
Switch	weckerMontag     "Montag"     <switch>	(gWeckerWochentage)	
Switch	weckerDienstag   "Dienstag"   <switch>	(gWeckerWochentage)	
Switch	weckerMittwoch   "Mittwoch"	  <switch>	(gWeckerWochentage)	
Switch	weckerDonnerstag "Donnerstag" <switch>	(gWeckerWochentage)	
Switch	weckerFreitag    "Freitag"    <switch>	(gWeckerWochentage)	
Switch	weckerSamstag    "Samstag"    <switch>	(gWeckerWochentage)	
Switch	weckerSonntag    "Sonntag"    <switch>	(gWeckerWochentage)	

String weckerZeitMessage "%s"

Number weckerZeitStunde "Stunde [%d]" <clock> (gWeckerZeit)
Number weckerZeitMinute "Minute [%d]" <clock> (gWeckerZeit)
```
## Rules
```Xtend
import org.openhab.core.library.types.*
import org.openhab.core.persistence.*
import org.openhab.model.script.actions.*
import org.openhab.action.squeezebox.*

import java.util.concurrent.locks.ReentrantLock

var Timer timer1 = null
var java.util.concurrent.locks.ReentrantLock lock1 = new java.util.concurrent.locks.ReentrantLock()

rule "Initialization"
 when 
   System started
 then
     postUpdate(weckerZeitStunde,  8)
     postUpdate(weckerZeitMinute, 15)
     postUpdate(weckerMontag,     ON)
     postUpdate(weckerDienstag,   ON)
     postUpdate(weckerMittwoch,   ON)
     postUpdate(weckerDonnerstag, ON)
     postUpdate(weckerFreitag,    ON)
     postUpdate(weckerSamstag,    OFF)
     postUpdate(weckerSonntag,    OFF)
 end

rule "Weckzeit"
when
	Item weckerZeitStunde changed or 
	Item weckerZeitMinute changed
then
  lock1.lock()
  try {
    
  var String msg = ""
  var stunde = weckerZeitStunde.state as DecimalType
  var minute = weckerZeitMinute.state as DecimalType
  
  if (stunde < 10) { msg = "0" } 
  msg = msg + weckerZeitStunde.state.format("%d") + ":"
    
  if (minute < 10) { msg = msg + "0" }
  msg = msg + weckerZeitMinute.state.format("%d")
  postUpdate(weckerZeitMessage,msg)
  
  var int weckzeit1
  weckzeit1 = (weckerZeitStunde.state as DecimalType).intValue * 60 + 
              (weckerZeitMinute.state as DecimalType).intValue
  weckzeit1 = weckzeit1.intValue
  
  var int jetzt1
  jetzt1 = now.getMinuteOfDay
  jetzt1 = jetzt1.intValue
  
  var int delta1
  if (timer1 != null) {
    timer1.cancel
    timer1 = null
  }
  
  delta1 = (weckzeit1 - jetzt1)
  delta1 = delta1.intValue
  
  if (jetzt1 > weckzeit1) { delta1 = delta1 + 1440 }
    
  timer1 = createTimer(now.plusMinutes(delta1)) [|
  	var Number day = now.getDayOfWeek
  	if (((day == 1) && (weckerMontag.state == ON))     ||
   		((day == 2) && (weckerDienstag.state == ON))   ||
   		((day == 3) && (weckerMittwoch.state == ON))   ||
   		((day == 4) && (weckerDonnerstag.state == ON)) ||
   		((day == 5) && (weckerFreitag.state == ON))    ||
   		((day == 6) && (weckerSamstag.state == ON))    ||
   		((day == 7) && (weckerSonntag.state == ON))
   		) {
   		sendHttpGetRequest("http://192.168.10.100/ExecuteEvent.asp?Event=Wecker")
    		
   		sendCommand(ZwaveShutterEGEingang, UP)
   		sendCommand(ZwaveShutterEGKuecheLinks, UP)
   		sendCommand(ZwaveShutterEGKuecheRechts, UP)
   		sendCommand(ZwaveShutterEGWohnenRechts, UP)
   		sendCommand(ZwaveShutterEGWohnenLinks, UP)
   		sendCommand(ZwaveShutterOGGang, UP)
   		sendCommand(ZwaveShutterOGBuero, UP)
   		sendCommand(ZwaveShutterEGTV, UP)
   		
   		createTimer(now.plusSeconds(7)) [|
   		  sendCommand(ZwaveShutterEGTV, STOP)
   		  ]
   	    }
   	   timer1.reschedule(now.plusHours(24))
     ]
    }
  } finally  {
     lock1.unlock()
  }
end
```
## Sitemap

    sitemap alarmclock
    {
        Frame label="System" {
                
            Text label="Wecker [%s]" item=weckerZeitMessage icon="clock" {
                Frame label="Zeit" {
                    Setpoint item=weckerZeitStunde minValue=0 maxValue=23 step=1
                    Setpoint item=weckerZeitMinute minValue=0 maxValue=55 step=5
                }
                Frame label="Wochentage" {
                    Switch item=weckerMontag
                    Switch item=weckerDienstag
                    Switch item=weckerMittwoch
                    Switch item=weckerDonnerstag
                    Switch item=weckerFreitag
                    Switch item=weckerSamstag
                    Switch item=weckerSonntag
                }
            }
        }	
    }

# References
 - [1]: [How to configure openHAB for setting alarm/schedule times thru the UI](https://groups.google.com/d/msg/openhab/F2hqVwjbRC0/b1s44_MWGygJ)