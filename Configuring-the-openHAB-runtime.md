This page describes the different places in which the openHAB runtime can be configured and customized.

**Note**: The configuration files are text files that can be edited with any text editor of your choice. Nevertheless, you may want to use the openHAB designer to edit them, and you will get informed about any syntax error. Note that the expected file encoding is UTF-8.

## General Configuration

The runtime comes with one core configuration file, the file [openhab_default.cfg](https://github.com/openhab/openhab/blob/master/distribution/openhabhome/configurations/openhab_default.cfg).
The purpose of this file is to define all basic settings, such as IP addresses, mail server, folder locations etc.

The file contains settings for different (possibly optional) bundles. These settings are automatically dispatched to the according bundle. For this, all settings come with a namespace (such as "mail:" or "knx:") to identify the associated bundle.

First thing after unzipping the runtime should be creating a copy of `openhab_default.cfg` to `openhab.cfg`. All personal settings should always only be done in this copy. This ensures that your settings are not lost, if you unzip a new version of the runtime to your openHAB home directory.

The `openhab_default.cfg` file comes with extensive comments which explain, what settings are available and what can be configured with them. If you have any doubts, please ask on the [discussion group](https://groups.google.com/forum/#!forum/openhab).

## Individual Configuration

For specific topics, there exist dedicated configurations files. These can be found in the folder `${openhab_home}/configurations`. For each topic, there should be another sub folder, such as `${openhab_home}/configurations/items`.




### Item Definitions
Item files are stored in `${openhab_home}/configurations/items`.

Although items can be dynamically added by item providers (as OSGi services), it is usually very practical to statically define most of the items that should be used in the UI or in automation rules. 

These static definition files follow a certain syntax. This syntax will be explained here. (For the technical interested: This syntax is in fact a [Xtext DSL grammar](https://github.com/openhab/openhab/blob/master/bundles/model/org.openhab.model.item/src/org/openhab/model/Items.xtext).)

Please visit the [Items](Explanation-of-Items) page on how to configure items.

### Sitemap Definitions

Sitemap files are stored in `${openhab_home}/configurations/sitemaps`. 

Sitemaps are a declarative UI definition. With a few lines it is possible to define the structure and the content of your UI screens. 

Please see page [Sitemaps](Explanation-of-Sitemaps) for a description on how to create sitemaps.

### Automation
Rule files are stored in `${openhab_home}/configurations/rules`.

Script files are stored in `${openhab_home}/configurations/scripts`.


Please visit the [automation](https://github.com/openhab/openhab/wiki/Automation) section on creating rules and scripts by using related events and actions. 

### Persistence
Script files are stored in `${openhab_home}/configurations/persistence`.


Please visit the [persistence](https://github.com/openhab/openhab/wiki/Persistence) section for further details on how to store item states over a time (a time series). 

### Transformation
Transformations files are stored in `${openhab_home}/configurations/transformation`.


Please visit the [transformation](https://github.com/openhab/openhab/wiki/Transformation) section for further details.



## Advanced Configuration
### general
You will find the openHAB configuration under /etc/openhab.
If you change configuration files it will not be overwritten by updates or upgrades.

#### /etc/default/openhab
    USER_AND_GROUP=openhab:openhab
    HTTP_PORT=8080
    HTTPS_PORT=8443
    TELNET_PORT=5555
    OPENHAB_JAVA=/usr/bin/java

### Logging
#### Configuration
The runtime uses /etc/openhab/logback.xml.
A template for debugging is provided through /etc/openhab/logback_debug.xml. You can change logback.xml
to your needs.
#### Log files
The runtime log: /var/log/openhab/openhab.log
Further log files are placed also into: /var/log/openhab/

### Jetty
/etc/openhab/jetty/etc/
### Runtime generated files
/var/lib/openhab
### login.conf
/etc/openhab/login.conf
### users.cfg
/etc/openhab/users.cfg
### quartz.properties
/etc/openhab/quartz.properties
