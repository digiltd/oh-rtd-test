Examples for accessing REST API

* [jquery](Samples-REST#jquery)
* [cURL](Samples-REST#curl)
* [PHP](Samples-REST#php)
* [Python](Samples-REST#python)

## Introduction

Please see below sample code for accessing openhab's REST API.  

Note that there are three main interfaces:

* **Send Command** - This will send a COMMAND to an item to tell it to take some action (e.g. turn on light).

* **Send Status** - This is to indicate that the status of an item has changed (e.g. window is now open).

* **Get Status** - Gets the current status of an item.  (This can also be used to continuously get updates as shown in the Python section).


### jquery

Accessing REST API via jquery (tested with jquery 2.0 and Chrome v26.0

_Get state of an item:_

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

_Set state of an item:_

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

_Send command to an item:_

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

_Get state of an item:_

    curl http://192.168.100.21:8080/rest/items/MyLight/state

_Set state of an item:_

    curl --header "Content-Type: text/plain" --request PUT --data "OFF" http://192.168.100.21:8080/rest/items/MyLight/state

_Send command to an item:_

    curl --header "Content-Type: text/plain" --request POST --data "ON" http://192.168.100.21:8080/rest/items/MyLight

### PHP

Simple PHP function to post a command to a switch using the REST interface.

_Send command to an item:_

    function sendCommand($item, $data) {
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

    sendCommand("doorbellSwitch", "ON");

If the post was successful the function will return the state you set, EG above returns "ON"

### Python

Python code snippets.  Note that for the request interface, this is set up to continuously receive updates rather than just getting a one time response.  This is done with the "polling header" and the last section decodes the JSON response.

_Send command to an item_

    def post_command(self, key, value):
        """ Post a command to OpenHAB - key is item, value is command """
        url = 'http://%s:%s/rest/items/%s'%(self.openhab_host,
                                    self.openhab_port, key)
        req = requests.post(url, data=value,
                                headers=self.basic_header())
        if req.status_code != requests.codes.ok:
            req.raise_for_status()

_Set state of an item_
       
    def put_status(self, key, value):
        """ Put a status update to OpenHAB  key is item, value is state """
        url = 'http://%s:%s/rest/items/%s/state'%(self.openhab_host,
                                    self.openhab_port, key)
        req = requests.put(url, data=value, headers=self.basic_header())
        if req.status_code != requests.codes.ok:
            req.raise_for_status()     

_Get state updates of an item_

    def get_status(self, name):
        """ Request updates for any item in group NAME from OpenHAB.
         Long-polling will not respond until item updates.
        """
        # When an item in Group NAME changes we will get all items in the group 
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

_HTTP Header definitions_

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
