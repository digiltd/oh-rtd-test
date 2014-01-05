This binding allows to use a [Velleman k8055 USB IO Board](http://www.vellemanusa.com/products/view/?country=us&lang=enu&id=500349) with OpenHab.

_Note: This binding is currently a proposal, and is not yet merged into an openhab release.  However, the  development code can be found on the following fork:  !_

## Pre-requisites

This binding makes use of JNI calls to the native k8055 library and thus requires that the native library is installed in the lib directory on the system.  The binding has been tested on Linux with the open-source linux library [libk8055](http://libk8055.sourceforge.net/) library.  In principle the windows DLL has the same API so might work, but it's not been tested.

## Binding configuration

Before configuring single items, the global device configuration needs to be set up in the openhab.cfg file.

     ################################# Velleman K8055 Binding ######################################  

     # refresh interval in milliseconds (optional, defaults to 60000ms, 60s)
     #k8055:refresh=60000

     # Board Number.
     #k8055:boardno=0



The k8055:refresh value is how often the binding should read the state of the hardware inputs.  

The k8055:boardno value is which board openhab should connect to. This must be specified to enable the binding.  Currently the binding only supports connecting to a single board.

## Item Binding Configuration

In order to bind an item to the device, you need to provide configuration settings.
 The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). 
The syntax of the binding configuration strings accepted is the following:

    k8055="<IO-type>:<IO-number>"

Where 
* **IO-type** is one of:
  DIGITAL_IN
  DIGITAL_OUT
  ANALOG_IN
  ANALOG_OUT

* **IO-number** is the number (1-8) of the particular IO channel to bind to.

## Examples

    Switch Output1 "Digital Output 1" { k8055="DIGITAL_OUT:1"}
    Switch Output2 "Digital Output 2" { k8055="DIGITAL_OUT:2"}
    
    Dimmer K8055_ANOUT_1 "K8055 Analog Output 1"   { k8055="ANALOG_OUT:1"}
    Dimmer K8055_ANOUT_2 "K8055  Analog Output 2"  { k8055="ANALOG_OUT:2"}
    
    Number K8055_ANIN_1 "K8055 Analog Input 1" { k8055="ANALOG_IN:1" } 
    Number K8055_ANIN_2 "K8055 Analog Input 2" { k8055="ANALOG_IN:2" }

## Troubleshooting
On some Linux distribution the user openhab is running as may not have permissions to access the USB ports by default.  It is worth checking that the standalone command-line program (k8055) that comes with libk8055 works as the relevant user before attempting to use the binding.  (Particularly as the driver outputs little useful debugging information to the logs).