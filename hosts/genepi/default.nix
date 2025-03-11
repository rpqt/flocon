{
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.agenix.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    ./acme.nix
    ./backup.nix
    ./boot.nix
    ./builder.nix
    ./disk.nix
    ./dns.nix
    ./freshrss.nix
    ./hardware.nix
    ./immich.nix
    ./monitoring
    ./mpd.nix
    ./network.nix
    ./nginx.nix
    ./persistence.nix
    ./syncthing.nix
    ./taskchampion.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rpqt = ./home.nix;
    }
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
