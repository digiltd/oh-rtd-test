> :warning: _Note:_ This how-to for Nest integration is superseded by the [[Nest Binding|Nest-Binding]].

This is a sample implementation of a read-only integration of the Nest into Openhab.
Here's the recipe:

1. get a developer account @ https://developer.nest.com/ and create a client registration:

2. Copy the authorization URL and open it in a new browser. Use your Nest login to approve the request. Once approved, you will get a "pincode".

3. I used curl, but there are other tools out there to do an http post. In the "Access Token URL", replace the "AUTHORIZATION_CODE" with the pincode from step 2.

4. `curl --data 'code=AUTH_CODE&client_id=CLIENT_ID&client_secret=CLIENT_SECRET&grant_type=authorization_code' https://api.home.nest.com/oauth2/access_token`

    `{"access_token":"[big long random string]","expires_in":315360000}`
5. We're done! The above access_token will give you access to the api for the next 10 years :-)

6. To test, open the following url in your browser: https://developer-api.nest.com/devices/thermostats?auth=[big long random string from step 4]

7. A json structure should be returned with all your devices. Get the "device_id" for your thermostat.

now in the openHAB world:


**Items**:

Number curNestTemp   "Nest [%.1f F]"  <temperature> (Weather_Chart,gFF) { http="<[nest:60000:JS(GetNestValue.js)]"}

Number curNestTargetTemp   "Nest Target [%.1f F]"  <temperature> (Weather_Chart,gFF) { http="<[nest:60000:JS(GetNestTargetValue.js)]"}


**openhab.cfg:**

############################### HTTP Binding ##########################################

`http:nest.url=https://developer-api.nest.com/devices/thermostats/[DEVICE_ID from step 7]?auth=[big long random string from step 5]`

`http:nest.updateInterval=60000`

GetNestValue.js:

`JSON.parse(input).ambient_temperature_f;`

GetNestTargetValue.js:

`JSON.parse(input).target_temperature_f;`


Simple! Now, every minute the current thermostat and target temperatures are refreshed. You can easily read any of the other properties of the thermostat as described here: https://developer.nest.com/documentation/api-reference.

For active control over the thermostat, see this discussion:
[https://groups.google.com/forum/#!topic/openhab/0u1t3xyZlqk](https://groups.google.com/forum/#!topic/openhab/0u1t3xyZlqk)
An implementation might be available soon.