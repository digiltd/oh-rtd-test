This binding can be used to connect through the CalDAV Interface to calendars.
First of all you need to add the org.openhab.io.caldav-version.jar to the addons folder.

**Currently the binding can just be loaded from here: [v09.10.2015](http://speedy.sh/qHKZJ/caldav-2015-10-09.zip) because the Pull-Request is not merged.**



openhab.cfg
* `caldavio:<calendar-id>:url=`
* `caldavio:<calendar-id>:username=`
* `caldavio:<calendar-id>:password=`
* `caldavio:<calendar-id>:reloadInterval=<minutes>`
* `caldavio:<calendar-id>:preloadTime=<minutes>`
* `caldavio:<calendar-id>:historicLoadTime=<minutes>`
* `caldavio:<calendar-id>:disableCertificateVerification=<true|false>`
* `caldavio:timeZone=<Timezone>`

**Restrictions**
* The calendar-id must be just upper- and lowercase characters. (e. g. private or work, something like 1 or private-home is not allowed)
* disableCertificateVerification can just be set to true (default is false) if ssl is used.
* timeZone must just be used if the local timezone of the pc is not the correct one. E. g. if you are living in Berlin and your calendar timezone is Berlin and your local pc timezone is Berlin you must not define this setting

***

# CalDAV Command
Binding file: org.openhab.binding.caldav-version.jar

Used to execute commands through an event, triggered at the start or the end of an event.
The event summary is free selectable. The event description must fullfill special syntax.
Syntax is `<BEGIN|END>:<Item-Name>:<Command>`.
Each item trigger must be a single line without linebreaks. Every line which starts with "BEGIN" will be executed at the begin of the event. Each line with an "END" will be executed at the end of the event. You can define multiple lines, which must not be ordered. For example:
<pre>BEGIN:Heater_Livingroom:22
BEGIN:Heater_Corridor:22
END:Heater_Livingroom:16
END:Heater_Corridor:16
END:Notification_Dummy:Heizung heruntergefahren</pre>

Additionaly you can define an item to listen to upcoming changes of an item (which will be triggered through an event). Two types are available the command which will be set and the trigger time.
Syntax is `caldavCommand="itemName:<Item-Name to listen to> type:<VALUE|DATE>"`
Furthermore a switch can be defined to disable the automatic execution (through calendar) of an item. 
Syntax is `caldavCommand="itemName:<Item-Name to listen to> type:<DISABLE>"`

openhab.cfg
`caldavCommand:readCalendars=<calendar-id>` (multiple calendars can be seperated by commas)

## Description of type
* VALUE: the value which will send to the command (can be of any type, depends on command in event and accepted commands of item)
* DATE: the time on which the event occurs (item type: DateTime)
* DISABLE: can turn off the automatic execution of the given item (item type: Switch)

***

# CalDAV Personal
Binding file: org.openhab.binding.caldav-presence-version.jar

* Used to detect presence through calendar events.
* Used to show upcoming/active events in openhab.

### openhab.cfg
* `caldavPersonal:usedCalendars=<calendar-id>` (multiple calendars can be seperated by commas)
* `caldavPersonal:homeIdentifiers=<values seperated by commans>` (if one of these identifiers can be found inside the place of the event, this event will not be used for presence)

### items
* `caldavPersonal="calendar:<calendar-id> type:<UPCOMING|ACTIVE|EVENT> eventNr:<event-nr, first one is 1> value:<NAME|DESCRIPTION|PLACE|START|END|TIME>"`
* `caldavPersonal="calendar:<calendar-id> type:PRESENCE" (type must be Switch)`

## Description of type
* UPCOMING: the next upcoming events, not the active ones
* ACTIVE: events which are currently on (internally used for presence detection)
* EVENT: all events, active as well as upcoming

## Description of value
* NAME: Name of the event (itemtype: String)
* DESCRIPTION: Event content (itemtype: String)
* PLACE: Place of event (itemtype: String)
* START: start time (itemtype: DateTime)
* END: end time (itemtype: DateTime)
* TIME: start/end time (itemtype: String)
* NAMEANDTIME: name und start- bis endzeit

# Logging
* `<logger name="org.openhab.binding.caldav_personal" level="TRACE"/>`
* `<logger name="org.openhab.binding.caldav_presence" level="TRACE"/>`
* `<logger name="org.openhab.io.caldav" level="TRACE"/>`

# Example configuration

There are three calendars defined. One of them is used just for executing commands in openhab (Command-kalender). The others are used to show the upcoming events (Müllkalender, Dienstlicher/privater Kalender).
In every case, the binding org.openhab.io.caldav-<version>.jar is needed. For executing commands the additional binding org.openhab.binding.caldav-command-<version>.jar is needed. For upcoming events or presence simulation the binding org.openhab.binding.caldav-personal-<version>.jar needs to be included.

openhab.cfg

    ################################ CalDav Binding #######################################
    #
    #caldavio:<calendar-id>:url=
    #caldavio:<calendar-id>:username=
    #caldavio:<calendar-id>:password=
    #caldavio:<calendar-id>:reloadInterval=<minutes>
    #caldavio:<calendar-id>:preloadTime=<minutes>
    #caldavio:timeZone=<e. g. Europe/Berlin>

    # Dienstlicher/privater Kalender
    caldavio:dienstlich:url=http://192.168.2.5/owncloud/remote.php/caldav/calendars/user/pers%C3%B6nlich
    caldavio:dienstlich:username=user
    caldavio:dienstlich:password=password
    caldavio:dienstlich:reloadInterval=60
    caldavio:dienstlich:preloadTime=2880
    caldavio:timeZone=Europe/Berlin

    # Müllkalender
    caldavio:muell:url=http://192.168.2.5/owncloud/remote.php/caldav/calendars/user/m%C3%BCll
    caldavio:muell:username=user
    caldavio:muell:password=password
    caldavio:muell:reloadInterval=1440
    caldavio:muell:preloadTime=2880
    caldavio:timeZone=Europe/Berlin

    # Command-kalender``
    caldavio:command:url=http://192.168.2.5/owncloud/remote.php/caldav/calendars/user/command
    caldavio:command:username=user
    caldavio:command:password=password
    caldavio:command:reloadInterval=10
    caldavio:command:preloadTime=1440
    caldavio:timeZone=Europe/Berlin

    # Additionally needed binding: org.openhab.binding.caldav-command-<version>.jar
    # used to execute commands by a triggered event
    # multiple calendars (calerdar-id) can be seperated by commas
    #caldavCommand:readCalendars=<calendar-id>
    caldavCommand:readCalendars=command

    # Additionally needed binding: org.openhab.binding.caldav-personal-<version>.jar
    # used to record and simulate presence and to show upcoming/active events
    # multiple calendars (calerdar-id) can be seperated by commas
    #caldavPersonal:usedCalendars=<calendar-id>
    caldavPersonal:usedCalendars=dienstlich,muell

    # If one of these identifiers can be found inside the place of the event, 
    # this event will not be used for presence
    #caldavPersonal:homeIdentifiers=<values seperated by commas>

The items-File:

    String OfficeCalName0	"Termin jetzt"		<calendar>	{ caldavPersonal="calendar:dienstlich type:ACTIVE eventNr:1 value:NAME" } //eventNr for concurrent events
    DateTime OfficeCalTime0	"Beginn"			<calendar>	{ caldavPersonal="calendar:dienstlich type:ACTIVE eventNr:1 value:START" } //eventNr for concurrent events
    String OfficeCalName1	"nächster Termin"	<calendar>	{ caldavPersonal="calendar:dienstlich type:UPCOMING eventNr:1 value:NAME" }
    DateTime OfficeCalTime1	"Beginn"			<calendar>	{ caldavPersonal="calendar:dienstlich type:UPCOMING eventNr:1 value:START" }
    String OfficeCalName2	"übernächster Termin" <calendar> { caldavPersonal="calendar:dienstlich type:UPCOMING eventNr:2 value:NAME" }
    DateTime OfficeCalTime2	"Beginn" 			<calendar> { caldavPersonal="calendar:dienstlich type:UPCOMING eventNr:2 value:START" }
