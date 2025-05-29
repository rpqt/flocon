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
    ./topology.nix

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

  disko.devices.disk.main.device = "/dev/disk/by-id/ata-WD_Green_M.2_2280_480GB_2251E6411147";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
