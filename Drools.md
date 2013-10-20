# How to use Drools in openHAB

# Introduction

Since openHAB 0.9.0, JBoss Drools support is available as a separate download. This can be used as a replacement for the integrated rule engine, if a more powerful rule engine is needed for the definition of automation rules.

To install this package, simply extract it to {{{${openhab.home}}}} and you are done.
If you want to switch off the integrated rule engine, you have to add the parameter {{{-DnoRules=true}}} to the {{{start.sh/bat}}} script.

Note that in contrast to the integrated rule engine, there is no IDE support in the openHAB Designer for Drools. You may want to download and install the [JBoss Tooling](http://docs.jboss.org/drools/release/5.2.0.Final/drools-expert-docs/html/ch08.html) for it.

Most of the rule code can be written in plain Java, but you should make yourself familiar with the specifics of the [Drools rule syntax](http://docs.jboss.org/drools/release/5.2.0.Final/drools-expert-docs/html/ch05.html).

# Details

## Drools Integration in openHAB

Rule files can be created in the folder {{{${openhab.home}/configurations/drools}}}. They should have the file extension drl for normal Java-based rule files. The runtime distribution already comes with an [example rule file](http://code.google.com/p/openhab/source/browse/distribution/openhabhome/configurations/drools/demo.drl).

## Type System

Most of the time you will be dealing with item states in your rules.
You will have to refer to the sources to see what type the states of your item are and how these can be transformed into Java primitive types.

You can find the item definitions [here](http://code.google.com/p/openhab/source/browse/bundles/core/org.openhab.core.library/src/main/java/org/openhab/core/#core%2Flibrary%2Fitems) and the type definitions [here](http://code.google.com/p/openhab/source/browse/bundles/core/org.openhab.core.library/src/main/java/org/openhab/core/library/types/).
To get a Java float of a temperature value defined as an {{{NumberItem}}}, you could use the following code:
{{{((DecimalType)$item.getState()).toBigDecimal().floatValue()}}}

## Working Memory Objects

The working memory of the Drools engine contains the following objects:

- The {{{Item}}} instances for all defined items of openHAB. These have the following attributes (their type is given in brackets):
- name (String)
- state (State)

- A {{{StateEvent}}} instance for every status update that was received on the event bus since the last rule evaluation. A {{{StateEvent}}} has the following attributes:
- itemName (String)
- item (Item)
- timestamp (Calendar)
- changed (boolean)
- oldState (State)
- newState (State)

- A {{{CommandEvent}}} instance for every command that was received on the event bus since the last rule evaluation. A {{{CommandEvent}}} has the following attributes:
- itemName (String)
- item (Item)
- timestamp (Calendar)
- command (Command)

{{{StateEvent}}} and {{{CommandEvent}}} objects are removed after a single rule evaluation again, so that rules are not triggered multiple times on such events. The {{{Item}}} objects clearly stay in the working memory, but are always directly updated when their status changes.

The rule evaluation is triggered continuously with a 200ms pause between two evaluations.

## Import Statements

To have all functions and types available, you should at least use the imports as they exist in the demo.drl file. Add additional import statements for any additional Java classes you might want to use (e.g. java.math.*).

## Defining the When clause (LHS)

The when clause (LHS) of a rule should contain conditions based on the objects in the working memory, i.e. items and events.

Here is an example of a when clause:

{{{ 
	$event : StateEvent(itemName=="Rain", changed==true)
        $window  : Item(name=="Window", state==OpenClosedType.OPEN)
}}}

## Defining the rule logic (RHS)

The rule logic can use the variables defined in the when clause and contain any kind of Java code. To work with item states, see the notes on the type system above - unfortunately, there is quite some ugly type casting involved in this.
Besides normal Java operations, there are some statically imported methods available to your rule code, called "actions" in openHAB - see the next section on what features are provided through these actions.

Here is an example of a rule logic for the LHS from above:

{{{ 
	boolean $isRaining = ((OnOffType)$event.getNewState()).equals(OnOffType.ON);
	if($isRaining) {
		say("It has started raining and your window is still open!");
	} else {
 		playSound("ICanSeeClearlyNow.mp3");
	}
}}}

## Actions available in the rule logic

In general, Drools can call any kind of static Java methods that are available on the classpath. openHAB comes with a [set of useful actions](http://code.google.com/p/openhab/wiki/Actions) for different use cases.