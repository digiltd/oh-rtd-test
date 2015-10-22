Documentation of the Asterisk binding bundle

## Introduction

The Asterisk binding is used to enable communication between openhab and the free and open source PBX solution [Asterisk](http://www.asterisk.org). By help of this binding you can e.g. detect incoming phone calls or determine if someone currently does a phone call. In combination with other bindings (e.g. [[Samsung TV Binding]]) you can display caller IDs on your TV.

For installation of the binding, please see Wiki page [[Bindings]].

## Generic Item Binding Configuration

In order to bind an item to the Asterisk PBX you need to provide configuration settings. The easiest way to do this is to add binding information in your item file (in the folder configurations/items`). 

The format of the binding configuration is simple and looks like this:

    asterisk=<eventType>
where `<eventType>` is of the value *active* for currently active calls. Currently there are no other valid values.

Asterisk binding configurations are valid on Switch and String items.

Switch items with this binding will receive an ON update event at the start and an OFF update event at the end.

String items will receive the external phone number in form of a string value as a status update. At the end of an event an empty string is sent as a status update.

As a result your lines in the items file might look like follows:

    Switch Incoming_Call	"Ringing"			(Phone)    { asterisk=active }
    Call Active_Call	"Connected [to %1$s from %2$s]"	(Phone)    { asterisk=active }
    Call Active_Call	"Connected to [%s]"		(Phone)    { asterisk=active }