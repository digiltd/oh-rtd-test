Documentation of the MAX!Cube Binding Bundle

## Introduction

The openHAB MAX!Cube binding allows to connect to [ELV MAX!Cube Lan Gateway](http://www.elv.de/max-cube-lan-gateway.html,) installations. The binding allows to communicate with the MAX! devices through the MAX!Cube Lan Gateway.

To communicate with MAX! devices, a already setup MAX! environment including a MAX!Cube Lan Gateway is required. In addition, the binding expects an already set up MAX environment.

## MAX!Cube Binding Configuration

No configuration is required in basic setting. The MaxCube is automatically discovered from the network.
You can configure the MAX!Cube Lan Gateway IP address in the openhab.cfg file. 
If not configured via DHCP, the factory default address of the MAX!Cube is 192.168.0.222.

    ################################ MAX!Cube Binding ##########################################
    #
    # MAX!Cube LAN gateway IP address 
    # maxcube:ip=192.168.0.222
    # MAX!Cube port (Optional, default to 62910)
    # maxcube:port=62910
    # MAX!Cube refresh interval in ms (Optional, default to 10000)
    # maxcube:refreshInterval=10000

Additional you can configure the port the MAX!Cube communicates with openHAB. By default this is 62910 and should not need to be changed.

Furthermore, you can change the refresh interval openHAB communicates with the MAX!Cube. By default the refresh interval is set to 10 seconds. 

## Item Configuration

In order to bind an generic item to the device, you need to provide MAX!Cube configuration settings in your item file (in the folder configurations/items) containing at least the serial number of the device. The syntax of the binding configuration strings accepted is the following: 

    maxcube="<serialNumber>"

The state of a shutter contact can be retrieved via the generic item binding. To display the shutter state, you need to use a Contact item.

    Contact Office_Window "Office Window [MAP(en.map):%s]" (MyGroup) { maxcube="JEQ0650337" }

For a heating thermostat, an identical configuration will provide the setpoint temperature of the heating thermostat (4.5° corresponds to OFF shown on the thermostat display). To show the temperature setpoint you need to use a number item.

    Number Heating_Max "Heating Thermostat [%.1f °C]" (MyGroup) { maxcube="JEQ0336148" }

The above examples would be shown as 

![MAX! Binding](https://dl.dropboxusercontent.com/u/7347332/web/maxcube.png)

MAX heating thermostat devices show OFF when turned to the minimum or On when turned to the maximum. The openHAB MAX!Cube binding would show the values 4.5 for OFF and 30.5 for On instead. 

If you would like to display OFF and on instead, you can apply a mapping and  change the binding using this mapping to 

    Number Heating_Max "Heating Thermostat [MAP(maxcube.map):%s]" (MyGroup) { maxcube="JEQ0336148" }

Instead of values 4.5 and 30.5 the results would look like

![MAX! Binding](https://dl.dropboxusercontent.com/u/7347332/web/max_on_off_small.png)

To apply this mapping you need to copy the [maxcube.map](https://dl.dropboxusercontent.com/u/7347332/web/maxcube.map) mapping file into the configuration/transformation folder within the openHAB directory. (Alternatively you can use this [maxcube.map](http://www.domorino.nl/drupal/?q=node/6) file when the mappings of round temperature settings don't show.)

Depending on the correpsonding device the MAX!Cube binding can be used to provide specific information about a device instead of the default information.

To receive the valve position of a heating thermostat, the type for the desired information needs to be specified in the bonding configuration

    Number Heating_Max_Valve "Thermostat Valve Position [%.1f %%]" (MyGroup) { maxcube="JEQ0336148:type=valve" }

![MAX! Binding Valve Position](https://dl.dropboxusercontent.com/u/7347332/web/max_valve.png)

The battery state of a device can be requested using the _battery_ type in the corresponding binding configuration. 

    String Heating_Max_Valve "Thermostat Battery [%s]" (MyGroup) { maxcube="JEQ0336148:type=battery" }

![MAX! Binding Battery State](https://dl.dropboxusercontent.com/u/7347332/web/max_battery.png)

String values returned by the binding are either _ok_ or _low_.

In order to be able to set a thermostat (and thus sending a temperature setting to an individual thermostat) use the Setpoint item in your sitemap configuration:

    Setpoint item=Heating_Max_Valve step=0.5 minValue=18 maxValue=30

This SetPoint item will allow a user to set the thermostat with 0.5 degrees intervals. If you would like to set the thermostat yourself, for instance in a rule, use the sendCommand option in your rules file, like in the following example:

     rule "Bedtime"
     when
        Time cron "0 0 23 * * ?"
     then
        sendCommand (Heating_Max_Valve, 15 )
     end

To receive the valve position of a heating thermostat, the type for the desired information needs to be specified in the bonding configuration

per release 1.6 (currently found via the Jenkins/cloudbees snapshots) you can request the actual temperature for the WallThermostat. The actual temperature can also be requested from the heating Thermostats, however  is usually outdated for the radiator thermostats, since they only send it over when their valve position changes. For the Wall thermostats, the value is accurate, since those send updates every couple of minutes

    Number Heating_Max_Temp "Thermostat Temperature  [%.1f °C]" (MyGroup) { maxcube="JEQ0336148:type=actual" }