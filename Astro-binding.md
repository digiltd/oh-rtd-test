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
* **planet** `sun`
    * **type** `rise, set, noon, night, morningNight, astroDawn, nauticDawn, civilDawn, astroDusk, nauticDusk, civilDusk, eveningNight, daylight`
        * **property** `start, end` (DateTime), `duration` (Number)
    * **type** `position`
        * **property** `azimuth, elevation` (Number)
    * **type** `zodiac`
        * **property** `start, end` (DateTime), `sign` (String)
    * **type** `season`
        * **property**: `spring, summer, autumn, winter` (DateTime), `name` (String)
    * **type** `eclipse`
        * **property**: `total, partial, ring` (DateTime)
* **planet** `moon`
    * **type** `rise, set`
        * **property** `start, end` (DateTime), `duration` (Number), **Note:** start and end is always equal, duration always 0.
    * **type** `phase`
        * **property**: `firstQuarter, thirdQuarter, full, new` (DateTime), `age, illumination` (Number), `name` (String)
    * **type** `eclipse`
        * **property**: `total, partial` (DateTime)
    * **type** `distance`
        * **property**: `date` (DateTime), `kilometer, miles` (Number)
    * **type** `perigee`
        * **property**: `date` (DateTime), `kilometer, miles` (Number)
    * **type** `apogee`
        * **property**: `date` (DateTime), `kilometer, miles` (Number)

**offset** (optional, taken into account for every DateTime property)  
offset in minutes to the calculated time

You can bind a property to different item types, which has a special meaning in the binding. If you bind a DateTime property (start, end, ...) to a DateTime Item, the DateTime is simply displayed. If you bind it to a Switch, a event is scheduled and the state of the Switch is updated to ON, followed by a OFF at the calculated time. You can even specify a offset for the event and bind multiple items to the same property.

###Sun examples
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
DateTime Zodiac_Start   "Zodiac Start [%1$td.%1$tm.%1$tY]"   {astro="planet=sun, type=zodiac, property=start"}
DateTime Zodiac_End     "Zodiac End [%1$td.%1$tm.%1$tY]"     {astro="planet=sun, type=zodiac, property=end"}
String   Zodiac_Sign    "Current zodiac [%s]"                {astro="planet=sun, type=zodiac, property=sign"}


// season
String Season_Name      "Season [%s]"                             {astro="planet=sun, type=season, property=name"}
DateTime Season_Spring  "Spring [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"  {astro="planet=sun, type=season, property=spring"}
DateTime Season_Summer  "Summer [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"  {astro="planet=sun, type=season, property=summer"}
DateTime Season_Autumn  "Autumn [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"  {astro="planet=sun, type=season, property=autumn"}
DateTime Season_Winter  "Winter [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"  {astro="planet=sun, type=season, property=winter"}


// eclipse
DateTime Sun_Eclipse_Total   "Sun total eclipse [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"   {astro="planet=sun, type=eclipse, property=total"}
DateTime Sun_Eclipse_Partial "Sun partial eclipse [%1$td.%1$tm.%1$tY %1$tH:%1$tM]" {astro="planet=sun, type=eclipse, property=partial"}
DateTime Sun_Eclipse_Ring    "Sun ring eclipse [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"    {astro="planet=sun, type=eclipse, property=ring"}
```

###Moon examples  
```
// rise, set
DateTime Moonrise_Time   "Moonrise [%1$tH:%1$tM]"  {astro="planet=moon, type=rise, property=start"}
DateTime Moonset_Time    "Moonset [%1$tH:%1$tM]"   {astro="planet=moon, type=set, property=end"}


// phase
DateTime  Moon_First_Quarter "First Quarter [%1$td.%1$tm.%1$tY %1$tH:%1$tM]" {astro="planet=moon, type=phase, property=firstQuarter"}
DateTime  Moon_Third_Quarter "Third Quarter [%1$td.%1$tm.%1$tY %1$tH:%1$tM]" {astro="planet=moon, type=phase, property=thirdQuarter"}
DateTime  Moon_Full          "Full moon [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"     {astro="planet=moon, type=phase, property=full"}
DateTime  Moon_New           "New moon [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"      {astro="planet=moon, type=phase, property=new"}
Number    Moon_Age           "Moon Age [%.0f]"           {astro="planet=moon, type=phase, property=age"}
Number    Moon_Illumination  "Moon Illumination [%.1f]"  {astro="planet=moon, type=phase, property=illumination"}
String    Moon_Phase_Name    "Moonphase [%s]"            {astro="planet=moon, type=phase, property=name"}


// distance
Number   Moon_Distance_K    "Moon distance [%.2f km]"    {astro="planet=moon, type=distance, property=kilometer"}
Number   Moon_Distance_M    "Moon distance [%.2f miles]" {astro="planet=moon, type=distance, property=miles"}
DateTime Moon_Distance_Time "Moon distance from [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"  {astro="planet=moon, type=distance, property=date"}


// eclipse
DateTime Moon_Eclipse_Total    "Moon total eclipse [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"    {astro="planet=moon, type=eclipse, property=total"}
DateTime Moon_Eclipse_Partial  "Moon partial eclipse [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"  {astro="planet=moon, type=eclipse, property=partial"}


// perigee
Number   Moon_Perigee_K     "Moon perigee [%.2f km]"    {astro="planet=moon, type=perigee, property=kilometer"}
Number   Moon_Perigee_M     "Moon perigee [%.2f miles]" {astro="planet=moon, type=perigee, property=miles"}
DateTime Moon_Perigee_Time  "Moon perigee from [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"    {astro="planet=moon, type=perigee, property=date"}


// apogee
Number   Moon_Apogee_K      "Moon apogee [%.2f  km]"    {astro="planet=moon, type=apogee, property=kilometer"}
Number   Moon_Apogee_M      "Moon apogee [%.2f miles]"  {astro="planet=moon, type=apogee, property=miles"}
DateTime Moon_Apogee_Time   "Moon apogee from [%1$td.%1$tm.%1$tY %1$tH:%1$tM]"     {astro="planet=moon, type=apogee, property=date"}


// schedules a event at full moon
Switch   Moon_Full_Event    {astro="planet=moon, type=phase, property=full"}

// schedules a event 10 minutes BEFORE new moon
Switch   Moon_New_Event     {astro="planet=moon, type=phase, property=new, offset=-10"}
```

If you like to have the season name, zodiac sign and the moon phase name in your own language, use a map.  
Example for german translation:
```
String Zodiac_Sign_Ger "Sternzeichen [MAP(zodiac.map):%s]"  	{astro="planet=sun, type=zodiac, property=sign"}
String Season_Name_Ger "Jahreszeit [MAP(season.map):%s]"        {astro="planet=sun, type=season, property=name"}
String Moon_Phase_Ger  "Mondphase [MAP(moon.map):%s]"           {astro="planet=moon, type=phase, property=name"}
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
**moon.map**
```
New=Neumond
Waxing\u0020Crescent=zunehmender Halbmond
First\u0020Quarter=erstes Viertel
Waxing\u0020Gibbous=zunehmender Mond
Full=Vollmond
Waning\u0020Gibbous=abnehmender Mond
Third\u0020Quarter=letztes Viertel
Waning\u0020Crescent=abnehmender Halbmond
```

### Download
These builds are BETA versions, work in progress, testers welcome!  
**04.08.2014 pb05:** [download binding](https://drive.google.com/file/d/0Bw7zjCgsXYnHNjd6dGNPZDJXeWs/edit?usp=sharing)
* AstroConfig logs more timezone and dst infos.
* Fixed daylight saving offset for moon rise/set.

**02.08.2014 pb04:** [download binding](https://drive.google.com/file/d/0Bw7zjCgsXYnHUjNoejFqOGxFUkU/edit?usp=sharing)
* Added moon calculation.
* Added sun and moon eclipses. 

**26.07.2014 pb03:**  [download binding](https://drive.google.com/file/d/0Bw7zjCgsXYnHUnlTc1lXWlFNNXM/edit?usp=sharing)
* Added zodiac calculation.
* Added season calculation.

**23.07.2014 pb02:** [download binding](https://drive.google.com/file/d/0Bw7zjCgsXYnHY1d3NFU5aHlwWTg/edit?usp=sharing)
* initial public 1.6.0 build (works in openHab 1.5.x too).