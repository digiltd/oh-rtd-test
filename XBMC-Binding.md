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
* {direction}: < for incoming (player state, media title etc.) or > for outgoing (Send "Play/Pause" or "Stop" etc.)
* {host}: When prefixed by a '#' a named instance, otherwise hostname or ip address of your xbmc host.
* {property}: The property to bind to (more on this later)

Some examples:

    xbmc="<[#livingRoom|Player.State]"
    xbmc="<[#livingRoom|Player.Title]"

    xbmc="<[#bedroom|Player.State]"

    xbmc="<[192.168.1.6|Player.State]"
    xbmc="<[xbmc.local|Player.Title]"

### Available properties

Currently, the list of properties you can use in your binding configuration is very limited:

Property          | Direction | Description
----------------- |:---------:| ------------
Player.State      | <         | Current player state (e.g. 'Play', 'Pause' or 'Stop')
Player.Type       | <         | Currently playing type (e.g. 'movie', 'episode', 'channel', or 'unknown' for a PVR recording)
Player.Title      | <         | Currently playing title (e.g. movie name, TV episode name)
Player.ShowTitle  | <         | Currently playing show title (e.g. TV show name, empty for movies)
Player.Artist     | <         | Currently playing artist (music only)
Player.Album      | <         | Currently playing album (music only)
Player.<???>      | <         | Any other player property supported by the XBMC JSON RPC API
Player.PlayPause  | >         | Play/pause playback
Player.Stop       | >         | Stop playback
GUI.ShowNotification | >         | Show a notification in the XBMC UI

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