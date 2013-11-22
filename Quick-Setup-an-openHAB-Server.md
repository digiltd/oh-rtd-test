**WARNING**: this quick setup is an example for a KNX environment. You may need additional addons and configurations for other bindings.

## What do you need

1. You will need to install Java if not already installed. Go to http://java.com/ to get it.
1. `openhab-runtime-<version>.zip`. This is the server.
1. Any bindings you may need. For this fast setup, we need  `knx-binding-<version>.jar` and `http-binding-<version>.jar`
1. OPTIONAL: You may want to download a tool to configure the items, sitemap and so on. If so, download `openhab-designer-<your platform>-<version>.zip`. This will give you syntax validation, content-assist and more on your configuration files.

## Installing the openHAB runtime

The openHAB runtime comes as a platform-independent zip file.
To install it, follow these simple steps:

1. Unzip the `openhab-runtime-<version>.zip` to where it is intended to be running from, e.g. `C:\openhab` or `/opt/openhab`.
1. Copy the bindings you have downloaded -`knx-binding-<version>.jar` and `http-binding-<version>.jar`- to the "addons" directory.
1. Create a personal configuration file by copying the file `configurations/openhab_default.cfg` to `configurations/openhab.cfg`.
 

## OPTIONAL: Installing the openHAB designer

The openHAB designer comes as a platform-*dependent* zip, so choose the right one for your platform.
To install it, follow these simple steps:

1. Unzip the `openhab-designer-<platform>-<version>.zip` to some directory, e.g. `C:\openhab-designer` resp. `/opt/openhab-designer`
1. Launch it by the executable `openHAB-Designer.exe` (resp. `openHAB-Designer` if you are on a Mac or Linux)
1. Select the "configurations" folder of your runtime installation in the folder dialog that is shown when selecting the "open folder" toolbar icon.


## Configuring the server

The configuration files are text files that may be edited with any text editor you wish. Nevertheless, you may use the openHAB designer to edit them, and you will get info about any syntax error. Note that the expected file encoding is UTF-8.

### The openhab.cfg file

- The easiest way of configuring a KNX binding is by connecting in ROUTER mode. To do so, enable this: `knx:type=ROUTER` . If you cannot use the ROUTER mode, set it to TUNNEL, but you must then configure the IP: `knx:ip=<IP of the KNX-IP module>`

### The yourname.items file

The next thing we must do is to tell openHAB which items we have. To do so, go to the "configurations/items" directory and create a new file called thenameyouwish.items. You have a demo.items sample file to see which is the syntax of this file.

In this file we define groups and items. Groups might be into groups, and items may be into none, one or more groups. For example:

- `Group gGF               (All)` This statement defines de gGF group and states that it belongs to the All group.
- `Group GF_Living         "Living room"   <video>         (gGF)` This statement defines de group GF_Living, defines that the user interface will show it as  "Living room", defines the icon to be shown <video> and states that it belongs to (gGF). Notice that the gGF group belongs to the ALL group, hence GF_Living inherits that group, and it belongs to the All group too.
- `Group:Number:AVG                                Lighting "Average lighting [Lux](%.2f)"         <switch>        (Status)`: this statement means that there is a group called Lighting, which has a value calculated as an average of all its members, and its value is a float with two decimals. It will show a switch icon and it belongs to the Status group.

The items may include the KNX group address to use them. They might be actively read by openHAB or not. They look like this:

- `Number Lighting_Room_Sensor "Lighting in the Room [Lux](%.2f)"     <switch>        (Room,Lighting) { knx = "<0/1/1" }`: This is a sensor item. It uses the 0/1/1 group address and openHAB will ask for its value periodically because there is a "<" sign before the address. It is a number item, called Lighting_Room_Sensor, and belongs to Room and Lighting groups.
- `Switch Light_Room_Table       "Table Light"               (Room, Lights) { knx = "<0/1/10+0/1/30"}`: This is a switch item that has two addresses. openHAB may respond to events in any of them, but may actively read the first one.

For more info about other options have a look at the demo.items file.

### The yourname.sitemap

In this file we tell openHAB how we want the items to be shown in the user interface. First, create a new thenameyouwish.sitemap file in the "configurations/sitemap" directory. We might define here:

- `sitemap demo label="Main Menu"`: This will be the first line. It is mandatory and it states the name of your sitemap (demo) and the title of the main screen.
- You may find descriptions like:

    Frame label="Demo" {
                    Text label="Group Demo" icon="1stfloor" {
                            Switch item=Lights mappings=[OFF="All Off"]
                            Group item=Heating
                            Group item=Windows
                            Text item=Temperature
                    }
                    Text label="Multimedia" icon="video" {
                            Selection item=Radio_Station mappings=[0=off, 1=HR3, 2=SWR3, 3=FFH, 4=Charivari]
                            Slider item=Volume
                    }
            }

- This means that you want a frame with a visual label "Demo". Then, inside you want two elements:
- An item called Group Demo with 1stfloor icon that contains 4 items.
- The first one is the group Lights, that has a mapping. It means that when it receives a value of OFF, it might show a "All off" text.
- The second one will be the Heating group.
- etc.
- An item called Multimedia with icon video. It has two elements:
- The Radio_station item that has several mappings
- The Volume item, shown as an Slider.

For more info about other options have a look at the demo.sitemap file.

NOTE: Items and sitemap may be changed in runtime as needed.

## Start the server!

1. Launch the runtime by executing the script `start.bat` or `start.sh`

## Go test it!

openHAB comes with a built-in user interface. It works on most browsers like Firefox, Chrome, Safari, etc. Point your browser to http://localhost:8080/openhab.app?sitemap=demo and you should be looking at your sitemap.