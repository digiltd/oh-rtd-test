# Multiple Items on One Row
The user interface of OpenHAB shows one Item per row and because of this, the number of items that can be shown without needing to scroll, on for example a mobile phone or tablet, can be very limited. Often it would be perfectly possible and may be even desirable to show two or more Items on a single row, e.g. inside and outside temperature, current energy use and total energy usage, and current date and time.

In this example, the sunrise and sunset values calculated by the [Astro binding](https://github.com/openhab/openhab/wiki/Astro-binding) are placed on a single row. This example requires the [Astro action](https://github.com/openhab/openhab/wiki/Actions) and the [Astro binding](https://github.com/openhab/openhab/wiki/Astro-binding) to be installed and configured.

The solution is based on the [this](https://github.com/openhab/openhab/wiki/Samples-Rules#create-text-item-to-combine-two-values-and-format-string-options) example. A more complex example can be found [here.](https://github.com/openhab/openhab/wiki/Rule-example%3A-Combining-different-items)



Items definition:
```xtend
String Sunrise_Sunset  "Sunrise / Sunset [%s]"    <sun>
DateTime Sunrise_Time  "Sunrise [%1$tH:%1$tM]"    <sun>    {astro="planet=sun, type=rise, property=start"}
DateTime Sunset_Time   "Sunset [%1$tH:%1$tM]"     <sun>    {astro="planet=sun, type=set, property=end"}
```
The `Sunrise_Sunset` String item is the item that is used to display both the sunrise and sunset values on a single row. Both the `Sunrise_Time` and `Sunset_Time` DateTime items receive their value (or better, _state_) from either the [Astro action](https://github.com/openhab/openhab/wiki/Actions) or the [Astro binding](https://github.com/openhab/openhab/wiki/Astro-binding).
When the `Sunrise_Time` or `Sunset_Time` item is updated, a rule is triggered which will then update the `Sunrise_Sunset` String item.



Sitemap definition:
```xtend
sitemap default label="Main Menu"
{
    Frame label="Home Automation"
    {
        Text item=Sunrise_Sunset
    }
}
```
The `Sunrise_Sunset` text item will show the sunrise and sunset values.

```xtend
import org.openhab.core.library.types.*
import org.openhab.core.persistence.*
import org.openhab.model.script.actions.*
import org.joda.time.*

////////////////////////////////////////////////////////////////////////////
// Rule:    Initialize system on startup / rule update
// Purpose: Initialize the system
rule "Initialize system on startup / rule update"
when
    System started
then
    var DateTimeType sunrise = new DateTimeType(getAstroSunriseStart(now.toDate, 52.3142, 4.9419))
    var DateTimeType sunset = new DateTimeType(getAstroSunsetStart(now.toDate, 52.3142, 4.9419))
    Sunrise_Time.postUpdate(sunrise)
    Sunset_Time.postUpdate(sunset)
end
```
It can take a while before the [Astro binding](https://github.com/openhab/openhab/wiki/Astro-binding) calculates the sunrise and sunset values after the system is started or when the rule file is updated. Hence, we use the [Astro action](https://github.com/openhab/openhab/wiki/Actions) to immediately calculate these values. (Update the latitude and longitude with your location)


```xtend
////////////////////////////////////////////////////////////////////////////
// Rule:    Sunrise/Sunset changed
// Purpose: Update Sunrise_Sunset string with the updated sunrise and sunset
//          times. The Sunrise_Sunset string is used to display both the
//          sunrise time and sunset time on a single line in the GUI
rule "Sunrise/Sunset changed"
when
    Item Sunrise_Time changed
    or Item Sunset_Time changed
then
    var DateTime sunrise = new DateTime((Sunrise_Time.state as DateTimeType).calendar.timeInMillis)
    var DateTime sunset = new DateTime((Sunset_Time.state as DateTimeType).calendar.timeInMillis)
    Sunrise_Sunset.postUpdate(String::format("%02d:%02d / %02d:%02d", sunrise.getHourOfDay(), sunrise.getMinuteOfHour(), sunset.getHourOfDay(), sunset.getMinuteOfHour()))
end
```
And this is where the magic happens. First, the sunrise and sunset values are converted into a `DateTime` object. This allows us to get the hour and minutes values. Next the `String::format()` function creates a new string that contains both the sunrise and sunset values separated by a slash character. Finally, the `Sunrise_Sunset.postUpdate()` method updates the `Sunrise_Sunset` state and OpenHAB displays the string on the user interface.
