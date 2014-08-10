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

In order to bind an item to a Koubachi resource query you need to provide configuration settings. The easiest way to do this is to add some binding information in your item file (in the folder configurations/items`). The syntax for the NTP binding configuration string is as follows:

    koubachi="<device | plant>:<resourceId>:<propertyName>"

Here are some examples for valid binding configuration strings:

    device:00066680190e:virtualBatteryLevel
    device:00066680190e:nextTransmission
    plant:129892:vdmMistLevel
    plant:129892:vdmWaterInstruction

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

As a result, your lines in the items file might look like as follows:

    DateTime	Device_00066680190e_AssociatedSince	"Assoc. since [%1$td.%1$tm.%1$tY %1$tT]"	<grass>	(Device_00066680190e)	{ koubachi="device:00066680190e:associatedSince" }
    String		Device_00066680190e_Soilmoisture	"Soilmoisture [%s]"				<grass>	(Device_00066680190e)	{ koubachi="device:00066680190e:recentSoilmoistureReadingValue" }
    String		Device_00066680190e_Temperature		"Temperature [%s]"				<grass>	(Device_00066680190e)	{ koubachi="device:00066680190e:recentTemperatureReadingValue" }
    String		Hortensie_Name				"Name [%s]"					<grass>	(Hortensie)		{ koubachi="plant:129892:name" }	
    Number		Hortensie_Mist_Level			"Mist Level [%.2f]"				<grass>	(Hortensie)		{ koubachi="plant:129892:vdmMistLevel" }	
    Number		Hortensie_Water_Level			"Water Level [%.2f]"				<grass>	(Hortensie)		{ koubachi="plant:129892:vdmWaterLevel" }	


