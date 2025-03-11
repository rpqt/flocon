{ config, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/rpqt/Media/Music";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "Pulse Audio"
      }
    '';

    network.listenAddress = "any";
  };

  services.pulseaudio.enable = true;

  # Workaround: run PulseAudio system-wide so that the mpd user can access it
  services.pulseaudio.systemWide = true;

  users.users.${config.services.mpd.user}.extraGroups = [ "pulse-access" ];

  users.users.rpqt.homeMode = "755";
}
