[Slack](www.slack.com) is a wonderful team collaboration tool. One of the best things about Slack is the integrations with other systems that are possible. Below are instructions for adding a plugin to Slack which enables you to send commands and updates to openHAB items, as well as querying current state.

Follow the instructions [here](https://github.com/slackhq/python-rtmbot) to install the Slack RTM bot. You will need to create a new Real-Time Messaging integration in your Slack account and copy the generated API token into the python-rtmbot config file.

Then copy the [slackhab.py](https://gist.github.com/sumnerboy12/bc40668005b3e4358d2a) script to the `python-rtmbot/plugins` folder and update the values at the top of the script;

```
openhab_url      = 'http://127.0.0.1:8080'
slackhab_user_id = "UXXXXXXXX"
```

Where `slackhab_user_id` is the internal user ID for the slackhab bot. The easiest way to get this user_id is to add some debugging to the slackhab plugin. Although there may be a way to find it via the Slack UI.

Once everything is configured and you start the python-rtmbot script you should see the `slackhab` bot turn green in your Slack UI. You can then either send direct messages (DMs) to the bot or mention the bot in any Slack channel, e.g. `@slackhab send CoffeeMachine ON`.

The following commands are supported;

```
* send <item> <command>
* update <item> <state>
* items [<filter>]
```

Examples;

`@slackhab items temp`
```
GroupItem      SensorTemperature       Undefined
NumberItem     Sensor_Temperature1     18.699999999999999289457264239899814128875732421875
NumberItem     Sensor_Temperature2     19.60000000000000142108547152020037174224853515625
NumberItem     Sensor_HallwayTemp      20.1
NumberItem     Sensor_EnsuiteTemp      20.2
NumberItem     Weather_TempOut         11
NumberItem     Sensor_GarageTemp       14.12
NumberItem     Heating_DaikinTemp      23
```

`@slackhab send CoffeeMachine ON`
```
Sent ON command to CoffeeMachine
```

`@slackhab send NonExistingItem TEST`
```
404: Not Found
```

