## Introduction

This binding supports multiple clients connected to a [Plex Media Server](http://plex.tv). With this binding it's possible to dim your lights when a video starts playing for example. Here's a [short demo video](https://www.youtube.com/watch?v=igAUFCZ-zXc).

## Configuration

```
# IP address of the Plex server
plex:host=192.168.1.15

# Optional, port that the Plex server is running on. Default = 32400
plex:port=32400

# Refresh interval in ms. Default = 5000. 
plex:refresh=5000

```
Most changes are pushed to the binding using web sockets. Polling (and the corresponding refresh interval) is only applicable to the online/offline status of clients.

Make sure 'Require authentication on local networks' is **disabled** on your Plex server. This setting can be found in Plex Web at Settings, Server, Connect, Show Advanced. 

## Items

All items use the following format:

```
{plex="<client-id>#<property>"}
```
A Plex server can have multiple clients. You'll have to find the client ID of your Plex client yourself. This can be found by signing into [plex.tv](https://plex.tv/users/sign_in) and then visiting [https://plex.tv/devices.xml](https://plex.tv/devices.xml). It's listed as Device -> clientIdentifier here. 

Alternatively, you can lookup the client ID on your local server:
- Client list: `http://<plex server ip>:<port>/clients` (Server -> machineIdentifier) 
- Sessions list: `http://<plex server ip>:<port>/status/sessions` (Player -> machineIdentifier)

You may need to start a video in your client first before it shows up in one of those local server URL's. 

The following properties are available: 

| Property | Type | Description | 
| :------------- |:-------------| :-----|
|  power | Switch | Power status of the player (online or offline) |
|  state | String | Status of player, values: Stopped, Buffering, Playing, Paused |
|  title | String | Title of the media playing |
|  type | String | Media type, values: movie, episode and [more](https://code.google.com/p/plex-api/wiki/MediaTypes) |
|  playback/progress | Dimmer | Progress of the media playing  |
|  playback/volume | Dimmer | Volume (increase/decrease or decimaltype) |
|  playback/pause | Switch | Pause |
|  playback/play | Switch | Play |
|  playback/stop | Switch | Stop |
|  navigation/select | Switch | Select |
|  navigation/back | Switch | Back |
|  navigation/moveUp | Switch | Up |
|  navigation/moveDown | Switch | Down |
|  navigation/moveLeft | Switch | Left |
|  navigation/moveRight | Switch | Right |
|  playback/stepForward | Switch | Skip forward |
|  playback/stepBack | Switch | Skip reverse |

Note: not all Plex clients support all properties. Status properties work on all platforms, except for the power property in the web client. Navigation commands are not support by the Android nor the web client. 

## Examples

Items:

```
Switch PlexTVPower		"Power"         <video>		{plex="playerid#power"}
String PlexTVStatus		"Status [%s]"	<video>		{plex="playerid#state"}
String PlexTVTitle		"Title [%s]"	<video>		{plex="playerid#title"}
String PlexTVType		"Type [%s]"		<video>		{plex="playerid#type"}

Dimmer PlexTVProgress   "Progress [%.1f%%]"    <video>    {plex="playerid#playback/progress"}
Dimmer PlexTVVolume		"Volume"		<video>		{plex="playerid#playback/volume"}
Switch PlexTVPause		"Pause"			<video>		{plex="playerid#playback/pause"}
Switch PlexTVPlay		"Play"			<video>		{plex="playerid#playback/play"}
Switch PlexTVStop		"Stop"			<video>		{plex="playerid#playback/stop"}

Switch PlexTVSelect		"Select"		<video>		{plex="playerid#navigation/select"}
Switch PlexTVBack		"Back"			<video>		{plex="playerid#navigation/back"}
Switch PlexTVUp			"Up"			<video>		{plex="playerid#navigation/moveUp"}
Switch PlexTVDown		"Down"			<video>		{plex="playerid#navigation/moveDown"}
Switch PlexTVLeft		"Left"			<video>		{plex="playerid#navigation/moveLeft"}
Switch PlexTVRight		"Right"			<video>		{plex="playerid#navigation/moveRight"}

Switch PlexTVForward	"Forward"		<video>		{plex="playerid#playback/stepForward"}
Switch PlexTVReverse	"Reverse"		<video>		{plex="playerid#playback/stepBack"}
```

Sitemap:

```
sitemap demo label="Main Menu"
{
	Frame {
		Switch item=PlexTVPower
		Text item=PlexTVStatus
        Slider item=PlexTVProgress visibility=[PlexTVStatus!="Stopped"] 
		Setpoint item=PlexTVProgress visibility=[PlexTVStatus!="Stopped"] minValue=0 maxValue=100 step=1
		Text item=PlexTVTitle visibility=[PlexTVStatus!="Stopped"]
		Text item=PlexTVType visibility=[PlexTVStatus!="Stopped"]
		Switch item=PlexTVPause
		Switch item=PlexTVPlay
		Switch item=PlexTVStop mappings=[ON="Stop"]
		Slider item=PlexTVVolume
		
		Switch item=PlexTVSelect mappings=[ON="Select"]
		Switch item=PlexTVBack mappings=[ON="Back"]
		Switch item=PlexTVUp mappings=[ON="⬆"]
		Switch item=PlexTVDown mappings=[ON="⬇"]
		Switch item=PlexTVLeft mappings=[ON="⬅"]
		Switch item=PlexTVRight mappings=[ON="➡"]
		
		Switch item=PlexTVForward mappings=[ON="⤏"]
		Switch item=PlexTVReverse mappings=[ON="⤎"]
	}
}
```

Rules:

```
import org.eclipse.xtext.xbase.lib.*

val Functions$Function1 dimLiving = [ int dimlevel | 
	var boolean scene = (Scene_Living.state == 11); 
	
	 // Only dim lights when a certain scene is selected
    if(scene) {
		sendCommand(Lamp_Living_Small, dimlevel)
		sendCommand(Lamp_Living_Floor, dimlevel)
	}
]

rule "Lights on when paused or stopped"
when
    Item PlexTVStatus changed to Paused or 
    Item PlexTVStatus changed to Stopped
then 
	logInfo("PlexLight", "Play to pause")
	dimLiving.apply(80)
end

rule "Lights dimmed when playing"
when
	Item PlexTVStatus changed to Playing  
then
	logInfo("PlexLight", "Pause to play")	
	dimLiving.apply(30)
end
```