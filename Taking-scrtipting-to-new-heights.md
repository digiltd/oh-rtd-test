# Taking OpenHAB Scripting to New Heights
Here are some examples of how complex automation rules can be developed in OpenHAB in order to achieve whatever smart building automation that one can imagine.  The focus here being on pushing the limits, and not code simplicity or simple comprehension.

## The Mother-of-All Light-Off Rules
This example created by Bernd Pfrommer provides a scripted mechanism for managing a very large number of switches, lights, and motion detectors in order to accomplish the following functions:
* turn lights on and off normally with switches
* turn area lights on if motion is detected and it is dark out
* turn off lights in an area should motion not be detected for a set time

By importing and using various Java libraries, he has been able to create configurable maps for each light allowing things like motion detection timeout, and auto-on after dusk to be set per light (which can later be looked up or looped through in the script).

### Items file
    // First you start out by defining 3 groups: one for the switches, one for the dimmers, and one for the motion sensors

    Group:Contact:OR(OPEN,CLOSED) gMotionSensors            "motion sensors"        (All)
    Group:Switch:OR(ON,OFF) gMotionSwitches   "motion sensored switches"        (All)
    Group gMotionDimmers    "motion sensored dimmers"        (All)

    // Then put the light switches into the right groups. I use insteon switches, adjust as needed. I don't use a dimmer in this example but just put any dimmers into gMotionDimmers, you get the idea:

    Switch officeLight	   "office light"	(gMotionSwitches) {insteonplm="xx.xx.xx:F00.00.02#switch"}
    Switch garageLightMudroomSw      "garage light mudroom sw"	(gMotionSwitches)	{insteonplm="xx.xx.xx:F00.00.02#switch"}
    Switch garageLightEastWallSw  	   "garage light east wall sw"	(gMotionSwitches)	{insteonplm="xx.xx.xx:F00.00.02#switch"}

    // Then put the relevant motion sensors into the gMotionSensors group (example here uses alarmdecoder binding):

    Contact garageMotion "garage motion [MAP(contact.map):%s]"   (gMotionSensors) {alarmdecoder="RFX:0000000#contact,bitmask=0x80"}
    Contact officeMotion "office motion [MAP(contact.map):%s]"        (gMotionSensors) {alarmdecoder="RFX:0000000#contact,bitmask=0x80"}


### Script file
Lastly install the below rule as e.g. light_off.rule in the rules folder of your openhab configuration directory, and adjust the hash tables accordingly.

    import org.joda.time.*
    import org.openhab.core.library.types.*
    import org.openhab.core.library.types.PercentType
    import org.openhab.core.library.items.SwitchItem
    import org.openhab.model.script.actions.*
    import org.openhab.model.script.actions.Timer
    import java.util.HashMap
    import java.util.LinkedHashMap
    import java.util.ArrayList
    import java.util.Map
    import java.util.concurrent.locks.Lock
    import java.util.concurrent.locks.ReentrantLock
    
    //
    // Rules to switch off lights when no activity is present.
    //
    // Carefully modify the hash maps to achieve the desired result:
    //
    // Notes:
    // - a single timer is maintained per light fixture, i.e. there is a timer
    //   per switched electrical circuit.
    // - a light fixture can be switched from multiple switches.
    // - a single motion sensor can affect multiple light fixtures
    // - after a light fixture has been turned off, a restore timer
    //   is started. If there is motion within the restore timeout,
    //   the light fixture is switched back on
    // - the flag "on_when_dark" causes the light to be switched on
    //   if motion is detected and it's dark outside.
    //
    // Hash maps:
    //
    // fixtures: - key is the name of the fixture (arbitrary string, but must be unique)
    //           - configure the timeout (how long the light will stay on)
    //           - specify which switches manipulate the fixture
    // 
    // motionSensors: - key is name of motion sensor. Must be literally the same as
    //                  as the name of the contact item as which it is configured in
    //                  the .items file
    //                - specify a list of fixtures that will be kept on whenever the
    //                  sensor is tripped
    
    
    // Defines the timeouts for each fixture, and which switches control it
    
    // the lock was needed because multiple threads were found
    // to be entering the rule at once
    
    var Lock lock = new ReentrantLock()
    
    var HashMap<String, LinkedHashMap<String, Object>> fixtures =
    	newLinkedHashMap(
    		"officeFixture" -> (newLinkedHashMap("timer" -> null as Timer,
    				"restore_timer" -> null as Timer,
    				"timeout" -> 3600, "on_when_dark" -> true,
    				"switches" -> newArrayList(officeLight))
    			as LinkedHashMap<String, Object>),
    		"garageFixture" -> (newLinkedHashMap("timer" -> null as Timer,
    				 "restore_timer" -> null as Timer,
    				 "timeout" -> 600, "on_when_dark" -> true,
    				 "switches" -> newArrayList(garageLightMudroomSw, garageLightEastWallSw))
    			as LinkedHashMap<String, Object>)
    	)
    var HashMap<String, ArrayList<String>> motionSensors = 
    	newLinkedHashMap(
    		"garageMotion" -> newArrayList("garageFixture"),
    		"officeMotion" -> newArrayList("officeFixture")
    	)
    
      
    rule "motion sensor tripped"
    when
        Item gMotionSensors changed
    then
    	logInfo("motion_tripped", "motion sensors changed state")
    	lock.lock()
    	var DateTime daystart = new DateTime((dawnStart.state as DateTimeType).calendar.timeInMillis)
    	var DateTime dayend = new DateTime((duskEnd.state as DateTimeType).calendar.timeInMillis)
    	val boolean isdark = now.isBefore(daystart) || now.isAfter(dayend)
    	var faultedSensors = gMotionSensors.members.filter(x|x.state == OPEN).map[it.name]
    	faultedSensors.forEach [ sensor |
    		var ArrayList<String> lightsAffected = motionSensors.get(sensor as String)
    		if (lightsAffected != null) {
    			logInfo("motion_tripped", " tripped sensor: " + sensor)
    			lightsAffected.forEach [ x |
    				var HashMap<String, ?> fixture = fixtures.get(x)
    				logInfo("motion_tripped", " affected fixture: " + x)
    				var Timer timer = fixture.get("timer") as Timer
    				if (timer != null) {
    					var dt = fixture.get("timeout") as Integer
    					timer.reschedule(now.plusSeconds(dt))
    					logInfo("motion_tripped", "  restarted timer for: " + x + " to +" + dt + "sec")
    				} else {
    					var Timer restoreTimer = fixture.get("restore_timer") as Timer
    					if (restoreTimer != null || ((fixture.get("on_when_dark") as Boolean) && isdark)) {
    						// Motion happened right after light was switched off, or auto_on in the dark is requested.
    						// Switch light on!
    						logInfo("motion_tripped", "  actively switching on fixture: " + x)
    						var ArrayList<SwitchItem> sl = fixture.get("switches") as ArrayList<SwitchItem>
    						sl.forEach [ ts |
    							logInfo("motion_tripped", "   turning on switch: " + ts.name)
    							sendCommand(ts, ON) ]
    						if (restoreTimer != null) restoreTimer.cancel
    						fixture.put("restore_timer", null) // clear restore timer
    					}  else {
    						logInfo("motion_tripped", "  no reason to switch on fixture: " + x)
    					}
    				}
    			]
    		} else {
    			logInfo("motion_tripped", " tripped sensor " + sensor + " does not affect any lights")
    		}
    	]
    	logInfo("motion_tripped", "done handling " + faultedSensors.size + " tripped sensors")
    	lock.unlock()
    end
    
    rule "switch flipped"
    when
    	Item gMotionDimmers changed or
    	Item gMotionSwitches changed
    then
    	logInfo("switch_flipped", "motion timed switch or dimmer changed state!")
    
    	// first build the map from switch to fixtures
    	// XXX silly to do this every time the rule executes, but did not want to introduce another
    	// static map that would have to be maintained
    	var HashMap<String, ArrayList<String>> sToF = new HashMap<String, ArrayList<String>>()
    
    	for (f : fixtures.entrySet()) {
    		var ArrayList<SwitchItem> swl = f.getValue().get("switches") as ArrayList<SwitchItem>
    		for (SwitchItem si : swl) {
    			var fl = sToF.get(si.name)
    			if (fl == null) {
    				fl = new ArrayList<String>()
    				sToF.put(si.name, fl)
    			} 
    			fl.add(f.getKey())
    		}
    	}
    	val switchToFixture = sToF; // make it final so we can use it in closure
    	//
    	// now iterate through members
    	//
    	lock.lock()
    	(gMotionSwitches.members + gMotionDimmers.members).forEach [ sw |
    		var ArrayList<String> fixtureStrings = switchToFixture.get(sw.name)
    		fixtureStrings.forEach [ x |
    			// The acceptedDataTypes.get(0) is a terrible hack. For
    			// whatever reason it won't accept a plain OnOffType here.
    			var stateOnOff = sw.getStateAs(sw.acceptedDataTypes.get(0))
    			// logInfo("light_off", sw + " state: " + stateOnOff + " affects fixture: " + x)
    			var f = fixtures.get(x)
    			var Timer timer = f.get("timer") as Timer
    			var Integer timeOut = f.get("timeout") as Integer
    			if (stateOnOff == ON) {
    				if (timer == null) { // start timer for the corresponding fixture
    					var texp = now.plusSeconds(timeOut)
    					logInfo("switch_flipped", " creating timer for " + x + " in " + timeOut + "sec" )
    					timer = createTimerWithArgument(texp, x,
    						[ k |
    							logInfo("switch_timeout", "timer expired, switching off " + k)
    							lock.lock()
    							var ft = fixtures.get(k);
    							var ArrayList<SwitchItem> sl = ft.get("switches") as ArrayList<SwitchItem>
    							sl.forEach [ ts |
    								logInfo("switch_timeout", "  turning off switch: " + ts.name)
    								sendCommand(ts, OFF)
    								]
    							ft.put("timer", null) // clear timer
    							// start restore timer
    							logInfo("switch_timeout", " starting restore timer for " + k)
    							var tExpRest = now.plusSeconds(20)
    							var Timer restoreTimer =
    							createTimerWithArgument(tExpRest, k,
    								[xr |
    									logInfo("restore__timer", "restore timer expired for " + xr)
    									lock.lock()
    									var rft = fixtures.get(xr);
    									rft.put("restore_timer", null);
    									lock.unlock()
    									])
    							ft.put("restore_timer", restoreTimer)
    							lock.unlock()
    							])
    					f.put("timer", timer) // put it in map so it can be tracked 
    				} else {
    					logInfo("switch_flipped", "already have timer running for " + x)
    				}
    			}
    			]
    		]
    	logInfo("switch_flipped", "motion timed switch change state finished!")
    	lock.unlock()
    end


