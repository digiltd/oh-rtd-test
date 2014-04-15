## Hardware

### Controller

The controller "speaks" with the HomeMatic devices through the properiatry wireless protocol of HomeMatic.

#### CCU 1

The best supported hardware so far for HomeMatic is the CCU 1. 

#### CCU 2

The second version (beginning with mid 2013) should work in most circumstances, but is not as widely used as the first version. 
We need testers here: If you own a CCU2, please try out the latest 1.4.0 nightly releases!

#### LAN Adapter

One of the cheaper alternatives is to use the [HomeMatic LAN Adapter](http://www.eq-3.de/produkt-detail-zentralen-und-gateways/items/hm-cfg-lan.html).
The LAN Adapter _**requires**_ the BidCos-Service running and listening on a specific port in your LAN. As of this writing the BidCos-Service is only available for Microsoft Windows. If you want to run the BidCos-Service '_natively_' (through Qemu) on Linux without messing around with [Wine](http://www.winehq.org) follow these step by step instructions.

1. Install QEMU (If you are running OpenHAB on i386/amd64)

    In order to run the BidCos-Service daemon 'rfd' under linux you need to install the QEMU arm emulation. If you are using Debian you have to install at least the package qemu-system-arm.
    ```
    apt-get install qemu
    ```
2. Download the latest CCU 2 firmware from [eQ-3 homepage](http://www.eq-3.de/software.html)
3. Extract the downloaded firmware e.g. HM-CCU2-2.7.8.tar.gz
    ```Shell
    mkdir /tmp/firmware
    tar xvzf HM-CCU2-2.7.8.tar.gz -C /tmp/firmware
    ```

    You should now have three files under the directory /tmp/firmware
    ```Shell
    rootfs.ubi    (<-- this is the firmware inside a UBIFS iamge)
    uImage
    update_script
    ```
4. Create an 256 MiB emulated NAND flash with 2KiB NAND page size
    ```Shell
    modprobe nandsim first_id_byte=0x20 second_id_byte=0xaa third_id_byte=0x00 fourth_id_byte=0x15
    ```

    You should see a newly created MTD device _/dev/mtd0_ (assume that you do not have other MTD devices)
5. Copy the contents of the UBIFS image _rootfs.ubi_ to the emulated MTD device

    ```Shell
    dd if=rootfs.ubi of=/dev/mtd0 bs=2048
    ```
6. Load UBI kernel module and attach the MTD device mtd0

    ```Shell
    modprobe ubi mtd=0,2048
    ```
7. Mount the UBIFS image

    ```Shell
    mkdir /mnt/ubifs
    mount -t ubifs /dev/ubi0_0 /mnt/ubifs
    ```
8. Copy the required files to run the BidCos-Service from the UBIFS image

    ```Shell
    mkdir -p /etc/eq3-rfd /opt/eq3-rfd/bin /opt/eq3-rfd/firmware
    cd /mnt/ubifs
    cp /mnt/ubifs/bin/rfd /opt/eq3-rfd/bin
    cp /mnt/ubifs/etc/config_templates/rfd.conf /etc/eq3-rfd/bidcos.conf
    cp -r /mnt/ubifs/firmware/* /opt/eq3-rfd/firmware/
    ```
    List the dependencies for rfd binary
    ```
    qemu-arm -L /mnt/ubifs /mnt/ubifs/lib/ld-linux.so.3 --list /mnt/ubifs/bin/rfd
    ```
    You should see an output like this
    ```
	libpthread.so.0 => /lib/libpthread.so.0 (0xf67a7000)
	libelvutils.so => /lib/libelvutils.so (0xf6786000)
	libhsscomm.so => /lib/libhsscomm.so (0xf6733000)
	libxmlparser.so => /lib/libxmlparser.so (0xf6725000)
	libXmlRpc.so => /lib/libXmlRpc.so (0xf66fc000)
	libLanDeviceUtils.so => /lib/libLanDeviceUtils.so (0xf66d2000)
	libUnifiedLanComm.so => /lib/libUnifiedLanComm.so (0xf66bf000)
	libstdc++.so.6 => /usr/lib/libstdc++.so.6 (0xf65e8000)
	libm.so.6 => /lib/libm.so.6 (0xf6542000)
	libc.so.6 => /lib/libc.so.6 (0xf63f7000)
	libgcc_s.so.1 => /lib/libgcc_s.so.1 (0xf63ce000)
	/lib/ld-linux.so.3 => /mnt/ubifs/lib/ld-linux.so.3 (0xf6fd7000)
    ```
    Copy all the listed libs from /mnt/ubifs to there respective folder at /opt/eq3-rfd
9. Create a system user and adjust permissions

    ```
    adduser --system --home /opt/eq3-rfd --shell /bin/false --no-create-home --group bidcos
    chown -R bidcos:bidcos /opt/eq3-rfd
    ```
10. Edit and adjust the BidCos-Service configuration bidcos.conf

    ```
    # TCP Port for XmlRpc connections
    Listen Port = 2001
    
    # Log Level: 1=DEBUG, 2=WARNING, 3=INFO, 4=NOTICE, 5=WARNING, 6=ERROR
    Log Level = 3
    
    # If set to 1 the AES keys are stored in a file. Highly recommended.
    Persist Keys = 1
    
    Address File = /etc/eq3-rfd/ids
    Key File = /etc/eq3-rfd/keys
    Device Files Dir = /etc/eq3-rfd/devices

    # These path are relative to QEMU_LD_PREFIX
    Device Description Dir = /firmware/rftypes
    Firmware Dir = /firmware
    Replacemap File = /firmware/rftypes/replaceMap/rfReplaceMap.xml

    # Logging
    Log Destination = File
    Log Filename = /var/log/eq3-rfd/bidcos.log

    [Interface 0]
    Type = Lan Interface
    Serial Number = <HomeMatic ID e.g. JEQ0707164>
    Encryption Key = <your encryption key>
    ```
11. Start the BidCos-Service daemon 'rfd'

    The BidCos-Service daemon 'rfd' can now be started with the following command
    ```
    qemu-arm -L /opt/eq3-rfd /opt/eq3-rfd/bin/rfd -f /etc/eq3-rfd/bidcos.conf
    ```

#### CUL

The other cheaper alternative is the CUL stick. The CUL is an USB stick that can be used as a wireless transceiver. It ca be programmed to be used with a hughe amount of wireless protocols, under which you can find the homemtic protocol as well.
Since the CUL is not natively supported by the binding, you need a program to translate the CUL data to the CCU XML RPC interface: [Homegear](http://www.homegear.eu)

We have reports from users that succesfully use both for their homemtic devices. Apparently security is still not supported.
