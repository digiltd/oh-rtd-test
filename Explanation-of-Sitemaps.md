Sitemap Definition

## Introduction

Sitemaps are used to create elements of a user interface for making openHAB items accessible to various frontends.

Sitemaps are a declarative UI definition. With a few lines it is possible to define the structure and the content of your UI screens. Sitemap files are stored in `${openhab_home}/configurations/sitemaps`.

The openHAB runtime comes with a [demo sitemap file](https://github.com/openhab/openhab/blob/master/distribution/openhabhome/configurations/sitemaps/demo.sitemap), which should let you easily understand its structure. 

For easy editing, the openHAB Designer brings full IDE support for these files, so you can easily check the syntax and find out about the options you have. (Again, for the technically interested, this is also an [Xtext DSL](https://github.com/openhab/openhab/blob/master/bundles/model/org.openhab.model.sitemap/src/org/openhab/model/Sitemap.xtext).)

## Syntax

Sitemaps can be composed by grouping various user interface elements into areas, which will be rendered by openHAB.

The following elements can be used in a sitemap definition file (alphabetical order):

<table>
  <tr><td><b>Element name</b></td><td><b>Description</b></td></tr>
  <tr><td>Colorpicker</td><td></td></tr>
  <tr><td>Chart</td><td></td></tr>
  <tr><td>Frame</td><td>Area with either various other sitemap elements or further nested frames</td></tr>
  <tr><td>Group</td><td>Renders all elements of a given group defined in an items defintion file</td></tr>
  <tr><td>Image</td><td>Renders an image</td></tr>
  <tr><td>List</td><td></td></tr>
  <tr><td>Switch</td><td>Renders a switch item</td></tr>
  <tr><td>Selection</td><td>Renders a selection item</td></tr>
  <tr><td>Setpoint</td><td></td></tr>
  <tr><td>Slider</td><td>Renders a slider</td></tr>
  <tr><td>Text</td><td>Renders a text element</td></tr>
  <tr><td>Video</td><td>Displays a video</td></tr>
  <tr><td>Webview</td><td></td></tr>
</table>

#### <a name="colorpicker"/>Element 'Colorpicker'

Syntax:

    Colorpicker [item="<itemname>"] [label="<labelname>"] [icon="<iconname>"] [sendFrequency=""]

#### Element 'Frame'

Frames are used to create a visually separated area of items.

Syntax:

    Frame [label="<labelname>"] [icon="<icon>"] [item="<item">]
    {
    	[additional sitemap elements]
    }

#### Element 'Group'

Syntax:

    Group [item="<itemname>"] [label="<labelname>"] [icon="<iconname>"]

#### Element 'Image'

Syntax:

    Image [item="<itemname>"] [icon="<iconname>"] url="<url of image>" [label="<labelname>"] [refresh=xxxx]
refresh is the refresh period of the image in milliseconds

#### Element 'Chart'

Syntax:

    Chart [item="<itemname>"] [icon="<iconname>"] [label="<labelname>"] [service="<service>"] [period=xxxx] [refresh=xxxx]
* _refresh_ is the refresh period of the image in milliseconds
* _service_ sets the persistence service to use. If no service is set, openHAB will use the first queryable persistence service it finds. Therefore, for an installation with only a single persistence service, this is not required.
* _period_ sets the length of the time axis of the chart. Valid values are h, 4h, 8h, 12h, D, 3D, W, 2W, M, 2M, 4M, Y

Note that charts are rendered by a chart provider. By default, openHAB provides a default chart provider which will work with all queryable persistence services. Other chart providers can be user to render the chart by changing the `chart:provider=default` configuration in openhab.cfg to the name of the alternative provider. Currently, then only alternative is to use the rrdj4 provider to render the graphs.

#### Element 'Switch'

Syntax:

    Switch item="<itemname>" [label="<labelname>"] [icon="<iconname>"] [mappings="<mapping definition>"]
An explanation for mappings you can find [here](#wiki-mappings).

#### Element 'Selection'

Syntax:

    Selection item="<itemname>" [label="<labelname>"] [icon="<iconname>"] [mappings="<mapping definition>"]
An explanation for mappings you can find [here](#wiki-mappings).

#### Element 'Setpoint'

Syntax:

    Setpoint item="<itemname>" [label="<labelname>"] [icon="<iconname>"] minValue="<min value>" maxValue="<max value>" step="<step value>"

#### Element 'Slider'

Syntax:

    Slider item="<itemname>" [label="<labelname>"] [icon="<iconname>"] [sendFrequency="frequency"] [switchEnabled]

#### Element 'List'

Syntax:

    List item="<itemname>" [label="<labelname>"] [icon="<iconname>"] [separator=""]

#### Element 'Text'

Syntax:

    Text item="<itemname>" [label="<labelname>"] [icon="<iconname>"]

#### Element 'Video'

Syntax:

    Video item="<itemname>"  [icon="<iconname>"] url="<url of video to embed>" [encoding="<video encoding>"]
encoding is the video encoding. Use "mjpeg" for MJPEG video or leave empty for autoselection

#### Element 'Webview'

Syntax:

    Webview item="<itemname>" [label="<labelname>"] [icon="<iconname>"] url="<url>" [height="<heightvalue"]

### <a name="mappings"/>Mappings

Mappings can be used to let the user chose an item from a list.

**Syntax:**

     mappings = [ "value1"="name1", "value2"="name2" ]
Quotes can be omitted if the value string and name string do not contain spaces.


**Examples:**

    mappings = [ "1"="ON", "0"="OFF" ]
    mappings = [ 1="BBC", 2="CNN", 3="BLOOMBERG" ]
	
## Dynamic Sitemaps
**Note** The following is only available in v1.4.

Sitemaps can be designed to show items dynamically, or add colors depending on their state, or the state of another item. A few use cases for this are -:
* Hide elements of a heating system depending on its mode
* Display different charts or URLs depending on the state of an item
* Show a battery warning of the voltage is low
* Highlight a value with a warning color if it's above or below limits

All widgets in the sitemap have the following three parameters available -:
* visibility
* labelcolor
* valuecolor

It is important to note that in all cases rules are parsed from left to right, and the first rule that returns _true_ will take priority.

#### Visibility
To dynamically show or hide an item, the _visibility_ tag is used. By default, an item is visible if the _visibility_ tag is not provided. If provided, a set of rules are used to indicate the items visibility status. If any of the rules are _true_ then the item will be visible, otherwise it will be hidden.

The format of the _visibility_ tag is as follows -:
```
visibility=[item_name operator value, ... ]
```
Multiple rules can be provided using a comma as a delimiter. Valid operators are the ==, >=, <=, !=, >, <.

**Examples**
```
visibility=[Weather_Chart_Period!=ON]
visibility=[Weather_Chart_Period=="Today"]
visibility=[Weather_Chart_Period>1, Weather_Temperature!="Uninitialized"]
```

#### Colors
Colors can be used to emphasise an items label or its value. 

The format of the _labelcolor_ and _valuecolor_ tags are as follows -:
```
labelcolor=[item_name operator value = "color", ... ]
```
Multiple rules can be provided using a comma as a delimiter. Valid operators are the ==, >=, <=, !=, >, <. 

_itemname_ and _operator_ are optional - if not provided, itemname will default to the current item and operator will default to ==. So the following three rules will all do the same thing, and all are valid.
```
Text item=Weather_Temperature valuecolor=[22="green"]
Text item=Weather_Temperature valuecolor=[==22="green"]
Text item=Weather_Temperature valuecolor=[Weather_Temperature==22="green"]
```



openHAB supports a standard set of colors, based on the CSS definitions. This is a set of 17 colors that should be supported by any UI. The colors are defined by name, and within openHAB they are translated to the CSS color format (ie "#xxxxxx"). This should ensure a standard interface for these colors.

Below is a list of the standard colors and their respective CSS definitions. Note that case is not important.

| Name used in sitemap | Color provided in REST interface |
|----------------------|----------------------------------|
| MAROON  | #800000
| RED     | #ff0000
| ORANGE  | #ffa500
| YELLOW  | #ffff00
| OLIVE   | #808000
| PURPLE  | #800080
| FUCHSIA | #ff00ff
| WHITE   | #ffffff
| LIME    | #00ff00
| GREEN   | #008000
| NAVY    | #000080
| BLUE    | #0000ff
| AQUA    | #00ffff
| TEAL    | #008080
| BLACK   | #000000
| SILVER  | #c0c0c0
| GRAY    | #808080

For any color other than those defined above, _"color"_ is passed directly through to the UI, so its exact implementation is up to the UI. It is generally expected that valid HTML colors can be used (eg "green", "red", "#334455") but a UI could for example define abstract colors that are defined internally depending on the theme. For example, "warning" could be defined and used in a UI dependant way, but there is currently no standardisation of these terms.


**Examples**
```
valuecolor=[>25="orange",>15="green",>5="orange",<5="blue"]
valuecolor=[Weather_LastUpdate=="Uninitialized"="lightgray",Weather_LastUpdate>600="lightgray",>15="green",>=10="orange",<10="red"]
```


#### A note about rule comparison
* String comparisons are case sensitive, so `==ON` is not the same a `==on`.
* DateTime comparisons are relative to the current time and specified in seconds. So a rule >300 will return true if the DateTime item is set to a value that's newer than the past 5 minutes (300 seconds).