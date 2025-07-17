{
  self,
  ...
}:
{
  imports = [
    ./acme.nix
    ./boot.nix
    ./builder.nix
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

    self.inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rpqt = ./home.nix;
    }
  ];

  networking.hostName = "genepi";

  clan.core.settings.state-version.enable = true;

  disko.devices.disk.main.device = "/dev/disk/by-id/ata-WD_Green_M.2_2280_480GB_2251E6411147";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
