{ pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
    plugins = [
      pkgs.networkmanager-openconnect
      pkgs.networkmanager-openvpn
    ];
  };

  users.users."rpqt".extraGroups = [ "networkmanager" ];
}
