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

  # Fixes the stutter when changing volume (found this randomly)
  services.pulseaudio.daemon.config.flat-volumes = "no";

  users.users.${config.services.mpd.user}.extraGroups = [ "pulse-access" ];

  users.users.rpqt.homeMode = "755";
}
