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
    ./hyprland.nix
    ./ssh.nix
    ./steam.nix
    ./thunderbird.nix
    ./hardware.nix
    ./network.nix
    ./niri.nix
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
