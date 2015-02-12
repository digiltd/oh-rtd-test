FAQ about hardware to run the openHAB runtime

## Introduction

This page summarizes how to get openHAB server running on specific hardware (it does not cover add-on bindings and modules).

## General Hardware Platform Requirements

The openHAB Runtime is a Java application. It requires JVM 1.6 or later.

openHAB is expected to run on all platforms (i.e. processor architectures and operating systems) where the required JVM version is available. This includes Windows, Mac OS X, and various distributions of Linux on x86, x86_64, and ARM architectures.

openHAB can be installed and operated on AMD or Intel powered commodity laptop, a desktop computer, or  ARM based single-board computers. 

Below are configuration notes for specific hardware.

## x86 Linux

**1. Install Java**
If not already present

**2. Install and setup OpenHAB**   Use apt-get as described below
(https://github.com/openhab/openhab/wiki/Apt-Repository)

**3. Use symlinks if you use more than one USB port**  Create or add to existing file (/etc/udev/rules.d/50-usb-serial.rules) a rule like the following:

SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{product}=="RFXrec433", SYMLINK+="USBrfx", GROUP="dialout", MODE="0666"
SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK+="USBzwave", GROUP="dialout", MODE="0666"

To get  IdVendor, product, and IdProduct,  you need type in the following (for USB0, USB1, etc)
   "sudo udevadm info --attribute-walk --path=/sys/bus/usb-serial/devices/ttyUSB0"

There you can find IdVendor, product, and IdProduct. Replace these IDs in the rule and save the file. Now your stick can be referenced in OpenHab config  as "/dev/USBzwave".  You will also need to add the property to the Java command line by adding the following (device names delimited by ":" ) to the file /etc/init.d/openhab in the JAVA_ARGS section with your device names substituted.

-Dgnu.io.rxtx.SerialPorts=/dev/USBrfxcom:/dev/USBzwave



## ARM Single-Board Computers

ARM-based computers are a popular choice among home automation enthusiasts due to low cost, small size, low power consumption and typically fan-less. They are usually extensible with available add-on components and via programmable GPIO.

### Raspberry Pi

![Raspberry PI 2](https://pbs.twimg.com/media/B82celWIIAAx90U.jpg:large)

**New Version of Raspberry PI! 6 times as fast as Raspberry PI 1, same price!**

* 900MHz quad-core ARM Cortex-A7 CPU (~6x performance)
* 1GB LPDDR2 SDRAM (2x memory)
* Complete compatibility with Raspberry Pi 1

![Raspberry Pi interfaces](http://www.raspberrypi.org/wp-content/uploads/2014/03/raspberry-pi-model-b-300x199.jpg)

**Raspberry Pi Model B - $ 30 700Mhz 0.5 Gb RAM**.  A proven choice for small residential installations. Large installations with few dozens of devices and/or a significant amount of rule logic may experience sluggish event processing and delayed response to control commands.


**NOTE** There is an issue with the zwave binding on the RPi and the RPi is **NOT RECOMMENDED** if you intend on using zwave. Refer to the [[z-wave binding]] for more information


#### Java Installation

Raspberry Pi has FPU coprocessor supported by Raspbian Wheezy Linux. 

To setup your Raspberry Pi board for openHAB:

1. Install Raspbian Wheezy release 2014-01-07 or later. It includes Java 7 JRE that meets openHAB pre-requisite JVM requirements.

2. Install openHAB. 

Optionally, a complete JDK 7 or 8 for Linux ARM v6/v7 Hard Float ABI is available for download from Oracle or from [Apt Repository](https://github.com/openhab/openhab/wiki/Apt-Repository).

#### Tweaking Performance

- Stay up to date with rpi-update (https://github.com/Hexxeh/rpi-update/)
- For headless, use a memory split of 240 (e.g. run `sudo rpi-update 240`)
- For headless, add these to /etc/rc.local:
- # Limit GPU IRQs
- fbset -xres 16 -yres 16 -vyres 16 -depth 8
- /opt/vc/bin/tvservice -o
- Overclocking does not seem to have big influences

### Banana Pi

![Banana Pi](http://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Front_of_Banana_Pi.JPG/490px-Front_of_Banana_Pi.JPG)

As a variant of the original Raspberry Pi the Banana Pi is equipped with

* A dual core Allwinner A20 CPU at 1GHz
* 1 GByte RAM
* One SATA Port

The SATA Port enables users to work around the poor I/O performance of the SD card subsystem.

The SATA connection is the key if you want to run an openhab server on such board. You can switch from SD card to SATA disks like described [here](http://www.htpcguides.com/move-linux-banana-pi-sata-setup/).

#### Performance impact

Overall cpu load dropped from 2.x to about 0.8. 
Key to this was the reduction of I/O wait (writing to SD card) from 25% to below 5% in cpu utilization. 

So far the combination of Banana Pi and SATA SSD can be highly recommended. 

#### Power supply of SATA devices

Be aware of power issues if you plan to use a normal (mechanical) hard disk. The bPi is only able to supply the 5V part of SATA power. Mechanical 3.5'' hard disks usually utilize 12V for the mechanical parts (disk spin motor, head control) and 5V for the electronical part. SATA SSD's and most 2.5'' HD's only use 5V and in general they do not require the 12V supply power to be present. For running an bPi with SATA SSD or 2.5'' HD the bPi-specific SATA/Power cable is sufficient in most cases.

### CubieBoard, ODroid, BeagleBone Black

![Single-Board Computers](http://www.pi-studio.eu/wp-content/uploads/2014/04/SBC_platforms_2014_04_14.jpg)

These systems have considerably more power than Raspberry Pi 1 and and range from about $35 to $70.

**1. Install Linux distro**

Recommended Linux distros:

* **CubieBoard2:**  The CubieBoard2 or CubieTruck works very well with OpenHAB for relatively large installations.  The following Linux distros work with OpenHAB
Use [Cubiuntu](http://cubiuntu.com)

* **ODroid C1: $ 37 1.5 Ghz Quad Core, 1.0 Gb DDR3 RAM**  
Use Ubuntu 14.04 

* **BeagleBone Black: $ 55 1GHz Cortex-A8 0.5 Gb DDR3 RAM**  
Use Ubuntu 14.04 

**2. Install Java Hard Floating point** 
If not already present, use (http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html) or (http://www.oracle.com/technetwork/java/javase/downloads/jdk8-arm-downloads-2187472.html) 
It is not recommended to use any other Java than Oracle Java. Bindings may not work properly with OpenJava.

**3. Install and setup OpenHAB**   Use apt-get as described below
(https://github.com/openhab/openhab/wiki/Apt-Repository)

**4. Use symlinks if you use more than one USB port**    See symlinks under x86 Linux above.


## Synology Diskstation
A package of OpenHAB 1.4.0 for [Synology Diskstations](http://www.synology.com/en-us/products/index) is stored at [OpenHAB google groups](https://groups.google.com/d/msg/openhab/lrzcZDYI3Ug/hLJF-sUUjgMJ) and on the package server [https://www.hofrichter.at/sspks](https://www.hofrichter.at/sspks/index.php?fulllist=true).  
This package can be installed in DSM via the package manager -> manual installation or by adding https://www.hofrichter.at/sspks/ as package source - there is a [tutorial on the Synology support pages](http://www.synology.com/en-us/support/tutorials/500) about how to do that.
This package is tested on DS213+ with oracle's java 7 from [PC load letter](http://pcloadletter.co.uk/2011/08/23/java-package-for-synology/).  
In the Synology package manager you can
* install
* start
* stop
* uninstall

OpenHAB.  
This package comes without any demo files - so the UI will not show much without giving OpenHAB some configurations ;-)
It takes some time after the start of OpenHAB before the UI starts responding (less than a minute on a DS213+).

####Paths
OpenHAB is installed at `/var/packages/OpenHAB/target/` (which is linked to `/volume1/@appstore/OpenHAB`).  
If the directory `/volume1/public/OpenHAB/configurations` exists, this directory will be used for all OpenHAB configuration files. This should make it easier to work with the OpenHAB designer installed on your PC.

If the directory `/volume1/public/OpenHAB/addons` exists, this directory will be used for all OpenHAB addons (bindings) files.

####Ports
The UI is on port 8081, the console (via telnet) is on port 5555.  

####Demo files
In the [OpenHAB google groups](https://groups.google.com/d/msg/openhab/lrzcZDYI3Ug/94XD81A9TYAJ) and on the package server https://www.hofrichter.at/sspks is an install-able package of the OpenHAB 1.4.0 demo files (only the demo files!) for Synology NAS. Prerequisite is that the OpenHAB package is installed.

After the installation of OpenHAB and the demo files http://your.synology.URL:8081/openhab.app?sitemap=demo should show the UI with the demo configuration.

"Text to speech" is disabled in configurations/rules/demo.rules otherwise the demo files are unchanged. This change was necessary (at leased on a DS213+) else OpenHAB stops responding.
Give OpenHAB a minute or so after the start of OpenHAB before you expect any response in the UI ;-)
####Kernel drivers
Some bindings (e.g. [EnOcean](https://github.com/openhab/openhab/wiki/EnOcean-Binding)) work with USB-sticks that require some kernel drivers. For qoric CPU Diskstations (e.g. DS213+) there is a short guide how to install those drivers at [Samples-Tricks](https://github.com/openhab/openhab/wiki/Samples-Tricks#enocean-binding-on-synology-ds213-kernel-driver-package).  

## QNAP Turbo Station

There is a QPGK package to install openHAB v1.5 on a QNAP Turbo Station NAS.
http://forum.qnap.com/viewtopic.php?f=320&t=95315&p=423268