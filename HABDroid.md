HABDroid is an open-source Android application providing openHAB user interface on Android platform. It is an integral part of openHAB project.

<img src="http://www.openhab.org/images/ui/android-screens.png">

# Basic information on HABDroid

Please use [openHAB issues](https://github.com/openhab/openhab/issues?state=open) to submit bugs, feature requests and ideas on how to improve HABDroid.

**Connecting to openHAB**

HABDroid uses Bonjour/mDNS service discovery to find openHAB in local network. During startup HABDroid detects the type of active network connection. If WiFi/Ethernet is used for network connection HABDroid tries to discover openHAB.
If HABDroid is unable to discover openHAB on local network, it assumes this is not a home network and uses Remote URL from application settings to connect to openHAB. It goes the same way if mobile network connection is detected. All settings, including username, password and remote URL can be configured through 'Settings' menu which is available at any point by pressing phone 'Menu' button and selecting 'Settings' from popup menu. You can also configure a static URL (openHAB URL) in Settings and openHAB will never try to discover and will connect to this URL during startup. No failover to remote URL is available in this mode.
When you connect to openHAB for the first time HABDroid will ask you to select sitemap from the list of available sitemaps. It will remember your decision and open this sitemap automatically next time you launch the app. You can switch sitemap anytime using 'Select sitemap' from application menu.

**Security**

We strongly recommend to use HTTPS, though HTTP is also available.

If username and password are configured HABDroid will automatically use them for authenticating http requests to openHAB. If openHAB doesn't have any security configured HABDroid will connect to openHAB anyway.

We strongly recommend to switch on user authentication in openHAB when enabling remote connection over the Internet!

**User experience**

HABDroid is currently designed for mobile phones and tablets running Android 4.x.

HABDroid supports all openHAB sitemap widgets.

HABDroid supports using NFC tags for your home automation!
You can write your sitemap page to NFC tag through application menu -> Write NFC tag. The current open sitemap page will be written to the tag. To open the page just touch the tag with your Android device, even if HABDroid is not running.
You can also write an item action to NFC tag. Long press the item on a sitemap page (Switch, Rollershutter and Selection items are currently supported), select an action you would like to be performed with this item when touching the tag, then write the tag. To perform the action just touch the tag with your Android device, even if HABDroid is not running.

HABDroid supports 2 different color themes, HOLO.Dark (which is default black one) and HOLO.Light (the white one). The theme can be set through Settings menu.

HABDroid supports disabling screen timeout timer while HABDroid is running. This is useful for those who use Android device as a wall control panel. This can be set through Settings menu.

**openHAB version support**

HABDroid is compatible with openHAB version starting from 1.0.0.

# Using application

Please install release version of HABDroid from Google Play store:
https://play.google.com/store/apps/details?id=org.openhab.habdroid

You can always find current development build on [openHAB Cloudbees page]
(https://openhab.ci.cloudbees.com/job/HABDroid/)
