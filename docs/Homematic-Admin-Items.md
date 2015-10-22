# There are two admin items available to gather more information about devices in the CCU

# Introduction

For devices not supported by the homematic binding, we needed a mechanism to get all available information about them. To make it easy for the user there exist two virtual items, the admin items.


# Admin Items

There are two admin items available in the homematic binding.

## Dump unconfigured devices

This is mainly intended to give users an idea on how to configure their devices. It will print out various information about all devices that are not configured (say exist in an items file).

In future we try to print out a fully working items file line to be just copied into your file and done.

### Example

    String AdminDumpUnconfigured "something" <rollershutter> {homematic="admin=DUMP_UNCONFIGURED_DEVICES"}

### Use the Admin Items

If you are looking for a specific device info, please make sure that it does not exist in your items files.

- add a new device with with the admin item (see above)
- send the following command (e.g. through OSGI console or through XMPP) to OpenHAB:
   `openhab send AdminDumpUnconfigured list`
- Copy the information from the logfile and attach it to the new device request

## How to create a new Device Request

We need as much as possible information about a device to support it. The best starting point is of course to copy the device dump gathered with the help of the "Dump unconfigured devices" admin item.
If the device is an sensor we would like to have the log line where it prints out the new value received from it. E.g. if you have a button, please press it and copy the log line appearing. Or if it is a sensor, please wait until the sensor sends an update to the CCU, that will be written into the logfile as well.

With this information, please add a new issue of type / template device request.