# Use Google MAP V3 API with openHAB
 * [Introduction](GoogleMap#Introduction)

## Introduction

After the setup of [MQTT](MQTT-Binding) and [MQTTitude](Mqttitude-Binding) bindings to provide geo-fencing I decided some more color in the UI would be nice. The idea was to show a map that centers on my home and automatically scales to show the location of the inhabitants:

![](https://dl.dropboxusercontent.com/u/1781347/wiki/2015-06-11_15_51_06.png)

For people familiar with Google API and Ajax that is probably nothing fancy ... but for those (like me) that are new to that topic my setup might give some help and a head start.

## Pre-Requisits

For this example to work you'll need a proper [MQTT](MQTT-Binding) and [OwnTracks](owntracks.org) setup. 
Once you have the "raw" data available in OH you're ready ...
![](https://dl.dropboxusercontent.com/u/1781347/wiki/2015-06-11_15_39_08.png)

## ...