## Installing the openHAB runtime

The openHAB runtime comes as a platform-independent zip file.
To install it, follow these simple steps:

1. You will need to install Java if not already installed. Go to http://java.com/ to get it.
1. Unzip the `openhab-runtime-<version>.zip` to where it is intended to be running from, e.g. `C:\openhab`.  Note that there can't be a space in the path, so it can't be in program files in windows.
1. Copy the bindings you have downloaded `*.jar` to the "addons" directory.
1. Create a personal configuration file `configurations/openhab.cfg` and add the appropriate configuration parameters from `configurations/openhab_default.cfg` (depending on the bindings you've copied).
 
## OPTIONAL: Installing the openHAB designer

The openHAB designer comes as a platform-*dependent* zip, so choose the right type for your platform.
To install it, follow these simple steps:

1. Unzip the `openhab-designer-<platform>-<version>.zip` to some directory, e.g. `C:\openhab-designer`.
1. Launch it by the executable `openHAB-Designer.exe` 
1. Select the "configurations" folder of your runtime installation in the folder dialog that is shown when selecting the "open folder" toolbar icon.

## Configuration
In terms of configuration please visit the [configuration](https://github.com/openhab/openhab/wiki/Configuring-the-openHAB-runtime) page(s). 

## Start the server!

1. Launch the runtime by executing the script `start.bat`

## Go test it!

openHAB comes with a built-in user interface. It works on all webkit-based browsers like Chrome, Safari, etc. Point your browser to `http://localhost:8080/openhab.app?sitemap=yourname` and you should be looking at your sitemap. 