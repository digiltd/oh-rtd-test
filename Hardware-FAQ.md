
## Introduction

This page summarizes how to get openHAB server running on specific ARM hardware (it does not cover add-on bindings and modules).

## ARM Single-Board Computers

ARM-based computers are a popular choice due to low cost, small size, low power consumption and typically being fan-less. They are usually extensible with available add-on components and via programmable GPIO.

**ONLY use the vendor forums recommended Wifi, SD card and power supply.**  These systems have NO headroom in any of their specs and may be flaky with other devices.  A lot of power supplies don't actually deliver what they claim, so again, go with a recommended model or you will get random flakiness and reboots.  If you experience dropped or duplicated packets from a USB device (keyboard, wifi, Z-Wave), search the vendor's forums for "keyboard not working".  You may need to upgrade firmware or use specific ports and settings for the USB devices.


| System   | Cost | Cores | Ghz | Model | Gb RAM | IO  |  Primary OS  |
| -------- | ---- | ------|-----|-------| ------ | --- |----|
| ODROID C1 | $36  | 4     | 1.5 | A7    | 1.0    | GPIO | Ubuntu |
| RaspPi 2 | $36  | 4     | 0.9 | A7    | 1.0    | GPIO |Raspbian |
| BananaPi | $40  | 2     | 1.0 |       | 1.0    | GPIO SATA |Raspbian |
| BeagleBlk | $50  | 2     | 1.0 | A8    | 0.5    | GPIO | Ubuntu |
| RaspPi B | $30  | 1     | 0.7 | A5    | 0.5    | GPIO |Raspbian |



### Raspberry Pi2

![Raspberry PI 2](https://pbs.twimg.com/media/B82celWIIAAx90U.jpg:large)

* 900MHz quad-core ARM Cortex-A7 CPU 
* 1GB LPDDR2 SDRAM 
* Complete compatibility with Raspberry Pi 1

![Raspberry Pi interfaces](http://www.raspberrypi.org/wp-content/uploads/2014/03/raspberry-pi-model-b-300x199.jpg)
 A proven choice for small residential installations. 

**NOTE** There is an issue with the zwave binding on the RPi and the RPi is **NOT RECOMMENDED** if you intend on using zwave. Refer to the [[z-wave binding]] for more information


#### Installation

1. Install Raspbian Wheezy release 2014-01-07 or later. It includes Java 7 JRE that meets openHAB pre-requisite JVM requirements.

1. Install openHAB. 

Optionally, a complete JDK 7 or 8 for Linux ARM v6/v7 Hard Float ABI is available for download from Oracle or from [Apt Repository](https://github.com/openhab/openhab/wiki/Apt-Repository).

#### Tweaking Performance

Stay up to date with rpi-update (https://github.com/Hexxeh/rpi-update/)

##### Change GPU memory usage
For headless, reduce memory down to 16, this can be done by using **raspi-config**

##### Disabling TV Service
For headless, add these to /etc/rc.local:

    # Limit GPU IRQs
    fbset -xres 16 -yres 16 -vyres 16 -depth 8
    /opt/vc/bin/tvservice -o

Overclocking does not seem to have big influences



### CubieBoard, ODroid, BeagleBone Black

![Single-Board Computers](http://www.pi-studio.eu/wp-content/uploads/2014/04/SBC_platforms_2014_04_14.jpg)

These systems have considerably more power than Raspberry Pi 1 and and range from about $35 to $70 and work well with OpenHAB for relatively large installations.

**1. Install Linux distro**

Recommended Linux distros:

* **ODroid C1: $ 37 1.5 Ghz Quad Core, 1.0 Gb DDR3 RAM**  
Use Ubuntu 14.04 

* **BeagleBone Black: $ 55 1GHz Cortex-A8 0.5 Gb DDR3 RAM**  
Use Ubuntu 14.04 

* **CubieBoard2:**  The CubieBoard2 or CubieTruck   The following Linux distros work with OpenHAB
Use [Cubiuntu](http://cubiuntu.com)

**2. Install JAVA** - see [java installation](http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html)

**3. Install and setup OpenHAB**   - as described in
[[Linux---OS-X]]




### Banana Pi (bPi) $ 40

![Banana Pi](http://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Front_of_Banana_Pi.JPG/490px-Front_of_Banana_Pi.JPG)

As a variant of the original Raspberry Pi the Banana Pi is equipped with

* A dual core Allwinner A20 CPU at 1GHz
* 1 GByte RAM
* One SATA Port

There are various system images available for the bPi but for the use with openHAB I found the "classical" Raspbian quite stable. All about performance tweaking form above is applicable for the bPi too but the most important thing is the SATA Port which enables users to work around the poor I/O performance of the SD card subsystem.

The SATA connection is the key if you want to run an openhab server (also a not-so-small installation) on such board. You can switch from SD card to SATA disks like described [here](http://www.htpcguides.com/move-linux-banana-pi-sata-setup/).

#### Performance impact
The following data is taken from the monitoring of my openhab server which has about 75 items, 50 rules and 80 sitemap-items.

Without changing anything else but the mass storage from SD card (Transcend SDHC UHC-I X600) to SSD (Crucial M500) overall cpu load dropped from 2.x to about 0.8.

![CPU load](https://lh5.googleusercontent.com/LbTyD62I1Nk3jT-sa3BJ48PQiF9xxjDHyJUVuLf4gmbcX6A85fxKy-kMGLsTd1Dm7j-4AGB_atU=w1790-h805)

Key to this was the reduction of I/O wait (writing to SD card) from 25% to below 5% in cpu utilization. 

![CPU utilization](https://lh3.googleusercontent.com/iDnCNJpI8jFoCYTSWzq2mHPg4DySw8D9FWxfwedqMK5DT5Lhdp0VjWQq1V6296IKOZzc2P6Da5E=w1790-h805)

So far the combination of Banana Pi and SATA SSD can be highly recommended. 


#### Power supply of SATA devices

Be aware of power issues if you plan to use a normal (mechanical) hard disk. The bPi is only able to supply the 5V part of SATA power. Mechanical 3.5'' hard disks usually utilize 12V for the mechanical parts (disk spin motor, head control) and 5V for the electronical part. SATA SSD's and most 2.5'' HD's only use 5V and in general they do not require the 12V supply power to be present. For running an bPi with SATA SSD or 2.5'' HD the bPi-specific SATA/Power cable is sufficient in most cases.