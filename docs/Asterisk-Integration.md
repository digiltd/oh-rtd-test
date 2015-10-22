### Asterisk

In some cases it is very useful to make call routing decisions in Asterisk based on openHAB Items states. As an example, if nobody is home (away mode is on) route my doorphone calls to mobile, in other case route them to local phones inside the house. To do that AGI (Asterisk application gateway interface) can be used to obtain Item state value into an Asterisk variable and then a routing decision can be performed based on this variable value. Here is a small python script which, when called from Asterisk AGI makes an http request to openHAB REST API, gets specific item state and puts it into specified Asterisk variable:
```sh
    #!/usr/bin/python
    import sys,os,datetime
    import httplib
    import base64
    
    def send(data):
            sys.stdout.write("%s \n"%data)
            sys.stdout.flush()
    
    AGIENV={}
    env = ""
    while(env != "\n"):
            env = sys.stdin.readline()
            envdata =  env.split(":")
            if len(envdata)==2:
                    AGIENV[envdata[0].strip()]=envdata[1].strip()
    
    username = AGIENV['agi_arg_1']
    password = AGIENV['agi_arg_2']
    item = AGIENV['agi_arg_3']
    varname = AGIENV['agi_arg_4']
    
    auth = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
    headers = {"Authorization" : "Basic %s" % auth}
    conn = httplib.HTTPConnection("localhost", 8080)
    conn.request('GET', "/rest/items/%s/state"%item, "", headers)
    response = conn.getresponse()
    item_state = response.read()
    
    send("SET VARIABLE %s %s"%(varname, item_state))
    sys.stdin.readline()
```
In Asterisk dialplan (extensions.conf) this AGI script is used in the following way:

    exten => 1000,1,Answer()
    exten => 1000,n,AGI(openhabitem.agi, "asterisk", "password", "Presence", "atHome")
    exten => 1000,n,GotoIf($["${atHome}" == "ON"]?athome:away)
    exten => 1000,n(athome),Playback(hello-world) ; do whatever you need if Presence is ON
    exten => 1000,n,Hangup()
    exten => 1000,n(away),Playback(beep) ; do whatever you need if Presence is OFF
    exten => 1000,n,Hangup()

In AGI call arguments are:
- the script name itself
- openhab username
- openhab password
- openhab Item name
- Asterisk variable to put state to
