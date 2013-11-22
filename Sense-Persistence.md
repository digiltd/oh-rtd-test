Documentation of the Sen.Se Persistence Service

## Introduction

This service allows you to feed item data to Sen.Se web site (see http://open.sen.se for more details)

## Features

This persistence service supports only writing information to the Sen.Se web site.
You need a Sen.Se API key and data feed to put data to. Each item being persisted represents a separate feed.

## Installation

For installation of this persistence package please follow the same steps as if you would [install a binding](Bindings).

Additionally, place a persistence file called sense.persist in the `${openhab.home}/configuration/persistence` folder.

## Configuration

This persistence service can be configured in the "Sen.Se Persistence Service" section in `openhab.cfg`. You need to specify your Sen.Se API key as

    sense:apikey=your_api_key

All item and event related configuration is done in the sense.persist file. Aliases correspond to sen.se feed  IDs for the sen.se persistence service.