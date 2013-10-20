# An overview of the contents of the "addons" download package

# openHAB Add-ons

This is an overview over the contents of the [download package]("addons").

This package contains various optional bundles of openHAB, each of which can be installed independently of any other. Simply copy the desired jars to {{{${openhab.home}/addons}}}.

They are distributed separately in order to keep the core runtime package as small as possible and to allow the user to just pick the features he is really interested in.

These are the bundles that are contained in the package:

- [KNX binding](KNXBinding): Bind your existing KNX hardware through serial or IP interfaces
- [[One Wire Binding|1-wire binding]]: Bind your 1-wire sensors
- [[Bluetooth Binding|Bluetooth binding]]: Bind your items to the bluetooth neighbourhood
- [Wake-on-LAN binding](WoLBinding): Send WoL packets when using a switch in openHAB
- [[Network Health Binding|Network health binding]]: Monitor your server availability
- [[Exec Binding|Exec binding]]: Execute any command on the host
- [[Serial Binding|Serial binding]]: Access devices connected via USB/RS-232
- [[Http Binding|HTTP binding]]: Get data from the internet or send out requests
- [[Fritz Box Binding|FritzBox binding]]: React on call notifications from your !FritzBox
- [[Ntp Binding|NTP binding]]: Get the precise time from NTP servers
- [[Mpd Binding|MPD binding]]: Control music playback on Music Player Deamon (MPD) clients
- [VDR binding](VDRBinding): Control your VDR and get notifications on your TV screen
- [[Asterisk Binding|Asterisk binding]]: React on call notifications from your Asterisk server
- FreeTTS: Add Text-to-Speech support using FreeTTS. Not required on Mac as openHAB uses native TTS support there.