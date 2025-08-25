{ self, pkgs, ... }:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    pavucontrol
    playerctl
    quickshell
    swaybg
    swaylock
    tofi
    wl-gammarelay-rs
    xwayland-satellite
    self.inputs.matugen.packages.${pkgs.system}.default
  ];

  services.gnome.gnome-keyring.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
