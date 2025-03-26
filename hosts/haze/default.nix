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
    ./discord.nix
    ./disk.nix
    ./firefox.nix
    ./gimp.nix
    ./gnome.nix
    ./hibernate.nix
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
    hyprland.configuration = ./hyprland.nix;
    niri.configuration = ./niri.nix;
    sway.configuration = ./sway.nix;
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
