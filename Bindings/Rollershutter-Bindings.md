# Rollershutter Groups

![](https://dl.dropboxusercontent.com/u/1781347/wiki/2014-12-24%2014_16_16-Ehrendingen.png)

An example how to group rollershutters:

## Items
```
Group gRollladen "Rollladen" <rollershutter>
Group gRollladenEG "EG" <rollershutter> (gRollladen, gEG)

Group:Rollershutter:OR(UP, DOWN, STOP) gShutterEGWohnen "Rollladen Wohnraum [(%d)]" <rollershutter> (gEG)
Group:Rollershutter:OR(UP, DOWN, STOP) gShutterEGKueche "Rollladen Küche    [(%d)]" <rollershutter> (gEG)

Rollershutter	ZwaveShutterEGTV	        "Rollladen TV"	        <rollershutter>	(gRollladenEG)		{ zwave="6:invert_state=true" }
Rollershutter	ZwaveShutterEGEingang	    "Rollladen Eingang"	    <rollershutter>	(gRollladenEG)		{ zwave="7:invert_state=true" }
Rollershutter	ZwaveShutterEGKuecheLinks	"Rollladen Küche <"    <rollershutter>	(gRollladenEG, gShutterEGKueche)		{ zwave="10:invert_state=true" }
Rollershutter	ZwaveShutterEGKuecheRechts	"Rollladen Küche >"   <rollershutter>	(gRollladenEG, gShutterEGKueche)		{ zwave="8:invert_state=true" }
Rollershutter	ZwaveShutterEGWohnenLinks	"Rollladen Wohnraum >"	<rollershutter>	(gRollladenEG, gShutterEGWohnen)		{ zwave="11:invert_state=true" }
Rollershutter	ZwaveShutterEGWohnenRechts	"Rollladen Wohnraum <"	<rollershutter>	(gRollladenEG, gShutterEGWohnen)		{ zwave="9:invert_state=true" }
```

## Sitemap
```
Text item=gRollladenEG label="Rollläden EG [(%d)]" {
    Switch item=gRollladenEG label="Rollläden EG [(%d)]" mappings=[UP="Hoch", STOP="X", DOWN="Runter"]
    Frame {
        Switch item=gShutterEGKueche label="Rollläden Küche  [(%d)]" mappings=[UP="Hoch", STOP="X", DOWN="Runter"]
        Switch item=gShutterEGWohnen label="Rollläden Wohnen [(%d)]" mappings=[UP="Hoch", STOP="X", DOWN="Runter"]
    }
    Group item=gRollladenEG
}
```

#Example for binding shutter using HTTP GET commands#

If you have following scenario: 

Shutters are controllable via HTTP GET URL. `shutterUpActionUrl` completely opens shutter, `shutterDownActionUrl` closes them. Both commands can be cancelled by `shutterStopActionUrl`. Time in ms to completely move shutter up/down: `SHUTTER_FULL_UP_TIME`/`SHUTTER_FULL_DOWN_TIME`

Use following snippets:

###Items####

    Rollershutter shutter "Shutter  [%d %%]"  <rollershutter>

###Sitemap###

    Frame label="Shutter" {
	Switch item=shutter
    }

###Rules###

    import org.openhab.core.library.types.DecimalType

    //variables to store current state of shutter
    var Number shutterOldState = 50
    var Number shutterLastUp = 0
    var Number shutterLastDown = 0

    //URL to be called as HTPP GET. Up and Down start moving shutting either until completely moved or until Stop called.
    var String shutterDownActionUrl = "http://localhost:90/?shutter=down"
    var String shutterUpActionUrl = "http://localhost:90/?shutter=up"
    var String shutterStopActionUrl = "http://localhost:90/?shutter=halt"

    //time in ms needed to completely open and close shutter, respectively
    var Number SHUTTER_FULL_UP_TIME = 20000
    var Number SHUTTER_FULL_DOWN_TIME = 20000
                    
    rule "Shutter Save Old State Rule"
    when
        Item shutter changed	
    then
        shutterOldState = previousState as DecimalType
    end

    rule "Shutter Control Rule"
    when
        Item shutter received command 
    then
        if(receivedCommand != null){
            var Number upTime = now.millis - shutterLastUp
            var Number downTime = now.millis - shutterLastDown
            switch(receivedCommand.toString.upperCase) {
                case "STOP" :{ 
                    var Number newState = -1
                    if(upTime < downTime && upTime < SHUTTER_FULL_UP_TIME) {
                        //last action was up and still going UP.
                        //0% is open!				
                        var Number percentMoved =  ((upTime) * 100 / SHUTTER_FULL_UP_TIME).intValue 
                        newState = shutterOldState - percentMoved
                        println("shutterOldState: " + shutterOldState + " UP: " + percentMoved + "% in " + upTime/1000 + "sec. Now: " + newState+ "%" )
                    } else if(upTime > downTime && downTime < SHUTTER_FULL_DOWN_TIME) {
                        //last action was down and still going DOWN.
                        //100% is closed!
                        var Number percentMoved = ((downTime) * 100 / SHUTTER_FULL_DOWN_TIME).intValue
                        newState = shutterOldState + percentMoved
                        println("shutterOldState: " + shutterOldState + "% DOWN: " + percentMoved + "% in " + downTime/1000 + "sec. Now: " + newState+ "%" )
                    }
                    if(newState > 0 && newState < 100) {
                        postUpdate(shutter, newState)
                        if(shutterStopActionUrl != null){
                            sendHttpGetRequest(shutterStopActionUrl)
                        }
                    }
                }			
                case "UP" : {
                    if(upTime < SHUTTER_FULL_UP_TIME) {
                        //still going up. ignore.
                    } else {
                        shutterLastUp = now.millis
                        if(shutterUpActionUrl != null){
                            sendHttpGetRequest(shutterUpActionUrl)
                        }
                    }
                }
                case "DOWN":{
                    if(downTime < SHUTTER_FULL_DOWN_TIME) {
                        //still going up. ignore.
                    } else {
                        shutterLastDown = now.millis
                        if(shutterDownActionUrl != null){
                            sendHttpGetRequest(shutterDownActionUrl)
                        }
                    }
                }
            }
        }
    end

###Controlling###

Use a simple HTTP GET to control the shutter:

* [http://localhost:8080/CMD?shutter=UP](http://localhost:8080/CMD?shutter=UP)
* [http://localhost:8080/CMD?shutter=DOWN](http://localhost:8080/CMD?shutter=DOWN)
* [http://localhost:8080/CMD?shutter=STOP](http://localhost:8080/CMD?shutter=STOP)

