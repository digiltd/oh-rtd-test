Documentation of the Frontier Silicon Radio binding for Internet Radios based on the Fronstier Silicon chipset.

## Introduction

TODO: Listing of the radios that are known to work.

For installation of the binding, please see Wiki page [[Bindings]].

The Anel binding is included since openHAB 1.7.0.


## Binding Configuration

Configuration is done in the openhab.cfg file (in the folder `${openhab_home}/configurations`):

    ############################### Frontier Silicon Radio Binding ###################################
    #
    # Hostname/IP of the radio to control
    #frontiersiliconradio:radio.host=192.168.0.100
    
    # PIN access code of the radio (default: 1234)
    #frontiersiliconradio:radio.pin=1234
    
    # Portnumber of the radio to control (optional, defaults to 80)
    #frontiersiliconradio:radio.port=80
    
    # The number of milliseconds between checks of the radio
    # (optional, defaults to 60 seconds).
    #frontiersiliconradio:refreshInterval=60000
    
    # Cache the state for n minutes so only changes are posted (optional, defaults to 0 = disabled)
    # Example: if period is 60, once per hour all states are posted to the event bus;
    #          changes are always and immediately posted to the event bus.
    # The recommended value is 60 minutes.
    #frontiersiliconradio:cachePeriod=60

Some notes:
* 'radio' is an identifier that can be replaced with your custom identifier, e.g. 'bedroom' or 'radio-kitchen'. This allows to use the binding also for multiple radios.
* The pin may vary from radio to radio, you can typically look it up in the radio settings.
* 'refreshInterval' and 'cachePeriod' are global settings that apply to all radios.


## Item Binding Configuration

TODO: all item types and binding options with explanation

## Example

TODO