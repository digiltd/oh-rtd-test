Documentation of the MQTT binding Bundle

## Introduction

The **MQTT binding bundle** is available as a separate (optional) download.
This binding allows openHAB to act as an MQTT client, so that openHAB items can send and receive [MQTT](http://mqtt.org/) messages to/from an MQTT broker. It does not provide MQTT broker functionality, for this you may want to have a look at [Mosquitto](http://mosquitto.org/). There are test servers available at m2m.eclipse.org and test.mosquitto.org. 
To install, place this bundle in the folder ${openhab_home}/addons and add binding information to your configuration. 
See the following sections on how to do this.


OpenHAB provides MQTT support on different levels. The table below gives a quick overview:

<table>
  <tr><td><b>Level</b></td><td><b>Description</b></td><td><b>Usage</b></td><td><b>Bundle</b></td></tr>
  <tr><td>Transport</td><td>Shared transport functions for setting up MQTT broker connections.</td><td>Ideal if you want to roll your own binding using MQTT as the transport.</td><td>o.o.io.transport.mqtt</td></tr>
  <tr><td>Item binding</td><td>Allows MQTT publish/subscribe configuration on item level</td><td>Ideal for highly customized in and outbound message scenarios.</td><td>o.o.binding.mqtt</td></tr>
  <tr><td>Event bus binding</td><td>Publish/receive all states/commmands directly on the openHAB eventbus.</td><td>Perfect for integrating multiple openHAB instances or broadcasting all events.</td><td>o.o.binding.mqtt</td></tr>
  <tr><td>Persistence</td><td>Uses persistent strategies to push messages on change or a regular interval.</td><td>Perfect for persisting time series to a public service like Xively. (See [[MQTT persistence|MQTT-Persistence]].)</td><td>o.o.persistence.mqtt</td></tr>
</table>

The [Mqttitude binding](https://github.com/openhab/openhab/wiki/Mqttitude-Binding) is also available which is an extension of this binding.
## Configuration

### Transport Configuration

In order to consume or publish messages to an MQTT broker, you need to define all the brokers which you want to connect to, in your openhab.cfg file.
The following properties can be configured to define a broker connection:

    mqtt:<broker>.url=<url>
    mqtt:<broker>.clientId=<clientId>
    mqtt:<broker>.user=<user>
    mqtt:<broker>.pwd=<password>
    mqtt:<broker>.qos=<qos>
    mqtt:<broker>.retain=<retain>
    mqtt:<broker>.async=<async>

The properties indicated by `<...>` need to be replaced with an actual value.  The table below lists the meaning of the different properties.

<table>
  <tr><td><b>Property</b></td><td><b>Description</b></td></tr>
  <tr><td>broker</td><td>Alias name for the MQTT broker.  This is the name you can use in the item binding configurations afterwards.</td></tr>
  <tr><td>url</td><td>URL to the MQTT broker, e.g. tcp://localhost:1883 or ssl://localhost:8883</td></tr>
  <tr><td>clientId</td><td>Optional. Client id (max 23 chars) to use when connecting to the broker. If not provided a default one is generated.</td></tr>
  <tr><td>user</td><td>Optional. User id to authenticate with the broker.</td></tr>
  <tr><td>pwd</td><td>Optional. Password to authenticate with the broker.</td></tr>
  <tr><td>qos</td><td>Optional. Set the quality of service level for sending messages to this broker. Possible values are 0 (Deliver at most once),1 (Deliver at least once) or 2 (Deliver exactly once). Defaults to 0.</td></tr>
  <tr><td>retain</td><td>Optional. True or false. Defines if the broker should retain the messages sent to it. Defaults to false.</td></tr>
  <tr><td>async</td><td>Optional. True or false. Defines if messages are published asynchronously or synchronously. Defaults to true.</td></tr>
</table>


### Example Configurations

Example configuration of a simple broker connection:

    mqtt:m2m-eclipse.url=tcp://m2m.eclipse.org:1883

Example configuration of a encrypted broker connection with authentication:

    mqtt:mosquitto.url=ssl://test.mosquitto.org:8883
    mqtt:mosquitto.user=administrator
    mqtt:mosquitto.pwd=mysecret
    mqtt:mosquitto.qos=1
    mqtt:mosquitto.retain=true
    mqtt:mosquitto.async=false

## Item Binding Configuration for Inbound Messages

Below you can see the structure of the inbound mqtt configuration string.  Inbound configurations allow you to receive MQTT messages  into an openHAB item.
Every item is allowed to have multiple inbound (or outbound) configurations.

    Item myItem {mqtt="<direction>[<broker>:<topic>:<type>:<transformer>], <direction>[<broker>:<topic>:<type>:<transformation>], ..."} 

Since 1.6 it is possible to add an optional 5th configuration like:

    Item myItem {mqtt="<direction>[<broker>:<topic>:<type>:<transformer>:<regex_filter>], <direction>[<broker>:<topic>:<type>:<transformation>], ..."} 

<table>
  <tr><td><b>Property</b></td><td><b>Description</b></td></tr>
  <tr><td>direction</td><td>This is always "&lt;" for inbound messages.</td></tr>
  <tr><td>broker</td><td>The broker alias as it is defined in the openHab configuration.</td></tr>
  <tr><td>topic</td><td>The MQTT Topic to subscribe to.</td></tr>
  <tr><td>type</td><td>Describes what the message content contains: a status update or command. Allowed values are 'state' or 'command'.</td></tr>
  <tr><td>transformation</td><td>Rule defining how to transform the received message content into something openHab recognizes. Transformations are defined in the format of TRANSFORMATION_NAME(transformation_function).  Allowed values are 'default' or any of the transformers provided in the org.openhab.core.transform bundle. Custom transformations can be contributed directly to the transform bundle by making the Transformation available through Declarative Services. Any other value than the above types will be interpreted as static text, in which case the actual content of the message is ignored.</td></tr>
  <tr><td> regex_filter(optional, since 1.6) </td><td>A string representing a regular expression. Only messages that match this expression will be further processed. All other messages will be dropped. Use Case: If multiple different data is sent over one topic (for example multiple sensors of one device), it is possible to distinguish the messages for different items. Example ".*" will match every message, ".*\"type\"=2\n.*" will match every message including type=2.</td></tr>
</table>

### Example Inbound Configurations

    Number temperature {mqtt="<[publicweatherservice:/london-city/temperature:state:default]"}
    Number waterConsumption {mqtt="<[mybroker:/myHome/watermeter:state:XSLT(parse_water_message.xslt)]"} 
    Switch doorbell {mqtt="<[mybroker:/myHome/doorbell:command:ON]"}
    Number mfase1 {mqtt="<[flukso:/sensor/9cf3d75543fa82a4662fe70df5bf4fde/gauge:state:.*,(.*),.*]"}

## Item Binding Configuration for Outbound Messages

Below you can see the structure of the outbound mqtt configuration string.  Outbound configurations allow you to send an MQTT message when the an openHAB item receives a command or state update.

    Item itemName {mqtt="<direction>[<broker>:<topic>:<type>:<trigger>:<transformation>]" }

<table>
  <tr><td><b>Property</b></td><td><b>Description</b></td></tr>
  <tr><td>direction</td><td>This is always "&gt;" for outbound messages.</td></tr>
  <tr><td>broker</td><td>The broker alias as it was defined in the openHAB configuration.</td></tr>
  <tr><td>topic</td><td>The MQTT Topic to publish messages to.</td></tr>
  <tr><td>type</td><td>'state' or 'command'. Indicates whether the receiving of a status update or command triggers the sending of an outbound message.</td></tr>
  <tr><td>trigger</td><td>Specifies a specific OpenHAB command or state (e.g. ON, OFF, a DecimalType, ..) which triggers the sending of an outbound message. Use `*` to indicate that any command or state should trigger the sending.</td></tr>
  <tr><td>transformation</td><td>Rule defining how to create the message content. Transformations are defined in the format of TRANSFORMATION_NAME(transformation_function).  Allowed values are 'default' or any of the transformers provided in the org.openhab.core.transform bundle. Custom transformations can be contributed directly to the transform bundle by making the Transformation available through Declarative Services. Any other value than the above types will be interpreted as static text, in which case this text is used as the message content.</td></tr>
</table>

When the message content for an outbound message is created, the following variables are always replaced with their respective value:
- ${itemName} : name of the item which triggered the sending
- ${state}    : current state of the item
- ${command}  : command which triggered the sending of the message

### Example Outbound Configurations

    Switch mySwitch {mqtt=">[mybroker:/myhouse/office/light:command:ON:1],>[mybroker:/myhouse/office/light:command:OFF:0]"}
    Switch mySwitch {mqtt=">[mybroker:/myhouse/office/light:command:ON:1],>[mybroker:/myhouse/office/light:command:*:Switch ${itemName} was turned ${command}]"}

## Event Bus Binding Configuration

In addition to configuring MQTT publish/subscribe options for specific openHAB items, you can also define a generic configuration in the openhab.cfg file which will act on **ALL** status updates or commands on the openHAB event bus.

The following properties can be used to configure MQTT for the openHAB event bus:

    mqtt-eventbus:broker=<broker>
    mqtt-eventbus:statePublishTopic=<statePublishTopic>
    mqtt-eventbus:commandPublishTopic=<commandPublishTopic>
    mqtt-eventbus:stateSubscribeTopic=<stateSubscribeTopic>
    mqtt-eventbus:commandSubscribeTopic=<commandSubscribeTopic>

The properties indicated by `<...>` need to be replaced with an actual value.  The table below lists the meaning of the different properties.

<table>
  <tr><td><b>Property</b></td><td><b>Description</b></td></tr>
  <tr><td>broker</td><td>Name of the broker as it is defined in the openhab.cfg. If this property is not available, no event bus MQTT binding will be created.</td></tr>
  <tr><td>statePublishTopic</td><td>When available, all status updates which occur on the openHAB event bus are published to the provided topic. The message content will be the status. The variable ${item} will be replaced during publishing with the item name for which the state was received.</td></tr>
  <tr><td>commandPublishTopic</td><td>When available, all commands which occur on the openHAB event bus are published to the provided topic. The message content will be the command. The variable ${item} will be replaced during publishing with the item name for which the command was received.</td></tr>
  <tr><td>stateSubscribeTopic</td><td>When available, all status updates received on this topic will be posted to the openHAB event bus. The message content is assumed to be a string representation of the status. The topic should include the variable ${item} to indicate which part of the topic contains the item name which can be used for posting the received value to the event bus.</td></tr>
  <tr><td>commandSubscribeTopic</td><td>When available, all commands received on this topic will be posted to the openHAB event bus. The message content is assumed to be a string representation of the command. The topic should include the variable ${item} to indicate which part of the topic contains the item name which can be used for posting the received value to the event bus.</td></tr>
</table>

### Example Configurations

Example configuration for a event bus binding, which sends all commands to an MQTT broker and receives status updates from that broker.
This scenario could be used for example to link 2 openHAB instances together where the master instance sends all commands to the slave instance and the slave instance sends all status updates back to the master. The example below shows an example configuration for the master node.

    mqtt-eventbus:broker=m2m-eclipse
    mqtt-eventbus:commandPublishTopic=/openHAB/out/${item}/command
    mqtt-eventbus:stateSubscribeTopic=/openHAB/in/${item}/state

## Using the org.openhab.io.transport.mqtt bundle

When the default MQTT binding configuration options are not sufficient for your needs, you can also use the MQTT transport bundle directly from within your own binding.

## MqttService

Using the MqttService, your binding can add custom message consumers and publishers to any of the defined MQTT brokers. You don't have to worry about (re)connection issues, all of this is done by the transport.mqtt bundle. The MqttService class is available  to your binding through Declarative Services. A good example on how to use the MqttService can be found in the org.openhab.persistence.mqtt bundle.

## Eclipse Paho

If the above service doesn't provide all the flexibility you need, you can also use the Eclipse Paho library directly in your binding.  To make the library available, it's sufficient to add a dependency to the org.openhab.io.transport.mqtt bundle and to add org.eclipse.paho.client.mqtttv3 to your list of imported packages. 