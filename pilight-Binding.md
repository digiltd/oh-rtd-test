Documentation for the pilight binding

## Introduction

This page describes the pilight binding, which allows openhab to communicate with a [pilight](http://www.pilight.org/) instance:

> pilight is a free open source full fledge domotica solution that runs on a Raspberry Pi, HummingBoard, BananaPi, Radxa, but also on *BSD and various linuxes (tested on Arch, Ubuntu and Debian). It's open source and freely available for anyone. pilight works with a great deal of devices and is frequency independent. Therefor, it can control devices working at 315Mhz, 433Mhz, 868Mhz etc. Support for these devices are dependent on community, because we as developers don't own them all.

pilight is a cheap way to control 'Click On Click Off' devices. You can do this for example by using a Raspberry Pi and a cheap 433Mhz transceiver off eBay, plus an optional band pass filter.

Currently, switches, dimmers and string and number items are supported by this binding. 

### Installation 

- Copy the pilight binding jar to your openhab addons directory
- Configure the pilight daemon in openhab.cfg
- Add controlable items to openhab .items file 
- Use items in sitemap 

### Configuration openhab.cfg

This binding supports multiple pilight instances. You must set the .host and .port values. 

```
#
# pilight:<instance name>.<parameter>=<value>
#
# IP address of the pilight daemon 
#pilight:kaku.host=192.168.1.22
#
# Port of the pilight daemon
#pilight:kaku.port=5000
#
# Optional delay (in millisecond) between consecutive commands. 
# Recommended value without band pass filter: 1000 
# Recommended value with band pass filter: somewhere between 200-500 
#pilight:kaku.delay=1000
```

### Item configuration

Item configuration follows this format: 

    pilight="<instance>#<room>:<device>"

Room and device are the same as specified in your pilight config.json. 

Examples:

```
Switch  KakuDeskLamp    "Desk lamp"             (Lamps)         {pilight="kaku#study:desklamp"}
Switch  KakuFloorLamp   "Floor lamp"            (Lamps)         {pilight="kaku#study:floorlamp"}

Dimmer  KakuCeiling     "Ceiling"               (Lamps)         {pilight="kaku#living:ceiling"}
```
### Usage in sitemap

```
Switch item=KakuDeskLamp
Switch item=KakuFloorLamp
Slider item=KakuCeiling
```

### Additional info

For more information/questions:

- [Dutch pilight support thread](http://gathering.tweakers.net/forum/list_messages/1581828/4)