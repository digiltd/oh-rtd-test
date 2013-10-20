# Documentation of the EnOcean binding bundle

# Introduction

<wiki:video url="http://www.youtube.com/watch?v=GpERJflmJKQ"/>

For installation of the binding, please see Wiki page [# !EnOcean Binding Configuration

## openhab.cfg

The following config params are used for the !EnOcean binding.

- enocean:serialPort
The serial port (can be a virtual one) where the enocean transceiver is connected to. An USB adapter creates a virtual serial port (normally /dev/ttyUSB0 under linux)

### Example

f28f499f39ef60839adca05929150952

# Generic Item Binding Configuration

## Items

General format:
    enocean="{id=<id_of_enocean_device> [, eep = <EEP_name>][, channel = <channelName>][, parameter = <parameterName>]}"
    The device id is printed on the device package. When the EEP is needed, the eep (e.g. "F6.02.01") is also printed on the device package.
    All parameters in [] are optional and only used for some devices.

## Supported Devices

These EEP Profiles are already supported. 
If your device is not listed, please add an issue for it at openhab.

- Rocker Switches
- F6:02:01 (Light and Blind Control - Application Style 1)
- Environment Sensors
- A5:02:05 (Temperature Range from 0° to 40°)

Soon supported: 
- Contact Sensors
- D5:00:01 (Single Input Contact)
  
 
### Rocker Switches

- eep = F6:02:01, F6:02:02
- channel = A / B
- parameter =
- I: The I button (normally the one with the solid arrow sign) was pressed (Switch, pressed=Update to ON, released=Update to OFF)
- O: The O button (normally the one with the empty arrow sign) was pressed (Switch, pressed=Update to ON, released=Update to OFF)

Be aware that the parameters are still under discussion and can be subject to change.

### = Examples =

Standard usage:
    Switch Button_Up () {enocean="{id=00:00:00:00, eep=F6:02:01, channel=B, parameter=I}}
- pressed: ON
- released: OFF

To control a roller shutter:
0067df86ebf36144276dda80762257fe
- Short press down: Close roller shutter or stop it when it was started shortly ago
- Short press up: Open roller shutter or stop it when it was started shortly ago
- Long press down: Close roller shutter as long as the button is pressed
- Long press up: Open roller shutter as long as the button is pressed

See [https://code.google.com/p/openhab-samples/wiki/ItemDef#How_to_control_a_homematic_roller_shutter_with_an_Rocker Example of roller shutter controlling](https://code.google.com/p/openhab/wiki/Bindings].)

To control a dimmer (left buttons = channel A):
    Dimmer myLights () {enocean="{id=00:00:00:00, channel=A, eep=F6:02:01}"}
- Short press down: Switch light ON
- Short press up: Switch light OFF
- Long press down: Dim light UP as long as the button is pressed (INCREASE every 300ms)
- Long press up: Dim light DOWN as long as the button is pressed (DECREASE every 300ms)

### Environment Sensors

- eep = A5:02:05
- channel = none
- parameter =
- TEMPERATURE: The current temperature (Number, unit=°C)

### = Examples =

    Number UG_Flur_Temp "Temperature [%.1f °C]" <temperature> () {enocean="{id=00:00:00:00, eep=A5:02:05, parameter=TEMPERATURE}"}

### Contact Sensors

- eep = D5:00:01
- channel = none
- parameter =
- CONTACT_STATE: Contact Open / Closed (OpenClosedType)

Will work in 1.4.0

### = Examples =

    tbd