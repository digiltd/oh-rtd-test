# Introduction
This binding allows to integrate RWE Smarthome into OpenHAB. It uses an inofficial interface, which is limited in some cases, as explained below. As the interface has some delay and polling is needed to receive all changes from the RWE Smarthome Central (SHC), it may take one or two seconds, until a device finally responds. However, this is tolerable in most cases as time critical rules can be done in the RWE Smarthome Central itself.

**DISCLAIMER:** This binding is based on an inofficial interface, which may be changed or even closed by RWE at any time.

# General configuration
The basic configuration is done in openhab.cfg and looks like this:

```
############################## RWE Smarthome Binding ##############################
#
# Hostname / IP address of the RWE Smarthome server
rwesmarthome:host=
 
# Username / password of the RWE Smarthome server
rwesmarthome:username=
rwesmarthome:password=
 
# The interval in seconds to check if the communication with the RWE Smarthome server is still alive.
# If no message receives from the RWE Smarthome server, the binding restarts. (optional, default is 300)
# rwesmarthome:alive.interval=300

# The interval in seconds to wait after the binding configuration has changed before the device states
# will be reloaded from the RWE SHC. (optional, default is 15)
# rwesmarthome:binding.changed.interval=15
```

Simply enter the hostname or IP address of your RWE Smarthome Central (SHC) as well as the corresponding username and password.

# General item binding configuration
All items use the format `{rwe="id=<logical-device-id>,param=<parameter>"}`, where `<logical-device-id>` is a unique number for each logical device (e.g. `2951a048-1d21-5caf-d866-b63bc00280f4`) and `<param>` the desired parameter of the device.

The following parameters are available:|||||||||||||

| Property | Type | Description | 
| :------------- |:-------------| :-----|
|  contact | Contact | Window/Door contact  |
|  temperature | Number | Temperature sensor |
|  settemperature | Number | Desired temperature of a thermostat |
|  operationmodeauto | Switch | Operationmode of a thermostat |
|  humidity | Number | Humidity sensor |
|  luminance | Number | Luminance sensor |
|  switch | Switch | Switch state, e.g. wall plug |
|  dimmer | Dimmer | Dimmer |
|  dimmerinverted | Dimmer | Dimmer with inverted values |
|  rollershutter | Rollershutter | Rollershutter |
|  rollershutterinverted | Rollershutter | Rollershutter with inverted values |
|  smokedetector | Switch | State of a smokedetector |
|  alarm | Switch | Siren of a smokedetector |
|  variable | Switch | Variable as defined in SHC |

Supported (confirmed) devices and corresponding parameters are:
* RWE SmartHome Bewegungsmelder innen (WMD): luminance only, movement only via variable, see (1)
* RWE SmartHome Heizkörperthermostat (RST): temperature, settemperature, operationmodeauto, humidity
* RWE SmartHome Rauchmelder (WSD): smokedetector, alarm
* RWE SmartHome Tür-/Fenstersensor (WDS): contact
* RWE SmartHome Unterputz-Dimmer (ISD2): dimmer, dimmerinverted
* RWE SmartHome Unterputz-Lichtschalter (ISS2): switch
* RWE SmartHome Unterputz-Rollladensteuerung (ISR2): rollershutter, rollershutterinverted
* RWE SmartHome Wandsender (WSC2): only indirect via variable, see (2)
* RWE SmartHome Zwischenstecker (PSS): switch
* RWE SmartHome Zwischenstecker aussen (PSSOz): switch

Unconfirmed but probably supported devices and corresponding parameters are (please report and confirm, if you own one of the following devices and they are working):
* RWE SmartHome Bewegungsmelder aussen (WMDO): luminance only, movement only via variable, see (1)
* RWE SmartHome Raumthermostat (WRT): temperature, settemperature, operationmodeauto, humidity
* RWE SmartHome Unterputz-Sender (ISC2): only indirect via variable, see (2)

(1) TODO
(2) TODO

# Examples
TODO