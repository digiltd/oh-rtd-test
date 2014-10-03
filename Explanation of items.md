## introduction

- Items are objects that can be read from or written to in order to interact with them.

- Items can be bound to bindings i.e. for reading the status from e.g. KNX or for updating them.
  Read the wiki page for the respective binding for more help and examples.

- Items can be defined in files in folder `${openhab_home}/configurations/items`.

- All item definition files have to have the file extension `.items`

Typically items are defined using the openHAB Designer by editing the items definition files. Doing so you will have full IDE support like syntax checking, contect assist etc.

## syntax

Items are defined in the followng syntax:

    itemtype itemname ["labeltext"] [<iconname>] [(group1, group2, ...)] [{bindingconfig}]

Parts in square brackets [are optional.

**Example:**

    Number Temperature_GF_Living "Temperature [%.1f °C]" <temperature> (GF_Living) {knx="1/0/15+0/0/15"}

Above example defines a `Number` item...
- with name `Temperature_GF_Living`
- formatting its output in format `xx.y °C`
- displaying icon `temperature`
- belonging to group `GF_Living`
- bound to openHAB binding `knx` with write group address `1/0/15` and listening group address `0/0/15`

### itemtype

The following item types are currently available (alphabetical order):

<table>
  <tr><td><b>Itemname</b></td><td><b>Description</b></td><td><b>Command Types</b></td></tr>
  <tr><td>Color</td><td>Color information (RGB)</td><td>OnOff, IncreaseDecrease, Percent, HSB</td></tr>
  <tr><td>Contact</td><td>Item storing status of e.g. door/window contacts</td><td>OpenClose</td></tr>
  <tr><td>DateTime</td><td>Stores date and time</td><td></td></tr>
  <tr><td>Dimmer</td><td>Item carrying a percentage value for dimmers</td><td>OnOff, IncreaseDecrease, Percent</td></tr>
  <tr><td>Group</td><td>Item to nest other items / collect them in groups</td><td>-</td></tr>
  <tr><td>Number</td><td>Stores values in number format</td><td>Decimal</td></tr>
  <tr><td>Rollershutter</td><td>Typically used for blinds</td><td>UpDown, StopMove, Percent</td></tr>
  <tr><td>String</td><td>Stores texts</td><td>String</td></tr>
  <tr><td>Switch</td><td>Typically used for lights (on/off)</td><td>OnOff</td></tr>
</table>

  Group items can also have a summary value displayed.
  - AVG displays the average of the items in the group.
  - OR displays an OR of the group, typically used to display whether any item in a group has been set.
  - other summaries:  AND, SUM, MIN, MAX, NAND, NOR

**Example** for a group summary:

    Group:Number:AVG() itemname ["labeltext"] [<iconname>] [(group1, group2, ...)] [{bindingconfig}]
    Group:Switch:OR(ON, OFF) itemname ["labeltext"] [<iconname>] [(group1, group2, ...)] [{bindingconfig}]


### itemname

The item name is the unique name of the object which is used e.g. in the sitemap definition or rule definition files to access the specific item.

### labeltext

The label text is used on the one hand side to display a description for the specific item e.g. in the sitemap, on the other hand to format the output of number or string item types.

Formatting is done applying [standard Java formatter class syntax](http://docs.oracle.com/javase/7/docs/api/java/util/Formatter.html).

**Example:**

An item defined like
    Number MyTemp "Temperature [%.1f] °C"
would be formatted for output as:
    "Temperature 23.2 °C"

Another possibility in labeltexts is to use so-called maps for replacing the item status name by e.g. human-readable words:

**Example:**

An item defined like
    Number WindowBathroom "Window is [MAP(en.map):%s]"
would be formatted for output as:
    "Window is open"
if there is a file called **en.map** in folder configurations/transform.

These map files have to be structured as simple key/value pairs:
    0=closed
    1=opened
    UNDEFINED=unknown

See the sample map files in the source code repository online here:
https://github.com/openhab/openhab/tree/master/distribution/openhabhome/configurations/transform

### iconname

The icon name is used to reference a png image file from folder `${openhab_home}/webapps/images/`. These icons are used in the openHAB frontends.

Please use the filename (without extension) of icons in above mentioned folder.
If you append e.g. "-on" and "-off" to the file name the icon will change its appearance depending on the switch item state.
Resp. you can add "-0", "-1" etc. to the filename for number items etc. 

**Example:**

You can use two icons "present.png" and "present-off.png" (the "-on" is not even neccessary) like this:

`Switch DanHome     "Dan at home"      <present>  `

### groups

Items can be linked to specific groups by referencing these in a comma separated list embraced by round brackets.

**Example:**

An item defined like
    Number MyTemp (gTempOutside, gTemperatures)
would be member of the groups `gTempOutside` and `gTemperatures`

### bindingconfig

Items can be bound to specific openHAB bindings by adding a binding definition in curly brackets at the end of the item definition:

` { ns1="bindingconfig1", ns2="bindingconfig2", ...} `

where "nsx" is the namespace for a certain binding (e.g. "knx", "bluetooth", "serial" etc.). 

For detailed binding configutation syntax of openHAB bindings please see the openHAB [[Bindings]] configuration section.

**Example:**

    Switch Light_GF_Living_Table "Table" (GF_Living, Lights) { knx="1/0/15+0/0/15" }
    Switch Presence { bluetooth="123456ABCD" }
    Switch Doorbell "Doorbell" <bell> { serial="/dev/usb/ttyUSB0" }

## examples

The openHAB runtime comes with a [demo items file](https://github.com/openhab/openhab/blob/master/distribution/openhabhome/configurations/items/demo.items), here is a short excerpt from it:

    Group            gAll
    Group            Status                                                 (gAll)
    Group            gGF 	                                            (gAll)
    Group            gLights 	                                            (gAll)
    Group            gShutters 	                                            (gAll)
    Group            gGF_Living       "Living room" 	             <video> 	    (gGF)
    Group:Number:AVG gTemperature     "Avg. Room Temp. [%.1f °C]" <temperature> 
    
    /* Lights */
    Switch Light_GF_Living_Table     "Table" 	                               (gGF_Living, gLights)
    
    /* Rollershutters */
    Rollershutter Shutter_GF_Living  "Shutter"	                               (gGF_Living, gShutters)

    /* Indoor Temperatures */
    Number Temperature_GF_Living     "Temperature [%.1f °C]"   <temperature>   (gTemperature, gGF_Living)
    Number Temperature_GF_Kitchen    "Temperature [%.1f °C]"   <temperature>   (gTemperature, gGF_Kitchen)

Groups can be inside groups, and items can be in none, one or more groups. For example:

- `Group gGF               (All)` This statement defines the gGF group and states that it belongs to the All group.
- `Group GF_Living         "Living room"   <video>         (gGF)` This statement defines the group GF_Living, defines that the user interface will show it as  "Living room", defines the icon to be shown <video> and states that it belongs to (gGF). Notice that the gGF group belongs to the ALL group, hence GF_Living inherits that group, and it belongs to the All group too.
- `Group:Number:AVG  Temperature "Average lighting [Lux](%.1f)"  <temperature>   (Status)`: this statement means that there is a group called Temperature, which has a value calculated as an average of all its members, and its value is a float with one decimals. It will show a temperature icon and it belongs to the Status group.


For more info about other options have a look at the demo.items file and the wiki bindings pages.

Further examples for defining items can be found in our [openHAB-samples section](Samples-Item-Definitions). 

The currently implemented item types can be found in [source code](https://github.com/openhab/openhab/tree/master/bundles/core/org.openhab.core.library/src/main/java/org/openhab/core/library/types).