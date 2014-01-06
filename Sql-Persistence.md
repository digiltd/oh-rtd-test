Documentation of the MYSQL Persistence Service

## Introduction

This service allows you to persist state updates using the mySQL database. Note that other SQL databases need a separate binding due to incompatibilities between different SQL databases.

## Features

This persistence service supports writing information to mysql relational database systems.

## Installation

For installation of this persistence package please follow the same steps as if you would [install a binding](Bindings).

Additionally, place a persistence file called sql.persist in the _${openhab.home}/configuration/persistence_ folder. This has the standard format as described in [[Persistence]].

## Configuration

This persistence service can be configured in the "SQL Persistence Service" section in openhab.cfg.
```
############################ mySQL Persistence Service ##################################

# the database url like 'jdbc:mysql://<host>:<port>/<user>'
mysql:url=jdbc:mysql://127.0.0.1/openhab

# the database user
mysql:user=<your user here>

# the database password
mysql:password=<your password here>

# optional tweaking of mysql datatypes
# example as described in https://github.com/openhab/openhab/issues/710
# mysql:sqltype.string=VARCHAR(20000)
```
The database location, user and password need to be modified as per your database.

## Database overview
The service will create a mapping table to link each item to a table, and a separate table is generated for each item. The item data tables include the time and data - the data type is dependent on the item type and allows the item state to be recovered back into openHAB in the same way it was stored.