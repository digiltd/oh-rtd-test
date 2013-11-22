Documentation of the Google Calendar IO-Bundle

## Introduction

If you want to administer events in Google Calendar that will be executed by openHAB this bundle will do the job. See the following sections on how to configure the necessary data and how to obtain the GCal URL. 

## Calendar Event Configuration

The format of Calendar event content is simple and looks like this:

    start {
      send|update <item> <state>
    }
    end {
      send|update <item> <state>
    }

or just

    send|update <item> <state>

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

openHAB must be configured with your google calendar of choice. The URL has to be configured in your openhab.cfg. To obtain the google calendar URL please walk through the following steps:

- login in to https://www.google.com/calendar/
- click "Settings" (under "My calendars") -> <your calendar> -> Calendar address "XML"
- copy the given url and replace "basic" with "full"


## Full text query

In order to reduce the amount of events one may want to filter them. Please enhance the calendar URL with the query parameter "q" with the fulltext to be searched in the events.

    https://www.google.com/calendar/feeds/jo@gmail.com/private/full?q=openHAB

The URL above returns all events which contain the Text "openHAB"


# Presence Simulation

The GCal bundle can be used to realize a simple but effective Presence Simulation feature (thanks Ralf for providing the concept). Every single change of an item that belongs to a certain group is posted as new calendar entry in the future. By default each entry is posted with an offset of 14 days (If you'd like to change the offset please change the parameter `gcal:offset` in your `openhab.cfg`). Each calendar entry looks like the following:

- title: `[[Presence|Simulation]] <itemname>`
- content: `> if (PresenceSimulation.state == ON) sendCommand(<itemname>,<value>)`

To make use of the Presence Simulation you have to walk through these configuration steps:

- make sure that you are using the correct openHAB release (at least 1.0.0-SNAPSHOT)
- make sure your items file contains items that belong to the group `PresenceSimulationGroup` - if you would like to change the group name change it at `presence simulation.persist`.
- make sure your items file contains an item called `PresenceSimulation` which is referred by the scripts executed at a certain point in time - if you would like to change the group name please change the parameter `gcal:executescript` in your openhab.cfg`.
- make sure the referenced gcal calendar is writeable by the given user (google calendar website)

To activate the Presence Simulation simply set `PresenceSimulation` to `ON` and the already downloaded events are being executed. Your smartHome behaves like you did 14 days ago.

A sample simulation.persist file looks like this:

    Strategies {
    	default = everyChange
    }
    
    Items {
    	PresenceSimulationGroup* : strategy = everyChange
    }