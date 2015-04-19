harmonyhub-binding
=======================

openHAB Binding for the Logitech Harmony Hub


### Introduction

The Harmony Hub binding is used to enable communication between openHAB and a single Logitech Harmony Hub device. The API exposed by the Harmony Hub is relatively limited, but it does allow for reading the current activity as well as setting the activity and sending device commands.

### Installing
The binding is not includes in the openhab pakage, yet.  
Download can be found here: https://github.com/digitaldan/openhab/releases  
Copy the org.openhab.binding.harmonyhub-***.jar into the addon folder.

### Usage

#### Configuration

The following configuration items are required to be set in openhab.cfg:

	harmonyhub:<devId1>.host=<local ip address of your hub>
	harmonyhub:<devId1>.username=<your logitech username>
	harmonyhub:<devId1>.password=<your logitech password>
        
	harmonyhub:<devId2>.host=<local ip address of your second hub>
	harmonyhub:<devId2>.username=<your logitech username>
	harmonyhub:<devId2>.password=<your logitech password>


#### Bindings

The Harmony binding supports both outgoing and incoming item bindings of the form:

    { harmonyhub="<binding>[ <devId>.<binding> ...]" }
    
where `<binding>` can be:

##### Current activity (status)

Displays the current activity:

    String Harmony_Activity         "activity [%s]" { harmonyhub="<[<devId>.currentActivity]" }
    
##### Start activity (command)

Start the specified activity (where activity can either be the activity id or label).

	String HarmonyHubPowerOff       "powerOff"      { harmonyhub=">[<devId>.start:PowerOff]" }
	String HarmonyHubWatchTV        "watchTV"       { harmonyhub=">[<devId>.start:Watch TV]" }

##### Press button (command)

Press the specified button on the given device (where device can either be the device id or label).

	String HarmonyHubMute           "mute"          { harmonyhub=">[<devId>.press:Denon AV Receiver:Mute]" }

#### Actions

There is also a action addon available to send PuchButton or StartActivity to the hub.

### Shell

The [harmony-java-client](https://github.com/tuck182/harmony-java-client) project on GitHub provides a simple shell for querying a Harmony Hub, and can be used to retrieve the full configuration of the hub to determine ids of available activities and devices as well as device commands (buttons).

