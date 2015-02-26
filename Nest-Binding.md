This wiki will contain configuration information for the Nest binding I'm developing.  

TBD

## openhab.cfg ##

Your `openhab.cfg` file should contain these keys.

```
nest:refresh=60000
nest:client_id=e5cc5558-ec55-4c55-8555-4b95555f4979
nest:client_secret=ZZo28toiuoiurok4WjUya1Bnc
nest:pincode=<supplied after first startup>
```

(Multiple instance support conflicts with Nest Developer agreement.)

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