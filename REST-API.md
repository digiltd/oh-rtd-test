## Introduction

The REST API of openHAB serves different purposes. It can be used to integrate openHAB with other system as it allows read access to items and item states as well as status updates or the sending of commands for items. Furthermore, it gives access to the sitemaps, so that it is the interface to be used by remote user interfaces (e.g. fat clients or fully Javascript based web clients).

The REST API furthermore supports server-push, so you can subscribe yourself on change notification for certain resources. Find more about the server-push features in the "Server-Push" section below.

The uris of the REST API support different media types. This means that you can define the format of the response with an additional HTTP header like 

    Accept: application/xml
For each url, you will find the list of supported media types documented below.

If your client cannot correctly set the HTTP accept header, you also have the choice to append the query "?type=xml", "?type=json" or "?type=jsonp" to the URI to request a specific media type for the response.

Each resource that accepts `application/x-javascript` as a media type returns JSONP results, which can be parameterized by appending `?jsoncallback=callback` to the URI, e.g.

```
    http://localhost:8080/rest/items/Temperature_FF_Office?jsoncallback=callback
```
which yields the following response
```
callback({"type":"NumberItem","name":"Temperature_FF_Office","state":"Undefined","link":"http://localhost:8080/rest/items/Temperature_FF_Office"})
```

The parameter `jsoncallback` is optional. If not provided, `callback` will be used as a default.

# Details

The entry url for the REST API is the following:

```
    http://localhost:8080/rest
```
Media types: application/xml, application/json, application/x-javascript

As a response, this will return links to the available resource collections:
```
    <openhab>
        <link type="items">http://localhost:8080/rest/items</link>
        <link type="sitemaps">http://localhost:8080/rest/sitemaps</link>
    </openhab>
```
## Item Resources

The request

```
    http://localhost:8080/rest/items
```
Media types: application/xml, application/json, application/x-javascript

returns a collection of all declared items like
```
    <items>
        <item>
            <type>GroupItem</type>
            <name>Temperature</name>
            <state>20.145533363073167</state>
            <link>http://localhost:8080/rest/items/Temperature</link>
        </item>
        <item>
            <type>NumberItem</type>
            <name>NoOfPairedDevices</name>
            <state>1</state>
            <link>http://localhost:8080/rest/items/NoOfPairedDevices</link>
        </item>
        <item>
            <type>GroupItem</type>
            <name>gFF</name>
            <state>Undefined</state>
            <link>http://localhost:8080/rest/items/gFF</link>
        </item>
        ...
    </items>
```

Single items can hence be accessed like

```
    http://localhost:8080/rest/items/Temperature_FF_Office
```
Media types: application/xml, application/json, application/x-javascript

To directly access an item state, you can access

```
    http://localhost:8080/rest/items/Temperature_FF_Office/state
```
which returns the state as a plain string.

Likewise, you can send a status update using the HTTP verb PUT to the same uri, passing the new state as a plain string argument in the body (encoding text/plain).

In order to send a command to an item, you would use the item uri (`http://localhost:8080/rest/items/Temperature_FF_Office`) and send an HTTP POST with the according command in the request body as text/plain.

## Sitemap Resource

The request

```
    http://localhost:8080/rest/sitemaps
```
Media types: application/xml, application/json, application/x-javascript

returns a collection of all declared sitemaps like
```
    <sitemaps>
        <sitemap>
            <name>default</name>
            <link>http://localhost:8080/rest/sitemaps/default</link>
        </sitemap>
        <sitemap>
            <name>demo</name>
            <link>http://localhost:8080/rest/sitemaps/demo</link>
        </sitemap>
    </sitemaps>
```
The content of a single sitemap is available at

The request
```
    http://localhost:8080/rest/sitemaps/demo
```
Media types: application/xml, application/json, application/x-javascript

which returns a result like
```
    <sitemap>
      <name>demo</name>
      <link>http://localhost:8080/rest/sitemaps/demo</link>
      <homepage>
        <id>demo</id>
        <link>http://localhost:8080/rest/sitemaps/demo/demo</link>
        <widget>
          <type>Frame</type>
          <label />
          <icon>frame</icon>
          <widget>
            <type>Group</type>
            <label>First Floor</label>
            <icon>1stfloor</icon>
            <item>
              <type>GroupItem</type>
              <name>gFF</name>
              <state>Undefined</state>
              <link>http://localhost:8080/rest/items/gFF</link>
            </item>
            <linkedPage>
              <id>0000</id>
              <link>http://localhost:8080/rest/sitemaps/demo/0000</link>
              <widget>
                <type>Group</type>
                <label>Bathroom</label>
                <icon>bath</icon>
                <item>
                  <type>GroupItem</type>
                  <name>FF_Bath</name>
                  <state>Undefined</state>
                  <link>http://localhost:8080/rest/items/FF_Bath</link>
                </item>
                [...]
              </widget>
            </linkedPage>
          </widget>
        </widget>
      </homepage>
    </sitemap>
```
You can see that the sitemap information not only contains the static information that the user has provided in the sitemap file, but that it also holds derived data like icons and labels and dynamic group contents, where the groups structure is not explicitly defined in the sitemap.

Single pages can be accessed by adding a page id (as given in the sitemap response):

```
    http://localhost:8080/rest/sitemaps/demo/FF_Bath
```
Media types: application/xml, application/json, application/x-javascript

which returns the widgets contained in this page:
```
    <page>
      <id>FF_Bath</id>
      <link>http://localhost:8080/rest/sitemaps/demo/FF_Bath</link>
      <widget>
        <type>Switch</type>
        <label>Ceiling</label>
        <icon>switch</icon>
        <item>
          <type>SwitchItem</type>
          <name>Light_FF_Bath_Ceiling</name>
          <state>ON</state>
          <link>http://localhost:8080/rest/items/Light_FF_Bath_Ceiling</link>
        </item>
      </widget>
      [...]
      <widget>
        <type>Text</type>
        <label>Bath [undefined]</label>
        <icon>contact</icon>
          <item>
          <type>ContactItem</type>
          <name>Window_FF_Bath</name>
          <state>CLOSED</state>
          <link>http://localhost:8080/rest/items/Window_FF_Bath</link>
        </item>
      </widget>
    </page>
```

## Server-Push

openHAB makes use of the Atmosphere framework for server-push functionality. 
By this, you automatically have the option to use long-polling, HTTP streaming or websockets, depending on what your client supports.  

You can subscribe on the following resources:
- a single item (or item group)
- an item state
- a single page of a sitemap

Whenever the state of an item that is part of the resource changes, the resource will be returned just as on a regular request (i.e. exactly the same syntax). This is especially useful for sitemap pages as you can instantly refresh your UI whenever some state changes on the currently shown page.

To tell the openHAB server that you want to suspend the response (i.e. use server-push), you have to add the following header to your HTTP request:
    X-Atmosphere-Transport: websocket|long-polling|streaming

Moreover it's recommend to set a unique tracking Id for each client. 
    X-Atmosphere-tracking-id: unique id
With the aid the of the tracking id openHAB is able to reduce the network load. openHAB will detect if the actual message is equal to the previous one and will supress double broadcasts. The tracking header is also neccessary if you want to receive page-label and page-icon updates on streaming connections (see below). 

Please note: for sitemap ressources we have different types of answers.
This depends on the connection type.

### Polling Connections

"X-Atmosphere-Transport: long-polling" should be set as HTTP Header.

long-polling connections will always receive a complete page object. The answer is equal to normal REST api invocations as described above.

### Streaming Connections

"X-Atmosphere-Transport: streaming" or
"X-Atmosphere-Transport: websocket"
should be set as HTTP Header.

HTTP streaming or websocket connections receive only updated objects from the openHAB server. The received update could either be a widget and / or a page object. If the page label or icon is not changed you will only receive a widget object, but if a label or icon is changed on the page you will additionally receive a page object. 
(For this feature the "X-Atmosphere-tracking-id" header is required)

a widget response looks like
```
    <widgets>
      <widget>
        <widgetId>FF_Bath_0</widgetId>
        <type>Switch</type>
        <label>Ceiling</label>
        <icon>switch-on</icon>
        <item>
          <type>SwitchItem</type>
          <name>Light_FF_Bath_Ceiling</name>
          <state>ON</state>
          <link>http://localhost:8080/rest/items/Light_FF_Bath_Ceiling</link>
        </item>
      </widget>
    </widgets>
```
in case the page label or icon changes you will also receive something like this:
```
    <page>
      <id>030001</id>
      <title>No. of Active Heatings [(1)]</title>
      <icon>heating-on</icon>
      <link>http://localhost:8080/rest/sitemaps/demo/030001</link>
      <parent>
        <id>0300</id>
        <title>Group Demo</title>
        <icon>1stfloor</icon>
        <link>http://localhost:8080/rest/sitemaps/demo/0300</link>
      </parent>
    </page>
```
That's all! The GreenT UI, the iOS client as well as HABDroid use this mechanism to update the pages.

Besides this, server-push can be very helpful for integration with other systems, if they are interested in state changes from openHAB - there is no need to do polling in such a case.

Checkout the atmosphere pages to learn more about client development: https://github.com/Atmosphere/atmosphere

### Code Samples

See the following for code samples:
https://github.com/openhab/openhab/wiki/Samples-REST