Documentation of the Withings binding Bundle.

# Introduction

The Withings Binding allows to synchronize data from the official Withings API to items. The following body measure types are supported: diastolic blood pressure, fat free mass, fat mass weight, fat ratio, heart pulse, height, systolic blood pressure, weight.

# Setup

To access Withings data the user needs to authenticate via an OAuth 1.0 flow. The binding implements the flow through the command line interface. The first the binding is started, it prints the following messages to the console:

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

So the user needs to open the shown url in a web browser, login with his withings credentials, confirm that openHAB is allowed to access his data and at the end he is redirected to a page on github. There the user finds the command that is needed to finish the authentication.