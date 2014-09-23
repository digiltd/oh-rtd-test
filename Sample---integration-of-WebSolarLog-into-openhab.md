For those that have no direct connection to their solar System or PVOutput - you might consider to check if [WebSolarLog.com](http://www.WebSolarLog.com) can support your device. The devices can be found on the [WebSolar Log Web Page](http://www.websolarlog.com/index.php/faqs/).

I have succesfully integrated this for my Diehl Solar system and can get the live data via exec binding and a small script into OH to react on energy production/ sun.

Steps to take:

* check if websolarlog supports your solar/ energy device
* install the same on either the same device or on a seperate one. Currently experimenting with it - a seperate PI would be performance wise better to suite
* after installation done use the API from websolarlog to take a look on the desired data:
'http://<yourWSLIP>/websolarlog/json2xml.php?url=<yourWSLIP>/websolarlog/api.php/Live?url=<yourWSLIP>/websolarlog/api.php/Live'

With this you should be able to see a XML File with the relevant information needed. The XML transfromation PHP should be in the current release - if not a guidance to download  can be downloaded here: [WebSolarBugTracker](http://tracker.websolarlog.com/view.php?id=268)

* now you need to create a transformation file in the transform directory of openhab:
 
wsl_pv_GP.xsl: 
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
        
        <xsl:output indent="yes" method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

        <xsl:template match="/">
						    <xsl:for-each select="html/body/div/tr/td">
				    			<xsl:if test="Power:">
						      <xsl:value-of select="span name="/>
						    </xsl:if>
						    </xsl:for-each>
        </xsl:template>

</xsl:stylesheet> 


## OH items
`Number DiehlWtemp	"Diehl W  [%.3f]"	{ http="<[http://<yourWSLIP>/websolarlog/json2xml.php?url=<yourWSLIP>/websolarlog/api.php/Live?url=<yourWSLIP>/websolarlog/api.php/Live:60000:XSLT(wsl_pv_GP.xsl)]" }`  
`Number DiehlKW     "Diehl KW [%.3f kW]"`
   
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
     `Thread::sleep(15000)   ` 
     `sendCommand(Shutter_DG_West, STOP)   ` 
   `}   ` 
   `else if(SunAuto.state==OFF){   ` 
        `if (SunAutoActive.state==ON){   ` 
            `postUpdate(SunAutoActive, OFF)   ` 
            `sendCommand(Shutter_DG_West, UP)   ` 
        `}  ` 
   `}   ` 
`end`  

Have fun!   
Karsten