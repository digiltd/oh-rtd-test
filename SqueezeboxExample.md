Below you'll find an example configuration for the squeezebox binding how to select different radio stations.

# openhab.cfg

Here you'll need to configure your players; please make sure that the id's match the name of your logitech configuration. Do not use special characters for the player id.

    ### Squeezebox
    squeeze:server.host     = 192.168.10.59

    squeeze:Bad.id          = 00:04:20:28:65:c7
    squeeze:Bastelzimmer.id = 00:04:20:29:62:0e
    squeeze:Buero.id        = 00:04:20:29:a7:27
    squeeze:Kueche.id       = 00:04:20:28:65:91
    squeeze:Schlafzimmer.id = 00:04:20:2a:37:4b
    squeeze:TV.id           = 00:04:20:23:52:3c
    squeeze:Wohnbereich.id  = 00:04:20:2a:3b:21

    squeeze:language        = de