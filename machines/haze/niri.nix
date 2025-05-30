{ inputs, pkgs, ... }:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    pavucontrol
    playerctl
    swaybg
    swaylock
    tail-tray
    tofi
    wl-gammarelay-rs
    xwayland-satellite
    inputs.ignis.packages.${pkgs.system}.ignis
    inputs.matugen.packages.${pkgs.system}.default
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
