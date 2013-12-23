Documentation of the Milight binding bundle

## Introduction
[![openHAB Milight](http://img.youtube.com/vi/zNe9AkQbfmc/0.jpg)](http://www.youtube.com/watch?v=zNe9AkQbfmc)<br/>
The openHAB Milight binding allows to send commands to multiple Milight bridges.
For installation of the binding, please see Wiki page [[Bindings]].

## Milight Binding Configuration in openhab.cfg

First of all you need to introduce your Milight bridge(s) in the openhab.cfg file (in the folder '${openhab_home}/configurations')

### Example

    ################################ Milight Binding #################################
    
    # Host of the first Milight bridge to control 
    # milight:<MilightId1>.host=
    # Port of the bridge to control (optional, defaults to 50000)
    # milight:<MilightId1>.port=
    #
    # Host of the second Milight bridge to control 
    # milight:<MilightId2>.host=
    # Port of the bridge to control (optional, defaults to 50000)
    # milight:<MilightId2>.port=

The `milight:<MilightId1>.host` value is the ip address of the Milight bridge.

The `milight:<MilightId1>.port` value is UDP port address of the Milight bridge. Port value is an optional parameter but has to be changed for the V3.0 version of milight bridge.

Examples, how to configure your receiver device:

    milight:bridge1.host=192.168.1.100
    milight:bridge1.port=50000

## Item Binding Configuration

In order to bind an item to the device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax of the binding configuration strings accepted is the following:

    milight="<deviceId>;<channelNumber>;<commandType>"
where `<commandType>` is optional for switch items, unless you want to use commandType nightMode or whiteMode.

The device-id corresponds to the bridge which is defined in openhab.cfg.

The channelNumber corresponds to the bulbs/channels on your bridge, where 0 reflects all white bulbs, 1-4 white bulb channels 1-4 and 5 all rgb bulbs.

With upcoming version 1.4.0 of openHAB, milight binding supports the new API V3.0 and the RGBW bulbs.
channelNumber 6 controlls all RGBW bulbs, channelNumber 7 to 10 controlls the channels individually.

The deviceCommand corresponds to the way you want to control your Milight bulbs.

These are valid command types for white bulbs:
    brightness		controls the brightness of your bulbs
    colorTemperature	changes from cold white to warm white and vice versa
    nightMode		dimms your bulbs to a very low level to use them as a night light

And these are the command types for rgb bulbs:
    rgb			changes the color and brightness of your rgb bulbs
    discoMode		changes the discoMode for rgb bulbs
    discoSpeed		changes the speed of your chosen discoMode

The following command type will be available with version 1.4.0 :
    whiteMode           sets RGBW bulbs to white mode

Limitations:
The rgb bulbs do not support changing their saturation, so the colorpicker will only set the hue and brightness of it.

Examples, how to configure your items in your items file:

    Switch Light_Groundfloor 	{milight="bridge1;0"}			#Switch for all white bulbs on bridge1
    Switch Light_GroundfloorN	{milight="bridge1;0;nightMode"}		# Activate the NightMode for all bulbs on bridge1
    Dimmer Light_LivingroomB 	{milight="bridge1;1;brightness"}	#Dimmer changing brightness for bulb1 on bridge1
    Dimmer Light_LivingroomC 	{milight="bridge1;1;colorTemperature"}	#Dimmer changing colorTemperature for bulb1 on bridge1
    Color Light_Party		{milight="bridge2;5;rgb"}		#Colorpicker for rgb bulbs at bridge2

The command types discoMode and discoSpeed should be configured as pushbuttons as they only support INCREASE and DECREASE commands:

items:

    Dimmer DiscoMode		{milight="bridge1;5;discoMode"}
    Dimmer DiscoSpeed		{milight="bridge1;5;discoSpeed"}
    
sitemap:

    Switch item=DiscoMode mappings=[DECREASE='-', INCREASE='+']
    Switch item=DiscoSpeed mappings=[DECREASE='-', INCREASE='+']

Disco Mode for RGBW bulbs can only be stepped in one direction, so please use INCREASE command only for those with openHAB version 1.4.0.