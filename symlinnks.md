**Use symlinks if you use more than one USB port.** Create or add to existing file (/etc/udev/rules.d/50-usb-serial.rules) a rule like the following:

SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{product}=="RFXrec433", SYMLINK+="USBrfx", GROUP="dialout", MODE="0666" SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK+="USBzwave", GROUP="dialout", MODE="0666"

To get IdVendor, product, and IdProduct, you need type in the following (for USB0, USB1, etc) "sudo udevadm info --attribute-walk --path=/sys/bus/usb-serial/devices/ttyUSB0"

There you can find IdVendor, product, and IdProduct. Replace these IDs in the rule and save the file. Now your stick can be referenced in OpenHab config as "/dev/USBzwave". You will also need to add the property to the Java command line by adding the following (device names delimited by ":" ) to the file /etc/init.d/openhab in the JAVA_ARGS section with your device names substituted.

-Dgnu.io.rxtx.SerialPorts=/dev/USBrfxcom:/dev/USBzwave