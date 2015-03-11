Documentation of the Bticino Binding Bundle

### Introduction

The openHAB Bticino binding allows to connect to Bticino My Home Automation installations by OpenWebNet protocol.
For example you can switching lights on and off, activating your roller shutters etc.

To access your Bticino My Home bus you either need an IP gateway (like e.g. the MH200N, F453).

For installation of the binding, please see Wiki page [[Bindings]].

## Binding Configuration in openhab.cfg

# OpenWeb gateway IP address / Hostname (for example 192.168.1.35)
bticino:webserver.host=

# OpenWeb gateway Port (optional, defaults to 20000)
bticino:webserver.port=

# OpenWeb bus status rescan interval (optional, defaults to 120 seconds)
bticino:webserver.rescan_secs=3600