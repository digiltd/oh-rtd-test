FAQ about hardware for the openHAB runtime

## Introduction

This page summarizes helpful information on how to get openHAB working on specific hardware.
Users are very welcome to provide tips&tricks here, e.g. on JVM experiences, embedded systems etc.

Please note: This page is NOT about home automation hardware (sensors, switches, etc) - consult other websites for such questions. For what systems openHAB can connect to, please see the list of [available bindings](Bindings).

## General Hardware Requirements

The openHAB Runtime is almost 100% pure Java, so all it requires is a JVM (>=1.6). So expect it to run on Windows, Mac and Linux likewise. As JavaSE exists also for ARM platforms, you are not constrained to x86 hardware.

Please note that openHAB has not (yet) been optimized for low-end embedded devices such as the Raspberry Pi. Still, if you are interested in using it on such hardware, you will find some tipps and tricks in the next sections.

### A) Raspberry Pi

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

### B) Synology Diskstation
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

### C) Low Cost ARM Systems

I'm using CubieBoard2   Its  DUAL 1 ghz core, 1 GB RAM, 4 GB NAND, 3 USB.  BeagleBoardBlack and ODroid, etc. would be similar.

**My Setup:**
Z-Wave with 3 motion sensors and 5 lights using Z-Stick2.   
Oregon Scientific using RFXCOM USB - 3 temperature sensors, wind speed, rain guage.
About 10 rules.

**Results (after 1 week):**
Cubieboard and OpenHAB are stable and pretty fast.  OpenHAB startup takes 34 seconds with my config.    Turning on a switch varies from 0 to 1 second.  Remote browser response is pretty snappy except chart which takes a few seconds. 

**How To:**
These directions are for CubieBoard2, but any of the small ARM systems will be similar.  Also, Im not an ARM expert or Lubuntu expert, but this seems to work.

** 1. Install Linux distro **

On a separate system download:

[Cubiuntu](http://dl.cubieboard.org/cubiuntux/cubiuntu/) - as of 15 Mar, this seems like the best CubieBoard2 distro, but there seem to be new ones weekly.  If you have a different ARM system you ll need to download the Linux distro from them.

Use Win32DiskImager (or similar tool) to make ISO image on micro-SD card.  

Place SD card in Cubie and power-up the system.  

** 2. Install Java Hard Floating point: **
On Cubie:

[JVM](http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-arm-vfp-hflt.tar.gz)

Extract this to /usr/lib/JVM

`Set JAVA Path:`
    `Edit the startup file (~/ .bashrc)`
        `Modify PATH variable in .bashrc to:`
            `PATH="$PATH":/usr/lib/JVM/jdk1.7.0_51/bin`
            `export PATH`
    `Save and close .bashrc`
    `Open new Terminal window`
        `Verify the PATH is set properly:`
        `% java -version`
**3. Fix proxy setting in Firefox.**  Launch Firefox and go to menu edit pref adv net settings and turn on auto-proxy.
**4. Install OpenHab -**
        Follow section, _Installing the openHAB runtime_ at http://www.openhab.org/gettingstarted.html.  
        OPTIONAL - You will probably want to install the demo as well in section _Installing the openHAB demo_

**5. If you're using Z-Wave** add z-wave devices to Z-Stick2 - otherwise you'll need to set up whatever Binding your using in Steps 5-7
        Disconnect Z-Stick from system
        Tap Z-Stick Button - light blinks slowly - only needs to be done for first device
        On each device, tap button on device _see device instructions_
        Z-Stick blinks fast then stays on solid for 3 seconds to show device is paired
**6. Connect Z-Stick to USB port** on OpenHAB system
   a. In OpenHAB.cfg - remove comment for Z-Wave binding and change port to TTYUSB0
   b. Download ADDONS folder. Copy Z-wave package to OpenHAB/addons
**7. Edit demo.items ** or yourname.items and add in all your Z-Wave devices, something like the following:
> Switch	Light_Kitchen	"Kitchen"	(Kitchen, Lights)	{ zwave="4:command=switch_binary" }
> Contact	Garage_Door	"Garage Door [MAP(en.map):%s]"	(Outdoor,Windows)	{ zwave="5:command=sensor_binary" }

**8. Start OpenHAB**
        Start Terminal and go to OpenHab Runtime folder and
        sudo ./start.sh
        Once your setup is stable, you'll want to make this part of system startup

**9. Start GUI**
        Point your browser to http://localhost:8080/openhab.app?sitemap=demo