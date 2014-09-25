This Page will show how to setup openHab runtime on a linux or osx server.

In terms of configuration please visit the configuration page(s). 

# Please help placing this page in the correct location.
# It should be a sub page of quick setup. 

### Add openHAB repo to the apt sources list (as root user)
    $ echo "deb http://repository-openhab.forge.cloudbees.com/release/1.5.1/apt-repo/ /" > /etc/apt/sources.list.d/openhab.list

### Install openHAB runtime

    $ sudo apt-get update
    $ sudo apt-get install openhab-runtime

The packages are not signed therefore you will get a warning!

### Install addons
Use *"apt-cache search openhab"* to get a list of all packages. Install the add-ons as you need them using *"apt-get install"*.

    $ sudo apt-cache search openhab
    $ sudo apt-get install openhab-addon-binding-xy

### Start openHAB runtime
    $ sudo /etc/init.d/openhab start
The server will run unprivileged using the account "openhab".
The deb installer adds openHAB to the system startup. 

## Upgrade
Changed configuration files will be retained even on upgrades!

    $ sudo apt-get update
    $ sudo apt-get upgrade

## Snapshot builds
TBD
