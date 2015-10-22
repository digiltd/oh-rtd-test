# Installation Guide

# Installing the openHAB runtime

The openHAB runtime comes as a platform-independent zip file.
To install and configure it, follow these simple steps:

1. Unzip the `openhab-runtime-<version>.zip` to some directory, e.g. `C:\openhab` resp. `/opt/openhab`.
1. Create a personal configuration file by copying the file `configurations/openhab_default.cfg` to `configurations/openhab.cfg`.
1. Edit the `openhab.cfg` file according to your personal needs.
1. Launch the runtime by executing the script `start.bat` resp. `start.sh`

### Add optional bundles to your runtime

In the download sections, you will find a couple of jar-files, which are optional bundles that can be used with the openHAB runtime. Some of them have to be distributed separately due to license restrictions (e.g. the KNX binding bundle), some are only relevant for a small group of users (e.g. the Dropbox IO bundle).
To add those bundles to your runtime installation, simply copy them into the `addons` folder.

# Installing the openHAB designer

The openHAB designer comes as a platform-*dependent* zip, so choose the right one for your platform.
To install it, follow these simple steps:

1. Unzip the `openhab-designer-<platform>-<version>.zip` to some directory, e.g. `C:\openhab-designer` resp. `/opt/openhab-designer`
1. Launch it by the executable `openhab-designer.exe`
1. Select the "configurations" folder of your runtime installation in the folder dialog that is shown when selecting the "open folder" toolbar icon.