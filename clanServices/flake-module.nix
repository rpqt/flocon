{
  imports = [
    ./buildbot/flake-module.nix
    ./glance/flake-module.nix
    ./prometheus/flake-module.nix
  ];

  clan.modules."@rpqt/home-assistant" = ./home-assistant.nix;
  clan.modules."@rpqt/vaultwarden" = ./vaultwarden.nix;
}
