# Homematic Configuration XML File 

## Introduction

To be able to configure the converter and available parameter of a homematic device, xml files are used. They are optional, not necessary. Some devices don't work properly without (rollershutter).
There is one device per file. 

The config file have to be included inside the distribution (org.openhab.binding.homematic/src/main/resources/devices) and they have to be instatiated at the HomematicBinding constructor. 
A better and easier way of adding these files is always welcome!

## Structure

Each file has one device element. Each device has several channel elements (the channel name is ignored at the moment).
Each channel contains multiple parameters, which are the same value as you would configure in your item config (e.g. LEVEL, STATE, TEMPERATURE etc). 
The parameter of a device can be found in the http://www.eq-3.de/Downloads/PDFs/Dokumentation_und_Tutorials/HM_Script_Teil_4_Datenpunkte_1_503.pdf (or newer versions of that file).

For each parameter there can be a number of converters for a homematic type (like PercentType, OpenClosedType, etc). The converter is given by FQN (full qualified name).

## Available Converter
* BooleanOnOffConverter.java
* BooleanOpenCloseConverter.java
* BrightnessConverter.java
* BrightnessIntegerDecimalConverter.java
* DoubleDecimalConverter.java
* DoubleOnOffConverter.java
* DoublePercentageConverter.java
* DoubleUpDownConverter.java
* IntegerDecimalConverter.java
* IntegerOnOffConverter.java
* IntegerOpenClosedConverter.java
* IntegerPercentageOnOffConverter.java
* IntegerPercentageOpenClosedConverter.java
* IntegerPercentConverter.java
* InvertedBooleanOpenCloseConverter.java
* InvertedDoubleOpenClosedConverter.java
* InvertedDoublePercentageConverter.java
* InvertedDoubleUpDownConverter.java
* NegativeBooleanOnOffConverter.java
* StateCommandConverter.java
* TemperatureConverter.java

These converters can also be given at the item config with parameter "converter".

### XML Schema

<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.w3.org/2001/XMLSchema" targetNamespace="http://www.example.org/device" xmlns:tns="http://www.example.org/device" elementFormDefault="qualified">

    <element name="device" type="tns:DeviceType"></element>

    <complexType name="DeviceType">
        <sequence>
            <element maxOccurs="unbounded" type="tns:ChannelType"></element>
        </sequence>
        <attribute name="name" type="string" />
        <attribute name="type" type="string" />
    </complexType>

    <complexType name="ChannelType">
        <sequence>
            <element maxOccurs="unbounded" name="parameter" type="tns:ParameterType"></element>
        </sequence>
        <attribute name="name" type="string"></attribute>
    </complexType>

    <complexType name="ParameterType">
        <sequence>
            <element maxOccurs="unbounded" type="tns:ConverterType" />
        </sequence>
        <attribute name="name" type="string"></attribute>
    </complexType>

    <complexType name="ConverterType">
        <sequence>
            <element name="className">
                <simpleType>
                    <restriction base="string"></restriction>
                </simpleType>
            </element>
        </sequence>
        <attribute name="forType" type="string"></attribute>
    </complexType>
</schema>

## Example
<?xml version="1.0" encoding="UTF-8"?>
<device name="HM-LC-Bl1PBU-FM" type="rollershutter">
    <channel name="0">
        <parameter name="UNREACH">
            <converter forType="OnOffType">
                <className>org.openhab.binding.homematic.internal.converter.state.BooleanOnOffConverter</className>
            </converter>
        </parameter>
    </channel>
    <channel name="1">
        <parameter name="LEVEL">
            <converter forType="PercentType">
                <className>org.openhab.binding.homematic.internal.converter.state.InvertedDoublePercentageConverter</className>
            </converter>
            <converter forType="OpenClosedType">
                <className>org.openhab.binding.homematic.internal.converter.state.InvertedDoubleOpenClosedConverter</className>
            </converter>
            <converter forType="UpDownType">
                <className>org.openhab.binding.homematic.internal.converter.state.InvertedDoubleUpDownConverter</className>
            </converter>
        </parameter>
        <parameter name="STOP">
            <converter forType="OnOffType">
                <className>org.openhab.binding.homematic.internal.converter.state.NegativeBooleanOnOffConverter</className>
            </converter>
        </parameter>
    </channel>
</device>