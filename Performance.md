## Performance Tuning OpenHAB
Tips for optimizing OpenHAB performance.   By default, OpenHAB logs quite a bit of data and scans frequently for config changes.  Once your setup is stable, you should reduce the level of logging and scanning.  Note: performance tuning for Bindings is in the Binding entries themselves. 


## Logging

In logback.xml

    do a search for INFO and replace with WARN


## Folder Scanning

In jetty.xml change the scan interval to 240 seconds. 
For Linux, jetty.xml is normally in /etc/openhab/jetty/etc

    <New class="org.eclipse.jetty.deploy.providers.ContextProvider">
    <Set name="monitoredDir"><Property name="jetty.home" default="." />/contexts</Set>
    <Set name="scanInterval">240</Set>
    </New>

In openhab.cfg, change the folder scan interval to 240 seconds.

    folder:items=240,items
    folder:sitemaps=240,sitemap
    folder:rules=240,rules
    folder:scripts=240,script
    folder:persistence=240,persist
