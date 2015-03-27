Overview of available actions

## Actions available in Scripts and Rules

Actions are predefined Java methods that are automatically statically imported and can be used within scripts and rules to execute openHAB specific operations.

Since openHAB 1.3.0, not all actions are part of the core runtime distribution anymore, but it is possible to easily implement add new actions to your runtime (see the [developer section](How-To-Implement-An-Action) for details).

### Core Actions

Here is the list of available actions in the core runtime:

**Event bus related actions:**
- `sendCommand(String itemName, String commandString)`: Sends the given command for the specified item to the event bus
- `postUpdate(String itemName, String stateString)`: Posts the given status update for the specified item to the event bus
- `Map<Item, State> storeStates(Item... items)`: Stores the current state of a list of items in a map which can be assigned to a variable. Group items are not themselves put into the map, but instead all their members.
- `restoreStates(Map<Item, State> statesMap)`: Restores item states from a map. If the saved state can be interpreted as a command, a command is sent for the item (and the physical device can send a status update if occurred). If it is no valid command, the item state is directly updated to the saved value.

**Audio actions:**
- `setMasterVolume(float volume)`: Sets the volume of the host machine (volume in range 0-1)
- `increaseMasterVolume(float percent)`: Increases the volume by x percent
- `decreaseMasterVolume(float percent)`: Decreases the volume by x percent
- `float getMasterVolume()`: Returns the volume with the range 0-1
- `playSound(String filename)`: Plays the given file (must be mp3 or wav and be located in `${openhab.home}/sounds`)
- `playStream(String url)`: Plays the audio stream from the given url.
- `say(String text)`: Says the given text through Text-to-speech
- `say(String text, String voice)`: Text-to-speech with a given voice (depends on the TTS engine or voices installed in the OS)
- `say(String text, String voice, String device)`: Text-to-speech with a given voice to the given output device (only supported on Mac OS)

**Logging:**
- `logDebug(String loggerName, String logText, Object[args))`: Logs `logText` on level `DEBUG` using the openhab Logback configuration
- `logInfo(String loggerName, String logText, Object[](]) args))`: Logs `logText` on level `INFO` using the openhab Logback configuration
- `logWarn(String loggerName, String logText, Object[args))`: Logs `logText` on level `WARN` using the openhab Logback configuration
- `logError(String loggerName, String logText, Object[](]) args))`: Logs `logText` on level `ERROR` using the openhab Logback configuration

**Other actions:**
- `sendHttpGetRequest(String url)`: Send out a GET-HTTP request
- `callScript(String scriptName)`: Calls a script which must be located in the configurations/scripts folder
- `createTimer(AbstractInstant instant, Procedure procedure)`: Schedules a block of code (a closure) for future execution.
- `executeCommandLine(String commandLine)`: Executes a command on the command line
- `executeCommandLine(String commandLine, int timeout)`: Executes a command on the command line with a timeout


### Add-on Actions

The following actions can be found in the "addons" download package. In order to install them to your runtime, simply copy the according jar file to the `${openhab.home}/addons` folder.
To make these actions available in the Designer as well, you need to copy the jar files into the `addons` folder of the Designer (note that you have to view the package content of the Designer in order to find the addons folder, if you are on Mac OS X). If the `addons` folder does not exist yet, simply create it.

**Mail Action**

This add-on provides SMTP services (please check openhab.cfg for required configuration settings):
- `sendMail(String to, String subject, String message)`: Sends an email via SMTP, to parameter can contain semicolon seperated multiple email addresses
- `sendMail(String to, String subject, String message, String attachmentUrl)`: Sends an email with attachment via SMTP

**XMPP Action**

*configure XMPP (openhab.cfg)*

Example: Google
```
xmpp:servername=talk.google.com
xmpp:securitymode=required
# You need this "tlspin" if openhab cannot verify the certificat from the google server
xmpp:tlspin=CERTSHA256:9e670d6624fc0c451d8d8e3efa81d4d8246ff9354800de09b549700e8d2a730a
xmpp:proxy=gmail.com
xmpp:username=my.openhab@gmail.com
xmpp:password=mysectret
# you may need to add the cryptic talk.google.com address of your private google account to the allowed users
# check you openhab.log to found the address after you send something via hangout to your openhab account
xmpp:consoleusers=**cryptic**@public.talk.google.com,myname@gmail.com
```
*using XMPP*

This add-on provides XMPP communication. Besides the action methods itself, it also contains the XMPP console (please check openhab.cfg for required configuration settings):
- `sendXMPP(String to, String message)`: Sends a message to an XMPP user
- `sendXMPP(String to, String message, String attachmentUrl)`: Sends a message with an attachment to an XMPP user
- `chatXMPP(String message)`: Sends a message to an multi user chat

**Prowl Action**

Prowl lets you use push notifications on iOS devices (please check openhab.cfg for required configuration settings):
- `pushNotification(String subject, String message)`: Pushes a Prowl Notification
- `pushNotification(String subject, String message, int priority)`: Pushes a Prowl Notification with the given priority

**Twitter Action**

Connect to Twitter through this action (please check openhab.cfg for required configuration settings):
- `sendTweet(String message)`: Sends a Tweet via Twitter
- `sendDirectMessage(String recipient, String message)`: Sends a direct Message via Twitter

**XBMC Action**

Sends notifications to XBMC
- `sendXbmcNotification(host, port, title, message)`: Sends a message to a given XBMC instance
- `sendXbmcNotification(host, port, title, message, image, displayTime)`: Sends a message to a given XBMC instance (image=a URL pointing to an image, displayTime=a display time for the message in milliseconds)

**NotifyMyAndroid Action**

Sends push messages to your Android devices. All configuration in openhab.cfg is optional
- `notifyMyAndroid(String event, String description)`: Send a message to a the pre configured api key (account) and use the configured or default values for the other parameters
- `notifyMyAndroid(String apiKey, String event, String description)`: Send a message to another api key than the configured or use this method if you have not configured a default api key
- `notifyMyAndroid(String apiKey, String event, String description, int priority, String url, boolean html)`: Send a message overwriting all configured parameters and using the specified values.

**Squeezebox Action**

Interact directly with your Squeezebox devices from within rules and scripts. In order to use these actions you must also install the **org.openhab.io.squeezeserver** bundle and configure the 'squeeze' properties in openhab.cfg. 

See the [[Squeezebox Action]] section for more details. 

**Pushover Action**

The pushover action allows you to notify mobile devices of a message using the Pushover API web service.

The following are configuration items for your openhab.cfg file. None of the options are required as you can specify required configuration items in the action call, but you must at least provide an _API Token_, _User/Group Key_ and a _Message_ in some manner before a message can be pushed.

- `pushover:defaultTimeout - The timeout for the communication with the Pushover service.`
- `pushover:defaultToken - Pushover API token to send to devices.`
- `pushover:defaultUser - Pushover User or Group key to send to devices.`
- `pushover:defaultTitle - Application title for the notification.`
- `pushover:defaultPriority - Priority of the notification. Default is 0.`
- `pushover:defaultUrl - A URL to send with the notification.`
- `pushover:defaultUtlTitle - Title of the URL to send with the notification.`
- `pushover:defaultRetry - When priority is 2, how often in seconds should messages be resent.` [Added 1.6+]
- `pushover:defaultExpire - When priority is 2, how long to continue resending messages until acknowledged.`  [Added 1.6+]

The following are valid action calls that can be made when the plugin is loaded. For specific information on each item, see the [Pushover API](https://pushover.net/api).

- `pushover(String message)`
- `pushover(String message, String device)`
- `pushover(String message, int priority)`
- `pushover(String message, int priority, String url)` [Added 1.6+]
- `pushover(String message, int priority, String url, String urlTitle)` [Added 1.6+]
- `pushover(String message, int priority, String url, String urlTitle, String soundFile)` [Added 1.6+]
- `pushover(String message, String device, int priority)`
- `pushover(String message, String device, int priority, String url)` [Added 1.6+]
- `pushover(String message, String device, int priority, String url, String urlTitle)` [Added 1.6+]
- `pushover(String message, String device, int priority, String url, String urlTitle, String soundFile)` [Added 1.6+]
- `pushover(String apiToken, String userKey, String message)`
- `pushover(String apiToken, String userKey, String message, String device)`
- `pushover(String apiToken, String userKey, String message, int priority)`
- `pushover(String apiToken, String userKey, String message, String device, int priority)`
- `pushover(String apiToken, String userKey, String message, String device, String title, String url, String urlTitle, int priority, String soundFile)`

**OpenWebIf Action**

The openwebif action allows you to send a message to enigma2 based linux sat receivers (Dreambox, VU+, Clarke-Tech, ...) with installed OpenWebIf plugin.

Configure your sat receivers in openhab.cfg, you can specify multiple sat receivers identified by name:
```
openwebif:receiver.<name>.host=
openwebif:receiver.<name>.port=
openwebif:receiver.<name>.user=
openwebif:receiver.<name>.password=
openwebif:receiver.<name>.https=
```

Example:
```
openwebif:receiver.main.host=vusolo2
openwebif:receiver.main.port=81
openwebif:receiver.main.user=root
openwebif:receiver.main.password=xxxxx
openwebif:receiver.main.https=false
```

Now you can send a message to the configured receiver:
- `sendOpenWebIfNotification(NAME, MESSAGE, TYPE, TIMEOUT);`  

**NAME:** The name of the sat receiver configured in openhab.cfg  
**MESSAGE:** The message to send to the receiver  
**TYPE:** The message type (INFO, WARNING, ERROR)  
**TIMEOUT:** How long the text will stay on the screen in seconds  

Example:  
`sendOpenWebIfNotification("main", "Hello World!\n\nThis is a message sent from openHab!", "WARNING", 10);`

![](https://farm4.staticflickr.com/3882/15284270826_8cf0e637d8_z.jpg)


**Astro Action**  
With the Astro-Action you can calculate sunrise and sunset DataTime values in rules. It's been released with openHab 1.7, but you can use it now with a snapshot build from [cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/).  
**Important:** The action also requires the corresponding Astro-Binding from cloudbees!

Example:
```
import org.openhab.core.library.types.*
import java.util.Date

rule "Astro Action Example"
when
	...
then
	var Date current = now.toDate
	var double lat = xx.xxxxxx
	var double lon = xx.xxxxxx

	logInfo("sunRiseStart: ", new DateTimeType(getAstroSunriseStart(current, lat, lon)).toString)
	logInfo("sunRiseEnd: ", new DateTimeType(getAstroSunriseEnd(current, lat, lon)).toString)

	logInfo("sunSetStart: ", new DateTimeType(getAstroSunsetStart(current, lat, lon)).toString)
	logInfo("sunSetEnd: ", new DateTimeType(getAstroSunsetEnd(current, lat, lon)).toString)
end
```