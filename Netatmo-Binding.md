The Netatmo binding integrates the Netatmo Personal Weather Station into openHAB. Its different modules allow you to measure temperature, humidity, air pressure, carbon dioxide concentration in the air, as well as the ambient noise level.

See http://www.netatmo.com/ for details on their product.

# Configuration

* Create an application at http://dev.netatmo.com/dev/createapp

* Retrieve a refresh token from Netatmo API, using e.g. curl:

```
curl -d "grant_type=password&client_id=123456789012345678901234&client_secret=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHI&username=example@example.com&password=example" "http://api.netatmo.net/oauth2/token"
```

* Add client id, client secret and refresh token to openhab.cfg

```
netatmo:refresh=300000
netatmo:clientid=123456789012345678901234
netatmo:clientsecret=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHI
netatmo:refreshtoken=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDE
```

* Configure items and rules

Example item for the **indoor sensor**:
```
Number Netatmo_Indoor_CO2 "Carbon dioxide [%d ppm]" {netatmo="00:00:00:00:00:00#Co2"}
```

Supported are Temperature, Humidity, Co2, Pressure and Noise.  




Example item for the **outdoor sensor** (first id is the device, second id is the module):
```
Number Netatmo_Outdoor_Temperature "Outdoor temperature [%.1f °C]" {netatmo="00:00:00:00:00:00#00:00:00:00:00:00#Temperature"}
```

Supported are Temperature and Humidity for the outdoor modules.  
 



The **rain gauge** supports Rain: (What a surprise!)
```
Number Netatmo_Rain_Gauge "Rain [%d mm]" {netatmo="00:00:00:00:00:00#00:00:00:00:00:00#Rain"}
```
  


**Example rule** to send a mail if carbon dioxide reaches a certain threshold:
```
var boolean co2HighWarning = false
var boolean co2VeryHighWarning = false

rule "Monitor carbon dioxide level"
	when
		Item Netatmo_Indoor_CO2 changed
	then
		if(Netatmo_Indoor_CO2.state > 1000) {
			if(co2HighWarning == false) {
				sendMail("example@example.com",
				         "High carbon dioxide level!",
				         "Carbon dioxide level is " + Netatmo_Indoor_CO2.state + " ppm.")
				co2HighWarning = true
			}
		} else if(Netatmo_Indoor_CO2.state > 2000) {
			if(co2VeryHighWarning == false) {
				sendMail("example@example.com",
				         "Very high carbon dioxide level!",
				         "Carbon dioxide level is " + Netatmo_Indoor_CO2.state + " ppm.")
				co2VeryHighWarning = true
			}
		} else {
			co2HighWarning = false
			co2VeryHighWarning = false
		}
end
```

# Common problems

## Missing Certificate Authority
```
javax.net.ssl.SSLHandshakeException:
sun.security.validator.ValidatorException:
PKIX path building failed:
sun.security.provider.certpath.SunCertPathBuilderException:
unable to find valid certification path to requested target
```

can be solved by installing the StartCom CA Certificate into the local JDK like this:

* Download the certificate from https://www.startssl.com/certs/ca.pem

* Then import it into the keystore (the password is "changeit")
```
$JAVA_HOME/bin/keytool -import -keystore $JAVA_HOME/jre/lib/security/cacerts -alias StartCom-Root-CA -file ca.pem
```

source: http://jinahya.wordpress.com/2013/04/28/installing-the-startcom-ca-certifcate-into-the-local-jdk/

# Sample data

If you want to evaluate this binding but have not got a Netatmo station yourself
yet, you can add the Netatmo office in Paris to your account:

http://www.netatmo.com/en-US/addguest/index/TIQ3797dtfOmgpqUcct3/70:ee:50:00:02:20

# Icons
The following icons are used by original Netatmo web app:

http://my.netatmo.com/img/my/app/module_int.png
http://my.netatmo.com/img/my/app/module_ext.png

http://my.netatmo.com/img/my/app/battery_verylow.png
http://my.netatmo.com/img/my/app/battery_low.png
http://my.netatmo.com/img/my/app/battery_medium.png
http://my.netatmo.com/img/my/app/battery_high.png
http://my.netatmo.com/img/my/app/battery_full.png

http://my.netatmo.com/img/my/app/signal_verylow.png
http://my.netatmo.com/img/my/app/signal_low.png
http://my.netatmo.com/img/my/app/signal_medium.png
http://my.netatmo.com/img/my/app/signal_high.png
http://my.netatmo.com/img/my/app/signal_full.png

http://my.netatmo.com/img/my/app/wifi_low.png
http://my.netatmo.com/img/my/app/wifi_medium.png
http://my.netatmo.com/img/my/app/wifi_high.png
http://my.netatmo.com/img/my/app/wifi_full.png