{ inputs, pkgs, ... }:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    pavucontrol
    playerctl
    swaybg
    swaylock
    tofi
    wl-gammarelay-rs
    xwayland-satellite
    inputs.ignis.packages.${pkgs.system}.ignis
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
