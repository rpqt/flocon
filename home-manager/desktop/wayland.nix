{ pkgs, ... }:
{
  home.packages = with pkgs; [
    waypaper
    wl-clipboard
  ];
}
