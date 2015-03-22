This page contains samples for binding configurations. These samples are sorted by binding.

* [How to - KNX basic configuration](Samples-Binding-Config#knx-basic-configuration)
* [How to send Date and Time from NTP to KNX](Samples-Binding-Config#how-to-send-date-and-time-from-ntp-to-knx)
* [How to use KNX data types 2.xxx Priority Control](Samples-Binding-Config#how-to-use-knx-data-types-2xxx-priority-control)
* [How to use KNX scenes](Samples-Binding-Config#how-to-use-knx-scenes)
* [How to get temperatures from OW-SERVER via HTTP binding](Samples-Binding-Config#how-to-get-temperatures-from-ow-server-via-http-binding)
* [How to get humidity from OW-SERVER via HTTP binding](Samples-Binding-Config#how-to-get-humidity-from-ow-server-via-http-binding)
* [How to get contact from OW-SERVER via HTTP binding](Samples-Binding-Config#how-to-get-contact-from-ow-server-via-http-binding)
* [How to turn on/off a switch from OW-SERVER via HTTP binding](Samples-Binding-Config#how-to-turn-onoff-a-switch-from-ow-server-via-http-binding)
* [How to read the status from a OneWire sensor DS2413 (2 port I/O)](Samples-Binding-Config#how-to-read-the-status-from-a-onewire-sensor-ds2413-2-port-io)
* [How to get data from Kostal Piko solar inverter via HTTP binding](Samples-Binding-Config#how-to-get-data-from-kostal-piko-solar-inverter-via-http-binding)
* [How to send commands to Telldus Tellstick](Samples-Binding-Config#how-to-send-commands-to-telldus-tellstick)
* [How to get power on a TV connected to HDMI with exec binding and update the status automatically](Samples-Binding-Config#how-to-get-power-on-a-tv-connected-to-hdmi-with-exec-binding-and-update-the-status-automatically)
* [How to catch a Mobotix T24/T25 bell button signal](Samples-Binding-Config#how-to-catch-a-mobotix-t24-bell-button-signal)

### KNX basic configuration

The openhab.cfg file

- The easiest way of configuring a KNX binding is by connecting in ROUTER mode. To do so, enable this: `knx:type=ROUTER` . If you cannot use the ROUTER mode, set it to TUNNEL, but you must then configure the IP: `knx:ip=<IP of the KNX-IP module>`



The items file

The items may include the KNX group address to use them. They might be actively read by openHAB or not. They look like this:

- `Number Lighting_Room_Sensor "Lighting in the Room [Lux](%.2f)"  <switch> (Room,Lighting) { knx = "<0/1/1" }`: This is a sensor item. It uses the 0/1/1 group address and openHAB will ask for its value periodically because there is a "<" sign before the address. It is a number item, called Lighting_Room_Sensor, and belongs to Room and Lighting groups.
- `Switch Light_Room_Table  "Table Light" (Room, Lights) { knx = "<0/1/10+0/1/30"}`: This is a switch item that has two addresses. openHAB may responds to events in any of them, but may actively read the first one.

### How to send Date and Time from NTP to KNX

This example sends the current date and time from the NTP to the KNX binding

    DateTime Date "Date & Time [%1$td.%1$tm.%1$tY %1$tT]" { ntp="Europe/Berlin:de_DE", knx="11.001:0/0/1, 10.001:0/0/2" } 

**Items**: 

  0/0/1 is the GA for Date

  0/0/2 is the GA for Time

Additional information on date and time formatting can be found 
[here](http://docs.oracle.com/javase/1.5.0/docs/api/java/util/Formatter.html#syntax)

### How to use KNX data types 2\.xxx Priority Control
Starting with version 1.6.0 KNX data types 2.xxx are supported.
This examples shows the usage of DPT 2.001 "Switch Control".

item definition:
  
    Number item2_001 "2.001 Switch Control" { knx="2.001:1/2/3"}

sitemap definition:
		
    Selection item=item2_001 mappings=[ 0="priority override disabled (off)", 1="priority override disabled (on)", 2="priority override: off", 3="priority override: on" ]

or

    Switch item=item2_001 mappings=[ 0="priority override disabled (off)", 1="priority override disabled (on)", 2="priority override: off", 3="priority override: on" ]

### How to use KNX scenes
KNX devices differ in the ways scenes can be activated and learned (programmed). Some devices require a bit trigger using data point type 1.022 "DPT_SCENE_AB", which will activate either scene A or B.
These devices can be used as follows (starting with version 1.6.0):

item definition:
  
    Number item1_022 "1.022 SCENE AB" { knx="1.022:1/2/3"}

sitemap definition:
		
    Selection item=item1_022 mappings=[ 0="Scene A", 1="Scene B" ]

or

    Switch item=item1_022 mappings=[ 0="Scene A", 1="Scene B" ]

Some devices require a byte using data point type 18.001 "DPT_SCENE_CONTROL", which will activate or learn one of 64 possible scenes. Adding 128 to the scene number to allow switching to learn mode.
Example: "activate Scene 2" requires value 1, "learn Scene 2" requires value 129 
These devices can be used as follows (starting with version 1.6.0):

item definition:
  
    Number item18_001 "Scene Control" {knx="18.001:1/2/3"}

sitemap definition:
		
    Selection item=item18_001 mappings=[ 0="Scene 1", 1="Scene 2", 2="Scene 3", 3="Scene 4", 128="learn Scene 1", 129="learn Scene 2", 130="learn Scene 3" ]

or

    Switch item=d18_001 mappings=[0="Scene 1", 1="Scene 2", 2="Scene 3", 128="learn Scene 1", 129=" learn Scene 2", 130="learn Scene 3"]

If you have a device requiring 17.001 DPT_SCENE_NUMBER for selecting or indicating scenes, then use one of the above mentioned examples and replace 18.001 with 17.001. Additionally, remove all "learn" mappings.

### How to get temperatures from OW-SERVER via HTTP binding

Requirements:
- [OW-SERVER with Ethernet](http://www.embeddeddatasystems.com/OW-SERVER-1-Wire-to-Ethernet-Server-Revision-2_p_152.html)
- [DS18B20](http://www.mikrocontroller.net/part/DS18B20)-Sensors (or DS18S20) connected via 1-wire-bus

Instructions:
1. Go to http://`<ow-server-IP>`/devices.htm and look for the ROMId-Value
![OW Server](https://lh3.googleusercontent.com/-XdaTtDlzyEU/Ud7_uB4fPCI/AAAAAAAALTY/pmajPpkk6uo/w780-h445-no/owserver_devices.PNG "OW Server")

1. Add an Number-Item to your items-configuration like this one

```
// Example:
Number Temp_Kitch "Küche [°C](%.1f)" { http="<[Units=\"Centigrade\">(.*?)</Temperature>.*)](http://192.168.1.16/details.xml:60000:REGEX(.*?<ROMId>A7000002CC4D2228</ROMId>.*?<Temperature)" }
```

Replace the ip address and the ROMId-value with your data.

### How to get humidity from OW-SERVER via HTTP binding

Device: OW-ENV-TH (EDS0065)

Example:

    Number Humidity "Humidity [%.1f %%]" { http="<[http://192.168.1.16/details.xml:5000:REGEX(.*?<ROMId>C30010000027767E</ROMId>.*?<Humidity Units=\"PercentRelativeHumidity\">(.*?)</Humidity>.*)]" }

### How to get contact from OW-SERVER via HTTP binding

Device: D2C (DS2406)

Example:

    Number Door "Door [MAP(contact.map):%d]" { http="<[http://192.168.1.16/details.xml:5000:REGEX(.*?<ROMId>BD0000009D93DC12</ROMId>.*?<InputLevel_A>(.*?)</InputLevel_A>.*)]" }
You may want to change the query-interval (here 5000ms) to a few seconds.
You can get the value for InputLevel_B, too. ;)
```
contact.map:
    0=open
    1=close
    -=UNKNOWN
```

### How to turn on/off a switch from OW-SERVER via HTTP binding

Device: D2C (DS2406)

Example:

    Switch Lamp "Switch [MAP(switch.map):%d]" { http="<[http://192.168.1.16/details.xml:5000:REGEX(.*?<ROMId>BD0000009D93DC12</ROMId>.*?<InputLevel_B>(.*?)</InputLevel_B>.*)]" }
This only reads the state of the switch.
```
switch.map:
    1=ON
    0=OFF
    -=undefiniert
```
To turn the switch on or off you need to define two rules:
    rule "Turn Lamp on"
    when 
    	Item Lamp changed to ON
    then
    	sendHttpGetRequest("http://192.168.1.16/devices.htm?rom=BD0000009D93DC12&variable=FlipFlop_B&value=0")
    end
    
    rule "Turn Lamp off"
    when 
    	Item Lamp changed to OFF
    then
    	sendHttpGetRequest("http://192.168.1.16/devices.htm?rom=BD0000009D93DC12&variable=FlipFlop_B&value=1")
    end

### How to read the status from a OneWire sensor DS2413 (2 port I/O)

item definition:

    Number WindowContact1   "Window 1 is [MAP(contact.map):%s]"                  (All) { onewire = "3C.16AA13000000#sensed.A" }
    Number WindowContact2   "Window 2 is [MAP(contact.map):%s]"                  (All) { onewire = "3C.16AA13000000#sensed.B" }

sitemap definition:

    Text item=WindowContact1
    Text item=WindowContact2

map file contact.map

    1=closed
    0=opened

Sample output for this definition would then be "Window 1 is opened" or "Window 2 is closed".

### How to get data from Kostal Piko solar inverter via HTTP binding

![Kostal Piko](https://lh4.googleusercontent.com/-pa3EqaUPe_E/Ud8lK56J_-I/AAAAAAAALT0/KNOfi7gWe_c/w563-h634-no/openhab_kostal_piko_screenshot.PNG)
```
/* AC Leistung */
Number Solar_Aktuell            "aktuelle Leistung [%.0f W]"  <inverter>   { http="<[kostal-wechselrichter-cache:30000:REGEX(.*aktuell</td>.*?([0-9]*)</td>.*)]" }

/* Energie */
Number Solar_Gesamt             "Ertrag (gesamt) [%.0f kWh]"  <energy>     { http="<[kostal-wechselrichter-cache:30000:REGEX(.*Gesamtenergie</td>.*?(\\d*)</td>.*)]" }
Number Solar_Tagesenergie       "Ertrag (am Tag) [%.2f kWh]"  <energy>     { http="<[kostal-wechselrichter-cache:30000:REGEX(.*Tagesenergie</td>.*?([0-9\\.]*)</td>.*)]" }

/* PV Generator String 1*/
Number Solar_PVG_Str1_Spannung  "String1 Spannung [%d V]"                    { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?String 1.*?Spannung</td>.*?(\\d*)</td>.*)]" }
Number Solar_PVG_Str1_Strom     "String1 Strom [%.2f A]"                     { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?String 1.*?Strom</td>.*?([0-9.]*)</td>.*)]" }

/* PV Generator String 2*/
Number Solar_PVG_Str2_Spannung  "String2 Spannung [%d V]"                    { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?String 2.*?Spannung</td>.*?(\\d*)</td>.*)]" }
Number Solar_PVG_Str2_Strom     "String2 Strom [%.2f A]"                     { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?String 2.*?Strom</td>.*?([0-9.]*)</td>.*)]" }

/* Ausgangsleistung & Spannung L1 */
Number Solar_AL_L1_Spannung     "L1 Spannung [%d V]"                       { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?String 1.*?Spannung</td>.*?Spannung</td>.*?(\\d*)</td>.*)]" }
Number Solar_AL_L1_Leistung     "L1 Leistung [%d W]"                       { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?String 1.*?Leistung</td>.*?(\\d*)</td>.*)]" }

/* Ausgangsleistung & Spannung L2 */
Number Solar_AL_L2_Spannung     "L2 Spannung [%d V]"                       { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?L2</u></td>.*?Spannung</td>.*?Spannung</td>.*?(\\d*)</td>.*)]" }
Number Solar_AL_L2_Leistung     "L2 Leistung [%d W]"                       { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?L2</u></td>.*?Leistung</td>.*?(\\d*)</td>.*)]" }

/* Ausgangsleistung & Spannung L3 */
Number Solar_AL_L3_Spannung     "L3 Spannung [%d V]"                       { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?L3</u></td>.*?Spannung</td>.*?(\\d*)</td>.*)]" }
Number Solar_AL_L3_Leistung     "L3 Leistung [%d W]"                       { http="<[kostal-wechselrichter-cache:30000:REGEX(.*?L3</u></td>.*?Leistung</td>.*?(\\d*)</td>.*)]" }
```
To avoid loading the HTML page for each entry add a HTTP cache entry (for the HTTP binding) to your openhab.cfg like:

```
http:kostal-wechselrichter-cache.url=http://pvserver:password@192.168.1.1/index.fhtml
http:kostal-wechselrichter-cache.updateInterval=60000
```

**Make sure you replace "password" with your password and edit the ip address!**

### How to send commands to Telldus Tellstick

This a simple example of how to command your tellstick devices from Openhab. For event triggered inbound integration, check the [Integration with other applications](https://code.google.com/p/openhab-samples/wiki/integration#Telldus_Tellstick) page.

Please note that if you use the inbound integration you must name you item `td_device_<number>` where `<number>` is the tellstick device enumeration as listed from command: `tdtool -l`. Obviously you also need to change enumeration after `--on` and `--off` in the exec binding.

Item definition:

    Switch td_device_5 "Tellstick device 5" {exec=">[ON:tdtool --on 5] >[OFF:tdtool --off 5]"}

### How to get power on a TV connected to HDMI with exec binding and update the status automatically

This is an example of how to power on a TV connected to the openhab server via HDMI. First you have to install cec-client utility on your host (you can see more details in [page)

The next thing is use the exec and the samsung binding (I can't switch on the TV with the samsung binding, and I can't switch off with the cec-client). My item definition shows like:

    Switch  TV_GF_Living_TV_power  "Power"  (GF_Living_TV)  { exec="ON:/usr/local/bin/samsungTvStart.sh, OFF:/bin/true", samsungtv="OFF:Livingroom:KEY_POWEROFF, ON:Livingroom:KEY_POWERON" }

And the script /usr/local/bin/samsungTvStart.sh is

    echo 'on 0' | cec-client -s

The next thing is automatically check and update the status. I use a shell script that I run every minute with cron. The script /usr/local/bin/samsungTvCheck.sh is 
```
#!/bin/bash
OH_URL=[OPENHAB_URL]
OH_USER=[OPENHAB_USER]
OH_PASS=[OPENHAB_PASS]
OH_ITEM=[OPENHAB_ITEM]
RESULT=`echo pow 0 | cec-client -d 1 -s | grep "power status:" | awk '{ print $3; }'`

case $RESULT in
        on)
                curl --user $OH_USER:$OH_PASS --max-time 2 --connect-timeout 2 --header "Content-Type: text/plain" --request PUT --data "ON" $OH_URL/rest/items/$OH_ITEM/state
                exit 0
                ;;
        *)
                curl --user $OH_USER:$OH_PASS --max-time 2 --connect-timeout 2 --header "Content-Type: text/plain" --request PUT --data "OFF" $OH_URL/rest/items/$OH_ITEM/state
                exit 1
esac
```
and you can add a line to your cron (in linux systems) with the command 

    crontab -e
    */1 * * * * /usr/local/bin/samsungTvCheck.sh

Note that you have to change [OPENHAB_URL](http://blog.endpoint.com/2012/11/using-cec-client-to-control-hdmi-devices.html]), [[OPENHAB_PASS](OPENHAB_USER],) and [OPENHAB_ITEM] according to your installation. This script update the status of the item, and you can see if your childs has switch on the tv ;)

### How to catch a Mobotix T24 bell button signal

To catch the bell ring event we make use of the Tcp/Ip binding. Please make sure to have it correctly placed in your addons directory.
To configure the binding we edit the openhab.cfg and add the following lines:
```
######################### TCP - UDP Binding ################################### 
# 
# all parameters can be applied to both the TCP and UDP binding unless  
# specified otherwise 

# Port to listen for incoming connections 
tcp:port=3000 

# Share connections within the Item binding configurations 
tcp:itemsharedconnections=true 

# Share connections between Item binding configurationswin 
tcp:bindingsharedconnections=true 

# Share connections between inbound and outbound connections 
tcp:directionssharedconnections=false 

# Allow masks in ip:port addressing, e.g. 192.168.0.1:* etc 
tcp:addressmask=true 

# Perform all write/read (send/receive) operations in a blocking mode, e.g. the binding
# will wait for a reply from the remote end after data has been sent
tcp:blocking=false

# Timeout - or 'refresh interval', in milliseconds, of the worker thread
tcp:refreshinterval=250

# Update the status of Items using the response received from the remote end (if the
# remote end sends replies to commands)
tcp:updatewithresponse=false
```
Now we configure the Mobotix T24 via the web GUI

First we add a new IP-Notification profile: We use the Admin Menu and chose Transfer Profiles/IP Notify Profiles. Then we make the settings according to the screenshot:
- We chose a name for the profile
- We select user defined configuration
- Destination address and port (of the openHab server)
- Tcp/Ip as protocoll
- Datatype just text
- an the text you whish to send and parse on openHab
- additionally you can configure the source port of the request. This tightens the security and you don't need to allow openHab to accept requests from any source port.

![](http://i.pictr.com/ho9qjdt6l4.png)

As a next step we assign this new Network Profile to the Event "CameraBellButton" i.e. when someone rings at the door.

We chose the Setup menu Event Control/Action Group Overview and add a new group
- We add a name for the group
- Set it active
- And chose the event Signal:CameraBellButton

Then we add a new Action and select the previously created IP-Notification profile

![](http://i.pictr.com/yrswqtkboq.png)

Now we can create a new item in openHab e.g.
```
/*Bell*/

Switch  Bell {tcp="<[ON:192.168.0.101:*:'REGEX((ON))']", autoupdate="false" } // for a Switch Item that captures the ringing from the T24 Mobotix  that connects to openHAB 
```
The REGEX parses the TCP message for the keyword "ON" which we have set in the Mobotix configuration.

In case you want to open the door via a Switch item as well:
```
/*MainDoor*/

Switch MainDoor { http=">[ON:GET:http://user:password@192.168.0.101/control/rcontrol?`action=customfunction&action=sigout&profile=~Door]", autoupdate="false" }
```
The Camera image can be put on the openHab sitemap via:
```
Image url="http://user:password@192.168.0.101/record/current.jpg" refresh=1000 //Camera image with 1fps
```