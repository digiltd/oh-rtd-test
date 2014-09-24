There are a few different way to controll openHAB with your android smartphone.
# Manual
## Web interface
The simplest way is to use the browser and open the openHAB [[web interface|Web-AppUI]].

## HABdroid
Use the official android app [HABdroid](https://github.com/openhab/openhab/wiki/HABDroid).

### NFC
HABdroid supports NFC

## HABsweetie
[HABSweetie](https://github.com/dereulenspiegel/HABSweetie) is an alternative android app.  

# Automation
## Tasker
Since you are already playing with home **automation**, you might as well try to automate some thing with your phone.  
One of the best ways to automate anything on your android is using the app [Tasker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm).

It is a little tricky at the beginning.
But once you understand how Tasker works, there are endless posibilities.  
A good place to start is the YouTube-Channel [Tasker 101 Tutorials](https://www.youtube.com/playlist?list=PLjV3HijScGMynGvjJrvNNd5Q9pPy255dL)

### Send a command to openHAB via HTTP Get
To send a command (set a value to an item) you can use the build-in action "HTTP Get".

* create a new task
* add the "HTTP Get" action
* fill in the fisrt three fields
    * Since you might want to use more than one actions it is adviseable to use global variables (start with capital letter) for "Server:Port"
    * Like: %OHSERVER:%OHPORT
* put "CMD" into the Path-field
* write the itemname and the value into the Attributes-field
    * Like: MeAtHome=ON
* exit this action and exit the task
* in the VARS tab (right top corner) you can see and define the global variables
    * fill in the IP and the port
Now you can run the task and see if it works.

### Read a item value from openHAB via RESTask
In order to read a value of an item via the [[REST-API|REST-API]] you need a the tasker plugin [RESTask](https://play.google.com/store/apps/details?id=com.freehaha.restask).
* Read the description in the Play Store
* add the RESTask action to your task
* Configure
    * Request Type: GET
    * Host: http://%OHSERVER:%OHPORT/rest/items/Temp_Bedroom/state
        * see above about global variables
    * save
* add an Wait action "until %RTCODE is set"
* add an action (e.g Flash) to output the %RTRES-variable

### Set and Get values from openHAB via HABSweetie plugin
[HABSweetie](https://github.com/dereulenspiegel/HABSweetie) provides a tasker plugin.

## Examples

### Mute radio during a call
One use case could be to mute your radio (or pause a movie) when you receive a call.
* openHAB
    * create a switch item in openHAB called "CallInProgress"
    * define a rule to mute your radio when the state of "CallInProgress" changes from OFF to ON
    * define a rule to unmute your radio when the state of "CallInProgress" changes from ON to OFF
* Tasker
    * create a tasker profile
        * use the "Call" state to trigger the task when a call starts
    * add a begin task and use the HTTP Get action to set "CallInProgress" to "ON"
    * add an end task and use the HTTP Get action to set "CallInProgress" to "OFF"

### more ideas
* tell openHAB you are at home when the smartphone connects to your home wifi
* use the Tasker plugin [AutoVoice](https://play.google.com/store/apps/details?id=com.joaomgcd.autovoice) to control anything with your vioce
* start the radio in the morning when the alarm (of your smartphone) goes off
