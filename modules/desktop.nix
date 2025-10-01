{ self, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.mpv # video player
    pkgs.amberol # music player
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.passff-host ];
  };

  programs.thunderbird.enable = true;
}
