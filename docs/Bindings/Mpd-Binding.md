Documentation of the MPD binding Bundle

## Introduction

[Music Player Daemon(MPD)](http://www.musicpd.org/) is a flexible, powerful, server-side application for playing music. Through plugins and libraries it can play a variety of sound files while being controlled by its network protocol. 
By help of the openHAB MPD binding you can e.g. start/stop playing music in specific rooms / on various channels and change volume.

For installation of the binding, please see Wiki page [[Bindings]].

## Generic Item Binding Configuration

In order to bind an item to a MPD, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the Exec binding configuration string is explained here:

    mpd="<openHAB-command>:<player-id>:<player-commandLine>[,<openHAB-command>:<player-id>:<player-commandLine>][,...]"

where the parts in `[]` are optional.

The Player-Id corresponds whith the configuration in openhab.cfg where one has to configure the MPDs:

    mpd:<player-id>.host=[host]
    mpd:<player-id>.port=[port]

Here are some examples of valid binding configuration strings:

    mpd="ON:bath:play, OFF:bath:stop"
    mpd="INCREASE:bath:volume_increase, DECREASE:bath:volume_decrease"

As a result, your lines in the items file might look like the following:

    Switch Mpd_Bathroom_StartStop	"Start/Stop"	(Bathroom)	{ mpd="ON:bad:play, OFF:bad:stop" }



## New features coming in [1.5](https://github.com/openhab/openhab/pull/888)

Support for track names was added and also ability to set exact volume for dimmer items (previously only increase/decrease actions were available)

Example items:

```
String CurrentTrack    "Current track [%s]" { mpd="TITLE:bad:tracktitle" }
String CurrentArtist    "Current artist [%s]" { mpd="ARTIST:bad:trackartist" }
String ConcatInfo       "Now playing [%s]"

Switch Mpd_Bathroom_StartStop       "Start/Stop"   (Bathroom)  { mpd="ON:bad:play, OFF:bad:stop" }
Switch Mpd_Bathroom_NextPrev        "Track control"   (Bathroom)    { mpd="ON:bad:next, OFF:bad:prev" } 
Dimmer Mpd_Bathroom_VolumeControl   "Volume [%d%%]"       (Bathroom)  { mpd="INCREASE:bad:volume_increase, DECREASE:bad:volume_decrease, PERCENT:bad:volume" }
```

Sample rules (to concatenate artist and title):

```
rule "concat"
when
  Item CurrentTrack received update or
  Item CurrentArtist received update
then
  ConcatInfo.postUpdate(CurrentTrack.state.toString + " / " + CurrentArtist.state.toString)
end
```

Example sitemap:

```
Text item=CurrentTrack
Text item=CurrentArtist
Text item=ConcatInfo
Switch item=Mpd_Bathroom_StartStop mappings=[OFF="Pause", ON="Play"]
Switch item=Mpd_Bathroom_NextPrev  mappings=[OFF="Previous", ON="Next"]
Slider item=Mpd_Bathroom_VolumeControl
```

