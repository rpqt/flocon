{
  imports = [
    ./buildbot/flake-module.nix
    ./coredns/flake-module.nix
    ./prometheus/flake-module.nix
  ];

  clan.modules."@rpqt/vaultwarden" = ./vaultwarden.nix;

  clan.modules."@schallerclan/dns" = ./dns.nix;
}
