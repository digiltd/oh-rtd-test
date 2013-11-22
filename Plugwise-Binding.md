## Introduction

Please note that in version 1.1 you also have to add the Serial binding, so that the libraries for serial communication are present.

**Note:** JRE 1.7 is required to run this binding

Currently only "V2" of the Plugwise protocol is supported. It is advices that users of the binding upgrade their devices to the latest firmware using the Plugwise Source software

Plugwise's system consists of a Plug - a ZigBee USB controller -, a Circle+ - managing the network, and multiple Circles that each, except for the Stick, measure energy usage in either real-time or per hour-interval, and that can switch an internal relay On or Off

For installation of the binding, please see Wiki page [[Bindings]].

## Generic Item Binding Configuration

In order to bind an item to a Plugwise device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the Plugwise binding configuration string is explained here:

The format of the binding configuration is simple and looks like this:

    plugwise="[<command>:<Plugwise id>:<Plugwise command>:<Polling interval>], [<command>:<Plugwise id>:<Plugwise command>:<Polling interval>], ..."

for Items that trigger action or commands on the Plugwise device, and

    plugwise="[<Plugwise id>:<Plugwise variable>:<Polling interval>], [<Plugwise id>:<Plugwise variable>:<Polling interval>], ..."

for Items that rather store a status variable or other from the Plugwise device

where the `<Plugwise id>` corresponds with the 'MAC' address  - or - the configuration in openhab.cfg where one can configure the Plugwise devices, which looks like this

    plugwise:<Plugwise id>.mac=[MAC]

where `<Polling Interval>` is the interval in seconds to poll the given variable

and where `<Plugwise command>` is the command to be sent to the Plugwise device when `<command>` is received. In case status variables are used then any value received from the Plugwise device for the defined `<Plugwise variable>` is used to update the Item

## Plugwise Commands

The Plugwise device is very simple device. For a perfect integration within OpenHAB it is assumed that the user will be using the Plugwise Source software to define the network, reset devices, perform firmware upgrade, and so forth, e.g. anything which requires user input or interactivity. Therefore the Plugwise Commands supported from within OpenHAB are mostly limited to those actions that require little or no user interaction

Valid `<Plugwise command>`'s are:

<table>
  <tr><td>**Command**</td><td>**Item Type**</td><td>**Purpose**</td><td>**Note**</td></tr>
  <tr><td>state</td><td>OnOff</td><td>switch the internal relay On or Off</td><td></td></tr>
</table>

## Plugwise Status Variables

Valid `<Plugwise variable>`s are:

<table>
  <tr><td>**Variable**</td><td>**Item Type**</td><td>**Purpose**</td><td>**Note**</td></tr>
  <tr><td>clock</td><td>String</td><td>Time as indicated by the internal clock of the device</td><td></td></tr>
  <tr><td>lasthour</td><td>Number</td><td>Energy consumption over the last hour, in kWh</td><td></td></tr>
  <tr><td>lasthour-stamp</td><td>DateTime</td><td>Date/Time stamp of the last hourly energy consumption history entry</td><td></td></tr>
  <tr><td>power</td><td>Number</td><td>Current energy consumption, measured over 1 second interval, in Watt</td><td></td></tr>
  <tr><td>power-stamp</td><td>DateTime</td><td>Date/Time stamp of the last energy consumption measurement</td><td></td></tr>
  <tr><td>realtime-clock</td><td>DateTime</td><td>Date/Time as indicated by the internal clock of the Circle+</td><td>only for Circle+</td></tr>
</table>

## Examples

Here are some examples of valid binding configuration strings, as defined in the items configuration file:

    Switch Switch1	"Switch1" <plugwise> { plugwise="[ON:000D6F000099675B:state:15], [OFF:000D6F000099675B:state:15]"}
    Number Item1	"Item1" <plugwise> { plugwise="[multimedia:power:3]"}
    DateTime Time1  "Time1" <plugwise> { plugwise="[circleplus:realtime-clock:10]"}