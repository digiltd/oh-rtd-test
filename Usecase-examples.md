# Usecase Examples

This is a collection of possible use cases to inspire adding intelligence to your home automation.

If possible examples are sorted by categories. Some might actually fit into more than one category. Some in none:

 location based
 environmental
 scenes
 event triggered
 other usecases
 

## location based
(via mqttitude, ibeacon, rfid, bluetooth, wlan, tasker(Android) )
* predicting when you gonna arrive from works, and preheating the home 20minutes sooner via calendar or geofence.
* cut off power (with some exceptions, like fridge, openHab server, etc), water supply, etc. when alarm is armed or via geofence
* RFID / ibeacons in shoes, and reader in door mats, so you can be tracked which room are u in (and music can follow u), or other high AI stuff based on ur profile


## environmental
* start irrigation when soil is dry and no rain is coming
* run the air exchange if CO2 is too high.
* in Summer when the outside temp is higher than the inside close the windows or rollershutters (or notify to close them)


## scenes
* Adjust lights for bedtime (most lights off; hallway on dim, front door on dim, etc. / if everything is off use red light betwenn bedroom and toilett)
* If no one is home (security system armed), turn certain lights on and off at semi-random intervals
* Tv: adjust light, rollershutter, switch on Beamer, receiver, player. Brighten the light if the phone or doorbell rings and hit pause. Same if I hit pause manually.
* dinner scene - adjust lighting and start playing music in living room

## event triggered
* starting a sunrise simulation 10 minutes before your alarm clock goes off and switch on all daylight bulps and heating or when motion detected in kitchen after 6am and house is in 'sleep' mode, switch to 'awake' mode.
Then switch on other lighting  when the sunrise simulation has finished. Start the coffee machine, play weather forecast on Squeezebox and if a work day fire up my work PC.
* send me a message if the dish washer or the washing machine has run while my status was not at home (mqttitude) on my return. 
* send me a message if the oven is still on when I am not at home or if its running for quite a long time. (Push button for standard timer reset. Might build a timer that can be set individually one time)
* send me a message if the alarm is triggered
* Turn garage flood light on if driveway gate is opened after dark
* Turn hallway lights on if garage door is opened with alarm armed after dark
* Run the air conditioner fan periodically at night if the compressor hasn't run recently and the bedroom window is closed

* cut off as much power as possible when I am in bed
*  wake up the PC / VDR: turn on all relevant sockets and send a wol package.