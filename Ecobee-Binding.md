Documentation of the Ecobee binding Bundle.

## Introduction

Ecobee Inc. of Toronto, Canada, sells a range of Wi-Fi enabled thermostats, principally in the Americas.  The EMS, EMS Si, Smart, Smart Si and ecobee3 models are supported by this binding, which communicates with the Ecobee API over a secure, RESTful API to Ecobee's servers. Monitoring ambient temperature and humidity, changing HVAC mode, changing heat or cool setpoints, changing the backlight intensity, and even sending textual messages to one or a group of thermostats, can be accomplished through this binding.

In order to use this binding, you must have already registered your thermostat(s) with Ecobee, registered a new app as a [developer](https://www.ecobee.com/developers/), and then login to your [web portal](https://www.ecobee.com/).

For installation of the binding, please see Wiki page [Bindings](Bindings).

The snapshot version of the binding can be downloaded, together with the rest of openhab, from the [cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/) page.

## Binding Configuration

In order to use the Ecobee API, you must specify the `appkey` and `scope` that will be used.  You must generate your own `appkey` on the Ecobee developer dashboard.  Typically, `scope` will be set to `smartWrite`, but if you have an EMS thermostat, set `scope` to `ems`.  These values must be set in the openhab.cfg file (in the folder '${openhab_home}/configurations'). The refresh interval can also be specified, and defaults to 60000ms (one minute).

    ############################## Ecobee binding ########################################
    #
    # Data refresh interval in ms (optional, defaults to 60000)
    # ecobee:refresh=60000

    # the temperature scale to use when sending or receiving temperatures
    # defaults to Fahrenheit (F)
    # ecobee:tempscale=C

    # the private API key issued be Ecobee to use the API (replace with your own)
    ecobee:appkey=9T4huoUXlT5b5qNpEJvMssqTMgaNCFoV

    # the application scope used when authorizing the binding
    # choices are smartWrite,smartRead, or ems, or multiple (comma-separated, no spaces)
    ecobee:scope=smartWrite

You can set up multiple, distinct API connections by repeating the `appkey` and `scope` settings with a prepended "user ID" that indicates a separate ecobee.com account will be used to complete authorization.

    ecobee:condo.appkey=T5vMsUXlpEsqT4huoJb5qN9TMgaNCFoV
    ecobee:condo.scope=smartRead

You would then include `condo.` in item references (see below) for those thermostats available from the "condo" account.

## Item configuration

In order to bind an item to a thermostat's properties and functions, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the Ecobee binding configuration string is explained below.

Ecobee bindings start with a `<`, `>` or `=`, to indicate if the item receives values from the API (in binding), sends values to the API (out binding), or both (bidirectional binding), respectively.

The first character is then followed by a section between square brackets (\[and \] characters):

```
[<thermostat>#<property>]
```

Where `<thermostat>` is a decimal thermostat identifier for in (`<`), out (`>`) and bidirectional (`=`) bindings.

For out (`>`) bindings only, `<thermostat>` can instead be selection criteria that specify which thermostats to change. You can use either a comma-separated list of thermostat identifiers (no spaces), or, for non-EMS thermostats only, a wildcard (the `*` character).

In the case of out bindings for EMS or Utility accounts, the `<thermostat>` criteria can be a path to a management set (for example, `/Toronto/Campus/BuildingA`).  Please note that management set path elements that contain the `.` or `#` characters cannot be specified.

The `<thermostat>` specification can be optionally prepended with a specific "user ID" as specified in openhab.cfg, as in `condo.123456789` when you have specified `ecobee:condo.scope` and `ecobee:condo.appkey` properties in openhab.cfg.

`<property>` is one of a long list of thermostat properties than you can read and optionally change. See the list below, and peruse this binding's JavaDoc for all specifics as to their meanings.

<table>
<thead><tr><th>Property</th><th>In</th><th>Out</th><th>Type</th></tr></thead>
<tbody>
<tr><td>name</td><td>X</td><td>X</td><td>StringType</td></tr>
<tr><td>runtime.actualTemperature</td><td>X</td><td></td><td>DecimalType</td></tr>
<tr><td>runtime.actualHumidity</td><td>X</td><td></td><td>DecimalType</td></tr>
<tr><td>settings.hvacMode</td><td>X</td><td>X</td><td>StringType</td></tr>
</tbody>
</table>

See the Example Binding Strings section below for more examples.

## Authentication

After you have installed the binding JAR in your `addons` directory, configured your `openhab.cfg` file, added items to your .items file and started OpenHAB (if not previously started), when the binding performs its first poll, it will discover that is has not yet authenticated with the Ecobee servers, and will retrieve a four-character PIN from Ecobee server.  This PIN will appear prominently in your `openhab.log` file:

	#########################################################################################
	# Ecobee-Integration: U S E R   I N T E R A C T I O N   R E Q U I R E D !!
	# 1. Login to www.ecobee.com using your 'DEFAULT_USER' account
	# 2. Enter the PIN 'gxvg' in My Apps within the next 9 minutes.
	# NOTE: Any API attempts will fail in the meantime.
	#########################################################################################

When it does, enter it into your Apps settings in your account at ecobee.com.  This will authenticate your instance of the binding to work with your Ecobee account.  On the next poll of the API, it will retrieve authentication tokens and continue.

## Example Binding Strings

```
{ ecobee="=[123456789#name]" }
```

Return or set the name of the thermostat whose ID is 123456789 using the default
Ecobee app instance (configured in openhab.cfg).

```
{ ecobee="<[condo.987654321#runtime.actualTemperature]" }
```

Return the current temperature read by the thermostat using the condo account
at ecobee.com.

```
{ ecobee="=[543212345#settings.fanMinOnTime]" }
```

Return or set the minimum number of minutes per hour the fan will run on thermostat ID
543212345.

```
{ ecobee=">[*#settings.hvacMode]" }
```

Change the HVAC mode to one of "auto", "auxHeatOnly", "cool", "heat", or
"off" on all thermostats registered in the default app instance.

```
{ ecobee=">[lakehouse.*#settings.backlightSleepIntensity]" }
```

Changes the backlight sleep intensity on all thermostats at the lake house
(meaning, all thermostats registered to the lakehouse Ecobee account).

## Known Issues

## Examples

Here are some examples of valid binding configuration strings, as you would define in the your .items file:

	/* Ecobee binding items */

	String identifier       "identifier [%s]"                                      { ecobee="<[123456789012#identifier]" }
	String name             "name [%s]"                                            { ecobee="<[123456789012#name]" }
	String thermostatRev    "thermostatRev [%s]"                                   { ecobee="<[123456789012#thermostatRev]" }
	Switch isRegistered     "isRegistered [%s]"                                    { ecobee="<[123456789012#isRegistered]" }
	String modelNumber      "modelNumber [%s]"                                     { ecobee="<[123456789012#modelNumber]" }
	DateTime lastModified   "lastModified [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]"   { ecobee="<[123456789012#lastModified]" }
	DateTime thermostatTime "thermostatTime [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" { ecobee="<[123456789012#thermostatTime]" }
	DateTime utcTime        "utcTime [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]"        { ecobee="<[123456789012#utcTime]" }
	String equipmentStatus  "equipmentStatus [%s]"                                 { ecobee="<[123456789012#equipmentStatus]" }
	String version_thermostatFirmwareVersion "thermostatFirmwareVersion [%s]"      { ecobee="<[123456789012#version.thermostatFirmwareVersion]" }
	String program_currentClimateRef "currentClimateRef [%s]"                      { ecobee="<[123456789012#program.currentClimateRef]" }

	Group All
	Group gSettings (All)

	String settings_hvacMode "hvacMode [%s]"                                       (gSettings) { ecobee="=[123456789012#settings.hvacMode]" }
	String settings_lastServiceDate "lastServiceDate [%s]"                         (gSettings) { ecobee="<[123456789012#settings.lastServiceDate]" }
	Switch settings_serviceRemindMe "serviceRemindMe [%s]"                         (gSettings) { ecobee="<[123456789012#settings.serviceRemindMe]" }
	Number settings_monthsBetweenService "monthsBetweenService [%d]"               (gSettings) { ecobee="<[123456789012#settings.monthsBetweenService]" }
	String settings_remindMeDate "remindMeDate [%s]"                               (gSettings) { ecobee="<[123456789012#settings.remindMeDate]" }
	String settings_vent "vent [%s]"                                               (gSettings) { ecobee="<[123456789012#settings.vent]" }
	Number settings_ventilatorMinOnTime "ventilatorMinOnTime [%d]"                 (gSettings) { ecobee="<[123456789012#settings.ventilatorMinOnTime]" }
	Switch settings_serviceRemindTechnician "serviceRemindTechnician [%s]"         (gSettings) { ecobee="<[123456789012#settings.serviceRemindTechnician]" }
	String settings_eiLocation "eiLocation [%s]"                                   (gSettings) { ecobee="<[123456789012#settings.eiLocation]" }
	Number settings_coldTempAlert "coldTempAlert [%.1f °F]"                        (gSettings) { ecobee="<[123456789012#settings.coldTempAlert]" }
	Switch settings_coldTempAlertEnabled "coldTempAlertEnabled [%s]"               (gSettings) { ecobee="<[123456789012#settings.coldTempAlertEnabled]" }
	Number settings_hotTempAlert "hotTempAlert [%.1f °F]"                          (gSettings) { ecobee="<[123456789012#settings.hotTempAlert]" }
	Switch settings_hotTempAlertEnabled "hotTempAlertEnabled [%s]"                 (gSettings) { ecobee="<[123456789012#settings.hotTempAlertEnabled]" }
	Number settings_coolStages "coolStages [%d]"                                   (gSettings) { ecobee="<[123456789012#settings.coolStages]" }
	Number settings_heatStages "heatStages [%d]"                                   (gSettings) { ecobee="<[123456789012#settings.heatStages]" }
	Number settings_maxSetBack "maxSetBack [%.1f °F]"                              (gSettings) { ecobee="=[123456789012#settings.maxSetBack]" }
	Number settings_maxSetForward "maxSetForward [%.1f °F]"                        (gSettings) { ecobee="<[123456789012#settings.maxSetForward]" }
	Number settings_quickSaveSetBack "quickSaveSetBack [%.1f °F]"                  (gSettings) { ecobee="<[123456789012#settings.quickSaveSetBack]" }
	Number settings_quickSaveSetForward "quickSaveSetForward [%.1f °F]"            (gSettings) { ecobee="<[123456789012#settings.quickSaveSetForward]" }
	Switch settings_hasHeatPump "hasHeatPump [%s]"                                 (gSettings) { ecobee="<[123456789012#settings.hasHeatPump]" }
	Switch settings_hasForcedAir "hasForcedAir [%s]"                               (gSettings) { ecobee="<[123456789012#settings.hasForcedAir]" }
	Switch settings_hasBoiler "hasBoiler [%s]"                                     (gSettings) { ecobee="<[123456789012#settings.hasBoiler]" }
	Switch settings_hasHumidifier "hasHumidifier [%s]"                             (gSettings) { ecobee="<[123456789012#settings.hasHumidifier]" }
	Switch settings_hasErv "hasErv [%s]"                                           (gSettings) { ecobee="<[123456789012#settings.hasErv]" }
	Switch settings_hasHrv "hasHrv [%s]"                                           (gSettings) { ecobee="<[123456789012#settings.hasHrv]" }
	Switch settings_condensationAvoid "condensationAvoid [%s]"                     (gSettings) { ecobee="<[123456789012#settings.condensationAvoid]" }
	Switch settings_useCelsius "useCelsius [%s]"                                   (gSettings) { ecobee="<[123456789012#settings.useCelsius]" }
	Switch settings_useTimeFormat12 "useTimeFormat12 [%s]"                         (gSettings) { ecobee="<[123456789012#settings.useTimeFormat12]" }
	String settings_locale "locale [%s]"                                           (gSettings) { ecobee="<[123456789012#settings.locale]" }
	String settings_humidity "humidity [%s]"                                       (gSettings) { ecobee="<[123456789012#settings.humidity]" }
	String settings_humidifierMode "humidifierMode [%s]"                           (gSettings) { ecobee="<[123456789012#settings.humidifierMode]" }
	Number settings_backlightOnIntensity "backlightOnIntensity [%d]"               (gSettings) { ecobee="<[123456789012#settings.backlightOnIntensity]" }
	Number settings_backlightSleepIntensity "backlightSleepIntensity [%d]"         (gSettings) { ecobee="<[123456789012#settings.backlightSleepIntensity]" }
	Number settings_backlightOffTime "backlightOffTime [%d]"                       (gSettings) { ecobee="<[123456789012#settings.backlightOffTime]" }
	Number settings_soundTickVolume "soundTickVolume [%d]"                         (gSettings) { ecobee="<[123456789012#settings.soundTickVolume]" }
	Number settings_soundAlertVolume "soundAlertVolume [%d]"                       (gSettings) { ecobee="<[123456789012#settings.soundAlertVolume]" }
	Number settings_compressorProtectionMinTime "compressorProtectionMinTime [%d]" (gSettings) { ecobee="<[123456789012#settings.compressorProtectionMinTime]" }
	Number settings_compressorProtectionMinTemp "compressorProtectionMinTemp [%.1f °F]" (gSettings) { ecobee="<[123456789012#settings.compressorProtectionMinTemp]" }
	Number settings_stage1HeatingDifferentialTemp "stage1HeatingDifferentialTemp [%.1f °F]" (gSettings) { ecobee="<[123456789012#settings.stage1HeatingDifferentialTemp]" }
	Number settings_stage1CoolingDifferentialTemp "stage1CoolingDifferentialTemp [%.1f °F]" (gSettings) { ecobee="<[123456789012#settings.stage1CoolingDifferentialTemp]" }
	Number settings_stage1HeatingDissipationTime "stage1HeatingDissipationTime [%d]" (gSettings) { ecobee="<[123456789012#settings.stage1HeatingDissipationTime]" }
	Number settings_stage1CoolingDissipationTime "stage1CoolingDissipationTime [%d]" (gSettings) { ecobee="<[123456789012#settings.stage1CoolingDissipationTime]" }
	Switch settings_heatPumpReversalOnCool "heatPumpReversalOnCool [%s]" (gSettings) { ecobee="<[123456789012#settings.heatPumpReversalOnCool]" }
	Switch settings_fanControlRequired "fanControlRequired [%s]"                   (gSettings) { ecobee="<[123456789012#settings.fanControlRequired]" }
	Number settings_fanMinOnTime "fanMinOnTime [%d]"                               (gSettings) { ecobee="<[123456789012#settings.fanMinOnTime]" }
	Number settings_heatCoolMinDelta "heatCoolMinDelta [%.1f °F]"                  (gSettings) { ecobee="<[123456789012#settings.heatCoolMinDelta]" }
	Number settings_tempCorrection "tempCorrection [%.1f °F]"                      (gSettings) { ecobee="<[123456789012#settings.tempCorrection]" }
	String settings_holdAction "holdAction [%s]"                                   (gSettings) { ecobee="<[123456789012#settings.holdAction]" }
	Switch settings_heatPumpGroundWater "heatPumpGroundWater [%s]"                 (gSettings) { ecobee="<[123456789012#settings.heatPumpGroundWater]" }
	Switch settings_hasElectric "hasElectric [%s]"                                 (gSettings) { ecobee="<[123456789012#settings.hasElectric]" }
	Switch settings_hasDehumidifier "hasDehumidifier [%s]"                         (gSettings) { ecobee="<[123456789012#settings.hasDehumidifier]" }
	String settings_dehumidifierMode "dehumidifierMode [%s]"                       (gSettings) { ecobee="<[123456789012#settings.dehumidifierMode]" }
	Number settings_dehumidifierLevel "dehumidifierLevel [%d]"                     (gSettings) { ecobee="<[123456789012#settings.dehumidifierLevel]" }
	Switch settings_dehumidifyWithAC "dehumidifyWithAC [%s]"                       (gSettings) { ecobee="<[123456789012#settings.dehumidifyWithAC]" }
	Number settings_dehumidifyOvercoolOffset "dehumidifyOvercoolOffset [%d]"       (gSettings) { ecobee="<[123456789012#settings.dehumidifyOvercoolOffset]" }
	Switch settings_autoHeatCoolFeatureEnabled "autoHeatCoolFeatureEnabled [%s]"   (gSettings) { ecobee="<[123456789012#settings.autoHeatCoolFeatureEnabled]" }
	Switch settings_wifiOfflineAlert "wifiOfflineAlert [%s]"                       (gSettings) { ecobee="<[123456789012#settings.wifiOfflineAlert]" }
	Number settings_heatMinTemp "heatMinTemp [%.1f °F]"                            (gSettings) { ecobee="<[123456789012#settings.heatMinTemp]" }
	Number settings_heatMaxTemp "heatMaxTemp [%.1f °F]"                            (gSettings) { ecobee="<[123456789012#settings.heatMaxTemp]" }
	Number settings_coolMinTemp "coolMinTemp [%.1f °F]"                            (gSettings) { ecobee="<[123456789012#settings.coolMinTemp]" }
	Number settings_coolMaxTemp "coolMaxTemp [%.1f °F]"                            (gSettings) { ecobee="<[123456789012#settings.coolMaxTemp]" }
	Number settings_heatRangeHigh "heatRangeHigh [%.1f °F]"                        (gSettings) { ecobee="<[123456789012#settings.heatRangeHigh]" }
	Number settings_heatRangeLow "heatRangeLow [%.1f °F]"                          (gSettings) { ecobee="<[123456789012#settings.heatRangeLow]" }
	Number settings_coolRangeHigh "coolRangeHigh [%.1f °F]"                        (gSettings) { ecobee="<[123456789012#settings.coolRangeHigh]" }
	Number settings_coolRangeLow "coolRangeLow [%.1f °F]"                          (gSettings) { ecobee="<[123456789012#settings.coolRangeLow]" }
	String settings_userAccessCode "userAccessCode [%s]"                           (gSettings) { ecobee="<[123456789012#settings.userAccessCode]" }
	Number settings_userAccessSetting "userAccessSetting [%d]"                     (gSettings) { ecobee="<[123456789012#settings.userAccessSetting]" }
	Number settings_auxRuntimeAlert "auxRuntimeAlert [%.1f °F]"                    (gSettings) { ecobee="<[123456789012#settings.auxRuntimeAlert]" }
	Number settings_auxOutdoorTempAlert "auxOutdoorTempAlert [%.1f °F]"            (gSettings) { ecobee="<[123456789012#settings.auxOutdoorTempAlert]" }
	Number settings_auxMaxOutdoorTemp "auxMaxOutdoorTemp [%.1f °F]"                (gSettings) { ecobee="<[123456789012#settings.auxMaxOutdoorTemp]" }
	Switch settings_auxRuntimeAlertNotify "auxRuntimeAlertNotify [%s]"             (gSettings) { ecobee="<[123456789012#settings.auxRuntimeAlertNotify]" }
	Switch settings_auxOutdoorTempAlertNotify "auxOutdoorTempAlertNotify [%s]"     (gSettings) { ecobee="<[123456789012#settings.auxOutdoorTempAlertNotify]" }
	Switch settings_auxRuntimeAlertNotifyTechnician "auxRuntimeAlertNotifyTechnician [%s]" (gSettings) { ecobee="<[123456789012#settings.auxRuntimeAlertNotifyTechnician]" }
	Switch settings_auxOutdoorTempAlertNotifyTechnician "auxOutdoorTempAlertNotifyTechnician [%s]" (gSettings) { ecobee="<[123456789012#settings.auxOutdoorTempAlertNotifyTechnician]" }
	Switch settings_disablePreHeating "disablePreHeating [%s]"                     (gSettings) { ecobee="<[123456789012#settings.disablePreHeating]" }
	Switch settings_disablePreCooling "disablePreCooling [%s]"                     (gSettings) { ecobee="<[123456789012#settings.disablePreCooling]" }
	Switch settings_installerCodeRequired "installerCodeRequired [%s]"             (gSettings) { ecobee="<[123456789012#settings.installerCodeRequired]" }
	String settings_drAccept "drAccept [%s]"                                       (gSettings) { ecobee="<[123456789012#settings.drAccept]" }
	Switch settings_isRentalProperty "isRentalProperty [%s]"                       (gSettings) { ecobee="<[123456789012#settings.isRentalProperty]" }
	Switch settings_useZoneController "useZoneController [%s]"                     (gSettings) { ecobee="<[123456789012#settings.useZoneController]" }
	Number settings_randomStartDelayCool "randomStartDelayCool [%d]"               (gSettings) { ecobee="<[123456789012#settings.randomStartDelayCool]" }
	Number settings_randomStartDelayHeat "randomStartDelayHeat [%d]"               (gSettings) { ecobee="<[123456789012#settings.randomStartDelayHeat]" }
	Number settings_humidityHighAlert "humidityHighAlert [%d]"                     (gSettings) { ecobee="<[123456789012#settings.humidityHighAlert]" }
	Number settings_humidityLowAlert "humidityLowAlert [%d]"                       (gSettings) { ecobee="<[123456789012#settings.humidityLowAlert]" }
	Switch settings_disableHeatPumpAlerts "disableHeatPumpAlerts [%s]"             (gSettings) { ecobee="<[123456789012#settings.disableHeatPumpAlerts]" }
	Switch settings_disableAlertsOnIdt "disableAlertsOnIdt [%s]"                   (gSettings) { ecobee="<[123456789012#settings.disableAlertsOnIdt]" }
	Switch settings_humidityAlertNotify "humidityAlertNotify [%s]"                 (gSettings) { ecobee="<[123456789012#settings.humidityAlertNotify]" }
	Switch settings_humidityAlertNotifyTechnician "humidityAlertNotifyTechnician [%s]" (gSettings) { ecobee="<[123456789012#settings.humidityAlertNotifyTechnician]" }
	Switch settings_tempAlertNotify "tempAlertNotify [%s]"                         (gSettings) { ecobee="<[123456789012#settings.tempAlertNotify]" }
	Switch settings_tempAlertNotifyTechnician "tempAlertNotifyTechnician [%s]"     (gSettings) { ecobee="<[123456789012#settings.tempAlertNotifyTechnician]" }
	Number settings_monthlyElectricityBillLimit "monthlyElectricityBillLimit [%d]" (gSettings) { ecobee="<[123456789012#settings.monthlyElectricityBillLimit]" }
	Switch settings_enableElectricityBillAlert "enableElectricityBillAlert [%s]"   (gSettings) { ecobee="<[123456789012#settings.enableElectricityBillAlert]" }
	Switch settings_enableProjectedElectricityBillAlert "enableProjectedElectricityBillAlert [%s]" (gSettings) { ecobee="<[123456789012#settings.enableProjectedElectricityBillAlert]" }
	Number settings_electricityBillingDayOfMonth "electricityBillingDayOfMonth [%d]" (gSettings) { ecobee="<[123456789012#settings.electricityBillingDayOfMonth]" }
	Number settings_electricityBillCycleMonths "electricityBillCycleMonths [%d]"   (gSettings) { ecobee="<[123456789012#settings.electricityBillCycleMonths]" }
	Number settings_electricityBillStartMonth "electricityBillStartMonth [%d]"     (gSettings) { ecobee="<[123456789012#settings.electricityBillStartMonth]" }
	Number settings_ventilatorMinOnTimeHome "ventilatorMinOnTimeHome [%d]"         (gSettings) { ecobee="<[123456789012#settings.ventilatorMinOnTimeHome]" }
	Number settings_ventilatorMinOnTimeAway "ventilatorMinOnTimeAway [%d]"         (gSettings) { ecobee="<[123456789012#settings.ventilatorMinOnTimeAway]" }
	Switch settings_backlightOffDuringSleep "backlightOffDuringSleep [%s]"         (gSettings) { ecobee="<[123456789012#settings.backlightOffDuringSleep]" }
	Switch settings_autoAway "autoAway [%s]"                                       (gSettings) { ecobee="<[123456789012#settings.autoAway]" }
	Switch settings_smartCirculation "smartCirculation [%s]"                       (gSettings) { ecobee="<[123456789012#settings.smartCirculation]" }
	Switch settings_followMeComfort "followMeComfort [%s]"                         (gSettings) { ecobee="<[123456789012#settings.followMeComfort]" }
	String settings_ventilatorType "ventilatorType [%s]"                           (gSettings) { ecobee="<[123456789012#settings.ventilatorType]" }
	Switch settings_isVentilatorTimerOn "isVentilatorTimerOn [%s]"                 (gSettings) { ecobee="<[123456789012#settings.isVentilatorTimerOn]" }
	DateTime settings_ventilatorOffDateTime "ventilatorOffDateTime [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" (gSettings) { ecobee="<[123456789012#settings.ventilatorOffDateTime]" }
	Switch settings_hasUVFilter "hasUVFilter [%s]"                                 (gSettings) { ecobee="<[123456789012#settings.hasUVFilter]" }
	Switch settings_coolingLockout "coolingLockout [%s]"                           (gSettings) { ecobee="<[123456789012#settings.coolingLockout]" }
	Switch settings_ventilatorFreeCooling "ventilatorFreeCooling [%s]"             (gSettings) { ecobee="<[123456789012#settings.ventilatorFreeCooling]" }
	Switch settings_dehumidifyWhenHeating "dehumidifyWhenHeating [%s]"             (gSettings) { ecobee="<[123456789012#settings.dehumidifyWhenHeating]" }
	String settings_groupRef "groupRef [%s]"                                       (gSettings) { ecobee="<[123456789012#settings.groupRef]" }
	String settings_groupName "groupName [%s]"                                     (gSettings) { ecobee="<[123456789012#settings.groupName]" }
	Number settings_groupSetting "groupSetting [%d]"                               (gSettings) { ecobee="<[123456789012#settings.groupSetting]" }

	Group gRuntime (All)

	String runtime_runtimeRev "runtimeRev [%s]"                                    (gRuntime) { ecobee="<[123456789012#runtime.runtimeRev]" }
	Switch runtime_connected "connected [%s]"                                      (gRuntime) { ecobee="<[123456789012#runtime.connected]" }
	DateTime runtime_firstConnected "firstConnected [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" (gRuntime) { ecobee="<[123456789012#runtime.firstConnected]" }
	DateTime runtime_connectDateTime "connectDateTime [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" (gRuntime) { ecobee="<[123456789012#runtime.connectDateTime]" }
	String runtime_disconnectDateTime "disconnectDateTime [%s]"                    (gRuntime) { ecobee="<[123456789012#runtime.disconnectDateTime]" }
	DateTime runtime_lastModified "lastModified [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" (gRuntime) { ecobee="<[123456789012#runtime.lastModified]" }
	DateTime runtime_lastStatusModified "lastStatusModified [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" (gRuntime) { ecobee="<[123456789012#runtime.lastStatusModified]" }
	String runtime_runtimeDate "runtimeDate [%s]"                                  (gRuntime) { ecobee="<[123456789012#runtime.runtimeDate]" }
	Number runtime_runtimeInterval "runtimeInterval [%d]"                          (gRuntime) { ecobee="<[123456789012#runtime.runtimeInterval]" }
	Number runtime_actualTemperature "actualTemperature [%.1f °F]"                 (gRuntime) { ecobee="<[123456789012#runtime.actualTemperature]" }
	Number runtime_actualHumidity "actualHumidity [%d %%]"                         (gRuntime) { ecobee="<[123456789012#runtime.actualHumidity]" }
	Number runtime_desiredHeat "desiredHeat [%.1f °F]"                             (gRuntime) { ecobee="<[123456789012#runtime.desiredHeat]" }
	Number runtime_desiredCool "desiredCool [%.1f °F]"                             (gRuntime) { ecobee="<[123456789012#runtime.desiredCool]" }
	Number runtime_desiredHumidity "desiredHumidity [%d %%]"                       (gRuntime) { ecobee="<[123456789012#runtime.desiredHumidity]" }
	Number runtime_desiredDehumidity "desiredDehumidity [%d %%]"                   (gRuntime) { ecobee="<[123456789012#runtime.desiredDehumidity]" }
	String runtime_desiredFanMode "desiredFanMode [%s]"                            (gRuntime) { ecobee="<[123456789012#runtime.desiredFanMode]" }

	Group gLocation (All)

	Number location_timeZoneOffsetMinutes "timeZoneOffsetMinutes [%d]"             (gLocation) { ecobee="<[123456789012#location.timeZoneOffsetMinutes]" }
	String location_timeZone "timeZone [%s]"                                       (gLocation) { ecobee="<[123456789012#location.timeZone]" }
	Switch location_isDaylightSaving "isDaylightSaving [%s]"                       (gLocation) { ecobee="<[123456789012#location.isDaylightSaving]" }
	String location_streetAddress "streetAddress [%s]"                             (gLocation) { ecobee="<[123456789012#location.streetAddress]" }
	String location_city "city [%s]"                                               (gLocation) { ecobee="<[123456789012#location.city]" }
	String location_provinceState "provinceState [%s]"                             (gLocation) { ecobee="<[123456789012#location.provinceState]" }
	String location_country "country [%s]"                                         (gLocation) { ecobee="<[123456789012#location.country]" }
	String location_postalCode "postalCode [%s]"                                   (gLocation) { ecobee="<[123456789012#location.postalCode]" }
	String location_phoneNumber "phoneNumber [%s]"                                 (gLocation) { ecobee="<[123456789012#location.phoneNumber]" }
	String location_mapCoordinates "mapCoordinates [%s]"                           (gLocation) { ecobee="<[123456789012#location.mapCoordinates]" }

	Group gWeather (All)

	DateTime weather_timestamp "timestamp [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]"   (gWeather) { ecobee="<[123456789012#weather.timestamp]" }
	String weather_weatherStation "weatherStation [%s]"                            (gWeather) { ecobee="<[123456789012#weather.weatherStation]" }

	Number weather_forecasts0_weatherSymbol "weatherSymbol [%d]"                   (gWeather) { ecobee="<[123456789012#weather.forecasts[0].weatherSymbol]" }
	DateTime weather_forecasts0_dateTime "dateTime [%1$tm/%1$td/%1$tY %1$tH:%1$tM:%1$tS]" (gWeather) { ecobee="<[123456789012#weather.forecasts[0].dateTime]" }
	String weather_forecasts0_condition "condition [%s]"                           (gWeather) { ecobee="<[123456789012#weather.forecasts[0].condition]" }
	Number weather_forecasts0_temperature "temperature [%.1f °F]"                  (gWeather) { ecobee="<[123456789012#weather.forecasts[0].temperature]" }
	Number weather_forecasts0_pressure "pressure [%d]"                             (gWeather) { ecobee="<[123456789012#weather.forecasts[0].pressure]" }
	Number weather_forecasts0_relativeHumidity "relativeHumidity [%d %%]"          (gWeather) { ecobee="<[123456789012#weather.forecasts[0].relativeHumidity]" }
	Number weather_forecasts0_dewpoint "dewpoint [%d]"                             (gWeather) { ecobee="<[123456789012#weather.forecasts[0].dewpoint]" }
	Number weather_forecasts0_visibility "visibility [%d]"                         (gWeather) { ecobee="<[123456789012#weather.forecasts[0].visibility]" }
	Number weather_forecasts0_windSpeed "windSpeed [%d]"                           (gWeather) { ecobee="<[123456789012#weather.forecasts[0].windSpeed]" }
	Number weather_forecasts0_windGust "windGust [%d]"                             (gWeather) { ecobee="<[123456789012#weather.forecasts[0].windGust]" }
	String weather_forecasts0_windDirection "windDirection [%s]"                   (gWeather) { ecobee="<[123456789012#weather.forecasts[0].windDirection]" }
	Number weather_forecasts0_windBearing "windBearing [%d]"                       (gWeather) { ecobee="<[123456789012#weather.forecasts[0].windBearing]" }
	Number weather_forecasts0_pop "pop [%d %%]"                                    (gWeather) { ecobee="<[123456789012#weather.forecasts[0].pop]" }
	Number weather_forecasts0_tempHigh "tempHigh [%.1f °F]"                        (gWeather) { ecobee="<[123456789012#weather.forecasts[0].tempHigh]" } 
	Number weather_forecasts0_tempLow "tempLow [%.1f °F]"                          (gWeather) { ecobee="<[123456789012#weather.forecasts[0].tempLow]" } 
	Number weather_forecasts0_sky "sky [%d]"                                       (gWeather) { ecobee="<[123456789012#weather.forecasts[0].sky]" } 

	Group gHouseDetails (All)

	String houseDetails_style "style [%s]"                                         (gHouseDetails) { ecobee="<[123456789012#houseDetails.style]" }
	Number houseDetails_size "size [%d]"                                           (gHouseDetails) { ecobee="<[123456789012#houseDetails.size]" }
	Number houseDetails_numberOfFloors "numberOfFloors [%d]"                       (gHouseDetails) { ecobee="<[123456789012#houseDetails.numberOfFloors]" }
	Number houseDetails_numberOfRooms "numberOfRooms [%d]"                         (gHouseDetails) { ecobee="<[123456789012#houseDetails.numberOfRooms]" }
	Number houseDetails_numberOfOccupants "numberOfOccupants [%d]"                 (gHouseDetails) { ecobee="<[123456789012#houseDetails.numberOfOccupants]" }
	Number houseDetails_age "age [%d]"                                             (gHouseDetails) { ecobee="<[123456789012#houseDetails.age]" }

## Logging

In order to configure logging for this binding to be generated in a separate file add the following to your /configuration/logback.xml file;
```xml
<appender name="ECOBEEFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
   <file>logs/ecobee.log</file>
   <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <!-- weekly rollover and archiving -->
      <fileNamePattern>logs/ecobee-%d{yyyy-ww}.log.zip</fileNamePattern>
      <!-- keep 30 days' worth of history -->
      <maxHistory>30</maxHistory>
   </rollingPolicy>
   <encoder>
     <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} %-5level %logger{30}[:%line]- %msg%n%ex{5}</pattern>
   </encoder>
</appender>
    
<!-- Change DEBUG->TRACE for even more detailed logging -->
<logger name="org.openhab.binding.ecobee" level="DEBUG" additivity="false">
   <appender-ref ref="ECOBEEFILE" />
</logger>
```