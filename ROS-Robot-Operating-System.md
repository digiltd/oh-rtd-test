### ROS - Robot Operating System
The **openhab_bridge** provides a  bridge between the Robot Operating System (ROS) and OpenHAB. The bridge runs on the ROS system and uses the OpenHAB REST API.

 * **ROS** is an extremely powerful open source set of libraries and tools that help you build robot applications - providing drivers and state-of-the-art algorithms for computer vision (object detection, recognition and tracking), facial recognition, movement, environment mapping, etc.
 <http://www.ros.org>

**Connect your robot to the wider world** 

**Use Cases:**

 * A motion detector in OpenHAB triggers and ROS dispatches the robot to the location.
 * ROS facial recognition recognizes a face at the door and OpenHAB turns on the lights and unlocks the door.
 * A Washing Machine indicates to OpenHAB that the load is complete and ROS dispatches a robot to move the laundry to the dryer.
 * Location presence via the OpenHAB MQTT binding indicates that Sarah will be home soon and a sensor indicates that the  temperature is hot.  ROS dispatches the robot to bring Sarah's favorite beer.  OpenHAB turns on her favorite rock music and lowers the house temperature.
 * A user clicks on the OpenHAB GUI on an IPAD and selects a new room location for the robot.  The message is forwarded by the openhab_bridge to ROS and ROS dispatches the robot.

With the openhab_bridge, any OpenHAB device can be easily setup to publish updates to ROS, giving a ROS robot knowledge of any Home Automation device.  Simply add the group (ROS) to the item in the OpenHAB .items file and the bridge will forward status updates to ROS.

Applications using ROS can publish to the _openhab_set_ topic (or _openhab_command_) and the device in OpenHAB will be set to the new value (or act on the specified command).

 * For more information see <http://wiki.ros.org/openhab_bridge>
