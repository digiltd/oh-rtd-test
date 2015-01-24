Examples for accessing REST API

* [jquery](Samples-REST#jquery)
* [cURL](Samples-REST#curl)
* [PHP](Samples-REST#php)
* [Python](Samples-REST#python)

## Introduction

Please see below sample code for accessing openhab's REST API.


### jquery

Accessing REST API via jquery (tested with jquery 2.0 and Chrome v26.0

Read state of an item:

    function getState()
    {
    	var request = $.ajax
    	({
    		type       : "GET",
    		url        : "http://192.168.100.21:8080/rest/items/MyLight/state"
    	});
    
    	request.done( function(data) 
    	{ 
    		console.log( "Success: Status=" + data );
    	});
    
    	request.fail( function(jqXHR, textStatus ) 
    	{ 
    		console.log( "Failure: " + textStatus );
    	});
    }

Set state of an item:

    function setState( txtNewState )
    {
    	var request = $.ajax
    	({
    		type       : "PUT",
    		url        : "http://192.168.100.21:8080/rest/items/MyLight/state",
    		data       : txtNewState, 
    		headers    : { "Content-Type": "text/plain" }
    	});
    
    	request.done( function(data) 
    	{ 
    		console.log( "Success" );
    	});
    
    	request.fail( function(jqXHR, textStatus ) 
    	{ 
    		console.log( "Failure: " + textStatus );
    	});
    }

Send command to an item:

    function sendCommand( txtCommand )
    {
    	var request = $.ajax
    	({
    		type       : "POST",
    		url        : "http://192.168.100.21:8080/rest/items/MyLight",
    		data       : txtCommand,
    		headers    : { 'Content-Type': 'text/plain' }
    	});
    
    	request.done( function(data) 
    	{ 
    		console.log( "Success: Status=" + data );
    	});
    
    	request.fail( function(jqXHR, textStatus ) 
    	{ 
    		console.log( "Failure: " + textStatus );
    	});
    }

### cURL

Accessing REST API via [cURL](http://curl.haxx.se). cURL is useful on shell scripts (Win/Linux/OS X) or e.g. on Automator (OS X).

Get state:

    curl http://192.168.100.21:8080/rest/items/MyLight/state

Set state:

    curl --header "Content-Type: text/plain" --request PUT --data "OFF" http://192.168.100.21:8080/rest/items/MyLight/state

Send command:

    curl --header "Content-Type: text/plain" --request POST --data "ON" http://192.168.100.21:8080/rest/items/MyLight

### PHP

Simple PHP function to set a switch state using the REST interface.

Set state:

    function doPostRequest($item, $data) {
      $url = "http://192.168.1.121:8080/rest/items/" . $item;
    
      $options = array(
        'http' => array(
            'header'  => "Content-type: text/plain\r\n",
            'method'  => 'POST',
            'content' => $data  //http_build_query($data),
        ),
      );
    
      $context  = stream_context_create($options);
      $result = file_get_contents($url, false, $context);
    
      return $result;
    }

Example function use:

    doPostRequest("doorbellSwitch", "ON");

If the post was successful the function will return the state you set, EG above returns "ON"

### Python

Python code snippets for the OpenHAB REST API

    def polling_header(self):
        """ Header for OpenHAB REST request - polling """
        self.auth = base64.encodestring('%s:%s'
                           %(self.username, self.password)
                           ).replace('\n', '')
        return {
            "Authorization" : "Basic %s" % self.cmd.auth,
            "X-Atmosphere-Transport" : "long-polling",
            "X-Atmosphere-tracking-id" : self.atmos_id,
            "X-Atmosphere-Framework" : "1.0",
            "Accept" : "application/json"}

    def basic_header(self):
        """ Header for OpenHAB REST request - standard """
        self.auth = base64.encodestring('%s:%s'
                           %(self.username, self.password)
                           ).replace('\n', '')
        return {
                "Authorization" : "Basic %s" %self.auth,
                "Content-type": "text/plain"}

    def post_command(self, key, value):
        """ Post a command to OpenHAB - key is item, value is command """
        url = 'http://%s:%s/rest/items/%s'%(self.openhab_host,
                                    self.openhab_port, key)
        req = requests.post(url, data=value,
                                headers=self.basic_header())
        if req.status_code != requests.codes.ok:
            req.raise_for_status()
            
    def put_status(self, key, value):
        """ Put a status update to OpenHAB  key is item, value is state """
        url = 'http://%s:%s/rest/items/%s/state'%(self.openhab_host,
                                    self.openhab_port, key)
        req = requests.put(url, data=value, headers=self.basic_header())
        if req.status_code != requests.codes.ok:
            req.raise_for_status()     

    def request_item(self, name):
        """ Request updates for any item in group NAME from OpenHAB.
         Long-polling will not respond until item updates.
        """
        # When an item in Group NAME changes we will get all items in group ROS
        # and need to determine which has changed
        url = 'http://%s:%s/rest/items/%s'%(self.openhab_host,
                                        self.openhab_port, name)
        payload = {'type': 'json'}
        try:
            req = requests.get(url, params=payload,
                                headers=self.polling_header())
            if req.status_code != requests.codes.ok:
                req.raise_for_status()
            # Try to parse JSON response
            # At top level, there is type, name, state, link and members array
            members = req.json()["members"]
            for member in members:
                # Each member has a type, name, state and link
                name = member["name"]
                state = member["state"]
                do_publish = True
                # Pub unless we had key before and it hasn't changed
                if name in self.prev_state_dict:
                    if self.prev_state_dict[name] == state:
                        do_publish = False
                self.prev_state_dict[name] = state
                if do_publish:
                    self.publish(name, state)
