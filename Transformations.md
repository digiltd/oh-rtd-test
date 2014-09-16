Overview of available transformation services

### Exec transformation service
tbd ...

### Java Script transformation service
tbd ...

### Map transformation service
tbd ...

### RegEx transformation service
tbd ...

### XPath transformation service
tbd ...

### XSLT transformation service
tbd ...

### JSonPath transformation service
As with XPath on XML data, [JSONPath](http://goessner.net/articles/JsonPath/) allows direct query of JSON data.

`// Test JSONPath
rule "Test JSONPath"
when Time cron "0 * * * * ?"
then
   var String json = '{"store":{"book":[{"category":"reference","author":"Nigel Rees","title": "Sayings of the Century", "price": 8.95  } ],  "bicycle": { "color": "red",  "price": 19.95} }}' 
    var test = transform("JSONPATH","$.store.book[0].author",json)
    println(test)
end`



