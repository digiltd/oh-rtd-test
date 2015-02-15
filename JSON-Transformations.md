It is possible to parse JSON data in several ways; this page shall give some examples on how to do this.

# Rules
Below example shows how to parse a JSON message received via MQTT in a rule (OH 1.6.2):
```Xtend
import org.openhab.core.library.types.*
import org.openhab.core.persistence.*
import org.openhab.model.script.actions.*

rule "MqttPostionPatrikParse"
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