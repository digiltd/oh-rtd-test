##Background
Many zwave devices communicate of a basic radio protocol which can be intercepted or spoofed.  But ZWave also supports encrypted communications via the Security Command Class which is used for high value use cases such as door locks.  The Security Class provides extra protection to help prevent messages from being intercepted and/or spooofed.

##Warnings
- The Security command classes in openhab are beta, use at your own risk!
- As with all modern crypto, the encryption is only as strong as the key.  Please take some time to generate a random key and do not use all zeros, etc

##Steps to test
