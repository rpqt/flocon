{ pkgs, ... }:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    i3bar-river
    mako
    playerctl
    swaybg
    swaylock
    tofi
    wlsunset
    xwayland-satellite
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
