Documentation of the Davisbinding Bundle

## Introduction

Binding is based on the [Serial Communication Reference Manual](http://www.google.at/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0CCQQFjAA&url=http%3A%2F%2Fwww.davisnet.com%2Fsupport%2Fweather%2Fdownload%2FVantageSerialProtocolDocs_v261.pdf&ei=yns1VLO9B9Pe7Ab9hYDgDQ&usg=AFQjCNEUP_O6jjV3tHaxc7_faaLKWAtw2g&sig2=0YuJy45Qmk76RlffOqayuA&bvm=bv.76943099,d.ZGU) from Davis. Most Davis weather stations should be supported, so far the Binding is tested with Vantage Pro 2.

For installation of the binding, please see Wiki page [[Bindings]].

Davis binding will be available since openhab 1.6.0

## Binding Configuration

First you need to define your Davis weather station he openhab.cfg file (in the folder '${openhab_home}/configurations').

    ######################## Davis weather stations ###########################
    
    # serial port of the Weather station connected to
    davis:port=/dev/ttyS0
    
    # refresh inverval in milliseconds (optional, defaults to 10000)
    #davis:refresh=

The `davis:port` value is the path from the serial device of the weather station. For windows systems it is COMx

The `davis:refresh` value is the refresh interval. Refresh value is optional parameter.

Examples, how to configure your Davis device:

    davis:port=/dev/ttyS0
    #davis:refresh=

