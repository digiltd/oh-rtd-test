Overview of available transformation services

### Exec transformation service
tbd ...

### Java Script transformation service
OpenHab supports transformation scripts written in Javascript. Example item configuration:

`http="<[http://example.com/var/value:60000:JS(getValue.js)]" }`

Let's assume we have received a string containing `foo bar baz` and we're looking for a length of the last word (`baz`).

`getValue.js`:

    // Wrap everything in a function
    (function(i) {
        var
            array = i.split(i);
        return array[array.length - 1].length;
    })(input)
    // input variable contains data passed by openhab

### Map transformation service
tbd ...

### RegEx transformation service
tbd ...

### XPath transformation service
tbd ...

### XSLT transformation service
tbd ...
For samples see [here](https://github.com/openhab/openhab/wiki/Samples-XSLT-Transformations).

### JSonPath transformation service
As with XPath on XML data, [JSONPath](http://goessner.net/articles/JsonPath/) allows direct query of JSON data.

```
// Test JSONPath
rule "Test JSONPath"
when Time cron "0 * * * * ?"
then
   var String json = '{"store":{"book":[{"category":"reference","author":"Nigel Rees","title": "Sayings of the Century", "price": 8.95  } ],  "bicycle": { "color": "red",  "price": 19.95} }}' 
    var test = transform("JSONPATH","$.store.book[0].author",json)
    println(test)
end
```



