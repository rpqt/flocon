{ pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  users.users."rpqt".extraGroups = [ "networkmanager" ];

  environment.systemPackages = [ pkgs.networkmanager-openconnect ];
}
