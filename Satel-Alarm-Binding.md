This is OpenHAB binding for Satel Integra Alarm System with ETHM-1 or INT-RS module installed.

The binding provides connectivity to an Integra board via a TCP socket connection to the ETHM-1 or a RS-232 serial connection to the INT-RS.

## Binding Configuration

There are some configuration settings that you can set in the openhab.cfg file. Include the following in your openhab.cfg.

```
############################### Satel Binding ###################################
#
# Satel ETHM-1 module hostname or IP.
# Leave this commented out for INT-RS module.  
#satel:host=

# ETHM-1 port to use (optional, defaults to 7094), if host setting is not empty.
# INT-RS port to use, if host setting is empty.
#satel:port=7094

# timeout value for both ETHM-1 and INT-RS (optional, in milliseconds, defaults to 5000)
#satel:timeout=5000

# refresh value (optional, in milliseconds, defaults to 10000)
#satel:refresh=10000

# user code for Integra control (optional, if empty binding works in read-only mode)
#satel:user_code=

# encryption key (optional, if empty communication is not encrypted)
#satel:encryption_key=
```
## Item Binding

In order to bind to the Integra Alarm system you can add items to an item file using the following format:

```
satel="<object type>[:<state type>][:object number][:options]"
```

TBD

## Examples

TBD

## TO DO
* support for RTC and basic status
* encryption for ETHM-1
* RTC synchronization
