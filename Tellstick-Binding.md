Documentation for tellstick binding

## Introduction

Binding is tested against Tellstick DUO, it should also work with a basic Tellstick.

Supports RF 433 Mhz protocols like: HomeEasy, Cresta, X10, La Crosse, OWL, CoCo (KlikAanKlikUit), Oregon e.o. <br>
See further information from http://www.telldus.com

Tellstick binding support currently Sensors (Temperatur and Humidity) and Devices (Switch, Dimmable and Dimmable without absolute level)

For installation of the binding, please see Wiki page [[Bindings]].

## Binding Configuration

First of all you need to make sure that your JVM is matching your installed Telldus Center. 
This normally means OpeHab must run on a 32bit JVM for windows and a 64bit JVM for linux.
The binding is now harcoded to look for Telldus Center in Programs Files.

You will have to use Telldus Center to add all your devices. It is also easiest to find the sensor ID by using the Telldus Center. To configure a device you need the name and type of device, to configure a sensor you need the ID and Type of sensor.

The item configuration for devices is:

   tellstick="<deviceName>:<deviceType>:[<resendCount>]"

The deviceName must match the name in Telldus Center.  

The deviceType is either: Command for on/off, DimmingLevel for absolute dimmable device, Dimmable for a device that is dimmable with pressing on twice.  

ResendCount is just number of times to resend command.

The item configuration for a sensor is:
    tellstick="<sensorId>:<valueType>:<useValueType>
##Configure examples   
Switch:   
Switch	GF_Dining_Aquarium "Aquarium" <aquarium> {**tellstick="Aquarium:Command"**}
Temp sensor:    
Number	GF_Kitchen_Temp	"Temperature [%.1f °C]"	<temperature> {**tellstick="14:Temperature"**}