Documentation of the InfluxDB Persistence Service

## Introduction

This service allows you to persist and query states using the time series database 
[InfluxDB](http://influxdb.org).

## Features

The InfluxDB persistence service persists item values using the the InfluxDB time series database.
The persisted values can be queried from within openHAB. There also are nice tools on the web for 
visualizing InfluxDB time series.

## Database Structure
The states of an item are persisted in time series with names equal to the name of the item. 
All values are stored in a field called "value" using integers or doubles, OnOffType and 
OpenClosedType values are stored using 0 or 1. 
The times for the entries are calculated by InfluxDB.

An example entry for an item with the name "AmbientLight" would look like this:

|time |   sequence_number| value|
|-----|-----------------|-------|
|1402243200072 |  79370001 |   6|


## Installation and Configuration
### Database Setup
First of all you have to setup and run a InfluxDB server. This is very easy and you will find good
documentation on it on the [InfluxDB web site](http://influxdb.com/docs/v0.8/introduction/installation.html).

Then database and the user must be created. This can be done using the influxdb 
admin web interface. If you want to use the defaults then create a database called
```openhab``` and a user with write access on the database called ```openhab```. 
Choose a password and remember it.

### openhab.cfg
After this the persistence service needs some configuration in the "InfluxDB Persistence Service" 
section in openhab.cfg.

The defaults for the database name, the database user and the database url are "openhab",
"openhab" and "http://127.0.0.1:8086" respectively. If you took this defaults for the database setup 
you only have to add the password value to the influxdb:password=<password> variable.

| variable            | description                   | default |
|---------------------|-------------------------------|---------|
|influxdb:url         | the database URL              | http://127.0.0.1:8086 |
|influxdb:user        | the name of the database user | openhab |
|influxdb:db          | the name of the database      | openhab |
| influxdb:password   | the password of the database user | no default |

### Installation
For installation of this persistence package please follow the same steps as if you would [install a binding](Bindings).

Now place a persistence configuration file called influxdb.persist in the 
_${openhab.home}/configuration/persistence_ folder. This has the standard format as described in [[Persistence]].

