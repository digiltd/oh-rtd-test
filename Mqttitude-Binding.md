Documentation of the Mqttitude binding bundle.

## Introduction

[Mqttitude](http://mqttitude.org/) was developed as a replacement for the old Google Latitude service. However it is slightly different (better) in that all your location data is private - i.e. there is no 3rd party server somewhere collecting and storing your data. Instead each time your device publishes its location, it is sent to an [MQTT](http://mqtt.org/) broker of your choice. 

This is where openHAB steps in, with the Mqttitude binding. The idea is that the binding will track your location and when you are 'near' to a specified location (usually your home) it will update a Switch item in openHAB, enabling presence detection.

First you need to set up an MQTT broker (e.g. [Mosquitto](http://mosquitto.org/)) and install the Mqttitude app on your mobile devices. At this point you should start seeing location updates appearing in your broker. 

Now it is time to configure MQTT and the Mqttitude binding...

## Broker Configuration

First you will need to install and configure the [MQTT binding](https://github.com/openhab/openhab/wiki/MQTT-Binding#transport-configuration). This will define the connection properties for your MQTT broker and specify the broker id which we will need when configuring the Mqttitude item bindings.

## Binding Configuration

### openhab.cfg Config

You need to define some properties in your openhab.cfg configuration file so the binding knows exactly where 'home' is and what size the [geofence](http://en.wikipedia.org/wiki/Geo-fence) is.

Here is an example;

    # The lat/lon coordinates of 'home' (mandatory)
    mqttitude:home.lat=xxx.xxxxx
    mqttitude:home.lon=xxx.xxxxx

    # Distance in metres from 'home' to be considered 'present'
    mqttitude:geofence=100

### Item bindings

To track the location/presence of a mobile device all you need to do is add a Switch item and specify the MQTT topic that device publishes its location to.

Here is an example;

    Switch  PresenceBen_PhoneMqtt   "Ben's Phone"   { mqttitude="mosquitto:/mqttitude/ben" }
    Switch  PresenceSam_PhoneMqtt   "Sam's Phone"   { mqttitude="mosquitto:/mqttitude/sam" }

You can track as many different mobile devices as you like, on the one MQTT broker, just by using a different MQTT topic for each. This is configured in the Mqttitude apps on your mobile devices.

When a device publishes a location the binding will receive it instantly, calculate the distance from your 'home' location, and if inside the 'geofence' radius set the Switch item to ON.

## Mqttitude Apps

Currently both the iOS and Android versions of the Mqttitude app will periodically publish location updates, based on time and distance traveled (e.g. 500m in the iOS app). This can cause problems however because if the app publishes a location when you are 250m from home (which is outside your geofence) and then you arrive home, you haven't traveled far enough to trigger another location update. Therefore openHAB thinks you are still 'away'.

v5.4 of the iOS app has had region/geofence support added which should alleviate this problem. By specifying your 'home' location the app will ALWAYS send a location update when you enter or leave the specified region.

This hasn't been implemented in the Android app but it is in the pipeline.