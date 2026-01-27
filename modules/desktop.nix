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

  fonts.packages = [
    pkgs.inter
  ];

  programs.firefox = {
    enable = true;
    languagePacks = [ "fr" ];
  };

  programs.thunderbird.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  services.pcscd.enable = true;

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
  };

  # Display manager keyboard layout
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
  };
}
