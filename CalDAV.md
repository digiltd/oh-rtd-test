This binding can be used to connect through the CalDAV Interface to calendars.

First of all you need to add the org.openhab.io.caldav-version.jar to the addons folder.

openhab.cfg
`caldavio:<calendar-id>:url=`
`caldavio:<calendar-id>:username=`
`caldavio:<calendar-id>:password=`
`caldavio:<calendar-id>:reloadInterval=<minutes>`
`caldavio:<calendar-id>:preloadTime=<minutes>`

# CalDAV Tasker
Binding file: org.openhab.binding.caldav-version.jar

Used to execute commands through an event, triggered at the start or the end of an event.
Syntax is `<BEGIN|END>:<Item-Name>:<Command>`.

Additionaly you can define an item to listen to upcoming changes of an item (which will be triggered through an event). Two types are available the command which will be set and the trigger time.
Syntax is `caldav="itemName:<Item-Name to listen to>:<VALUE|DATE>"`

openhab.cfg
`caldav:readCalendars=<calendar-id>` (multiple calendars can be seperated by commas)

# CalDAV Presence
Binding file: org.openhab.binding.caldav-presence-version.jar

Used to detect presence through calendar events.

openhab.cfg
`caldavPresence:usedCalendars=<calendar-id>` (multiple calendars can be seperated by commas)
`caldavPresence:homeIdentifiers=<values seperated by commans>` (if one of these identifiers can be found inside the place of the event, this event will not be used for presence)

items
`caldavPresence="<calendar-id>"`

