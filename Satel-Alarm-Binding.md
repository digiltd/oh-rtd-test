## Introduction

This is documentation of OpenHAB binding for Satel Integra Alarm System which allows you to connect to your alarm system using TCP/IP protocol with ETHM-1 module installed or RS-232 protocol with INT-RS module installed.

For installation of the binding, please see Wiki page [Bindings](Bindings).

**NOTE:** INT-RS module is not supported yet.

## Binding Configuration

There are some configuration settings that you can set in the openhab.cfg file. Include the following in your openhab.cfg.

```
############################### Satel Binding ###################################
#
# Satel ETHM-1 module hostname or IP.
# Leave this commented out for INT-RS module.  
#satel:host=

# ETHM-1 port to use (optional, defaults to 7094), if host setting is not empty.
# INT-RS port to use, if host setting is empty.
#satel:port=7094

# timeout value for both ETHM-1 and INT-RS (optional, in milliseconds, defaults to 5000)
#satel:timeout=5000

# refresh value (optional, in milliseconds, defaults to 10000)
#satel:refresh=10000

# user code for Integra control (optional, if empty binding works in read-only mode)
#satel:user_code=

# encryption key (optional, if empty communication is not encrypted)
#satel:encryption_key=
```

The only required parameter is _satel:host_ for the ETHM-1 module and _satel:port_ for the INT-RS module. The rest default to the values described in the configuration comments. In order to use ETHM-1 module it is required to enable "integration" protocol for the module in Integra configuration (DLOADX).

<table>
<tr><th>Option</th><th>Description</th></tr>
<tr><td>satel:host</td><td>Valid only for ETHM-1 module. Specifies either IP or host name of the module</td></tr>
<tr><td>satel:port</td><td>For INT-RS it specifies the serial port on the host system to which the module is connected, i.e. "COM1" on Windows, "/dev/ttyS0" or "/dev/ttyUSB0" on Linux<br>For ETHM-1 it specifies the TCP port on which the module listens for new connections. Defaults to 7094.</td></tr>
<tr><td>satel:timeout</td><td>Timeout value for connect, read and write operations specified in milliseconds. Defaults to 5 seconds</td></tr>
<tr><td>satel:refresh</td><td>Refresh interval in milliseconds. Defaults to 10 seconds.</td></tr>
<tr><td>satel:user_code</td><td>Security code (password) of the user used for control operations, like arming, changing state of outputs, etc. It is recommended to use dedicated user for OpenHAB integration.</td></tr>
<tr><td>satel:encryption_key</td><td>Key use for encrypting communication between OpenHAB and ETHM-1 module. To disable encrytpion leave it empty. See also the note below.</td></tr></table>

**NOTE:** Encryption for ETHM-1 module is not implemented yet and therefore encryption key in the configuration must be empty.

## Item Binding

In order to bind to the Integra Alarm system you need to add settings for items defined in your item file. Here is item configuration string syntax:

```
satel="<object_type>[:<state_type>][:<object_number>][:<option>=<value>,...]"
```

Name of object type, state type and option is case insensitive. For "output" objects state type cannot be specified and must be ommited. `object_number` must be integer number in range 1-256. Options are comma-separated pairs of name and value separated by `=` character.

Supported item types: `Contact`, `Switch`, `Number`. Number items can be used only if `object_number` is not given and the number specifies cardinality of objects that are in given state. For example if object is "zone" and state is "violated", item will tell you number of zones violated. See examples section for detailed configuration syntax.

**Valid `object_type` values:**
<table><tr><th>Type</th><th>Description</th></tr>
<tr><td>zone</td><td>defines a zone: PIR, contact, etc.</td></tr>
<tr><td>partition</td><td>defines a partition</td></tr>
<tr><td>output</td><td>defines an output</td></tr>
<tr><td>doors</td><td>defines doors</td></tr></table>


**Valid `state_type` values for "zone" objects:**
<table><tr><th>Type</th><th>Notes</th></tr>
<tr><td>violation</td><td></td></tr>
<tr><td>tamper</td><td></td></tr>
<tr><td>alarm</td><td></td></tr>
<tr><td>tamper_alarm</td><td></td></tr>
<tr><td>alarm_memory</td><td></td></tr>
<tr><td>tamper_alarm_memory</td><td></td></tr>
<tr><td>bypass</td><td></td></tr>
<tr><td>no_violation_trouble</td><td></td></tr>
<tr><td>long_violation_trouble</td><td></td></tr>
<tr><td>isolate</td><td></td></tr>
<tr><td>masked</td><td></td></tr>
<tr><td>masked_memory</td><td></td></tr></table>


**Valid `state_type` values for "partition" objects:**
<table><tr><th>Type</th><th>Notes</th></tr>
<tr><td>armed</td><td>ON command arms specified partition in mode 0, OFF disarms. Forces arming if "force_arm" option is specified.</td></tr>
<tr><td>really_armed</td><td>ON command arms specified partition in mode 0, OFF disarms. Forces arming if "force_arm" option is specified.</td></tr>
<tr><td>armed_mode_1</td><td>ON command arms specified partition in mode 1, OFF disarms. Forces arming if "force_arm" option is specified.</td></tr>
<tr><td>armed_mode_2</td><td>ON command arms specified partition in mode 2, OFF disarms. Forces arming if "force_arm" option is specified.</td></tr>
<tr><td>armed_mode_3</td><td>ON command arms specified partition in mode 3, OFF disarms. Forces arming if "force_arm" option is specified.</td></tr>
<tr><td>first_code_entered</td><td></td></tr>
<tr><td>entry_time</td><td></td></tr>
<tr><td>exit_time_gt_10</td><td></td></tr>
<tr><td>exit_time_lt_10</td><td></td></tr>
<tr><td>temporary_blocked</td><td></td></tr>
<tr><td>blocked_for_guard</td><td></td></tr>
<tr><td>alarm</td><td>OFF command clears alarms for specified partition</td></tr>
<tr><td>alarm_memory</td><td>OFF command clears alarms for specified partition</td></tr>
<tr><td>fire_alarm</td><td>OFF command clears alarms for specified partition</td></tr>
<tr><td>fire_alarm_memory</td><td>OFF command clears alarms for specified partition</td></tr>
<tr><td>violated_zones</td><td></td></tr>
<tr><td>verified_alarms</td><td>OFF command clears alarms for specified partition</td></tr>
<tr><td>warning_alarms</td><td>OFF command clears alarms for specified partition</td></tr></table>


**Valid `state_type` values for "doors" objects:**
<table><tr><th>Type</th><th>Notes</th></tr>
<tr><td>opened</td><td></td></tr>
<tr><td>opened_long</td><td></td></tr></table>


## Examples

Partition item with ability to arm and disarm:
```
Switch PartitionArmed "Partition armed" { satel="partition:armed:1" }
```

Sitemap definitions for above example. The second one allows only to arm the partition:
```
Switch item=PartitionArmed
Switch item=PartitionArmed mappings=[ON="Arm"]
```

Partition item with ability to force arming:
```
Switch Partition1 "Partition armed" { satel="partition:armed:1:force_arm" }
```

Simple contact item:
```
Contact	Zone1 "Zone #1 violated" { satel="zone:violation:1" }
```

Number of items violated:
```
Number	ZonesViolated "Zones violated [%d]" { satel="zone:violation" }
```

Simple output item with ability to change its state:
```
Switch	Output1 "Output #1" { satel="output:1" }
```

Number of partitions with "alarm" state:
```
Number PartitionsInAlarm "Partitions alarmed [%d]" { satel="partition:alarm" }
```


## Security considerations

**User for OH integration**

To control Integra partitions and outputs you need to provide security code of user in behalf all those operations will be executed. It is highly recommended to use a separate user for OpenHAB integration with only required access rights set in Integra configuration, like access to certain partitions, etc. This allows you to distinguish actions made by OH and a user using Integra panel, also it will block unwanted operations in case someone breaks into your local network.

**Disarming and clearing alarms**

Although this binding allows you to configure disarming a partition and clearing alarms for a partion, this should be used only in cases when security is not the priority. Don't forget both these operations can be executed in OpenHAB without specifying user code, which is required to disarm or clear alarms using Integra panel. Also don't forget to secure your OpenHAB installation by using HTTPS protocol and setting a user with password. Here is a page about security in OpenHAB: [Security](Security)

## TO DO

* support for RTC and basic status
* troubles support
* support for INT-RS module
* encryption for ETHM-1
* RTC synchronization