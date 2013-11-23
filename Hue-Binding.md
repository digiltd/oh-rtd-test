## Introduction
**Video:**
<a href="http://www.youtube.com/watch?feature=player_embedded&v=Q4_LkXIRBWc" target="_blank"><img src="http://img.youtube.com/vi/Q4_LkXIRBWc/0.jpg" alt="openHAB Hue binding" width="300" height="220" border="10" /></a>

For installation of the binding, please see Wiki page [[Bindings]].

## Configuring the binding

First of all you need to configure the following values in the openhab.cfg file (in the folder '${openhab_home}/configurations'). 

    ################################ HUE Binding #########################################
    
    # IP of the Hue bridge
    hue:ip=192.168.1.28
    hue:secret=pairingKeyForOpenHABSystem

The hue:ip value is optional. If it is not provided, the binding tries to find the bridge on its own. This may not always work perfectly. The preferred way should be a defined IP.

The hue:secret value is a string that gets stored in the hue bridge when pairing it with openHAB. That way the bridge 'knows' openHAB and allows it to send commands. It is kind of a password. Be aware that it is not encrypted in the communication. You may change this value to anything you like using characters and numbers. It must be between 10 and 40 characters long.

## Pairing the Philips Hue bridge

In order to use your Philips Hue system within openHAB you need to publicize openHAB to your Philips Hue bridge. To do so you need to link the systems by pressing the connect button on the bridge when starting up openHAB. In the logs you can see when openHAB is waiting to be paired to the bridge. Look out for the following lines:

    Please press the connect button on the Hue bridge. Waiting for pairing for 100 seconds...
    Please press the connect button on the Hue bridge. Waiting for pairing for 99 seconds...
    Please press the connect button on the Hue bridge. Waiting for pairing for 98 seconds...

If you see this you should press the button on the bridge. You should see the following in the logs:

    Hue bridge successfully paired!

This procedure has only to be done once. Now you are ready to go.

## Generic Item Binding Configuration

In order to bind an item to a Philips Hue bulb, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder '${openhab_home}/configurations/items'). The syntax for the Philips Hue binding configuration string is explained in the following sections.

## Switch items

The switch item is the easiest way to control your bulbs. It enables you to turn on and off your bulbs without changing color or brightness.

    hue="<bulb number>"

The bulb number is assigned to the bulb by your Philips Hue bridge. The numbers should start with 1 and increase for every connected bulb by 1. If you have a starter kit, the first bulbs are numbered 1, 2, 3. 

Here are some examples of valid binding configuration strings for switch items:

    hue="1"
    hue="2"
    hue="3"

## Color items

The color item allows you to change color and brightness of a bulb.

    hue="<bulb number>"

The bulb number is assigned to the bulb by your Philips Hue bridge. The numbers should start with 1 and increase for every connected bulb by 1. If you have a starter kit, the first bulbs are numbered 1, 2, 3. 

Here are some examples of valid binding configuration strings for switch items:

    hue="1"
    hue="2"
    hue="3"

## Dimmer items

Dimmer items enable you to do two different things:

1. Change the brightness of a bulb without changing the color, or
1. Change the color temperature of a bulb from warm to cold.

### Brightness dimmer items

    hue="<bulb number>;brightness[;<step size>]"

where the part in `[is optional.

The step size defines how fast the dimmer changes the brightness. If no value is defined the default value of 25 is used.

Here are some examples of valid binding configuration strings for brightness dimmer items:

    hue="1;brightness"
    hue="2;brightness;20"
    hue="3;brightness;100"

### Color temperature dimmer items

    hue="<bulb number>;colorTemperature[;<step size>]"
where the part in `[](]`)` is optional.

The step size defines how fast the dimmer changes the color temperature. If no value is defined the default value of 25 is used.

Here are some examples of valid binding configuration strings for brightness dimmer items:

    hue="1;colorTemperature"
    hue="2;colorTemperature;20"
    hue="3;colorTemperature;100"

## Examples

As a result, your lines in the items file might look like the following:

    Switch Toggle_1	  "left bulb" 	(Switching)	{hue="1"}
    Switch Toggle_2	  "center bulb"	(Switching)	{hue="2"}
    Switch Toggle_3 	  "right bulb" 	(Switching)	{hue="3"}
    
    Color Color_1 	  "left bulb" 	(Colorize)	{hue="1"}
    Color Color_2         "center bulb"	(Colorize)	{hue="2"}
    Color Color_3 	  "right bulb" 	(Colorize)	{hue="3"}
    
    Dimmer Dimm_1 	  "left bulb" 	(WhiteDimmer)	{hue="1;brightness;30"}
    Dimmer Dimm_2 	  "center bulb" (WhiteDimmer)	{hue="2;brightness;30"}
    Dimmer Dimm_3 	  "right bulb" 	(WhiteDimmer)	{hue="3;brightness;30"}
    
    Dimmer CT_Dimm_1 	  "left bulb" 	(CTDimmer)	{hue="1;colorTemperature;30"}
    Dimmer CT_Dimm_2 	  "center bulb" (CTDimmer)	{hue="2;colorTemperature;30"}
    Dimmer CT_Dimm_3 	  "right bulb" 	(CTDimmer)	{hue="3;colorTemperature;30"}
    
For more information on the used API see the following link: http://developers.meethue.com/