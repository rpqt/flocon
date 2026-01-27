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

  # services.yubikey-agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

  services.pcscd.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;

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
