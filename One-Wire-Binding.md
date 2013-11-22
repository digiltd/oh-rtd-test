# Documentation of the OneWire binding Bundle

# Introduction

The OneWire bus system is a lightweight and cheap bus system mostly used for sensors like, temperature, humidity and presence but there are also switches available. The binding is designed to work as client of the [ow-server](http://owfs.org/index.php?page=owserver_protocol) which implements the [owserver-protocol](http://owfs.org/index.php?page=owserver-protocol). The OneWire devices could be connected to the machine running ow-server by a [USB-Adapter](http://shop.wiregate.de/wiregate/usb-produkte/ds9490r-1-wire-usb-adapter.html). For detailed information on OneWire please refer to http://en.wikipedia.org/wiki/One_wire or http://owfs.org.

For installation of the binding, please see Wiki page [[Bindings]].

# Configuration

If your 1-Wire Bus System is physically connected to your server and working properely please follow the steps:

1. Install and configure the ow-server and ow-shell packages on your 1-wire server
1. Copy the binding (e.g. openhab.binding.onewire-1.1.0.jar in the openhab/addons folder
1. Edit the relevant section in the openhab configuration file (openhab/configurations/openhab.cfg). If you are running the 1-wire server on the same machine please insert the local ip adress of the server (127.0.0.1) and not localhost in the line onewire:ip. In this case on every onewire update you will have an file system access to the /etc/hosts file.

# Generic Item Binding Configuration

In order to bind an item to a OneWire device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the OneWire binding configuration string is explained here:

    onewire="<sensorId>#<unitId>"

Here are some examples of valid binding configuration strings:

    onewire="26.AF9C32000000#temperature"
    onewire="26.AF9C32000000#humidity"


As a result, your lines in the items file might look like the following:

    Number Temperature_FF_Office 	"Temperature [%.1f ¬∞C]"	<temperature>	(FF_Office)		{ onewire="26.AF9C32000000#temperature" }

# Known Limitations

The OneWire binding currently accepts only items of type Number which is good enough for temperature and humidity sensors. But for other sensors (e.g. Door contact) it would be good to support Contact items as well. Though you can use Number items with door contacts as well but you have to convert the resulting '0' to CLOSED and the '1' to OPEN with the help of rules.

# Roadmap & wishlist

- make one wire writeable for switch support (e.g. DS2408 1-Wire 8-Channel Addressable Switch)
- non number support
- presence information for iButton support
- 1-wire communication e.g. via [GPIO](http://en.wikipedia.org/wiki/GPIO) to support devices connected to a Raspberry PI.