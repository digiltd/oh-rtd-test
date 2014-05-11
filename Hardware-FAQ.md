FAQ about hardware to run the openHAB runtime

## Introduction

This page summarizes how to get openHAB running on specific hardware.
Users are welcome to provide tips & tricks here, e.g. on JVM experiences, embedded systems etc.

Please note: This page is NOT about home automation sensors, switches, etc. For a list of the systems openHAB can connect to, please see [available bindings](Bindings).

## General Hardware Platform Requirements

The openHAB Runtime is a Java application. It requires JVM 1.6 or later.

openHAB is expected to run on all platforms (i.e. processor architectures and operating systems) where the required JVM version is available. This includes Windows, Mac OS X, and various distributions of Linux on x86, x86_64, and ARM architectures.

openHAB can be installed and operated on AMD or Intel powered commodity laptop, a desktop computer, or a special form factor platform, such as ARM based single-board computers. 

Below are configuration notes for specialized hardware.


## ARM-based Single-Board Computers (SBC)

ARM-based embedded computers are a popular choice among home automation enthusiasts due to low cost and low power consumption. They are typically extensible with available add-on components and via programmable GPIO.
Based on the community feedback and information about the openHAB requirements here is the short comparison of the SBC platforms:
![SBC comparison (as per April 2014)](http://www.pi-studio.eu/wp-content/uploads/2014/04/SBC_comparison_2014_04_v2.png)
(April 2014)
[(click here for bigger picture)](http://www.pi-studio.eu/wp-content/uploads/2014/04/SBC_comparison_2014_04_v2.png).


### Raspberry Pi
![Raspberry Pi interfaces](http://www.raspberrypi.org/wp-content/uploads/2014/03/raspberry-pi-model-b-300x199.jpg)

Raspberry Pi Model B has an attractive price/performance point and is a proven choice for small to medium residential installations. Large installations with few dozens of devices and/or a significant amount of rule logic may experience sluggish event processing and delayed response to control commands.


#### Java Installation

Raspberry Pi has FPU coprocessor supported by Raspbian Wheezy Linux. According to [this press release](http://www.raspberrypi.org/archives/4920), the current and all future Raspbian images will ship with *hard-float* Oracle Java 7 by default.

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

### CubieBoard, ODroid

![Single-Board Computers](http://www.pi-studio.eu/wp-content/uploads/2014/04/SBC_platforms_2014_04_14.jpg)

**1. Install Linux distro**

On a separate system download:

* For CubieBoard2:  The CubieBoard2 or CubieTruck works very well with OpenHAB for relatively large installations.  The following Linux distros work with OpenHAB
[Cubiuntu - Lubuntu](http://dl.cubieboard.org/cubiuntux/cubiuntu/cubiuntu_cb2_1.001_3308067698bcd2d5246071da85547d77.img.zip
) or 
[Cubian - Debian](http://cubian.org/downloads/)

* For ODroid U3: Use Xubuntu
(http://com.odroid.com/sigong/nf_file_board/nfile_board.php)

**2. Install Java Hard Floating point** 
Download Java JRE for ARMHF from Oracle if it is not already present.  

**3. Install and setup OpenHAB**   Use apt-get as described below
(https://github.com/openhab/openhab/wiki/Apt-Repository)

**4. Use symlinks if you use more than one USB port. **  Create or add to existing file (/etc/udev/rules.d/50-usb-serial.rules) a rule like the following:

SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK+="zwaveUSB", MODE="0666"

to get  IdVendor and IdProduct,  you need type in the following:
   "sudo udevadm info -q all -n /dev/ttyUSB0"

There you can find the "ID_VENDOR_ID", "ID_MODEL_ID" . Replace these IDs in the rule and save the file. Now your stick can be referenced in OpenHab config  as "/dev/zwaveUSB".  You will also need to add the property to the Java command line by adding the following (device names delimited by ":" ) to the file /etc/init.d/openhab in the JAVA_ARGS section with your device names substituted.

-Dgnu.io.rxtx.SerialPorts=/dev/rfxcomUSB:/dev/zwaveUSB


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