**NOTE*: This page is still under construction!!!*

## Introduction

[[Actions]] are simple Java methods (or rather a set of methods) that are made available to scripts and rules. So whenever you want to implement a complex functionality that is reusable and useful in many situations or if you need to access third-party Java libraries, implementing an action is the way to go.

For information about how to setup a development environment, please see the [according wiki page](IDE-Setup).

## General Information about the Architecture

The openHAB runtime distribution comes only with a limited set of actions. All other actions are considered to be "add-ons", which the user can optionally install by putting it in the "addons" folder of the runtime. As a consequence of this, an action should usually be a single file and as a file corresponds to an OSGi bundle, an action should be a single bundle.

As openHAB makes use of the Xbase framework to allow interpreting scripts at runtime, the actions need to be integrated with Xbase. openHAB provides all means for that so that the only thing you have to do is to register an OSGi service which implements the [ActionService](https://github.com/openhab/openhab/blob/master/bundles/core/org.openhab.core.scriptengine/src/main/java/org/openhab/core/scriptengine/action/ActionService.java) interface. This service then only has to provide the action class name and instance. All public static methods of this action class are then automatically made available to the script engine.

## Creating an Action Skeleton

As explained above, an action should correspond to one bundle. The naming convention for the action bundle is "`org.openhab.action.<name>`". To create a working action skeleton one should use the maven archetype which facilitates the creation process. The following steps have to be performed:

1. run a full build (meaning run `mvn clean install` in the topmost directory)
1. `cd ./bundles/archetype/./org.openhab.archetype.action`
1. `mvn clean install`
1. `cd ../../action`
1. `mvn archetype:generate -B -DarchetypeGroupId=org.openhab.archetype -DarchetypeArtifactId=org.openhab.archetype.action -DarchetypeVersion=1.6.0-SNAPSHOT -Dauthor=<author> -Dversion=<target-version-of-binding> -DartifactId=org.openhab.action.<action-name-in-small-caps> -Dpackage=org.openhab.action.<action-name-in-small-caps> -Daction-name=<action-name-in-camel-case>`
1. import newly created project by issuing 'Import->Existing Java project'
1. active the new plugin in !RunConfiguration 'Run Configurations->openHAB Runtime->Plugins->activate your plugin->Auto-start true'
1. active the new plugin in !RunConfiguration 'Run Configurations->openHAB Designer (xxx)->Plugins->activate your plugin->Auto-start true'

Another possibility is to copy an existing action and do a search&replace for the name.
Don't forget to add it as dependency in `./distribution/pom.xml` and as module in `./bundles/action/pom.xml`

## Action Configuration

Many actions might require configuration data. The generated action service class therefore already implements the !ManagedService interface and registers as such an OSGi service. This has the effect that you can add configuration data like `<action-name-in-small-caps>:<property>=<value>` in your openhab.cfg, which will then be automatically passed into the `updated()` method of your action service. In there you can store the configuration data and make it available to your action class.
 

## Building and Packaging

After IDE setup and creating/testing your action, you may want others to use it. For this, you can use the Eclipse export function as follows:

1. Right-click on your binding project
1. Select Export
1. Choose Plug-in Development->Deployable plug-ins and features
1. Fill "Directory" with the Path where you want your jar-file to appear
1. Check "Use class files compiled in the workspace" on the "Options" tab
1. Click Finish and check your directory