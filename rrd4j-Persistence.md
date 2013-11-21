# Documentation of the rrd4j Persistence Service

# Introduction

The rrd4j Persistence Service is based on a round-robin database, specifically it uses the project [rrd4j](http://code.google.com/p/rrd4j/) as its name suggests.

# Features

In contrast to a "normal" database such as db4o, a round-robin database does not grow in size - it has a fixed allocated size, which is used. This is accomplished by doing data compression, which means that the older the data is, the less values are available. So while you might have a value every minute for the last 24 hours, you might only have one every day for the last year.

There are many possibilities in rrd4j to define how the data compression should work in detail. openHAB comes at the moment with a fixed setting which looks like this (see the [rrd4j tutorial for details](http://code.google.com/p/rrd4j/wiki/Tutorial):

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

I future versions it is planned to offer an "expert mode", where these values are configurable.

The rrd4j Persistence Service currently does not allow to be queried, because of the data compression. You could not provide precise answers for all questions. 

# Installation

For installation of this persistence package please follow the same steps as if you would [install a binding](Bindings).

Additionally, place a persistence file called rrd4j.persist in the `${openhab_home}/configuration/persistence` folder.

# Configuration

There is nothing to configure in the `openhab.cfg` file for this persistence service.

All item and event related configuration is done in the rrd4j.persist file. Aliases do not have any special meaning for the rrd4j Persistence Service.