Documentation of the XBMC binding

## Introduction

This page describes the XBMC binding, which allows openhab items to receive realtime updates about information like player state and running media from one or more instances of xbmc.

[![openhab binding for xbmc](http://img.youtube.com/vi/N7_5phTVbo0/0.jpg)](http://www.youtube.com/watch?v=N7_5phTVbo0)

### Installation 

For installation of the binding, please see Wiki page Bindings.

### System requirements

This binding has been developed and tested on XBMC Frodo (v12) and Gotham (v13).
The binding uses XBMCs JSON-RPC API, both the HTTP and the websocket transports. These therefore need to be enabled and need to be reachable from your openHAB host (think firewall, routing etc.)

### Support

If you have any questions about this binding, encounter any problems or think you found a bug, please issue a bug report.

## Global binding configuration

The XBMC binding allows you to define named instances of XBMC in your openhab.cfg. When defining your item binding configuration you can use the name to refer to your instances. In doing so, you can easily change the address by which you XBMC instance can be reached without having to reconfigure all of your bindings. 

The syntax of the binding configuration is like this:
```
xbmc:{instanceName}.{parameter}={value}
```
Where <instanceName> is the name by which you can refer to this instance in your item binding configuration.
<parameter> can be one of the following
* host
* rsPort
* wsPort
* username
* password 

### Example

    ######################## XBMC Binding ###########################
    
    # Hostname / IP address of your XBMC host
    xbmc:livingRoom.host=192.168.1.6
    
    # Port number for the json rpc service (optional, defaults to 8080)
    xbmc:livingRoom.rsPort=8080
    
    # Port number for the web socket service (optional, defaults to 9090)
    xbmc:livingRoom.wsPort=9090
    
    # Username to connect to XBMC. (optional, defaults to none)
    xbmc:livingRoom.username=xbmc
    
    # Password to connect to XBMC. (optional, defaults to none)
    xbmc:livingRoom.password=xbmc


Although you *can* configure one or more instances, it is not strictly necessary to do so. As long as you dont intend to use ports or login data different from the default, you could just as well use this by directly refering to hostnames or ip adresses in you item binding configuration.

## Item binding configuration

### Configuration format

    xbmc="{direction}[{host}|{property}]"

Where
* {direction}: < for incoming (player state, media title etc.), > for outgoing (Send "Play/Pause" or "Stop" etc.) or = for bi-directional (send/receive volume) 
* {host}: When prefixed by a '#' a named instance, otherwise hostname or ip address of your xbmc host.
* {property}: The property to bind to (more on this later)

Some examples:

    xbmc="<[#livingRoom|Player.State]"
    xbmc="<[#livingRoom|Player.Title]"

    xbmc="<[#bedroom|Player.State]"

    xbmc="<[192.168.1.6|Player.State]"
    xbmc="<[xbmc.local|Player.Title]"

    xbmc="=[#livingRoom|Application.Volume]" 

### Available properties

Currently, the list of properties you can use in your binding configuration is very limited:

Property          | Direction | Description
----------------- |:---------:| ------------
Player.State      | <         | Current player state: 'Play', 'Pause', 'End' (Stopped due to end of content), 'Stop' (Stopped by user). An 'End' state is immediately followed by a 'Stop' state.
Player.Type       | <         | Currently playing type: 'movie', 'episode', 'channel', or 'unknown' for a PVR recording
Player.Title      | <         | Currently playing title: movie name, TV episode name, music track name
Player.ShowTitle  | <         | Currently playing show title: TV show name, empty for other types
Player.Artist     | <         | Currently playing artist (music only)
Player.Album      | <         | Currently playing album (music only)
Player.Label      | <         | Currently playing title (in case of radio streams) 
Player.<???>      | <         | Any other player property supported by the XBMC JSON RPC API
Player.PlayPause  | >         | Play/pause playback
Player.Stop       | >         | Stop playback
Player.Open       | >         | Open a URL for playback
System.Shutdown   | >         | Send OFF to power down the system
System.Suspend    | >         | Send OFF to put the system in Suspend mode
System.Hibernate  | >         | Send OFF to put the system in Hibernate mode
System.Reboot     | >         | Send OFF to reboot the system
System.State      | <         | State of the XBMC application (ON if connected, OFF is XBMC unavailable)
GUI.ShowNotification | >         | Show a notification in the XBMC UI
Application.Volume   | =         | Show and adjust the volume in the XBMC application
PVR.OpenTV       | >         | Open a PVR TV Channel by name for playback
PVR.OpenRadio       | >         | Open a PVR Radio Channel for playback
Screensaver.State    | <         | Current screensaver state: (ON if screensaver active)

Incoming properties that are not part of any XBMC notification, will be refreshed with each refresh interval of the binding (default 60 seconds). Currently this applies to the 'Player.Label' and 'Player.Title'  properties. 

## Example use case

As can be seen in the introduction video, i have a dimmable lamp next to my tv. I use this to light up the room after sunset when i press pause and go back to the previous level on resume, unless the lamp state has been altered while on pause.
This is of course an example very specific to my preferences, but should give you an idea on what can be done.

    import org.openhab.core.library.types.*
    import org.openhab.core.persistence.*
    import org.openhab.model.script.actions.*
    import java.util.Date

    var Number brightnessBeforePause

    rule "Lights on when paused"
    when
            Item LivingRoom_XBMC changed from Play to Pause
    then
            var Date sunsetTime = (G_SUNSET_V.state as DateTimeType).calendar.time
            var Date sunriseTime = (G_SUNRISE_V.state as DateTimeType).calendar.time
            if( now.toDate().after(sunsetTime) || now.toDate().before(sunriseTime)){
                    brightnessBeforePause = LivingRoom_Lamp.state as DecimalType
                    if ( brightnessBeforePause < 50){
                            sendCommand( LivingRoom_Lamp, "50")     
                    }
            }
    end

    rule "Lights off when pause end"
    when
            Item LivingRoom_XBMC changed from Pause to Play
    then
            if (LivingRoom_Lamp.state == 50){               
                    sendCommand( LivingRoom_Lamp, brightnessBeforePause)
            }
    end

## XBMC Binding combined with Wake-On-LAN and Network Health Bindings

The following configuration can be used to power on your XBMC machine using the Wake-On-LAN Binding and power it off using the XBMC Binding. The Network Health binding updates the state after some time if XBMC was powered on or off without using openHAB. You have to insert your own IP and MAC address of course.

    Switch XBMC_Power "XBMC Power" {xbmc=">[#openelec|System.Shutdown]", wol="192.168.1.0#xx:xx:xx:xx:xx:xx", nh="openelec:80"}

## Example of using the Player.Open option

To use the Player.Open command, you would need to define a String item with this binding, then send an Update to this String item. This will cause Openhab to send the Player.Open command to the specified XBMC instance:

### Items

    String XBMC_OpenMedia    "XBMC Player file [%s]"  { xbmc=">[#woonkamer|Player.Open]" }
    Switch XBMC_Radio        "XBMC Start Radio"       

### Rules

    rule "Start Radio"
    when
        Item XBMC_Radio changed to ON
    then
        postUpdate(XBMC_Radio, OFF)
        sendCommand(XBMC_OpenMedia, "http://icecast.omroep.nl/3fm-bb-mp3")
    end

This will introduce a Switch item with an associated rule that will send the Player.Open command when the switch is pressed. 

## Example of using the Application.Volume option

### Item

    Dimmer XBMC_Volume "XBMC Volume [%.1f]" (XBMC) { xbmc="=[#woonkamer|Application.Volume]" }

### Sitemap

    Slider item=XBMC_Volume step=10

## Example of Screensaver.State

### Item

    Switch LG_Screensaver "XBMC Screensaver Living Room" {xbmc="<[#woonkamer|Screensaver.State]"}

### Rule

    rule "turn tv on or off"
	when
		Item LG_Screensaver  changed
	then
		if(LG_Screensaver.state == ON)
		{
			logInfo("screensaver", "turn tv OFF")
			sendCommand(TV_Power,OFF)
                } else{
			logInfo("screensaver", "turn tv ON")
			sendCommand(TV_Power,ON)
		}
    end

## Example of PVR.OpenTV

### Item

    String LG_OpenTVChannel    "Open TV Channel [%s]"  { xbmc=">[#woonkamer|PVR.OpenTV]" }

### rule

    rule "Voice Command open tv channel"
     when
        Item VoiceCommand received command
     then
        sendCommand(LG_OpenTVChannel,VoiceCommand.state.toString)
    end