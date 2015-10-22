Documentation of the persistence service in openHAB

## Introduction

The persistence support stores item states over time (a time series). openHAB is not restricted to a single data store. Different stores can co-exist and be configured independently.

When persisting states, there are many different possibilities one might think of: relational databases, NoSQL databases, round-robin databases, Internet-of-Things (IoT) cloud services, simple log files etc.
openHAB tries to make all of these options possible and configurable in the same way. Note that some options might only be good for exporting data (e.g. IoT services or log files), while others can be easily queried as well and hence be used for providing historical data for openHAB functionality.

In openHAB, we call these different options the available "persistence services".

Currently, there are the following implementations available:
- [db4o](http://www.db4o.com/) - a lightweight, 100% pure Java object database
- [rrd4j](http://code.google.com/p/rrd4j/) - a Java version of the powerful round-robin database solution [RRDtool](http://oss.oetiker.ch/rrdtool/).
- [mysql](http://www.mysql.com/) - MySQL database tables
- [mongodb](http://www.mongodb.org/) - MongoDB document store
- [Open.Sen.Se](http://open.sen.se/) - a fancy Internet-of-Things platform, which allows data processing in many ways and from different sources
- logging using [Logback](http://logback.qos.ch/) - writing item states to log files with a highly flexible syntax definition
- [InfluxDB](http://influxdb.org) - An open-source distributed time series database with no external dependencies.
- Java Persistence API [JPA](http://en.wikipedia.org/wiki/Java_Persistence_API) - Binding that supports a range of SQL and NoSQL databases. In version 1.6 of openHAB JPA binding comes with MySQL, Apache Derby and PostgreSQL drivers.

## Configuration

For every persistence service that you have installed and want to use, you have to put a configuration file named `<persistenceservice>.persist` (e.g. `db4o.persist`) in the folder `${openhab.home}/configurations/persistence`. These files should be edited with the openHAB Designer, which provides syntax checks, auto-completion and more.

Before going into the details of the syntax of these files, let us discuss the concept behind it first:
The basic idea is to provide a simple way to tell openHAB, which items should be persisted when. The persistence configuration defines so called "strategies" for this. These are very similar to the triggers of [[Rules|rules]] as you will most likely also either persist a value when some bus event occurred (i.e. an item state has been updated or changed) or with a fixed schedule as the [cron expressions](http://www.quartz-scheduler.org/documentation/quartz-2.1.x/tutorials/crontrigger) allow to define. 

The persistence configuration files hence consist out of several sections:

**Strategies section**: This allows to define strategies and to declare a set of default strategies to use (for this persistence service). The syntax is the following:
```
Strategies {
    <strategyName1> : "<cronexpression1>"
    <strategyName2> : "<cronexpression2>"
    ...
    
    default = <strategyNameX>, <strategyNameY>
}
```
The following strategies are already statically defined (and thus do not need to be listed here, but can be declared as a default):
* everyChange: persist the state whenever its state has changed
* everyUpdate: persist the state whenever its state has been updated, even if it did not change
* restoreOnStartup:If the state is undefined at startup, the last persisted value is loaded and the item is initialized with this state. This is very handy for all "virtual" items that do not have any binding to real hardware, like "Presence" or similar.

**Items section**: This defines, which items should be persisted with which strategy. The syntax is:
```
Items {
    <itemlist1> [-> "<alias1>"] : [strategy = <strategy1>, <strategy2>, ...]
    <itemlist2> [-> "<alias2>"] : [strategy = <strategyX>, <strategyY>, ...]
    ...
}
```
where `<itemlist>` is a comma-separated list of the following options:
- `*` - this line should apply to all items in the system.
- `<itemName>` - a single item identified by its name. This item can be a group item, but note that only its own (group) value will be persisted, not the states of its members.
- `<groupName>*` - all members of this group will be persisted, but not the group itself.
  If no strategies are provided, the default strategies that are declared in the first section are used.
  An alias can be optionally provided, if the persistence service requires special names (e.g. a table to use in a database, a feed id for an IoT-service etc.) 

As a result, a valid persistence configuration file might look like this:

    // persistence strategies have a name and a definition and are referred to in the "Items" section
    Strategies {
    	everyHour : "0 0 * * * ?"
    	everyDay  : "0 0 0 * * ?"
    
    	// if no strategy is specified for an item entry below, the default list will be used
    	default = everyChange
    }
    
    /* 
     * Each line in this section defines for which item(s) which strategy(ies) should be applied.
     * You can list single items, use "*" for all items or "groupitem*" for all members of a group
     * item (excl. the group item itself).
     */
    Items {
    	// persist all items once a day and on every change and restore them from the db at startup
    	* : strategy = everyChange, everyDay, restoreOnStartup
    	
    	// additionally, persist all temperature and weather values every hour
    	Temperature*, Weather* : strategy = everyHour
    }

## Persistence Extensions in Scripts and Rules

To make use of persisted states inside scripts and rules, a couple of useful extensions have been defined on items. In contrast to an action (which is a function that can be called anywhere in a script or rule), an extension is a function that is only available like a method on a certain type. This means that the persistence extensions are available like methods on all items. An example will make this clearer:
The statement

    Temperature.historicState(now.minusDays(1))
will return the state of the item "Temperature" from 24 hours ago. You can easily imagine that you can implement very powerful rules with this kind of feature.

Here is the full list of available persistence extensions:

    <item>.persist - Persists the current state
    <item>.lastUpdate - Query for the last update timestamp of a given item.
    <item>.historicState(AbstractInstant) - Retrieves the state of the item at a certain point in time
    <item>.changedSince(AbstractInstant) - Checks if the state of the item has (ever) changed since a certain point in time
    <item>.updatedSince(AbstractInstant) - Checks if the state of the item has been updated since a certain point in time
    <item>.maximumSince(AbstractInstant) - Gets the maximum value of the state of the item since a certain point in time
    <item>.minimumSince(AbstractInstant) - Gets the minimum value of the state of the item since a certain point in time
    <item>.averageSince(AbstractInstant) - Gets the average value of the state of a given item since a certain point in time.
    <item>.deltaSince(AbstractInstant) - Gets the difference value of the state of a given item since a certain point in time.
    <item>.previousState(AbstractInstant) - Retrieves the previous state of the item.
    <item>.previousState(AbstractInstant, true) - Retrieves the previous state of the item, skips equal state values and searches the first state not equal the current state

These extensions use the default persistence service that is configured in openhab.cfg. If the default service should not be used, all extensions accept a String as a further parameter for the persistence service to use (e.g. "rrd4j" or "sense").

For all kinds of time and date calculations, [Jodatime](http://joda-time.sourceforge.net/) has been made available in the scripts and rules. This makes it very easy to navigate through time, here are some examples of valid expressions:

    Lights.changedSince(now.minusMinutes(2).minusSeconds(30))
    Temperature.maximumSince(now.toDateMidnight)
    Temperature.minimumSince(parse("2012-01-01"))
    PowerMeter.historicState(now.toDateMidnight.withDayOfMonth(1))
The "now" variable can be used for relative time expressions, while "parse()" can define absolute dates and times. See the [Jodatime documentation](http://joda-time.sourceforge.net/api-release/org/joda/time/format/ISODateTimeFormat.html#dateTimeParser()) on what string formats are supported for parsing.

## Startup Behavior
Persistence services and rule engine are started in parallel. It may happen that rules are already executed using items that have not been persisted yet having an "undefined" state. Therefore, rules that rely on persisted information break during this time.

####Workaround 1####

A workaround which helped some cases is to introduce an item e.g. "delayed_start" that is set to "OFF" at startup and to "ON" some time later (when it can be assumed that persistence has restored all items. The time needs to be determined empirically. It is influenced by the size of your home automation project and the performance of your platform).
The affected rules then have to be masked by using "delayed_start".

####Workaround 2####
Create `configurations/rules/refresh.rules` with following content. It runs a refresh script when openHAB is started.

    var boolean reloadOnce = true
    rule "Refresh rules after persistance service started"
      when System started
    then
      if(reloadOnce)
        executeCommandLine("./configurations/rules_refresh.sh")
      else
        println("reloadOnce is false")
      reloadOnce = false
    end

Create according refresh script `configurations/rules_refresh.sh` and make runnable (`chmod +x rules_refresh.sh`):

    # This script is called by openHAB after persistance service was started
    sleep 5
    cd [full_path_to_openhab]/configurations/rules/
    RULES=`find *.rules | grep -v refresh.rules`
    for f in $RULES
    do
      touch $f
    done 

The script waits for 5 seconds, then touches all `*.rules` files (except `refresh.rules`) which causes openHAB to reload these files. Other rules-files may be added on new lines.