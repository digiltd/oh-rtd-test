FAQ about hardware for the openHAB runtime

## Introduction

This page summarizes helpful information on how to get openHAB working on specific hardware.
Users are very welcome to provide tips&tricks here, e.g. on JVM experiences, embedded systems etc.

Please note: This page is NOT about home automation hardware - we expect that you either already have hardware or consult other websites for such questions; there are simply far too many different options you could possibly consider. For what systems openHAB can connect to, please see the list of [available bindings](Bindings).

## General Hardware Requirements

The openHAB Runtime is almost 100% pure Java, so all it requires is a JVM (>=1.6). So expect it to run on Windows, Mac and Linux likewise. As JavaSE exists also for ARM platforms, you are not even constrained on x86 hardware.

Please note that openHAB has not (yet) been optimized for low-end embedded devices such as the Raspberry Pi. Still, if you are interested in using it on such hardware, you will find some tipps and tricks in the next sections.

### Raspberry Pi

#### Basic Setup

There are three ways to use Java an Openhab on the Raspberry Pi

1. Soft-float Debian “wheezy”
    - The image is found at [Rasberry download site](http://www.raspberrypi.org/downloads)
    - This image is well proved, but all floating point calculations are done by software rather then using hardware (maybe slower).
    - The only way to use Oracle´s JVM 7 as a stable release (http://raspberrypi.stackexchange.com/questions/1603/how-can-i-get-and-install-oracles-java-jvm-for-raspbian)
    - Java can be downloaded at http://www.oracle.com/technetwork/java/javase/downloads/index.html
    - Use [this](http://www.savagehomeautomation.com/projects/raspberry-pi-installing-oracle-java-runtime-environment-jre.html) guide for basic setup
1. Hard-float Raspberryian
    - The image is found at [Rasberry download site](http://www.raspberrypi.org/downloads)
    - This image uses the hardware for floating point calculations (maybe faster)
    - Only a preview (beta) version of Oracle´s JVM 8 FX available
    - Use [this](http://javafx.steveonjava.com/javafx-on-raspberry-pi-3-easy-steps/) guide for basic setup
1. Soft-float "wheezy" with tmpfs
    - Very interesting version of the soft-float version. Openhab is used in a tmpfs ramdisk. This will improve performance and stability. The image is still under development.
    - The image is a ready to use image with openhab and eibd based on soft-float java version 7
    - Use [this](https://github.com/cribskip/OpenHABpi/wiki/Getting-Started) guide for setup
    - Based on you bus, set up eibd ([http://knx-user-forum.de/knx-eib-forum/20663-eibd-linknx-cometvisu-auf-raspberry-pi.html]) as connection between openhab and KNX in tunnel mode.

#### Tweaking Performance

- Stay up to date with rpi-update (https://github.com/Hexxeh/rpi-update/)
- For headless, use a memory split of 240 (e.g. run `sudo rpi-update 240`)
- For headless, add these to /etc/rc.local:
- # Limit GPU IRQs
- fbset -xres 16 -yres 16 -vyres 16 -depth 8
- /opt/vc/bin/tvservice -o
- Overclocking does not seem to have big influences

### Synology Diskstation
A package of OpenHAB 1.3.1 for [Synology Diskstations](http://www.synology.com/en-us/products/index) is stored at [OpenHAB google groups](https://groups.google.com/d/msg/openhab/lrzcZDYI3Ug/hLJF-sUUjgMJ) and on the package server [https://www.hofrichter.at/sspks](https://www.hofrichter.at/sspks/index.php?fulllist=true).  
This package can be installed in DSM via the package manager -> manual installation or by adding https://www.hofrichter.at/sspks/ as package source - there is a [tutorial on the Synology support pages](http://www.synology.com/en-us/support/tutorials/500) about how to do that.
This package is tested on DS213+ with oracle's java 7 from [PC load letter](http://pcloadletter.co.uk/2011/08/23/java-package-for-synology/).  
In the Synology package manager you can
* install
* start
* stop
* uninstall

OpenHAB.  

####Paths
OpenHAB is installed at `/var/packages/OpenHAB/target/` (which is linked to `/volume1/@appstore/OpenHAB`).  
If the directory `/volume1/public/OpenHAB/configurations` exists, this directory will be used for all OpenHAB configuration files. This should make it easier to work with the OpenHAB designer installed on your PC.

If the directory `/volume1/public/OpenHAB/addons` exists, this directory will be used for all OpenHAB addons (bindings) files.

####Ports
The UI is on port 8081, the console (via telnet) is on port 5555.  

####Kernel drivers
Some bindings (e.g. [EnOcean](https://github.com/openhab/openhab/wiki/EnOcean-Binding)) work with USB-sticks that require some kernel drivers. For qoric CPU Diskstations (e.g. DS213+) there is a short guide how to install those drivers at [Samples-Tricks](https://github.com/openhab/openhab/wiki/Samples-Tricks#enocean-binding-on-synology-ds213-kernel-driver-package).  

Have fun!