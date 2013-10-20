# Documentation of the MPD binding Bundle

# Introduction

[Music Player Daemon(MPD)](http://www.musicpd.org/) is a flexible, powerful, server-side application for playing music. Through plugins and libraries it can play a variety of sound files while being controlled by its network protocol. 
By help of the openHAB MPD binding you can e.g. start/stop playing music in specific rooms / on various channels and change volume.

For installation of the binding, please see Wiki page [[Bindings]].

# Generic Item Binding Configuration

In order to bind an item to a MPD, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the Exec binding configuration string is explained here:

    mpd="<openHAB-command>:<player-id>:<player-commandLine>[,<openHAB-command>:<player-id>:<player-commandLine>][,...]"

where the parts in {{{[]}}} are optional.

The Player-Id corresponds whith the configuration in openhab.cfg where one has to configure the MPDs:

    mpd:<player-id>.host=[host]
    mpd:<player-id>.port=[port]

Here are some examples of valid binding configuration strings:

    mpd="ON:bath:play, OFF:bath:stop"
    mpd="INCREASE:bath:volume_increase, DECREASE:bath:volume_decrease"


As a result, your lines in the items file might look like the following:
    Switch Mpd_Bathroom_StartStop	"Start/Stop"	(Bathroom)	{ mpd="ON:bad:play, OFF:bad:stop" }