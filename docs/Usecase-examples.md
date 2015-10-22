# Usecase Examples

This is a collection of possible use cases to inspire adding intelligence to your home automation.

If possible examples are sorted by categories. Some might actually fit into more than one category. Some into none. 
Please link to corresponding rules in the samples section.

* location based
* environmental
* scenes
* event triggered
* other usecases
 

## location based
* Predicting when you will arrive from work, and preheating the home 20 minutes sooner via calendar or geofence.
* Cut off power (with some exceptions, like fridge, openHab server, etc), water supply, etc. when alarm is armed or via geofence
* RFID / ibeacons in shoes, and reader in door mats, so you can be tracked which room are you in (and music can follow you), or other high AI stuff based on your profile


## environmental
* Start irrigation when soil is dry and no rain is coming during morning or evening hours and the temperature is not below 0° C.
* Run the air exchange if CO2 is too high.
* Run the air exchange if humidity is too high and increase heating if temperature is low.
* In Summer when the outside temp is higher than the inside close the windows or rollershutters (or notify to close them)
* Switch off tv and pc rack if power consumption has decreased below a certain level at 00.00 / 01.00 / 02.00 assuming units have been switched of to reduce standby power consumption.


## scenes
* Adjust lights for bedtime (most lights off; hallway on dim, front door on dim, etc. / if everything is off use red light betwenn bedroom and toilett)
* If no one is home (security system armed), turn certain lights on and off at semi-random intervals
* Tv: adjust light, rollershutter, switch on Beamer, receiver, player. Brighten the light if the phone or doorbell rings and hit pause. Show the caller number / front door cam on the tv screen. Brighten lights if I hit pause manually.
* Dinner scene - adjust lighting and start playing music in living room

## event triggered
* Decrease tv / music volume if someone calls / rings the bell. Display the number / front door cam picture on the tv if its on. Otherwise switch it on until the call was picked up or the front door was opened.
* Starting a sunrise simulation 10 minutes before your alarm clock goes off. Switch on all daylight bulbs and heating or when motion detected in kitchen after 6am and house is in 'sleep' mode, switch to 'awake' mode.
Then switch on other lighting  when the sunrise simulation has finished. Start the coffee machine, play weather forecast on Squeezebox and if a work day fire up my work PC.
* Light up status LED in the house if outer gates are open
* Light up status LED in the house or send me a message if the dish washer or the washing machine has run while my status was "not at home" (mqttitude) on my return. 
* Send me a message if the oven is still on when I am not at home or if its running for quite a long time. (Push button for standard timer reset. Might build a timer that can be set individually one time)
* Send me a message if the alarm is triggered
* Turn garage flood light on if driveway gate is opened after dark
* Turn hallway lights on if garage door is opened with alarm armed after dark
* Run the air conditioner fan periodically at night if the compressor hasn't run recently and the bedroom window is closed
* When entry gate opens play 'doorbell' MP3 in kitchen and arm entry IP camera to record for 5 mins
* If internal garage door is opened between 7am-9am and wife is still home, open the garage door (i.e. she is leaving for work)
* tasker app on Android phone which puts house into 'sleep' mode when I plug in my charger (if phone is on home WIFI and after 9pm)
* tasker app with autovoice - 'heading out' command opens garage door and when my phone drops off the home wifi closes the garage door and arms the alarm
* tasker app with autovoice - 'coming home' command disarms alarm and opens garage door
* Turn off any lamp 2h-s after turning them on (arguable, but I would use it)
* Email about missed phone call (w/ called ID)on landline

* Cut off as much power as possible when I am in bed
* Wake up the PC / VDR: turn on all relevant sockets and send a wol package.
* Switch on gate lights for 5 minutes if anybody rings at the garden front gate (but only in darkness resp. after sunset, of course)
* Attic lights controlled by attic stairs
* Outside lights control: If house door opens in darkness (sunset/sunrise time +/- configurable amount on minutes) lights will switch on for a configurable amout of minutes. If doors still open after timeout or motion is detected (IP-Cam or ir sensor driven), timer will extend by one minute until doors closed.
* Master / slave power socket: e.g. switch all pc stuff like pc, printer, sound, etc. via a low standby power consuming device like a monitor etc. If the monitor is being switched on, switch on the other power socket. If neccessary send a wol package to the pc.