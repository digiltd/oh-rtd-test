This Page will show how to setup openHab runtime on a Windows server.

In terms of configuration please visit the configuration page(s). 

# Please help placing this page in the correct location.
# It should be a sub page of quick setup. 

***
## What you need

1. You will need to install Java if not already installed. Go to http://java.com/ to get it.  
1. `openhab-runtime-<version>.zip`. This is the server. It can be found [here](http://www.openhab.org/downloads.html) like everything else follwing (Addons, Designer, ...).
1. Any bindings you want to use. Jar Files 
1. OPTIONAL: You may want to download a tool to configure the items, sitemap and so on. If you do, download `openhab-designer-<your platform>-<version>.zip`. This will give you syntax validation, content-assist and more on your configuration files.

## Installing the openHAB runtime

The openHAB runtime comes as a platform-independent zip file.
To install it, follow these simple steps:

1. Unzip the `openhab-runtime-<version>.zip` to where it is intended to be running from, e.g. `C:\openhab`.  Note that there can't be a space in the path, so it can't be in program files in windows.
1. Copy the bindings you have downloaded `*.jar` to the "addons" directory.
1. Create a personal configuration file by copying the file `configurations/openhab_default.cfg` to `configurations/openhab.cfg`.
 
## OPTIONAL: Installing the openHAB designer

The openHAB designer comes as a platform-*dependent* zip, so choose the right type for your platform.
To install it, follow these simple steps:

1. Unzip the `openhab-designer-<platform>-<version>.zip` to some directory, e.g. `C:\openhab-designer`.
1. Launch it by the executable `openHAB-Designer.exe` 
1. Select the "configurations" folder of your runtime installation in the folder dialog that is shown when selecting the "open folder" toolbar icon.