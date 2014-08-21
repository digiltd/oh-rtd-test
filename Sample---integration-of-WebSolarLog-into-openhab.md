
For those that have no direct connection to their solar System or PVOutput - you might consider to check if [WebSolarLog.com](http://www.WebSolarLog.com) can support your device.

I have succesfully integrated this for my Diehl Solar system and can get the live data via exec binding and a small script into OH to react on energy production/ sun.

Steps to take:

* check if websolarlog supports your solar/ energy device
* install the same on either the same device or on a seperate one. Currently experimenting with it - a seperate PI would be performance wise better to suite
* after installation done use the API from websolarlog to take a look on the desired data:
   _**http://<yourWSLIP>/websolarlog/api.php/Live**_ - the result should look like:

`  {"0":{"type":"production","id":"1","name":"Diehl PV","data":{"id":"11","INV":"1","deviceId":"1","I1V":"335.7","I1A":"9.731","I1P":"3257","I1Ratio":"100","I2V":null,"I2A":null,"I2P":null,"I2Ratio":"0","I3V":null,"I3A":null,"I3P":null,"I3Ratio":"0","GV":"229.8","GA":"13.728","GP":"3156","GV2":null,"GA2":null,"GP2":null,"GV3":null,"GA3":null,"GP3":null,"SDTE":null,"time":"1408613158","FRQ":"50","EFF":"96.899","INVT":"45.63","BOOT":null,"KWHT":"7568.017","IP":null,"ACP":null,"status":null,"name":null,"trendImage":null,"trend":null,"avgPower":null,"type":null}},"1":{"type":"weather","id":"2","name":"Pflugfelden","data":{"id":"111","deviceId":"2","time":"1408612800","temp":"17.29","temp_min":"12.78","temp_max":"22.78","pressure":"1018","humidity":"55","conditionId":"801","rain1h":null,"rain3h":null,"clouds":"20","wind_speed":"2.6","wind_direction":"250"}},"totals":{"production":{"devices":1,"GP":3156,"GP2":0,"GP3":0},"metering":{"devices":0,"liveEnergy":0}}}`

* I then used a simple perl script reading regular expressions the value of: "GP":"3156" and posted the same to openhap items:

## Script:  
There might be an easier way for the regular expressions or using json but - i am not a programmer so used what i was able to do. For getting the relevant integer i used [txt2re.com](http://txt2re.com)   
   
`#!/usr/bin/perl  `
`use LWP::Simple;  `
`my $url = 'http://192.168.1.10/websolarlog/api.php/Live';  `
`my $txt = get $url;  `
`die "Couldn't get $url" unless defined $txt;  `
  
`# http://txt2re.com/index-perl.php3?s={%220%22:{%22type%22:%22production%22,%22id%22:%221%22,%22name%22:%22Diehl%20PV%22,%22data%22:{%22id%22:%221%22,%22INV%22:%221%22,%22deviceId%22:%221%22,%22I1V%22:%22227.7%22,%22I1A%22:%220.034%22,%22I1P%22:%227%22,%22I1Ratio%22:%22100%22,%22I2V%22:null,%22I2A%22:null,%22I2P%22:null,%22I2Ratio%22:%220%22,%22I3V%22:null,%22I3A%22:null,%22I3P%22:null,%22I3Ratio%22:%220%22,%22GV%22:%22229.2%22,%22GA%22:%220.055%22,%22GP%22:%221%22,%22GV2%22:null,%22GA2%22:null,%22GP2%22:null,%22GV3%22:null,%22GA3%22:null,%22GP3%22:null,%22SDTE%22:null,%22time%22:%221407782202%22,%22FRQ%22:%2249.98%22,%22EFF%22:%2214.286%22,%22INVT%22:%2239.42%22,%22BOOT%22:null,%22KWHT%22:%227450.828%22,%22IP%22:null,%22ACP%22:null,%22status%22:null,%22name%22:null,%22trendImage%22:null,%22trend%22:null,%22avgPower%22:null,%22type%22:null}},%22totals%22:{%22production%22:{%22devices%22:1,%22GP%22:1,%22GP2%22:0,%22GP3%22:0},%22metering%22:{%22devices%22:0,%22liveEnergy%22:0}}}&302  `
  
`$re1='.*?';	# Non-greedy match on filler  `
`$re2='\\d+';	# Uninteresting: int  `
`$re3='.*?';	# Non-greedy match on filler  `
`$re4='\\d+';	# Uninteresting: int  `
`$re5='.*?';	# Non-greedy match on filler  `
`$re6='\\d+';	# Uninteresting: int  `
`$re7='.*?';	# Non-greedy match on filler  `
`(...)   `
`$re58='\\d+';	# Uninteresting: int   `
`$re59='.*?';	# Non-greedy match on filler  `
`$re60='(\\d+)';	# Integer Number 1  `
  
`$re=$re1.$re2.$re3.$re4.$re5.$re6.$re7.$re8.$re9.$re10.$re11.$re12.$re13.$re14.$re15.$re16.$re17.$re18.$re19.$re20.$re21.$re22.$re23.$re24.$re25.$re26.$re27.$re28.$re29.$re30.$re31.$re32.$re33.$re34.$re35.$re36.$re37.$re38.$re39.$re40.$re41.$re42.$re43.$re44.$re45.$re46.$re47.$re48.$re49.$re50.$re51.$re52.$re53.$re54.$re55.$re56.$re57.$re58.$re59.$re60;  `
`if ($txt =~ m/$re/is)  `
`{  `
    `$int1=;  `
    `print "$int1";  `
`}  `
   
   
## OH items
`Number DiehlW	     "Diehl W [%.3f kW]"	(gDiehl)	{exec="<[/usr/bin/perl /opt/openhab/configurations/scripts/pv_diehl.pl:30000:REGEX((.*?))]"}`  
`Number DiehlKW    "Diehl KW [%.3f kW]"	(gDiehl)`
   
I then transformed the same by a rule into kW.  
   
## Sample Rules 
Created to react on the kW generated to close down some shutters:  
   
`// Calculate based on Input from Script the kW  `
`rule "Calc KW"  `
`when  `
   `Item DiehlW received update  `
`then  `
   `{  `
    `var diehlW  = DiehlW.state as DecimalType  `
    `var diehlKW = (diehlW / 1000)  `
    `postUpdate(DiehlKW, diehlKW)  `
   `}  `
`end  `
 
`// Calculate the average kW from last 90 minutes  `
`rule "Calc SolarAverage"  `
`when   `
   `Item DiehlKW received update  `
`then  `
   `var diehlAV = DiehlKW.averageSince(now.minusMinutes(90)) as DecimalType  `
   `postUpdate(DiehlAV, diehlAV)  `
`end  `
 
`// Activate the Solar actions based on an average kW above 1.8   `
`rule "Activate SunAuto based on SolarAverage"  `
`when   `
   `Item DiehlAV received update  `
`then  `
   `if (DiehlAV.state >= 1.8)  `
    `{    `
     `sendCommand(SunAuto, ON)  `
    `}  `
   `else sendCommand(SunAuto, OFF)   `
`end  ` 
`   `
`// Activate shutter down when SunAuto.state is ON between 11-17 every 15 minutes`
`rule "Sonnenschutz Automatisch"  `
`when  `
   `Time cron "0 */15 11-17 * * ?"  `
`then  `
   `if(SunAuto.state==ON){`
     `postUpdate(SunAutoActive, ON)   `
     `sendCommand(Shutter_DG_West, DOWN)   `
     `sendCommand(Shutter_DG_South, DOWN)    `
     `Thread::sleep(15000)   `
     `sendCommand(Shutter_DG_West, STOP)   `
     `sendCommand(Shutter_DG_South, STOP)   `
   `}   `
   `else if(SunAuto.state==OFF){   `
        `if (SunAutoActive.state==ON){   `
            `postUpdate(SunAutoActive, OFF)   `
            `sendCommand(Shutter_DG_West, UP)   `
            `sendCommand(Shutter_DG_South, UP)   `
        `}  `
   `}   `
`end`

Have fun!   
Karsten