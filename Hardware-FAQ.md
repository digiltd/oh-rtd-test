FAQ about hardware for the openHAB runtime

## Introduction

This page summarizes helpful information on how to get openHAB working on specific hardware.
Users are very welcome to provide tips&tricks here, e.g. on JVM experiences, embedded systems etc.

Please note: This page is NOT about home automation hardware (sensors, switches, etc) - consult other websites for such questions. For a list of the systems openHAB can connect to, please see [available bindings](Bindings).

## General Hardware Requirements

The openHAB Runtime is almost 100% pure Java, so all it requires is a JVM (>=1.6). So expect it to run on Windows, Mac and Linux likewise. As JavaSE exists also for ARM platforms, you are not constrained to x86 hardware.

Please note that openHAB has not (yet) been optimized for low-end embedded devices such as the Raspberry Pi. Still, if you are interested in using it on such hardware, you will find some tips and tricks in the next sections.



## A) Raspberry Pi

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



## B) Synology Diskstation
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



## C) Low Cost ARM Systems

**1. Install Linux distro**

On a separate system download:

* For CubieBoard2:
[Cubiuntu](http://dl.cubieboard.org/cubiuntux/cubiuntu/) - this seems to run well with OpenHAB

* For BeagleBoneBlack
_TBD_

* For ODroid
_TBD_

**2 Make ISO image on micro-SD card**
Use Win32DiskImager (or similar tool) to make ISO image on micro-SD card (4 GB absolute minimum, but 8 GB or higher recommended for Cubiuntu)

**3. Increase size of partition** 
The ISO image has a 4 GB partition.  If you have a larger card, increase the partition.  On a Linux system (not the OpenHAB system), use gparted to increase the partition.

**4. Install Java Hard Floating point** 
Place SD card in OpenHAB system and power-up the system.  
Download Java JDK from:
[JVM](http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-arm-vfp-hflt.tar.gz)

Extract this to /usr/lib/JVM

If there is a default-java link, modify it to point to 7u51:
`cd /usr/lib/JVM`
`rm default-java`
`ln -s /usr/lib/jvm/jdk1.7.0_51 default-java`

`Set JAVA Path:`
    `Edit the startup file (~/ .bashrc)`
        `Modify PATH variable in .bashrc to:`
            `PATH="$PATH":/usr/lib/JVM/jdk1.7.0_51/bin`
            `export PATH`
    `Save and close .bashrc`
    `Open new Terminal window`
        `Verify the PATH is set properly:`
        `% java -version`

**5. Verify proxy setting in Firefox.**  Launch Firefox and go to menu edit pref adv net settings and turn on auto-proxy.

**6. Use symlinks for USB ports.**  See section on Symlinks (https://github.com/openhab/openhab/wiki/Samples-Tricks#how-to-configure-openhab-to-connect-to-device-symlinks-on-linux)

**7. Install and setup OpenHAB**   Follow instructions at Quick Setup
