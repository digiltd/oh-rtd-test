Documentation of the Fritz!Box binding bundle

## Introduction

For installation of the binding, please see Wiki page [[Bindings]].

## Generic Item Binding Configuration

In order to bind an item to the Fritz!Box, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). 

The format of the binding configuration is simple and looks like this:
    fritzbox="<eventType>"
where `<eventType>` is one of the following values:
- inbound - for incoming calls
- outbound - for placed calls
- active - for currently active calls

Fritz!Box binding configurations are valid on Switch and Call items.

Switch items with this binding will receive an ON update event at the start and an OFF update event at the end (a connection marks the end for inbound and outbound types, only active type will be ON for connected calls).

Call items will receive the external and the internal phone number in form of a string value as a status update. At the end of the event, an empty !CallItem which contains empty strings is sent as a status update.

As a result, your lines in the items file might look like the following:

    Switch    Incoming_Call     "Ringing"                        (Phone)    { fritzbox="inbound" }
    Call      Active_Call       "Connected to [%1$s from %2$s]"  (Phone)    { fritzbox="active"  }
    Call      Incoming_Call_No  "Caller No. [%2$s]"              (Phone)    { fritzbox="inbound" } 