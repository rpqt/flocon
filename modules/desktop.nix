{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.mpv # video player
    pkgs.amberol # music player
    pkgs.alacritty
    pkgs.ghostty
    pkgs.libreoffice
    pkgs.nautilus
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.passff-host ];
  };

  programs.thunderbird.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };
}
