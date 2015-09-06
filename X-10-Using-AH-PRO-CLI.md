OpenHab does not have built-in support (yet) for direct control of X10 Devices via a CM11A/CM17A Device. However there is a CLI tool provided by X-10 in both the Active Home Pro Software and the SDK (now a free download), this used with an exec binding makes for X-10 Control via OpenHAB on Windows.

The steps are relatively simple:
* Install [Active Home X-10 SDK and Drivers](http://kbase.x10.com/wiki/Activehome_Pro_SDK) 
* Browse to C:\Program Files (x86)\AHSDK
* Find an application called AHCMD.exe
* Copy it to your OpenHAB Directory
* Insert the exec command into your items file, mine looks like this:
	
`Switch Light_Main_Bedroomlamp "Bedroom Lamp" <lights> (Main, Lights){exec="ON:ahcmd.exe sendrf A1 ON, OFF:ahcmd.exe sendrf A1 off"}`	


**Notes:**

* If you have Active Home Pro installed you already have AHCMD.exe, it is located at C:\Program Files (x86)\Common Files\X10\Common
* These steps will be similar in Linux, and can be achieved using the [HEYU](http://heyu.tanj.com/) X-10 interface.
* The command ahcmd.exe sendrf A1 ON will turn on the X-10 device at address A1 via the RF (Firecracker/CM17A), to use a CM11A replace "sendrf" with "sendplc".
	
**Reference Credit:**

X-10.com Forums - http://forums.x10.com/index.php?topic=16813.0 
OpenHab WIKI- https://github.com/openhab/openhab/wiki/Exec-Binding 