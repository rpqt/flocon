{ lib, ... }:

{
  imports = [
    ./users.nix
    ./ssh-server.nix
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  system.stateVersion = lib.mkDefault "24.11";

  time.timeZone = lib.mkDefault "Europe/Paris";
}
