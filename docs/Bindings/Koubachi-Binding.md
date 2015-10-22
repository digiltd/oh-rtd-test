Documentation of the Koubachi binding bundle

## Introduction

The [Koubachi](http://www.koubachi.com) Services help everybody without a green thumb to be a perfect gardener. All plants can be registered on their really nice website (or through iPhone/iPad App) to tell you when and how to care for your plants. Furthermore they offer a dedicated hardware, the WIFI Plant Sensor. This wireless device measures vital parameters and determines the vitality of your plants.

Koubachis' slogan "give your plants a voice" becomes reality with this binding. It queries all relevant data through Koubachi's [webservice](http://labs.koubachi.com) and pushes it into openHAB.

For installation of the binding, please see Wiki page [[Bindings]].

## Registration

Before using the Koubachi services one has to register free of charge at [Koubachi-Labs](http://labs.koubachi.com) website for API access. Once the account is created the credentials and personal appKey can be obtained from the portal. Both values have to be specified in openhab.cfg.

## Binding Configuration

### openhab.cfg

The following config parameters have to be set for using Koubachi binding:

- (optional) koubachi:refresh - The refresh interval in milliseconds. Defaults to 900000ms (which equals to 15 minutes)
- (optional) koubachi:deviceurl - The Koubachi API URL of the device list. Defaults to  '`https://api.koubachi.com/v2/user/smart_devices?user_credentials=%1$s&app_key=%2$s`'
- (optional) koubachi:planturl - The Koubachi API URL of the plant list. Defaults to  '`https://api.koubachi.com/v2/plants?user_credentials=%1$s&app_key=%2$s`'
- koubachi:credentials - The single access token configured obtained from http://labs.koubachi.com
- koubachi:appkey - The personal appKey obtained from http://labs.koubachi.com

### Example

    ################################ Koubachi Binding #####################################
    
    # The single access token obtained from http://labs.koubachi.com
    koubachi:credentials=fMWNa6uR-KJtoidLe11k
    
    # The personal appKey obtained from http://labs.koubachi.com
    koubachi:appkey=KLABPLQP365CNQRIG0HY2DEX

## Generic Item Binding Configuration

In order to bind an item to a Koubachi resource query you need to provide configuration settings. The easiest way to do this is to add some binding information in your item file (in the folder configurations/items`). The syntax for the Koubachi binding configuration string is as follows:

    koubachi="<device | plant>:<resourceId>:<propertyName>"

You can also bind to the action types in the Koubachi API using the keyword "action" and then the action type.

    koubachi="plant:<resourceId>:action:<actionType>"

What actions can actually be performed on a specific plant depends on the type of Koubachi device used.

Here are some examples for valid binding configuration strings:

    device:00066680190e:virtualBatteryLevel
    device:00066680190e:nextTransmission
    plant:129892:vdmMistLevel
    plant:129892:vdmWaterInstruction
    plant:129892:action:mist.performed

### Valid property names are

#### for Device Resource type

- virtualBatteryLevel (Number)
- ssid (String)
- hardwareProductType (String)
- lastTransmission (!DateTime)
- nextTransmission (!DateTime)
- associatedSince (!DateTime)
- recentSoilmoistureReadingValue (String)
- recentSoilmoistureReadingTime (!DateTime)
- recentTemperatureReadingValue (String)
- recentTemperatureReadingTime (!DateTime)
- recentLightReadingValue (String)
- recentLightReadingTime (!DateTime)

#### for Plant Resource type

- name (String)
- location (String)
- lastFertilizerAt (!DateTime)
- nextFertilizerAt (!DateTime)
- lastMistAt (!DateTime)
- nextMistAt (!DateTime)
- lastWaterAt (!DateTime)
- nextWaterAt (!DateTime)
- vdmWaterInstruction (String)
- vdmWaterLevel (Number)
- vdmMistInstruction (String)
- vdmMistLevel (Number)
- vdmFertilizerInstruction (String)
- vdmFertilizerLevel (Number)
- vdmTemperatureHint (String)
- vdmTemperatureInstruction (String)
- vdmTemperatureLevel (Number)
- vdmLightHint (String)
- vdmLightInstruction (String)
- vdmLightLevel (Number)

#### Plant actions

- calibration.watered (Switch)
- calibration.is_dry (Switch)
- calibration.is_not_dry (Switch)
- calibration.restarted (Switch)
- water.performed (Switch)
- mist.skipped (Switch)
- mist.performed (Switch)
- fertilize.skipped (Switch)
- fertilize.performed (Switch)
- put_into_light.performed (Switch)
- put_into_shade.performed (Switch)
- heat_plant.performed (Switch)
- cool_plant.performed (Switch)

As a result, your lines in the items file might look like as follows:

    DateTime	Device_00066680190e_AssociatedSince	"Assoc. since [%1$td.%1$tm.%1$tY %1$tT]"	<grass>	(Device_00066680190e)	{ koubachi="device:00066680190e:associatedSince" }
    String		Device_00066680190e_Soilmoisture	"Soilmoisture [%s]"				<grass>	(Device_00066680190e)	{ koubachi="device:00066680190e:recentSoilmoistureReadingValue" }
    String		Device_00066680190e_Temperature		"Temperature [%s]"				<grass>	(Device_00066680190e)	{ koubachi="device:00066680190e:recentTemperatureReadingValue" }
    String		Hortensie_Name				"Name [%s]"					<grass>	(Hortensie)		{ koubachi="plant:129892:name" }	
    Number		Hortensie_Mist_Level			"Mist Level [%.2f]"				<grass>	(Hortensie)		{ koubachi="plant:129892:vdmMistLevel" }	
    Number		Hortensie_Water_Level			"Water Level [%.2f]"				<grass>	(Hortensie)		{ koubachi="plant:129892:vdmWaterLevel" }	
    Switch		Hortensie_Fertilized			"Fertilization done"				<grass>	(Hortensie)		{ koubachi="plant:129892:action:fertilize.performed" }	

## Example Rules

### Koubachi remind the water level 

To remind you to give your plant water use the following rule.
First need the water level Item and some block Item to don't spam your self.

Items


      String plant1_Water_Level "Water Level [%s]" <grass> (gPL) { koubachi="device:00066672ef98:recentSoilmoistureReadingValue" }
      Switch plantbswitch90 (gPL)
      Switch plantbswitch80 (gPL)
      Switch plantbswitch70 (gPL)
      Switch plantbswitch60 (gPL)
      Switch plantbswitch50 (gPL)
      Switch plantbswitch40 (gPL)
      Switch plantbswitch30 (gPL)

Following this two rules 


Rules

        rule "water level"

        when 

        Item plant1_Water_Level received update
 
        then
	
	var level = plant1_Water_Level.state
	
	if (plant1_Water_Level.state.toString.matches("9. %") && plantbswitch90.state == OFF{
	sendMail("my@mail.de", "Zamioculcas_zamiifolia", "I am well!My water level is " + level,           "http://192.168.177.138/flower1.jpg")
	sendCommand(plantbswitch90, ON)
	sendCommand(plantbswitch80, OFF)
	sendCommand(plantbswitch70, OFF)
	sendCommand(plantbswitch60, OFF)
	sendCommand(plantbswitch50, OFF)
	sendCommand(plantbswitch40, OFF)
	sendCommand(plantbswitch30, OFF)
	}
	
	if (plant1_Water_Level.state.toString.matches("8. %") && plantbswitch80.state == OFF ){
	sendMail("my@mail.de", "Zamioculcas_zamiifolia", "I am still well! My water level is " + level ,"http://192.168.177.138/flower1.jpg")
	sendCommand(plantbswitch80, ON)
	sendCommand(plantbswitch90, OFF)
	}
	
	if (plant1_Water_Level.state.toString.matches("7. %") && plantbswitch70.state == OFF ){
	sendMail("my@mail.de", "Zamioculcas_zamiifolia", "I am still well!My water level is "  + level ,"http://192.168.177.138/flower1.jpg")
	sendCommand(plantbswitch70, ON)
	}
	
	if (plant1_Water_Level.state.toString.matches("6. %") && plantbswitch60.state == OFF ){
	sendMail("my@mail.de", "Zamioculcas_zamiifolia", "I am still well!My water level is " + level ,"http://192.168.177.138/flower1.jpg")
	sendCommand(plantbswitch60, ON)
	}
	
	if (plant1_Water_Level.state.toString.matches("5. %") && plantbswitch50.state == OFF ){
	sendMail("my@mail.de", "Zamioculcas_zamiifolia", "Next I need water!My water level is " + level ,"http://192.168.177.138/flower1.jpg")
	sendCommand(plantbswitch50, ON)
	}
	
	if (plant1_Water_Level.state.toString.matches("4. %") && plantbswitch40.state == OFF ){
	sendMail("my@mail.de", "Zamioculcas_zamiifolia", "I need water! Please give me water. My water level is"  + level ,"http://192.168.177.138/flower1.jpg")
	sendCommand(plantbswitch40, ON)
	}
	 
	if (plant1_Water_Level.state.toString.matches("3. %") && plantbswitch30.state == OFF ){
	sendMail("my@mail.de", "Zamioculcas_zamiifolia", "I realy need water! Please give me water ore i will        di.  My water level is "  + level ,"http://192.168.177.138/flower1.jpg")
	sendCommand(plantbswitch30, ON)
	}
	
	
        end

        rule "set switch to off at start"

        when

	System started

        then
	
	sendCommand(plantbswitch90, OFF)
	sendCommand(plantbswitch80, OFF)
	sendCommand(plantbswitch70, OFF)
	sendCommand(plantbswitch60, OFF)
	sendCommand(plantbswitch50, OFF)
	sendCommand(plantbswitch40, OFF)
	sendCommand(plantbswitch30, OFF)
        end