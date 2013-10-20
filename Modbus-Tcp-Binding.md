# Documentation of the Modbus TCP binding Bundle

# Introduction

The modbus TCP binding polls the bus in an configurable interval for a configurable length.  

For installation of the binding, please see Wiki page [[Bindings]].
 
# Details

# Binding Configuration

add to `${openhab_home}/configuration/`

Modbus binding allows to connect to multiple Modbus slaves as TCP master. This implementation works with coils (boolean values) only.
Entries in openhab config file should look like below.
Most of config parameters are related to specific slaves, the only exception is

     modbus:poll=<value>

which sets refresh interval to Modbus polling service. Value is in milliseconds - optional, default is 200

     modbus:<slave-name>:<slave-parameter>

{{{ 
 <slave-name> is unique name per slave you are connecting to.
 <slave-parameter> are pairs key=value
}}}

 Valid keys are
 host mandatory
 port TCP port, optional, default 502
 id  slave id, optional, default 1
 start slave start address, optional, default 0
 length number of data item to read, default 0 (but set it to something meaningful :)
 type data type, can be either "coil", "discrete", "holding", "input" or "register", now only "coil", "discrete", "holding" and "input" is supported
 
 now the modbus read function in case of {{{type=coil}}} is function 1, 
 in case of {{{type=discrete}}} the read function is 2,
 in case of {{{type=holding}}} the read function is 3,
 in case of {{{type=input}}} the read function ist 4

 writing is possible with {{{type=coil}}} the write function in this case is 5
 and with {{{type=holding}}} the write function is 6
 see also http://www.simplymodbus.ca

 with {{{type=holding}}} and {{{type=input}}} you can now only operate with datatype byte!!!
 see below point 4

 Minimal construction in openhab.config will look like

{{{ 
 modbus:slave1.host=192.168.1.50
 modbus:slave1.length=10
 modbus:slave1.type=coil
}}}
 
 connects to slave on ip=192.168.1.51 and reads 10 coils starting from address 0
 More complex setup could look like

    modbus:slave1.host=192.168.1.50
    modbus:slave1.port=502
    modbus:slave1.id=41
    modbus:poll=300
    modbus:slave1.start=0
    modbus:slave1.length=32
    modbus:slave1.type=coil

 example for an moxa e1214 module in simple io mode
 6 output switches starting from modbus address 0 and
 6 inputs from modbus address 10000 (the function 2 implizits the modbus 10000 address range)
 you only read 6 input bits and say start from 0
 the moxa manual ist not right clear in this case 

    modbus:poll=300
    
    modbus:slave1.host=192.168.6.180
    modbus:slave1.port=502
    modbus:slave1.id=1
    modbus:slave1.start=0
    modbus:slave1.length=6
    modbus:slave1.type=coil
    
    modbus:slave2.host=192.168.6.180
    modbus:slave2.port=502
    modbus:slave2.id=1
    modbus:slave2.start=0
    modbus:slave2.length=6
    modbus:slave2.type=discrete
    
    modbus:slave3.host=192.168.6.180
    modbus:slave3.port=502
    modbus:slave3.id=1
    modbus:slave3.start=17
    modbus:slave3.length=2
    modbus:slave3.type=input
    
    modbus:slave4.host=192.168.6.181
    modbus:slave4.port=502
    modbus:slave4.id=1
    modbus:slave4.start=33
    modbus:slave4.length=2
    modbus:slave4.type=holding

 here we use the same modbus gateway with ip 192.168.6.180 twice 
 on different modbus address ranges and modbus functions

NOTE: the moxa e1200 modules give by reading with function 02 from start=0 the content of register 10000 aka DI-00, an reading with function code 1 gives the address 00000 this is a little bit scary, reading from other plc can be different! 


# Item Binding Configuration

ModbusBindingProvider provides binding for Openhab Items
There are two ways to bind an item to modbus coils/registers

 1) single coil/register per item
     Switch MySwitch "My Modbus Switch" (ALL) {modbus="slave1:5"}

 This binds MySwitch to modbus slave defined as "slave1" in openhab.config reading/writing to the coil 5

 2) separate coils for reading and writing
     Switch MySwitch "My Modbus Switch" (ALL) {modbus="slave1:<6:>7"}
 In this case coil 6 is used as status coil (readonly) and commands are put to coil 7 by setting coil 7 to true.
 You hardware should then set coil 7 back to false to allow further commands processing. 

 3) input coil only for reading
     Contact Contact1 "Contact1 [MAP(en.map):%s]" (All)   {modbus="slave2:0"}
 In this case regarding to moxa example coil 0 is used as discrete input (in Moxa naming DI-00)

 following examples are relatively useless, if you know better one let us know!
 counter values in most cases 16bit values, now we must do math: in rules to deal with them ...

 4) read write byte register
      Number Dimmer1 "Dimmer1 [%d]" (ALL) {modbus="slave4:0"}
  and in sitemap
      Setpoint item=Dimmer1 minValue=0 maxValue=100 step=5
  NOTE: if the value goes over a byte this case is fully untested!!!
   this example should write the value to all DO bits of an moxa e1212 as byte value

 5) read only byte register {{{type=input}}}
      Number MyCounterH "My Counter high [%d]" (All) {modbus="slave3:0"}
 this reads counter 1 high word
      Number MyCounterL "My Counter low [%d]" (All) {modbus="slave3:1"}
 this reads counter 1 low word
 