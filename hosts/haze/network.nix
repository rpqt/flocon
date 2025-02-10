{
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  users.users."rpqt".extraGroups = [ "networkmanager" ];
}
