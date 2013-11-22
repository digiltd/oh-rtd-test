Documentation of the OpenSprinkler binding Bundle

## Introduction

https://www.youtube.com/watch?v=lT0uxFlwu9s <br/>
In the OpenHAB 1.3.0 release, this binding is compatible with with both the [OpenSprinkler](http://opensprinkler.com) and [OpenSprinkler Pi](http://pi.opensprinkler.com) hardware. In other words, this binding supports communicating to the !OpenSprinkler and !OpenSprinkler Pi using http (as long as you have the interval program installed), or directly via GPIO when using the !OpenSprinkler Pi.

For installation of the binding, please see Wiki page [[Bindings]].

## Binding Configuration

!OpenSprinkler stations are numbered 0 through 7 for the default number of stations, but for some users of the !OpenSprinkler and !OpenSprinkler Pi, they will have extension boards in use. This requires that the openhab.cfg file be edited to specify how many stations are available (by default there are 8, so if you are not using an extension board then you don't need to do this step).

Additionally, if you are wanting to connect via http to your !OpenSprinkler (most probably because you have the original version), you will need to specify the url and password to access the interval program server. Note that by connecting OpenHAB to the interval program, you will be disabling any timers and forcing it into manual mode. Refer to the example below to see what you need to include in your openhab.cfg file:

    ################################ OpenSprinkler Binding ################################
    # The type of OpenSprinkler connection to make. There are two valid options, and the 
    # default mode is gpio.
    #
    # gpio: this mode is only applicable when running OpenHAB on a Raspberry Pi, which 
    #       is connected directly to an OpenSprinkler Pi. In this mode the communication
    #       is directly over the GPIO pins of the Raspberry Pi
    # http: this mode is applicable to both OpenSprinkler and OpenSprinkler Pi, as long as
    #       they are running the interval program. Realistically though if you have an
    #       OpenSprinkler Pi, it makes more sense to directly connect via gpio mode.
    # openSprinkler:mode=gpio
    
    # If the http mode is used, you need to specify the url of the internal program,
    # and the password to access it. By default the password is 'opendoor'.
    # openSprinkler:httpUrl=http://localhost:8080/
    # openSprinkler:httpPassword=opendoor
    
    # The number of stations available. By default this is 8, but for each expansion board
    # installed this number will can be incremented by 8. Default value is 8.
    # openSprinkler:numberOfStations=8

## Item Binding Configuration

In order to switch a station open or shut using the binding, you must firstly define a switch item in your item file (in the folder configurations/items). The syntax (by way of example) of the item configuration is shown below:

    /* Sprinklers */
    Switch Sprinkler_Station_0 	"Station 0" { openSprinkler="0" }
    Switch Sprinkler_Station_1 	"Station 1" { openSprinkler="1" }

You can see in this example that two stations are exposed as items. The first station exposed is the 0th port (i.e. the left-most pin on the OpenSprinkler Pi), and the second station is the 1st port (the second-to-left-most pin on the OpenSprinkler Pi). Note that there is no requirement to use the stations in order - you can open and close any station.
 