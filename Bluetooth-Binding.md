Documentation of the Bluetooth Binding Bundle

## Introduction

The Bluetooth binding is used to connect openhab with a Bluetooth device. By its help you can make openhab e.g. react on bluetooth devices that get in range of your network.

The Bluetooth binding supports three different types of openhab items: Switches, Numbers and Strings.

- Switches can be bound to a certain bluetooth device address so that they are switched on if the device is in range and off otherwise.
- Number items simply determine how many devices are currently in range.
- String items are updated with a comma-separated list of device names that are in range.

It is possible to define for each bound item if only paired, unpaired or all devices should be observed.

For installation of the binding, please see Wiki page [[Bindings]].

## Generic Item Binding Configuration

In order to bind an item to a Bluetooth event you need to provide configuration settings. The easiest way to do this is to add binding information in your item file (in the folder configurations/items`). The syntax for the Bluetooth binding configuration string is as follows:


* for switch items: `bluetooth="<deviceAddress>[!]"`, where `<deviceAddress>` is the technical address of the device, e.g. `EC935BD417C5`; the optional exclamation mark defines whether the devices needs to be paired with the host or not.
* for string items: `bluetooth="[*|!|?]"`, where '`!`' denotes to only observe paired devices, '`?`' denotes to only observe unpaired devices and '`*`' accepts any device.
* for number items: `bluetooth="[*|!|?]"`, where '`!`' denotes to only observe paired devices, '`?`' denotes to only observe unpaired devices and '`*`' accepts any device.

***

* Switch items: will receive an ON / OFF update on the bus
* String items: will be sent a comma separated list of all device names
* Number items will show the number of bluetooth devices in range


If a friendly name cannot be resolved for a device, its address will be used instead as its name when listing it on a String item.


Here are some examples for valid binding configuration strings:

    bluetooth="EC935BD417C5"
    bluetooth="EC935BD417C5!"
    bluetooth="*"
    bluetooth="!"
    bluetooth="?"

As a result, your lines in the items file might look like follows:

    Switch MyMobile     	                                  { bluetooth="EC935BD417C5!" }
    String UnknownDevices    "Unknown devices in range: [%s]" { bluetooth="?" }
    Number NoOfPairedDevices "Paired devices in range: [%d]"  { bluetooth="!" }