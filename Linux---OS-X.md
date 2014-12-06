# Content

* [Installation via **aptitude**](Linux---OS-X#aptitude)
* [**Manual installation** (alternativly - including openHAB Designer)](Linux---OS-X#manual-installation-alternative-approach)


**Note**: for Hardware specific approach please visit the [Hardware FAQ](https://github.com/openhab/openhab/wiki/Hardware-FAQ). 

# Aptitude
## Installation
### Add openHAB repo to the apt sources list 
    $ sudo nano /etc/apt/sources.list.d/openhab.list

Add the following line in the editor:
    deb http://repository-openhab.forge.cloudbees.com/release/1.6.1/apt-repo/ /

Exit with CTRL C then Y


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