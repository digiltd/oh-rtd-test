Documentation of the Withings binding Bundle.

# Introduction

The Withings Binding allows to synchronize data from the official Withings API to items. The following body measure types are supported: diastolic blood pressure, fat free mass, fat mass weight, fat ratio, heart pulse, height, systolic blood pressure, weight.

For installation of the binding, please see Wiki page [[Bindings]].

# Setup

To access Withings data the user needs to authenticate via an OAuth 1.0 flow. The binding implements the flow through the command line interface. The first time the binding is started, it prints the following messages to the console:

    #########################################################################################
    # Withings Binding needs authentication.
    # Execute 'withings:startAuthentication' on OSGi console.
    #########################################################################################

In order to start the authentication process the user needs to execute `withings:startAuthentication` on the OSGi console. The binding will print the following lines to the console

    #########################################################################################
    # Withings Binding Setup: 
    # 1. Open URL 'http://<auth-url>//' in your webbrowser
    # 2. Login, choose your user and allow openHAB to access your Withings data
    # 3. Execute 'withings:finishAuthentication "<verifier>" "<user-id>" on OSGi console"
    #########################################################################################

So the user needs to open the shown url in a web browser, login with his withings credentials, confirm that openHAB is allowed to access his data and at the end he is redirected to a page on github. There the user finds the command `withings:finishAuthentication "<verifier>" "<user-id>` with filled parameters that is needed to finish the authentication. 

The binding stores the OAuth tokens, so that the user does not need to login again. From this point the binding is successfully configured.

# Item Binding Configuration

To bind a measure value to an item the measure type has to be defined in the generic binding config. Withings data can be bound to `NumberItem`s only. The syntax for a Withings binding is `withings=<measure type>` The following table shows the measure types and units, that are supported by the binding:

<table>
<tr>
<th>Measure type</th>
<th>Binding Config</th>
<th>Unit</th>
</tr>
<tr><td>Weight</td><td>weight</td><td>kg</td></tr>
<tr><td>Height</td><td>height</td><td>meter</td></tr>
<tr><td>Fat Free Mass</td><td>fat_free_mass</td><td>kg</td></tr>
<tr><td>Fat Ratio</td><td>fat_ratio</td><td>%</td></tr>
<tr><td>Fat Mass Weight</td><td>fat_mass_weight</td><td>kg</td></tr>
<tr><td>Diastolic Blood Pressure</td><td>diastolic_blood_pressure</td><td>mmHg</td></tr>
<tr><td>Systolic Blood Pressure</td><td>systolic_blood_pressure</td><td>mmHg</td></tr>
<tr><td>Heart Pulse</td><td>heart_pulse</td><td>bpm</td></tr>
</table>

The following snippet shows some sample bindings:

    Number Weight     "Weight"     { withings = "weight" }
    Number FatRatio   "FatRatio"   { withings = "fat_ratio" }
    Number HeartPulse "HeartPulse" { withings = "heart_pulse" }

# Synchronization

By default the Withings data is requested every 60 minutes. The interval can be configured in the `openhab.cfg` file. The interval must be specified in ms. The following snippet shows a data refresh interval configuration of 120 minutes:

    withings:refresh=7200000 