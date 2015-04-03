## Introduction
The B-Control Energy Manager is mostly used in combination with an solar power system to measure the energy and wattage.
B-Control released the specification of the
[JSON](http://www.b-control.com/fileadmin/Webdata/b-control/Uploads/Energiemanagement_PDF/B-control_Energy_Manager_-_JSON-API_0100.pdf)
and the
[Modbus](http://www.b-control.com/fileadmin/Webdata/b-control/Uploads/Energiemanagement_PDF/B-control_Energy_Manager_Modbus_Master.0100.pdf)
interface. With this information, it is possible to get the date an use it with openHAB.

## Get data over JSON
This solution use the exec Binding in combination with an Linux Bash scrip.
Additional are the software tools curl and jq required.
Curl and JQ is in the most Linux distributions included. If jq is not availabel on your Linux distribution,
you can download it from the [project homepage](http://stedolan.github.io/jq/).

The Bash script *bcontrol* read the data over the B-Control Energy Manager JSON interface and write the output to the file bcontrol.out
to the path /opt/bcontrol.  

Before continue with the example, create the folder *bcontrol* in /opt!  

Create the file*bcontrol* and copy the folowing content in it. Make the file executable!  

```
#!/bin/bash
# Script to get data from B-Control Manager over the JSON interface

# path to write JSON output
JsonPath="/opt/bcontrol"

# file name for JSON output
JsonFile="bcontrol.out"

# file Name cookie-file (output of curl)
CookieFile="cookie.txt"

# IP addresse of B-Control manager
BcontrolIP="192.168.1.12"

# build needed path and links
JsonOutput="${JsonPath}/${JsonFile}"
CookiePath="${JsonPath}/${CookieFile}"
JSONLink="http://${BcontrolIP}/mum-webservice/data.php"
LoginLink="${BcontrolIP}/start.php"

# get data (JSON) from B-Control Manager
curl -s -b $CookiePath -X GET $JSONLink > $JsonOutput

# check if login is pass
AuthError=$(/usr/local/bin/jq 'has("authentication")' $JsonOutput)

if [ $AuthError  = "true" ]
then
  echo "Login Error: Login will be repeat!"
  curl -s --cookie-jar $CookiePath $LoginLink > /dev/null
  curl -s -b $CookiePath --cookie-jar $CookiePath -d "login=<serial-no>&password=<password>&save_login=1" $LoginLink > /dev/null
  curl -s -b $CookiePath -X GET $JSONLink > $JsonOutput
fi

# Rueckgabe des gewuenschten Wertes
case "$1" in
	CurrentConsumption)	echo $(/usr/local/bin/jq '.["1-0:1.4.0*255"]' $JsonOutput);;
	CurrentFeeding)		echo $(/usr/local/bin/jq '.["1-0:2.4.0*255"]' $JsonOutput);;
	TotalConsumption)	echo $(/usr/local/bin/jq '.["1-0:1.8.0*255"]' $JsonOutput);;
	TotalFeeding)		echo $(/usr/local/bin/jq '.["1-0:2.8.0*255"]' $JsonOutput);;
	*)			echo "unknown parameter!"
				exit 1;;
esac

exit 0
```  

Please replace <serial-no> with the USER name (default is this the serialnumber), <password> with the password of the B-Control Manager (if no password is set, the let it free) and change the IP Address of the B-Control Manager!  


Now you can test the script without openHAB with command:  
```
/opt/TQManager/bcontrol TotalConsumption
```  

If all is okay, you will get an valid value. You are now able to use the scrit in openHAB.  

To use the script in openHAB, copy the exec Binding to folder addons. In your items file you define the following Number-items.  

```
Number BCM_consumption_wattage		"current wattage consumption [%.1f W]"	{exec="<[/opt/bcontrol/bcontrol@@CurrentConsumption:5000:REGEX((.*?))]"}
Number BCM_feeding_wattage		    "current feeding wattage [%.1f W]"	    {exec="<[/opt/bcontrol/bcontrol@@CurrentFeeding:5000:REGEX((.*?))]"}
Number BCM_energy_value_consumption	"energy value consumption [%.1f Wh]"	{exec="<[/opt/bcontrol/bcontrol@@TotalConsumption:10000:REGEX((.*?))]"}
Number BCM_energy_value_feeding		"energy value feeding [%.1f Wh]"	    {exec="<[/opt/bcontrol/bcontrol@@TotalFeeding:10000:REGEX((.*?))]"}
```


