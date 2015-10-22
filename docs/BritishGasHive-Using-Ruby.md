You Will Need

* [RUBY](https://www.ruby-lang.org/en/documentation/installation/)
* [BritishGasHive Gem](https://rubygems.org/gems/BritishGasHive)

This looks simple but I created the Ruby Gem for this so you don't have to do the hard work, you could do it all in one script.

One you have Ruby installed you can get the example script from [GitHub](https://github.com/josephdouce/rubygem-BritishGasHive)

![Ruby Script](http://puu.sh/gsOe7/74648a719e.png)

Create a Number item with a binding to call the Ruby script and use the output to update your Number item, obviously change the "OpenHABAlertMe.rb to whatever you called your script.

`Number Temperature_Hive "Temperature [%.1f °C]" <temperature> (Living) {exec="<[ruby C:/Tools/Scripts/OpenHABAlertMe.rb:60000:REGEX((.*?))]"} `

![OpenHAB Item](http://puu.sh/gsOh7/17ba674daa.png)

Here is the event bus update

![OpenHAB Update](http://puu.sh/gsOfi/66f11bf9e6.png)

And the corresponding UI

![UI](http://puu.sh/gsOzz/8ef9e932f9.png)