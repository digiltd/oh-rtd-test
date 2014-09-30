### FS20 Binding

This binding enables support of sending and receiving FS20 messages via the CUL transport. You will need CULLite or similiar device from busware.de. This device needs to be flashed with the latest culfw firmware from culfw.de.

### Installation
You need the CUL transport (`org.openhab.io.transport.cul`) and the binding (`org.openhab.binding.fs20`) in your addons folder.

### Configuration
In your openhab.cfg you need to specify which serial device is the CUL device. This simply done via

    fs20:device=serial:/dev/ttyACM0

if your serial device is /dev/ttyACM0

### Item configuration
You can use SwitchItems and DimmerItems with this binding. You need to know the house address and device address of the device you want to receive messages or send messages to. To find these addresses you can start openhab in debug mode. The CUL transport will print all out all received messages.
A sample switch configuration looks like this

    Switch  WallSwitch1     "Wandschalter 1"                {fs20="C04B00"}

where `C04B` is the house address and `00` the device address. If you want to control switches or dimmers you can simply create you own house and device address. You can set such devices in a pairing mode and they will react to the first message they receive.

### Coming from FHEM?

In the `fhem.cfg` you find such statements:

    define AmbiLight FS20 c04b 01

Just write the last "words" together and you have the full address you need for your item (see above).