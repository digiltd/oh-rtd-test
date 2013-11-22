## Introduction

For installation of the binding, please see Wiki page [[Bindings]].

## Generic Item Binding Configuration

In order to bind an item to a NTP query, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax for the NTP binding configuration string is explained here:

    nh="[timeZone][:locale]"

where the parts in `[are optional. If no or an incorrect time zone is configured it defaults to `TimeZone.getDefault()`. If no or an incorrect Locale is configured it defaults to `Locale.getDefault()`.

Here are some examples of valid binding configuration strings:

    ntp="Europe/Berlin:de_DE"
    ntp="Europe/Berlin"
    ntp=""


As a result, your lines in the items file might look like the following:
ae437745fef791172e2cba4be47fbb1f

If you like to post the quried time to the knx-bus your line might looke like:
49ab0754c9ad1691acbbc634e4b41a78
where 11.001 is the KNX date type and 10.001 is the KNX time type

## Example configurations

Example configurations can be found [https://code.google.com/p/openhab-samples/wiki/BindingConfig?ts=1370629305&updated=BindingConfig here](]`).