# ImperiHome Binding

**Please Note:** 
This binding is in alpha stage; currently available for download via the [OpenHAB-Forum](https://groups.google.com/d/msg/openhab/TWrvCd1fens/mO83ymI772sJ).

 * [[Purpose|ImperiHome-Binding#purpose]]
 * [[Installation|ImperiHome-Binding#installation]]
 * [[Configuration|ImperiHome-Binding#configuration]]
  * [[Items|ImperiHome-Binding#items]]
   * [[Binding Format|ImperiHome-Binding#binding-format]]

## Purpose

The binding will enable you to use the comercial [ImperiHome](http://www.imperihome.com/) UI.

![](http://www.imperihome.com/wp-content/main-screens.png)

## Installation
Copy the .jar files provided into the ./addons directory of your OH installation.

[[Page Top|ImperiHome-Binding#imperihome-binding]]

## Configuration
The binding provides the API for ImperiHome to load the devices from openHAB and to control it.

### Items
#### Binding Format
```
{imperihab="room:[#room],type:[#type],watts:[#wattsitem]"}
```
<table>
  <tr><td>#room</td><td>the room you want the item to appear under in ImperiHome</td></tr>
  <tr><td>#type</td><td>Optional, only needed if the type of the device cannot be guessed from the item.  It first tries to find the type based on the values it support OpenClose, OnOff, Percentage etc and there's some best guesses for the item names e.g. if item name contains "Humidity" it thinks its a humidity sensor).  If none of these work, or if you want to override the type it guesses, you can specify it.  Using the device types for imperihome: 
<table>
  <tr><th>Device type string</th><th>Description</th></tr>
  <tr><td>DevCamera</td><td>MJPEG IP Camera</td></tr>
  <tr><td></td><td></td></tr>
  <tr><td></td><td></td></tr>
  <tr><td></td><td></td></tr>
  <tr><td></td><td></td></tr>
  <tr><td></td><td></td></tr>
  <tr><td></td><td></td></tr>
  <tr><td></td><td></td></tr>
</table>
</td></tr>
  <tr><td>#wattsitem</td><td>Optional, this lets you specify another item to be the "energy" value for an item, e.g. for a z-wave power outlet Switch Item, you can link this to the Number item that has the power reading.  Then in imperihome it will show the power usage for that switch.</td></tr>
</table>

[[Page Top|ImperiHome-Binding#imperihome-binding]]