## Prerequisites
### Raspberry Pi
    sudo apt-get update && sudo apt-get install oracle-java7-jdk
    sudo update-java-alternatives -s jdk-7-oracle-armhf
### BeagleBone Black
TBD
### Ubuntu / Debian
Install a java 7 runtime.

### Remarks
The runtime installation is tweaked to use separate folders for configuration, the software, log files
 and runtime generated files. Therefore your feedback will be very welcome, especially if you run into problems.

## Quick Setup
### Add openHAB repo to the apt sources list 
    $ sudo echo "deb http://repository-openhab.forge.cloudbees.com/release/1.4.0/apt-repo/ /" > /etc/apt/sources.list.d/openhab.list

### Install openHAB runtime

    $ sudo apt-get update
    $ sudo apt-get install openhab-runtime

The packages are not signed therefore you will get a warning!

### Install addons
Use *"apt-cache search openhab"* to get a list of all packages. Install the add-ons as you need them using *"apt-get install"*.

    $ sudo apt-cache search openhab
    $ sudo apt-get install openhab-addon-binding-xy

### Add openHAB configuration
#### openhab.cfg
Edit /etc/openhab/configurations/openhab.cfg
#### Items
Drop an items file into the directory /etc/openhab/configurations/items/
#### Sitemap
Drop a sitemap file into the directory /etc/openhab/configurations/sitemaps

#### Optional configuration
##### Rules
Drop a rules file into the directory /etc/openhab/configurations/rules

##### Persistence
Drop a rules file into the directory /etc/openhab/configurations/persitence
##### Scripts
Drop a rules file into the directory /etc/openhab/configurations/scripts
##### Transform
Drop a rules file into the directory /etc/openhab/configurations/transform


### Start openHAB runtime
    $ sudo /etc/init.d/openhab start
The server will run unprivileged using the account "openhab".
The deb installer adds openHAB to the system startup. 

## Upgrade
Changed configuration files will be retained even on upgrades!

    $ sudo apt-get update
    $ sudo apt-get upgrade

## Advanced Configuration
### general
You will find the openHAB configuration under /etc/openhab.
If you change configuration files it will not be overwritten by updates or upgrades.

#### /etc/default/openhab
    USER_AND_GROUP=openhab:openhab
    HTTP_PORT=8080
    HTTPS_PORT=8443
    TELNET_PORT=5555
    OPENHAB_JAVA=/usr/bin/java

### Logging
#### Configuration
The runtime uses /etc/openhab/logback.xml.
A template for debugging is provided through /etc/openhab/logback_debug.xml. You can change logback.xml
to your needs.
#### Log files
The runtime log: /var/log/openhab/openhab.log
Further log files are placed also into: /var/log/openhab/

### Jetty
/etc/openhab/jetty/etc/
### Runtime generated files
/var/lib/openhab
### login.conf
/etc/openhab/login.conf
### users.cfg
/etc/openhab/users.cfg
### quartz.properties
/etc/openhab/quartz.properties

## Snapshot builds
TBD