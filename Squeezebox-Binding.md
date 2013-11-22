Documentation of the Squeezebox binding Bundle

## Introduction

Slim Devices was established in 2000, and was first known for its SlimServer used for streaming music, but launched a hardware player named SliMP3 able to play these streams in 2001. Although the first player was fairly simple only supporting wired Ethernet and MP3 natively, it was followed two years later by a slightly more advanced player which was renamed to Squeezebox. Other versions followed, gradually adding native support for additional file formats, Wi-Fi-support, gradually adding larger and more advanced displays as well as a version targeting audiophile users. Support for playing music from external streaming platforms such as Pandora, Napster, Last.fm and Sirius were also added. The devices in general have two operating modes; either standalone where the device connects to an internet streaming service directly, or to a local computer running the Logitech Media Server or a network-attached storage device. Both the server software and large parts of the firmware on the most recent players are released under open source licenses.

In 2006, Slim Devices was acquired by Logitech for $20 million USD. Logitech continued the development of the player until they announced in August 2012 that it would be discontinued. Given the cross-platform nature of the server and software client, some users have ensured the continued use of the platform by utilizing the Raspberry Pi as dedicated Squeezebox device (both client and server).

Taken from: [Wiki](http://en.wikipedia.org/wiki/Squeezebox_%28network_music_player%29)

For installation of the binding, please see Wiki page [[Bindings]].

Please note there are two parts to the Squeezebox binding. You need to install both `org.openhab.io.squeezeserver` and `org.openhab.binding.squeezebox`. The `io.squeezeserver` bundle is a common library used by both this binding and the Squeezebox action and handles all connections and messaging between openHAB and the Squeeze Server. This ensures you only need to specify one set of configuration in openhab.cfg (see below), which can be used by both the binding and the action.

## Common Configuration

First you need to let openHAB know where to find your Squeeze Server and each of your Squeezebox devices. This configuration is entered in your openhab.cfg configuration file and is used by both the Squeezebox binding and the [[Squeezebox Action]]:

    # Squeeze server
    squeeze:server.host=A.B.C.D
    [squeeze:server.cliport=9090]
    [squeeze:server.webport=9000]
    
    # Squeezebox players/devices
    squeeze:<player-id>=<mac-address-of-player A:B:C:D:E:F>

NOTE: the `player-id` will be used in both the binding item configs and the action calls to defined which of your Squeezebox devices to communicate with.

## Item Binding Configuration

The syntax of an item configuration is shown in the following line in general:

    squeeze="<player-id>:<command>[:<extra>]"

Where `player-id` matches one of the ids defined in your openhab.cfg file.

## Squeezebox commands
| Command         | Purpose                   |
| --------------- | ------------------------- |
| power           | Power on/off your device  |
| mute            | Mute/unmute your device   |
| volume          | Change volume by 5%       |
| play            | Play the current title    |
| pause           | Pause the current title   |
| stop            | Stop the current title    |
| http:stream     | Play the given http stream (obsolete as there is now a new playUrlSqueezebox() action for handling this inside rules directly) |
| file:file       | Play the given file on your server (obsolete as there is now a new playUrlSqueezebox() action for handling this inside rules directly) |
| sync:player-id2 | Add `player-id2` to your device for synced playback |

## Squeezebox variables

<table>
  <tr><td>**Variable**</td><td>**Purpose**</td></tr>
  <tr><td>title</td><td>Title of the current song</td></tr>
  <tr><td>album</td><td>Album name of the current song</td></tr>
  <tr><td>artist</td><td>Artist name of the current song</td></tr>
  <tr><td>year</td><td>Release year of the current song</td></tr>
  <tr><td>genre</td><td>Genre name of the current song</td></tr>
  <tr><td>coverart</td><td>Address to cover art of the current song</td></tr>
  <tr><td>remotetitle</td><td>Title of radio station currently playing</td></tr>
</table>

## Examples

Here are some examples of valid binding configuration strings:

    squeeze="player1:volume"
    squeeze="player1:title"
    squeeze="player1:play"

As a result, your lines in the items file might look like the following:

    Dimmer sq_test_volume 	   "Volume [%.1f %%]"	{ squeeze="player1:volume" }
    String sq_test_title	   "Title [%s]"		{ squeeze="player1:title" }
    Number sq_test_play        "Play"		{ squeeze="player1:play" }

NOTE: when binding the 'play' command to a switch item you will trigger 'play' when the item receives the ON command. It will also trigger 'stop' when the item receives the OFF command. The same applies for 'stop' and 'pause' except ON=>stop/pause and OFF=>play. This is so you can setup a single item for controlling play/stop by defining mappings in your sitemap:

    Switch item=sq_test_play mapppings=[ON="Play", OFF="Stop"]

And whenever the player state is changed from outside of openHAB these items will be updated accordingly, since there is now no longer a separate item for 'play' and 'isPlaying'.