# Documentation of the Serial binding Bundle

# Introduction

For installation of the binding, please see Wiki page [[Bindings]].

# Generic Item Binding Configuration

In order to bind an item to a Serial device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). 

The format of the binding configuration is simple and looks like this:
    serial="<port>"
where `<port>` is the identification of the serial port on the host system, e.g. "COM1" on Windows, "/dev/ttyS0" on Linux or "/dev/tty.PL2303-0000103D" on Mac.

Switch items with this binding will receive an ON-OFF update on the bus, when ever data becomes available on the serial interface (or simply by short-cutting pins 2 and 7 on the RS-232 interface)

String items will receive the submitted data in form of a string value as a status update, while openHAB commands to a String item is sent out as data through the serial interface.

As a result, your lines in the items file might look like the following:
    Switch HardwareButton	"Bell"	           (Entrance)      { serial="/dev/ttyS0" }
    String AVR              "Surround System"  (Multimedia)    { serial="/dev/ttyS1" } 

Note: If you are working with a Mac, you might need to install a driver for your USB-RS232 converter (e.g. http://osx-pl2303.sourceforge.net/ or http://mac.softpedia.com/get/Drivers/Prolific-PL-2303.shtml) and create the /var/lock folder, see the [rxtx troubleshooting guide](http://rxtx.qbang.org/wiki/index.php/Trouble_shooting#Mac_OS_X_users).