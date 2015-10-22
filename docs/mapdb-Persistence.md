Documentation of the mapdb Persistence Service

## Introduction

The mapdb Persistence Service is based on simple key-value store http://www.mapdb.org/

## Since 

1.7.0

## Features

The mapdb Persistence Service is a simple persistence provider that only saves the last value. Intention is to use this for "reloadOnStartup" items because all other persistence options have their drawbacks if values are only needed for reload

They:
a) grow in time
b) require complex installs (mysql, influxdb, ...)
c) rrd4j can't store all item types (only numeric types)

Querying the mapdb persistence service for historic values other than the last value make no sense since the persistence service can only store one value per item.

## Installation

For installation of this persistence package please follow the same steps as if you would [install a binding](Bindings).

## Configuration

Place a persistence file called mapdb.persist in the `${openhab_home}/configuration/persistence` folder.

See [Persistence](Persistence) for details on configuring this file.

This persistence service can be configured in the "MapDB Persistence Service" section in `openhab.cfg`.
You can set the commit interval.

## Troubleshooting

Restore of items after startup is taking some time. Rules are already started in parallel. Especially in rules that are started via "System started" trigger, it may happen that the restore is not completed resulting in defined items. In these cases the use of restored items has to be delayed by a couple of seconds. This delay has to be determined experimentally.