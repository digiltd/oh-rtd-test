Documentation for tellstick binding

_**Note:** This Binding will be available in the upcoming 1.5 Release. For preliminary builds please see the [CI server at Cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/)._

## Introduction

Binding is tested against Tellstick DUO, it should also work with a basic Tellstick.
This binding is currently not released, contact me if you want to try it (jarlebh)

Supports RF 433 Mhz protocols like: Nexa, HomeEasy, X10, CoCo (KlikAanKlikUit), Oregon e.o. <br>
See further information from http://www.telldus.com

Tellstick binding support currently Sensors (Temperatur and Humidity) and Devices (Switch, Dimmable and Dimmable without absolute level)

For installation of the binding, please see Wiki page [[Bindings]].

## Binding Configuration

First of all you need to make sure that your JVM is matching your installed Telldus Center. 
This normally means OpenHab must run on a 32bit JVM for windows and a 64bit JVM for linux.
For windows the binding is hardcoded to look for Telldus Center in Programs Files ("C:/Program Files/Telldus/;C:/Program Files (x86)/Telldus/").

You will have to use Telldus Center to add all your devices. It is also easiest to find the sensor ID by using the Telldus Center. To configure a device you need the name and type of device, to configure a sensor you need the ID and Type of sensor. Also run OpenHAB in debug mode to see that everything starts up correctly and that you are receiving sensor/device updates.

The item configuration for devices is:

    tellstick="<deviceName>:<deviceType>:[<specialCase>][<resendCount>]"

The **deviceName** must match the name in Telldus Center.  
The **deviceType** is either: Command for on/off, DimmingLevel for absolute dimmable device.
**SpecialCase** is used for the dimmable without absolute level(devices that is dimmable with pressing on twice). For this case use Dimmable as specialCase.  
**ResendCount** is just number of times to resend command.

The item configuration for a sensor is:
  
    tellstick="<sensorId>:<valueType>:[<useValueType>]

**SensorId** is the sensorId taken from Telldus Center or debug logs.  
**ValueType** is either Temperatur or Humidity, based on sensor.  
**UseValueType** is for special cases where the value in ValueType is actually something else, supports BatteryLevel (Humidity:BatteryLevel) and Motion (Temperature:Motion). This is implemented for homemade temp/humid and motion sensor [Forum](http://elektronikforumet.com/forum/viewtopic.php?f=3&t=63772&hilit=telldus)
##Configure examples   
Switch:
   
    Switch	GF_Dining_Aquarium "Aquarium" <aquarium> {tellstick="Aquarium:Command"}
Temp sensor:
      
    Number	GF_Kitchen_Temp	"Temperature [%.1f °C]"	<temperature> {tellstick="14:Temperature"}
Battery Level

    Number	GF_Kitchen_Battery "Battery [%d]" <battery> { tellstick="82:Humidity:BatteryLevel" }