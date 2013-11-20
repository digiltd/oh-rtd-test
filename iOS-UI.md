# Release Notes of openHAB iOS (iPhone/iPad/iPod) UI

# openHAB iOS UI

The iOS native interface allows the users to have a native iOS app to control openHAB. It is released under two licenses: 
- The GPL licensed code can be found [in the project repository](http://code.google.com/p/openhab/source/browse/?repo=ios).
- a private-copyright licensed binary has been [published to the AppStore](http://itunes.apple.com/us/app/openhab/id492054521?mt=8).

## Features

- All types of widgets are supported, included: Switch, Selection (using mappings), Slider,  List (using mappings,  Text,  Group, Image and Frame.
- Interface languages are: English, Spanish and German.
- Icons are downloaded from the server.
- Images are fully catched and are downloaded just once to save bandwidth, specially in mobile environments.
- The refresh rate is selectable at the configuration screen.
- The maximum number of connections are selectable at the configuration screen. In local environments,  more connections will result in faster updates. On remote, less connections will result in better bandwidth  management.

## Known Limitations/Bugs

- MJPEG: It is not possible to show a MJPEG movie, just images.
- SLIDERS: Icons are not updated until the slider is released.
- SECURITY: Security is not yet implemented

## Screenshots

http://wiki.openhab.googlecode.com/hg/images/screenshots/iOS_iPad2.png

openHAB UI on iPad


http://wiki.openhab.googlecode.com/hg/images/screenshots/iOS_iPhone.png http://wiki.openhab.googlecode.com/hg/images/screenshots/iOS_iPhone2.png

openHAB UI on iPhone