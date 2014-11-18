_**Note:** This Binding will be available in the upcoming 1.6 Release. For preliminary builds please see the [CI server at Cloudbees](https://openhab.ci.cloudbees.com/job/openHAB/)._

# Introduction
This binding is designed to interface with BenQ projectors that have an RS232 interface on them that accepts the commands documented by BenQ in [\[1\]](ftp://ftp.benq-eu.com/projector/benq_rs232_commands.pdf).

# Status
This binding is current in Beta state with the following commands implemented:

| Command               | Query | Set  |Comments                                    |
|-----------------------|:-----:|:----:|--------------------------------------------|
| Power                 |Y      | Y    | |
| Mute                  |Y      | Y    | |
| Volume                |Y      | Y    | |
| Source                |Y      | Y    | Can be returned as either a string or number |
| Lamp Time             |Y      | N    | |

Tested Devices:

* BenQ W1080

## Transports

The binding has currently been developed using a TCP/IP to RS232 converter. A direct RS232 interface needs to be implemented.

Known working converter is the [USR-TCP232-2](http://en.usr.cn/Ethernet-Module-T24/RS232-to-Ethernet-module.html).

# Binding Configuration
```
############################# BenqProjector Binding  ########################################

# device interface
benqprojector:deviceId=<hostname>:<port number>

# set interval to refresh status from projector
benqprojector:refresh=15000

# following is default, non-network mode is not implemented
#benqprojector:networkMode=true
```

# Item Configuration

Example of Item bindings:

```
Switch gf_lounge_multimedia_projectorPower "Projector Power" (gf_lounge, gf_multimedia) {benqprojector="power"}
Switch gf_lounge_multimedia_projectorMute "Projector Mute" (gf_lounge, gf_multimedia) {benqprojector="mute"}
Number gf_lounge_multimedia_projectorVol "Projector Volume [%d]" (gf_lounge, gf_multimedia) {benqprojector="volume", autoupdate="false"}
Number gf_lounge_multimedia_projectorSourceNum "Projector Source [MAP(ProjSourceNum.map):%s]" (gf_lounge, gf_multimedia) {benqprojector="source_number"}
String gf_lounge_multimedia_projectorSourceString "Projector Source [%s]" (gf_lounge, gf_multimedia) {benqprojector="source_string"}
Number gf_lounge_multimedia_projectorLamp "Projector Lamp [%d hours]" (gf_lounge, gf_multimedia) {benqprojector="lamp_hours"}
```

Example source mapping:
```
0=Computer
1=Computer 2
2=Component
3=DVI-A
4=DVI-D
5=Sky TV (HDMI)
6=Chromecast (HDMI2)
7=Composite
8=S-Video
9=Network
10=USB Display
11=USB Reader
-=Unknown
undefined=Unknown
```

Example sitemap:

```
	Frame label="Media" {
		Switch item=gf_lounge_multimedia_projectorPower
	}
			
	Frame label="Projector" visibility=[gf_lounge_multimedia_projectorPower==ON] {
		Selection item=gf_lounge_multimedia_projectorSourceNum label="Projector Source" mappings=[5="Sky TV", 6="Chromecast"]  visibility=[gf_lounge_multimedia_projectorPower==ON]
		Switch item=gf_lounge_multimedia_projectorMute visibility=[gf_lounge_multimedia_projectorPower==ON]
		Setpoint item=gf_lounge_multimedia_projectorVol step=1 minValue=0 maxValue=10 visibility=[gf_lounge_multimedia_projectorPower==ON]				
	}
```

# References
[\[1\]](ftp://ftp.benq-eu.com/projector/benq_rs232_commands.pdf) ftp://ftp.benq-eu.com/projector/benq_rs232_commands.pdf