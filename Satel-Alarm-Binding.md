## Introduction

This is documentation of OpenHAB binding for Satel Integra Alarm System which allows you to connect to your alarm system using TCP/IP protocol with ETHM-1 installed or RS-232 protocol with INT-RS module installed.

For installation of the binding, please see Wiki page [Bindings](Bindings).

**NOTE:** INT-RS nmodule is not supported yet.

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

The only required parameter is _satel:host_ for the ETHM-1 module and _satel:port_ for the INT-RS module. The rest default to the values described in the configuration comments. In order to use ETHM-1 module it is required to enable "integration" protocol for the module in Integra configuration (DLOADX).

<table>
<tr><td>Option</td><td>Description</td></tr>
<tr><td>satel:host</td><td>Valid only for ETHM-1 module. Specifies either IP or host name of the module</td></tr>
<tr><td>satel:port</td><td>For INT-RS it specifies the serial port on the host system to which the module is connected, i.e. "COM1" on Windows, "/dev/ttyS0" or "/dev/ttyUSB0" on Linux<br>For ETHM-1 it specifies the TCP port on which the module listens for new connections. Defaults to 7094.</td></tr>
<tr><td>satel:timeout</td><td>Timeout value for connect, read and write operations specified in milliseconds. Defaults to 5 seconds</td></tr>
<tr><td>satel:refresh</td><td>Refresh interval in milliseconds. Defaults to 10 seconds.</td></tr>
<tr><td>satel:user_code</td><td>TBD</td></tr>
<tr><td>satel:encryption_key</td><td>TBD</td></tr></table>

## Item Binding

In order to bind to the Integra Alarm system you can add items to an item file using the following format:

```
satel="<object_type>[:<state_type>][:object_number][:options]"
```
Valid object_type
TBD

## Examples

TBD

## TO DO
* support for INT-RS module
* support for RTC and basic status
* encryption for ETHM-1
* RTC synchronization
