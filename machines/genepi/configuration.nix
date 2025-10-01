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
    ./taskchampion.nix

    ../../modules/acme-home.nix
    ../../modules/lounge.nix
    ../../modules/unbound.nix
    ../../modules/unbound-auth.nix
    ../../system/core
    ../../system/nix

  ];

  networking.hostName = "genepi";

  time.timeZone = "Europe/Paris";

  clan.core.settings.state-version.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
