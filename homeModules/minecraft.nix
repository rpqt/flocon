{ pkgs, ... }:
{
  home.packages = [
    pkgs.hmcl
    pkgs.openjdk21
  ];
}
