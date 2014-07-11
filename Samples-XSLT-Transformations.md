openHAB allows you to post [HTTP](Http-Binding) queries over the internet, and to put the received data in items that you can use in your rules.
In most cases, you will get the information you need into a XML structured document, and you need a way to extract only the value you want: here is where XSLT transformations come in our help.
XSLT is a standard method to transform an XML structure into a document with the structure you want. You can find a very good tutorial here: [XSLT tutorial at W3Schools](http://www.w3schools.com/xsl/default.asp)

In the following examples:
*  the directive **xsl:output** says that the incoming document must be transformed into another XML-like document, without XML header (the _<?xml...?>_ part)
* the directive **template** specify a rule to apply when a specific XML node type is found. The template to match is contained in the **match="/"** clause, where **"/"** means **"any type of node"**, so the whole document.
* inside the template directive we find the rule, in this case a value to extract from the selected node. In the first example, we want to extract the value **temp** from the node **yweather:condition**. Indeed, if we look at the syntax of the Yahoo Weather service, we can see that the weather conditions are returned into a XML document that contains a string like that:
```xml
<yweather:condition  text="Mostly Cloudy"  code="28"  temp="50"  date="Fri, 18 Dec 2009 9:38 am PST" />
```

***


Yahoo Weather - temperature 
```xml
<?xml version="1.0"?>
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" version="1.0">
    
   <xsl:output indent="yes" method="xml" encoding="UTF-8" omit-xml-declaration="yes" />
    
   <xsl:template match="/">
      <xsl:value-of select="//yweather:condition/@temp" /> 
   </xsl:template>
    
</xsl:stylesheet>
```

Yahoo Weather - feels like temperature
```xml
<?xml version="1.0"?>
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" version="1.0">
    
   <xsl:output indent="yes" method="xml" encoding="UTF-8" omit-xml-declaration="yes" />
    
   <xsl:template match="/">
      <xsl:value-of select="//yweather:wind/@chill" /> 
   </xsl:template>  
    
</xsl:stylesheet>
```

Yahoo Weather - humidity
```xml
<?xml version="1.0"?>
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" version="1.0">
    
   <xsl:output indent="yes" method="xml" encoding="UTF-8" omit-xml-declaration="yes" />
    
   <xsl:template match="/">
      <xsl:value-of select="//yweather:atmosphere/@humidity" />
   </xsl:template>
    
</xsl:stylesheet>
```

Yahoo Weather - sunrise
```xml
<?xml version="1.0"?>
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" version="1.0">
    
   <xsl:output indent="yes" method="xml" encoding="UTF-8" omit-xml-declaration="yes" />
    
   <xsl:template match="/">
      <xsl:value-of select="//yweather:astronomy/@sunrise" />
   </xsl:template>
    
</xsl:stylesheet>
```

Yahoo Weather - sunset
```xml
<?xml version="1.0"?>
    <xsl:stylesheet 
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" version="1.0">
    
            <xsl:output indent="yes" method="xml" encoding="UTF-8" omit-xml-declaration="yes" />
    
            <xsl:template match="/">
                    <xsl:value-of select="//yweather:astronomy/@sunset" />
            </xsl:template>
    
    </xsl:stylesheet>
```

Yahoo Weather - weather text
```xml
<?xml version="1.0"?>
    <xsl:stylesheet 
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" version="1.0">
    
            <xsl:output indent="yes" method="xml" encoding="UTF-8" omit-xml-declaration="yes" />
    
            <xsl:template match="/">
                    <xsl:value-of select="//item/yweather:condition/@text" />
            </xsl:template>
    
    </xsl:stylesheet>
```

Yahoo Weather - wind speed
```xml
<?xml version="1.0"?>
    <xsl:stylesheet 
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" version="1.0">
    
            <xsl:output indent="yes" method="xml" encoding="UTF-8" omit-xml-declaration="yes" />
    
            <xsl:template match="/">
                    <xsl:value-of select="//yweather:wind/@speed" />
            </xsl:template>
    
    </xsl:stylesheet>
```

Yahoo Weather - forecast tomorrow
```xml
<?xml version="1.0"?>
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" version="1.0">
    
   <xsl:output indent="yes" method="text" encoding="UTF-8" omit-xml-declaration="yes" />
    
   <xsl:template match="/">
      <xsl:value-of select="//item/yweather:forecast[1]/@text" />
      <xsl:text>, Low: </xsl:text>
      <xsl:value-of select="//item/yweather:forecast[1]/@low" /> 
      <xsl:text>°C, High: </xsl:text>
      <xsl:value-of select="//item/yweather:forecast[1]/@high" /> 
      <xsl:text>°C</xsl:text>
   </xsl:template>
       
</xsl:stylesheet>
```

Yahoo Weather - forecast day after tomorrow
```xml
<?xml version="1.0"?>
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" version="1.0">
    
   <xsl:output indent="yes" method="text" encoding="UTF-8" omit-xml-declaration="yes" />
    
   <xsl:template match="/">
      <xsl:value-of select="//item/yweather:forecast[2]/@text" />
      <xsl:text>, Low: </xsl:text>
      <xsl:value-of select="//item/yweather:forecast[2]/@low" /> 
      <xsl:text>°C, High: </xsl:text>
      <xsl:value-of select="//item/yweather:forecast[2]/@high" /> 
      <xsl:text>°C</xsl:text>
   </xsl:template>
    
</xsl:stylesheet>
```