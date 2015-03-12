Documentation of the Bticino Binding Bundle

### Introduction

The openHAB Bticino binding allows to connect to Bticino My Home Automation installations by OpenWebNet protocol.
For example you can switching lights on and off, activating your roller shutters etc.

To access your Bticino My Home bus you either need an IP gateway (like e.g. the MH200N, F453).

For installation of the binding, please see Wiki page [[Bindings]].

## Binding Configuration in openhab.cfg

    # OpenWebNet gateway IP address / Hostname
    bticino:webserver.host=

    # OpenWebNet gateway Port (optional, defaults to 20000)
    bticino:webserver.port=

    # OpenWebNet bus status rescan interval (optional, defaults to 120 seconds)
    bticino:webserver.rescan_secs=

A sample configuration could look like:

    bticino:webserver.host=192.168.1.35
    bticino:webserver.rescan_secs=3600

## Bind Items to Bticino

### Description
In order to bind an item to a Bticino device you need to provide configuration settings. The easiest way to do so is to add  binding information in your 'item file' (in the folder configurations/items`). The syntax for the Bticino binding configuration string is explained here:

    bticino="if=webserver;who=<who>;what=<what>;where=<where>"

    Table of WHO

    Code  Description
     0    Scenarios
     1    Lightning
     2    Automation
     3    Load control
     4    Temperature Control
     5    Alarm
     6    VDES
    13    Gateway Management
    15    CEN commands
    16/22 Sound diffusion**
    17    MH200N scenarios
    18    Energy management
    25    CEN plus/ scenarios plus/ dry contacts
    1001  Automation diagnostic
    1004  Thermoregulation diagnostic
    1013  Device diagnostic

For more details refer to the official document [OpenWebNet Introduction](http://www.myopen-legrandgroup.com/resources/own_protocol/m/own_documents/16.aspx).

At the moment only Automation , Lightning, CEN plus and part of the Temperature Control are supported.

### Example

    Switch        Lig_FF_Bed_Cei  "Ceiling" (FF_Bed, Lights) {bticino="if=webserver;who=1;what=1;where=35"}
    Rollershutter Shu_GF_Liv_Left "Living"  (GF_Liv, Shu)    {bticino="if=webserver;who=2;what=1;where=46"}