{
  self,
  ...
}:
{
  imports = [
    ./actual.nix
    ./boot.nix
    ./builder.nix
    ./freshrss.nix
    ./glance.nix
    ./homeassistant.nix
    ./immich.nix
    ./monitoring
    ./mpd.nix
    ./network.nix
    ./nginx.nix
    ./pinchflat.nix
    ./syncthing.nix

    ../../modules/acme-home.nix
    ../../modules/lounge.nix
    ../../modules/unbound.nix
    ../../modules/unbound-auth.nix
    self.nixosModules.nix-defaults

    self.nixosModules.user-rpqt
  ];

  networking.hostName = "genepi";

  time.timeZone = "Europe/Paris";

  services.prometheus.checkConfig = "syntax-only";
  clan.core.vars.generators.garage.files.metrics_token.owner = "prometheus";

  clan.core.settings.state-version.enable = true;
}
