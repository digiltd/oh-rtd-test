# Content

* [Installation via **apt-get**](Linux---OS-X#aptitude)
* [**Manual installation** (alternatively - including openHAB Designer)](Linux---OS-X#manual-installation-alternative-approach)
* [Yocto Layer](Linux---OS-X#yocto-layer)
* [Via Chef](Linux---OS-X#via-chef)



**Note**: for Hardware specific approach (e.g. ARM boards like Raspberry Pi) please visit the [Hardware FAQ](https://github.com/openhab/openhab/wiki/Hardware-FAQ).

# apt-get
* Prerequisites: java 7 or newer
* The packages are not signed therefore you will get a warning.

## Installation
1. You will need to install Java if not already installed.
1. Add openHAB apt repository to the apt sources list
```
echo "deb https://dl.bintray.com/openhab/apt-repo stable main" | sudo tee -a /etc/apt/sources.list
```
1. Resynchronize the package index
```
sudo apt-get update
```
1. Install the openHAB runtime
```
sudo apt-get install openhab-runtime
```
1. Start the openHAB runtime
  1. Init based on sysVinit (e.g. Debian 7)
```
sudo /etc/init.d/openhab start
```
  1. Init based on systemd (e.g. Debian 8)
```
sudo systemctl start openhab
```
1. Start openHAB at System Startup
  1. Init based on sysVinit
```
sudo update-rc.d openhab defaults
```
  1. Init based on systemd
```
sudo systemctl daemon-reload
sudo systemctl enable openhab
```
1. Install the add-ons as you need them
```
sudo apt-get install openhab-addon-${addon-type}-${addon-name}
```
Examples:
```
apt-get install openhab-addon-binding-knx
apt-get install openhab-addon-persistence-rrd4j
apt-get install openhab-addon-io-dropbox
apt-get install openhab-addon-action-twitter
```
1. A list of all available packages can be retrieved with
```
sudo apt-cache search openhab
```

## Upgrade
Changed configuration files will be retained even on upgrades.

    $ sudo apt-get update
    $ sudo apt-get upgrade

## Configuration
In terms of configuration please visit the [configuration](https://github.com/openhab/openhab/wiki/Configuring-the-openHAB-runtime) page(s).

## Advanced Setup
### Apt Repository Distributions
1. stable

  The latest stable openHAB release will be installed.
1. testing

  The latest release candidate of openHAB will be installed.
1. unstable (not yet available)

  The latest snapshot release of openHAB will be installed.
1. version based distribution names (1.7.0, ...)

  All Releases are available as with a distribution name corresponding to the version name.
If you want to stick your installation to a specific version use one of these distribution names.
The installation will only be upgraded if you change the sources.list to another version.
Therefore "apt-get update && apt-get upgrade" can be safely used for the other linux software.

 Examples:
```
echo "deb https://dl.bintray.com/openhab/apt-repo 1.7.0 main" | sudo tee -a /etc/apt/sources.list
echo "deb https://dl.bintray.com/openhab/apt-repo 1.7.0.RC1 main" | sudo tee -a /etc/apt/sources.list
```

## Go test it!

openHAB comes with a built-in user interface. It works on all webkit-based browsers like Chrome, Safari, etc. Point your browser to `http://localhost:8080/openhab.app?sitemap=yourname` and you should be looking at your sitemap.

## Files and Directories
* service execution configuration /etc/default/openhab
* openHAB engine (including /webapps folder) is installed in /usr/share/openhab.
* configuration is located at /etc/openhab
* log files are stored in /var/log/openhab
* userdata like rrd4j or db4o databases are in /var/lib/openhab

## Snapshot builds
Not yet available.

### [Java 8 Installation for Ubuntu](http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html)

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

# Manual installation (alternative approach)
**WARNING**: this quick setup is an example for a KNX environment. You need different addons and configurations for other bindings.


## Installing the openHAB runtime

The openHAB runtime comes as a platform-independent zip file.
To install it, follow these simple steps:

1. You will need to install Java if not already installed. Go to http://java.com/ to get it. For ARM based systems and Synology Diskstation, see [Hardware FAQ](https://github.com/openhab/openhab/wiki/Hardware-FAQ) for instructions on getting Java.
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

# Via Chef

There is a chef cookbook available at [github.com/JustinAiken/openhab-cookbook](https://github.com/JustinAiken/openhab-cookbook).  It can install from the Debian packages or via source.
