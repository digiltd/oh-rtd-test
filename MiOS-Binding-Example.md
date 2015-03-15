## [[MiOS Binding|MiOS-Binding]] Example

This document is intended to provide [[MiOS Binding|MiOS-Binding]] users with real-world example openHAB configurations.

Users typically have configurations falling into one or more of the following categories, which will be used to outline any subsequent examples:

* Augmenting - openHAB Rules that "add" to existing MiOS Scenes.
* Co-existing - Replacing MiOS Scenes with openHAB Rules, but keeping the Devices.
* Replacing - wholesale replacement of MiOS functionality (Devices|Scenes) with openHAB equivalent functionality.

### Examples for Augmenting
#### Adding Notifications and Text-to-Speech (TTS) when a House Alarm is triggered
MiOS has a standardized definition that most Alarm Panel plugins adhere to (DSC, Ademco, GE Caddx, Paradox, etc).  This exposes a standardized UPnP-style attribute, `AlarmPartition2/Alarm`, for the Alarm System being in active _Alarm_ mode.  It has the value `None` or `Alarm`.

Here we check the specific transition between those two states as we want to avoid being re-notified, when the `Uninitialized` » `Alarm` state transition occurs, should openHAB restart.

Item declaration:
```xtend
String   AlarmArea1Alarm "Alarm Area 1 Alarm [%s]" (GAlarmArea1) {mios="unit:house,device:228/service/AlarmPartition2/Alarm"}
```

Rule declaration:
```xtend
rule "Alarm Panel Breach"
	when
		Item AlarmArea1Alarm changed from None to Active
	then
		pushNotification("House-Alarm", "House in ALARM!! Notification")
		say("Alert: House in Alarm Notification")
end 
```

### Examples for Co-existing

### Examples for Replacing

