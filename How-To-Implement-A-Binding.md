**NOTE*: This page is still under construction!!!*

# Introduction

Bindings are the most interesting bit for people to get into coding for openHAB and therefore, many questions arise around this topic regularly.

This page tries to give you a starting point, if you intent to implement (and hopefully contribute) your own binding.

For information about how to setup a development environment, please see the [according wiki page](IDE-Setup).

# General Information about the Architecture

The openHAB runtime distribution comes without any binding. All bindings are considered to be "add-ons", which the user can optionally install by putting it in the "addons" folder of the runtime. As a consequence of this, a binding should usually be a single file and as a file corresponds to an OSGi bundle, a binding should be a single bundle.

The purpose of a binding is to translate between events on the openHAB event bus and an external system. This translation should happen "stateless", i.e. the binding must not access the !ItemRegistry in order to get hold of the current state of an item. Likewise, it should not itself keep states of items in memory.

# Creating a Bundle Skeleton

As explained above, a binding should correspond to one bundle. The naming convention for the binding bundle is "`org.openhab.binding.<name>`". To create a working binding skeleton one should use the Maven archetype which facilitates the creation process. The following steps have to be performed:

1. run a full build (meaning run `mvn clean install` in the topmost directory)
1. `cd ./bundles/archetype/./org.openhab.archetype.binding`
1. `mvn clean install`
1. `cd ../../binding`
1. use maven archetype

        mvn archetype:generate -B -DarchetypeGroupId=org.openhab.archetype 
        -DarchetypeArtifactId=org.openhab.archetype.binding
        -DarchetypeVersion=1.4.0 -Dauthor=<author> -Dversion=<target-version-of-binding>
        -DartifactId=org.openhab.binding.<binding-name-in-small-caps>
        -Dpackage=org.openhab.binding.<binding-name-in-small-caps> 
        -Dbinding-name=<binding-name-in-camel-case>
1. import newly created project by selecting 'Import->Existing Java project'
1. active the new plugin in !RunConfiguration 'Run Configurations->openHAB Runtime->Plugins->activate your plugin->Auto-start true'

Another possibility is to copy an existing binding and do a search&replace for the name.


# Global Binding Configuration

A binding may require general configuration settings, such as a host and port of the external system to connect to. This can be done through the OSGi Configuration Admin service, i.e. by registering an OSGi service, which implements the interface `ManagedService`.

openHAB then allows to add configuration information in openhab.cfg, which is automatically dispatched to your !ManagedService. All you have to make sure is to specify the property "`service.pid`" in your component declaration as "`org.openhab.<name>`", where name is the prefix to be used in openhab.cfg.

Please refer to the KNX binding for an example on how to [implement a ManagedService](https://github.com/openhab/openhab/blob/master/bundles/binding/org.openhab.binding.knx/src/main/java/org/openhab/binding/knx/internal/connection/KNXConnection.java) and how to [register it through OSGi Declarative Services](https://github.com/openhab/openhab/blob/master/bundles/binding/org.openhab.binding.knx/OSGI-INF/knxconnection.xml).

more t.b.d.

# Item-specific Binding Configuration

t.b.d.

# Connecting to the Event Bus

There are to directions for the communication of a binding - either sending out commands and status updates from the openHAB even bus to some external system or to receive information from an external system and post this on the openHAB event bus for certain items.

A binding can implement the one or the other direction or both. We usually talk about "Out-", "In-" or "InOut-Bindings" respectively.

## openHAB Event Bus -> External System

A good example for such an "Out-Binding" is the Exec-binding. When receiving a command for an item, a configured command is executed on the command line of the host system.

Such bindings can be implemented pretty easily: All you have to do is to extend the class `AbstractBinding` and override the methods 

    	public void internalReceiveCommand(String itemName, Command command)
and / or
    	protected void internalReceiveUpdate(String itemName, State newState)
As the method signatures suggest, you are passed the name of the item and the command or state that was sent on the openHAB event bus. In these methods, you can then perform whatever code is appropriate for your use case. See the [ExecBinding class](https://github.com/openhab/openhab/blob/master/bundles/binding/org.openhab.binding.exec/src/main/java/org/openhab/binding/exec/internal/ExecBinding.java) as an example.

All there is left to do is to register your class with the OSGi event admin service. To do so, your component has to provide the `EventHandler` service and define the property `event.topics`. In your `OSGI-INF/binding.xml` file, this should look like this:
       <service>
          <provide interface="org.osgi.service.event.EventHandler"/>
       </service>
       <property name="event.topics" type="String" value="openhab/*"/>
If you are only interested in commands, you can also choose `openhab/command/*` as a topic.
See the [component descriptor of the ExecBinding](https://github.com/openhab/openhab/blob/master/bundles/binding/org.openhab.binding.exec/OSGI-INF/binding.xml) as an example.

## External System -> openHAB Event Bus

If you receive information from an external system somewhere in your code and you want to post commands or status updates on the openHAB event bus, you can as well simply extend `AbstractBinding` for your implementation. Your binding class should then reference the `EventPublisher` service in the `OSGI-INF/binding.xml` file. This should look like this:
       <reference bind="setEventPublisher" cardinality="1..1" interface="org.openhab.core.events.EventPublisher" name="EventPublisher" policy="dynamic" unbind="unsetEventPublisher"/>

In your code, you can then simply refer to the instance variable `eventPublisher` in order to very easily send events:
    	eventPublisher.postUpdate(itemName, state);
    	eventPublisher.postCommand(itemName, command);
    	eventPublisher.sendCommand(itemName, command);

Please note the difference between `sendCommand` and `postCommand`: Sending means a synchronous call, i.e. the method does not return until all event bus subscribers have processed the event. So if you just want to do a fire&forget, use the asynchronous postCommand method instead.

### Handling background activities

In order to receive information from an external system, you usually either need some background thread continuously listening to the external system (e.g. on a socket or serial interface) or you need to regularly actively poll the external system. In both cases, choosing to extend the class `AbstractActiveBinding` will help you.

`AbstractActiveBinding` extends `AbstractBinding` so everything said above will still be the same. You will simply get an additional feature: The active binding provides a thread creation and handling and all you have to do is to specify a pause interval between calls of the `execute()` method. 
See the [NtpBinding class](https://github.com/openhab/openhab/blob/master/bundles/binding/org.openhab.binding.ntp/src/main/java/org/openhab/binding/ntp/internal/NtpBinding.java) for a simple example of such a binding.

### Lifecycle

A few notes on the lifecyle: Bindings are dynamic OSGi services and thus behave according to the OSGi specs. The dynamics make it easy to change openHAB during runtime (add new bindings later on, reconfigure items, etc.), but it also brings some complexity in the coding. In consequence the methods of the interfaces that the bindings implement (such as addBindingProvider(), allBindingsChanged(), updated(), processBindingConfiguration() etc.) can be called at any time and in any order. So you need to make sure that you write your code in a way that you can always react in a decent way when a method is called and reach a valid state of your binding.

This specifically means:
- activate() is called as soon as all required dependencies (e.g. the first !BindingProvider) are resolved and set in your service instance
- optional dependencies might be set any time (e.g. a second !BindingProvider is set through addBindingProvider())
- updated() is called any time, but after activate(). So you should even consider the case that you receive invalid configuration at a later time and thus stop your services again (-> setProperlyConfigured(false)).
- processBindingConfigurations can be called anytime, but always after activate()

# Building and Packaging

After IDE setup and creating/testing your binding, you may want others to use it. For this, you can use the Eclipse export function as follows:

1. Right-click on your binding project
1. Select Export
1. Choose Plug-in Development->Deployable plug-ins and features
1. Fill "Directory" with the Path where you want your jar-file to appear
1. Check "Use class files compiled in the workspace" on the "Options" tab
1. Click Finish and check yor Directory