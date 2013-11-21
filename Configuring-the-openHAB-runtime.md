This page describes the different places in which the openHAB runtime can be configured and customized.

## Main Configuration

The runtime comes with one core configuration file, the file [openhab_default.cfg](https://github.com/openhab/openhab/blob/master/distribution/openhabhome/configurations/openhab_default.cfg).
The purpose of this file is to define all basic settings, such as IP addresses, mail server, folder locations etc.

The file contains settings for different (possibly optional) bundles. These settings are automatically dispatched to the according bundle. For this, all settings come with a namespace (such as "mail:" or "knx:") to identify the associated bundle.

First thing after unzipping the runtime should be creating a copy of `openhab_default.cfg` to `openhab.cfg`. All personal settings should always only be done in this copy. This ensures that your settings are not lost, if you unzip a new version of the runtime to your openHAB home directory.

The `openhab_default.cfg` file comes with extensive comments which explain, what settings are available and what can be configured with them. If you have any doubts, please ask on the discussion group.

## Specific Configuration

For specific topics, there exist dedicated configurations files. These can be found in the folder `${openhab_home}/configurations`. For each topic, there should be another sub folder, such as `${openhab_home}/configurations/items`.

### Item Definitions

Although items can be dynamically added by item providers (as OSGi services), it is usually very practical to statically define most of the items that should be used in the UI or in automation rules. 

These static definition files follow a certain syntax. This syntax will be explained here. (For the technical interested: This syntax is in fact a [Xtext DSL grammar](http://code.google.com/p/openhab/source/browse/bundles/model/org.openhab.model.item/src/org/openhab/model/Items.xtext).)

Please see page [Items](Explanation-of-Items) on how to configure items.

### Sitemap Definitions

Sitemaps are a declarative UI definition. With a few lines it is possible to define the structure and the content of your UI screens. Sitemap files are stored in ${openhab_home}/configurations/sitemaps.

Please see page [Sitemaps](Explanation-of-Sitemaps) for description on how to create sitemaps.

### Automation Rules

Rule files are stored in `${openhab_home}/configurations/rules`.
The syntax of these files is described [here](Rules) in detail.