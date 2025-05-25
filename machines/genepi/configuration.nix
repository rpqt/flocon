{
  inputs,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
    ./acme.nix
    ./boot.nix
    ./builder.nix
    ./dns.nix
    ./freshrss.nix
    ./glance.nix
    ./homeassistant.nix
    # ./immich.nix
    ./monitoring
    ./mpd.nix
    ./network.nix
    ./nginx.nix
    ./syncthing.nix
    ./taskchampion.nix

    ../../system
    ../../modules/borgbackup.nix

    inputs.clan-core.clanModules.state-version
    inputs.clan-core.clanModules.trusted-nix-caches

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rpqt = ./home.nix;
    }
  ];

  networking.hostName = "genepi";
  clan.core.networking.targetHost = "root@genepi.local";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
