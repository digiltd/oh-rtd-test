Documentation of the Google Calendar IO-Bundle

## Introduction

If you want to administer events in Google Calendar that will be executed by openHAB this bundle will do the job. See the following sections on how to configure the necessary data and how to obtain the GCal URL. 

## Calendar Event Configuration

The event title can be anything and the event description will have the commands to execute.

The format of Calendar event description is simple and looks like this:

    start {
      send|update <item> <state>
    }
    end {
      send|update <item> <state>
    }

or just

    send|update <item> <state>

The commands in the `start` section will be executed at the even start time and the `end` section at the event end time. If these sections are not present, the commands will be executed at the event start time.

As a result, your lines in a Calendar event might look like this:

    start {
      send Light_Garden ON
      send Pump_Garden ON
    }
    end {
      send Light_Garden OFF
      send Pump_Garden OFF
    }

or just

    send Light_Garden ON
    send Pump_Garden ON

## Obtain the calendar URL

openHAB must be configured with your google calendar of choice. The URL has to be configured in your openhab.cfg. The following cases are supported:

1. URL, username, password (Calendar Address)
2. URL (Private Address)


**Alternative 1:** To obtain the google calendar URL using username/password
- fill in gcal:url gcal:username, gcal:password in openhab.cfg
- login in to https://www.google.com/calendar/
- click "Settings" (under "My calendars") -> \<your calendar\>
- find the calendar URL in in heading "Calendar Address" -> "XML". The URL for will be something like this:
`https://www.google.com/calendar/feeds/user@gmail.com/public/basic` 
- copy the given url and replace "basic" with "full". Note: if you want to write entries to your calendar (via gcal persistence for example), "public" must also be replaced with "private".

The final URL should be similar to:
`https://www.google.com/calendar/feeds/user@gmail.com/private/full`

Google added a new security feature which needs to be disabled for this method to work. Go to https://www.google.com/settings/security/lesssecureapps and allow access for less secure apps.

**Alternative 2:** To obtain the google calendar URL without password (only for reading !!):
- only gcal:url should be used in openhab.cfg
- login in to https://www.google.com/calendar/
- click "Settings" (under "My calendars") -> \<your calendar\>
- find the calendar URL in in heading "Private Address" -> "XML". The URL for will be something like this:
`https://www.google.com/calendar/feeds/user@gmail.com/private-da2412ef24124f151214deedbeef1234/basic`
- copy the given url and replace "basic" with "full". 

The final URL should be similar to:
`https://www.google.com/calendar/feeds/user@gmail.com/private-da2412ef24124f151214deedbeef1234/full`


# Presence Simulation

The GCal persistence bundle can be used to realize a simple but effective Presence Simulation feature (thanks Ralf for providing the concept). Every single change of an item that belongs to a certain group is posted as new calendar entry in the future. By default each entry is posted with an offset of 14 days (If you'd like to change the offset please change the parameter `gcal-persistence:offset` in your `openhab.cfg`). Each calendar entry looks like the following:

- title: `[PresenceSimulation] <itemname>`
- content: `> if (PresenceSimulation.state == ON) sendCommand(<itemname>,<value>)`

To make use of the Presence Simulation you have to walk through these configuration steps:

- make sure that you are using the correct openHAB release (at least 1.0.0-SNAPSHOT)
- configure the gcal-persistence bundle by adding the appropriate configuration in your `openhab.cfg`. All entries start with `gcal-persistence`. You must at least add the username, password and url. Get the url using the 'alternative 1' method. The url must end with "/private/full".
- make sure your items file contains items that belong to the group `PresenceSimulationGroup` - if you would like to change the group name change it at `gcal.persist`.
- make sure your items file contains an item called `PresenceSimulation` which is referred by the scripts executed at a certain point in time - if you would like to change the group name please change the parameter `gcal-persistence:executescript` in your openhab.cfg`.
- make sure the referenced gcal calendar is writeable by the given user (google calendar website)

Note: you also need to configure the gcal-io binding (Google Calendar Configuration in 'openhab.cfg') to be able to read the entries from the calendar and act on it!

To activate the Presence Simulation simply set `PresenceSimulation` to `ON` and the already downloaded events are being executed. Your smartHome behaves like you did 14 days ago.

A sample `gcal.persist` file looks like this:

    Strategies {
    	default = everyChange
    }
    
    Items {
    	PresenceSimulationGroup* : strategy = everyChange
    }

## Solving gcal persistence errors:
To solve any issues with any binding, increase the logging. For gcal, add these lines to your 'logback.xml'

    <logger name="org.openhab.persistence.gcal" level="TRACE" />
    <logger name="org.openhab.io.gcal" level="TRACE" />

* "GCal PresenceSimulation Service isn't initialized properly! No entries will be uploaded to your Google Calendar"

    The persistence configuration is not correct; username, password and url are required.
    Configuration entries must be prefixed by `gcal-persistence:`.

* "creating a new calendar entry throws an exception: Forbidden"

    This can have several causes:
    * The username/password might not be correct

    * The url is not correct. Get the url from your calendar settings, in the 'calendar details' at the 'Calendar Address'. Get the XML url. Always use 'https'. Make sure the url ends with "/private/full".

    * If your not using your own calendar, make sure the sharing settings are correct and the user has sufficient rights to create calendar entries.

