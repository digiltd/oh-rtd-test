# Overview of avaialble actions

# Actions available in Scripts and Rules

Actions are predefined Java methods that are automatically statically imported and can be used within scripts and rules to execute openHAB specific operations.

Since openHAB 1.3.0, not all actions are part of the core runtime distribution anymore, but it is possible to easily implement add new actions to your runtime (see the [developer section](How-To-Implement-An-Action) for details).

## Core Actions

Here is the list of available actions in the core runtime:

**Event bus related actions:**
- {{{sendCommand(String itemName, String commandString)}}}: Sends the given command for the specified item to the event bus
- {{{postUpdate(String itemName, String stateString)}}}: Posts the given status update for the specified item to the event bus
- {{{Map<Item, State> storeStates(Item... items)}}}: Stores the current state of a list of items in a map which can be assigned to a variable. Group items are not themselves put into the map, but instead all their members.
- {{{restoreStates(Map<Item, State> statesMap)}}}: Restores item states from a map. If the saved state can be interpreted as a command, a command is sent for the item (and the physical device can send a status update if occurred). If it is no valid command, the item state is directly updated to the saved value.

**Audio actions:**
- {{{setMasterVolume(float volume)}}}: Sets the volume of the host machine (volume in range 0-1)
- {{{increaseMasterVolume(float percent)}}}: Increases the volume by x percent
- {{{decreaseMasterVolume(float percent)}}}: Decreases the volume by x percent
- {{{float getMasterVolume()}}}: Returns the volume with the range 0-1
- {{{playSound(String filename)}}}: Plays the given file (must be mp3 or wav and be located in {{{${openhab.home}/sounds}}})
- {{{playStream(String url)}}}: Plays the audio stream from the given url.
- {{{say(String text)}}}: Says the given text through Text-to-speech
- {{{say(String text, String voice)}}}: Text-to-speech with a given voice (depends on the TTS engine or voices installed in the OS)
- {{{say(String text, String voice, String device)}}}: Text-to-speech with a given voice to the given output device (only supported on Mac OS)

**Logging:**
- {{{logDebug(String loggerName, String logText, Object[args))}}}: Logs {{{logText}}} on level {{{DEBUG}}} using the openhab Logback configuration
- {{{logInfo(String loggerName, String logText, Object[](]) args))}}}: Logs {{{logText}}} on level {{{INFO}}} using the openhab Logback configuration
- {{{logWarn(String loggerName, String logText, Object[args))}}}: Logs {{{logText}}} on level {{{WARN}}} using the openhab Logback configuration
- {{{logError(String loggerName, String logText, Object[](]) args))}}}: Logs {{{logText}}} on level {{{ERROR}}} using the openhab Logback configuration

**Other actions:**
- {{{sendHttpGetRequest(String url)}}}: Send out a GET-HTTP request
- {{{callScript(String scriptName)}}}: Calls a script which must be located in the configurations/scripts folder
- {{{createTimer(AbstractInstant instant, Procedure procedure)}}}: Schedules a block of code (a closure) for future execution.
- {{{executeCommandLine(String commandLine)}}}: Executes a command on the command line
- {{{executeCommandLine(String commandLine, int timeout)}}}: Executes a command on the command line with a timeout


## Add-on Actions

The following actions can be found in the "addons" download package. In order to install them to your runtime, simply copy the according jar file to the {{{${openhab.home}/addons}}} folder.
To make these actions available in the Designer as well, you need to copy the jar files into the {{{addons}}} folder of the Designer (note that you have to view the package content of the Designer in order to find the addons folder, if you are on Mac OS X). If the {{{addons}}} folder does not exist yet, simply create it.

** Mail Action **

This add-on provides SMTP services (please check openhab.cfg for required configuration settings):
- {{{sendMail(String to, String subject, String message)}}}: Sends an email via SMTP
- {{{sendMail(String to, String subject, String message, String attachmentUrl)}}}: Sends an email with attachment via SMTP

** XMPP Action **

This add-on provides XMPP communication. Besides the action methods itself, it also contains the XMPP console (please check openhab.cfg for required configuration settings):
- {{{sendXMPP(String to, String message)}}}: Sends a message to an XMPP user
- {{{sendXMPP(String to, String message, String attachmentUrl)}}}: Sends a message with an attachment to an XMPP user

** Prowl Action **

Prowl lets you use push notifications on iOS devices (please check openhab.cfg for required configuration settings):
- {{{pushNotification(String subject, String message)}}}: Pushes a Prowl Notification
- {{{pushNotification(String subject, String message, int priority)}}}: Pushes a Prowl Notification with the given priority

** Twitter Action **

Connect to Twitter through this action (please check openhab.cfg for required configuration settings):
- {{{sendTweet(String message)}}}: Sends a Tweet via Twitter
- {{{sendDirectMessage(String recipient, String message)}}}: Sends a direct Message via Twitter

** XBMC Action **

Sends notifications to XBMC
- {{{sendXbmcNotification(host, port, title, message)}}}: Sends a message to a given XBMC instance
- {{{sendXbmcNotification(host, port, title, message, image, displayTime)}}}: Sends a message to a given XBMC instance (image=a URL pointing to an image, displayTime=a display time for the message in milliseconds)

** !NotifyMyAndroid Action **

Sends push messages to your Android devices. All configuration in openhab.cfg is optional
- {{{notifyMyAndroid(String event, String description)}}}: Send a message to a the pre configured api key (account) and use the configured or default values for the other parameters
- {{{notifyMyAndroid(String apiKey, String event, String description)}}}: Send a message to another api key than the configured or use this method if you have not configured a default api key
- {{{notifyMyAndroid(String apiKey, String event, String description, int priority, String url, boolean html)}}}: Send a message overwriting all configured parameters and using the specified values.

** Squeezebox Action **

Interact directly with your Squeezebox devices from within rules and scripts. In order to use these actions you must also install the **org.openhab.io.squeezeserver** bundle and configure the 'squeeze' properties in openhab.cfg. See the [[Squeezebox Binding|Squeezebox binding]] section for more details. The 'id' you specify in your openhab.cfg is used to identify which player to perform the specified action on.

Send voice notifications to your Squeezebox devices; 
- {{{squeezeboxSpeak(String playerId, String message)}}}: Send an announcement to the specified player using the current volume
- {{{squeezeboxSpeak(String playerId, String message, int volume)}}}: Send an announcement to the specified player at the specified volume

Play a URL on one of your Squeezebox devices (e.g. start a radio stream when you wake up in the morning);
- {{{squeezeboxPlayUrl(String playerId, String url)}}}: Plays the URL on the specified player using the current volume
- {{{squeezeboxPlayUrl(String playerId, String url, int volume)}}}: Plays the URL on the specified player at the specified volume

Standard Squeezebox actions for controlling your devices;
- {{{squeezeboxPower(String playerId, boolean power)}}}
- {{{squeezeboxMute(String playerId, boolean mute)}}}
- {{{squeezeboxVolume(String playerId, int volume)}}}
- {{{squeezeboxPlay(String playerId)}}}
- {{{squeezeboxPause(String playerId)}}}
- {{{squeezeboxStop(String playerId)}}}
- {{{squeezeboxNext(String playerId)}}}
- {{{squeezeboxPrev(String playerId)}}}