# Documentation of the HTTP binding Bundle

# Introduction

The HTTP binding bundle is available as a separate (optional) download.
If you want to let openHAB request an URL when special events occur or let it poll a given URL frequently, please place this bundle in the folder `${openhab_home}/addons` and add binding information to your configuration. See the following sections on how to do this. 


# Generic Item Binding Configuration

In order to bind an item to a HTTP request, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the HTTP binding configuration string is explained here:

    in:  http:"<[<url>:<refreshintervalinmilliseconds>:<transformationrule>]"
    out: http:">[<command>:<httpmethod>:<url>]"

For the !OutBinding there are two special commands available:

- '`*`' - which means the following URL is called regardless which command has been issued
- 'CHANGED' - which means the following URL is called whenever the state of the given item changed


Here are some examples of valid binding configuration strings:

    http=">[ON:POST:http://www.domain.org/home/lights/23871/?status=on&type=\"text\"] >[OFF:POST:http://www.domain.org/home/lights/23871/?status=off]"
    http="<[http://www.domain.org/weather/openhabcity/daily:60000:REGEX(.*?<title>(.*?)</title>.*)]"
    http=">[ON:POST:http://www.domain.org/home/lights/23871/?status=on&type=\"text\"] >[OFF:POST:http://www.domain.org/home/lights/23871/?status=off]"
    http=">[*:POST:http://www.domain.org/home/lights/23871/?status=%2$s&type=\"text\"] <[http://www.domain.org/weather/openhabcity/daily:60000:REGEX(.*?<title>(.*?)</title>.*)]"
    http=">[CHANGED:POST:http://www.domain.org/home/lights/23871/?status=%2$s&date=%1$tY-%1$tm-%1$td]"


As a result, your lines in the items file might look like the following:
    Number Weather_Temperature "Temperature [%.1f ¬∞C]"  <temperature>  (Wetter) { http="<[http://weather.yahooapis.com/forecastrss?w=638242&u=c:60000:XSLT(demo_yahoo_weather.xsl)]" }
    

# Dynamic URL enhancement

The given URL can be enhanced using the well known Syntax of the [java.util.Formatter](http://docs.oracle.com/javase/6/docs/api/java/util/Formatter.html). The !HttpOutBinding currently adds to parameters to the String.format() automatically

1. the current date (as java.util.Date)
1. the current Command or State

To reference these values the indexed format syntax is used. A well prepared URL look like this:

{{{ http://www.domain.org/home/lights/23871/?status=%2$s&date=%1$tY-%1$tm-%1$td }}}

Each format string starts with '%' followed by an optional index e.g. '2$' whereas '2' is the index of the parameter arg given to the format(format, args...) method. Besides the index you have to specify the format to be applied to the argument. E.g. 's' to format a String in the given example or 'd' to format an Integer, or '.1f' to format a Float with one decimal fraction.

# HTTP headers

Both !OutBinding and !InBinding provide the possibility to define optional HTTP headers, which will be sent during the HTTP method call. Those optional headers can be added to the url in the form {{{header1=value1&header2=value2....}}} This headers string should be enclosed in curly brackets right after the url itself (before the separation colon).

Example:
    http="<[https://www.flukso.net/api/sensor/xxxx?interval=daily{X-Token=mytoken&X-version=1.0}:60000:REGEX(.*?<title>(.*?)</title>(.*))]"


# Caching

Since v1.3, HTTP binding support page caching. Caching is usable, when multiple items could be parsed from the same URL.

Cache functionality can be configured in the openhab.cfg file (in the folder '${openhab_home}/configurations').

    ############################### HTTP Binding ##########################################
    # URL of the first cache item
    # http:<cacheItemName1>.url=
    # Update interval for first cache item
    # http:<cacheItemName1>.updateInterval=
    
    # URL of the second cache item
    # http:<cacheItemName2>.url=
    # Update interval for second cache item
    # http:<cacheItemName2>.updateInterval=

The `http:<cacheItemName1>.url` value is the valid URL. 
The `http:<cacheItemName1>.updateInterval` value is update interval in milliseconds.

Examples, how to configure your HTTP cache item:

Configuration:
    http:weatherCache.url=http://weather.yahooapis.com/forecastrss?w=566473&u=c
    http:weatherCache.updateInterval=60000

Items:
    Number temperature { http="<[weatherCache:10000:XSLT(demo_yahoo_weather_temperature.xsl)]" }
    Number windSpeed { http="<[weatherCache:10000:XSLT(demo_yahoo_weather_wind_speed.xsl)]" }