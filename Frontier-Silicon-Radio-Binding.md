Documentation of the Frontier Silicon Radio binding for Internet Radios based on the [Frontier Silicon chipset](http://www.frontier-silicon.com/digital-radio-solutions).

## Introduction

This binding has been developed and tested with the [Hama IR110](https://de.hama.com/00054823/hama-internetradio-ir110) and [Medion MD87180](https://www.medion.com/de/service/start/_product.php?msn=50047825&gid=00) internet radios.

[<img src="http://internetradio.medion.com/images/md87180_small.jpg" alt="MEDION LIFE P85044 (MD 87180)" height="160">](http://internetradio.medion.com/)
[<img src="https://de.hama.com/bilder/00054/abb/00054823abb.jpg" alt="Hama Internetradio IR110" height="180">](https://de.hama.com/00054823/hama-internetradio-ir110)

You can easily check if your IP radio is supported:

1. Figure out the *IP* of your radio (e.g. by looking it up in your router)
2. Figure out the *PIN* that is configured for the radio (somewhere hidden in the radio's on-screen menu); or try the default pin `1234`
3. Go to your web browser and enter: `http://<IP>/fsapi/CREATE_SESSION?pin=<PIN>`
4. If the response is similar to `FS_OK 6836164442`, your radio is most likely compatible with this binding
5. If you radio works with this binding, please add it to the list above by [Editing this page](_edit)!

For installation of the binding, please see Wiki page [[Bindings]].

The Frontier Silicon Radio binding is included since openHAB 1.7.0.


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