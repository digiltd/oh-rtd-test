# openHAB on Ubuntu Snappy

_Ubuntu snappy_ is a package manager for the minimalistic Ubuntu server variant _Ubuntu Core_, previously called _JeOS_. _snappy_ supports transactional updates and rollbacks.
It's designed to run on low power devices and virtual machines.

With _snappy_, you can install so called _snaps_, which can contain Frameworks or Apps, like _openHAB_.

This is all about openHAB 1. For version 2, instructions will be added later.

## Installation

The further steps are tested on an _ODROID C1_. See other [supported hardware](http://www.ubuntu.com/things#try-beaglebone) on _Ubuntu Core_ website.

```bash
ssh ubuntu@<ip-of-your-snappy-core-device>
sudo snappy update && sudo reboot
sudo snappy install openhab
```

**Hint: Currently (March, 2nd 2015), the snappy repo does not contain openHAB. Please follow the _Create the openHAB snap_ instructions to build a snap.**

## Create the openHAB snap

On a development machine, running ubuntu:

```bash
sudo add-apt-repository ppa:snappy-dev/beta
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install snappy-tools git-core
git clone https://github.com/openhab/snappy-openhab.git
cd snappy-openhab
# make changes
snappy build .
ls *.snap # should list one .snap file
snappy-remote --url=ssh://<ip-of-your-snappy-core-device> install ./*.snap
```

The previous steps add the snappy ppa to your repositories, install the snappy tools and clone the install files from _openHAB_. Now you can make changes to the configuration or startup scripts or whatever you want. 

Keep in mind, that AppArmor will prevent you from accessing files or folders, you create on "unusual" paths. Have a look in `meta/openhab.profile`, where the process spawned by calling `openhab/startup.sh` is restricted and see, what "unusual" means. Maybe you have to extend the profile.

The `.snap` file is just an `ar` archive, which you can extract with `ar x *.snap` if you're curious what you have packaged before.

The command `snappy-remove` will install or update the snap on your snappy core host. Depending on the hardware, that step can take some time.

## Debug a snap

If something does not work, then maybe check the following steps:
 - Can you reach your snappy core host from the dev machine? `ping <ip-of-your-snappy-core-device>` should give you an answer.
 - Is there enough disk space? `df -h`
 - Does your snappy core device work as intended? Use a serial console (if available) or call `dmesg` after some minutes of operation and search for CRC errors. Some devices are sensitive for some memory cards. `dmesg | grep -i crc`
 - Delete the snap and recreate it with `snappy build`.
 - Maybe you have any AppArmor violations. Open a second console or ssh session and call `journalctl -f -k`. Then install your snap or, if it is already installed, call `aa-exec -p openhab_openhab_1.x.x -- /apps/openhab/1.x.x/openhab/start.sh` on the other console. Have a look at the output of the first Terminal. A bad example would be something like that: `type=1400 audit(1425307113.805:9): apparmor="DENIED" operation="exec" profile="openhab_openhab_1.6.2" name="/apps/bin/java" pid=1194 comm="start.sh" requested_mask="x" denied_mask="x" fsuid=0 ouid=0`. This was, because startup.sh tried to execute `/apps/bin/java`, which was not allowed by the profile.

**TODO: Add the snappy repo**
