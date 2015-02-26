This wiki will contain configuration information for the Nest binding I'm developing.  

TBD

## openhab.cfg ##

Your `openhab.cfg` file should contain these keys.

### nest:refresh ###

How often, in milliseconds, to update states.  Don't do it too frequently or you will hit API limits.

```
nest:refresh=60000
```

### nest:client_id ###
### nest:client_secret ###
### nest:pincode ###

You will have to register as a [Nest Developer](https://nest.com/developer/) and [Register a new client](https://developer.nest.com/clients/new).  Make sure to grant all the permissions you intend to use.

Once you've created your [client](https://developer.nest.com/clients), paste the Authorization URL into a new tab in your browser.  This will have you login to your normal Nest account, and will then present the pincode.

Paste all three of these values into your openhab.cfg file like so (using your actual values):

```
nest:client_id=e5cc5558-ec55-4c55-8555-4b95555f4979
nest:client_secret=ZZo28toiuoiurok4WjUya1Bnc
nest:pincode=2JTXXXJL
```

Multiple instance support (allowing the binding to access multiple Nest accounts at once) conflicts with Prohibition 3 of the [Nest Developer Terms of Service](https://developer.nest.com/documentation/cloud/tos), and so is not implemented.

## your.items file: ##

The Nest binding will support binding strings in this format:

```
{ nest="<[thermostats(Name).humidity]" }
{ nest="<[thermostats(Name).locale]" }
{ nest="<[thermostats(Name).temperature_scale]" }
{ nest="<[thermostats(Name).is_using_emergency_heat]" }
{ nest="<[thermostats(Name).has_fan]" }
{ nest="<[thermostats(Name).software_version]" }
{ nest="<[thermostats(Name).has_leaf]" }
{ nest="<[thermostats(Name).device_id]" }
{ nest="<[thermostats(Name).name]" }
{ nest="<[thermostats(Name).can_heat]" }
{ nest="<[thermostats(Name).can_cool]" }
{ nest="<[thermostats(Name).hvac_mode]" }
{ nest="<[thermostats(Name).target_temperature_c]" }
{ nest="<[thermostats(Name).target_temperature_f]" }
{ nest="<[thermostats(Name).target_temperature_high_c]" }
{ nest="<[thermostats(Name).target_temperature_high_f]" }
{ nest="<[thermostats(Name).target_temperature_low_c]" }
{ nest="<[thermostats(Name).target_temperature_low_f]" }
{ nest="<[thermostats(Name).ambient_temperature_c]" }
{ nest="<[thermostats(Name).ambient_temperature_f]" }
{ nest="<[thermostats(Name).away_temperature_high_c]" }
{ nest="<[thermostats(Name).away_temperature_high_f]" }
{ nest="<[thermostats(Name).away_temperature_low_c]" }
{ nest="<[thermostats(Name).away_temperature_low_f]" }
{ nest="<[thermostats(Name).structure_id]" }
{ nest="<[thermostats(Name).fan_timer_active]" }
{ nest="<[thermostats(Name).name_long]" }
{ nest="<[thermostats(Name).is_online]" }
{ nest="<[thermostats(Name).last_connection]" }

{ nest="<[smoke_co_alarms(Name).name]" }
{ nest="<[smoke_co_alarms(Name).locale]" }
{ nest="<[smoke_co_alarms(Name).structure_id]" }
{ nest="<[smoke_co_alarms(Name).software_version]" }
{ nest="<[smoke_co_alarms(Name).device_id]" }
{ nest="<[smoke_co_alarms(Name).name_long]" }
{ nest="<[smoke_co_alarms(Name).is_online]" }
{ nest="<[smoke_co_alarms(Name).last_connection]" }
{ nest="<[smoke_co_alarms(Name).battery_health]" }
{ nest="<[smoke_co_alarms(Name).co_alarm_state]" }
{ nest="<[smoke_co_alarms(Name).smoke_alarm_state]" }
{ nest="<[smoke_co_alarms(Name).ui_color_state]" }
{ nest="<[smoke_co_alarms(Name).is_manual_test_active]" }
{ nest="<[smoke_co_alarms(Name).last_manual_test_time]" }

{ nest="<[structures(Name).name]" }
{ nest="<[structures(Name).country_code]" }
{ nest="<[structures(Name).postal_code]" }
{ nest="<[structures(Name).time_zone]" }
{ nest="<[structures(Name).away]" }
{ nest="<[structures(Name).structure_id]" }
{ nest="<[structures(Name).smoke_co_alarms(Name).SEE_ABOVE]" }
{ nest="<[structures(Name).thermostats(Name).SEE_ABOVE]" }
```

TBD