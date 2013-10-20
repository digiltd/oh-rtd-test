# Documentation of the Logging Persistence Service

# Introduction

The Logging Persistence Service allows to write item states to log files.

# Features

This persistence service makes use of [Logback](http://logback.qos.ch/) as an underlying logging framework. This means that the syntax of the produced logfiles can be defined very flexibly.

# Installation

For installation of this persistence package please follow the same steps as if you would [[Bindings|install a binding]].

Additionally, place a persistence file called logging.persist in the {{{${openhab_home}/configuration/persistence}}} folder.

# Configuration

This persistence service can be configured in the "Logging Persistence Service" section in {{{openhab.cfg}}}.
In this place you define the syntax of your log files according to the [Logback specification](http://logback.qos.ch/manual/layouts.html#ClassicPatternLayout).

All item and event related configuration is done in the logging.persist file. The provided aliases define the name of the log file (without the .log suffix). All logfiles are written to {{{${openhab_home}/logs}}}.