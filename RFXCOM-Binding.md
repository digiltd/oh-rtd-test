# Documentation of the RFXCOM binding Bundle

# Introduction

Binding should be compatible at least with RFXtrx433 USB 433.92MHz transceiver, which contains both receiver and transmitter functions. 

See further information from http://www.rfxcom.com

RFXCOM binding support currently TemperatureHumidity, Lighting1, Lighting2 and Curtain1 packet types. 

For installation of the binding, please see Wiki page [[Bindings]].

# Binding Configuration

First of all you need to configure the following values in the openhab.cfg file (in the folder '${openhab_home}/configurations').

    ############################### RFXCOM Binding #########################################
    
    # Serial port of RFXCOM interface
    # Valid values are e.g. COM1 for Windows and /dev/ttyS0 or /dev/ttyUSB0 for Linux
    rfxcom:serialPort=
    
    # Set mode command for controller (optional)
    # E.g. rfxcom:setMode=0D000000035300000C2F00000000 
    rfxcom:setMode=

The rfxcom:serialPort value is the identification of the serial port on the host system where RFXCOM controller is connected, e.g. "COM1" on Windows, "/dev/ttyS0" on Linux or "/dev/tty.PL2303-0000103D" on Mac.

The rfxcom:setMode value is is optional. Set mode command can be used to configure RFXCOM controller to listening various receiver protocols. This is very useful because the receiver will become more sensitive when protocols not used are disabled. You can use RFXmngr application to configure controller and get valid configuration command. Command must be 28 characters (14 bytes) hexadecimal string.

# Item Binding Configuration

In order to bind an item to RFXCOM device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items). The syntax of the binding configuration strings accepted is the following:
`    in:  rfxcom="<DeviceId:ValueSelector"
    out: rfxcom=">DeviceId:PacketType.SubType:ValueSelector"

where `DeviceID` is a valid wireless device identifier.

- Lighting1 format: `SensorId.UnitCode`
    e.g. B.1, B.2 or B.G for group functions

- Lighting2 format: `SensorId.UnitCode`
    e.g. 636602.1 

- Curtain1 format: `SensorId.UnitCode`
    e.g. P.1 see RFXCOM documentation

- TemperatureHumidity format: `SensorId`
    e.g. 2561

Examples, how to configure your items:
    Number OutdoorTemperature { rfxcom="<2561:Temperature" }
    Number OutdoorHumidity { rfxcom="<2561:Humidity" }
    Switch Btn1 { rfxcom="<636602.1:Command" }
    Number Btn1SignalLevel { rfxcom="<636602.1:SignalLevel" }
    Dimmer Btn1DimLevel { rfxcom="<636602.1:DimmingLevel" }
    String Btn2RawData { rfxcom="<636602.2:RawData" }
    
    Switch ChristmasTreeLights { rfxcom">636602.1:LIGHTING2.AC:Command" }
    
    Rollershutter CurtainDownstairs { rfxcom=">P.1:CURTAIN1.HARRISON:Shutter" }
    	

	
`PacketType.SubType` specify packet and sub type information ...

<table>
  <tr><td>**PacketType.SubType**</td><td>**Description**</td><td>**ValueSelector**</td></tr>
  <tr><td>LIGHTING1.X10</td><td>Untested</td><td></td></tr>
  <tr><td>LIGHTING1.ARC</td><td>tested and working</td><td>Command</td></tr>
  <tr><td>LIGHTING1.AB400D</td><td>Untested</td><td></td></tr>
  <tr><td>LIGHTING1.WAVEMAN</td><td>Untested</td><td></td></tr>
  <tr><td>LIGHTING1.EMW200</td><td>Untested</td><td></td></tr>
  <tr><td>LIGHTING1.IMPULS</td><td>Untested</td><td></td></tr>
  <tr><td>LIGHTING1.RISINGSUN</td><td>Untested</td><td></td></tr>
  <tr><td>LIGHTING1.PHILIPS</td><td>Untested</td><td></td></tr>
  <tr><td>LIGHTING2.AC</td><td>tested and working</td><td>Command, DimmingLevel</td></tr>
  <tr><td>LIGHTING2.HOME_EASY_EU</td><td>Untested</td><td></td></tr>
  <tr><td>LIGHTING2.ANSLUT</td><td>Untested</td><td></td></tr>
  <tr><td>CURTAIN1.HARRISON</td><td>Harrison curtain rail, e.g. Neta 12</td><td>Shutter</td></tr>
  <tr><td>TEMPERATUREHUMIDITY.THGN122_123_132_THGR122_228_238_268</td><td>Untested</td><td></td></tr>
  <tr><td>TEMPERATUREHUMIDITY.THGN800_THGR810</td><td>Untested</td><td></td></tr>
  <tr><td>TEMPERATUREHUMIDITY.RTGR328</td><td>Untested</td><td></td></tr>
  <tr><td>TEMPERATUREHUMIDITY.THGR328</td><td>Untested</td><td></td></tr>
  <tr><td>TEMPERATUREHUMIDITY.WTGR800</td><td>Untested</td><td></td></tr>
  <tr><td>TEMPERATUREHUMIDITY.THGR918_THGRN228_THGN50</td><td>Untested</td><td></td></tr>
  <tr><td>TEMPERATUREHUMIDITY.TFA_TS34C__CRESTA</td><td>Untested</td><td></td></tr>
  <tr><td>TEMPERATUREHUMIDITY.WT260_WT260H_WT440H_WT450_WT450H</td><td>Untested</td><td></td></tr>
  <tr><td>TEMPERATUREHUMIDITY.VIKING_02035_02038</td><td>Untested</td><td></td></tr>
</table>


`ValueSelector` specify ...

<table>
  <tr><td>**Value selector**</td><td>**Valid OpenHAB data type**</td><td>**Information**</td></tr>
  <tr><td>RawData</td><td>StringItem</td><td></td></tr>
  <tr><td>Command</td><td>SwitchItem</td><td>ON, OFF, GROUP_ON, GROUP_OFF</td></tr>
  <tr><td>SignalLevel</td><td>NumberItem</td><td></td></tr>
  <tr><td>DimmingLevel</td><td>DimmerItem</td><td>UP, DOWN, PERCENTAGE</td></tr>
  <tr><td>Temperature</td><td>NumberItem</td><td></td></tr>
  <tr><td>Humidity</td><td>NumberItem</td><td></td></tr>
  <tr><td>HumidityStatus</td><td>StringItem</td><td></td></tr>
  <tr><td>BatteryLevel</td><td>NumberItem</td><td></td></tr>
  <tr><td>Shutter</td><td>RollershutterItem</td><td>OPEN, CLOSE, STOP</td></tr>
</table>