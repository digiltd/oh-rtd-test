# Content

* [Installation via **apt-get**](Linux---OS-X#aptitude)
* [**Manual installation** (alternativly - including openHAB Designer)](Linux---OS-X#manual-installation-alternative-approach)
* [Yocto Layer](Linux---OS-X#yocto-layer)


**Note**: for Hardware specific approach (e.g. ARM boards like Raspberry Pi) please visit the [Hardware FAQ](https://github.com/openhab/openhab/wiki/Hardware-FAQ). 

# apt-get
## Installation
### [Install Java 8](http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html)

```
su -
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update
apt-get purge openjdk* (to remove previously installed lower versions)
apt-get install oracle-java8-installer
exit
```

### Add openHAB repo to the apt sources list 
    $ sudo nano /etc/apt/sources.list.d/openhab.list

Add the following line in the editor:
`    deb http://repository-openhab.forge.cloudbees.com/release/1.x.y/apt-repo/ /`

Replace the x and the y by the appropriate version numbers. You can find the latest stable version at the OpenHAB [downloads page](http://www.openhab.org/downloads.html).

Exit with CTRL X then Y


### Install openHAB runtime

    $ sudo apt-get update
    $ sudo apt-get install openhab-runtime

The packages are not signed therefore you will get a warning!

### Install addons
Use *"apt-cache search openhab"* to get a list of all packages. Install the add-ons as you need them using *"apt-get install"*.

    $ sudo apt-cache search openhab
    $ sudo apt-get install openhab-addon-binding-xy

### Configuration
In terms of configuration please visit the [configuration](https://github.com/openhab/openhab/wiki/Configuring-the-openHAB-runtime) page(s). 

### Start openHAB runtime
    $ sudo /etc/init.d/openhab start
The server will run unprivileged using the account "openhab".
The deb installer adds openHAB to the system startup. 

### Go test it!

openHAB comes with a built-in user interface. It works on all webkit-based browsers like Chrome, Safari, etc. Point your browser to `http://localhost:8080/openhab.app?sitemap=yourname` and you should be looking at your sitemap. 

### Paths
- openHAB engine (including /webapps folder) is installed in /usr/share/openhab.
- Configuration is located at /etc/openhab
- log-files are stored in /var/log/openhab

## Upgrade
Changed configuration files will be retained even on upgrades!

    $ sudo apt-get update
    $ sudo apt-get upgrade

## Snapshot builds
TBD

# Manual installation (alternative approach)
**WARNING**: this quick setup is an example for a KNX environment. You need different addons and configurations for other bindings.


## Installing the openHAB runtime

The openHAB runtime comes as a platform-independent zip file.
To install it, follow these simple steps:

1. You will need to install Java if not already installed. Go to http://java.com/ to get it.  For ARM based systems and Synology Diskstation, see [Hardware FAQ](https://github.com/openhab/openhab/wiki/Hardware-FAQ) for instructions on getting Java.
1. Unzip the `openhab-runtime-<version>.zip` to where it is intended to be running from, e.g. `/opt/openhab`.  
1. Copy the bindings you have downloaded -`knx-binding-<version>.jar` and `http-binding-<version>.jar`- to the "addons" directory.
1. Create a personal configuration file `configurations/openhab.cfg` and add the appropriate configuration parameters from `configurations/openhab_default.cfg` (depending on the bindings you've copied).
 
### OPTIONAL: Installing the openHAB designer

The openHAB designer comes as a platform-*dependent* zip, so choose the right type for your platform.
To install it, follow these simple steps:

1. Unzip the `openhab-designer-<platform>-<version>.zip` to some directory, e.g. `/opt/openhab-designer`
1. Launch it by the executable `openHAB-Designer`
1. Select the "configurations" folder of your runtime installation in the folder dialog that is shown when selecting the "open folder" toolbar icon.

## Configuring the server
For please visit the [configuration](https://github.com/openhab/openhab/wiki/Configuring-the-openHAB-runtime) page(s). 


## Start the server!

1. Launch the runtime by executing the script `start.sh`

## Go test it!

openHAB comes with a built-in user interface. It works on all webkit-based browsers like Chrome, Safari, etc. Point your browser to `http://localhost:8080/openhab.app?sitemap=yourname` and you should be looking at your sitemap. 

# Yocto Layer
For people who make their own linux distribution using Yocto, there is a openHAB layer available:

https://github.com/ulfwin/meta-openhab

You can also find it through the very convenient layer search site:

http://layers.openembedded.org/layerindex/branch/master/layers/

The layer contains one recipe that install both the runtime engine and addons. Check the README for specific instructions for the layer. How to add and use a layer is not covered here (you need to know that in order use Yocto in the first place), but some explanation can be found here:

http://www.yoctoproject.org/docs/1.6/dev-manual/dev-manual.html#understanding-and-creating-layers