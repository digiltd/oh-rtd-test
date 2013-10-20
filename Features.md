# Feature Overview

openHAB has many features and we will try here to give you an overview of them. Please also check the [issue tracker](http://code.google.com/p/openhab/issues/list).

<wiki:toc max_depth="1" />


# User Interfaces

### Touch-optimized Web-UI for Smartphones

The main interface to communicate with openHAB is surely the [web-based UI](WebAppUI). It comes with the default runtime package and is pre-configured with a demo house. This UI is available at the url
        http://localhost:8080/openhab.app?sitemap=demo

### Native iOS Client

There is [a native iOS User Interface](iOS_UI) available on the !AppStore. Go and check it out!

### HABDroid a native Android Client

There is [a native Android User Interface](HABDroid). Go and check it out!

### GreenT Web-UI for Smartphones and Tablets

There is a [SenchaTouch-based UI](TouchUI), which can be used with smartphones and tablets likewise. This UI is [distributed as a separate package](http://code.google.com/p/openhab/downloads/detail?name=openhab-greent-1.0.0.zip) and needs to be unzipped to {$openhab.home}/webapps. Afterwards it is accessible at the url
        http://localhost:8080/greent/

### OSGi Console

openHAB adds commands to the OSGi console. If you type "help" on the console, you will see a section like
    ---openHAB commands---
    	openhab send <item> <command> - sends a command for an item
    	openhab update <item> <state> - sends a status update for an item
    	openhab status <item> - shows the current status of an item
    	openhab items [<pattern>] - lists names and types of all items matching the pattern
    	openhab say <sentence to say> - Says a message through TTS on the host machine

With these you can manually send commands and status updates to the event bus, ask for the current status of items and browse the item registry.

The "say" command also supports to include item states in the sentence to say through TTS. If the item {{{Weather_Temperature}}} has the current value 15, you can use the command 
       openhab say The temperature outside is %Weather_Temperature% degrees celsius.
where {{{%Weather_Temperature%}}} is automatically replaced by {{{15}}}.

### XMPP (Jabber) Instant Messaging Console

openHAB supports remote console access through XMPP.
For this, you require an XMPP account for your house - you can easily create on for example at [Jabber.org](https://register.jabber.org/).

Configure the XMPP-section of your openhab.cfg file accordingly and define, which XMPP users are allowed to use the console.

Next time you start your openHAB runtime, you will see that your house automatically comes online - you can now chat with it just like on the local console (the only difference is that you do not need the "openhab" prefix of the commands, e.g. simply type {{{status Weather_Temperature}}}).

http://wiki.openhab.googlecode.com/hg/images/screenshots/xmpp.jpg

### Google Calendar Console

The third console is using Google calendar entries - with this cool feature, you can schedule console commands by entering them in your calendar. See [more details about how to use it here](GCalBinding).

### REST-API

The RESTful interface opens up openHAB to any other system that might want to tightly interact with openHAB. Not only gives it direct access to items, but also to sitemaps.This API can hence be used as a communication channel for user interfaces. Read [all the details about the REST-API](REST).


# Designer

The openHAB Designer, which is the configuration tool for the openHAB Runtime, is an Eclipse RCP application with Xtext-based editors to offer a highly user-friendly way of editing configuration files, UI definitions and automation rules. For the automation rules, there are two implementations available. A self designed powerful Xbase/Xtext-based engine or the JBoss Drools engine.


# Automation Rules / Scripts / Actions

openHAB comes with a highly integrated rule engine to allow users to write automation rules.
Read about the [[Rules|details on this wiki page]].

Optionally, you can also use JBoss Drools, see the [[Drools|details here]].

Rules can make use of user-defined [[Scripts|scripts]], but those scripts can also be called directly from consoles. They make it very easy to define macros.

openHAB defines a useful [[Actions|set of actions]] that can be used from within rules and scripts. They can be used to send e-mails and do other kinds of notifications as well as other common things.

# Bindings

As the OSGi platform allows a highly modular architecture, the bindings are realized as different bundles, which can be dynamically plugged to openHAB, so that every user can decide on the bindings he is interested in.

There are many different hardware/protocol bindings available, each is documented including its configuration options on the wiki:

- [[Asterisk Binding|Asterisk Binding]]
- [[Bluetooth Binding|Bluetooth Binding]]
- [CUPS Binding](CUPSBinding)
- [DMX512 Binding](DMXBinding)
- [[Exec Binding|Exec Binding]]
- [[Fritz Box Binding|Fritz!Box Binding]]
- [[Homematic Binding|Homematic Binding]]
- [[Http Binding|HTTP Binding]]
- [IHC / ELKO Binding](IHCBinding)
- [KNX Binding](KNXBinding)
- [[Koubachi Binding|Koubachi Binding]]
- [[Modbus Tcp Binding|Modbus TCP Binding]]
- [[Mpd Binding|MPD Binding]]
- [[Network Health Binding|Network Health Binding]]
- [[Novelan Heat Pump Binding|Novelan Heatpump Binding]]
- [[Ntp Binding|NTP Binding]]
- [[One Wire Binding|One-Wire Binding]]
- [[Config Admin Binding|OSGi Configuration Admin Binding]]
- [[Hue Binding|Philips Hue Binding]]
- [[Plugwise Binding|Plugwise Binding]]
- [PLCBus Binding](PLCBusBinding)
- [[Pulseaudio Binding|Pulseaudio Binding]]
- [RFXCOM Binding](RFXCOMBinding)
- [Samsung TV Binding](SamsungTVBinding)
- [[Serial Binding|Serial Binding]]
- [[Snmp Binding|Snmp Binding]]
- [Somfy URTSI II Binding](URTSIBinding)
- [[Sonos Binding|Sonos Binding]]
- [TCP/UDP Binding](TCPBinding)
- [VDR Binding](VDRBinding)
- [Wake-on-LAN Binding](WoLBinding)

# Other

There more features which aren't hardware/protocol bindings but also available as separate bundles.

- [Dropbox Support](DropboxIOBundle)
- [Google Calendar Support](GCalBinding)
- Text to speech implementation