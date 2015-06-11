# Use Google MAP V3 API
 * [Introduction](GoogleMap#Introduction)
 * [Pre-Requisits](GoogleMap#pre-requisits)
 * [Configuration](GoogleMap#configuration)
  * [Parse the raw data ...](GoogleMap#parse-the-raw-data-)


## Introduction

After the setup of [MQTT](MQTT-Binding) and [MQTTitude](Mqttitude-Binding) bindings to provide geo-fencing I decided some more color in the UI would be nice. The idea was to show a map that centers on my home and automatically scales to show the location of the inhabitants:

![](https://dl.dropboxusercontent.com/u/1781347/wiki/2015-06-11_15_51_06.png)

For people familiar with Google API and Ajax that is probably nothing fancy ... but for those (like me) that are new to that topic my setup might give some help and a head start.

## Pre-Requisits

For this example to work you'll need a proper [MQTT](MQTT-Binding) and [OwnTracks](owntracks.org) setup. 
Once you have the "raw" data available in OH you're ready ...

![](https://dl.dropboxusercontent.com/u/1781347/wiki/2015-06-11_15_39_08.png)

## Configuration
### Parse the raw data ...
For each person you'ld like to show on the map you'll need to have latitude and longitude data available. A rule can be used to parse the data received:

```Xtend
rule "MqttPostionParsePatrik"
  when 
    Item mqttPositionPatrikRaw changed
  then
    var String json = (mqttPositionPatrikRaw.state as StringType).toString
	// {"_type": "location", "lat": "47.5010314", "lon": "8.3444293",
	//    "tst": "1422616466", "acc": "21.05", "batt": "40"}
	var String type = transform("JSONPATH", "$._type", json)
	if (type == "location") {
	  var String lat  = transform("JSONPATH", "$.lat", json)
	  var String lon  = transform("JSONPATH", "$.lon", json)
	  var String acc  = transform("JSONPATH", "$.acc", json)
	  var String batt = transform("JSONPATH", "$.batt", json)
	
      sendCommand(mqttPatrikLatitude,  lat)
	  sendCommand(mqttPatrikLongitude, lon)
	  sendCommand(mqttPatikAccuracy,   acc) 
	  sendCommand(mqttHtcOneBattery,  batt)
	}
  end
```
