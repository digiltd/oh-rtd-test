FAQ about hardware for the openHAB runtime

## Introduction

This page summarizes helpful information on how to get openHAB working on specific hardware.
Users are very welcome to provide tips&tricks here, e.g. on JVM experiences, embedded systems etc.

Please note: This page is NOT about home automation hardware (sensors, switches, etc) - consult other websites for such questions. For a list of the systems openHAB can connect to, please see [available bindings](Bindings).

## General Hardware Platform Requirements

The openHAB Runtime is a Java application. It requires JVM 1.6 or later.

openHAB is expected to run on all platforms (i.e. processor architectures and operating systems) where the required JVM version is available. This includes Windows, Mac OS X, and various distributions of Linux on x86, x86_64, and ARM architectures.

openHAB can be installed and operated on AMD or Intel powered commodity laptop, a desktop computer, or a special form factor platform, such as a popular Raspberry PI single-board computer. 

Below are configuration notes for specialized hardware.


## ARM-based Single-Board Computers (SBC)

ARM-based embedded computers is a popular choice among home automation enthusiasts due to low cost and low power consumption. They are typically extensible with available add-on components and via programmable GPIO.
Based on the community feedback and information about the openHAB requirements here is the short comparison of the SBC platforms:
![SBC comparison (as of April 2014)](http://www.wikisolar.eu/wp-content/uploads/2014/04/SBC_comparison_2014_04.png)
(April 2014)
[(click here for bigger picture)](http://www.wikisolar.eu/wp-content/uploads/2014/04/SBC_comparison_2014_04.png).


### Raspberry Pi
![Raspberry Pi interfaces](http://www.raspberrypi.org/wp-content/uploads/2011/07/RaspiModelB.png)
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

### CubieBoard, BeagleBoneBlack, ODroid

**1. Install Linux distro**

On a separate system download:

* For CubieBoard2:
[Cubiuntu - Lubuntu](http://dl.cubieforums.com/ikeeki/IMAGES/ik/cubiuntu_0.999_sd_CT_2c968b278b54a70fa203e77d88e016b0.img.zip) - runs well with OpenHAB
[Cubian - Debian](http://cubian.org/downloads/) - runs well with OpenHAB

* For BeagleBoneBlack
_TBD_

* For ODroid
_TBD_

**2 Make ISO image on micro-SD card**
Use Win32DiskImager (or dd on Linux/OSX) to make ISO image on micro-SD card (4 GB  minimum.  UHS-1 speed recommended)

**3. Increase size of partition** 
If you have a larger card, increase the partition.  

**4. Install Java Hard Floating point** 
Download Java ARMHF from Oracle if its not already present.  

**5. Use symlinks if you use more than one USB port for bindings.**  See section on Symlinks (https://github.com/openhab/openhab/wiki/Samples-Tricks#how-to-configure-openhab-to-connect-to-device-symlinks-on-linux)

**6. Install and setup OpenHAB**   Follow instructions at Quick Setup or use apt-get as below
(https://github.com/openhab/openhab/issues/641?source=cc)


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

