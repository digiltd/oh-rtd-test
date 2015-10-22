If you are completely new to openHAB and you prefer listening over reading, you can [start with our webinar](http://www.element14.com/community/videos/12763/l/home-automation-at-your-fingertips-with-eclipse-smarthome-and-openhab), which was organized by element14.

If you speak german, you can find an openHAB manual in german language at (http://openhabdoc.readthedocs.org/de/latest/).

# Overview

The openHAB project is split into two parts

1. openhab-runtime: This is the package, which you will actually run on your server and which does the "real" work.
1. openhab-designer: This is a configuration tool for the openhab-runtime. It comes with user-friendly editors to configure your runtime, to define your UIs and to implement your rules.

# openHAB Runtime

The openHAB runtime is a set of OSGi bundles deployed on an OSGi framework (Equinox). It is therefore a pure Java solution and needs a JVM to run. Being based on OSGi, it provides a highly modular architecture, which even allows adding and removing functionality during runtime without stopping the service. Here is an overview of the main bundles and how they depend on each other:

[[images/architecture.png]]

## Communication

openHAB has two different internal communication channels:

1. an asynchronous event bus
1. a stateful repository, which can be queried

### The Event Bus

The event bus is THE base service of openHAB. All bundles that do not require stateful behaviour should use it to inform other bundles about events and to be updated by other bundles on external events.

There are mainly two types of events: 

1. Commands which trigger an action or a state change of some item/device.
1. Status updates which inform about a status change of some item/device (often as a response to a command)

All protocol bindings (which provide the link to the real hardware devices) should communicate via the Event Bus. This makes sure that there is a very low coupling between the bundles, which facilitates the dynamic nature of openHAB.

As a technical foundation, the OSGi EventAdmin service is used by openHAB. This is a light-weight  pub-sub implementation, which perfectly meets the requirements.

It is important to note that openHAB is not meant to reside on (or near) actual hardware devices which would then have to remotely communicate with many other distributed openHAB instances. Instead, openHAB serves as an integration hub between such devices and as a mediator between different protocols that are spoken between these devices.
In a typical installation there will therefore be usually just one instance of openHAB running on some central server. Nonetheless, as the OSGi EventAdmin service can also be used as a remote service, it is possible to connect several distributed openHAB instances via the Event Bus.

### Item Repository

Not all functionality can be covered purely by stateless services. Therefore openHAB also offers the Item Repository, which is connected to the Event Bus and keeps track of the current status of all items.
The Item Repository can be used whenever needed to access the current state of items. E.g. a user interface needs to display the current state of items in the moment of the user access. Also the automation logic execution engine needs to always be informed about the current states.
The Item Repository avoids requiring each bundle to cache states themselves for their internal use. It also makes sure that the state is in sync for all those bundles and it provides the possibility to persist states to the file system or a database, so that they are even kept throughout a system restart.

The following diagram shows how these communication channels are used:

[[images/events.png]]

### Sitemap

openHAB comes with a generic textual configuration for its user interfaces: The Sitemap. The Sitemap is a tree structure of widgets, which define the different pages of a UI and their content. Widgets can be associated to items, for which they should show the status and/or control elements.

The definition of the Sitemap is quite abstract by design; it is supposed to be a suitable UI model for different kinds of user interfaces, so that the user does not have to configure each of them in case he sets up multiple UIs. If a UI has further requirements on top of the sitemap, it is still possible to introduce additional configuration options which are then specific for the UI in question.

### Item UI Providers

Item UI providers offer a dynamic way to configure the UI, so that not everything must be stored statically in the Sitemap. An item UI provider can for example define, what widget should be used for an item, if none is specified and can dynamically define icons and labels (which might depend on the current state of the item) for the widgets.

An important use case for this feature is the dynamic display of item groups - all that there is stored in the Sitemap is the information that a certain group should be displayed; the page is then dynamically assembled at runtime with whatever items are available at that time.

# openHAB Designer

The openHAB Designer is an Eclipse RCP application for configuring the openHAB runtime.
It comes with editors for configuration files like the sitemap. Its advantage over simple text editors is the full IDE support, like syntax checking, auto completion, highlighting and content assist. It is also meant to implement and deploy rules for automatic actions.