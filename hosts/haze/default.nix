{
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    ./beeper.nix
    ./boot.nix
    ./disk.nix
    ./thunderbird.nix
    ./hardware.nix
    ./network.nix
    ./sway.nix
    ./syncthing.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rpqt = ./home.nix;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];
}
