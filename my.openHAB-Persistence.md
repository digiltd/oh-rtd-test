You can persist your events and data in my.openHAB cloud. 

First signup at [my.openhab.org](http://my.openhab.org) and follow the docs to install and setup.

Then configure a my.openHAB persistence a `myopenhab.persist` file, defining the policy to store your data.

You will then be able to see all items status changes in your event log and current item state in items section.

Example (for all items):

    Strategies {
        default = everyChange
    }
    Items {
        * : strategy = everyChange
    }

**The example above will persist all your data, with every change, to my.openHAB cloud.**

Currently (21 Sept 2015) there is no method to remove data or items from the my.openHAB cloud.

(Though there are plans to add the option [https://community.openhab.org/t/cleaning-up-demo-items-from-myopenhab/1689](https://community.openhab.org/t/cleaning-up-demo-items-from-myopenhab/1689))

This means if you change the name of an item, the old "item" will still appear on my.openHAB cloud and also appear in your IFTTT dropdown. Also, if you set up my.openHAB with the demo configuration still setup, all of those items will also appear.

If you have a PIR or any type of sensor that sends constant updates to OpenHAB then those will also appear, and you probably don't need or want the thousands of updates logged to my.openHAB

People starting out should be aware of this due to the immense experimenting and testing that comes with learning OpenHAB. You will quickly find that the item list will contain a whole load of items that you no longer need.

### Selectively adding specific items to my.openHAB

Create a group to identify your items 

    Group    gMyOpenHAB

Then add items you know you need to log to that group. This will greatly help keep things under control.

e.g. Here only the on/off state of the switch is logged. There was no need to log every brightness state

    Switch Light_GF_Lounge_All    "Lounge All" (GF_Lounge, gMyOpenHAB) {milight="bridge01;6"}
    Dimmer Light_GF_Lounge_All_B  "Lounge All Brightness" (GF_Lounge) {milight="bridge01;6;brightness;27"}

Finally, configure your my.openHAB persistence file `myopenhab.persist` to only persist items in the group

````
Strategies {
    default = everyChange
}
Items {
    gMyOpenHAB* : strategy = everyChange
}
````

### IFTTT & other cloud based services

Be aware that **Sending persistence data to my.openHAB is required** if you use any data-driven cloud functions, [IFTTT](https://ifttt.com) integration for example.

Meaning, if you want to control the brightness (or any item) using the OpenHAB IFTTT Channel, be sure that the item is in the gMyOpenHAB group, or it won't appear in the dropdown on IFTTT.


[Official documentation](https://my.openhab.org/docs/persistence)