This binding can be used for CUNO devices from busware.de. It provides Onewire functionality to the openHAB.

# openhab configuration
The configuration needs two configuration parameters:
> * onewireCuno:device=<device name (see cul-io binding for syntax)>
> * onewireCuno:hms-emulation=<true|false> (enables or disables automatic polling in a specific (by cul firmware) interval)

# item configuration
> { onewireCuno="<2 byte, hexadecimal, onewire device address>" }

# example
## openhab configuration
> * onewireCuno:device=network:192.168.1.1:2323
> * onewireCuno:hms-emulation=true

## item configuraton
> Number Temperature_Labor "Temperatur Labor [%.1f °C]" (Temperature) { onewireCuno="4A7E" }

