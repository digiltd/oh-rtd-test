### FS20 Binding

This binding enables support of sending and receiving FS20 messages via the CUL transport. You will need CULLite or similiar device from busware.de. This device needs to be flashed with the latest culfw firmware from culfw.de.

### Installation
You need the CUL transport (`org.openhab.io.transport.cul`) and the binding (`org.openhab.binding.fs20`) in your addons folder.

### Configuration
In your openhab.cfg you need to specify which serial device is the CUL device. This simply done via

    fs20:device=serial:/dev/ttyACM0

if your serial device is /dev/ttyACM0

Starting with version 1.6 you can adjust baudrate and parity handling too. For busware COC Raspberry extension please use the following settings: 

    fs20:baudrate=38400
    fs20:parity=0

To connect to a networked CUL e.g. one made available by ser2net from a tuxnet device:
    fs20:device=network:<my host ip>:<my port>

### Item configuration
You can use SwitchItems and DimmerItems with this binding. You need to know the house address and device address of the device you want to receive messages or send messages to. To find these addresses you can start openhab in debug mode. The CUL transport will print all out all received messages.
A sample switch configuration looks like this

    Switch  WallSwitch1     "Wandschalter 1"                {fs20="C04B00"}

where `C04B` is the house address and `00` the device address. If you want to control switches or dimmers you can simply create you own house and device address. You can set such devices in a pairing mode and they will react to the first message they receive.

### Coming from FHEM?

In the `fhem.cfg` you find such statements:

    define AmbiLight FS20 c04b 01

Just write the last "words" together and you have the full address you need for your item (see above).

### Networked connection with ser2net

To use a networked CUL device for FS20 from ser2net, this line in /etc/ser2net.conf on the remote host will publish the serial interface (replace /dev/ttySP1 with whatever is appropriate):

    3333:raw:0:/dev/ttySP1:38400 8DATABITS NONE 1STOPBIT

with

    fs20:device=network:myhostnamewithCUL:3333

you can connect to this remote CUL.