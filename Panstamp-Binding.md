Documentation of the Panstamp binding Bundle

## Introduction

This is a simple openhab wrapper for the panstamp library found here: https://github.com/GideonLeGrange/panstamp-java
the current panstamp java library used in the binding is V1.2.
binding support currently ##### packet types.

For installation of the binding, please see Wiki page [[Bindings]].

## Binding Configuration

First of all you need to configure the following values in the openhab.cfg file (in the folder '${openhab_home}/configurations').

    ################################ Panstamp Binding #######################################

    # Serial port of Panstamp interface
    # Valid values are e.g. COM1 for Windows and /dev/ttyS0 or /dev/ttyUSB0 for Linux
    panstamp:port=COM12

    # Port Control at startup
    panstamp:setportstatus=open

    # Local device library location
    #panstamp:devicelibrary=f:\panstamp\definitions

    # Remote device library location
    #panstamp:httpLibrary=https://raw.githubusercontent.com/panStamp/panstamp/master/devices/

The panstamp:port  value is the identification of the serial port on the host system where panstamp controller is connected, e.g. "COM2" on Windows,"/dev/ttyS0" on Linux or "/dev/tty.PL2303-0000103D" on Mac.

NOTE: On Linux, should the panstamp device be added to the dialout group, you may get an error stating the the serial port cannot be opened when the panstamp plugin tries to load. You can get around this by adding the openhab user to the dialout group like this:usermod -a -G dialout openhab.

The panstamp:setportstatus value is optional. panstamp:setportstatus mode command can be used to configure panstamp controller to open the serial port at startup or close. If not set, the user will have to configure an item to be the port controller.

The panstamp:devicelibrary value will configure the panstamp controller to look for extra device definition files in this folder.

The panstamp:httpLibrary value will configure the panstamp controller to look for device definition files at the remote location.

## Item Binding Configuration

In order to bind an item to a Panstamp device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items). The syntax of the binding configuration strings accepted is the following:

    panstamp= "<Manufacturer ID>: <Product ID>: <Device ID Address>: <Register>: <Endpoint Name (as in DDF)>: <Endpoint Type>: <Openhab Item Type>: <Endpoint Unit of measurement>"

where:
- Manufacturer ID: refers to the Panstamp developer ID.<developer id="1" name="panStamp">

- Product ID: refers to the Panstamp Product ID. e.g. <dev id="6" name="bininps" label="Binary/Counter input module"/>

- Device ID Address: refers to the standard Panstamp RF ID. e.g. 

- Register: refers to the specific register value of the panstamp device. e.g <reg name="Binary states" id="12">

- Endpoint Name: refers to the Endpoint name as specified in the device definition file of the device type. e.g <endpoint name="Binary 1" type="bin" dir="inp">

- Endpoint Type: refers to the Endpoint type as specified in the device definition file of the device type. e.g <endpoint name="Binary 1" type="bin" dir="inp">

- Openhab Item Type: refers to the type of openhab item the endpoint will be bound to. 

- Endpoint Unit of measurement: refers to the specific unit of measurement the user is interested in as specified in the device definition file. e.g <unit name="V" factor="0.001" offset="0"/>

Examples, how to configure your items:

    Switch PanGatewayOpenClose        "Panstamp Port Switch"                                         (Panstamp)    { panstamp = "controller" }

    /* Temperature Sensor */
    Number PanTempVoltage    "Voltage  [%.2f V]"      (PanTemp)       { panstamp = "1:1:20:11:Voltage:0:6:-" }     //"Device ID Address:Register:Endpoint Name (as in DDF)"
    Number PanTempTemp       "Temperature  [%.1f C]"      (PanTemp)   { panstamp = "1:1:20:12:Temperature:0:6:-" }
    Number PanTempHumidity   "Humidity  [%d ]"       (PanTemp)  { panstamp = "1:1:20:12:Humidity:0:6:-" } 
    //Number PanTempTemp       "Temperature  [%.2f F]"      (PanTemp)   { panstamp = "1:1:255:12:Temperature:0:6:F" }
    //Number PanTempTemp       "Temperature  [%.2f K]"      (PanTemp)   { panstamp = "1:1:255:12:Temperature:0:6:K" }

    //Panstsamp configuration - "Manufacturer ID: Product ID: Device ID Address: Register: Endpoint Name (as in DDF): Endpoint Type: Openhab Item Type"
    /* Binary Inputs */
    Number PaninputVoltage     "Voltage [%.1f mV]"  (PanBinIn)    { panstamp = "1:6:22:12:Voltage:0:6:-" }
    Switch PaninputSw1         "Input 1"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 0:1:0:-" }
    Switch PaninputSw2         "Input 2"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 1:1:0:-" }
    Switch PaninputSw3         "Input 3"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 2:1:0:-" }
    Switch PaninputSw4         "Input 4"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 3:1:0:-" }
    Switch PaninputSw5         "Input 5"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 4:1:0:-" }
    Switch PaninputSw6         "Input 6"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 5:1:0:-" }
    Switch PaninputSw7         "Input 7"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 6:1:0:-" }
    Switch PaninputSw8         "Input 8"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 7:1:0:-" }
    //Contact PaninputSw2             "Input 2"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 1:1:2" }
    //Rollershutter PaninputSw3       "Input 3"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 2:1:3" }
    //Dimmer PaninputSw4       "Input 4"                  (PanBinIn)    { panstamp = "1:6:22:12:Binary 3:1:1" }

                                                                                                        
    //Panstsamp configuration - "Manufacturer ID: Product ID: Device ID Address: Register: Endpoint Name (as in DDF)"
    /* Relay Output Board */
    Switch PanRelay1           "Output 1"           (PanBinOut)   { panstamp = "1:7:21:11:Binary 0:1:0:-" }
    Switch PanRelay2           "Output 2"           (PanBinOut)   { panstamp = "1:7:21:11:Binary 1:1:0:-" }
    Switch PanRelay3           "Output 3"           (PanBinOut)   { panstamp = "1:7:21:11:Binary 2:1:0:-" }
    Switch PanRelay4           "Output 4"           (PanBinOut)   { panstamp = "1:7:21:11:Binary 3:1:0:-" }
    Switch PanRelay5           "Output 5"           (PanBinOut)   { panstamp = "1:7:21:11:Binary 4:1:0:-" }
    Switch PanRelay6           "Output 6"           (PanBinOut)   { panstamp = "1:7:21:11:Binary 5:1:0:-" }
    Switch PanRelay7           "Output 7"           (PanBinOut)   { panstamp = "1:7:21:11:Binary 6:1:0:-" }
    Switch PanRelay8           "Output 8"           (PanBinOut)   { panstamp = "1:7:21:11:Binary 7:1:0:-" }
