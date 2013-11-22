This page describes what the service discovery feature is and how it can be used by UIs

## Introduction

The Service Discovery bundle provides Multicast DNS/Bonjour functionality to openHAB. It is available in openHAB since version 1.0.0. This bundle is based on a well known java MDNS library - [jmDNS](http://jmdns.sourceforge.net/). The library is included into the bundle so no additional actions are needed to make this bundle work.

## How to use Service Discovery

The Service Discovery bundle was created mainly to simplify interaction between User Interface applications on different platforms (Android, iOS, etc) and openHAB. It provides service interface to register and announce different services, provided by openHAB to MDNS/Bonjour. 

This interface is currently used by REST bundle to announce available REST interfaces on local network. REST application announces both HTTP and HTTPS connection points depending on their individual availability.

- HTTP is announced as  **`*`openhab-server.`*`tcp.local.** and it's name is **openHAB**
- HTTPS is announced as  **`*`openhab-server-ssl.`*`tcp.local.** and it's name is **openHAB-ssl**
Both service announcements include additional **uri** attribute which shows the path ("/rest" by default) to REST interface. User Interface applications should use this attribute to form the base URL of REST interface before connecting to openHAB.

The same java library ([jmDNS](http://jmdns.sourceforge.net/)) can be used to discover openHAB on local network from java applications, including Android applications. MDNS/Bonjour is built in iOS application development framework. Plenty of examples can be found in corresponding platform developers documentation and on the internet ([Android example](http://home.heeere.com/tech-androidjmdns.html), [iOS example](http://mobileorchard.com/tutorial-networking-and-bonjour-on-iphone/) for MDNS/Bonjour usage).

## Example

To discover HTTP REST interface application must resolve `*`openhab-server.`*`tcp.local. service.

Service discovery will return several parameters of openHAB:
- IP address (like **192.168.1.20**)
- TCP port (like **8080**)
- uri attribute (like **/rest**)

The base URL for openHAB will look like this: **http://192.168.1.20:8080/rest **

## Tools

We recommend using MDNS/Bonjour tools to check if openHAB announcement is available on the network for developers:

- [iStumbler](http://www.istumbler.net/) - a good network tool for Mac OS which includes MDNS/Bonjour browsing functionality
- [Bonjour Browser](http://itunes.apple.com/us/app/discovery-bonjour-browser/id305441017?mt=8) - an iPhone/iPad application to browse MDNS/Bonjour
- [Android Bonjour Browser](https://market.android.com/details?id=com.grokkt.android.bonjour) - an Android application to browse MDNS/Bonjour
- Any windows tools links are welcome!