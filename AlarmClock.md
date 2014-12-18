# Alarm Clock - Example
 - [Items](AlarmClock#alarmitems)
 - [Rules](AlarmClock#alarmrules)
 - [Sitemap](AlarmClock#alarmsitemap)

![UI (greenT)](https://dl.dropboxusercontent.com/u/1781347/wiki/2014-12-07%2018_30_22-openHAB.png)

Below an example on how to create an alarm clock with openHAB.

## alarm.items

    Group   gWeckerWochentage "Wochentage"
    Group   gWeckerZeit "Zeit"
    Switch	weckerMontag	"Montag"	<switch>	(gWeckerWochentage)	
    Switch	weckerDienstag	"Dienstag"	<switch>	(gWeckerWochentage)	
    Switch	weckerMittwoch	"Mittwoch"	<switch>	(gWeckerWochentage)	
    Switch	weckerDonnerstag	"Donnerstag"	<switch>	(gWeckerWochentage)	
    Switch	weckerFreitag	"Freitag"	<switch>	(gWeckerWochentage)	
    Switch	weckerSamstag	"Samstag"	<switch>	(gWeckerWochentage)	
    Switch	weckerSonntag	"Sonntag"	<switch>	(gWeckerWochentage)	

    String weckerZeitMessage "%s"

    Number weckerZeitStunde "Stunde [%d]" <clock> (gWeckerZeit)
    Number weckerZeitMinute "Minute [%d]" <clock> (gWeckerZeit)

## alarm.rules

    import org.openhab.core.library.types.*
    import org.openhab.core.persistence.*
    import org.openhab.model.script.actions.*
    import org.openhab.action.squeezebox.*

    var Timer Wecker

    rule "WeckzeitUpdate"
    when
        System started
        or Item weckerZeitStunde changed
        or Item weckerZeitMinute changed
    then
      if ((weckerZeitStunde.state instanceof DecimalType) && (weckerZeitMinute.state instanceof DecimalType)) {

        var String msg = ""
        var stunde = weckerZeitStunde.state as DecimalType
        var minute = weckerZeitMinute.state as DecimalType
      
        if (stunde < 10) { msg = "0" } 
        msg = msg + weckerZeitStunde.state.format("%d") + ":"
        if (minute < 10) { msg = msg + "0" }
        msg = msg + weckerZeitMinute.state.format("%d")
        postUpdate(weckerZeitMessage,msg)
      
        var int weckzeit
        weckzeit = (weckerZeitStunde.state as DecimalType).intValue * 60 + (weckerZeitMinute.state as DecimalType).intValue
        weckzeit = weckzeit.intValue
      
        var int jetzt
        jetzt = now.getMinuteOfDay
        jetzt = jetzt.intValue
      
        var int delta
        if (Wecker != null) {
          Wecker.cancel
          Wecker = null
        }
      
        delta = (weckzeit - jetzt)
        delta = delta.intValue
      
        if (jetzt > weckzeit) { delta = delta + 1440 }
        
        Wecker = createTimer(now.plusMinutes(delta)) [|
            logInfo("wecker.rules", "Timer Event")
            var Number day = now.getDayOfWeek
            if (((day == 1) && (weckerMontag.state == ON))     ||
                ((day == 2) && (weckerDienstag.state == ON))   ||
                ((day == 3) && (weckerMittwoch.state == ON))   ||
                ((day == 4) && (weckerDonnerstag.state == ON)) ||
                ((day == 5) && (weckerFreitag.state == ON))    ||
                ((day == 6) && (weckerSamstag.state == ON))    ||
                ((day == 7) && (weckerSonntag.state == ON))
                ) {
                logInfo("wecker.rules", "Alarm")
                sendHttpGetRequest("http://192.168.10.100/ExecuteEvent.asp?Event=Wecker")
                sendCommand("gRollladen", "UP")
                createTimer(now.plusSeconds(5)) [|
                  sendCommand("ZwaveShutterEGTV", "STOP")
                ]
            }
            Wecker.reschedule(now.plusHours(24))
        ]
        
      } else {
        // alarm clock not initialized ...
        postUpdate(weckerZeitStunde, 8)
        postUpdate(weckerZeitMinute, 15)
        postUpdate(weckerMontag, ON)
        postUpdate(weckerDienstag, ON)
        postUpdate(weckerMittwoch, ON)
        postUpdate(weckerDonnerstag, ON)
        postUpdate(weckerFreitag, ON)
        postUpdate(weckerSamstag, OFF)
        postUpdate(weckerSonntag, OFF)
        Wecker = null
      }
      
    end

## alarm.sitemap

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
