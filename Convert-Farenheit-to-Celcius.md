The example can be used to convert a fahrenheit temperature value to celcius:
```Xtend
import org.openhab.core.library.types.*
import org.openhab.core.persistence.*
import org.openhab.model.script.actions.*

rule "Convers_Temp_EG"
when
	Item ZwaveTemperatureEGF changed 
then
    var tempFahrenheit = (ZwaveTemperatureEGF.state as DecimalType).doubleValue
	var tempCelsius = (tempFahrenheit -  32)  *  5/9
	postUpdate(ZwaveTemperatureEG, tempCelsius)
end
```