Documentation of the Bluetooth Binding Bundle

## Introduction

The Bluetooth binding is used to connect openhab with a Bluetooth device. By its help you can make openhab e.g. react on bluetooth devices that get in range of your network.

The Bluetooth binding supports three different types of openhab items: Switches, Numbers and Strings.

- Switches can be bound to a certain bluetooth device address so that they are switched on if the device is in range and off otherwise.
- Number items simply determine how many devices are currently in range.
- String items are updated with a comma-separated list of device names that are in range.

It is possible to define for each bound item if only paired, unpaired or all devices should be observed.

For installation of the binding, please see Wiki page [[Bindings]].

## Generic Item Binding Configuration

In order to bind an item to a Bluetooth event you need to provide configuration settings. The easiest way to do this is to add binding information in your item file (in the folder configurations/items`). The syntax for the Bluetooth binding configuration string is as follows:


* for switch items: `bluetooth="<deviceAddress>[!]"`, where `<deviceAddress>` is the technical address of the device, e.g. `EC935BD417C5`; the optional exclamation mark defines whether the devices needs to be paired with the host or not.
* for string items: `bluetooth="[*|!|?]"`, where '`!`' denotes to only observe paired devices, '`?`' denotes to only observe unpaired devices and '`*`' accepts any device.
* for number items: `bluetooth="[*|!|?]"`, where '`!`' denotes to only observe paired devices, '`?`' denotes to only observe unpaired devices and '`*`' accepts any device.

***

* Switch items: will receive an ON / OFF update on the bus
* String items: will be sent a comma separated list of all device names
* Number items will show the number of bluetooth devices in range


If a friendly name cannot be resolved for a device, its address will be used instead as its name when listing it on a String item.


Here are some examples for valid binding configuration strings:

    bluetooth="EC935BD417C5"
    bluetooth="EC935BD417C5!"
    bluetooth="*"
    bluetooth="!"
    bluetooth="?"

As a result, your lines in the items file might look like follows:

    Switch MyMobile     	                                  { bluetooth="EC935BD417C5!" }
    String UnknownDevices    "Unknown devices in range: [%s]" { bluetooth="?" }
    Number NoOfPairedDevices "Paired devices in range: [%d]"  { bluetooth="!" }

## Got the binding working under Linux

### Common informations

* To access the local blueooth device the binding is using [BlueCove](http://bluecove.org/).
* BlueCove is using native libraries (JNI) to access the platform specific bluetooth stack.
* There are prebuild native libraries for Windows and Mac OS X (IMHO).
* The native libraries could be build.

### What to do

So, to access the bluetooth stack on linux systems, we have to build the native libraries for our self.
* The libraries have to fit to the used platform (x86, arm, 32/64 bit, endianess).
We have to replace the bluecove stuff, that is bundled with the mainline bluetooth binding with that one, we build and then rebuild the binding for our target system (so the corrent stuff comes with it).

### Build BlueCove

To build the libraries you could use the following steps.

Install necessary packages to build (here an example for [ARM] Arch Linux).
<pre>pacman --needed -S base-devel subversion maven bluez-libs</pre>

Checkout BlueCove repository (tested with v2.1.0)
<pre>svn checkout https://bluecove.googlecode.com/svn/tags/2.1.0/</pre>

Now enter the directory and edit the pom.xml file to disable some modules, we do not need (we are only interested in bluecove and bluecove-gpl -- I did not check, if bluevoce-site-skin is necessary for bluecove build).

<pre>
    &lt;modules>
        &lt;module>bluecove-site-skin&lt;/module>
        &lt;module>bluecove&lt;/module>
&lt;!--
        &lt;module>bluecove-emu&lt;/module>
        &lt;module>bluecove-tests&lt;/module>
        &lt;module>bluecove-emu-gui&lt;/module>
-->
        &lt;module>bluecove-gpl&lt;/module>
&lt;!--
        &lt;module>bluecove-bluez&lt;/module>
        &lt;module>bluecove-examples&lt;/module>
-->
    &lt;/modules>
</pre>

Start build using maven.
<pre>mvn</pre>

The build will fail on bluecove-gpl, caused by missing header file(s).

Don't know, why the header files are not generated at the build process, but that problem should be reported upstream (perhaps, it is known and accepted for some reason I don't know).

Generate (missing) JNI header files
<pre>javah -d ./bluecove-gpl/src/main/c/ \
  -cp ./bluecove-gpl/target/classes:./bluecove/target/classes \
  com.intel.bluetooth.BluetoothStackBlueZ \
  com.intel.bluetooth.BluetoothStackBlueZConsts \
  com.intel.bluetooth.BluetoothStackBlueZNativeTests</pre>

Resume build
<pre>mvn -rf:bluecove</pre>

Necessary build results:
<pre>./bluecove/target/bluecove-2.1.0.jar
./bluecove-gpl/target/bluecove-gpl-2.1.0.jar</pre>

### Build openHAB Bluetooth binding

* Delete the bluecove jar file in the lib subdirectory of the binding.
* Add the two build jar files (e.g. bluecove-2.1.0.jar and bluecove-gpl-2.1.0.jar) to the lib subdirectory of the binding.
* Adjust binding dependencies (see below)
* Clean and rebuild the binding.

The binding will work now on the target system, the bluecove jar (and so, the native libraries) are generated. 

#### Adjust binding dependencies

This could be done using different ways, e.g. you could use the Eclipse IDE.
* open META-INF/MANIFEST.MF
* Change "Runtime", "Classpath" (replace the old bluecove jar with the two new ones)
* In "Build" the "Binary Build" should be changed automatically, if you change the runtime classpath.
* Check, if "MANIFEST.MF" and "build.properties" was changed.
* Save file

#### Restrictions

Binding is not working for Windows 8.1 (both 32 and 64 bit) and MAC OS (Yosemite).