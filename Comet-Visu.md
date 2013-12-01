Documentation of the CometVisu Backend

**Note: This feature will only be available in openHAB 1.4!**

## Introduction

This adds a backend for the web based visualization CometVisu (http://www.cometvisu.org). The CometVisu is a highly customizable visualization, that runs in any browser. Despite the existing browser based UI´s in openHAB, the CometVisu does not read the sitemaps. The layout is defined with an XML-based configuration file.

This is just a short overview, more details will be added soon!

## Requirements

* openHAB 1.4 or greater<br>
Note: Until openHAB 1.4 is relased, the latest version can be downloaded from [here](https://openhab.ci.cloudbees.com/job/openHAB/)
* CometVisu 0.8.0 or greater (https://sourceforge.net/projects/openautomation/files/CometVisu/).<br>
It might be usefull to work with the latest SVN version of CometVisu as well.<br>
On a Raspberry Pi, the installation of the SVN version works like this:<br>
 1. Installation of subversion on the RasPi:<br>
`sudo apt-get update` <br>
`sudo apt-get install subversion`<br>
 2. Download of the CometVisu SVN<br>
Assumptions: openHAB is installed in the directory openHAB, CometVisu is located in webapps/cometVISU<br>
`cd openHAB/webapps`<br>
`svn co svn://svn.code.sf.net/p/openautomation/code/CometVisu/trunk/src cometVISU`<br>
 3. For an update later on you just need to do this<br>
`cd openHAB/webapps`<br> 
`svn update cometVISU`<br>
Note: This information ist taken from [here](http://www.cometvisu.de/wiki/index.php?title=CometVisu/HowTo_install_the_development_version_on_the_WireGate). As long as the PHP runtime is not available (see Known Problems), the chmod described there is not required.

## Installation

* Copy the addon org.openhab.io.cv*.jar to the openHAB addon folder
* Then just extract the release folder of the downloaded CometVisu archive in openHAB´s webapps folder and rename it to, e.g. cometVISU.

## Configuration

This is a first small sample implementation. Actually only the items below are implemented:
* number
* switch
* contact
* dimmer

Please feel free to add more items.


## Known problems

Some parts of the CometVisu need a PHP runtime. As this is not included in Jetty, the following parts do not work:
* Editor
* Configuration check
* Configuration upgrade (only needed if you upgrade your CometVisu to a new release)

Currently the only workaround is to build, edit and maintain your CometVisu configuration manually with an XML editor of your choice.

## Screenshots

will be available soon, meanwhile some screenshots can be found here:
- http://knx-user-forum.de/cometvisu/26139-allgemeine-frage-wie-sieht-eure-cv-startseite-aus.html

## Links

* German CometVisu Support Forum: http://knx-user-forum.de/cometvisu/
* Some documentation about CometVisu: http://www.cometvisu.org