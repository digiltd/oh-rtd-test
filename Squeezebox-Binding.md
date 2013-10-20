# Documentation of the Squeezebox binding Bundle

# Introduction

Slim Devices was established in 2000, and was first known for its SlimServer used for streaming music, but launched a hardware player named SliMP3 able to play these streams in 2001. Although the first player was fairly simple only supporting wired Ethernet and MP3 natively, it was followed two years later by a slightly more advanced player which was renamed to Squeezebox. Other versions followed, gradually adding native support for additional file formats, Wi-Fi-support, gradually adding larger and more advanced displays as well as a version targeting audiophile users. Support for playing music from external streaming platforms such as Pandora, Napster, Last.fm and Sirius were also added. The devices in general have two operating modes; either standalone where the device connects to an internet streaming service directly, or to a local computer running the Logitech Media Server or a network-attached storage device. Both the server software and large parts of the firmware on the most recent players are released under open source licenses.

In 2006, Slim Devices was acquired by Logitech for $20 million USD. Logitech continued the development of the player until they announced in August 2012 that it would be discontinued. Given the cross-platform nature of the server and software client, some users have ensured the continued use of the platform by utilizing the Raspberry Pi as dedicated Squeezebox device (both client and server).

Taken from: [Wiki](http://en.wikipedia.org/wiki/Squeezebox_%28network_music_player%29)

For installation of the binding, please see Wiki page [[Bindings]].


# Generic Item Binding Configuration

In order to bind an item to a Squeezebox, you need to provide configuration settings for your Logitech Media Server (SqueezeCenter) and Squeezebox device as well as the item description.

The syntax of an item configuration is shown in the following line in general:
    squeeze="<openHAB-command>:<player-id>:<player-commandLine>[,<openHAB-command>:<player-id>:<player-commandLine>][,...]"

Before you can use a player form within openhab, you have to provide some information in your openhab.cfg:
    one per server:
    squeeze:server.host=A.B.C.D
    [squeeze:server.cliport=9090]
    [squeeze:server.webport=9000]
    
    one per device:
    squeeze:<player-id>=<address-of-your-player A:B:C:D:E:F>



# Squeezebox commands

<table>
  <tr><td>**Command**</td><td>**Purpose**</td></tr>
  <tr><td>volume_increase</td><td>Increase volume by 5%</td></tr>
  <tr><td>volume_decrease</td><td>Decrease volume by 5%</td></tr>
  <tr><td>play</td><td>Play the current title</td></tr>
  <tr><td>http=<stream></td><td>Play the given http stream</td></tr>
  <tr><td>file=<file></td><td>Play the given file on your server</td></tr>
  <tr><td>pause</td><td>Pause the current title</td></tr>
  <tr><td>stop</td><td>Stop the current title</td></tr>
  <tr><td>powerOn</td><td>Power on your device</td></tr>
  <tr><td>powerOff</td><td>Power off your device</td></tr>
  <tr><td>mute</td><td>Mute your device</td></tr>
  <tr><td>unmute</td><td>Unmute your device</td></tr>
  <tr><td>add=<hardware address></td><td>Add <player-hardwareadress> to your <player-id> for synced playback</td></tr>
  <tr><td>remove=<hardware address></td><td>Remove <player-hardwareadress> from your <player-id></td></tr>
</table>



# Squeezebox variables

<table>
  <tr><td>**Variable**</td><td>**Purpose**</td></tr>
  <tr><td>volume</td><td>The volume in percent</td></tr>
  <tr><td>isMuted</td><td>Mute state of the selected player</td></tr>
  <tr><td>isPlaying</td><td>Play state of the selected player</td></tr>
  <tr><td>isStopped</td><td>Stop state of the selected player</td></tr>
  <tr><td>isPaused</td><td>Pause state of the selected player</td></tr>
  <tr><td>isPowered</td><td>Power state of the selected player</td></tr>
  <tr><td>album</td><td>Album title of the current song</td></tr>
  <tr><td>coverart</td><td>Address to cover art of the current song</td></tr>
  <tr><td>artist</td><td>Artist name of the current song</td></tr>
  <tr><td>year</td><td>Release year of the current song</td></tr>
  <tr><td>genre</td><td>Genre name of the current song</td></tr>
  <tr><td>title</td><td>title of the current song</td></tr>
  <tr><td>remotetitle</td><td>title of radio station currently playing</td></tr>
</table>



# Examples

Here are some examples of valid binding configuration strings:

    squeeze="PERCENT:player1:volume, INCREASE:player1:volume_increase, DECREASE:player1:volume_decrease"
    squeeze="STRING:player1:title"
    squeeze="0:player1:stop, 1:player1:http=wdr-mp3-m-wdr2-duesseldorf.akacast.akamaistream.net:8080/7/371/119456/v1/gnl.akacast.akamaistream.net/wdr-mp3-m-wdr2-duesseldorf, 2:player1:file=/somemusic.mp3" }

As a result, your lines in the items file might look like the following:
    Dimmer sq_test_volume 	   "Volume [%.1f %%]"	{ squeeze="PERCENT:player1:volume, INCREASE:player1:volume_increase, DECREASE:player1:volume_decrease" }
    String sq_test_title	   "Title [%s]"		{ squeeze="STRING:player1:title" }
    Number sq_test_play_select "Demo"		{ squeeze="0:player1:stop, 1:player1:http=wdr-mp3-m-wdr2-duesseldorf.akacast.akamaistream.net:8080/7/371/119456/v1/gnl.akacast.akamaistream.net/wdr-mp3-m-wdr2-duesseldorf, 2:player1:file=/somemusic.mp3" }