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