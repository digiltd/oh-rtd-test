**Note**: This Script-Engine comes with no forward compatibility guarantee. It is currently untested against openHAB2 and therefore it can happen that scripts need to be rewritten for openHAB2 compatibility.

# Script-Engines

This addon allows the usage of different scripting languages as basis for rules. It was tested with the Jython-Scripting-Runtime and all examples rely on this scripting language. Feel free to contribute to this wiki, if you are using another language like JRuby.

## Installation
The package needs to be installed to addons like any other addon. But by default it does not come with any scripting language except the build-in Nashorn-Engine. But this JavaScript-Engine is not that comfortable to use, so it is recommended to use another scripting language like Jython.

### Jython-Installation
- Download Jython 2.7.0 from http://www.jython.org/downloads.html as an installer package.
- Install jython to /opt/jython
- customize start.sh to reference to the JYTHON-PATH:
    
```
#!/bin/sh

cd `dirname $0`

# set path to eclipse folder. If local folder, use '.'; otherwise, use /path/to/eclipse/
eclipsehome="server";

# set ports for HTTP(S) server
HTTP_PORT=8080
HTTPS_PORT=8443

JYTHON_HOME="/opt/jython";

# get path to equinox jar inside $eclipsehome folder
cp=$(echo lib/*.jar | tr ' ' ':'):$(find $eclipsehome -name "org.eclipse.equinox.launcher_*.jar" | sort | tail -1);
echo $cp
echo Launching the openHAB runtime...
java \
    -Dpython.home="$JYTHON_HOME" \
    -Dosgi.clean=true \
    -Declipse.ignoreApp=true \
    -Dosgi.noShutdown=true  \
    -Djetty.port=$HTTP_PORT  \
    -Djetty.port.ssl=$HTTPS_PORT \
    -Djetty.home=.  \
    -Dlogback.configurationFile=configurations/logback.xml \
    -Dfelix.fileinstall.dir=addons -Dfelix.fileinstall.filter=.*\\.jar \
    -Djava.library.path=lib \
    -Djava.security.auth.login.config=./etc/login.conf \
    -Dorg.quartz.properties=./etc/quartz.properties \
    -Dequinox.ds.block_timeout=240000 \
    -Dequinox.scr.waitTimeOnBlock=60000 \
    -Dfelix.fileinstall.active.level=4 \
    -Djava.awt.headless=true \
    -cp $cp org.eclipse.equinox.launcher.Main $* \
    -console
```

- symlink jython.jar into /opt/openhab/lib/ (mkdir /opt/openhab/lib; cd /opt/openhab/lib; ln -s /opt/jython/jython.jar .)  or add jython.jar to classpath in start-script

## Scripts
Each Script needs to be located in configurations/scripts with a correct script ending (".py", ".jy" for jython interpreter). Each Script can contain multiple rules.

### Rule-Class
Each rule is basically a class in the given scripting language. It needs to implement two functions:
* getEventTrigger
    * returns an array of EventTrigger
* execute
    * gets as first argument the reason why it was called

Supported triggers: 
* ChangedEventTrigger (for updates and changed states)
* CommandEventTrigger
* ShutdownTrigger
* StartUpTrigger
* TimerTrigger

```
class TestRule(Rule):
	def getEventTrigger(self):
		return [
			StartupTrigger(),
			ChangedEventTrigger("Heating_FF_Child", None, None),
			TimerTrigger("0/50 * * * * ?")
		] 
		
	def execute(self, event):
		oh.logDebug(self.getName(), "event received " + str(event))
		oh.logInfo(self.getName(), str(ItemRegistry.getItem("Heating_GF_Corridor")))
		action = oh.getActions() 
		oh.logInfo(self.getName(), "available actions: " + str(action.keySet()))
		ping = oh.getAction("Ping")
		oh.logInfo(self.getName(), "internet reachable: " + ("yes" if ping.checkVitality("google.com", 80, 100) else "no"))

def getRules():
    return RuleSet([
        TestRule()
    ])
```

#### Output
```
21:47:06.975 [DEBUG] [.openhab.model.jsr232.TestRule:60   ] - event received Event [triggerType=STARTUP, item=null, oldState=null, newState=null, command=null]
21:47:06.977 [INFO ] [.openhab.model.jsr232.TestRule:75   ] - Heating_GF_Corridor (Type=SwitchItem, State=OFF)
21:47:06.979 [INFO ] [.openhab.model.jsr232.TestRule:75   ] - available actions: [Exec, Transformation, Ping, HTTP, Audio]
21:47:07.003 [INFO ] [.openhab.model.jsr232.TestRule:75   ] - internet reachable: yes
```

## Interaction with Openhab
In general all interaction is done through the oh object. It has support for the following:

### Logging
* oh.logDebug(logger_name, format, arg0,....)
* oh.logInfo(logger_name, format, arg0,....)
* oh.logWarn(logger_name, format, arg0,....)
* oh.logError(logger_name, format, arg0,....) 

### BusEvent
* oh.sendCommand([Item] item, [String] commandString)
* oh.sendCommand([Item] item, [Numer] number)
* oh.sendCommand([String] itemName, [String] commandString)
* oh.sendCommand([Item] item, [Command] command)
* oh.postUpdate([Item] item, [String] stateAsString)
* oh.postUpdate([String] itemName, [String] stateAsString)
* oh.postUpdate([String] itemName, [State] state)
* oh.storeStates([Item[]] items)
* oh.restoreStates([Map<Item, State>] statesMap)

### ItemRegistry
* ItemRegistry.getItem(itemName) 
* ItemRegistry.getItemByPattern(String name)
* ItemRegistry.getItems()
* ItemRegistry.getItems(String pattern)
* ItemRegistry.isValidItemName(String itemName)

### Accessing actions
To access the old known methods (all actions) the openhab interface supports getActions() and getAction(name_of_action_provider).

```
oh.getActions()
ping = oh.getAction("Ping")
ping.checkVitality("google.com", 80, 100)
```

## Global variables/classes
* RuleSet
* Rule
* State
* Command
* ChangedEventTrigger
* CommandEventTrigger
* Event
* EventTrigger
* ShutdownTrigger
* StartupTrigger
* TimerTrigger
* TriggerType
* ItemRegistry <-- this allows direct access to items ( ItemRegistry.getItem(itemName) )
* oh


# Examples

Open-Window on temperature (uses string casts, item info can also directly be obtained by the member method (intValue() etc.)) :

    import datetime

    class WintergartenRule(Rule):
        def __init__(self):
            item = ItemRegistry.getItem("Wintergarten_Automatik")
            if item.state == None or str(item.state) == "Uninitialized":
                oh.postUpdate("Wintergarten_Automatik", "ON")
                oh.postUpdate("Wintergarten_Automatik_from", "8")
                oh.postUpdate("Wintergarten_Automatik_to", "19")
                oh.postUpdate("Wintergarten_Automatik_openTemp", "23")
                oh.postUpdate("Wintergarten_Automatik_closeTemp", "20")

            self.logger = oh.getLogger("WintergartenRule")

        def getAutomatikInfo(self):
            return {
                "enabled": ItemRegistry.getItem("Wintergarten_Automatik").state == OnOffType.ON,
                "from": int(str(ItemRegistry.getItem("Wintergarten_Automatik_from").state)),
                "to": int(str(ItemRegistry.getItem("Wintergarten_Automatik_to").state)),
                "openTemp": float(str(ItemRegistry.getItem("Wintergarten_Automatik_openTemp").state)),
                "closeTemp": float(str(ItemRegistry.getItem("Wintergarten_Automatik_closeTemp").state))
            }

        def getEventTrigger(self):
            return [
                ChangedEventTrigger("Wintergarten_Temperatur")
            ]

        def execute(self, event):
            self.logger.info("event {}", event)
            if event.newState:
                self.logger.info("Wintergarten_Temperatur changed to: {}", event.newState)

                temp = float(str(event.newState))
                self.checkConditions(temp)

        def checkConditions(self, temp):
            config = self.getAutomatikInfo()

            t = datetime.datetime.now().time()

            if config["enabled"] and t < datetime.time(config["to"]) and t >= datetime.time(config["from"]):

                alleFenster = ItemRegistry.getItem("Wintergarten_Jalousie_Fenster_Alle")
                state = int(str(alleFenster.state))

                regen = str(ItemRegistry.getItem("Regensensor").state) == "1"
                print "Regen=",regen

                if not regen:
                    if temp >= config["openTemp"] and state == 100:
                        oh.sendCommand("Wintergarten_Jalousie_Fenster_Alle", "UP")
                    elif temp <= config["closeTemp"] and state <= 50:
                        oh.sendCommand("Wintergarten_Jalousie_Fenster_Alle", "DOWN")


    def getRules():
        return RuleSet([
            WintergartenRule()
        ])
