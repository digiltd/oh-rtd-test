# Yamahareceiver Binding

_Remark: this Page is Beta, please add your extensions if you know one!
the explanations copied from various forum posts_

This binding connects openhab with varoius Yamaha Receivers.

## Configuration

`openhab.cfg

     #Yamaha Receiver 
     yamahareceiver:basement.host=192.168.178.50
`

`.items

     Switch Yamaha_Power         "Power [%s]"         <tv>    { yamahareceiver="uid=amp, zone=main,  bindingType=power" }
     Dimmer Yamaha_Volume         "Volume [%.1f %%]"             { yamahareceiver="uid=amp, zone=main, bindingType=volumePercent" }
     Switch Yamaha_Mute             "Mute [%s]"                 { yamahareceiver="uid=amp, zone=main, bindingType=mute" }
     String Yamaha_Input         "Input [%s]"                 { yamahareceiver="uid=amp, zone=main, bindingType=input" } 
     String Yamaha_Surround         "surround [%s]"             { yamahareceiver="uid=amp, zone=main, bindingType=surroundProgram" } 
     Number Yamaha_NetRadio  "Net Radio" <netRadio> { yamahareceiver="uid=amp, zone=main, bindingType=netRadio" }
`

`.sitemap

     Selection item=Kueche_NetRadio label="Sender" mappings=[1="N Joy", 2="Radio Sport", 3="RDU", 4="91ZM", 5="Hauraki"]
     Selection item=Yamaha_Input mappings=[HDMI1="BlueRay",HDMI2="Satellite",AV4="Roku",TUNER="Tuner"]