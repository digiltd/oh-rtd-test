Documentation of the Mqttitude binding bundle.

## Introduction

[Mqttitude](http://mqttitude.org/) was developed as a replacement for the old Google Latitude service. However it is slightly different (better) in that all your location data is private - i.e. there is no 3rd party server somewhere collecting and storing your data. Instead each time your device publishes its location, it is sent to an [MQTT](http://mqtt.org/) broker of your choice. 

This is where openHAB steps in, with the Mqttitude binding. The idea is that the binding will track your location and when you are 'near' to a specified location (usually your home) it will update a Switch item in openHAB, enabling presence detection.

First you need to set up an MQTT broker (e.g. [Mosquitto](http://mosquitto.org/)) and install the Mqttitude app on your mobile devices. At this point you should start seeing location updates appearing in your broker. 

Now it is time to configure MQTT and the Mqttitude binding...

## Broker Configuration

First you will need to install and configure the [MQTT binding](https://github.com/openhab/openhab/wiki/MQTT-Binding#transport-configuration). This will define the connection properties for your MQTT broker and specify the broker id which we will need when configuring the Mqttitude item bindings.

## Binding Configuration

There are two modes of operation for the Mqttitude binding. Note: you can have item bindings which are mixture of these two modes.

#### Manual Mode ####
The first is a manual calculation of your position relative to a single fixed 'home' geofence. In this mode you specify the 'home' geofence in your openhab.cfg file and then configure your item bindings to watch for location publishes from the Mqttitude app. As each location update is received the binding will calculate the distance from 'home' and update the item (ON/OFF) accordingly.

#### Region Mode ####
The second mode leaves the geofence definition and relative location calculations to the Mqttitude app itself. You can setup any number of 'regions' in your app and give them unique names. Then in openHAB you simply add the region name (optional third parameter of the item binding) and the binding will look for 'enter' or 'leave' events which are published by the app and switch the openHAB item accordingly. This allows you to define as many 'regions' or 'geofences' as you like, and track a phones location relative to many points of interest - e.g. home, work, holiday house. 

### openhab.cfg Config

You only need to define these properties in your openhab.cfg configuration file if you are using one or more 'Manual Mode' item bindings. In this mode you need to let the binding know exactly where 'home' is and what size the [geofence](http://en.wikipedia.org/wiki/Geo-fence) is.

Here is an example;

    # Optional. The lat/lon coordinates of 'home'
    mqttitude:home.lat=xxx.xxxxx
    mqttitude:home.lon=xxx.xxxxx

    # Optional. Distance in metres from 'home' to be considered 'present'
    mqttitude:geofence=100

### Item bindings

To track the location/presence of a mobile device all you need to do is add a Switch item and specify the MQTT topic that device publishes its location to. 

The binding definition for the two modes of operation are;

    Manual Mode:    { mqttitude="<broker_id>:<mqtt_topic>" }
    Region Mode:    { mqttitude="<broker_id>:<mqtt_topic>:<region>" }

#### Manual Mode ####
Here is an example of some 'Manual Mode' item bindings;

    Switch  PresenceBen_PhoneMqtt   "Ben @ Home"   { mqttitude="mosquitto:/mqttitude/ben" }
    Switch  PresenceSam_PhoneMqtt   "Sam @ Home"   { mqttitude="mosquitto:/mqttitude/sam" }

You can track as many different mobile devices as you like, on the one MQTT broker, just by using a different MQTT topic for each. This is configured in the Mqttitude apps on your mobile devices.

When a device publishes a location the binding will receive it instantly, calculate the distance from your 'home' location, and if inside the 'geofence' radius set the Switch item to ON.

#### Region Mode ###
Here is an example of some 'Region Mode' item bindings;

    Switch  PresenceBen_PhoneMqttHome   "Ben @ Home"   { mqttitude="mosquitto:/mqttitude/ben:home" }
    Switch  PresenceBen_PhoneMqttWork   "Ben @ Work"   { mqttitude="mosquitto:/mqttitude/ben:work" }

Here you can setup as many 'regions' as you like in your Mqttitude app and track each region in openHAB by creating a different item for each one, with the region name as the optional third parameter in the item binding.

This is a far more powerful mode and gives greater flexibily. It also stops the issue of location publishes happening just before you get close enough to 'home' and thus being considered outside the geofence, and then no further updates being sent because you don't move far enough to trigger one.

In 'Region Mode' the Mqttitude apps detects when you cross a geofence boundary and ALWAYS sends a location update (either enter or leave), meaning openHAB should never lose track of your position. 

## Mqttitude Apps

Currently only the iOS app (from v5.5) has region support but the Android version is being updated as we speak and should be available very soon. 