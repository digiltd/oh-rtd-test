# FAQ about hardware for the openHAB runtime

# Introduction

This page summarizes helpful information on how to get openHAB working on specific hardware.
Users are very welcome to provide tips&tricks here, e.g. on JVM experiences, embedded systems etc.

Please note: This page is NOT about home automation hardware - we expect that you either already have hardware or consult other websites for such questions; there are simply far too many different options you could possibly consider. For what systems openHAB can connect to, please see the list of [available bindings](Bindings).

## General Hardware Requirements

The openHAB Runtime is almost 100% pure Java, so all it requires is a JVM (>=1.6). So expect it to run on Windows, Mac and Linux likewise. As JavaSE exists also for ARM platforms, you are not even constrained on x86 hardware.

Please note that openHAB has not (yet) been optimized for low-end embedded devices such as the Raspberry Pi. Still, if you are interested in using it on such hardware, you will find some tipps and tricks in the next sections.

## Raspberry Pi

### Basic Setup

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
- Very intresting version of the soft-float version. Openhab is used in a tmpfs ramdisk. This will improve performance and stability. The image is still under development.
- The image is a ready to use image with openhab and eibd based on soft-float java version 7
- Use [this](https://github.com/cribskip/OpenHABpi/wiki/Getting-Started) guide for setup
- Based on you bus, set up eibd ([http://knx-user-forum.de/knx-eib-forum/20663-eibd-linknx-cometvisu-auf-raspberry-pi.html]) as connection between openhab and KNX in tunnel mode.

### Tweaking Performance

- Stay up to date with rpi-update (https://github.com/Hexxeh/rpi-update/)
- For headless, use a memory split of 240 (e.g. run `sudo rpi-update 240`)
- For headless, add these to /etc/rc.local:
- # Limit GPU IRQs
- fbset -xres 16 -yres 16 -vyres 16 -depth 8
- /opt/vc/bin/tvservice -o
- Overclocking does not seem to have big influences