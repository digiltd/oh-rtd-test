Documentation of the Astro Binding Bundle

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