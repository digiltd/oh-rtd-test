Documentation of the GPIO binding bundle

_**Note:** This Binding will be available in the upcoming 1.5 Release. For preliminary builds please see the [CI server at Cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/)._

## Introduction
Binding for local GPIO subsystem, currently only this exposed to user space by [Linux GPIO framework](https://www.kernel.org/doc/Documentation/gpio/sysfs.txt) is implemented. Being based on kernel implementation it's hardware agnostic and works on different boards without modification (this is on theory only, not all existing boards can be tested). The difference from other bindings dealing with GPIOs is that it works with GPIO subsystem on the board on which openHAB runs and don't require third-party programs/daemons running. The binding consists of two components: base module (org.openhab.io.gpio) which implements low-level GPIO access and provides API for high-level modules (can be used by other bindings needing to interact directly with GPIOs) and the binding itself (org.openhab.binding.gpio) which introduces hardware GPIO pins as full feature openHAB items capable of generating events or receiving commands depending of their type (input or output).

## Prerequisites
1. Linux-based OS with GPIO driver loaded (check whether exists directory `/sys/class/gpio`), usually it's compiled into the kernel for all recent boards which exposes GPIOs
2. Mounted `sysfs` pseudo file system, the mount point can be:
 * Automatically determined if `procfs` is mounted under path `/proc`, this is the default path in almost all configurations
 * Manually set in openHAB configuration file, key `gpio:sysfs`
3. Installed package for native JNA library, e.g. for debian-based OS use `apt-get install libjna-java`. Version 3.2.7 is used, it's the only available package in Debian currently. If the library isn't in system library path (which is true for most of the cases) you need to add a parameter in command line which starts openHAB and specify the path to JNA library, e.g. edit the last line in "start.sh" and append `-Djna.boot.library.path=/usr/lib/jni` right after `java`.

_NOTE: Some boards may need additional pin configuration prior using them, for example OMAP-based processors are using pin multiplexing which require changing the mode for some of the pins. Please refer to board's System Reference Manual for more information whether preliminary configuration is needed and how to do it._

## Global Binding Configuration
`gpio:sysfs` - optional directory path where `sysfs` pseudo file system is mounted. If isn't specified it will be determined automatically (if `procfs` is mounted under `/proc`).  
`gpio:debounce` - optional time interval in milliseconds in which pin interrupts for input pins will be ignored to prevent bounce effect seen mainly on buttons. Global option for all pins, can be customized per pin in item configuration. Default value if isn't specified - 0 (zero).

Examples:

    gpio:sysfs=/sys
    gpio:debounce=10

## Item Binding Configuration
Allowed item types are `Contact` and `Switch`. Type `Contact` is used for input pins, `Switch` - for output pins. The configuration string is following:

`gpio="pin:PIN_NUMBER [debounce:DEBOUNCE_INTERVAL] [activelow:yes|no]"`

Key-value pairs are separated by space, their order isn't important. Character's case is also insignificant. Key-value pair `pin` is mandatory, `debounce` and `activelow` are optional. If omitted `activelow` is set to `no`, `debounce` - to global option in openHAB configuration file (`gpio:debounce`) or 0 (zero) if neither is specified. `PIN_NUMBER` is the number of the pin as seen by the kernel. `DEBOUNCE_INTERVAL` is the time interval in milliseconds in which pin interrupts for input pins will be ignored to prevent bounce effect seen mainly on buttons. Note that underlying OS isn't real time nor the application is, so debounce implementation isn't something on which you can rely on 100%, you may need to experiment with this value. When `activelow` is set to `no` (or omitted) the pins behaves normally: output pins will be set `high` on `ON` command and `low` on `OFF`, input pins will generate `OPEN` event when they are `high` and `CLOSED` when are `low`. However, if `activelow` is set to `yes` the logic is inverted: when `ON` command is sent to output pin it will be set to `low`, on `OFF` command - to `high`. Input pins will generate `OPEN` event when they are `low` and `CLOSED` event on `high`.

Examples:

    Switch LED "LED" { gpio="pin:1" }
    Switch NormallyClosedRelay "Normally Closed Relay" { gpio="pin:2 activelow:yes" }
    Contact NormallyOpenPushButton "Normally Open Push Button" { gpio="pin:3 debounce:10" }
    Contact PIR "PIR" { gpio="pin:4 activelow:yes" }
    Contact NormallyClosedPushButton "Normally Closed Push Button" { gpio="pin:5 debounce:10 activelow:yes" }