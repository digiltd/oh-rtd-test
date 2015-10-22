#!/bin/sh

# set variables
webpath=https://openhab.ci.cloudbees.com/job/openHAB/$1/artifact/distribution/target/
version=1.4.0-
dist=-${version}SNAPSHOT

if  [ "$#" -ne 1 ]
 then
  echo "get Snapshot of openhab"
  echo ""
  echo "Usage: `basename $0` {snapshot-number}"
  exit 1
fi

# create path
mkdir /srv/openhab/${version}$1
cd /srv/openhab/${version}$1
mkdir zips

echo "Created Directory /srv/openhab/${version}$1"
echo "let's download openHAB${dist}-$1"

# get snapshot
echo "Get designer"
wget -nv ${webpath}distribution${dist}-designer-win.zip
echo "Got designer"
echo "Get runtime"
wget -nv ${webpath}distribution${dist}-runtime.zip
echo "Got runtime"
echo "Get demo"
wget -nv ${webpath}distribution${dist}-demo.zip
echo "Got demo"
echo "Get addons"
wget -nv ${webpath}distribution${dist}-addons.zip
echo "Got addons"
echo "Get greent"
wget -nv ${webpath}distribution${dist}-greent.zip
echo "Got greent"
mv distribution${dist}* zips

echo "unzipping..."
# unzip to folders
unzip -q zips/distribution${dist}-designer-win.zip -d ide
unzip -q zips/distribution${dist}-runtime.zip -d runtime
unzip -q zips/distribution${dist}-demo.zip -d runtime/demo
unzip -q zips/distribution${dist}-addons.zip -d runtime/addons_inactive
unzip -q zips/distribution${dist}-greent.zip -d runtime/webapps

echo "move addons"
# move all needed addons to activate
mv runtime/addons_inactive/org.openhab.binding.http${dist}.jar  runtime/addons/
mv runtime/addons_inactive/org.openhab.binding.knx${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.binding.mpd${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.binding.networkhealth${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.binding.ntp${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.binding.tcp${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.binding.vdr${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.binding.wol${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.persistence.db4o${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.persistence.gcal${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.persistence.logging${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.persistence.rrd4j${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.persistence.sql*${dist}.jar runtime/addons/
mv runtime/addons_inactive/org.openhab.action.xmpp${dist}.jar runtime/addons/

echo "make links..."
# link configs, images and databases
mv runtime/configurations runtime/configurations_old
mv runtime/etc runtime/etc_old
mv runtime/webapps/images runtime/webapps/images_old

ln -s /srv/openhab/configurations/ runtime/configurations
ln -s /srv/openhab/etc/ runtime/etc
ln -s /srv/openhab/images/ runtime/webapps/images

echo "copy default.cfg and logback.xml"
cp runtime/configurations_old/openhab_default.cfg runtime/configurations
mv runtime/configurations/logback.xml runtime/configurations/logback.xml.old
mv runtime/configurations/logback_debug.xml runtime/configurations/logback_debug.xml.old
cp runtime/configurations_old/logback.xml runtime/configurations/logback.xml
cp runtime/configurations_old/logback_debug.xml runtime/configurations/logback_debug.xml

echo "ready to switch to openHAB${dist}-$1"
