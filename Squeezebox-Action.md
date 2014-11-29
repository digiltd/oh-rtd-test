**Squeezebox Action**

Interact directly with your Squeezebox devices from within rules and scripts. In order to use these actions you must also install the **org.openhab.io.squeezeserver** bundle and configure the 'squeeze' properties in openhab.cfg. See the [[Squeezebox Binding|Squeezebox binding]] section for more details. The 'id' you specify in your openhab.cfg is used to identify which player to perform the specified action on.

Send voice notifications to your Squeezebox devices; 
- `squeezeboxSpeak(String playerId, String message)`: Send an announcement to the specified player using the current volume
- `squeezeboxSpeak(String playerId, String message, int volume)`: Send an announcement to the specified player at the specified volume

Play a URL on one of your Squeezebox devices (e.g. start a radio stream when you wake up in the morning);
- `squeezeboxPlayUrl(String playerId, String url)`: Plays the URL on the specified player using the current volume
- `squeezeboxPlayUrl(String playerId, String url, int volume)`: Plays the URL on the specified player at the specified volume

Standard Squeezebox actions for controlling your devices;
- `squeezeboxPower(String playerId, boolean power)`
- `squeezeboxMute(String playerId, boolean mute)`
- `squeezeboxVolume(String playerId, int volume)`
- `squeezeboxPlay(String playerId)`
- `squeezeboxPause(String playerId)`
- `squeezeboxStop(String playerId)`
- `squeezeboxNext(String playerId)`
- `squeezeboxPrev(String playerId)`

See also [[Core Actions|Actions]].