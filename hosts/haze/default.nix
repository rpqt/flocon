{
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    ./boot.nix
    ./chat.nix
    ./disk.nix
    ./firefox.nix
    ./gimp.nix
    ./gnome.nix
    ./hibernate.nix
    ./niri.nix
    ./ssh.nix
    ./steam.nix
    ./thunderbird.nix
    ./hardware.nix
    ./network.nix
    ./syncthing.nix
    ./video.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rpqt = ./home.nix;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];

  specialisation = {
    hyprland.configuration =
      { ... }:
      {
        imports = [ ./hyprland.nix ];
        disabledModules = [ ./niri.nix ];
      };
    sway.configuration =
      { ... }:
      {
        imports = [ ./sway.nix ];
        disabledModules = [ ./niri.nix ];
      };
  };

  # Remote builds
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        sshUser = "nixremote";
        sshKey = "/etc/ssh/ssh_host_ed25519_key";
        systems = [ "aarch64-linux" ];
        hostName = "genepi";
      }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
