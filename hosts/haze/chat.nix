{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    beeper
    discord
    element-desktop
  ];
}
