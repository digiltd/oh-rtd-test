I have been using Wink for a about a week - but lack of local control was a deal breaker as well some inconsistencies  in maintaining the state of the GE-Link bulb.  It is very easy to get the status of the light bulb out of sync with the Wink app.  Another thing which is also a deal breaker is after power loss the light turns on  - I can understand why they did this, probably so you could turn on a lamp on with a local switch and not have to rely upon an app.  Anyhow thanks to the wonderful work done by a number of people in this forum and on reddit winkhubroot forum I was able to resolve these issues and have a very nice setup - here are my scripts and how I did it.

Goals :
Local Control
Consistency between actual state of the lights and app
Maintain state after power failure for GE Link Bulbs
Setup :
Raspberry PI  with 8GB flash running openhab and asterisk - it was a http://www.raspberry-asterisk.org/ distro
Wink hub
3 GE Links lights so far - will be adding more
Nest 
2 ZWave dimmers - added them to the Wink hub haven't finished the integration
Waiting on X-10 USB RF controller to integrate the existing X-10 network.

I used a combination of approaches mainly from these two posts, many thanks to the original posters, since I have borrowed so many things then build up on them, I won't mention each idea.

Wink "binding" without a binding https://groups.google.com/forum/#!msg/openhab/pmrns4Yb8fM/BzqCJrpt7ycJ
Fastest way to get a command to aprontest locally? http://www.reddit.com/r/winkhub/comments/2r8xuz/fastest_way_to_get_a_command_to_aprontest_locally/

One disclaimer I am not a Java programmer or unix shell script person, I get by hacking around other people's code and its my third day with openhab, so if you find something stupid would appreciate if you would point it out.

Lets do the easy one first :

Maintain state after power failure for GE Link Bulbs

Although after a power failure GE Link bulbs turn on, however internally either in Wink or in the bulb the last "SET" state is remembered so leveraging that I sync the two states using a startup script based on the assumption that Wink will also reboot after a power failure.  This script checks the status of each light and if there is a difference between the current status and the last status it sets the light bulb to the last status.  I have set to run every 6 hours.  So if someone does turn on the light locally after 6 hours it will get turned off.  Although with LED bulbs energy usage is not much of an issue but waste any.

Link to the  script - http://pastebin.com/Z3ajMk43
I run this script as a startup service using the service example by wpskier from here http://www.reddit.com/r/winkhub/comments/2r8xuz/fastest_way_to_get_a_command_to_aprontest_locally/cnn2lxh


Maintain consistency between openhab and devices

I basically used wpskier solution in the above-mentioned link with  few couple of changes:
Added ability to send raw attribute data instead of target data in the original script
Ability to read level data and send back a calculated percentage that is bound directly to the dimmer control
Longer sleep between each run - I do 9 sec sweeps, this doesn't overload the CPU and also allows the bulb to reach the desired level after a change command
Here is the link to  my modified script http://pastebin.com/R4dHpzB7 and its also run using the same technique as the previous script from rc.d.  

Local control

This is done by  rule based on  Anderew M's post Wink "binding" without a binding  - currently I am duplicating the rules for each device which is inelegant but I will have at most 10-15 lights so I can live with it for now.  I was trying to duplicate the dual nature of buttons in the wink app that they are both dimmers and switches unfortunately openhab's dimmer control doesn't seem to work that way, I can either turn the light off by changing the level to 0% but the state will still be on and upon power failure the light will come back on.  In the end I ended up forcing an ON and OFF and 0% and 100%.

This script uses the ssh technique to call Wink by JustinAike in this post http://www.reddit.com/r/winkhub/comments/2r8xuz/fastest_way_to_get_a_command_to_aprontest_locally/cneh6dc
The rule - 

    rule "Den Light Control"
	when 
		Item denlight received command
	then
		 var Number percent = 0

		 if(denlight.state instanceof DecimalType) 
		         percent = denlight.state as DecimalType 
		 
		 logInfo("ExecUtil", "Light Status = " + percent)
		 if(receivedCommand==OFF) {
			 executeCommandLine("/root/bin/wink.sh -u -m 6 -t 1 -v OFF") 
		 }
		 else if (receivedCommand==ON){
			 executeCommandLine("/root/bin/wink.sh -u -m 6 -t 1 -v ON")
		  }
		 else {
			 if(receivedCommand==INCREASE) {
			   percent = percent + 1
			   logInfo("ExecUtil", "Increased")
			 }
			 if(receivedCommand==DECREASE) {
			   percent = percent - 1
			   logInfo("ExecUtil", "Increased")
			 }
			 if(percent<=0) {
			   percent = 0
			   executeCommandLine("/root/bin/wink.sh -u -m 6 -t 1 -v OFF")
			 } else {
			   executeCommandLine("/root/bin/wink.sh -u -m 6 -t 1 -v ON")
			 }
			 if(percent>=100) {
			   percent = 100
			  
			 }
			 var value = percent * 2.55 
			 executeCommandLine("/root/bin/wink.sh -u -m 6 -t 2 -v" + value.intValue)
		 }
    end

