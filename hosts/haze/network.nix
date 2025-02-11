{
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  networking.useDHCP = true;

  users.users."rpqt".extraGroups = [ "networkmanager" ];
}
