Documentation of the NetworkHealth binding Bundle

## Introduction

For installation of the binding, please see Wiki page [[Bindings]].

## Generic Item Binding Configuration

In order to bind an item to a NetworkHealth check, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder `configurations/items`). The syntax for the NetworkHealth binding configuration string is explained here:

    nh="<hostname>[:port][:timeout]"

where the parts in `[]` are optional. If no port is configured a simple ping is issued. If no timeout is configured the query defaults to '5000' milliseconds.

Here are some examples of valid binding configuration strings:

    nh="www.google.com:80"
    nh="openhab.org"
    nh="openhab.org:443"
    nh="openhab.org:443:2000"


As a result, your lines in the items file might look like the following:

    Switch Network_OpenhabWebsite   "openHAB Web"   (Status, Network)   { nh="openhab.org:80" }