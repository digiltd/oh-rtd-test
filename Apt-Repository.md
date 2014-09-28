_**This Page is being merged into Quicksetup->Linux and Hardware currently. It will be gone soon.**_

***

## Prerequisites
### Raspberry Pi
#### Java 7
    sudo apt-get update && sudo apt-get install oracle-java7-jdk
    sudo update-java-alternatives -s jdk-7-oracle-armhf
#### Java 8
    sudo apt-get install oracle-java8-jdk
    sudo update-java-alternatives -s jdk-8-oracle-arm-vfp-hflt
### BeagleBone Black
TBD
### Ubuntu / Debian
Install a java 7 runtime.

### Remarks
The runtime installation is tweaked to use separate folders for configuration, the software, log files
 and runtime generated files. Therefore your feedback will be very welcome, especially if you run into problems.

Then continue with the [installation (linux)](https://github.com/openhab/openhab/wiki/Linux---OS-X) and [configuration](https://github.com/openhab/openhab/wiki/Configuring-the-openHAB-runtime). 