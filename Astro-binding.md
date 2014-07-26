### News
Public 1.6.0 builds  
[Release Notes](#release-notes-160)  
[Download](#download)

### Introduction

The Astro binding is used for:
- calculating the sunrise, noon and sunset time
- scheduling of events at sunrise, noon and sunset
- calculating the azimuth and elevation (e.g. for auto shading with RollerShutter, ...)

### Configuration in openhab.cfg
```
############################## Astro Binding ##############################
#
# Your latitude
astro:latitude=nn.nnnnnn
 
# Your longitude
astro:longitude=nn.nnnnnn
 
# Refresh interval for azimuth and elevation calculation in seconds (optional, defaults to disabled)
astro:interval=nnn
```

### Available Items
```
Number   Azimuth        "Azimuth [%.2f]"         {astro="type=AZIMUTH"}
Number   Elevation      "Elevation [%.2f]"       {astro="type=ELEVATION"}

DateTime Sunrise_Time   "Sunrise [%1$tH:%1$tM]"  {astro="type=SUNRISE_TIME"}
DateTime Noon_Time      "Noon [%1$tH:%1$tM]"     {astro="type=NOON_TIME"}
DateTime Sunset_Time    "Sunset [%1$tH:%1$tM]"   {astro="type=SUNSET_TIME"}

Switch   Sunrise_Event                           {astro="type=SUNRISE"}
Switch   Noon_Event                              {astro="type=NOON"}
Switch   Sunset_Event                            {astro="type=SUNSET"}
```

The Azimuth and Elevation items are updated at the configured refresh interval in openhab.cfg.

At midnight, the sunrise, noon and sunset time is calculated, published and the event jobs are scheduled. The sunrise, noon and sunset Switches are updated with ON followed by a OFF at the calculated time.

### Example Rules
Rule at sunrise:
```
rule "Example Rule at sunrise"
when
    Item Sunrise_Event received update ON
then
    ...
end
```

Rule to close all RollerShutters after sunset and the outside temperature is lower than 5 degrees:
```
rule "Close RollerShutters if cold after sunset"
when
    Item Temp_Outside changed
then
    if (now.isAfter((Sunset_Time.state as DateTimeType).calendar.timeInMillis) &&
       (Temp_Outside.state as DecimalType).intValue < 5) {
		
       RollerShutters?.members.forEach(r | sendCommand(r, DOWN))

    }
end
```

Let's say, you know that the sun is shining through your livingroom window between Azimuth 100 and 130. If it's summer you want to close the RollerShutter.
```
rule "Autoshading RollerShutter"
when
    Item Azimuth changed
then
    var int azimuth = (Azimuth.state as DecimalType).intValue
	
    if (azimuth > 100 && azimuth < 130) {
      sendCommand(Rollershutter_Livingroom, DOWN)
    }

    ...
end
```
## Release Notes 1.6.0
All sun calculations are now based on those of http://www.suncalc.net/  

**New item binding style!** The old style is still supported, but a warning is written to the log.
```
{astro="planet=..., type=..., property=..., offset=..."}
```
**Important:** type and property are case sensitive! So enter the values exactly as shown.

### Description  
**planet**  
currently only `sun` ist available, more to come

**type**: `rise, set, noon, night, morningNight, astroDawn, nauticDawn, civilDawn, astroDusk, nauticDusk, civilDusk, eveningNight, daylight`  
- **property**: `start, end` (DateTime), `duration` (Number)

**type**: `position`
- **property**: `azimuth, elevation` (Number)

**type**: `zodiac`
- **property**: `start, end` (DateTime), `sign` (String)

**type**: `season`
- **property**: `spring, summer, autumn, winter` (DateTime), `name` (String)

**offset** (optional, taken into account for every DateTime property)  
offset in minutes to the calculated time

You can bind a property to different item types, which has a special meaning in the binding. If you bind a DateTime property (start, end) to a DateTime Item, the DateTime is simply displayed. If you bind it to a Switch, a event is scheduled and the state of the Switch is updated to ON, followed by a OFF at the calculated time. You can even specify a offset for the event and bind multiple items to the same property.

**Examples:**  
```
// shows the sunrise
DateTime Sunrise_Time  "Sunrise [%1$tH:%1$tM]"  {astro="planet=sun, type=rise, property=start"}

// schedules a event which starts at sunrise, updating the Switch with ON, followed by a OFF
Switch Sunrise_Event   {astro="planet=sun, type=rise, property=start"}

// schedules a event which starts 10 minutes AFTER sunrise
Switch Sunrise_Event   {astro="planet=sun, type=rise, property=start, offset=10"}

// schedules a event which starts 10 minutes BEFORE sunrise
Switch Sunrise_Event   {astro="planet=sun, type=rise, property=start, offset=-10"}

// shows the sunset
DateTime Sunset_Time   "Sunset [%1$tH:%1$tM]"   {astro="planet=sun, type=set, property=end"}

// schedules a event which starts 30 minutes BEFORE sunset:
Switch Sunset_Event    {astro="planet=sun, type=set, property=end, offset=-30"}

// displays the start, end and duration of the astroDawn
DateTime Astro_Dawn_Start        "Astro Dawn Start [%1$tH:%1$tM]"  {astro="planet=sun, type=astroDawn, property=start"}
DateTime Astro_Dawn_End          "Astro Dawn End [%1$tH:%1$tM]"    {astro="planet=sun, type=astroDawn, property=end"}
// duration in minutes
Number   Astro_Dawn_Duration     "Astro Dawn Duration [%f]"        {astro="planet=sun, type=astroDawn, property=duration"}
// duration formatted to a string, e.g. 02:32 (2 hours, 32 minutes)
String   Astro_Dawn_Duration_Str "Astro Dawn Duration [%s]"        {astro="planet=sun, type=astroDawn, property=duration"}


// azimuth and elevation
Number   Azimuth        "Azimuth [%.2f]"     {astro="planet=sun, type=position, property=azimuth"}
Number   Elevation      "Elevation [%.2f]"   {astro="planet=sun, type=position, property=elevation"}


// zodiac
DateTime Zodiac_Start   "Zodiac Start [%1$td.%1$tm.%1$ty]"   {astro="planet=sun, type=zodiac, property=start"}
DateTime Zodiac_End     "Zodiac End [%1$td.%1$tm.%1$ty]"     {astro="planet=sun, type=zodiac, property=end"}
String   Zodiac_Sign    "Current zodiac [%s]"                {astro="planet=sun, type=zodiac, property=sign"}


// season
String Season_Name      "Season [%s]"                             {astro="planet=sun, type=season, property=name"}
DateTime Season_Spring  "Spring [%1$td.%1$tm.%1$ty %1$tH:%1$tM]"  {astro="planet=sun, type=season, property=spring"}
DateTime Season_Summer  "Summer [%1$td.%1$tm.%1$ty %1$tH:%1$tM]"  {astro="planet=sun, type=season, property=summer"}
DateTime Season_Autumn  "Autumn [%1$td.%1$tm.%1$ty %1$tH:%1$tM]"  {astro="planet=sun, type=season, property=autumn"}
DateTime Season_Winter  "Winter [%1$td.%1$tm.%1$ty %1$tH:%1$tM]"  {astro="planet=sun, type=season, property=winter"}
```

If you like to have the season name and the zodiac sign in your own language, use a map.  
Example for german translation:
```
String Zodiac_Sign_Ger "Sternzeichen [MAP(zodiac.map):%s]"  	{astro="planet=sun, type=zodiac, property=sign"}
String Season_Name_Ger "Jahreszeit [MAP(season.map):%s]"        {astro="planet=sun, type=season, property=name"}
```
**zodiac.map**  
```
Aries=Widder
Taurus=Stier
Gemini=Zwilling
Cancer=Krebs
Leo=Löwe
Virgo=Jungfrau
Libra=Waage
Scorpio=Skorpion
Sagittarius=Schütze
Capricorn=Steinbock
Aquarius=Wassermann
Pisces=Fisch
```
**season.map**  
```
Spring=Frühling
Summer=Sommer
Autumn=Herbst
Winter=Winter
```

### Download
These builds are BETA versions, work in progress, testers welcome!  
**26.07.2014 pb03:**  download coming soon
* Added zodiac calculation.
* Added season calculation.

**23.07.2014 pb02:** [download binding](https://drive.google.com/file/d/0Bw7zjCgsXYnHY1d3NFU5aHlwWTg/edit?usp=sharing)
* initial public 1.6.0 build (works in openHab 1.5.x too).