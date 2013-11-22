# Sitemap Definition

## Introduction

Sitemaps are used to create elements of a user interface for making openHAB items accessible to various frontends.

Sitemaps are a declarative UI definition. With a few lines it is possible to define the structure and the content of your UI screens. Sitemap files are stored in `${openhab_home}/configurations/sitemaps`.

The openHAB runtime comes with a [demo sitemap file](https://github.com/openhab/openhab/blob/master/distribution/openhabhome/configurations/sitemaps/demo.sitemap), which should let you easily understand its structure. 

For easy editing, the openHAB Designer brings full IDE support for these files, so you can easily check the syntax and find out about the options you have. (Again, for the technically interested, this is also an [Xtext DSL](https://github.com/openhab/openhab/blob/master/bundles/model/org.openhab.model.sitemap/src/org/openhab/model/Sitemap.xtext).)

## Syntax

Sitemaps can be composed by grouping various user interface elements into areas, which will be rendered by openHAB.

The following elements can be used in a sitemap definition file (alphabetical order):

<table>
  <tr><td>**Element name**</td><td>**Description**</td></tr>
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

### Element 'Colorpicker'

Syntax:
    Colorpicker [item="<itemname>"] [label="<labelname>"] [icon="<iconname>"] [sendFrequency=""]

### Element 'Frame'

Frames are used to create a visually separated area of items.

Syntax:
    Frame [label="<labelname>"] [icon="<icon>"] [item="<item">]
    {
    	[additional sitemap elements]
    }

### Element 'Group'

Syntax:
    Group [item="<itemname>"] [label="<labelname>"] [icon="<iconname>"]

### Element 'Image'

Syntax:
    Image [item="<itemname>"] [icon="<iconname>"] url="<url of image>" [label="<labelname>"] [refresh=xxxx]
refresh is the refresh period of the image in milliseconds

### Element 'Chart'

Syntax:
    Image [item="<itemname>"] [icon="<iconname>"] [label="<labelname>"] [service="<service>"] [period=xxxx] [refresh=xxxx]
refresh is the refresh period of the image in milliseconds

### Element 'Switch'

Syntax:
    Switch item="<itemname>" [label="<labelname>"] [icon="<iconname>"] [mappings="<mapping definition>"]

### Element 'Selection'

Syntax:
    Selection item="<itemname>" [label="<labelname>"] [icon="<iconname>"] [mappings="<mapping definition>"]

### Element 'Setpoint'

Syntax:
    Setpoint item="<itemname>" [label="<labelname>"] [icon="<iconname>"] minValue="<min value>" maxValue="<max value>" step="<step value>"

### Element 'Slider'

Syntax:
    Slider item="<itemname>" [label="<labelname>"] [icon="<iconname>"] [sendFrequency="frequency"] [switchEnabled="switchSupport"]

### Element 'List'

Syntax:
    List item="<itemname>" [label="<labelname>"] [icon="<iconname>"] [separator=""]

### Element 'Text'

Syntax:
    Text item="<itemname>" [label="<labelname>"] [icon="<iconname>"]

### Element 'Video'

Syntax:
    Video item="<itemname>"  [icon="<iconname>"] url="<url of video to embed>"

### Element 'Webview'

Syntax:
    Webview item="<itemname>" [label="<labelname>"] [icon="<iconname>"] url="<url>" [height="<heightvalue"]