Documentation of the HomeMatic binding bundle<br/>
[![HomeMatic Binding](http://img.youtube.com/vi/F0ImuuIPjYk/0.jpg)](http://www.youtube.com/watch?v=F0ImuuIPjYk)

## Introduction

For installation of the binding, please see Wiki page [[Bindings]].

## Hardware

### Controller

The controller "speaks" with the HomeMatic devices through the properiatry wireless protocol of HomeMatic.

#### CCU 1

The best supported hardware so far for HomeMatic is the CCU 1. 

#### CCU 2

The second version (beginning with mid 2013) should work in most circumstances, but is not as widely used as the first version. 
We need testers here: If you own a CCU2, please try out the latest 1.4.0 nightly releases!

#### LAN Adapter

One of the cheaper alternatives is to use the [HomeMatic LAN Adapter](http://www.eq-3.de/produkt-detail-zentralen-und-gateways/items/hm-cfg-lan.html).
The LAN Adapter _**requires**_ the BidCos-Service running and listening on a specific port in your LAN. As of this writing the BidCos-Service is only available for Microsoft Windows. If you want to run the BidCos-Service '_natively_' (through Qemu) on Linux without messing around with [Wine](http://www.winehq.org) follow these step by step instructions.

1. Install QEMU (If you are running OpenHAB on i386/amd64)

    In order to run the BidCos-Service daemon 'rfd' under linux you need to install the QEMU arm emulation. If you are using Debian you have to install at least the package qemu-system-arm.
    ```
    apt-get install qemu
    ```
2. Download the latest CCU 2 firmware from [eQ-3 homepage](http://www.eq-3.de/software.html)
3. Extract the downloaded firmware e.g. HM-CCU2-2.7.8.tar.gz
    ```Shell
    mkdir /tmp/firmware
    tar xvzf HM-CCU2-2.7.8.tar.gz -C /tmp/firmware
    ```

    You should now have three files under the directory /tmp/firmware
    ```Shell
    rootfs.ubi    (<-- this is the firmware inside a UBIFS iamge)
    uImage
    update_script
    ```
4. Create an 256 MiB emulated NAND flash with 2KiB NAND page size
    ```Shell
    modprobe nandsim first_id_byte=0x20 second_id_byte=0xaa third_id_byte=0x00 fourth_id_byte=0x15
    ```

    You should see a newly created MTD device _/dev/mtd0_ (assume that you do not have other MTD devices)
5. Copy the contents of the UBIFS image _rootfs.ubi_ to the emulated MTD device

    ```Shell
    dd if=rootfs.ubi of=/dev/mtd0 bs=2048
    ```
6. Load UBI kernel module and attach the MTD device mtd0

    ```Shell
    modprobe ubi mtd=0,2048
    ```
7. Mount the UBIFS image

    ```Shell
    mkdir /mnt/ubifs
    mount -t ubifs /dev/ubi0_0 /mnt/ubifs
    ```
8. Copy the required files to run the BidCos-Service from the UBIFS image

    ```Shell
    mkdir -p /etc/eq3-rfd /opt/eq3-rfd/bin opt/eq3-rfd/firmware
    cd /mnt/ubifs
    cp /mnt/ubifs/bin/rfd /opt/eq3-rfd/bin
    cp /mnt/ubifs/etc/config_templates/rfd.conf /etc/eq3-rfd/bidcos.conf
    cp -r /mnt/ubifs/firmware/* /opt/eq3-rfd/firmware/
    ```
    List the dependencies for rfd binary
    ```
    qemu-arm -L /mnt/ubifs /mnt/ubifs/lib/ld-linux.so.3 --list /mnt/ubifs/bin/rfd
    ```
    You should see an output like this
    ```
	libpthread.so.0 => /lib/libpthread.so.0 (0xf67a7000)
	libelvutils.so => /lib/libelvutils.so (0xf6786000)
	libhsscomm.so => /lib/libhsscomm.so (0xf6733000)
	libxmlparser.so => /lib/libxmlparser.so (0xf6725000)
	libXmlRpc.so => /lib/libXmlRpc.so (0xf66fc000)
	libLanDeviceUtils.so => /lib/libLanDeviceUtils.so (0xf66d2000)
	libUnifiedLanComm.so => /lib/libUnifiedLanComm.so (0xf66bf000)
	libstdc++.so.6 => /usr/lib/libstdc++.so.6 (0xf65e8000)
	libm.so.6 => /lib/libm.so.6 (0xf6542000)
	libc.so.6 => /lib/libc.so.6 (0xf63f7000)
	libgcc_s.so.1 => /lib/libgcc_s.so.1 (0xf63ce000)
	/lib/ld-linux.so.3 => /mnt/ubifs/lib/ld-linux.so.3 (0xf6fd7000)
    ```
    Copy all the listed libs from /mnt/ubifs to there respective folder at /opt/eq3-rfd
9. Create a system user and adjust permissions

    ```
    adduser --system --home/opt/eq3-rfd --shell /bin/false --no-create-home --group bidcos
    chown -R bidcos:bidcos /opt/eq3-rfd
    ```
10. Edit and adjust the BidCos-Service configuration bidcos.conf

    ```
    # TCP Port for XmlRpc connections
    Listen Port = 2001
    
    # Log Level: 1=DEBUG, 2=WARNING, 3=INFO, 4=NOTICE, 5=WARNING, 6=ERROR
    Log Level = 3
    
    # If set to 1 the AES keys are stored in a file. Highly recommended.
    Persist Keys = 1
    
    Address File = /etc/eq3-rfd/ids
    Key File = /etc/eq3-rfd/keys
    Device Files Dir = /etc/eq3-rfd/devices

    # These path are relative to QEMU_LD_PREFIX
    Device Description Dir = /firmware/rftypes
    Firmware Dir = /firmware
    Replacemap File = /firmware/rftypes/replaceMap/rfReplaceMap.xml

    # Logging
    Log Destination = File
    Log Filename = /var/log/eq3-rfd/bidcos.log

    [Interface 0]
    Type = Lan Interface
    Serial Number = <HomeMatic ID e.g. JEQ0707164>
    Encryption Key = <your encryption key>
    ```
11. Start the BidCos-Service daemon 'rfd'

    The BidCos-Service daemon 'rfd' can now be started with the following command
    ```
    qemu-arm -L /opt/eq3-rfd /opt/eq3-rfd/bin/rfd -f /etc/eq3-rfd/bidcos.conf
    ```

#### CUL

The other cheaper alternative is the CUL stick. The CUL is an USB stick that can be used as a wireless transceiver. It ca be programmed to be used with a hughe amount of wireless protocols, under which you can find the homemtic protocol as well.
Since the CUL is not natively supported by the binding, you need a program to translate the CUL data to the CCU XML RPC interface: [Homegear](http://www.homegear.eu)

We have reports from users that succesfully use both for their homemtic devices. Apparently security is still not supported.


## HomeMatic Binding Configuration

### openhab.cfg

The following config params are used for the HomeMatic binding.

- homematic:host
Hostname / IP address of the HomeMatic CCU
- (optional) homematic:callback.host
Hostname / IP address for the callback server. This is normally the IP / hostname of the local host (but not "localhost" or "127.0.0.1"). If not present, it is auto discovered. Will print out an warning / error if not successful.
- (optional) homematic:callback.port
Port number for the callback server. Defaults to 9123.

### Example

    ######################## HomeMatic Binding ###########################
    
    # Hostname / IP address of the HomeMatic CCU
    homematic:host=homematic
    
    # Hostname / IP address for the callback server (optional, default is auto-discovery)
    # This is normally the IP / hostname of the local host 
    # (but not "localhost" or "127.0.0.1"). 
    homematic:callback.host=laptop-dell-linux
    
    # Port number for the callback server. (optional, defaults to 9123)
    homematic:callback.port=9123

## Generic Item Binding Configuration

### Items

General format (since 1.3):

    homematic="{<device config>}"
The device config consists of several name/value pairs seperated by a equal sign ("="). The format is derived from the JSON format. 
    
Normal parameters: 

    id=<physicalDeviceAddress / serial number>, channel=<channel in the devices>, parameter=<parameterKey>. 
    
Advanced parameters: 

    converter=<Class name of the converter to use>, admin: For admin commands.

### About the Documentation

The information at each value in brakets is: `(<item type>, <unit>, <min/max or possible values>)`

For the German CCU users:
Die Physical Device Address findet man in der CCU als Seriennummer. Zum Beispiel im Menü aus Einstellungen -> Geräte. Dann hat man eine gute Übersicht über alle Devices.

### Supported Datapoints

The current binding does support the following datapoint:
PRESS_LONG, PRESS_LONG_RELEASE, TEMPERATURE, PRESS_SHORT, HUMIDITY, LEVEL, STATE, BRIGHTNESS, MOTION, SETPOINT, VALVE_STATE, STOP, WORKING, INSTALL_TEST, PRESS_CONT, ERROR, UNREACH, LOWBAT, MODE_TEMPERATUR_VALVE

A documentation which device is proving which datapoint, please check the documentation from eQ3: http://www.eq-3.de/Downloads/PDFs/Dokumentation_und_Tutorials/HM_Script_Teil_4_Datenpunkte_1_503.pdf

### Supported Devices

These devices are already supported or will be in near future since we own them. 
If your device is not listed, please add an issue for it.
See [[HomeMatic Admin Items|homematic admin items]] on howto get information about your devices.

- Remote Controls
 - HM-RC-4 (Wireless 4-button sender)
 - HM-PBI-4-FM (Wireless 4-button sender flush mount)
 - HM-RC-P1 (Single button control)
 - HM-RC-12-B (12 button remote control)
 - HM-SwI-3-FM (with workaround)
 - HM-PB-2-WM (2 channel rocker)
 - HM-PB-2-WM55 (2 channel rocker, new model)
 - BidCoS-RF:1 - BidCoS-RF:50 (Virtual Keys of the CCU)
 - HM-PB-4DIS-WM (Wireless 20 button sender with display)
- Switches
 - HM-LC-Sw1-Pl (Plug switch (1-port))
 - HM-LC-Sw1-Pl-2 (Plug switch (1-port))+
 - HM-LC-Sw1PBU-FM (Flush switch (1-port))
 - HM-LC-Sw1-FM (Flush switch (1-port))+
 - HM-LC-Sw2-FM (Flush switch (2-port))+
 - HM-LC-Sw4-SM (Flush switch (4-port))
 - HM-ES-PMSw1 (Plug switch (1-port) with measure Features)
- Dim actors
 - HM-LC-Dim2T-SM (Two port dim actor)
 - HM-LC-Dim1T-PI (One port dim actor plug)
 - HM-LC-Dim1T-FM (One port dim actor)
 - HM-LC-Dim1TPBU-FM (1 port dimmer actor flush mount)
- Environment Sensors
 - HM-WDS40-TH-I (Temperature and Humidity sensor)
 - HM-WDS10-TH-O (Temperature and Humidity sensor)
 - HM-Sec-MDIR (Motion and Brightness Sensor)
 - HM-Sen-MDIR-O (Motion and Brightness Sensor)
 - HM-Sec-WDS (water sensor)
- Contact Sensors
 - HM-Sec-SC (Wireless door / window contact sensor)
 - HM-SCI-3-FM (Shutter Contact)
 - HM-Sec-RHS (Rotary handle sensor)
- Climate Controls
 - HM-CC-VD (Wireless actuator)+
 - HM-CC-TC (Themo control, partly working)
- Not fully supported: Roller Shutters
 - HM-LC-Bl1-FM (Roller Shutter actor (1-port))
 - HM-LC-Bl1PBU-FM (Roller Shutter actor (1-port))
 - HM-LC-Bl1-SM (Roller Shutter actor (1-port))
  
For a complete list with translations (en - de) see http://www.elv.de/controller.aspx?cid=824&detail=10&detail2=2850.

### Remote Controls

Supported Devices:
- HM-RC-4
- HM-PBI-4-FM
- HM-RC-P1
- HM-PB-2-WM
- HM-PB-2-WM55
- HM-SwI-3-FM
- BidCoS-RF:1 - BidCoS-RF:50 (Virtual Keys of the CCU)
- HM-PB-4DIS-WM

Valid parameter keys: 
- PRESS_SHORT: The button was pressed short (Switch, pressed=Update to ON)
- PRESS_LONG: The button was pressed or released (Switch, pressed=Update to ON, released=Update to OFF).
- PRESS_CONT: Every few ms this is updated to ON while the long press button is pressed. Useful e.g. for dimming. (Switch, button still pressed=Update to ON)

#### = Trouble Shoot =

If the button is not working and you do not see any PRESS_LONG / SHORT in your log file (when started in debug mode), it could be because of enabled security.
Try to disable security of your buttons in the HomeMatic Web GUI and try again.
If you can't disable security (e.g. HM-SwI-3-FM) try to use key INSTALL_TEST which gets updated to ON for each key press (Switch, pressed=Update to ON)

#### = Examples =

    Switch LivingRoom_RC_One_Left    "Living Room Light Sofa INCREASE" <rollershutter> (LivingRoom, Light) {homematic="id=IEQ0035141, channel=1, parameter=PRESS_SHORT"}
    Switch LivingRoom_RC_One_Right    "Living Room Light Sofa DECREASE" <rollershutter> (LivingRoom, Light) {homematic="id=IEQ0035141, channel=2, parameter=PRESS_SHORT"}
    Switch LivingRoom_RC_Two_Left    "Living Room Light TV INCREASE" <rollershutter> (LivingRoom, Light) {homematic="id=IEQ0035141, channel=3, parameter=PRESS_SHORT"}
    Switch LivingRoom_RC_Two_Right    "Living Room Light TV DECREASE" <rollershutter> (LivingRoom, Light) {homematic="id=IEQ0035141, channel=4, parameter=PRESS_SHORT"}  
    Switch test "Test" (Test) {homematic="id=BidCoS-RF, channel=10, parameter=PRESS_SHORT"}
  
### Switches

Supported Devices:
- HM-LC-Sw1PBU-FM
- HM-LC-Sw1-FM
- HM-LC-Sw2-FM
- HM-LC-Sw1-Pl
- HM-LC-Sw1-Pl-2
- HM-LC-Sw4-SM
- HM-ES-PMSw1

Valid parameter keys: 
- STATE: The current state of the switch (Switch, TRUE=ON, FALSE=OFF). Accepts OPEN / CLOSE as well.

#### = Examples =

    Switch RF_Plug1 "RF Plug 1" (Light) {homematic="id=JEQxxxxxxxx, channel=1, parameter=STATE"} 

#### = Example for HM-ES-PMSw1 measure values =

    Number S_POWER "Power [%.1f W]" (Light) 	{homematic="id=KEQxxxxxxx,channel=2,parameter=POWER,converter=DoubleDecimalConverter" } 
    Number S_CURRENT "Current [%.1f mA]" (Light) 	{homematic="id=KEQxxxxxxx,channel=2,parameter=CURRENT,converter=DoubleDecimalConverter" } 
    Number S_VOLTAGE "Voltage [%.1f V]" (Light) 	{homematic="id=KEQxxxxxxx,channel=2,parameter=VOLTAGE,converter=DoubleDecimalConverter" } 
    Number S_FREQUENCY "Frequency [%.1f Hz]" (Light) 	{homematic="id=KEQxxxxxxx,channel=2,parameter=FREQUENCY,converter=DoubleDecimalConverter" }

### Dim Actors

Supported Devices:
- HM-LC-Dim2T-SM
- HM-LC-Dim1T-PI
- HM-LC-Dim1T-FM
- HM-LC-Dim1TPBU-FM

Valid parameter keys:
- LEVEL: The energy level (Dimmer, Unit=Percentage, 0%=OFF, 100%=ON)
  
#### = Examples =

    Dimmer LivingRoom_Light_TV	    "Living Room Light TV Level [%d %%]" <rollershutter> (LivingRoom, Light) {homematic="id=GEQ0210158, channel=1, parameter=LEVEL"}
    Dimmer LivingRoom_Light_Sofa    "Living Room Light Sofa Level [%d %%]" <rollershutter> (LivingRoom, Light) {homematic="id=GEQ0210158, channel=2, parameter=LEVEL"}

### Temperature / Humidity Sensors

Supported Devices:
- HM-WDS10-TH-O
- HM-WDS40-TH-I
- HM-CC-TC (Channel 1)

Valid parameter keys: 
- TEMPERATURE: The current temperature (Number, unit=°C)
- SETPOINT (HM-CC-TC only): The target temperature (Number, unit=°C)
- HUMIDITY: The current humidity (Number, Unit=Percentage of humidity, min=0, max=100) or (Dimmer, Unit=Percentage of humidity, min=0%, max=100%)
 
#### = Examples =

    Number LivingRoom_Temperature   "Living Room Temperature [%.1f °C]" <temperature> (LivingRoom, Temperature) {homematic="id=IEQ0022806, channel=1, parameter=TEMPERATURE"}
    Number LivingRoom_Humidity   "Living Room Humidity [%d %%]" <temperature> (LivingRoom, Humidity) {homematic="id=IEQ0022806, channel=1, parameter=HUMIDITY"}
    Number LivingRoom_Temperature_Setpoint   "Living Room Temperature SetPoint [%.1f °C]" <temperature> (LivingRoom, Temperature) {homematic="id=IEQ0022806, channel=2, parameter=SETPOINT"}

### Motion and Brightness Sensors

Supported Devices:
- HM-Sec-MDIR
- HM-Sen-MDIR-O

Valid parameter keys: 
- MOTION: Motion detected (Switch, ON=Motion detected, OFF (default)=NONE)
- BRIGHTNESS: Actual brightness (Dimmer, Unit=Percentage, 0%=dark, 100%=bright) or (Number, Unit=Integer Number, 0=dark, 100=bright)

#### = Examples =


### Water Sensors

Supported Devices:
- HM-Sec-WDS

Valid parameter keys: 
- STATE: The water sensor state
- As Number (Number, 0=no water, 1=humid, 2=water)
- PLANNED: As Switch (Switch, water sensored=Update to ON, no water or just humidity=OFF)

#### = Examples =

    

### 3 State Contact Sensors

Supported Devices:
- HM-Sec-RHS

Valid parameter keys: 
- STATE: The current state of the handle (Number, 0=open, 1=tilted, 2=closed)

#### = Examples =

    

### 2 State Contact Sensors

Supported Devices:
- HM-SCI-3-FM

Valid parameter keys: 
- STATE: The current state of the handle (Number, 0=open, 1=closed)

#### = Examples =

    

### 2 State Contact Sensors (Boolean)

Supported Devices:
- HM-Sec-SC (Wireless door / window contact sensor)

Valid parameter keys: 
- STATE: The current state of the handle (Number, false=open, true=closed)

#### = Examples =

    Contact myWindowContact "Contact" {homematic="id=IEQ000000, channel=1, parameter=STATE"}

### Climate Controls

Supported Devices:
- HM-CC-VD (Actuator)
- HM-CC-TC (Themo Control)

Valid parameter keys: 
- VALVE_STATE: The current state of the valve (Dimmer, Unit=Percentage, 0%=closed, 100%=open) or (Switch, Unit=ON/OFF, OFF=closed, ON=open). Read-only value.

#### = Examples =

    

### Roller Shutter Actors

The roller shutter support is still not really usable. It mainly mapps to the wrong direction: 100% in homematic is 0% in openHAB which makes all widgets very unusable!

Supported Devices:
- HM-LC-Bl1-FM
- HM-LC-Bl1PBU-FM
- HM-LC-Bl1-SM

Valid parameter keys:
- LEVEL: The roller shutter level (Rollershutter, Unit=Percentage, 0%=OPEN, 100%=CLOSED, stop=STOP, move again=MOVE).

NOTE: It is a known bug that the direction is incorrect, i.e. if you move your shutter down, it goes up and vice versa. This is due to the fact that HomeMatic defines 100% as "up" while for openHAB 100% means "down". This will be dealt with in the next release.

#### = Examples =

    Rollershutter LivingRoom_Rollershutter	    "Living Room Roller Shutter Level [%d %%]" <rollershutter> (LivingRoom, Rollershutter) {homematic="id=JEQ0299993, channel=1, parameter=LEVEL"}


### Detect Low Battery

Sensors and actors usually provide a datapoint called LOWBAT which can be used if to bind an item.

#### = Examples =

    Switch Lowbat_GF_Living_Terrace "Empty battery terrace door [%s]" 	<siren> {homematic="id=JEQ1234567, channel=0, parameter=LOWBAT"} 

### Detect unreachable devices

The most sensors and actors are provide a datapoint which becomes true if the device is not reachable (because of a communication issue).

#### = Examples =

    Switch Unreach_GF_Living_Terrace "Terrace door unreachable [%s]" <siren>  {homematic="id=JEQ1234567, channel=0, parameter=UNREACH"}  

### Sabotage of security devices

Some security devices like motion sensors and contact sensors do provide a datapoint which can be used to detect sabotage of this device.

#### = Examples =

    Switch Sabotage_GF_Living_Terrace "Sabotage Terrace [MAP(home.map):Sabotage_%s]" <siren> {homematic="id=JEQ1234567, channel=1, parameter=ERROR"} 