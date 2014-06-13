# Introduction

The jointSpace binding lets you control your Philips TV that is compatible with the [jointSPACE JSON API](http://jointspace.sourceforge.net/projectdata/documentation/jasonApi/index.html) over Ethernet. 

It allows you to: 
* Send Button commands
* Set and Read Volume/Mute
* Set and Get Colors of Ambilight "Pixels"
* Set and Read Source

# Prerequisites
## Compatibility and Activation jointSPACE API
1. The TV has to be in the network and turned on
2. The TV has to be compatible with the API. This should be possible for all models since 2011, but a list of models and firmwares can be found [here](http://jointspace.sourceforge.net/download.html) 
3. If the TV is compatible and the newest firmware is installed, the API has to be activated. Therefore, you have to input on the remote "5646877223" (which spells jointspace on the digits) while watching TV. A popup should appear saying that the activation was successful. 
4. To check it if everything works correctly, you can browse to `http://<ip-of-your-TV>:1925/1/examples/audio/volume.html`. There you should see a page allowing you to change the volume of the TV.


## Binding installation
To install the binding refer to [here](https://github.com/openhab/openhab/wiki/Bindings)
## OpenHAB Configuration



# Binding Configuration
## Remote

## Ambilight

# Known Limitations
* The TV has to be on to control it. This is a limitation as the network interface is off for the TV in standby. Thus it is not possible to turn the TV on with this Binding
* Right now only one device with jointspace capabilities is supported
* Reading ambilight color values only works for specific pixels, but not for layers

