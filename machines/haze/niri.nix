{ self, pkgs, ... }:
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
    self.inputs.ignis.packages.${pkgs.system}.ignis
    self.inputs.matugen.packages.${pkgs.system}.default
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
