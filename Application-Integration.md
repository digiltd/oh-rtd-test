Integrating openHAB with other applications.

* [Asterisk](Samples-Integration#Asterisk)
* [Linux Media Players](Samples-Integration#linux-media-players)
* [ROS Robot Operating System](Samples-Integration#ROS-integration)
* [Telldus Tellstick](Samples-Integration#telldus-tellstick)
* [Zoneminder](Samples-Integration#zoneminder)

## Integration

Sometimes you can easily integrate openHAB with other applications without creating specific bindings. This page collects recipes for doing that.

### Asterisk

In some cases it is very useful to make call routing decisions in Asterisk based on openHAB Items states. As an example, if nobody is home (away mode is on) route my doorphone calls to mobile, in other case route them to local phones inside the house. To do that AGI (Asterisk application gateway interface) can be used to obtain Item state value into an Asterisk variable and then a routing decision can be performed based on this variable value. Here is a small python script which, when called from Asterisk AGI makes an http request to openHAB REST API, gets specific item state and puts it into specified Asterisk variable:
```sh
    #!/usr/bin/python
    import sys,os,datetime
    import httplib
    import base64
    
    def send(data):
            sys.stdout.write("%s \n"%data)
            sys.stdout.flush()
    
    AGIENV={}
    env = ""
    while(env != "\n"):
            env = sys.stdin.readline()
            envdata =  env.split(":")
            if len(envdata)==2:
                    AGIENV[envdata[0].strip()]=envdata[1].strip()
    
    username = AGIENV['agi_arg_1']
    password = AGIENV['agi_arg_2']
    item = AGIENV['agi_arg_3']
    varname = AGIENV['agi_arg_4']
    
    auth = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
    headers = {"Authorization" : "Basic %s" % auth}
    conn = httplib.HTTPConnection("localhost", 8080)
    conn.request('GET', "/rest/items/%s/state"%item, "", headers)
    response = conn.getresponse()
    item_state = response.read()
    
    send("SET VARIABLE %s %s"%(varname, item_state))
    sys.stdin.readline()
```
In Asterisk dialplan (extensions.conf) this AGI script is used in the following way:

    exten => 1000,1,Answer()
    exten => 1000,n,AGI(openhabitem.agi, "asterisk", "password", "Presence", "atHome")
    exten => 1000,n,GotoIf($["${atHome}" == "ON"]?athome:away)
    exten => 1000,n(athome),Playback(hello-world) ; do whatever you need if Presence is ON
    exten => 1000,n,Hangup()
    exten => 1000,n(away),Playback(beep) ; do whatever you need if Presence is OFF
    exten => 1000,n,Hangup()

In AGI call arguments are:
- the script name itself
- openhab username
- openhab password
- openhab Item name
- Asterisk variable to put state to

### Linux Media Players

A number of popular Linux media players can be remotely controlled via the D-Bus based Media Player Remote Interfacing Specification (MPRIS). The Perl script below provides some "glue" you can use to control a Linux Media Play (in this case Clementine) from OpenHAB via MQTT. The script needs to run on the same machine as the media player but using MQTT means that OpenHAB can be running somewhere else.
```perl
    #!/usr/bin/perl
 
    use strict;
 
    use 5.010;
    use Net::DBus;
    use Data::Dumper;
    use Net::MQTT::Simple;
 
    my $mqtt = Net::MQTT::Simple->new("my-mqtt-server");
 
    our $service = Net::DBus->session->get_service('org.mpris.MediaPlayer2.clementine');
    our $player = $service->get_object('/Player');
    our $properties = $service->get_object('/TrackList');
    my $playlists = $service->get_object('/org/mpris/MediaPlayer2', 'org.mpris.MediaPlayer2.Playlists');
 
    $playlists->ActivatePlaylist('/org/mpris/MediaPlayer2/Playlists/1');         # Playlist 1 is my radio stations
 
    # Main Loop
 
    $mqtt->run(
        "/Clementine/status" => sub {       # For debugging purposes
            my $status = $properties->GetMetadata();
            print Dumper $status;
        },
        "/Clementine/station" => sub {
            my ($topic, $message) = @_;
            $properties->PlayTrack($message);
        },
        "/Clementine/volume" => sub {
            my $volume = $player->VolumeGet();
            my $newvolume = $volume;
            my ($topic, $message) = @_;
            given ($message) {
                when ("ON")           { $player->Play(); }
                when ("OFF")          { $player->Stop(); }
                when (/\d+$/)          { $newvolume = $message; }
                when ("INCREASE")     { $newvolume += 10; }
                when ("DECREASE")     { $newvolume -= 10; }
            }
            $newvolume = 100 if ($newvolume > 100);
            $newvolume = 0 if ($newvolume < 0);
            if ($volume != $newvolume) {
                $player->VolumeSet($newvolume);
            }
        },
        "/Clementine/#" => sub {            # For debugging purposes
            my ($topic, $message) = @_;
            print "[$topic] $message\n";
        },
    )
```

Sample items:
```
Dimmer Radio    "Radio Volume"      <slider>                (House) {mqtt=">[mosquitto:/Clementine/volume:command:*:${command}]"}
Number Station  "Radio Station"     <music>                 (House) {mqtt=">[mosquitto:/Clementine/station:command:*:${command}]"}
```

### ROS - Robot Operating System
The **openhab_bridge** provides a  bridge between the Robot Operating System (ROS) and OpenHAB. The bridge runs on the ROS system and uses the OpenHAB REST API.

 * **ROS** is an extremely powerful open source set of libraries and tools that help you build robot applications - providing drivers and state-of-the-art algorithms for computer vision (object detection, recognition and tracking), facial recognition, movement, environment mapping, etc.
 [[http://www.ros.org|ros.org]]

**Connect your robot to the wider world** 

**Use Cases:**

 * A motion detector in OpenHAB triggers and ROS dispatches the robot to the location.
 * ROS facial recognition recognizes a face at the door and OpenHAB turns on the lights and unlocks the door.
 * A Washing Machine indicates to OpenHAB that the load is complete and ROS dispatches a robot to move the laundry to the dryer.
 * Location presence via the OpenHAB MQTT binding indicates that Sarah will be home soon and a sensor indicates that the  temperature is hot.  ROS dispatches the robot to bring Sarah's favorite beer.  OpenHAB turns on her favorite rock music and lowers the house temperature.
 * A user clicks on the OpenHAB GUI on an IPAD and selects a new room location for the robot.  The message is forwarded by the openhab_bridge to ROS and ROS dispatches the robot.

With the openhab_bridge, any OpenHAB device can be easily setup to publish updates to ROS, giving a ROS robot knowledge of any Home Automation device.  Simply add the group (ROS) to the item in the OpenHAB .items file and the bridge will forward status updates to ROS.

Applications using ROS can publish to the _openhab_set_ topic (or _openhab_command_) and the device in OpenHAB will be set to the new value (or act on the specified command).

 * For more information see [[http://wiki.ros.org/openhab_bridge|ros.org/openhab_bridge]]


### Telldus Tellstick

Below is an example of how to capture events from Telldus Tellstick and forward them to the openhab bus as events through REST. The example works for on/off switches and wireless sensors but can easily be extended to dimmers, etc. Events are sent to openhab regardless if a telldus state change originates from a wireless remote or from other software (e. g. Switchking or Telldus Center). In other word, the script keeps openhab in sync with telldus states.

You need:
- Tellstick Duo (RF Transmitter/Receiver)
- Telldus Core software from here: http://developer.telldus.se/
- Tellcore Python lib: https://pypi.python.org/pypi/tellcore-py

See wiki section [Binding configurations](https://code.google.com/p/openhab-samples/wiki/BindingConfig?ts=1378067942&updated=BindingConfig#How_to_send_commands_to_Telldus_Tellstick) for the outbound example (openhab to tellstick).

Tested on Ubuntu Server 13.04.
```python
    #!/usr/bin/env python
    
    import sys
    import time
    
    import tellcore.telldus as td
    from tellcore.constants import *
    
    import httplib
    
    openhab = "localhost:8080"
    headers = {"Content-type": "text/plain"}
    connErr = "No connection to openhab on http://" + openhab
    
    METHODS = {TELLSTICK_TURNON: 'ON',
               TELLSTICK_TURNOFF: 'OFF',
               TELLSTICK_BELL: 'BELL',
               TELLSTICK_TOGGLE: 'toggle',
               TELLSTICK_DIM: 'dim',
               TELLSTICK_LEARN: 'learn',
               TELLSTICK_EXECUTE: 'execute',
               TELLSTICK_UP: 'up',
               TELLSTICK_DOWN: 'down',
               TELLSTICK_STOP: 'stop'}
    
    def raw_event(data, controller_id, cid):
        string = "[RAW] {0} <- {1}".format(controller_id, data)
        print(string)
    
    def device_event(id_, method, data, cid):
        method_string = METHODS.get(method, "UNKNOWN STATE {0}".format(method))
        string = "[DEVICE] {0} -> {1}".format(id_, method_string)
        if method == TELLSTICK_DIM:
            string += " [{0}]".format(data)
        print(string)
        url = "/rest/items/td_device_{0}/state".format(id_)
        try:
            conn = httplib.HTTPConnection(openhab)
            conn.request('PUT', url, method_string, headers)
        except:
            print(connErr)
    
    def sensor_event(protocol, model, id_, dataType, value, timestamp, cid):
        string = "[SENSOR] {0} [{1}/{2}] ({3}) @ {4} <- {5}".format(
            id_, protocol, model, dataType, timestamp, value)
        print(string)
        url = "/rest/items/td_sensor_{0}_{1}_{2}/state".format(protocol, id_, dataType)
        try:
            conn = httplib.HTTPConnection(openhab)
            conn.request('PUT', url, value, headers)
        except:
            print(connErr)
    
    core = td.TelldusCore()
    callbacks = []
    
    callbacks.append(core.register_device_event(device_event))
    callbacks.append(core.register_raw_device_event(raw_event))
    callbacks.append(core.register_sensor_event(sensor_event))
    
    try:
        while True:
            core.process_pending_callbacks()
            time.sleep(0.5)
    except KeyboardInterrupt:
        pass
```

### Zoneminder

I appreciate Zoneminder has the Zoneminder.pm api.  I attempted to use it but with most things zoneminder I found the documentation totally out of date and zero comments in the code.  So instead I achieved my goal by accessing the zoneminder mySQL database direct.  It works rather well.

This is a simple php script that can be executed from a linux commandline if you have the PHP packages installed.  I simply run it under "screen" at boot time with the command "screen -d -m /opt/openhab/scripts/zoneminderAlarm.php".

It serves two purposes:

1) Sets a switch in openhab when motion is recorded on my front drive.  Openhab uses the switch to sound a doorbell sound.  I have all sorts of rules governing when to sound the doorbell and when to simply record a missed visitor, how you have that setup is your own call.

2) The script updates openhab number items.  The items store a count for the number of events in the last 24 hours.

READ THE COMMENTS IN THE SOURCE CODE BELOW to set it up.  Hope this helps someone.
```php
    #!/usr/bin/php
    <?php
    /*
    THIS SCRIPT SERVES TWO PURPOSES.  THE FIRST HALF IS USED TO SOUND A DOORBELL WHEN A
    NEW EVENT IS DETECTED. BY DEFAULT ZONEMINDER MONITOR 1 IS USED FOR THIS AS THATS MY
    MONITOR THAT WATCHES THE FRONT DRIVE.
    
    **** CHECK THE SWITCH STATEMENT IN THE "CHECK FOR EVENTS" SECTION BELOW, BE SURE TO
    USE THE RIGHT MONITOR ID (SEE THE COMMENTS) ****
    
    THE SECOND HALF OF THE SCRIPT HARVESTS THE NUMBER OF EVENTS IN THE LAST 24 HOURS FOR
    ANY NUMBER OF ZONEMINDER MONITORS AND PASSES THE COUNTS TO OPENHAB
    */
    
    //THIS ARRAY CONTAINS THE MONITOR IDS AND THE OPENHAB ITEMS YOU WANT TO UPDATE.  THE OPENHAB ITEM IS A SIMPLE NUMBER ITEM THAT STORES THE COUNT
    $countDetails = array(
                       0 => array('monitorId' => '1', 'openhabItem' => 'frontGardenCount', 'lastCount' => 0),
                       1 => array('monitorId' => '2', 'openhabItem' => 'rearGardenCount', 'lastCount' => 0),
                       2 => array('monitorId' => '5', 'openhabItem' => 'rearDoorCount', 'lastCount' => 0),
                    );
    
    function getValByID($id) {
      $res = file_get_contents("http://192.168.1.121:8080/rest/items/" . $id . "/state");
      return $res;
    }
    
    function doPostRequest($item, $data) {
      $url = "http://192.168.1.121:8080/rest/items/" . $item;
    
      $options = array(
        'http' => array(
            'header'  => "Content-type: text/plain\r\n",
            'method'  => 'POST',
            'content' => $data  //http_build_query($data),
        ),
      );
    
      $context  = stream_context_create($options);
      $result = file_get_contents($url, false, $context);
    
      return $result;
    }
    
    $lastId = 0;
    $countCheckTimestamp = time();
    
    //FIRST RUN, BEFORE WE GO INTO THE MAIN LOOP MAKE SURE ALL COUNTS IN OPENHAB ARE SET TO 0
    foreach ($countDetails as $curCount) {
      doPostRequest($curCount['openhabItem'], "0");
    }
    
    $con = mysqli_connect("localhost", "root", "r292nda", "zm");
    
    if (mysqli_connect_errno($con)) {
      exec('logger "zoneminderAlarm cannot connect to database"');
    } else {
      while(1 == 1) {
    
        //CHECK FOR EVENTS
        if ($result = $con->query("select * from Events order by Id desc limit 1")) {
          while ($row = $result->fetch_row()) {
            if ($lastId == 0) {
              $lastId = $row[0];
            }
    
            if ($row[0] > $lastId) {
              $lastId = $row[0];
    
    	  //$row[1] IS THE MONITOR ID IN ZONEMINDER, TO FIND THIS GO TO THE ZONEMINDER WEBSITE, POINT TO THE LINK TO VIEW THE MONITOR, LOOK AT THE LINK URL, MID= IS THE MONITOR ID
              switch ($row[1]) {
                case "1":
                  doPostRequest("doorbellState", "ON");
                  break;
                case "2":
                  doPostRequest("privacyState", "ON");
                  break;
              }
            }
          }
        }
    
        //EVERY 30 SECONDS UPDATE THE EVENT COUNTS
        if (time() - $countCheckTimestamp >= 30) {
          $countCheckTimestamp = time();
          //GET EVENT COUNTS
          $curDate = date("Y-m-d");
    
          foreach ($countDetails as $key => $curCount) {
    
            if ($result = $con->query("select count(Id) as num from Events where MonitorId = '" . $curCount['monitorId'] . "' and StartTime like '" . $curDate . "%'")) {
              $row = $result->fetch_row();
    
              if (is_numeric($row[0])) {
                //ONLY SEND A COUNT TO OPENHAB IF IT HAS CHANGED
                if ($row[0] <> $curCount['lastCount']) {
                  $countDetails[$key]['lastCount'] = $row[0];
                  doPostRequest($curCount['openhabItem'], $row[0]);
                }
              } else {
                $countDetails[$key]['lastCount'] = "0";
                doPostRequest($curCount['openhabItem'], "0");
              }
            }
          } //foreach ($countDetails as $curCount)
        } //if (time() - $countCheckTimestamp > 30)
    
        sleep(2);
      }
    }
    ?>
```