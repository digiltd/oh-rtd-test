**WARNING**: this quick setup is an example for a KNX environment. You need different addons and configurations for other bindings.

## What you need

1. You will need to install Java if not already installed. 
1. `openhab-runtime-<version>.zip`. This is the server. It can be found [here](http://www.openhab.org/downloads.html) like everything else follwing (Addons, Designer, ...).
1. Any bindings you may need. For this example setup, we use  `knx-binding-<version>.jar` and `http-binding-<version>.jar`
1. OPTIONAL: You may want to download a tool to configure the items, sitemap and so on. If so, download `openhab-designer-<your platform>-<version>.zip`. This will give you syntax validation, content-assist and more on your configuration files.

For detailed instruction please visit the installation page for [Linux](https://github.com/openhab/openhab/wiki/Linux---OS-X) or [Windows](https://github.com/openhab/openhab/wiki/Windows).


## Configuring the server

The configuration files are text files that may be edited with any text editor you wish. Nevertheless, you may want to use the openHAB designer to edit them, and you will get informed about any syntax error. Note that the expected file encoding is UTF-8.

### The openhab.cfg file

- The easiest way of configuring a KNX binding is by connecting in ROUTER mode. To do so, enable this: `knx:type=ROUTER` . If you cannot use the ROUTER mode, set it to TUNNEL, but you must then configure the IP: `knx:ip=<IP of the KNX-IP module>`
- further information on configuring any other binding can be found on the individual binding pages

### The yourname.items file

- The next thing we must do is to tell openHAB which items we have. To do so, go to the "configurations/items" directory and create a new file called thenameyouwish.items. You have a demo.items sample file to see the syntax of this file.

In this file we define groups and items. Groups can be inside groups, and items can be in none, one or more groups. For example:

- `Group gGF               (All)` This statement defines the gGF group and states that it belongs to the All group.
- `Group GF_Living         "Living room"   <video>         (gGF)` This statement defines the group GF_Living, defines that the user interface will show it as  "Living room", defines the icon to be shown <video> and states that it belongs to (gGF). Notice that the gGF group belongs to the ALL group, hence GF_Living inherits that group, and it belongs to the All group too.
- `Group:Number:AVG                                Lighting "Average lighting [Lux](%.2f)"         <switch>        (Status)`: this statement means that there is a group called Lighting, which has a value calculated as an average of all its members, and its value is a float with two decimals. It will show a switch icon and it belongs to the Status group.

The items may include the KNX group address to use them. They might be actively read by openHAB or not. They look like this:

- `Number Lighting_Room_Sensor "Lighting in the Room [Lux](%.2f)"  <switch> (Room,Lighting) { knx = "<0/1/1" }`: This is a sensor item. It uses the 0/1/1 group address and openHAB will ask for its value periodically because there is a "<" sign before the address. It is a number item, called Lighting_Room_Sensor, and belongs to Room and Lighting groups.
- `Switch Light_Room_Table  "Table Light" (Room, Lights) { knx = "<0/1/10+0/1/30"}`: This is a switch item that has two addresses. openHAB may responds to events in any of them, but may actively read the first one.

For more info about other options have a look at the demo.items file and the wiki bindings pages.

### The yourname.sitemap

In this file we tell openHAB how we want the items to be shown in our user interface. First, create a new thenameyouwish.sitemap file in the "configurations/sitemap" directory. For example we define here:

- `sitemap demo label="Main Menu"`: This will be the first line. It is mandatory and it states the name of your sitemap (demo) and the title of the main screen.
- You may find descriptions like:

```    
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
```
- This means that you want a frame with a visual label "Demo". Then, inside the frame you want two elements:
- An item called Group Demo with 1stfloor icon that contains 4 items.
- The first one is the group Lights, that has a mapping. It means that when it receives a value of OFF, it might show a "All off" text.
- The second one will be the Heating group.
- etc.
- An item called Multimedia with icon video. It has two elements:
- The Radio_station item that has several mappings
- The Volume item, shown as an Slider.

For more info about other options have a look at the demo.sitemap file.

NOTE: Items and sitemap may be changed during runtime as needed.

