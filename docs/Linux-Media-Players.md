### Linux Media Players

A number of popular Linux media players can be remotely controlled via the D-Bus based Media Player Remote Interfacing Specification (MPRIS). The Perl script below provides some "glue" you can use to control a Linux Media Play (in this case Clementine) from OpenHAB via MQTT. The script needs to run on the same machine as the media player but using MQTT means that OpenHAB can be running somewhere else.
```perl
    #!/usr/bin/perl
 
    use strict;
 
    use 5.010;
    use Net::DBus;
    use Data::Dumper;
    use Net::MQTT::Simple;
 
    my $mqtt = Net::MQTT::Simple->new("my-mqtt-server");
 
    our $service = Net::DBus->session->get_service('org.mpris.MediaPlayer2.clementine');
    our $player = $service->get_object('/Player');
    our $properties = $service->get_object('/TrackList');
    my $playlists = $service->get_object('/org/mpris/MediaPlayer2', 'org.mpris.MediaPlayer2.Playlists');
 
    $playlists->ActivatePlaylist('/org/mpris/MediaPlayer2/Playlists/1');         # Playlist 1 is my radio stations
 
    # Main Loop
 
    $mqtt->run(
        "/Clementine/status" => sub {       # For debugging purposes
            my $status = $properties->GetMetadata();
            print Dumper $status;
        },
        "/Clementine/station" => sub {
            my ($topic, $message) = @_;
            $properties->PlayTrack($message);
        },
        "/Clementine/volume" => sub {
            my $volume = $player->VolumeGet();
            my $newvolume = $volume;
            my ($topic, $message) = @_;
            given ($message) {
                when ("ON")           { $player->Play(); }
                when ("OFF")          { $player->Stop(); }
                when (/\d+$/)          { $newvolume = $message; }
                when ("INCREASE")     { $newvolume += 10; }
                when ("DECREASE")     { $newvolume -= 10; }
            }
            $newvolume = 100 if ($newvolume > 100);
            $newvolume = 0 if ($newvolume < 0);
            if ($volume != $newvolume) {
                $player->VolumeSet($newvolume);
            }
        },
        "/Clementine/#" => sub {            # For debugging purposes
            my ($topic, $message) = @_;
            print "[$topic] $message\n";
        },
    )
```

Sample items:
```
Dimmer Radio    "Radio Volume"      <slider>                (House) {mqtt=">[mosquitto:/Clementine/volume:command:*:${command}]"}
Number Station  "Radio Station"     <music>                 (House) {mqtt=">[mosquitto:/Clementine/station:command:*:${command}]"}
```
