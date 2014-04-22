Documentation of the IrTrans binding Bundle

_**Note:** This Binding will be available in the upcoming 1.5 Release. For preliminary builds please see the [CI server at Cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/)._

# Introduction

The IrTrans binding bundle is available as a separate (optional) download.
If you want to let openHAB communicate with the infrared emitter/transceiver of IrTrans (www.irtrans.de), please place this bundle in the folder `${openhab_home}/addons` and add binding information to your configuration. See the following sections on how to do this.

The IrTrans binding currently supports the Ethernet version of the IrTrans transceiver and communicates with the transceiver over a TCP connection

# Generic Item Binding Configuration

In order to bind an item to an ethernet transceiver, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the IrTrans binding configuration string is explained here:

The format of the binding configuration is simple and looks like this:

    irtrans="<direction>[<command>:<ip address>:<port>:<led>:<device>:<ircommand>], <direction>[<command>:<ip address>:<port>:<led>:<device>:<ircommand>], ..."

where `<direction>` is one of the following values:
- < - for inbound communication
- > - for outbound communication
- `*` - for either inbound or outbound communication, e.g bi-directional

where `<ip address>` is the hostname or ip address in dotted notation of the remote host

where `<led>` is the transceiver led to be used to send or receive the infrared command, and is one of the following values:
DEFAULT, INTERNAL, EXTERNAL, ALL, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT. **Note:** It is up to the user to check that the led value is valid for the device installed, e.g. not all IrTrans transceivers have the same number of led transmitters or received built-in. See the documentation of your IrTrans device

where `<device>` is the name of the device (category), as defined in one of the `.rem` files

and where,finally, `<ircommand>` is the name of the infrared command, as defined in the `.irtrans` file that goes with the `<device>`, to be sent to the transceiver when `<command>` is received. When an infrared command is received by the transceiver that matches the `<device>`:`<ircommand>`, then the Item will be updated with the `<command>` 

It is possible to define 'wildcards' for `<device>` and `<ircommand>` : if either of them are equal to `**` then respectively, any device that defines the given `<ircommand>`, or any `<ircommand>` for the given `<device>`, will 'match' and will trigger the status update of the Item. If you would put `**` for both `<device>` and `<ircommand>` then  any infrared command received by the transceiver will cause the Item to be updated.

**Note:** the IrTrans device does not communicate which `<led>` a command is received by, so that information can not be used to wildcard infrared commands received

All communication is checked against the `<direction>` field, e.g. an Item binding that has ">" will not be able to receive data from the remote host

**Note:** If the Item is of the type String, then any infrared command received by the transceiver will cause the Item to be updated with "`<device>`,`<ircommand>`". Likewise, any string passed on by the OpenHAB runtime will simply be parsed using the "`<device>`,`<ircommand>`" pattern. For such Items the `<command>` element has to be omitted in the configuration string

Here are some examples of valid binding configuration strings:

     irtrans=">[ON:192.168.0.1:3000:1:pioneer:voldown]" // send the 'voldown' infrared command of remote type 'pioneer' when ON is received
     irtrans="<[ON:192.168.0.1:3000:1:pioneer:*]" // accept any command from remote of type Pioneer, e.g. any key press on the remote
     irtrans=">[ON:192.168.0.1:3000:*:pioneer:voldown]" // send command to all leds
     irtrans="<[ON:192.168.0.1:3000:1:*:*]" // accept all infrared commands from any type of remote
     irtrans="<[192.168.0.1:3000:1:*:*]" // for String Items, take or update 'remote,command' strings that match the pattern

As a result, your lines in the items file might look like the following:
    Switch	PioneerReceiver_Vol		"Pioneer"		(AV)	{ irtrans="*[ON:192.168.0.1:3000:1:pioneer:volup], *[OFF:192.168.0.1:3000:1:pioneer:voldown]" }


# IrTrans .irtrans file format

IrTrans has a proprietary file format to describe and store infrared commands. The format is easy to comprehend and described in the IrTrans documentation. IrTrans also has software to remotely manage, configure etc IrTrans devices, but this software can also be used to 'learn' infrared commands, and consequently store those commands in `.irtrans` files

`.irtrans` are placed in the folder `${openhab.home}/configurations/irtrans`

**Note:** RAW infrared codes and CCF (Philips Pronto format) infrared codes are not supported (yet)

IrTrans `.irtrans` files look like:

    [REMOTE]
      [NAME]pioneer
    
    [TIMING]
      [0][N]4[1]8600 4184[2]600 440[3]600 1512[4]600 27528[RC]3[FL]91[FREQ]38[SB][RS]
      
    
    [COMMANDS]
      [volup][T]0[D]S101001010101101001010000101011110 
      [voldown][T]0[D]S101001010101101011010000001011110

where `[denotes the `<device>` to be used in the binding configuration and the `[COMMANDS](NAME]`)` section defines the `<ircommand>`s