{
  imports = [
    ./buildbot/flake-module.nix
    ./prometheus/flake-module.nix
  ];

  clan.modules."@rpqt/vaultwarden" = ./vaultwarden.nix;
}
