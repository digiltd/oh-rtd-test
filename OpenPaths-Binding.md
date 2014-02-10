Documentation of the OpenPaths binding bundle.

## Introduction

[OpenPaths](https://openpaths.cc/‎) is an app you can install on your Android or iOS device which will periodically upload your location to the OpenPaths servers. Using the OpenPaths binding openHAB will periodically request your latest location data from the OpenPaths servers and calculate your presence relative to a specified location (usually your home).

## Binding Configuration

First you will need to install the OpenPaths app on your mobile device. You will then need to sign up to the OpenPaths service. At this point you should be issued with an ACCESS_KEY and SECRET_KEY which you will need to configure the OpenPaths binding. You will also need to link your app to your new OpenPath account.

### openhab.cfg Config

You need to let the binding know exactly where 'home' is and what size the [geofence](http://en.wikipedia.org/wiki/Geo-fence) is. You can also optionally specify the refresh interval which determines how often openHAB will poll the OpenPaths servers. 

Finally, you need to add entries for each OpenPaths account you wish to track. You can track as many different OpenPaths accounts as you like, you will just need a set of entries in your openhab.cfg for each account, containing the ACCESS_KEY and SECRET_KEY from each account.

Here is an example;

    # The latitude/longitude coordinates of 'home'.
    openpaths:home.lat=xxx.xxxxx
    openpaths:home.long=xxx.xxxxx

    # Distance in metres a user must be from 'home' to be considered inside the 
    # geofence (optional, defaults to 100m). 
    openpaths:geofence=100

    # Interval in milliseconds to poll for user location (optional, defaults to 5mins).
    openpaths:refresh=300000

    # OpenPaths access/secret keys for each user.
    #openpaths:user1.accesskey=<accesskey>
    #openpaths:user1.secretkey=<secretkey>

### Item bindings

To track the location/presence of a mobile device all you need to do is add a Switch item and specify the name you entered in your openhab.cfg file (in the example above it was 'user1') for the OpenPaths account you wish to track.

    Switch  User1Presence   "User 1 @ Home"   { openpaths="user1" }
