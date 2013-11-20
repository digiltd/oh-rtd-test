##  Description

This binding allows to remotely control a Pioneer AV receiver equipped with an ethernet interface. It enables OpenHAB to switch ON/OFF the receiver, adjust the volume, set the input source and configure most other parameters.

Most common commands are supported directly, special commands can be added manually using the "advanced command" mechanism described below.

## Binding configuration

Before configuring single items, the global device configuration needs to be set up in the openhab.cfg file.

     ################################# Pioneer AVR Binding ######################################  
     # Host of the first Pioneer device to control  
     pioneeravr:<Pioneer1>.host=192.168.2.140  
     
     # Port of the Pioneer device to control (optional, defaults to 23)  
     pioneeravr:<Pioneer1>.port=23

The pioneeravr:<Pioneer1>.host value is the ip address of the Pioneer AV receiver.
The pioneeravr:<Pioneer1>.port value is TCP port address of the the receiver. Port value is an optional parameter.


Example:

     pioneeravr:livingroom.host=192.168.2.140  
     pioneeravr:livingroom.port=23

## Item Binding Configuration

In order to bind an item to the device, you need to provide configuration settings.
 The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). 
The syntax of the binding configuration strings accepted is the following:


     pioneeravr="<openHAB-command>:<device-id>:<device-command>[,<openHAB-command>:<device-id>:<device-command>][,...]"


where parts in brackets signify an optional information.

* The openHAB-command corresponds OpenHAB command.
* The device-id corresponds the deviceid that was introduced in openhab.cfg.
* The device-command corresponds Pioneer AV receiver command. See complete list below.

Examples, how to configure your items:


     Switch  AV_Pwr { pioneeravr="INIT:livingroom:POWER_QUERY, OFF:livingroom:POWER_OFF, ON:livingroom:POWER_ON"}
     Switch  AV_Mute  { pioneeravr="INIT:livingroom:MUTE_QUERY, ON:livingroom:MUTE, OFF:livingroom:UNMUTE" }
     Dimmer  AV_Volume { pioneeravr="INIT:livingroom:VOLUME_QUERY, INCREASE:livingroom:VOLUME_UP, DECREASE:livingroom:VOLUME_DOWN, *:livingroom:VOLUME_SET" }



## List of predefined Pioneer AV receiver commands 

* Power  
    * POWER_OFF  
    * POWER_ON  
    * POWER_QUERY  

* Mute
    * UNMUTE
    * MUTE
    * MUTE_QUERY

* Volume
    * VOLUME_UP
    * VOLUME_DOWN
    * VOLUME_QUERY
    * VOLUME_SET

* Source
    * SOURCE_DVD
    * SOURCE_BD
    * SOURCE_TV_SAT
    * SOURCE_DVR_BDR
    * SOURCE_VIDEO1
    * SOURCE_VIDEO2
    * SOURCE_HDMI1
    * SOURCE_HDMI2
    * SOURCE_HDMI3
    * SOURCE_HDMI4
    * SOURCE_HDMI5
    * SOURCE_HMG
    * SOURCE_IPOD
    * SOURCE_XMRADIO
    * SOURCE_CD
    * SOURCE_CDR_TAPE
    * SOURCE_TUNER
    * SOURCE_PHONO
    * SOURCE_MULTI_CH_IN
    * SOURCE_ADAPTER_PORT
    * SOURCE_SIRIUS
    * SOURCE_UP
    * SOURCE_DOWN
    * SOURCE_QUERY
    * SOURCE_SET
    * SOURCE_HDMI_CYCLIC

* Listening mode
    * LISTENING_MODE
    * LISTENING_MODE_QUERY

* Home Media Gallery
    * HMG_NUMKEY
    * HMG_NUMKEY0
    * HMG_NUMKEY1
    * HMG_NUMKEY2
    * HMG_NUMKEY3
    * HMG_NUMKEY4
    * HMG_NUMKEY5
    * HMG_NUMKEY6
    * HMG_NUMKEY7
    * HMG_NUMKEY8
    * HMG_NUMKEY9
    * HMG_PLAY
    * HMG_PAUSE
    * HMG_PREVIOUS
    * HMG_NEXT
    * HMG_DISPLAY
    * HMG_STOP
    * HMG_UP
    * HMG_DOWN
    * HMG_RIGHT
    * HMG_LEFT
    * HMG_ENTER
    * HMG_RETURN
    * HMG_PROGRAM
    * HMG_CLEAR
    * HMG_REPEAT
    * HMG_RANDOM
    * HMG_MENU
    * HMG_EDIT
    * HMG_CLASS

* Tone control
    * TONE_ON
    * TONE_BYPASS
    * TONE_QUERY
    * BASS_INCREMENT
    * BASS_DECREMENT
    * BASS_QUERY
    * TREBLE_INCREMENT
    * TREBLE_DECREMENT
    * TREBLE_QUERY

* Speaker control
    * SPEAKERS
    * SPEAKERS_OFF
    * SPEAKERS_A
    * SPEAKERS_B
    * SPEAKERS_A_B

* HDMI Output selection
    * HDMI_OUTPUT
    * HDMI_OUT_ALL
    * HDMI_OUT_1
    * HDMI_OUT_2

* HDMI Audio control
    * HDMI_AUDIO_AMP
    * HDMI_AUDIO_THROUGH

* PQLS setting
    * PQLS_OFF
    * PQLS_AUTO

* Zone 2 control
    * ZONE2_POWER_ON
    * ZONE2_POWER_OFF
    * ZONE2_POWER_QUERY
    * ZONE2_INPUT
    * ZONE2_INPUT_DVD
    * ZONE2_INPUT_TV_SAT
    * ZONE2_INPUT_DVR_BDR
    * ZONE2_INPUT_VIDEO1
    * ZONE2_INPUT_VIDEO2
    * ZONE2_INPUT_HMG
    * ZONE2_INPUT_IPOD
    * ZONE2_INPUT_XMRADIO
    * ZONE2_INPUT_CD
    * ZONE2_INPUT_CDR_TAPE
    * ZONE2_INPUT_TUNER
    * ZONE2_INPUT_ADAPTER
    * ZONE2_INPUT_SIRIUS
    * ZONE2_INPUT_QUERY
    * ZONE2_VOLUME_UP
    * ZONE2_VOLUME_DOWN
    * ZONE2_VOLUME
    * ZONE2_VOLUME_QUERY
    * ZONE2_MUTE
    * ZONE2_UNMUTE
    * ZONE2_MUTE_QUERY

* Zone 3 control
    * ZONE3_POWER_ON
    * ZONE3_POWER_OFF
    * ZONE3_POWER_QUERY
    * ZONE3_INPUT
    * ZONE3_INPUT_DVD
    * ZONE3_INPUT_TV_SAT
    * ZONE3_INPUT_DVR_BDR
    * ZONE3_INPUT_VIDEO1
    * ZONE3_INPUT_VIDEO2
    * ZONE3_INPUT_HMG
    * ZONE3_INPUT_IPOD
    * ZONE3_INPUT_XMRADIO
    * ZONE3_INPUT_CD
    * ZONE3_INPUT_CDR_TAPE
    * ZONE3_INPUT_TUNER
    * ZONE3_INPUT_ADAPTER
    * ZONE3_INPUT_SIRIUS
    * ZONE3_INPUT_QUERY
    * ZONE3_VOLUME_UP
    * ZONE3_VOLUME_DOWN
    * ZONE3_VOLUME
    * ZONE3_VOLUME_QUERY
    * ZONE3_MUTE
    * ZONE3_UNMUTE
    * ZONE3_MUTE_QUERY

* Tuner settings
    * TUNER_FREQ_INCREMENT
    * TUNER_FREQ_DECREMENT
    * TUNER_FREQ_QUERY_AM
    * TUNER_FREQ_QUERY_FM
    * TUNER_BAND
    * TUNER_PRESET
    * TUNER_CLASS
    * TUNER_PRESET_INCREMENT
    * TUNER_PRESET_DECREMENT
    * TUNER_PRESET_QUERY

* iPod Control
    * IPOD_PLAY
    * IPOD_PAUSE
    * IPOD_STOP
    * IPOD_PREVIOS
    * IPOD_NEXT
    * IPOD_REV
    * IPOD_FWD
    * IPOD_REPEAT
    * IPOD_SHUFFLE
    * IPOD_DISPLAY
    * IPOD_CONTROL
    * IPOD_CURSOR_UP
    * IPOD_CURSOR_DOWN
    * IPOD_CURSOR_LEFT
    * IPOD_CURSOR_RIGHT
    * IPOD_ENTER
    * IPOD_RETURN
    * IPOD_TOP_MENU
    * IPOD_KEY_OFF

* Adapter port
    * ADAPTER_PLAY_PAUSE
    * ADAPTER_PLAY
    * ADAPTER_PAUSE
    * ADAPTER_STOP
    * ADAPTER_PREVIOUS
    * ADAPTER_NEXT
    * ADAPTER_REV
    * ADAPTER_FWD

* LCD status information text
    * DISPLAY_INFO_QUERY



## Advanced commands

If you want to use commands that are not predefined by the binding you can use them with a shape # as a prefix.

Example:

     Switch  AV_AdvCmd { pioneeravr="INIT:livingroom:POWER_QUERY, ON:livingroom:#PO, OFF:livingroom:#PF" }

This will act as a power switch.
A list of all commands that are supported by the pioneer receiver can be found here: [http://www.pioneerelectronics.com/PUSA/Support/Home-Entertainment-Custom-Install/RS-232+&+IP+Codes](http://www.pioneerelectronics.com/PUSA/Support/Home-Entertainment-Custom-Install/RS-232+&+IP+Codes)



## Basic demo


### av.items:

     Switch  AV_Pwr     "Power" { pioneeravr="INIT:livingroom:POWER_QUERY, OFF:livingroom:POWER_OFF, ON:livingroom:POWER_ON" }
     Switch  AV_Mute    "Mute" { pioneeravr="INIT:livingroom:MUTE_QUERY, ON:livingroom:MUTE, OFF:livingroom:UNMUTE" }
     Number  AV_Source  „Source [%.1f]" { pioneeravr="INCREASE:livingroom:SOURCE_UP, DECREASE:livingroom:SOURCE_DOWN, *:livingroom:SOURCE_SET" }
     String  AV_Status  "Status [%s]" { pioneeravr="INIT:livingroom:DISPLAY_INFO_QUERY" }
     Number  AV_Volume "Volume abs.[%.1f]" { pioneeravr="INIT:livingroom:VOLUME_QUERY, *:livingroom:VOLUME_SET" }
     Dimmer  AV_Volume_perc "Volume perc. [%.1f]%" (gAV_Receiver) { pioneeravr="INIT:livingroom:VOLUME_QUERY,  INCREASE:livingroom:VOLUME_UP, DECREASE:livingroom:VOLUME_DOWN, *:livingroom:VOLUME_SET" }
     Switch  AV_HMG_Class "HMG class" { pioneeravr="ON:livingroom:HMG_CLASS" }
     Number  AV_HMG_Num "HMG Num" { pioneeravr="*:livingroom:HMG_NUMKEY" }
     Switch  AV_AdvCmd_Test "Adv Cmd test" { pioneeravr="INIT:livingroom:POWER_QUERY, ON:livingroom:#PO, OFF:livingroom:#PF" }

### av.sitemap:

     Frame {
     		Text label="AV Receiver" icon="video" {
     			Text item=AV_Status label="Status: [%s]"
     			Switch item=AV_Pwr
     			Switch item=AV_Mute mappings=[ON="Mute", OFF="Un-Mute"]
     			Switch item=AV_Source  mappings=[5=TV, 4=DVD, 26=HMG, 15=DVR, 2=FM ] 
     			Setpoint item=AV_Volume_perc
     			Switch item=AV_HMG_Num  mappings=[1="WDR2", 2="1Live", 3="DLF" ]
                        Switch item=AV_Tuner_Preset  mappings=[1="WDR2", 2="1Live", 3="DLF" ]
     		}
     	}

## Additional protocol information:

The mapping of the source channels (AV_Source) to enumation numbers is as follows:

* 04: DVD
* 25: BD
* 05: TV/SAT
* 15: DVR/BDR
* 10: VIDEO 1(VIDEO)
* 14: VIDEO 2
* 19: HDMI 1
* 20: HDMI 2
* 21: HDMI 3
* 22: HDMI 4
* 23: HDMI 5
* 26: HOME MEDIA GALLERY(Internet Radio)
* 17: iPod/USB
* 18: XM RADIO
* 01: CD
* 03: CD-R/TAPE
* 02: TUNER
* 00: PHONO
* 12: MULTI CH IN
* 33: ADAPTER PORT
* 27: SIRIUS
* 31: HDMI (cyclic)

Further information for specific receivers can be found here: [http://www.pioneerelectronics.com/PUSA/Support/Home-Entertainment-Custom-Install/RS-232+&+IP+Codes](http://www.pioneerelectronics.com/PUSA/Support/Home-Entertainment-Custom-Install/RS-232+&+IP+Codes)
