# Documentation of the SQL Persistence Service

# Introduction

This service allows you to persist state updates by using standard SQL queries. Currently the mySQL-Driver is being delivered as well.

# Features

This persistence service supports writing information to mysql relational database systems.

# Installation

For installation of this persistence package please follow the same steps as if you would [[Bindings|install a binding]].

Additionally, place a persistence file called sql.persist in the {{{${openhab.home}/configuration/persistence}}} folder.

# Configuration

This persistence service can be configured in the "SQL Persistence Service" section in openhab.cfg.

All item and event related configuration is done in the sql.persist file. Aliases do have special meaning for the sql Persistence Service because they carry out the sql commands to be executed e.g. like

{{{"insert into TEMPERATURE values('%2$tY-%2$tm-%2$td %2$tT, 999, %1$s)"}}}

To enhance the given command line with the current state or the current date the service incorporates the [String.format()](http://docs.oracle.com/javase/6/docs/api/java/util/Formatter.html) method. The first parameter is always the state of the particular item, the second parameter is the current date.