Documentation of the Wake-on-LAN binding Bundle

## Introduction

For installation of the binding, please see Wiki page [[Bindings]].


## Generic Item Binding Configuration

In order to bind an item to this binding, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the !NetworkHealth binding configuration string is explained here:

    wol="<broadcast-IP>#<macaddress>"

Here are some examples of valid binding configuration strings:

    wol="192.168.1.0#00:1f:d0:93:f8:b7"
    wol="192.168.1.0#00-1f-d0-93-f8-b7"


As a result, your lines in the items file might look like the following:

    Switch Network_OpenhabWebsite	"openHAB Web"	(Status, Network)	{ wol="192.168.1.0#00:1f:d0:93:f8:b7" }