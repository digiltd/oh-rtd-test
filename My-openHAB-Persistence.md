# My openHAB Persistence

You can persist your events and data in my.openHAB cloud. To do that you need to configure my.openHAB persistence a `myopenhab.persist` file, defining the policy to store your data.

Example:

    Strategies {
        default = everyChange
    }
    Items {
        * : strategy = everyChange
    }

This persist all your data, with every change, to my.openHAB cloud.

Sending persistence data to my.openHAB is needed if you use any data-driven cloud functions, [IFTTT](https://ifttt.com) integration for example.

You will alse be able to see all items status changes in your event log and current item state in items section.
 
[Official documentation](https://my.openhab.org/docs/persistence)