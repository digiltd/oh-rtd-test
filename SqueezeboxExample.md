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

# squeeze.items

    /* SqueezeBox */
    Number squeezeSelectedPlayer
    Number squeezeSelectedStation
    Switch squeezePlay

    Switch squeezeBadPower           "Bad" <squeeze> (gPlayerPower, gPlayerPowerOG) { squeeze="Bad:power" }
    Switch squeezeBadPlay            "Bad"                                          { squeeze="Bad:play" }
    Dimmer squeezeBadVolume          "Bad [%.1f %%]" <volume> (gPlayerVolume)       { squeeze="Bad:volume" }

    Switch squeezeBastelzimmerPower  "Gästezimmer" <squeeze> (gPlayerPower, gPlayerPowerOG) { squeeze="Bastelzimmer:power" }
    Switch squeezeBastelzimmerPlay   "Gästezimmer"                                          { squeeze="Bastelzimmer:play" }
    Dimmer squeezeBastelzimmerVolume "Gästezimmer [%.1f %%]" <volume> (gPlayerVolume)       { squeeze="Bastelzimmer:volume" }

    Switch squeezeBueroPower         "Büro" <squeeze> (gPlayerPower, gPlayerPowerOG) { squeeze="Buero:power" }
    Switch squeezeBueroPlay          "Büro"                                          { squeeze="Buero:play" }
    Dimmer squeezeBueroVolume        "Büro [%.1f %%]" <volume> (gPlayerVolume)       { squeeze="Buero:volume" }

    Switch squeezeSchlafzimmerPower  "Schlafzimmer" <squeeze> (gPlayerPower, gPlayerPowerOG) { squeeze="Schlafzimmer:power" }
    Switch squeezeSchlafzimmerPlay   "Schlafzimmer"                                          { squeeze="Schlafzimmer:play" }
    Dimmer squeezeSchlafzimmerVolume "Schlafzimmer [%.1f %%]" <volume> (gPlayerVolume)       { squeeze="Schlafzimmer:volume" }

    Switch squeezeTVPower            "TV" <squeeze> (gPlayerPower, gPlayerPowerEG, gTV) { squeeze="TV:power" }
    Switch squeezeTVPlay             "TV"                                               { squeeze="TV:play" }
    Dimmer squeezeTVVolume           "TV [%.1f %%]" <volume> (gPlayerVolume)            { squeeze="TV:volume" }

    Switch squeezeKuechePower        "Küche" <squeeze> (gPlayerPower, gPlayerPowerEG) { squeeze="Kueche:power" }
    Switch squeezeKuechePlay         "Küche"                                          { squeeze="Kueche:play" }
    Dimmer squeezeKuecheVolume       "Küche [%.1f %%]" <volume> (gPlayerVolume)       { squeeze="Kueche:volume" }

    Switch squeezeWohnbereichPower   "Wohnbereich" <squeeze> (gPlayerPower, gPlayerPowerEG) { squeeze="Wohnbereich:power" }
    Switch squeezeWohnbereichPlay    "Wohnbereich"                                          { squeeze="Wohnbereich:play" }
    Dimmer squeezeWohnbereichVolume  "Wohnbereich [%.1f %%]" <volume> (gPlayerVolume)       { squeeze="Wohnbereich:volume" }
