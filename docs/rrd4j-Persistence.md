Documentation of the rrd4j Persistence Service

## Introduction

The rrd4j Persistence Service is based on a round-robin database, specifically it uses the project [rrd4j](http://code.google.com/p/rrd4j/) as its name suggests.

## Features

In contrast to a "normal" database such as db4o, a round-robin database does not grow in size - it has a fixed allocated size, which is used. This is accomplished by doing data compression, which means that the older the data is, the less values are available. So while you might have a value every minute for the last 24 hours, you might only have one every day for the last year.

There are many possibilities in rrd4j to define how the data compression should work in detail. openHAB comes at the moment with a fixed setting which looks like this (see the [rrd4j tutorial for details](https://github.com/rrd4j/rrd4j/wiki/Tutorial):

    // for measurement values, we define archives that are suitable for charts
    rrdDef.setStep(60);
    rrdDef.addDatasource(DATASOURCE_STATE, DsType.GAUGE, 60, Double.NaN, Double.NaN);
    rrdDef.addArchive(function, 0.5, 1, 480); // 8 hours (granularity 1 min)
    rrdDef.addArchive(function, 0.5, 4, 360); // one day (granularity 4 min)
    rrdDef.addArchive(function, 0.5, 15, 644); // one week (granularity 15 min)
    rrdDef.addArchive(function, 0.5, 60, 720); // one month (granularity 1 hour)
    rrdDef.addArchive(function, 0.5, 720, 730); // one year (granularity 12 hours)
    rrdDef.addArchive(function, 0.5, 10080, 520); // ten years (granularity 7 days)

    // for other things (switches, contacts etc), we mainly provide a high level of detail for the last hour
    rrdDef.setStep(1);
    rrdDef.addDatasource(DATASOURCE_STATE, DsType.GAUGE, 3600, Double.NaN, Double.NaN);
    rrdDef.addArchive(function, .999, 1, 3600); // 1 hour (granularity 1 sec)
    rrdDef.addArchive(function, .999, 10, 1440); // 4 hours (granularity 10 sec)
    rrdDef.addArchive(function, .999, 60, 1440); // one day (granularity 1 min)
    rrdDef.addArchive(function, .999, 900, 2880); // one month (granularity 15 min)
    rrdDef.addArchive(function, .999, 21600, 1460); // one year (granularity 6 hours)
    rrdDef.addArchive(function, .999, 86400, 3650); // ten years (granularity 1 day)

In future versions it is planned to offer an "expert mode", where these values are configurable.

The rrd4j Persistence Service cannot be directly queried, because of the data compression. You could not provide precise answers for all questions. 

## Installation

For installation of this persistence package please follow the same steps as if you would [install a binding](Bindings).

## Configuration

Place a persistence file called rrd4j.persist in the `${openhab_home}/configuration/persistence` folder.

See [Persistence](Persistence) for details on configuring this file.

## Troubleshooting

From time to time, you may find that if you change the item type of a persisted data, you may experience charting or other problems. To resolve this issue, remove the old <item_name>.rrd file in the `${openhab_home}/etc/rrd4j` folder or `/var/lib/openhab/persistence/rrd4j` folder for apt-get installed openHABs.

Restore of items after startup is taking some time. Rules are already started in parallel. Especially in rules that are started via "System started" trigger, it may happen that the restore is not completed resulting in defined items. In these cases the use of restored items has to be delayed by a couple of seconds. This delay has to be determined experimentally.


## Further information about RRD4J
RRDs have fixed-length so-called "archives" for storing values. One RRD can have (in general) several datasources and each datasource can have several archives. OpenHAB only support one datasource per RRD, which is named DATASOURCE_STATE.

### COUNTER, GAUGE, DERIVE and ABSOLUTE
Depending on the data to be stored, several types for datasources exist:
COUNTER, GAUGE, DERIVE and ABSOLUTE.

COUNTER represents a ever-incrementing value (historically this was used for packet counters or traffic counters on network interfaces, a typical home-automation application would be your electricity meter). If you store the values of this counter in a simple database and make a chart of that, you'll most likely see a nearly flat line, because the increments per time are small compared to the absolute value (e.g. your electricity meter reads 60567 kWh, and you add 0.5 kWh per hour, than your chart over the whole day will show 60567 at the start and 60579 at the end of your chart. That is nearly invisible. RRD4J helps you out and will display the difference from one stored value to the other (depending on the selected size).

GAUGE represents the reading of e.g. a temperature sensor. You'll see only small deviation over the day and your values will be within a small range, clearly visible within a chart.

ABSOLUTE is like a counter, but RRD4J assumes that the counter is reset when the value is read. So these are basically the delta values between the reads.

DERIVE is like a counter, but it can also decrease and therefore have a negative delta. 

### Heartbeat, MIN, MAX
Each datasource also has a value for heartbeat, minimum and maximum. This heartbeat setting helps the database to detect "missing" values, i.e. if no new value is stored after "heartbeat" seconds, the value is considered missing when charting. Minimum and maximum define the range of acceptable values for that datasource.

### Steps
Now for the archives: As already said, each datasource can have several archives. Think of an archive as a drawer with a fixed number of boxes in it. Each steps*step seconds  (the step is globally defined for the RRD, 60s in our example) the most-left box is emptied, the content of all boxes is moved one box to the left and new content is added to the most right box. The "steps" value is defined per archive it is the third parameter in the archive definition. The number of boxes is defined as the fourth parameter.

### Example
So in the above example, we have 480 boxes, which each represent the value of one minute (Step is set to 60s, Granularity = 1). If more than one value is added to the database within (steps*step) second (and thus more than one value would be stored in one box), the "consolidation function" is used. OpenHAB uses AVERAGE as default for numeric values, so if you add 20 and 21 within one minute, 20.5 would be stored. 480 minutes is 8 hours, so we have a 8h with the granularity of one minute.

The same goes for the next archives, for larger time spans, the stored values are less "exact". However, usually you are not interested in the exact temperature for a selected minute two years ago.

## New in 1.7
As of Openhab 1.7 it is possible to configure the earlier described values. Example:
```
# rrd4j:<dsname>.def=<dstype>,<heartbeat>,[<min>|U],[<max>|U],<step>
# rrd4j:<dsname>.archives=<consolidationfunction>,<xff>,<steps>,<rows>    
# rrd4j:<dsname>.items=<list of items for this dsname>
rrd4j:ctr5min.def=COUNTER,900,0,U,300
rrd4j:ctr5min.archives=AVERAGE,0.5,1,365
rrd4j:ctr5min.archives=AVERAGE,0.5,7,300 
rrd4j:ctr5min.items=Item1,Item2
```